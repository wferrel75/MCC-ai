# Group Policy Deployment Guide: Service Existence Check

## Overview

This guide explains how to deploy the `Check-ServiceExists.ps1` script via Group Policy to monitor for the presence (or absence) of Windows services across your domain computers.

## Use Cases

- **Monitor critical service installation**: Verify that required services (backup agents, security software, monitoring tools) are installed
- **Compliance tracking**: Track which computers are missing specific services
- **Troubleshooting**: Identify systems where services have been uninstalled or never installed
- **Audit logging**: Create audit trail of service presence across infrastructure

## Deployment Methods

### Method 1: Startup Script (Recommended for Quick Checks)

Best for services that should always be present on boot.

**Advantages:**
- Runs automatically on computer startup
- No user interaction required
- Simple to implement

**Disadvantages:**
- Only runs at startup (not on schedule)
- Can slightly delay boot time if checking many services

### Method 2: Scheduled Task via GPO (Recommended for Regular Monitoring)

Best for ongoing monitoring with customizable schedule.

**Advantages:**
- Runs on schedule (hourly, daily, etc.)
- Can run in background without system restart
- More flexible than startup scripts

**Disadvantages:**
- Slightly more complex to configure
- Requires Windows Vista/Server 2008 or newer

---

## Method 1: Deploy as Startup Script

### Prerequisites

1. **Domain Admin** or **Group Policy Management** permissions
2. **SYSVOL access** to store the script
3. **Target computers** must have PowerShell installed (default on Windows 7+/Server 2008 R2+)

### Step 1: Prepare the Script

1. **Copy the script to SYSVOL:**
   ```
   \\domain.com\SYSVOL\domain.com\Policies\{GPO-GUID}\Machine\Scripts\Startup\
   ```

   Or use a centralized scripts folder:
   ```
   \\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1
   ```

2. **Create the log directory** on target computers (or use `-CreateLogDirectory` switch):
   ```powershell
   # Option 1: Pre-create via GPO Preferences
   Computer Configuration > Preferences > Windows Settings > Folders
   Action: Create
   Path: C:\Logs

   # Option 2: Let script create it with -CreateLogDirectory parameter
   ```

### Step 2: Create or Edit Group Policy Object

1. Open **Group Policy Management Console** (gpmc.msc)
2. Navigate to the OU containing target computers
3. Create new GPO or edit existing: Right-click > **Create a GPO in this domain, and Link it here**
4. Name it descriptively: `Service Check - [ServiceName]`

### Step 3: Configure Startup Script

1. Right-click the GPO > **Edit**
2. Navigate to:
   ```
   Computer Configuration
     └─ Policies
         └─ Windows Settings
             └─ Scripts (Startup/Shutdown)
                 └─ Startup
   ```
3. Click **Add** > **Browse**
4. Navigate to your script location or paste UNC path
5. In **Script Parameters** field, enter:
   ```
   -ServiceName "YourServiceName" -CreateLogDirectory
   ```

   **Examples:**
   ```powershell
   # Check for Print Spooler
   -ServiceName "Spooler" -CreateLogDirectory

   # Check for Datto RMM Agent
   -ServiceName "CentraStage" -CreateLogDirectory

   # Check for Windows Defender
   -ServiceName "WinDefend" -CreateLogDirectory

   # Custom log location
   -ServiceName "MyService" -LogPath "C:\ServiceLogs\MyService.log" -CreateLogDirectory
   ```

6. Click **OK** to save

### Step 4: Configure PowerShell Execution Policy (if needed)

If PowerShell scripts are blocked by execution policy:

1. In the same GPO, navigate to:
   ```
   Computer Configuration
     └─ Policies
         └─ Administrative Templates
             └─ Windows Components
                 └─ Windows PowerShell
   ```
2. Enable **Turn on Script Execution**
3. Set to **Allow local scripts and remote signed scripts**

### Step 5: Link and Test

1. **Link GPO** to target OU
2. **Force update** on test computer:
   ```cmd
   gpupdate /force
   ```
3. **Restart** the test computer to trigger startup script
4. **Verify log file** created at `C:\Logs\ServiceCheck.log`

---

## Method 2: Deploy as Scheduled Task

