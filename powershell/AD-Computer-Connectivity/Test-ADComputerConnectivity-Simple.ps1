<#
.SYNOPSIS
    Simplified AD computer connectivity test for PowerShell 2.0 / Server 2008 R2.

.DESCRIPTION
    Lightweight version using ADSI and basic PowerShell 2.0 cmdlets.
    Tests ping, WMI, WinRM, and RPC connectivity.
    Tracks last AD check-in times and activity.

.PARAMETER OutputPath
    Path for the CSV output file. Default: .\AD-Computer-Connectivity-Report.csv

.PARAMETER LogPath
    Path for the detailed log file. Default: .\AD-Computer-Connectivity-Log.txt

.PARAMETER NoLog
    Disable logging to file.

.EXAMPLE
    .\Test-ADComputerConnectivity-Simple.ps1

.EXAMPLE
    .\Test-ADComputerConnectivity-Simple.ps1 -OutputPath "C:\Reports\connectivity.csv"

.EXAMPLE
    .\Test-ADComputerConnectivity-Simple.ps1 -LogPath "C:\Logs\connectivity.log"
#>

param(
    [string]$OutputPath = ".\AD-Computer-Connectivity-Report.csv",
    [string]$LogPath = ".\AD-Computer-Connectivity-Log.txt",
    [switch]$NoLog
)

