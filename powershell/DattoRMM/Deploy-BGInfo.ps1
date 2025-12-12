<#
.SYNOPSIS
    Deploys BGInfo with custom configuration for display on Windows desktop wallpaper.

.DESCRIPTION
    This Datto RMM component script downloads and configures BGInfo (Sysinternals) to run
    automatically at user logon. It handles both 32-bit and 64-bit Windows architectures,
    includes fallback mechanisms for download failures, and configures registry autorun.

    The script performs the following operations:
    1. Detects OS architecture (32-bit or 64-bit)
    2. Downloads appropriate BGInfo executable from Microsoft
    3. Falls back to local copy if download fails
    4. Deploys custom .bgi configuration file (prefers non-default configs)
    5. Creates registry autorun entry for all users
    6. Executes BGInfo immediately to update wallpaper

.PARAMETER DestinationPath
    Target directory for BGInfo installation. Defaults to C:\MCC\BGInfo

.PARAMETER DownloadTimeout
    Timeout in seconds for web downloads. Defaults to 30 seconds.

.EXAMPLE
    .\Deploy-BGInfo.ps1
    Deploys BGInfo with default settings to C:\MCC\BGInfo

.EXAMPLE
    .\Deploy-BGInfo.ps1 -DestinationPath "C:\Tools\BGInfo" -DownloadTimeout 60
    Deploys BGInfo to custom location with extended timeout

.NOTES
    File Name      : Deploy-BGInfo.ps1
    Version        : 1.1.2
    Author         : Datto RMM Deployment Script
    Prerequisite   : PowerShell 5.1 or higher, Administrator privileges

    Version History:
    1.1.2 - 2025-12-11 - Fixed WMI class invocation - use [wmiclass] instead of Get-WmiObject
    1.1.1 - 2025-12-11 - Fixed WMI/CIM API mixing error in Invoke-BGInfoAsUser function
    1.1.0 - 2025-12-10 - Added multi-user support - BGInfo now executes in all logged-in user sessions
    1.0.1 - 2025-12-10 - Fixed Write-Output pipeline pollution in logging function
    1.0.0 - 2025-12-10 - Initial release

    Exit Codes:
        0   - Success
        1   - Failed to create destination directory
        2   - Failed to obtain BGInfo executable
        3   - Failed to obtain BGInfo configuration file
        4   - Failed to create registry autorun entry
        5   - Failed to execute BGInfo initially

    Datto RMM Considerations:
        - Runs in SYSTEM context
        - Should be deployed as a Quick Job or Component
        - Requires local BGInfo files to be packaged if fallback needed
        - Configuration file (.bgi) should be uploaded with script

.LINK
    https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$DestinationPath = "C:\MCC\BGInfo",

    [Parameter(Mandatory = $false)]
    [ValidateRange(10, 300)]
    [int]$DownloadTimeout = 30
)

#Requires -RunAsAdministrator

#region Initialization and Variables

# Script execution tracking
$ErrorActionPreference = 'Stop'
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogMessages = [System.Collections.ArrayList]::new()
$ExitCode = 0

# BGInfo download URLs (Sysinternals Live)
$BGInfoUrls = @{
    x64 = 'https://live.sysinternals.com/Bginfo64.exe'
    x86 = 'https://live.sysinternals.com/Bginfo.exe'
}

# Registry configuration
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$RegistryValueName = "BGInfo"

#endregion

#region Helper Functions

function Write-LogMessage {
    <#
    .SYNOPSIS
        Writes formatted log messages for Datto RMM consumption.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet('INFO', 'WARNING', 'ERROR', 'SUCCESS')]
        [string]$Level = 'INFO'
    )

    $Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $FormattedMessage = "[$Timestamp] [$Level] $Message"

    # Add to collection for final output
    [void]$LogMessages.Add($FormattedMessage)

    # Write to appropriate stream (avoid Write-Output to prevent pipeline pollution)
    switch ($Level) {
        'ERROR'   { Write-Error $FormattedMessage -ErrorAction Continue }
        'WARNING' { Write-Warning $FormattedMessage }
        'SUCCESS' { Write-Host $FormattedMessage -ForegroundColor Green }
        default   { Write-Verbose $FormattedMessage -Verbose }
    }
}

function Get-OSArchitecture {
    <#
    .SYNOPSIS
        Determines if the operating system is 32-bit or 64-bit.
    .OUTPUTS
        String: 'x64' or 'x86'
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $Architecture = if ([Environment]::Is64BitOperatingSystem) { 'x64' } else { 'x86' }
        Write-LogMessage "Detected OS Architecture: $Architecture" -Level INFO
        return $Architecture
    }
    catch {
        Write-LogMessage "Failed to detect OS architecture, defaulting to x86: $_" -Level WARNING
        return 'x86'
    }
}