### Step 1: Prepare the Script

Same as Method 1 - copy script to SYSVOL or NETLOGON.

### Step 2: Create Scheduled Task via GPO

1. Open **Group Policy Management Console**
2. Create or edit a GPO
3. Navigate to:
   ```
   Computer Configuration
     └─ Preferences
         └─ Control Panel Settings
             └─ Scheduled Tasks
   ```
4. Right-click > **New > Scheduled Task** (Windows Vista and later)

### Step 3: Configure General Settings

**General Tab:**
- **Name:** `Service Check - [ServiceName]`
- **User account:** `NT AUTHORITY\SYSTEM`
- **Run whether user is logged on or not:** ✓
- **Run with highest privileges:** ✓

### Step 4: Configure Trigger

**Triggers Tab:**
Click **New**, then choose trigger type:

**Option A: At Startup**
```
Begin the task: At startup
```

**Option B: Daily**
```
Begin the task: On a schedule
Settings: Daily
Start: 8:00 AM
Recur every: 1 days
```

**Option C: Hourly**
```
Begin the task: On a schedule
Settings: Daily
Start: 12:00 AM
Recur every: 1 days
Advanced settings:
  Repeat task every: 1 hour
  For a duration of: 1 day
```

### Step 5: Configure Action

**Actions Tab:**
Click **New**:

- **Action:** Start a program
- **Program/script:**
  ```
  powershell.exe
  ```
- **Add arguments:**
  ```
  -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1" -ServiceName "ServiceName" -CreateLogDirectory
  ```

  **Example for Datto RMM Agent:**
  ```
  -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1" -ServiceName "CentraStage" -CreateLogDirectory
  ```

### Step 6: Configure Conditions (Optional)

**Conditions Tab:**
- Uncheck **Start the task only if the computer is on AC power** (for laptops)
- Check **Wake the computer to run this task** (if needed)

### Step 7: Configure Settings

**Settings Tab:**
- **Allow task to be run on demand:** ✓
- **Run task as soon as possible after a scheduled start is missed:** ✓
- **If the task fails, restart every:** 10 minutes
- **Attempt to restart up to:** 3 times

### Step 8: Apply and Test

1. **Apply** GPO settings
2. **Force update** on test computer:
   ```cmd
   gpupdate /force
   ```
3. **Verify scheduled task** created:
   ```cmd
   schtasks /query /fo list /tn "Service Check*"
   ```
4. **Run manually** to test:
   ```cmd
   schtasks /run /tn "Service Check - [ServiceName]"
   ```
5. **Check log file:** `C:\Logs\ServiceCheck.log`

---

## Checking Multiple Services

To check multiple services, create separate GPOs or scheduled tasks for each service:

### Option 1: Multiple Scheduled Tasks in One GPO

1. Create a scheduled task for each service
2. Name them descriptively:
   - `Service Check - Spooler`
   - `Service Check - CentraStage`
   - `Service Check - WinDefend`
3. Each task checks one service and logs to the same or different files

### Option 2: Wrapper Script

Create a wrapper script that calls `Check-ServiceExists.ps1` multiple times:

```powershell
# Check-MultipleServices.ps1
$scriptPath = "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1"
$services = @("Spooler", "CentraStage", "WinDefend", "W32Time")

foreach ($service in $services) {
    & $scriptPath -ServiceName $service -CreateLogDirectory -LogPath "C:\Logs\ServiceCheck-$service.log"
}
```

---

## Log File Location Strategies

### Strategy 1: Centralized Network Logging

Log to network share for easy collection:

```powershell
-ServiceName "Spooler" -LogPath "\\fileserver\Logs$\ServiceChecks\%COMPUTERNAME%-Spooler.log" -CreateLogDirectory
```

**Permissions needed:**
- Computer accounts must have **Write** access to share
- Use `Authenticated Users` group or create dedicated service account

### Strategy 2: Local Logging with Collection

Log locally, collect via scheduled task or Datto RMM:

```powershell
# Log locally
-ServiceName "Spooler" -LogPath "C:\Logs\ServiceCheck.log"

# Collect via Datto RMM component or scheduled task:
# Copy C:\Logs\ServiceCheck.log to \\fileserver\Logs$\%COMPUTERNAME%-ServiceCheck.log
```