# Function to write log entries
function Write-Log {
    param(
        [string]$Message,
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
        if ($FileTime.GetType().Name -eq '__ComObject') {
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

Write-Host "`nAD Computer Connectivity Test (PowerShell 2.0 Compatible)" -ForegroundColor Cyan
Write-Host "============================================================`n" -ForegroundColor Cyan

# Initialize log file
if (-not $NoLog) {
    try {
        "========================================" | Out-File -FilePath $LogPath -Force
        "AD Computer Connectivity Test Log (Simple)" | Out-File -FilePath $LogPath -Append
        "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $LogPath -Append
        "========================================`n" | Out-File -FilePath $LogPath -Append
        Write-Host "Logging to: $LogPath`n" -ForegroundColor Cyan
    }
    catch {
        Write-Warning "Failed to initialize log file: $_"
        $NoLog = $true
    }
}

Write-Log "Script started" -Level "INFO"
Write-Log "Output Path: $OutputPath" -Level "INFO"

# Get computers from AD using ADSI
Write-Host "Querying Active Directory..." -ForegroundColor Yellow
Write-Log "Querying Active Directory via ADSI" -Level "INFO"

$searcher = New-Object System.DirectoryServices.DirectorySearcher
$searcher.Filter = "(&(objectCategory=computer))"
$searcher.PropertiesToLoad.AddRange(@("name","dNSHostName","operatingSystem","lastLogon","lastLogonTimestamp","pwdLastSet","userAccountControl","whenCreated"))
$searcher.PageSize = 1000

$results = $searcher.FindAll()
Write-Host "Found $($results.Count) computers`n" -ForegroundColor Green
Write-Log "Found $($results.Count) computers" -Level "SUCCESS"

$report = @()
$counter = 0

foreach ($result in $results) {
    $counter++
    $name = $result.Properties["name"][0]
    $dnsName = if($result.Properties["dNSHostName"].Count -gt 0) { $result.Properties["dNSHostName"][0] } else { $name }
    $os = if($result.Properties["operatingSystem"].Count -gt 0) { $result.Properties["operatingSystem"][0] } else { "Unknown" }

    Write-Host "[$counter/$($results.Count)] Testing: $dnsName" -ForegroundColor Yellow
    Write-Log "Testing computer: $dnsName" -Level "INFO"

    # Get AD activity timestamps
    $lastLogon = if($result.Properties["lastLogon"].Count -gt 0) {
        Convert-FileTimeToDateTime -FileTime $result.Properties["lastLogon"][0]
    } else { $null }

    $lastLogonTimestamp = if($result.Properties["lastLogonTimestamp"].Count -gt 0) {
        Convert-FileTimeToDateTime -FileTime $result.Properties["lastLogonTimestamp"][0]
    } else { $null }

    $pwdLastSet = if($result.Properties["pwdLastSet"].Count -gt 0) {
        Convert-FileTimeToDateTime -FileTime $result.Properties["pwdLastSet"][0]
    } else { $null }

    $whenCreated = if($result.Properties["whenCreated"].Count -gt 0) {
        $result.Properties["whenCreated"][0]
    } else { $null }

    # Determine account status
    $uac = if($result.Properties["userAccountControl"].Count -gt 0) {
        $result.Properties["userAccountControl"][0]
    } else { 0 }
    $enabled = -not ($uac -band 2)

    # Determine most recent activity
    $mostRecentActivity = $null
    $activitySource = "Never"

    if ($lastLogonTimestamp) {
        $mostRecentActivity = $lastLogonTimestamp
        $activitySource = "LastLogonTimestamp"
    }

    if ($lastLogon) {
        if (-not $mostRecentActivity -or $lastLogon -gt $mostRecentActivity) {
            $mostRecentActivity = $lastLogon
            $activitySource = "LastLogon"
        }
    }

    # Calculate days since last activity
    $daysSinceLastActivity = if ($mostRecentActivity) {
        [math]::Round(((Get-Date) - $mostRecentActivity).TotalDays, 1)
    } else {
        $null
    }

    # Log AD activity info
    if ($mostRecentActivity) {
        Write-Log "  Last Activity: $mostRecentActivity ($daysSinceLastActivity days ago, Source: $activitySource)" -Level "INFO"
    } else {
        Write-Log "  Last Activity: Never" -Level "WARNING"
    }

    # Initialize result
    $obj = New-Object PSObject -Property @{
        ComputerName = $name
        DNSHostName = $dnsName
        OperatingSystem = $os
        Enabled = $enabled
        LastLogon = $lastLogon
        LastLogonTimestamp = $lastLogonTimestamp
        MostRecentActivity = $mostRecentActivity
        DaysSinceLastActivity = $daysSinceLastActivity
        ActivitySource = $activitySource
        PasswordLastSet = $pwdLastSet
        WhenCreated = $whenCreated
        Ping = "Failed"
        WMI = "Failed"
        WinRM = "Failed"
        RPC = "Failed"
        TestDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Test Ping
    try {
        if (Test-Connection -ComputerName $dnsName -Count 1 -Quiet) {
            $obj.Ping = "Success"
            Write-Host "  Ping: Success" -ForegroundColor Green
            Write-Log "  Ping: Success" -Level "SUCCESS"

            # Test WMI
            try {
                $wmi = Get-WmiObject Win32_OperatingSystem -ComputerName $dnsName -ErrorAction Stop
                $obj.WMI = "Success"
                Write-Host "  WMI: Success" -ForegroundColor Green
                Write-Log "  WMI: Success" -Level "SUCCESS"
            } catch {
                Write-Host "  WMI: Failed" -ForegroundColor Red
                Write-Log "  WMI: Failed" -Level "WARNING"
            }

            # Test WinRM
            try {
                $winrm = Test-WSMan -ComputerName $dnsName -ErrorAction Stop
                $obj.WinRM = "Success"
                Write-Host "  WinRM: Success" -ForegroundColor Green
                Write-Log "  WinRM: Success" -Level "SUCCESS"
            } catch {
                Write-Host "  WinRM: Failed" -ForegroundColor Red
                Write-Log "  WinRM: Failed" -Level "WARNING"
            }

            # Test RPC (via Remote Registry)
            try {
                $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $dnsName)
                $reg.Close()
                $obj.RPC = "Success"
                Write-Host "  RPC: Success" -ForegroundColor Green
                Write-Log "  RPC: Success" -Level "SUCCESS"
            } catch {
                Write-Host "  RPC: Failed" -ForegroundColor Red
                Write-Log "  RPC: Failed" -Level "WARNING"
            }
        } else {
            Write-Host "  Ping: Failed (skipping remote tests)" -ForegroundColor Red
            Write-Log "  Ping: Failed - skipping remote tests" -Level "ERROR"
        }
    } catch {
        Write-Host "  Ping: Failed (skipping remote tests)" -ForegroundColor Red
        Write-Log "  Ping: Failed - skipping remote tests" -Level "ERROR"
    }

    $report += $obj
}

# Export to CSV
Write-Host "`nExporting to: $OutputPath" -ForegroundColor Cyan
Write-Log "Exporting results to CSV: $OutputPath" -Level "INFO"

$report | Select-Object ComputerName, DNSHostName, OperatingSystem, Enabled, LastLogon, LastLogonTimestamp, `
    MostRecentActivity, DaysSinceLastActivity, ActivitySource, PasswordLastSet, WhenCreated, `
    Ping, WMI, WinRM, RPC, TestDate |
    Export-Csv -Path $OutputPath -NoTypeInformation

Write-Log "CSV export completed" -Level "SUCCESS"

# Calculate summary statistics
$totalComputers = $report.Count
$pingSuccess = ($report | Where-Object {$_.Ping -eq "Success"}).Count
$wmiSuccess = ($report | Where-Object {$_.WMI -eq "Success"}).Count
$winrmSuccess = ($report | Where-Object {$_.WinRM -eq "Success"}).Count
$rpcSuccess = ($report | Where-Object {$_.RPC -eq "Success"}).Count

# Activity statistics
$neverCheckedIn = ($report | Where-Object {$_.ActivitySource -eq "Never"}).Count
$staleComputers90 = ($report | Where-Object {$_.DaysSinceLastActivity -gt 90}).Count
$staleComputers30 = ($report | Where-Object {$_.DaysSinceLastActivity -gt 30 -and $_.DaysSinceLastActivity -le 90}).Count
$activeComputers30 = ($report | Where-Object {$_.DaysSinceLastActivity -le 30}).Count

# Display summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total Computers: $totalComputers" -ForegroundColor White
Write-Host "`nConnectivity:" -ForegroundColor Cyan
Write-Host "  Ping Success: $pingSuccess" -ForegroundColor Green
Write-Host "  WMI Success: $wmiSuccess" -ForegroundColor Green
Write-Host "  WinRM Success: $winrmSuccess" -ForegroundColor Green
Write-Host "  RPC Success: $rpcSuccess" -ForegroundColor Green
Write-Host "`nAD Activity:" -ForegroundColor Cyan
Write-Host "  Active (0-30 days): $activeComputers30" -ForegroundColor Green
Write-Host "  Stale (30-90 days): $staleComputers30" -ForegroundColor Yellow
Write-Host "  Very Stale (>90 days): $staleComputers90" -ForegroundColor Red
Write-Host "  Never Checked In: $neverCheckedIn" -ForegroundColor Red
Write-Host "`nReport saved: $OutputPath" -ForegroundColor Cyan
if (-not $NoLog) {
    Write-Host "Log saved: $LogPath" -ForegroundColor Cyan
}

# Log summary
Write-Log "`n========================================" -Level "INFO"
Write-Log "Summary" -Level "INFO"
Write-Log "========================================" -Level "INFO"
Write-Log "Total Computers: $totalComputers" -Level "INFO"
Write-Log "Ping Success: $pingSuccess" -Level "INFO"
Write-Log "WMI Success: $wmiSuccess" -Level "INFO"
Write-Log "WinRM Success: $winrmSuccess" -Level "INFO"
Write-Log "RPC Success: $rpcSuccess" -Level "INFO"
Write-Log "Active (0-30 days): $activeComputers30" -Level "INFO"
Write-Log "Stale (30-90 days): $staleComputers30" -Level "INFO"
Write-Log "Very Stale (>90 days): $staleComputers90" -Level "INFO"
Write-Log "Never Checked In: $neverCheckedIn" -Level "INFO"
Write-Log "Script completed successfully" -Level "SUCCESS"
