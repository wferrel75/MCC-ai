<#
.SYNOPSIS
    Enumerates AD computers and tests connectivity and remote execution methods.

.DESCRIPTION
    This script enumerates computers from Active Directory, tests ping connectivity,
    and tests various remote execution methods (WinRM, WMI, PSRemoting).
    Designed for Windows Server 2008 R2 compatibility.

.PARAMETER SearchBase
    Optional OU Distinguished Name to search. If not specified, searches entire domain.

.PARAMETER OutputPath
    Path for the CSV output file. Default: .\AD-Computer-Connectivity-Report.csv

.PARAMETER PingTimeout
    Timeout in seconds for ping test. Default: 2

.PARAMETER LogPath
    Path for the detailed log file. Default: .\AD-Computer-Connectivity-Log.txt

.PARAMETER NoLog
    Disable logging to file.

.EXAMPLE
    .\Test-ADComputerConnectivity.ps1

.EXAMPLE
    .\Test-ADComputerConnectivity.ps1 -SearchBase "OU=Servers,DC=domain,DC=com" -OutputPath "C:\Reports\connectivity.csv"

.EXAMPLE
    .\Test-ADComputerConnectivity.ps1 -LogPath "C:\Logs\connectivity.log"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$SearchBase,

    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".\AD-Computer-Connectivity-Report.csv",

    [Parameter(Mandatory=$false)]
    [int]$PingTimeout = 2,

    [Parameter(Mandatory=$false)]
    [string]$LogPath = ".\AD-Computer-Connectivity-Log.txt",

    [Parameter(Mandatory=$false)]
    [switch]$NoLog
)

# Function to write log entries
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('INFO','WARNING','ERROR','SUCCESS')]
        [string]$Level = 'INFO'
    )

    if ($NoLog) { return }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    try {
        Add-Content -Path $LogPath -Value $logMessage -ErrorAction Stop
    }
    catch {
        Write-Warning "Failed to write to log file: $_"
    }
}

# Function to convert FileTime to DateTime
function Convert-FileTimeToDateTime {
    param([object]$FileTime)

    if (-not $FileTime -or $FileTime -eq 0) {
        return $null
    }

    try {
        # Handle both integer and COM object types
        if ($FileTime -is [Int64] -or $FileTime -is [Int32]) {
            return [DateTime]::FromFileTime($FileTime)
        }
        elseif ($FileTime.GetType().Name -eq '__ComObject') {
            $highPart = $FileTime.HighPart
            $lowPart = $FileTime.LowPart
            $fileTimeValue = ([Int64]$highPart -shl 32) -bor $lowPart
            if ($fileTimeValue -eq 0) { return $null }
            return [DateTime]::FromFileTime($fileTimeValue)
        }
        else {
            return [DateTime]::FromFileTime([Int64]$FileTime)
        }
    }
    catch {
        return $null
    }
}