### Strategy 3: Windows Event Log

Modify script to write to Event Log instead (requires script modification):

```powershell
# Add to script:
Write-EventLog -LogName Application -Source "ServiceCheck" -EventId 1001 -EntryType Warning -Message "Service not found: $ServiceName"
```

---

## Common Service Names

| Service Name | Display Name | Purpose |
|--------------|--------------|---------|
| `Spooler` | Print Spooler | Printing services |
| `CentraStage` | Datto RMM Agent | Datto RMM monitoring |
| `WinDefend` | Windows Defender Antivirus Service | Antivirus |
| `W32Time` | Windows Time | Time synchronization |
| `SENS` | System Event Notification Service | System events |
| `EventLog` | Windows Event Log | Event logging |
| `Dnscache` | DNS Client | DNS caching |
| `LanmanServer` | Server | File and print sharing |
| `LanmanWorkstation` | Workstation | Network connections |
| `RpcSs` | Remote Procedure Call (RPC) | Core Windows service |

**To find service names:**
```powershell
Get-Service | Select-Object Name, DisplayName | Out-GridView
```

---

## Viewing and Analyzing Logs

### View Log File

```powershell
# View entire log
Get-Content C:\Logs\ServiceCheck.log

# View last 50 entries
Get-Content C:\Logs\ServiceCheck.log -Tail 50

# View only warnings (service not found)
Get-Content C:\Logs\ServiceCheck.log | Where-Object { $_ -match "WARNING" }

# View logs from today
Get-Content C:\Logs\ServiceCheck.log | Where-Object { $_ -match (Get-Date -Format "yyyy-MM-dd") }
```

### Centralized Log Analysis

Collect logs from all computers:

```powershell
# Collect logs from network share
$computers = Get-ADComputer -Filter * -SearchBase "OU=Workstations,DC=domain,DC=com"
$results = @()

foreach ($computer in $computers) {
    $logPath = "\\$($computer.Name)\C$\Logs\ServiceCheck.log"
    if (Test-Path $logPath) {
        $content = Get-Content $logPath | Where-Object { $_ -match "WARNING" }
        $results += [PSCustomObject]@{
            Computer = $computer.Name
            Warnings = $content.Count
            LastEntry = ($content | Select-Object -Last 1)
        }
    }
}

$results | Export-Csv C:\Reports\ServiceCheck-Summary.csv -NoTypeInformation
```

### Integration with Datto RMM

Create a Datto component to read and alert on log entries:

```powershell
# Datto RMM Component
$logFile = "C:\Logs\ServiceCheck.log"
$lastHours = 24

if (Test-Path $logFile) {
    $cutoff = (Get-Date).AddHours(-$lastHours)
    $entries = Get-Content $logFile | Where-Object {
        $timestamp = [DateTime]::ParseExact($_.Split('|')[0].Trim(), "yyyy-MM-dd HH:mm:ss", $null)
        $timestamp -gt $cutoff -and $_ -match "WARNING"
    }

    if ($entries.Count -gt 0) {
        Write-Output "ALERT: $($entries.Count) service(s) not found in last $lastHours hours"
        Write-Output $entries
        exit 1  # Trigger Datto alert
    }
    else {
        Write-Output "OK: All monitored services present"
        exit 0
    }
}
else {
    Write-Output "WARNING: Log file not found"
    exit 1
}
```

---

## Troubleshooting

### Script Not Running

**Check 1: Verify GPO Applied**
```cmd
gpresult /r /scope computer
```

**Check 2: Verify Script Location**
```cmd
dir \\domain.com\NETLOGON\Scripts\ServiceCheck\
```

**Check 3: Check PowerShell Execution Policy**
```powershell
Get-ExecutionPolicy -List
```

**Check 4: Test Script Manually**
```powershell
PowerShell -ExecutionPolicy Bypass -File "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1" -ServiceName "Spooler" -CreateLogDirectory -Verbose
```

### Log File Not Created

**Check 1: Verify Permissions**
```cmd
# Check if SYSTEM can write to C:\Logs
icacls C:\Logs
```

