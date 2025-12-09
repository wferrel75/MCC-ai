<#
.SYNOPSIS
    Datto RMM Component - Creates a new Active Directory user and adds them to Domain Admins group.

.DESCRIPTION
    This component creates a new Active Directory user account with specified parameters
    and automatically adds the account to the Domain Admins security group. This is intended
    for use in Datto RMM as a component for domain controller management.

    SECURITY WARNING: This script creates highly privileged accounts. Use with extreme caution.
    - Only run on trusted systems
    - Ensure credentials are securely stored in Datto RMM
    - Enable audit logging for all Domain Admin account creations
    - Follow principle of least privilege - create regular accounts when possible
    - Review and remove unnecessary Domain Admin accounts regularly

.COMPONENT METADATA
    Name: New-DomainAdminAccount
    Category: Active Directory Management
    Execution Context: System (must run on Domain Controller or system with RSAT)
    Timeout: 120 seconds
    Platform: Windows Server (Domain Controller or RSAT-enabled system)

.DATTO RMM VARIABLES
    Configure these as component variables in Datto RMM:
    - Username (String, Required): SAM Account Name for the new user
    - Password (Secure String, Required): Password for the new account
    - FirstName (String, Optional): User's first name
    - LastName (String, Optional): User's last name
    - Description (String, Optional): Account description
    - OUPath (String, Optional): Distinguished Name of target OU (default: CN=Users)

.EXIT CODES
    0  - Success: User created and added to Domain Admins
    1  - General failure or unhandled exception
    10 - Missing required parameters
    11 - Invalid parameter values
    20 - Active Directory module not available
    21 - Not running in domain environment
    30 - User already exists
    31 - Password does not meet complexity requirements
    32 - Failed to create user account
    33 - Failed to add user to Domain Admins group
    34 - Invalid OU path specified

.NOTES
    Author: Datto RMM Component
    Version: 1.0.0
    Last Updated: 2025-12-08

    Requirements:
    - Windows Server with AD DS role OR RSAT tools installed
    - PowerShell 5.1 or higher
    - Active Directory PowerShell module
    - Appropriate permissions to create users and modify group membership
    - Must run as SYSTEM or account with Domain Admin privileges

.EXAMPLE
    Datto RMM Component Variables:
    Username: adm.jdoe
    Password: [Secure credential from Datto vault]
    FirstName: John
    LastName: Doe
    Description: Administrative account for John Doe
    OUPath: OU=AdminUsers,DC=contoso,DC=com
#>

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Username = $env:Username,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Password = $env:Password,

    [Parameter(Mandatory = $false)]
    [string]$FirstName = $env:FirstName,

    [Parameter(Mandatory = $false)]
    [string]$LastName = $env:LastName,

    [Parameter(Mandatory = $false)]
    [string]$Description = $env:Description,

    [Parameter(Mandatory = $false)]
    [string]$OUPath = $env:OUPath
)

#region Functions

function Write-DattoLog {
    <#
    .SYNOPSIS
        Writes formatted output for Datto RMM consumption.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet('INFO', 'SUCCESS', 'WARNING', 'ERROR')]
        [string]$Level = 'INFO'
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $formattedMessage = "[$timestamp] [$Level] $Message"

    # Datto RMM captures Write-Host output
    Write-Host $formattedMessage

    # Also write to appropriate streams for local logging
    switch ($Level) {
        'ERROR'   { Write-Error $Message -ErrorAction SilentlyContinue }
        'WARNING' { Write-Warning $Message }
        default   { Write-Verbose $Message -Verbose }
    }
}

function Test-PasswordComplexity {
    <#
    .SYNOPSIS
        Validates password meets Windows password complexity requirements.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PasswordToTest
    )

    # Windows default password complexity requirements:
    # - At least 6 characters (recommended minimum 8)
    # - Contains characters from at least 3 of these 4 categories:
    #   * Uppercase letters (A-Z)
    #   * Lowercase letters (a-z)
    #   * Digits (0-9)
    #   * Special characters (!@#$%^&*()_+-=[]{}|;:,.<>?)

    if ($PasswordToTest.Length -lt 8) {
        Write-DattoLog -Message "Password is too short. Minimum length is 8 characters." -Level ERROR
        return $false
    }

    $categories = 0

    if ($PasswordToTest -cmatch '[A-Z]') { $categories++ }
    if ($PasswordToTest -cmatch '[a-z]') { $categories++ }
    if ($PasswordToTest -match '[0-9]') { $categories++ }
    if ($PasswordToTest -match '[^a-zA-Z0-9]') { $categories++ }

    if ($categories -lt 3) {
        Write-DattoLog -Message "Password does not meet complexity requirements. Must contain characters from at least 3 categories (uppercase, lowercase, digits, special characters)." -Level ERROR
        return $false
    }

    # Check for common weak passwords (basic check)
    $weakPasswords = @('Password1', 'Password123', 'Admin123', 'Welcome1', 'Passw0rd')
    if ($weakPasswords -contains $PasswordToTest) {
        Write-DattoLog -Message "Password is too common. Please use a stronger password." -Level ERROR
        return $false
    }

    return $true
}