# Function to get AD computers (compatible with Server 2008 R2)
function Get-ADComputersCompat {
    param([string]$SearchBase)

    Write-Host "Enumerating computers from Active Directory..." -ForegroundColor Cyan

    # Try to use ActiveDirectory module first
    if (Get-Module -ListAvailable -Name ActiveDirectory) {
        Import-Module ActiveDirectory -ErrorAction SilentlyContinue

        if (Get-Command Get-ADComputer -ErrorAction SilentlyContinue) {
            Write-Host "Using ActiveDirectory module..." -ForegroundColor Green
            Write-Log "Using ActiveDirectory module to enumerate computers" -Level INFO

            $params = @{
                Filter = '*'
                Properties = 'Name','DNSHostName','OperatingSystem','LastLogonDate','lastLogonTimestamp','pwdLastSet','Enabled','whenCreated'
            }

            if ($SearchBase) {
                $params.SearchBase = $SearchBase
                Write-Log "Searching in SearchBase: $SearchBase" -Level INFO
            }

            $computers = Get-ADComputer @params

            return $computers | Select-Object Name, DNSHostName, OperatingSystem, LastLogonDate, lastLogonTimestamp, pwdLastSet, Enabled, whenCreated
        }
    }

    # Fallback to ADSI for Server 2008 R2 without AD module
    Write-Host "Using ADSI fallback method..." -ForegroundColor Yellow
    Write-Log "Using ADSI fallback method to enumerate computers" -Level INFO

    $searcher = New-Object System.DirectoryServices.DirectorySearcher
    $searcher.Filter = "(&(objectCategory=computer))"
    $searcher.PropertiesToLoad.AddRange(@("name","dNSHostName","operatingSystem","lastLogon","lastLogonTimestamp","pwdLastSet","userAccountControl","whenCreated"))
    $searcher.PageSize = 1000

    if ($SearchBase) {
        $searcher.SearchRoot = [ADSI]"LDAP://$SearchBase"
        Write-Log "Searching in SearchBase: $SearchBase" -Level INFO
    }

    $results = $searcher.FindAll()

    $computers = foreach ($result in $results) {
        # Get lastLogon (not replicated, specific to this DC)
        $lastLogon = if($result.Properties["lastLogon"].Count -gt 0) {
            Convert-FileTimeToDateTime -FileTime $result.Properties["lastLogon"][0]
        } else { $null }

        # Get lastLogonTimestamp (replicated across DCs, more reliable but 9-14 day lag)
        $lastLogonTimestamp = if($result.Properties["lastLogonTimestamp"].Count -gt 0) {
            Convert-FileTimeToDateTime -FileTime $result.Properties["lastLogonTimestamp"][0]
        } else { $null }

        # Get pwdLastSet
        $pwdLastSet = if($result.Properties["pwdLastSet"].Count -gt 0) {
            Convert-FileTimeToDateTime -FileTime $result.Properties["pwdLastSet"][0]
        } else { $null }

        # Get whenCreated
        $whenCreated = if($result.Properties["whenCreated"].Count -gt 0) {
            $result.Properties["whenCreated"][0]
        } else { $null }

        # Determine if account is enabled
        $uac = if($result.Properties["userAccountControl"].Count -gt 0) {
            $result.Properties["userAccountControl"][0]
        } else { 0 }
        $enabled = -not ($uac -band 2)  # ADS_UF_ACCOUNTDISABLE = 0x0002

        [PSCustomObject]@{
            Name = $result.Properties["name"][0]
            DNSHostName = if($result.Properties["dNSHostName"].Count -gt 0) { $result.Properties["dNSHostName"][0] } else { $null }
            OperatingSystem = if($result.Properties["operatingSystem"].Count -gt 0) { $result.Properties["operatingSystem"][0] } else { $null }
            LastLogonDate = $lastLogon
            lastLogonTimestamp = $lastLogonTimestamp
            pwdLastSet = $pwdLastSet
            Enabled = $enabled
            whenCreated = $whenCreated
        }
    }

    return $computers
}

# Function to test ping connectivity
function Test-PingConnectivity {
    param(
        [string]$ComputerName,
        [int]$Timeout
    )

    try {
        $ping = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet -ErrorAction Stop
        return $ping
    }
    catch {
        return $false
    }
}