function Get-BGInfoExecutable {
    <#
    .SYNOPSIS
        Downloads BGInfo executable or falls back to local copy.
    .OUTPUTS
        String: Path to BGInfo executable, or $null if failed
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Architecture,

        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    $ExeName = if ($Architecture -eq 'x64') { 'Bginfo64.exe' } else { 'Bginfo.exe' }
    $DestFile = Join-Path -Path $Destination -ChildPath 'BGInfo.exe'

    # Attempt download from Sysinternals Live
    $WebClient = $null
    try {
        Write-LogMessage "Attempting to download BGInfo from $($BGInfoUrls[$Architecture])..." -Level INFO

        $WebClient = New-Object System.Net.WebClient
        $WebClient.Headers.Add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)')

        # Create task for timeout handling
        $DownloadTask = $WebClient.DownloadFileTaskAsync($BGInfoUrls[$Architecture], $DestFile)

        if ($DownloadTask.Wait([TimeSpan]::FromSeconds($DownloadTimeout))) {
            if (Test-Path -Path $DestFile) {
                Write-LogMessage "Successfully downloaded BGInfo to $DestFile" -Level SUCCESS
                return $DestFile
            }
        }
        else {
            $DownloadTask.Cancel()
            throw "Download timed out after $DownloadTimeout seconds"
        }
    }
    catch {
        Write-LogMessage "Download failed: $_" -Level WARNING
    }
    finally {
        if ($null -ne $WebClient) {
            $WebClient.Dispose()
        }
    }

    # Fallback: Copy from script directory
    Write-LogMessage "Attempting fallback: Copying from script directory..." -Level INFO

    # Look for architecture-specific file first, then generic
    $PossibleSourceFiles = @(
        (Join-Path -Path $ScriptPath -ChildPath $ExeName),
        (Join-Path -Path $ScriptPath -ChildPath 'BGInfo.exe'),
        (Join-Path -Path $ScriptPath -ChildPath 'Bginfo.exe')
    )

    foreach ($SourceFile in $PossibleSourceFiles) {
        if (Test-Path -Path $SourceFile) {
            try {
                Copy-Item -Path $SourceFile -Destination $DestFile -Force
                Write-LogMessage "Successfully copied BGInfo from $SourceFile to $DestFile" -Level SUCCESS
                return $DestFile
            }
            catch {
                Write-LogMessage "Failed to copy from ${SourceFile}: $_" -Level WARNING
                continue
            }
        }
    }

    Write-LogMessage "Failed to obtain BGInfo executable from any source" -Level ERROR
    return $null
}

function Get-BGInfoConfigFile {
    <#
    .SYNOPSIS
        Locates and deploys BGInfo configuration file (.bgi).
    .OUTPUTS
        String: Path to deployed config file, or $null if failed
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    $DestConfigFile = Join-Path -Path $Destination -ChildPath 'BGInfo.bgi'

    # Find all .bgi files in script directory
    $ConfigFiles = Get-ChildItem -Path $ScriptPath -Filter '*.bgi' -ErrorAction SilentlyContinue

    if ($ConfigFiles.Count -eq 0) {
        Write-LogMessage "No .bgi configuration files found in script directory: $ScriptPath" -Level ERROR
        return $null
    }

    # Prefer non-default.bgi files
    $PreferredConfig = $ConfigFiles | Where-Object { $_.Name -notlike 'default.bgi' } | Select-Object -First 1

    if (-not $PreferredConfig) {
        # Fall back to any .bgi file (including default.bgi)
        $PreferredConfig = $ConfigFiles | Select-Object -First 1
        Write-LogMessage "No non-default .bgi files found, using: $($PreferredConfig.Name)" -Level WARNING
    }
    else {
        Write-LogMessage "Selected preferred configuration file: $($PreferredConfig.Name)" -Level INFO
    }

    try {
        Copy-Item -Path $PreferredConfig.FullName -Destination $DestConfigFile -Force
        Write-LogMessage "Successfully deployed configuration file to $DestConfigFile" -Level SUCCESS
        return $DestConfigFile
    }
    catch {
        Write-LogMessage "Failed to deploy configuration file: $_" -Level ERROR
        return $null
    }
}

