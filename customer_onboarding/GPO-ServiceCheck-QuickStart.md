# Quick Start: Service Check via GPO

## Ready-to-Use Examples

Copy and paste these configurations for common scenarios.

---

## Scenario 1: Check for Datto RMM Agent at Startup

### Script Parameters for GPO Startup Script
```
-ServiceName "CentraStage" -CreateLogDirectory
```

### Full Path for Scheduled Task
```
-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1" -ServiceName "CentraStage" -CreateLogDirectory
```

**Service Details:**
- Service Name: `CentraStage`
- Display Name: Datto RMM Agent
- Purpose: Verify RMM monitoring agent is installed

---

## Scenario 2: Check for Print Spooler Service Daily

### Script Parameters
```
-ServiceName "Spooler" -LogPath "C:\Logs\PrintSpooler.log" -CreateLogDirectory
```

### Scheduled Task Configuration
**Trigger:** Daily at 8:00 AM
**Action:**
```
-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1" -ServiceName "Spooler" -LogPath "C:\Logs\PrintSpooler.log" -CreateLogDirectory
```

---

## Scenario 3: Check Multiple Security Services Hourly

### Services to Monitor
- Windows Defender: `WinDefend`
- Windows Firewall: `MpsSvc`
- Security Center: `wscsvc`

### Option A: Wrapper Script

Create `Check-SecurityServices.ps1`:
```powershell
$scriptPath = "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1"
$services = @("WinDefend", "MpsSvc", "wscsvc")

foreach ($service in $services) {
    & $scriptPath -ServiceName $service -CreateLogDirectory -LogPath "C:\Logs\SecurityCheck-$service.log"
}
```

**Scheduled Task Action:**
```
-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-SecurityServices.ps1"
```

**Trigger:** Hourly (Daily recurring every 1 hour)

### Option B: Three Separate Scheduled Tasks

Create 3 tasks with these parameters:

**Task 1: Windows Defender**
```
-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1" -ServiceName "WinDefend" -CreateLogDirectory
```

**Task 2: Windows Firewall**
```
-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1" -ServiceName "MpsSvc" -CreateLogDirectory
```

**Task 3: Security Center**
```
-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1" -ServiceName "wscsvc" -CreateLogDirectory
```

---

## Scenario 4: Network Log to Central Server

### Script Parameters
```
-ServiceName "ServiceName" -LogPath "\\fileserver\Logs$\ServiceChecks\%COMPUTERNAME%-ServiceName.log" -CreateLogDirectory
```

### Example for Datto RMM to Network Share
```
-ServiceName "CentraStage" -LogPath "\\fileserver\Logs$\ServiceChecks\%COMPUTERNAME%-DattoRMM.log" -CreateLogDirectory
```

**Note:** `%COMPUTERNAME%` will be expanded by Windows to the actual computer name.

### Share Permissions Required
```
Share Name: Logs$
Path: D:\Logs
Permissions:
  - Authenticated Users: Change (NTFS: Write, Modify)
  - Domain Admins: Full Control
```

---

## Scenario 5: Custom Service with Email Alert

### Wrapper Script with Email Alert

Create `Check-ServiceWithAlert.ps1`:
```powershell
# Parameters
$serviceName = "MyCustomService"
$logPath = "C:\Logs\ServiceCheck.log"
$smtpServer = "smtp.domain.com"
$from = "alerts@domain.com"
$to = "admin@domain.com"

# Run service check
$scriptPath = "\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1"
& $scriptPath -ServiceName $serviceName -LogPath $logPath -CreateLogDirectory

# Check if service was missing (log contains today's date + WARNING)
$todayLogs = Get-Content $logPath -ErrorAction SilentlyContinue |
    Where-Object { $_ -match (Get-Date -Format "yyyy-MM-dd") -and $_ -match "WARNING" -and $_ -match $serviceName }

if ($todayLogs) {
    $subject = "ALERT: Service '$serviceName' not found on $env:COMPUTERNAME"
    $body = $todayLogs -join "`n"

    Send-MailMessage -SmtpServer $smtpServer -From $from -To $to `
        -Subject $subject -Body $body -Priority High
}
```

---

## Common Service Names Reference

### MSP Monitoring Agents
| Service Name | Display Name | Vendor |
|--------------|--------------|--------|
| `CentraStage` | Datto RMM Agent | Datto RMM |
| `LTService` | LabTech Service | ConnectWise Automate |
| `CWA` | ConnectWise Automate Agent | ConnectWise |
| `NableAgent` | N-able Agent | N-able RMM |

### Backup Agents
| Service Name | Display Name | Vendor |
|--------------|--------------|--------|
| `AcronisCyberProtectService` | Acronis Cyber Protect | Acronis |
| `BackupExecAgentAccelerator` | Backup Exec Agent Accelerator | Veritas |
| `Veeam.EndPoint.Service` | Veeam Endpoint Backup Service | Veeam |

### Security Software
| Service Name | Display Name | Vendor |
|--------------|--------------|--------|
| `WinDefend` | Windows Defender Antivirus Service | Microsoft |
| `SentinelAgent` | SentinelOne Agent | SentinelOne |
| `CSFalconService` | CrowdStrike Falcon Sensor | CrowdStrike |
| `KasperskySecurityService` | Kaspersky Security Service | Kaspersky |