# Function to test WinRM connectivity
function Test-WinRMConnectivity {
    param([string]$ComputerName)

    try {
        $result = Test-WSMan -ComputerName $ComputerName -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Function to test WMI connectivity
function Test-WMIConnectivity {
    param([string]$ComputerName)

    try {
        $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName -ErrorAction Stop -WarningAction SilentlyContinue
        return $true
    }
    catch {
        return $false
    }
}

# Function to test PSRemoting
function Test-PSRemotingConnectivity {
    param([string]$ComputerName)

    try {
        $session = New-PSSession -ComputerName $ComputerName -ErrorAction Stop
        if ($session) {
            Remove-PSSession -Session $session
            return $true
        }
        return $false
    }
    catch {
        return $false
    }
}

# Function to test RPC connectivity
function Test-RPCConnectivity {
    param([string]$ComputerName)

    try {
        # Try to access remote registry as RPC test
        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $ComputerName)
        if ($reg) {
            $reg.Close()
            return $true
        }
        return $false
    }
    catch {
        return $false
    }
}

# Main script execution
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "AD Computer Connectivity Test" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Initialize log file
if (-not $NoLog) {
    try {
        "========================================" | Out-File -FilePath $LogPath -Force
        "AD Computer Connectivity Test Log" | Out-File -FilePath $LogPath -Append
        "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $LogPath -Append
        "========================================`n" | Out-File -FilePath $LogPath -Append
        Write-Host "Logging to: $LogPath" -ForegroundColor Cyan
    }
    catch {
        Write-Warning "Failed to initialize log file: $_"
        $NoLog = $true
    }
}

Write-Log "Script started" -Level INFO
Write-Log "Output Path: $OutputPath" -Level INFO
Write-Log "Ping Timeout: $PingTimeout seconds" -Level INFO

# Get all computers from AD
$computers = Get-ADComputersCompat -SearchBase $SearchBase

if (-not $computers) {
    Write-Host "No computers found in Active Directory." -ForegroundColor Red
    Write-Log "No computers found in Active Directory" -Level ERROR
    exit 1
}

Write-Host "Found $($computers.Count) computers in Active Directory.`n" -ForegroundColor Green
Write-Log "Found $($computers.Count) computers in Active Directory" -Level SUCCESS

# Initialize results array
$results = @()

# Counter for progress
$counter = 0
$total = $computers.Count

foreach ($computer in $computers) {
    $counter++
    $computerName = $computer.DNSHostName

    # Skip if no DNS name
    if (-not $computerName) {
        $computerName = $computer.Name
    }

    Write-Progress -Activity "Testing Computers" -Status "Processing: $computerName" -PercentComplete (($counter / $total) * 100)
    Write-Host "[$counter/$total] Testing: $computerName" -ForegroundColor Yellow
    Write-Log "Testing computer: $computerName" -Level INFO

    # Determine most recent activity date
    $mostRecentActivity = $null
    $activitySource = "Never"

    # Compare lastLogonTimestamp (replicated) and LastLogonDate
    if ($computer.lastLogonTimestamp) {
        $mostRecentActivity = $computer.lastLogonTimestamp
        $activitySource = "LastLogonTimestamp"
    }

    if ($computer.LastLogonDate) {
        if (-not $mostRecentActivity -or $computer.LastLogonDate -gt $mostRecentActivity) {
            $mostRecentActivity = $computer.LastLogonDate
            $activitySource = "LastLogon"
        }
    }

    # Calculate days since last activity
    $daysSinceLastActivity = if ($mostRecentActivity) {
        [math]::Round(((Get-Date) - $mostRecentActivity).TotalDays, 1)
    } else {
        $null
    }

    # Create result object
    $result = [PSCustomObject]@{
        ComputerName = $computer.Name
        DNSHostName = $computer.DNSHostName
        OperatingSystem = $computer.OperatingSystem
        Enabled = $computer.Enabled
        LastLogon = $computer.LastLogonDate
        LastLogonTimestamp = $computer.lastLogonTimestamp
        MostRecentActivity = $mostRecentActivity
        DaysSinceLastActivity = $daysSinceLastActivity
        ActivitySource = $activitySource
        PasswordLastSet = $computer.pwdLastSet
        WhenCreated = $computer.whenCreated
        PingStatus = "Failed"
        WinRM = "Failed"
        WMI = "Failed"
        PSRemoting = "Failed"
        RPC = "Failed"
        TestDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Log AD activity information
    if ($mostRecentActivity) {
        Write-Log "  Last Activity: $mostRecentActivity ($daysSinceLastActivity days ago, Source: $activitySource)" -Level INFO
    } else {
        Write-Log "  Last Activity: Never" -Level WARNING
    }

    # Test Ping
    Write-Host "  Testing Ping..." -NoNewline
    if (Test-PingConnectivity -ComputerName $computerName -Timeout $PingTimeout) {
        $result.PingStatus = "Success"
        Write-Host " Success" -ForegroundColor Green
        Write-Log "  Ping: Success" -Level SUCCESS

        # Only test remote methods if ping succeeds
        Write-Host "  Testing WinRM..." -NoNewline
        if (Test-WinRMConnectivity -ComputerName $computerName) {
            $result.WinRM = "Success"
            Write-Host " Success" -ForegroundColor Green
            Write-Log "  WinRM: Success" -Level SUCCESS
        } else {
            Write-Host " Failed" -ForegroundColor Red
            Write-Log "  WinRM: Failed" -Level WARNING
        }

        Write-Host "  Testing WMI..." -NoNewline
        if (Test-WMIConnectivity -ComputerName $computerName) {
            $result.WMI = "Success"
            Write-Host " Success" -ForegroundColor Green
            Write-Log "  WMI: Success" -Level SUCCESS
        } else {
            Write-Host " Failed" -ForegroundColor Red
            Write-Log "  WMI: Failed" -Level WARNING
        }

        Write-Host "  Testing PSRemoting..." -NoNewline
        if (Test-PSRemotingConnectivity -ComputerName $computerName) {
            $result.PSRemoting = "Success"
            Write-Host " Success" -ForegroundColor Green
            Write-Log "  PSRemoting: Success" -Level SUCCESS
        } else {
            Write-Host " Failed" -ForegroundColor Red
            Write-Log "  PSRemoting: Failed" -Level WARNING
        }

        Write-Host "  Testing RPC..." -NoNewline
        if (Test-RPCConnectivity -ComputerName $computerName) {
            $result.RPC = "Success"
            Write-Host " Success" -ForegroundColor Green
            Write-Log "  RPC: Success" -Level SUCCESS
        } else {
            Write-Host " Failed" -ForegroundColor Red
            Write-Log "  RPC: Failed" -Level WARNING
        }
    } else {
        Write-Host " Failed (skipping remote tests)" -ForegroundColor Red
        Write-Log "  Ping: Failed - skipping remote tests" -Level ERROR
    }

    $results += $result
    Write-Host ""
}

Write-Progress -Activity "Testing Computers" -Completed

# Export to CSV
Write-Host "`nExporting results to: $OutputPath" -ForegroundColor Cyan
Write-Log "Exporting results to CSV: $OutputPath" -Level INFO
$results | Export-Csv -Path $OutputPath -NoTypeInformation -Force
Write-Log "CSV export completed" -Level SUCCESS

# Calculate summary statistics
$totalComputers = $results.Count
$pingSuccess = ($results | Where-Object {$_.PingStatus -eq 'Success'}).Count
$winrmSuccess = ($results | Where-Object {$_.WinRM -eq 'Success'}).Count
$wmiSuccess = ($results | Where-Object {$_.WMI -eq 'Success'}).Count
$psRemotingSuccess = ($results | Where-Object {$_.PSRemoting -eq 'Success'}).Count
$rpcSuccess = ($results | Where-Object {$_.RPC -eq 'Success'}).Count

# Activity statistics
$neverCheckedIn = ($results | Where-Object {$_.ActivitySource -eq 'Never'}).Count
$staleComputers90 = ($results | Where-Object {$_.DaysSinceLastActivity -gt 90}).Count
$staleComputers30 = ($results | Where-Object {$_.DaysSinceLastActivity -gt 30 -and $_.DaysSinceLastActivity -le 90}).Count
$activeComputers30 = ($results | Where-Object {$_.DaysSinceLastActivity -le 30}).Count

# Display summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total Computers: $totalComputers" -ForegroundColor White
Write-Host "`nConnectivity:" -ForegroundColor Cyan
Write-Host "  Ping Success: $pingSuccess" -ForegroundColor Green
Write-Host "  WinRM Success: $winrmSuccess" -ForegroundColor Green
Write-Host "  WMI Success: $wmiSuccess" -ForegroundColor Green
Write-Host "  PSRemoting Success: $psRemotingSuccess" -ForegroundColor Green
Write-Host "  RPC Success: $rpcSuccess" -ForegroundColor Green
Write-Host "`nAD Activity:" -ForegroundColor Cyan
Write-Host "  Active (0-30 days): $activeComputers30" -ForegroundColor Green
Write-Host "  Stale (30-90 days): $staleComputers30" -ForegroundColor Yellow
Write-Host "  Very Stale (>90 days): $staleComputers90" -ForegroundColor Red
Write-Host "  Never Checked In: $neverCheckedIn" -ForegroundColor Red
Write-Host "`nResults saved to: $OutputPath" -ForegroundColor Cyan
if (-not $NoLog) {
    Write-Host "Log saved to: $LogPath" -ForegroundColor Cyan
}

# Log summary
Write-Log "`n========================================" -Level INFO
Write-Log "Summary" -Level INFO
Write-Log "========================================" -Level INFO
Write-Log "Total Computers: $totalComputers" -Level INFO
Write-Log "Ping Success: $pingSuccess" -Level INFO
Write-Log "WinRM Success: $winrmSuccess" -Level INFO
Write-Log "WMI Success: $wmiSuccess" -Level INFO
Write-Log "PSRemoting Success: $psRemotingSuccess" -Level INFO
Write-Log "RPC Success: $rpcSuccess" -Level INFO
Write-Log "Active (0-30 days): $activeComputers30" -Level INFO
Write-Log "Stale (30-90 days): $staleComputers30" -Level INFO
Write-Log "Very Stale (>90 days): $staleComputers90" -Level INFO
Write-Log "Never Checked In: $neverCheckedIn" -Level INFO
Write-Log "Script completed successfully" -Level SUCCESS