function Set-BGInfoAutorun {
    <#
    .SYNOPSIS
        Creates registry entry for BGInfo to run at user logon.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ExecutablePath,

        [Parameter(Mandatory = $true)]
        [string]$ConfigPath
    )

    try {
        # Ensure registry path exists
        if (-not (Test-Path -Path $RegistryPath)) {
            New-Item -Path $RegistryPath -Force | Out-Null
        }

        # Create autorun command (silent execution with config file, no timeout prompt)
        $AutorunCommand = "`"$ExecutablePath`" `"$ConfigPath`" /timer:0 /silent /nolicprompt"

        # Set registry value
        Set-ItemProperty -Path $RegistryPath -Name $RegistryValueName -Value $AutorunCommand -Type String -Force

        Write-LogMessage "Successfully created registry autorun entry: $AutorunCommand" -Level SUCCESS
        return $true
    }
    catch {
        Write-LogMessage "Failed to create registry autorun entry: $_" -Level ERROR
        return $false
    }
}

function Get-LoggedInUsers {
    <#
    .SYNOPSIS
        Gets all currently logged-in users with active sessions.
    .OUTPUTS
        Array of objects containing Username and SessionId
    #>
    [CmdletBinding()]
    param()

    try {
        # Query for logged-in users using quser/query user
        $QuserOutput = quser 2>&1

        if ($LASTEXITCODE -ne 0) {
            Write-LogMessage "No users currently logged in" -Level INFO
            return @()
        }

        $Users = @()
        # Skip header line and parse output
        $QuserOutput | Select-Object -Skip 1 | ForEach-Object {
            $Line = $_ -replace '\s{2,}', ',' # Replace multiple spaces with comma
            $Fields = $Line.Split(',')

            # Handle both disconnected and active sessions
            if ($Fields.Count -ge 3) {
                $SessionId = $null
                if ($Fields[2] -match '^\d+$') {
                    $SessionId = [int]$Fields[2]
                }
                elseif ($Fields.Count -ge 4 -and $Fields[3] -match '^\d+$') {
                    $SessionId = [int]$Fields[3]
                }

                if ($null -ne $SessionId -and $SessionId -gt 0) {
                    $Username = $Fields[0].Trim().TrimStart('>')
                    $Users += [PSCustomObject]@{
                        Username  = $Username
                        SessionId = $SessionId
                    }
                }
            }
        }

        return $Users
    }
    catch {
        Write-LogMessage "Error querying logged-in users: $_" -Level WARNING
        return @()
    }
}

function Invoke-BGInfoAsUser {
    <#
    .SYNOPSIS
        Executes BGInfo in the context of a specific user session.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ExecutablePath,

        [Parameter(Mandatory = $true)]
        [string]$ConfigPath,

        [Parameter(Mandatory = $true)]
        [int]$SessionId,

        [Parameter(Mandatory = $true)]
        [string]$Username
    )

    try {
        Write-LogMessage "Executing BGInfo for user '$Username' in session $SessionId..." -Level INFO

        # Build command line
        $CommandLine = "`"$ExecutablePath`" `"$ConfigPath`" /timer:0 /silent /nolicprompt"

        # Use WMI to create process in user's session
        $ProcessStartup = ([wmiclass]"Win32_ProcessStartup").CreateInstance()
        $ProcessStartup.ShowWindow = 0 # Hidden window

        # Call the static Create method on the Win32_Process class
        $ProcessClass = [wmiclass]"Win32_Process"
        $Result = $ProcessClass.Create($CommandLine, $null, $ProcessStartup)

        if ($Result.ReturnValue -eq 0) {
            Write-LogMessage "BGInfo launched successfully for user '$Username' (PID: $($Result.ProcessId))" -Level SUCCESS
            return $true
        }
        else {
            Write-LogMessage "Failed to launch BGInfo for user '$Username' (Return Code: $($Result.ReturnValue))" -Level WARNING
            return $false
        }
    }
    catch {
        Write-LogMessage "Error executing BGInfo for user '$Username': $_" -Level ERROR
        return $false
    }
}