**Check 2: Run Script as SYSTEM**
```cmd
# Download PsExec from Sysinternals
psexec -i -s powershell.exe

# Then run script from elevated PowerShell
```

**Check 3: Check for -CreateLogDirectory Switch**
Ensure the switch is included in GPO script parameters.

### Service Name Not Found (False Positive)

**Issue:** Log shows service not found, but service exists

**Cause:** Using Display Name instead of Service Name

**Solution:**
```powershell
# Find correct service name
Get-Service | Where-Object { $_.DisplayName -like "*Print*" } | Select-Object Name, DisplayName

# Use the "Name" column value, not "DisplayName"
```

### Scheduled Task Not Running

**Check 1: Verify Task Exists**
```cmd
schtasks /query /tn "Service Check*" /fo list /v
```

**Check 2: Check Task History**
- Open Task Scheduler
- Navigate to task
- Enable history: Actions > Enable All Tasks History
- View History tab

**Check 3: Run Task Manually**
```cmd
schtasks /run /tn "Service Check - ServiceName"
```

---

## Security Considerations

### Permissions

- **Script execution:** Runs as SYSTEM (has full local access)
- **Log file access:** Ensure only administrators can modify logs
- **Network logs:** Secure network share with appropriate ACLs

### Best Practices

1. **Read-only script location:** Make SYSVOL script read-only to prevent tampering
2. **Log file integrity:** Monitor log files for unauthorized modifications
3. **Credential security:** Script doesn't store credentials, but network paths may require authentication
4. **Least privilege:** Consider running as dedicated service account if less privilege is acceptable

---

## Advanced Scenarios

### Scenario 1: Alert if Service Found (Instead of Not Found)

Invert the logic to alert when a service SHOULD NOT be installed:

Modify the script or create a wrapper:

```powershell
$service = Get-Service -Name "UnwantedService" -ErrorAction SilentlyContinue
if ($service) {
    # Alert: Service found but shouldn't be
    Write-LogEntry -Message "ALERT: Unwanted service 'UnwantedService' found on computer"
}
```

### Scenario 2: Check Service Status (Running/Stopped)

Extend to check not just existence but also status:

```powershell
$service = Get-Service -Name "ServiceName" -ErrorAction SilentlyContinue
if ($service) {
    if ($service.Status -ne "Running") {
        Write-LogEntry -Message "WARNING: Service '$ServiceName' exists but is not running (Status: $($service.Status))"
    }
}
```

### Scenario 3: Integration with Email Alerts

Combine with PowerShell email for alerts:

```powershell
# After logging
$recentWarnings = Get-Content $logPath | Where-Object { $_ -match "WARNING" -and $_ -match (Get-Date -Format "yyyy-MM-dd") }

if ($recentWarnings.Count -gt 0) {
    Send-MailMessage -From "alerts@company.com" -To "admin@company.com" `
        -Subject "Service Check Alert: $env:COMPUTERNAME" `
        -Body ($recentWarnings -join "`n") `
        -SmtpServer "smtp.company.com"
}
```

---

## Maintenance

### Regular Tasks

1. **Review logs weekly** for patterns or issues
2. **Archive old logs** (rotate logs older than 90 days)
3. **Update script parameters** if service names change
4. **Test on new OS versions** before broad deployment

### Log Rotation

Create scheduled task for log rotation:

```powershell
# Rotate-ServiceCheckLogs.ps1
$logPath = "C:\Logs\ServiceCheck.log"
$archivePath = "C:\Logs\Archive"

if ((Get-Item $logPath).Length -gt 10MB) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    Move-Item $logPath "$archivePath\ServiceCheck-$timestamp.log"
}
```

---

## Summary

This deployment guide provides multiple methods for implementing service existence checks via Group Policy. Choose the method that best fits your monitoring requirements:

- **Startup Script:** Best for critical services that must be present at boot
- **Scheduled Task:** Best for ongoing monitoring with customizable frequency
- **Multiple Services:** Use wrapper scripts or multiple tasks
- **Centralized Logging:** Collect logs to network share for analysis

For most scenarios, **Method 2 (Scheduled Task)** provides the most flexibility and is recommended for production deployments.