function Test-ADEnvironment {
    <#
    .SYNOPSIS
        Verifies the Active Directory environment and module availability.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    $result = @{
        IsValid = $false
        ModuleAvailable = $false
        IsDomainJoined = $false
        DomainName = $null
        ErrorMessage = $null
    }

    # Check if ActiveDirectory module is available
    Write-DattoLog -Message "Checking for Active Directory PowerShell module..."

    try {
        $adModule = Get-Module -Name ActiveDirectory -ListAvailable -ErrorAction Stop
        if ($adModule) {
            Import-Module ActiveDirectory -ErrorAction Stop
            $result.ModuleAvailable = $true
            Write-DattoLog -Message "Active Directory module loaded successfully." -Level SUCCESS
        }
    }
    catch {
        $result.ErrorMessage = "Active Directory PowerShell module not available. Install RSAT tools or run on a Domain Controller."
        Write-DattoLog -Message $result.ErrorMessage -Level ERROR
        return $result
    }

    # Check if computer is domain-joined
    Write-DattoLog -Message "Verifying domain membership..."

    try {
        $computerSystem = Get-WmiObject -Class Win32_ComputerSystem -ErrorAction Stop

        if ($computerSystem.PartOfDomain) {
            $result.IsDomainJoined = $true
            $result.DomainName = $computerSystem.Domain
            Write-DattoLog -Message "Computer is joined to domain: $($result.DomainName)" -Level SUCCESS
        }
        else {
            $result.ErrorMessage = "Computer is not joined to a domain."
            Write-DattoLog -Message $result.ErrorMessage -Level ERROR
            return $result
        }
    }
    catch {
        $result.ErrorMessage = "Failed to query domain membership: $($_.Exception.Message)"
        Write-DattoLog -Message $result.ErrorMessage -Level ERROR
        return $result
    }

    # Verify we can connect to AD
    try {
        $null = Get-ADDomain -ErrorAction Stop
        $result.IsValid = $true
        Write-DattoLog -Message "Successfully connected to Active Directory." -Level SUCCESS
    }
    catch {
        $result.ErrorMessage = "Cannot connect to Active Directory: $($_.Exception.Message)"
        Write-DattoLog -Message $result.ErrorMessage -Level ERROR
        return $result
    }

    return $result
}

#endregion Functions

#region Main Script