### Critical Windows Services
| Service Name | Display Name | Purpose |
|--------------|--------------|---------|
| `Spooler` | Print Spooler | Printing |
| `W32Time` | Windows Time | Time sync |
| `Dnscache` | DNS Client | DNS resolution |
| `EventLog` | Windows Event Log | Event logging |
| `RpcSs` | Remote Procedure Call (RPC) | Core Windows |
| `SENS` | System Event Notification Service | System events |

---

## Quick Testing Commands

### Test Script Manually
```powershell
# Run with verbose output
PowerShell -ExecutionPolicy Bypass -File "C:\Scripts\Check-ServiceExists.ps1" -ServiceName "Spooler" -CreateLogDirectory -Verbose

# Run as SYSTEM (using PsExec)
psexec -i -s powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\Check-ServiceExists.ps1" -ServiceName "Spooler" -CreateLogDirectory
```

### Verify GPO Application
```cmd
# Check applied GPOs
gpresult /r /scope computer

# Force GPO update
gpupdate /force

# View detailed GPO results
gpresult /h C:\gpresult.html
```

### Check Scheduled Task
```cmd
# List service check tasks
schtasks /query /tn "Service Check*" /fo list /v

# Run task manually
schtasks /run /tn "Service Check - Spooler"

# Check task result
schtasks /query /tn "Service Check - Spooler" /fo list /v | findstr "Last Result"
```

### View Logs
```powershell
# View last 20 entries
Get-Content C:\Logs\ServiceCheck.log -Tail 20

# View warnings only
Get-Content C:\Logs\ServiceCheck.log | Where-Object { $_ -match "WARNING" }

# View today's logs
Get-Content C:\Logs\ServiceCheck.log | Where-Object { $_ -match (Get-Date -Format "yyyy-MM-dd") }

# Count warnings
(Get-Content C:\Logs\ServiceCheck.log | Where-Object { $_ -match "WARNING" }).Count
```

---

## Deployment Checklist

- [ ] Copy `Check-ServiceExists.ps1` to SYSVOL or NETLOGON
- [ ] Verify script is accessible from target computers
- [ ] Create/verify log directory exists on target computers (or use `-CreateLogDirectory`)
- [ ] Create or edit Group Policy Object
- [ ] Configure startup script OR scheduled task
- [ ] Set PowerShell execution policy if needed
- [ ] Link GPO to target OU
- [ ] Force GPO update on test computer (`gpupdate /force`)
- [ ] Restart test computer (for startup script) OR run scheduled task manually
- [ ] Verify log file created and contains expected output
- [ ] Monitor for 24 hours to confirm regular execution
- [ ] Deploy to production OUs

---

## Support and Troubleshooting

### Script Not Running?

1. **Check GPO applied:**
   ```cmd
   gpresult /r /scope computer | findstr "Service Check"
   ```

2. **Verify script location:**
   ```cmd
   dir \\domain.com\NETLOGON\Scripts\ServiceCheck\
   ```

3. **Test execution policy:**
   ```powershell
   Get-ExecutionPolicy -Scope LocalMachine
   ```

4. **Run manually as SYSTEM:**
   ```cmd
   psexec -i -s cmd
   # Then run PowerShell and test script
   ```

### Log File Issues?

1. **Verify directory exists:**
   ```cmd
   dir C:\Logs
   ```

2. **Check permissions:**
   ```cmd
   icacls C:\Logs
   ```

3. **Create manually:**
   ```cmd
   mkdir C:\Logs
   icacls C:\Logs /grant "NT AUTHORITY\SYSTEM:(OI)(CI)F"
   ```

### Scheduled Task Not Running?

1. **Enable task history:**
   - Open Task Scheduler
   - Action menu > Enable All Tasks History

2. **Check last run result:**
   ```cmd
   schtasks /query /tn "Service Check*" /v /fo list | findstr "Last Run Result"
   ```
   - `0x0` = Success
   - `0x1` = Failure
   - `0x41301` = Task is running

3. **View task history:**
   - Open Task Scheduler
   - Find the task
   - History tab

---

## File Locations

### Script Storage (Choose One)
```
\\domain.com\NETLOGON\Scripts\ServiceCheck\Check-ServiceExists.ps1
\\domain.com\SYSVOL\domain.com\Scripts\ServiceCheck\Check-ServiceExists.ps1
```

### Log Files
```
Local: C:\Logs\ServiceCheck.log
Network: \\fileserver\Logs$\ServiceChecks\%COMPUTERNAME%-ServiceCheck.log
Custom: C:\Logs\ServiceCheck-[ServiceName].log
```

### Group Policy
```
Computer Configuration > Policies > Windows Settings > Scripts > Startup
Computer Configuration > Preferences > Control Panel Settings > Scheduled Tasks
```

---

## Next Steps

1. **Deploy to pilot group** (5-10 computers)
2. **Monitor logs for 1 week**
3. **Adjust schedule/services as needed**
4. **Roll out to production**
5. **Set up log collection/analysis**
6. **Integrate with alerting system** (Datto RMM, email, etc.)

---

## Additional Resources

- Full deployment guide: `GPO-ServiceCheck-Deployment-Guide.md`
- Script source: `Check-ServiceExists.ps1`
- Microsoft docs: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-service
