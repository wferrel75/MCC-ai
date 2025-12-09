<#
.SYNOPSIS
    Test harness for the New-DomainAdminAccount Datto RMM component.

.DESCRIPTION
    This script provides comprehensive testing for the New-DomainAdminAccount component.
    It simulates various scenarios including success cases, error conditions, and edge cases
    to ensure the component works correctly before deployment to production.

.NOTES
    Author: Test Script
    Version: 1.0.0
    Last Updated: 2025-12-08

    Requirements:
    - Active Directory test environment
    - Domain Admin or delegated permissions
    - PowerShell 5.1 or higher
    - Active Directory PowerShell module

.PARAMETER TestScenario
    Specific test scenario to run. If not specified, runs all tests.

.PARAMETER CleanupAfterTest
    If set, removes test accounts created during testing.

.EXAMPLE
    .\Test-NewDomainAdminComponent.ps1 -TestScenario All -CleanupAfterTest

    Runs all test scenarios and cleans up test accounts afterwards.

.EXAMPLE
    .\Test-NewDomainAdminComponent.ps1 -TestScenario BasicCreation

    Tests basic user creation scenario only.
#>

#Requires -Version 5.1
#Requires -Modules ActiveDirectory

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet('All', 'BasicCreation', 'CustomOU', 'DuplicateUser', 'WeakPassword',
                 'InvalidOU', 'PasswordComplexity', 'InvalidUsername', 'MissingParameters')]
    [string]$TestScenario = 'All',

    [Parameter(Mandatory = $false)]
    [switch]$CleanupAfterTest
)

#region Test Configuration

$script:TestResults = @()
$script:TestAccountsCreated = @()
$script:ComponentScriptPath = Join-Path $PSScriptRoot "New-DomainAdminAccount.ps1"

# Test user prefix to identify test accounts
$script:TestUserPrefix = "TEST_ADM_"

#endregion Test Configuration

#region Helper Functions