function Invoke-BGInfoNow {
    <#
    .SYNOPSIS
        Executes BGInfo immediately for all logged-in users.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ExecutablePath,

        [Parameter(Mandatory = $true)]
        [string]$ConfigPath
    )

    try {
        Write-LogMessage "Querying for logged-in users..." -Level INFO
        $LoggedInUsers = Get-LoggedInUsers

        if ($LoggedInUsers.Count -eq 0) {
            Write-LogMessage "No users currently logged in. BGInfo will run at next logon via registry autorun." -Level WARNING
            return $true
        }

        Write-LogMessage "Found $($LoggedInUsers.Count) logged-in user(s)" -Level INFO

        $SuccessCount = 0
        foreach ($User in $LoggedInUsers) {
            $Success = Invoke-BGInfoAsUser -ExecutablePath $ExecutablePath `
                                           -ConfigPath $ConfigPath `
                                           -SessionId $User.SessionId `
                                           -Username $User.Username
            if ($Success) {
                $SuccessCount++
            }
        }

        if ($SuccessCount -gt 0) {
            Write-LogMessage "Successfully executed BGInfo for $SuccessCount of $($LoggedInUsers.Count) user(s)" -Level SUCCESS
            return $true
        }
        else {
            Write-LogMessage "Failed to execute BGInfo for any logged-in users" -Level ERROR
            return $false
        }
    }
    catch {
        Write-LogMessage "Failed to execute BGInfo: $_" -Level ERROR
        return $false
    }
}

#endregion

#region Main Script Logic

try {
    Write-LogMessage "========== BGInfo Deployment Started ==========" -Level INFO
    Write-LogMessage "Script Path: $ScriptPath" -Level INFO
    Write-LogMessage "Destination Path: $DestinationPath" -Level INFO
    Write-LogMessage "PowerShell Version: $($PSVersionTable.PSVersion)" -Level INFO

    # Step 1: Create destination directory
    Write-LogMessage "Step 1: Creating destination directory..." -Level INFO
    try {
        if (-not (Test-Path -Path $DestinationPath)) {
            New-Item -Path $DestinationPath -ItemType Directory -Force | Out-Null
            Write-LogMessage "Created directory: $DestinationPath" -Level SUCCESS
        }
        else {
            Write-LogMessage "Directory already exists: $DestinationPath" -Level INFO
        }
    }
    catch {
        Write-LogMessage "Failed to create destination directory: $_" -Level ERROR
        $ExitCode = 1
        throw
    }

    # Step 2: Detect OS architecture
    Write-LogMessage "Step 2: Detecting OS architecture..." -Level INFO
    $OSArch = Get-OSArchitecture

    # Step 3: Obtain BGInfo executable
    Write-LogMessage "Step 3: Obtaining BGInfo executable..." -Level INFO
    $BGInfoExePath = Get-BGInfoExecutable -Architecture $OSArch -Destination $DestinationPath

    if (-not $BGInfoExePath) {
        Write-LogMessage "Failed to obtain BGInfo executable" -Level ERROR
        $ExitCode = 2
        throw "BGInfo executable not available"
    }

    # Step 4: Obtain BGInfo configuration file
    Write-LogMessage "Step 4: Obtaining BGInfo configuration file..." -Level INFO
    $BGInfoConfigPath = Get-BGInfoConfigFile -Destination $DestinationPath

    if (-not $BGInfoConfigPath) {
        Write-LogMessage "Failed to obtain BGInfo configuration file" -Level ERROR
        $ExitCode = 3
        throw "BGInfo configuration file not available"
    }

    # Step 5: Create registry autorun entry
    Write-LogMessage "Step 5: Creating registry autorun entry..." -Level INFO
    $RegistrySuccess = Set-BGInfoAutorun -ExecutablePath $BGInfoExePath -ConfigPath $BGInfoConfigPath

    if (-not $RegistrySuccess) {
        Write-LogMessage "Failed to create registry autorun entry" -Level ERROR
        $ExitCode = 4
        throw "Registry configuration failed"
    }

    # Step 6: Execute BGInfo immediately
    Write-LogMessage "Step 6: Executing BGInfo immediately..." -Level INFO
    $ExecutionSuccess = Invoke-BGInfoNow -ExecutablePath $BGInfoExePath -ConfigPath $BGInfoConfigPath

    if (-not $ExecutionSuccess) {
        Write-LogMessage "Failed to execute BGInfo" -Level ERROR
        $ExitCode = 5
        throw "BGInfo execution failed"
    }

    # Success!
    Write-LogMessage "========== BGInfo Deployment Completed Successfully ==========" -Level SUCCESS
    $ExitCode = 0
}
catch {
    Write-LogMessage "========== BGInfo Deployment Failed ==========" -Level ERROR
    Write-LogMessage "Error: $($_.Exception.Message)" -Level ERROR
    Write-LogMessage "Stack Trace: $($_.ScriptStackTrace)" -Level ERROR

    # Ensure exit code is set
    if ($ExitCode -eq 0) {
        $ExitCode = 99  # Generic failure
    }
}
finally {
    # Output summary for Datto RMM
    Write-Output "`n========== DEPLOYMENT SUMMARY =========="
    Write-Output "Exit Code: $ExitCode"
    Write-Output "Total Log Entries: $($LogMessages.Count)"
    Write-Output "`n========== DETAILED LOG =========="
    $LogMessages | ForEach-Object { Write-Output $_ }
    Write-Output "======================================`n"

    # Exit with appropriate code for Datto RMM monitoring
    exit $ExitCode
}

#endregion
