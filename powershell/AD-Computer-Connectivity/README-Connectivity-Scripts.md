# AD Computer Connectivity Test Scripts

Two PowerShell scripts for testing AD computer connectivity on Windows Server 2008 R2.

## Scripts

### 1. Test-ADComputerConnectivity.ps1 (Full Version)
Full-featured script with ActiveDirectory module support and ADSI fallback.

**Features:**
- Enumerates all computers from Active Directory
- Tracks last AD check-in (lastLogon, lastLogonTimestamp)
- Calculates days since last activity
- Identifies stale/inactive computer accounts
- Tests ping connectivity
- Tests WinRM (Windows Remote Management)
- Tests WMI (Windows Management Instrumentation)
- Tests PSRemoting (PowerShell Remoting)
- Tests RPC (Remote Procedure Call via Registry)
- Exports detailed CSV report with AD activity metrics
- Detailed logging to file
- Progress bar and colored output
- Supports filtering by SearchBase (OU)

**Usage:**
```powershell
# Basic usage - scan all AD computers
.\Test-ADComputerConnectivity.ps1

# Scan specific OU
.\Test-ADComputerConnectivity.ps1 -SearchBase "OU=Servers,DC=domain,DC=com"

# Custom output location
.\Test-ADComputerConnectivity.ps1 -OutputPath "C:\Reports\connectivity-report.csv"

# Custom ping timeout and log path
.\Test-ADComputerConnectivity.ps1 -PingTimeout 5 -LogPath "C:\Logs\connectivity.log"

# Disable logging
.\Test-ADComputerConnectivity.ps1 -NoLog
```

### 2. Test-ADComputerConnectivity-Simple.ps1 (PowerShell 2.0)
Lightweight version optimized for PowerShell 2.0 without dependencies.

**Features:**
- Uses ADSI only (no ActiveDirectory module required)
- Tracks last AD check-in (lastLogon, lastLogonTimestamp)
- Calculates days since last activity
- Identifies stale/inactive computer accounts
- Tests ping, WMI, WinRM, and RPC
- Detailed logging to file
- Smaller and faster
- Guaranteed compatibility with Server 2008 R2

**Usage:**
```powershell
# Basic usage
.\Test-ADComputerConnectivity-Simple.ps1

# Custom output location
.\Test-ADComputerConnectivity-Simple.ps1 -OutputPath "C:\Reports\report.csv"

# Custom log path
.\Test-ADComputerConnectivity-Simple.ps1 -LogPath "C:\Logs\connectivity.log"

# Disable logging
.\Test-ADComputerConnectivity-Simple.ps1 -NoLog
```

## Output Format

Both scripts generate CSV files with the following columns:

| Column | Description |
|--------|-------------|
| ComputerName | NetBIOS name |
| DNSHostName | Fully qualified domain name |
| OperatingSystem | OS version |
| Enabled | AD account status (enabled/disabled) |
| LastLogon | Last logon to this specific DC (not replicated) |
| LastLogonTimestamp | Last logon timestamp (replicated, 9-14 day lag) |
| MostRecentActivity | Most recent activity date from either source |
| DaysSinceLastActivity | Days since last AD activity |
| ActivitySource | Source of activity date (LastLogon/LastLogonTimestamp/Never) |
| PasswordLastSet | When password was last changed |
| WhenCreated | When AD computer account was created |
| PingStatus/Ping | Ping test result (Success/Failed) |
| WinRM | WinRM connectivity (Success/Failed) |
| WMI | WMI connectivity (Success/Failed) |
| PSRemoting | PSRemoting test (full version only) |
| RPC | RPC connectivity (Success/Failed) |
| TestDate | Timestamp of test |

### Understanding AD Activity Fields

**LastLogon vs LastLogonTimestamp:**
- **LastLogon**: Updates immediately but is NOT replicated between domain controllers. Only shows logons to the specific DC you're querying.
- **LastLogonTimestamp**: Replicated across all DCs but has a 9-14 day lag before updating. More reliable for detecting stale accounts.
- **MostRecentActivity**: The script automatically uses whichever is more recent, giving you the best of both values.

**Activity Categories:**
- **Active (0-30 days)**: Computer has checked in recently
- **Stale (30-90 days)**: Computer may be inactive or offline
- **Very Stale (>90 days)**: Likely inactive, candidate for cleanup
- **Never**: Computer account created but never used

## Logging

Both scripts now include detailed logging functionality:

**Log File Contents:**
- Script start/completion timestamps
- Computers enumerated from AD
- Each computer tested with detailed results
- Ping, WinRM, WMI, PSRemoting, and RPC test results
- AD activity information (last check-in dates)
- Summary statistics

**Log Levels:**
- **INFO**: General information
- **SUCCESS**: Successful operations
- **WARNING**: Non-critical issues (e.g., failed connectivity tests)
- **ERROR**: Critical failures

**Default Log Location:** `.\AD-Computer-Connectivity-Log.txt`