try {
    Write-DattoLog -Message "========================================" -Level INFO
    Write-DattoLog -Message "Starting Domain Admin Account Creation" -Level INFO
    Write-DattoLog -Message "========================================" -Level INFO

    # Security warning
    Write-DattoLog -Message "SECURITY WARNING: Creating Domain Admin account. This operation grants full administrative privileges to the domain." -Level WARNING

    #region Parameter Validation

    Write-DattoLog -Message "Validating input parameters..."

    # Check required parameters
    if ([string]::IsNullOrWhiteSpace($Username)) {
        Write-DattoLog -Message "Username parameter is required." -Level ERROR
        exit 10
    }

    if ([string]::IsNullOrWhiteSpace($Password)) {
        Write-DattoLog -Message "Password parameter is required." -Level ERROR
        exit 10
    }

    # Validate username format (SAM Account Name restrictions)
    if ($Username.Length -gt 20) {
        Write-DattoLog -Message "Username exceeds maximum length of 20 characters." -Level ERROR
        exit 11
    }

    if ($Username -match '["/\\\[\]:;|=,+*?<>]') {
        Write-DattoLog -Message "Username contains invalid characters. Cannot contain: / \ [ ] : ; | = , + * ? < > @" -Level ERROR
        exit 11
    }

    # Validate password complexity
    Write-DattoLog -Message "Validating password complexity..."
    if (-not (Test-PasswordComplexity -PasswordToTest $Password)) {
        Write-DattoLog -Message "Password does not meet complexity requirements." -Level ERROR
        exit 31
    }

    Write-DattoLog -Message "Password complexity validation passed." -Level SUCCESS

    #endregion Parameter Validation

    #region Environment Validation

    $adEnvironment = Test-ADEnvironment

    if (-not $adEnvironment.ModuleAvailable) {
        Write-DattoLog -Message "Active Directory module is not available." -Level ERROR
        exit 20
    }

    if (-not $adEnvironment.IsDomainJoined) {
        Write-DattoLog -Message "System is not joined to a domain." -Level ERROR
        exit 21
    }

    if (-not $adEnvironment.IsValid) {
        Write-DattoLog -Message "Active Directory environment validation failed: $($adEnvironment.ErrorMessage)" -Level ERROR
        exit 21
    }

    #endregion Environment Validation

    #region Get Domain Information

    Write-DattoLog -Message "Retrieving domain information..."

    try {
        $domain = Get-ADDomain -ErrorAction Stop
        $domainDN = $domain.DistinguishedName
        $domainNetBIOS = $domain.NetBIOSName

        Write-DattoLog -Message "Domain: $($domain.DNSRoot)" -Level INFO
        Write-DattoLog -Message "Domain DN: $domainDN" -Level INFO
    }
    catch {
        Write-DattoLog -Message "Failed to retrieve domain information: $($_.Exception.Message)" -Level ERROR
        exit 21
    }

    #endregion Get Domain Information

    #region Determine OU Path

    # Set default OU to Users container if not specified
    if ([string]::IsNullOrWhiteSpace($OUPath)) {
        $OUPath = "CN=Users,$domainDN"
        Write-DattoLog -Message "No OU path specified. Using default: $OUPath" -Level INFO
    }
    else {
        Write-DattoLog -Message "Using specified OU path: $OUPath" -Level INFO

        # Validate OU path exists
        try {
            $null = Get-ADOrganizationalUnit -Identity $OUPath -ErrorAction Stop
            Write-DattoLog -Message "OU path validated successfully." -Level SUCCESS
        }
        catch {
            # Check if it's the Users container (which is a CN, not an OU)
            try {
                $null = Get-ADObject -Identity $OUPath -ErrorAction Stop
                Write-DattoLog -Message "Container path validated successfully." -Level SUCCESS
            }
            catch {
                Write-DattoLog -Message "Invalid OU path specified: $OUPath. Error: $($_.Exception.Message)" -Level ERROR
                exit 34
            }
        }
    }

    #endregion Determine OU Path

    #region Check if User Already Exists

    Write-DattoLog -Message "Checking if user '$Username' already exists..."

    try {
        $existingUser = Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction Stop

        if ($existingUser) {
            Write-DattoLog -Message "User '$Username' already exists in Active Directory." -Level ERROR
            Write-DattoLog -Message "Existing user DN: $($existingUser.DistinguishedName)" -Level ERROR
            exit 30
        }

        Write-DattoLog -Message "User does not exist. Proceeding with creation." -Level SUCCESS
    }
    catch {
        Write-DattoLog -Message "Error checking for existing user: $($_.Exception.Message)" -Level ERROR
        exit 1
    }

    #endregion Check if User Already Exists

    #region Create User Account

    Write-DattoLog -Message "Creating user account: $Username"

    # Convert password to SecureString
    $securePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force

    # Build user parameters
    $userParams = @{
        Name = $Username
        SamAccountName = $Username
        UserPrincipalName = "$Username@$($domain.DNSRoot)"
        AccountPassword = $securePassword
        Path = $OUPath
        Enabled = $true
        ChangePasswordAtLogon = $false  # Domain admin accounts typically don't require password change
        PasswordNeverExpires = $false   # Security best practice: passwords should expire
        ErrorAction = 'Stop'
    }

    # Add optional parameters if provided
    if (-not [string]::IsNullOrWhiteSpace($FirstName)) {
        $userParams['GivenName'] = $FirstName
    }

    if (-not [string]::IsNullOrWhiteSpace($LastName)) {
        $userParams['Surname'] = $LastName
    }

    # Build display name if we have first/last name
    if ($FirstName -and $LastName) {
        $userParams['DisplayName'] = "$FirstName $LastName"
    }
    elseif ($FirstName) {
        $userParams['DisplayName'] = $FirstName
    }
    elseif ($LastName) {
        $userParams['DisplayName'] = $LastName
    }
    else {
        $userParams['DisplayName'] = $Username
    }

    # Set description
    if ([string]::IsNullOrWhiteSpace($Description)) {
        $Description = "Domain Administrator account created via Datto RMM on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }
    $userParams['Description'] = $Description

    try {
        Write-DattoLog -Message "Creating AD user with the following parameters:" -Level INFO
        Write-DattoLog -Message "  SAM Account Name: $($userParams.SamAccountName)" -Level INFO
        Write-DattoLog -Message "  UPN: $($userParams.UserPrincipalName)" -Level INFO
        Write-DattoLog -Message "  Display Name: $($userParams.DisplayName)" -Level INFO
        Write-DattoLog -Message "  OU Path: $($userParams.Path)" -Level INFO
        Write-DattoLog -Message "  Description: $($userParams.Description)" -Level INFO

        New-ADUser @userParams

        Write-DattoLog -Message "User account '$Username' created successfully." -Level SUCCESS
    }
    catch {
        Write-DattoLog -Message "Failed to create user account: $($_.Exception.Message)" -Level ERROR
        Write-DattoLog -Message "Full error: $($_ | Out-String)" -Level ERROR
        exit 32
    }

    # Verify user was created
    try {
        $newUser = Get-ADUser -Identity $Username -ErrorAction Stop
        Write-DattoLog -Message "Verified user creation. DN: $($newUser.DistinguishedName)" -Level SUCCESS
    }
    catch {
        Write-DattoLog -Message "User creation reported success but cannot retrieve user: $($_.Exception.Message)" -Level ERROR
        exit 32
    }

    #endregion Create User Account

    #region Add User to Domain Admins Group

    Write-DattoLog -Message "Adding user '$Username' to Domain Admins group..."

    try {
        # Get Domain Admins group
        $domainAdminsGroup = Get-ADGroup -Filter "Name -eq 'Domain Admins'" -ErrorAction Stop

        if (-not $domainAdminsGroup) {
            Write-DattoLog -Message "Could not find Domain Admins group." -Level ERROR
            exit 33
        }

        Write-DattoLog -Message "Domain Admins group DN: $($domainAdminsGroup.DistinguishedName)" -Level INFO

        # Add user to group
        Add-ADGroupMember -Identity $domainAdminsGroup -Members $newUser -ErrorAction Stop

        Write-DattoLog -Message "User successfully added to Domain Admins group." -Level SUCCESS

        # Verify group membership
        $groupMembership = Get-ADPrincipalGroupMembership -Identity $Username -ErrorAction Stop
        $isDomainAdmin = $groupMembership | Where-Object { $_.Name -eq 'Domain Admins' }

        if ($isDomainAdmin) {
            Write-DattoLog -Message "Verified: User is a member of Domain Admins group." -Level SUCCESS
        }
        else {
            Write-DattoLog -Message "WARNING: Group membership addition reported success but verification failed." -Level WARNING
            exit 33
        }
    }
    catch {
        Write-DattoLog -Message "Failed to add user to Domain Admins group: $($_.Exception.Message)" -Level ERROR
        Write-DattoLog -Message "User account was created but is NOT a Domain Admin. Manual intervention required." -Level ERROR
        exit 33
    }

    #endregion Add User to Domain Admins Group

    #region Final Verification and Summary

    Write-DattoLog -Message "========================================" -Level INFO
    Write-DattoLog -Message "OPERATION COMPLETED SUCCESSFULLY" -Level SUCCESS
    Write-DattoLog -Message "========================================" -Level INFO

    Write-DattoLog -Message "Account Details:" -Level INFO
    Write-DattoLog -Message "  Username: $Username" -Level INFO
    Write-DattoLog -Message "  Display Name: $($newUser.Name)" -Level INFO
    Write-DattoLog -Message "  UPN: $($newUser.UserPrincipalName)" -Level INFO
    Write-DattoLog -Message "  Distinguished Name: $($newUser.DistinguishedName)" -Level INFO
    Write-DattoLog -Message "  Account Enabled: $($newUser.Enabled)" -Level INFO
    Write-DattoLog -Message "  Domain Admin: Yes" -Level INFO

    Write-DattoLog -Message "" -Level INFO
    Write-DattoLog -Message "SECURITY REMINDERS:" -Level WARNING
    Write-DattoLog -Message "  1. Document this account creation in your change management system" -Level WARNING
    Write-DattoLog -Message "  2. Ensure this account is protected with MFA if available" -Level WARNING
    Write-DattoLog -Message "  3. Regularly audit usage of this privileged account" -Level WARNING
    Write-DattoLog -Message "  4. Remove this account when no longer needed" -Level WARNING
    Write-DattoLog -Message "  5. Ensure password is stored securely and not shared" -Level WARNING

    #endregion Final Verification and Summary

    # Exit with success code
    exit 0
}
catch {
    # Catch any unhandled exceptions
    Write-DattoLog -Message "UNHANDLED EXCEPTION OCCURRED" -Level ERROR
    Write-DattoLog -Message "Error: $($_.Exception.Message)" -Level ERROR
    Write-DattoLog -Message "Stack Trace: $($_.ScriptStackTrace)" -Level ERROR
    exit 1
}

#endregion Main Script