function Write-TestHeader {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host " $Message" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Write-TestResult {
    param(
        [string]$TestName,
        [bool]$Passed,
        [string]$Message,
        [int]$ExpectedExitCode = $null,
        [int]$ActualExitCode = $null
    )

    $result = [PSCustomObject]@{
        TestName = $TestName
        Passed = $Passed
        Message = $Message
        ExpectedExitCode = $ExpectedExitCode
        ActualExitCode = $ActualExitCode
        Timestamp = Get-Date
    }

    $script:TestResults += $result

    if ($Passed) {
        Write-Host "[PASS] $TestName" -ForegroundColor Green
        Write-Host "       $Message" -ForegroundColor Gray
    }
    else {
        Write-Host "[FAIL] $TestName" -ForegroundColor Red
        Write-Host "       $Message" -ForegroundColor Gray
        if ($null -ne $ExpectedExitCode) {
            Write-Host "       Expected Exit Code: $ExpectedExitCode, Got: $ActualExitCode" -ForegroundColor Yellow
        }
    }
}

function Invoke-ComponentTest {
    param(
        [hashtable]$Parameters,
        [int]$ExpectedExitCode = 0
    )

    # Set environment variables to simulate Datto RMM
    $Parameters.GetEnumerator() | ForEach-Object {
        Set-Item -Path "env:$($_.Key)" -Value $_.Value -ErrorAction SilentlyContinue
    }

    try {
        # Execute the component script
        & $script:ComponentScriptPath *>&1 | Out-Null
        $exitCode = $LASTEXITCODE

        # Clean up environment variables
        $Parameters.Keys | ForEach-Object {
            Remove-Item -Path "env:$_" -ErrorAction SilentlyContinue
        }

        return $exitCode
    }
    catch {
        Write-Warning "Exception during component execution: $($_.Exception.Message)"
        return 1
    }
}

function New-RandomPassword {
    param(
        [int]$Length = 16,
        [bool]$MeetComplexity = $true
    )

    if ($MeetComplexity) {
        # Generate complex password
        $uppercase = (65..90) | Get-Random -Count 3 | ForEach-Object { [char]$_ }
        $lowercase = (97..122) | Get-Random -Count 3 | ForEach-Object { [char]$_ }
        $digits = (48..57) | Get-Random -Count 3 | ForEach-Object { [char]$_ }
        $special = ('!@#$%^&*()_+-=[]{}|;:,.<>?'.ToCharArray() | Get-Random -Count 3)

        $allChars = $uppercase + $lowercase + $digits + $special

        # Add random chars to reach desired length
        $remaining = $Length - $allChars.Count
        if ($remaining -gt 0) {
            $allChars += (65..90) + (97..122) + (48..57) | Get-Random -Count $remaining | ForEach-Object { [char]$_ }
        }

        # Shuffle the characters
        $password = ($allChars | Sort-Object { Get-Random }) -join ''
        return $password
    }
    else {
        # Generate simple password (for negative testing)
        return "simple"
    }
}

function Remove-TestAccount {
    param([string]$Username)

    try {
        $user = Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue
        if ($user) {
            Remove-ADUser -Identity $user -Confirm:$false -ErrorAction Stop
            Write-Host "   Cleaned up test account: $Username" -ForegroundColor DarkGray
        }
    }
    catch {
        Write-Warning "Failed to clean up test account $Username: $($_.Exception.Message)"
    }
}

function Test-ComponentAvailable {
    if (-not (Test-Path $script:ComponentScriptPath)) {
        Write-Host "ERROR: Component script not found at: $script:ComponentScriptPath" -ForegroundColor Red
        Write-Host "Please ensure New-DomainAdminAccount.ps1 is in the same directory as this test script." -ForegroundColor Yellow
        return $false
    }
    return $true
}

#endregion Helper Functions

#region Test Scenarios

function Test-BasicCreation {
    Write-TestHeader "Test 1: Basic User Creation"

    $testUser = "$($script:TestUserPrefix)Basic_$(Get-Random -Minimum 1000 -Maximum 9999)"
    $password = New-RandomPassword

    $params = @{
        Username = $testUser
        Password = $password
    }

    $script:TestAccountsCreated += $testUser

    $exitCode = Invoke-ComponentTest -Parameters $params -ExpectedExitCode 0

    if ($exitCode -eq 0) {
        # Verify user was created
        $user = Get-ADUser -Filter "SamAccountName -eq '$testUser'" -ErrorAction SilentlyContinue

        if ($user) {
            # Verify Domain Admins membership
            $groups = Get-ADPrincipalGroupMembership -Identity $testUser
            $isDomainAdmin = $groups | Where-Object { $_.Name -eq 'Domain Admins' }

            if ($isDomainAdmin) {
                Write-TestResult -TestName "Basic Creation" -Passed $true `
                    -Message "User created successfully and added to Domain Admins" `
                    -ExpectedExitCode 0 -ActualExitCode $exitCode
            }
            else {
                Write-TestResult -TestName "Basic Creation" -Passed $false `
                    -Message "User created but NOT in Domain Admins group" `
                    -ExpectedExitCode 0 -ActualExitCode $exitCode
            }
        }
        else {
            Write-TestResult -TestName "Basic Creation" -Passed $false `
                -Message "Exit code was 0 but user was not created" `
                -ExpectedExitCode 0 -ActualExitCode $exitCode
        }
    }
    else {
        Write-TestResult -TestName "Basic Creation" -Passed $false `
            -Message "Component returned unexpected exit code" `
            -ExpectedExitCode 0 -ActualExitCode $exitCode
    }
}

function Test-CustomOU {
    Write-TestHeader "Test 2: Custom OU Path"

    # Get domain DN
    $domain = Get-ADDomain
    $domainDN = $domain.DistinguishedName

    # Use default Users container (exists in all domains)
    $ouPath = "CN=Users,$domainDN"

    $testUser = "$($script:TestUserPrefix)CustomOU_$(Get-Random -Minimum 1000 -Maximum 9999)"
    $password = New-RandomPassword

    $params = @{
        Username = $testUser
        Password = $password
        OUPath = $ouPath
        FirstName = "Test"
        LastName = "CustomOU"
        Description = "Test account with custom OU"
    }

    $script:TestAccountsCreated += $testUser

    $exitCode = Invoke-ComponentTest -Parameters $params -ExpectedExitCode 0

    if ($exitCode -eq 0) {
        $user = Get-ADUser -Filter "SamAccountName -eq '$testUser'" -ErrorAction SilentlyContinue

        if ($user -and $user.DistinguishedName -like "*$ouPath") {
            Write-TestResult -TestName "Custom OU Path" -Passed $true `
                -Message "User created in specified OU: $ouPath" `
                -ExpectedExitCode 0 -ActualExitCode $exitCode
        }
        else {
            Write-TestResult -TestName "Custom OU Path" -Passed $false `
                -Message "User not created in specified OU" `
                -ExpectedExitCode 0 -ActualExitCode $exitCode
        }
    }
    else {
        Write-TestResult -TestName "Custom OU Path" -Passed $false `
            -Message "Component returned unexpected exit code" `
            -ExpectedExitCode 0 -ActualExitCode $exitCode
    }
}

function Test-DuplicateUser {
    Write-TestHeader "Test 3: Duplicate User Detection"

    $testUser = "$($script:TestUserPrefix)Duplicate_$(Get-Random -Minimum 1000 -Maximum 9999)"
    $password = New-RandomPassword

    # Create user first time
    $params = @{
        Username = $testUser
        Password = $password
    }

    $script:TestAccountsCreated += $testUser

    $exitCode1 = Invoke-ComponentTest -Parameters $params -ExpectedExitCode 0

    if ($exitCode1 -eq 0) {
        # Try to create same user again - should fail with exit code 30
        Start-Sleep -Seconds 2  # Allow AD replication
        $exitCode2 = Invoke-ComponentTest -Parameters $params -ExpectedExitCode 30

        if ($exitCode2 -eq 30) {
            Write-TestResult -TestName "Duplicate User Detection" -Passed $true `
                -Message "Duplicate user correctly detected and prevented" `
                -ExpectedExitCode 30 -ActualExitCode $exitCode2
        }
        else {
            Write-TestResult -TestName "Duplicate User Detection" -Passed $false `
                -Message "Duplicate user not detected properly" `
                -ExpectedExitCode 30 -ActualExitCode $exitCode2
        }
    }
    else {
        Write-TestResult -TestName "Duplicate User Detection" -Passed $false `
            -Message "Initial user creation failed" `
            -ExpectedExitCode 0 -ActualExitCode $exitCode1
    }
}

function Test-WeakPassword {
    Write-TestHeader "Test 4: Weak Password Detection"

    $testUser = "$($script:TestUserPrefix)WeakPwd_$(Get-Random -Minimum 1000 -Maximum 9999)"

    # Test with common weak password
    $params = @{
        Username = $testUser
        Password = "Password1"  # Common weak password
    }

    $exitCode = Invoke-ComponentTest -Parameters $params -ExpectedExitCode 31

    if ($exitCode -eq 31) {
        Write-TestResult -TestName "Weak Password Detection" -Passed $true `
            -Message "Weak password correctly detected and rejected" `
            -ExpectedExitCode 31 -ActualExitCode $exitCode
    }
    else {
        Write-TestResult -TestName "Weak Password Detection" -Passed $false `
            -Message "Weak password not detected" `
            -ExpectedExitCode 31 -ActualExitCode $exitCode

        # Clean up if user was created
        if ($exitCode -eq 0) {
            $script:TestAccountsCreated += $testUser
        }
    }
}

function Test-InvalidOU {
    Write-TestHeader "Test 5: Invalid OU Path Detection"

    $testUser = "$($script:TestUserPrefix)InvalidOU_$(Get-Random -Minimum 1000 -Maximum 9999)"
    $password = New-RandomPassword

    # Use non-existent OU
    $params = @{
        Username = $testUser
        Password = $password
        OUPath = "OU=ThisDoesNotExist,DC=fake,DC=domain"
    }

    $exitCode = Invoke-ComponentTest -Parameters $params -ExpectedExitCode 34

    if ($exitCode -eq 34) {
        Write-TestResult -TestName "Invalid OU Path Detection" -Passed $true `
            -Message "Invalid OU path correctly detected" `
            -ExpectedExitCode 34 -ActualExitCode $exitCode
    }
    else {
        Write-TestResult -TestName "Invalid OU Path Detection" -Passed $false `
            -Message "Invalid OU path not detected properly" `
            -ExpectedExitCode 34 -ActualExitCode $exitCode

        # Clean up if user was created
        if ($exitCode -eq 0) {
            $script:TestAccountsCreated += $testUser
        }
    }
}

function Test-PasswordComplexity {
    Write-TestHeader "Test 6: Password Complexity Validation"

    $testCases = @(
        @{ Password = "short"; Expected = 31; Description = "Too short (< 8 chars)" }
        @{ Password = "alllowercase"; Expected = 31; Description = "Only lowercase" }
        @{ Password = "ALLUPPERCASE"; Expected = 31; Description = "Only uppercase" }
        @{ Password = "12345678"; Expected = 31; Description = "Only digits" }
        @{ Password = "NoDigitsOrSpecial"; Expected = 31; Description = "No digits or special chars" }
    )

    $allPassed = $true

    foreach ($testCase in $testCases) {
        $testUser = "$($script:TestUserPrefix)PwdTest_$(Get-Random -Minimum 1000 -Maximum 9999)"

        $params = @{
            Username = $testUser
            Password = $testCase.Password
        }

        $exitCode = Invoke-ComponentTest -Parameters $params -ExpectedExitCode $testCase.Expected

        if ($exitCode -eq $testCase.Expected) {
            Write-Host "  [PASS] $($testCase.Description)" -ForegroundColor Green
        }
        else {
            Write-Host "  [FAIL] $($testCase.Description) - Expected: $($testCase.Expected), Got: $exitCode" -ForegroundColor Red
            $allPassed = $false

            # Clean up if user was created
            if ($exitCode -eq 0) {
                $script:TestAccountsCreated += $testUser
            }
        }
    }

    Write-TestResult -TestName "Password Complexity Validation" -Passed $allPassed `
        -Message "All password complexity tests $(if($allPassed){'passed'}else{'had failures'})"
}

function Test-InvalidUsername {
    Write-TestHeader "Test 7: Invalid Username Detection"

    $testCases = @(
        @{ Username = "user/name"; Expected = 11; Description = "Username with forward slash" }
        @{ Username = "user\name"; Expected = 11; Description = "Username with backslash" }
        @{ Username = "user@domain"; Expected = 11; Description = "Username with @ symbol" }
        @{ Username = "ThisUsernameIsWayTooLongForSAMAccountName"; Expected = 11; Description = "Username > 20 chars" }
    )

    $allPassed = $true

    foreach ($testCase in $testCases) {
        $params = @{
            Username = $testCase.Username
            Password = New-RandomPassword
        }

        $exitCode = Invoke-ComponentTest -Parameters $params -ExpectedExitCode $testCase.Expected

        if ($exitCode -eq $testCase.Expected) {
            Write-Host "  [PASS] $($testCase.Description)" -ForegroundColor Green
        }
        else {
            Write-Host "  [FAIL] $($testCase.Description) - Expected: $($testCase.Expected), Got: $exitCode" -ForegroundColor Red
            $allPassed = $false
        }
    }

    Write-TestResult -TestName "Invalid Username Detection" -Passed $allPassed `
        -Message "All invalid username tests $(if($allPassed){'passed'}else{'had failures'})"
}

function Test-MissingParameters {
    Write-TestHeader "Test 8: Missing Required Parameters"

    # Test missing username
    $params1 = @{
        Password = New-RandomPassword
    }
    $exitCode1 = Invoke-ComponentTest -Parameters $params1 -ExpectedExitCode 10

    # Test missing password
    $params2 = @{
        Username = "$($script:TestUserPrefix)NoPwd"
    }
    $exitCode2 = Invoke-ComponentTest -Parameters $params2 -ExpectedExitCode 10

    $passed = ($exitCode1 -eq 10) -and ($exitCode2 -eq 10)

    if ($passed) {
        Write-TestResult -TestName "Missing Required Parameters" -Passed $true `
            -Message "Missing parameters correctly detected (Username and Password)"
    }
    else {
        Write-TestResult -TestName "Missing Required Parameters" -Passed $false `
            -Message "Missing parameter detection failed. Username exit: $exitCode1, Password exit: $exitCode2"
    }
}

#endregion Test Scenarios

#region Main Test Execution

function Invoke-AllTests {
    Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  New-DomainAdminAccount Component Test Suite              ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

    # Verify prerequisites
    Write-Host "`nVerifying prerequisites..." -ForegroundColor Yellow

    if (-not (Test-ComponentAvailable)) {
        return
    }

    # Check AD module
    if (-not (Get-Module -Name ActiveDirectory -ListAvailable)) {
        Write-Host "ERROR: Active Directory PowerShell module not available" -ForegroundColor Red
        return
    }

    # Check domain connectivity
    try {
        $domain = Get-ADDomain -ErrorAction Stop
        Write-Host "Connected to domain: $($domain.DNSRoot)" -ForegroundColor Green
    }
    catch {
        Write-Host "ERROR: Cannot connect to Active Directory: $($_.Exception.Message)" -ForegroundColor Red
        return
    }

    Write-Host "Prerequisites verified successfully`n" -ForegroundColor Green

    # Run tests based on scenario
    switch ($TestScenario) {
        'All' {
            Test-BasicCreation
            Test-CustomOU
            Test-DuplicateUser
            Test-WeakPassword
            Test-InvalidOU
            Test-PasswordComplexity
            Test-InvalidUsername
            Test-MissingParameters
        }
        'BasicCreation' { Test-BasicCreation }
        'CustomOU' { Test-CustomOU }
        'DuplicateUser' { Test-DuplicateUser }
        'WeakPassword' { Test-WeakPassword }
        'InvalidOU' { Test-InvalidOU }
        'PasswordComplexity' { Test-PasswordComplexity }
        'InvalidUsername' { Test-InvalidUsername }
        'MissingParameters' { Test-MissingParameters }
    }

    # Display summary
    Write-TestHeader "Test Summary"

    $totalTests = $script:TestResults.Count
    $passedTests = ($script:TestResults | Where-Object { $_.Passed }).Count
    $failedTests = $totalTests - $passedTests

    Write-Host "Total Tests: $totalTests" -ForegroundColor White
    Write-Host "Passed: $passedTests" -ForegroundColor Green
    Write-Host "Failed: $failedTests" -ForegroundColor $(if($failedTests -eq 0){'Green'}else{'Red'})
    Write-Host "Success Rate: $([math]::Round(($passedTests/$totalTests)*100, 2))%" -ForegroundColor $(if($failedTests -eq 0){'Green'}else{'Yellow'})

    # Show failed tests
    if ($failedTests -gt 0) {
        Write-Host "`nFailed Tests:" -ForegroundColor Red
        $script:TestResults | Where-Object { -not $_.Passed } | ForEach-Object {
            Write-Host "  - $($_.TestName): $($_.Message)" -ForegroundColor Red
        }
    }

    # Cleanup
    if ($CleanupAfterTest -and $script:TestAccountsCreated.Count -gt 0) {
        Write-Host "`nCleaning up test accounts..." -ForegroundColor Yellow
        foreach ($testAccount in $script:TestAccountsCreated) {
            Remove-TestAccount -Username $testAccount
        }
        Write-Host "Cleanup complete" -ForegroundColor Green
    }
    elseif ($script:TestAccountsCreated.Count -gt 0) {
        Write-Host "`nTest accounts created (not cleaned up):" -ForegroundColor Yellow
        $script:TestAccountsCreated | ForEach-Object {
            Write-Host "  - $_" -ForegroundColor Gray
        }
        Write-Host "`nRun with -CleanupAfterTest to automatically remove test accounts" -ForegroundColor Yellow
    }

    # Export results
    $resultsFile = Join-Path $PSScriptRoot "TestResults_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    $script:TestResults | Export-Csv -Path $resultsFile -NoTypeInformation
    Write-Host "`nDetailed results exported to: $resultsFile" -ForegroundColor Cyan
}

# Execute tests
Invoke-AllTests

#endregion Main Test Execution