**Disable Logging:** Use the `-NoLog` switch to disable file logging (console output remains)

## Requirements

### Server 2008 R2
- PowerShell 2.0 or higher
- Domain member server
- Account with permissions to:
  - Query Active Directory
  - Make network connections to target computers
  - Access remote WMI/RPC services

### Firewall Rules (on target computers)
For successful remote tests, target computers need:
- **ICMP Echo Request** (ping)
- **WinRM**: TCP 5985 (HTTP) and/or 5986 (HTTPS)
- **WMI**: TCP 135 + dynamic RPC ports
- **RPC**: TCP 135 + dynamic ports

## Troubleshooting

### No computers found
- Verify you're running on a domain member server
- Check account has AD read permissions
- For specific OU searches, verify the SearchBase DN is correct

### All remote tests fail but ping succeeds
- Check Windows Firewall on target computers
- Verify remote management is enabled
- Check if Remote Registry service is running (for RPC test)
- For WinRM: Run `winrm quickconfig` on target computers

### Script runs slowly
- Use the simple version for faster results
- Reduce the search scope with -SearchBase parameter
- Filter disabled computer accounts beforehand

## Examples

### Find stale computers (>90 days inactive)
```powershell
.\Test-ADComputerConnectivity.ps1
Import-Csv .\AD-Computer-Connectivity-Report.csv |
    Where-Object {[int]$_.DaysSinceLastActivity -gt 90} |
    Select-Object ComputerName, DNSHostName, DaysSinceLastActivity, MostRecentActivity |
    Export-Csv .\Stale-Computers.csv -NoTypeInformation
```

### Find computers that never checked in
```powershell
Import-Csv .\AD-Computer-Connectivity-Report.csv |
    Where-Object {$_.ActivitySource -eq "Never"} |
    Select-Object ComputerName, DNSHostName, WhenCreated, Enabled
```

### Find all servers that support PSRemoting
```powershell
.\Test-ADComputerConnectivity.ps1
Import-Csv .\AD-Computer-Connectivity-Report.csv | Where-Object {$_.PSRemoting -eq "Success"}
```

### Identify computers with no remote access
```powershell
Import-Csv .\AD-Computer-Connectivity-Report.csv |
    Where-Object {$_.PingStatus -eq "Success" -and $_.WMI -eq "Failed" -and $_.WinRM -eq "Failed"}
```

### Find active computers with failed connectivity
```powershell
# These computers are active in AD but can't be reached
Import-Csv .\AD-Computer-Connectivity-Report.csv |
    Where-Object {[int]$_.DaysSinceLastActivity -lt 30 -and $_.Ping -eq "Failed"} |
    Select-Object ComputerName, DNSHostName, MostRecentActivity, OperatingSystem
```

### Generate cleanup report for disabled and stale computers
```powershell
Import-Csv .\AD-Computer-Connectivity-Report.csv |
    Where-Object {$_.Enabled -eq $false -or [int]$_.DaysSinceLastActivity -gt 180} |
    Select-Object ComputerName, Enabled, DaysSinceLastActivity, MostRecentActivity, WhenCreated |
    Export-Csv .\Cleanup-Candidates.csv -NoTypeInformation
```

### Summary of connectivity by activity age
```powershell
$data = Import-Csv .\AD-Computer-Connectivity-Report.csv

"Active computers (0-30 days):"
$data | Where-Object {[int]$_.DaysSinceLastActivity -le 30} | Measure-Object | Select-Object -ExpandProperty Count

"Stale computers (30-90 days):"
$data | Where-Object {[int]$_.DaysSinceLastActivity -gt 30 -and [int]$_.DaysSinceLastActivity -le 90} | Measure-Object | Select-Object -ExpandProperty Count

"Very stale computers (>90 days):"
$data | Where-Object {[int]$_.DaysSinceLastActivity -gt 90} | Measure-Object | Select-Object -ExpandProperty Count
```

## Performance Notes

- The full version tests 5 different methods per computer
- Average time: 5-10 seconds per computer if ping succeeds
- For 100 computers: expect 10-20 minutes total
- Use `-PingTimeout` to speed up failed ping tests
- The simple version is typically 20-30% faster

## Which Script to Use?

**Use the Full Version if:**
- You have ActiveDirectory PowerShell module
- You need PSRemoting tests
- You need to filter by OU with SearchBase
- You want the most comprehensive testing

**Use the Simple Version if:**
- Running on basic Server 2008 R2 with PowerShell 2.0
- No ActiveDirectory module available
- You want faster results
- You need basic connectivity and AD activity tracking

**Both scripts now provide:**
- AD activity tracking (lastLogon, lastLogonTimestamp)
- Days since last check-in calculation
- Stale computer identification
- Detailed logging
- Comprehensive CSV reports

The main difference is the Full version includes PSRemoting tests and OU filtering, while the Simple version is lighter and faster.
