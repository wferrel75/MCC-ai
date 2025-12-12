# Deploy-BGInfo.ps1 - Troubleshooting Guide

This guide covers common issues, error scenarios, and their resolutions when deploying BGInfo via Datto RMM.

## Table of Contents

- [Exit Code Reference](#exit-code-reference)
- [Common Issues](#common-issues)
- [Error Messages](#error-messages)
- [Diagnostic Commands](#diagnostic-commands)
- [Advanced Troubleshooting](#advanced-troubleshooting)

## Exit Code Reference

| Exit Code | Issue | Severity | Action Required |
|-----------|-------|----------|-----------------|
| 0 | Success | None | No action needed |
| 1 | Directory creation failed | Critical | Check permissions and disk space |
| 2 | BGInfo executable unavailable | Critical | Check network or upload executables |
| 3 | Configuration file missing | Critical | Upload .bgi file with script |
| 4 | Registry entry failed | Critical | Verify administrator privileges |
| 5 | Execution failed for users | Warning | Check user sessions and permissions |
| 99 | Unexpected failure | Critical | Review detailed logs |

## Common Issues

### Issue 1: Exit Code 1 - Failed to Create Destination Directory

**Symptoms:**
```
[ERROR] Failed to create destination directory: Access to the path 'C:\MCC\BGInfo' is denied.
Exit Code: 1
```

**Possible Causes:**
1. Insufficient permissions
2. Disk full
3. Path blocked by antivirus/security software
4. Parent directory doesn't exist

**Solutions:**

**Check permissions:**
```powershell
# Verify current user context
whoami

# Should show: NT AUTHORITY\SYSTEM (when run via Datto RMM)
```

**Check disk space:**
```powershell
Get-PSDrive C | Select-Object Used,Free
```

**Try alternate path:**
```powershell
.\Deploy-BGInfo.ps1 -DestinationPath "C:\ProgramData\BGInfo"
```

**Check antivirus exclusions:**
- Add `C:\MCC\BGInfo` to antivirus exclusions
- Temporarily disable real-time protection for testing

---

### Issue 2: Exit Code 2 - Failed to Obtain BGInfo Executable

**Symptoms:**
```
[WARNING] Download failed: The remote server returned an error: (407) Proxy Authentication Required.
[INFO] Attempting fallback: Copying from script directory...
[ERROR] Failed to obtain BGInfo executable from any source
Exit Code: 2
```

**Possible Causes:**
1. No internet connectivity
2. Proxy blocking downloads
3. Firewall blocking Sysinternals Live
4. No local fallback executables uploaded

**Solutions:**

**Option 1: Upload local executables**
1. Download BGInfo from [Sysinternals](https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo)
2. Upload `Bginfo64.exe` and/or `Bginfo.exe` with your Datto RMM component
3. Script will automatically use local copies

**Option 2: Configure proxy**
```powershell
# Add proxy configuration before running script
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy("http://proxy.domain.com:8080")
.\Deploy-BGInfo.ps1
```

**Option 3: Firewall whitelist**
- Whitelist: `live.sysinternals.com`
- Protocol: HTTPS (TCP 443)

**Test connectivity:**
```powershell
Test-NetConnection -ComputerName live.sysinternals.com -Port 443
```

---

### Issue 3: Exit Code 3 - Failed to Obtain BGInfo Configuration File

**Symptoms:**
```
[ERROR] No .bgi configuration files found in script directory
Exit Code: 3
```

**Possible Causes:**
1. No `.bgi` file uploaded with script
2. File extension incorrect (e.g., `.txt` instead of `.bgi`)
3. File uploaded to wrong location

**Solutions:**

**Verify file upload:**
```powershell
# Check what files are in the script directory
Get-ChildItem -Path $PSScriptRoot -Filter "*.bgi"
```

**Create default configuration:**
1. Run BGInfo manually on a test machine
2. Configure desired layout
3. Save as `custom.bgi`
4. Upload to Datto RMM component

**Quick test configuration:**
- Download a sample .bgi from Microsoft documentation
- Temporarily rename any existing config file to `.bgi` extension for testing

---

### Issue 4: Exit Code 4 - Failed to Create Registry Autorun Entry

**Symptoms:**
```
[ERROR] Failed to create registry autorun entry: Requested registry access is not allowed.
Exit Code: 4
```

**Possible Causes:**
1. Not running as Administrator/SYSTEM
2. Registry permissions restricted by Group Policy
3. Registry key protected by security software

**Solutions:**

**Verify execution context:**
```powershell
# Check if running as admin
([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Should return: True
```

**Check registry permissions:**
```powershell
# Verify access to Run key
Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
```

**Manual registry entry (temporary workaround):**
```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" `
    -Name "BGInfo" `
    -Value '"C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt' `
    -PropertyType String -Force
```

**Check Group Policy:**
- Verify no GPO is restricting `HKLM\...\Run` modifications
- Check: `gpedit.msc` → Computer Configuration → Administrative Templates

---

### Issue 5: Exit Code 5 - Failed to Execute BGInfo

**Symptoms:**
```
[WARNING] Failed to launch BGInfo for user 'jsmith' (Return Code: 5)
[ERROR] Failed to execute BGInfo for any logged-in users
Exit Code: 5
```

**Possible Causes:**
1. No users currently logged in
2. User session in disconnected state
3. WMI service issues
4. BGInfo executable corrupted

**Solutions:**

**Check logged-in users:**
```powershell
quser
# or
query user
```

**Expected output:**
```
 USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
>jsmith                console             1  Active          .  12/10/2025 3:45 PM
```

**If exit code 5 but no users logged in:**
- This is expected behavior
- BGInfo will run at next user logon via registry autorun
- Consider exit code 5 as "warning" not "error" in this scenario

**Test manual execution:**
```powershell
# Test BGInfo works
& "C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt
```

**Check WMI service:**
```powershell
Get-Service Winmgmt | Select-Object Name, Status, StartType
# Status should be: Running
```

**Restart WMI if needed:**
```powershell
Restart-Service Winmgmt -Force
```

---

### Issue 6: BGInfo Displays But Immediately Disappears

**Symptoms:**
- BGInfo runs successfully (exit code 0)
- Desktop wallpaper shows system info briefly
- Wallpaper returns to original image

**Possible Causes:**
1. Group Policy overriding wallpaper
2. Third-party wallpaper management software
3. BGInfo timer set incorrectly

**Solutions:**

**Check Group Policy wallpaper settings:**
```powershell
# Check current wallpaper policy
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "Wallpaper" -ErrorAction SilentlyContinue
```

**Disable GP wallpaper override:**
- `gpedit.msc` → User Configuration → Administrative Templates → Desktop → Desktop
- Set "Desktop Wallpaper" to "Not Configured"

**Verify BGInfo command:**
- Ensure `/timer:0` is set (not `/timer:300` or other value)
- Check registry autorun entry:
```powershell
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo"
```

**Set registry to prevent wallpaper changes (optional):**
```powershell
# Lock wallpaper after BGInfo runs
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" `
    -Name "NoChangingWallpaper" -Value 1 -PropertyType DWord -Force
```

---

### Issue 7: Download Timeout

**Symptoms:**
```
[WARNING] Download failed: Download timed out after 30 seconds
[INFO] Attempting fallback: Copying from script directory...
```

**Possible Causes:**
1. Slow internet connection
2. Network congestion
3. Sysinternals Live temporarily slow

**Solutions:**

**Increase timeout:**
```powershell
.\Deploy-BGInfo.ps1 -DownloadTimeout 60
```

**Pre-download executables:**
- Download BGInfo executables manually
- Upload with Datto RMM component
- Script will use local copies automatically

---

### Issue 8: PowerShell Execution Policy Blocking

**Symptoms:**
```
.\Deploy-BGInfo.ps1 : File cannot be loaded because running scripts is disabled on this system.
```

**Possible Causes:**
1. PowerShell execution policy set to Restricted
2. Script not signed and AllSigned policy active

**Solutions:**

**Datto RMM typically bypasses this**, but if running manually:

```powershell
# Check current policy
Get-ExecutionPolicy

# Temporarily bypass
powershell.exe -ExecutionPolicy Bypass -File .\Deploy-BGInfo.ps1

# Or set for current session
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Deploy-BGInfo.ps1
```

---

### Issue 9: Multiple BGInfo Instances Running

**Symptoms:**
- High CPU usage
- Multiple BGInfo.exe processes in Task Manager
- Wallpaper flickering

**Possible Causes:**
1. Script run multiple times without cleanup
2. Registry autorun entry duplicated
3. Task Scheduler entries conflicting

**Solutions:**

**Check registry entries:**
```powershell
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" |
    Select-Object BGInfo*
```

**Check Task Scheduler:**
```powershell
Get-ScheduledTask | Where-Object {$_.TaskName -like "*BGInfo*"}
```

**Kill running instances:**
```powershell
Get-Process BGInfo -ErrorAction SilentlyContinue | Stop-Process -Force
```

**Clean registry duplicates:**
```powershell
# Remove all BGInfo entries
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo*" -ErrorAction SilentlyContinue

# Re-run deployment script
.\Deploy-BGInfo.ps1
```

---

### Issue 10: BGInfo Shows Incorrect Information

**Symptoms:**
- Wrong computer name, IP address, or other fields
- Blank fields
- Error text displayed on wallpaper

**Possible Causes:**
1. .bgi configuration file outdated
2. Custom fields using incorrect WMI queries
3. Permissions preventing data access

**Solutions:**

**Validate .bgi configuration:**
1. Run BGInfo manually to test configuration
2. Verify all custom fields return data
3. Update WMI queries if needed

**Common field fixes:**

**Computer Name:**
```
<Computer Name>
```

**IP Address (prefer IPv4):**
```
<IP Address (IPv4)>
```

**Free Disk Space:**
```
<Free Space>
```

**Test custom WMI queries:**
```powershell
# Example: Test network adapter query
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=True"
```

---

## Error Messages

### "Cannot process argument transformation on parameter 'ExecutablePath'"

**Fixed in version 1.0.1+**

If using an older version:
- Update to latest script version
- Issue was caused by Write-Output pollution in logging

---

### "Access Denied" When Creating Files

**Cause:** Insufficient permissions or antivirus blocking

**Solution:**
```powershell
# Check effective permissions
icacls "C:\MCC\BGInfo"

# Grant SYSTEM full control (if needed)
icacls "C:\MCC\BGInfo" /grant "NT AUTHORITY\SYSTEM:(OI)(CI)F" /T
```

---

### "The term 'quser' is not recognized"

**Cause:** Running on Windows Home edition or quser command unavailable

**Workaround:** Edit script to use alternative user detection:
```powershell
# Replace quser with:
Get-Process explorer | Select-Object @{Name='Username';Expression={(Get-CimInstance Win32_Process -Filter "ProcessId=$($_.Id)").GetOwner().User}}
```

---

## Diagnostic Commands

### Full System Check

Run these commands to gather diagnostic information:

```powershell
# PowerShell version
$PSVersionTable.PSVersion

# Execution policy
Get-ExecutionPolicy -List

# Current user context
whoami
[Security.Principal.WindowsIdentity]::GetCurrent().Name

# Check if running as admin
([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Network connectivity
Test-NetConnection -ComputerName live.sysinternals.com -Port 443

# Disk space
Get-PSDrive C | Select-Object Used,Free

# Check installation
Test-Path "C:\MCC\BGInfo\BGInfo.exe"
Test-Path "C:\MCC\BGInfo\BGInfo.bgi"

# Verify registry entry
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo" -ErrorAction SilentlyContinue

# Check logged-in users
quser

# Check WMI service
Get-Service Winmgmt | Select-Object Name, Status, StartType

# List running BGInfo processes
Get-Process BGInfo -ErrorAction SilentlyContinue
```

### Script-Specific Diagnostics

```powershell
# Run with verbose output
.\Deploy-BGInfo.ps1 -Verbose

# Test mode (shows what would happen)
.\Deploy-BGInfo.ps1 -WhatIf -Verbose

# Check files in script directory
Get-ChildItem -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Filter "*"
```

### Validate BGInfo Files

```powershell
# Check executable
$BGInfoPath = "C:\MCC\BGInfo\BGInfo.exe"
if (Test-Path $BGInfoPath) {
    (Get-Item $BGInfoPath).VersionInfo | Select-Object FileVersion, ProductVersion, FileDescription
    (Get-Item $BGInfoPath).Length # File size
    (Get-FileHash $BGInfoPath -Algorithm SHA256).Hash
}

# Check config file (it's XML)
$ConfigPath = "C:\MCC\BGInfo\BGInfo.bgi"
if (Test-Path $ConfigPath) {
    [xml](Get-Content $ConfigPath) # Should load as XML
}
```

---

## Advanced Troubleshooting

### Enable Script Debugging

Modify the script temporarily to add debug output:

```powershell
# Add at top of script (after param block)
$DebugPreference = 'Continue'
$VerbosePreference = 'Continue'
$ErrorActionPreference = 'Continue' # Change from 'Stop' to see all errors

# Add before critical sections
Write-Debug "About to execute: <description>"
```

### Capture Full Transcript

```powershell
Start-Transcript -Path "C:\Temp\BGInfo-Deployment.log" -Append
.\Deploy-BGInfo.ps1 -Verbose
Stop-Transcript
```

### Test Individual Functions

Extract and test specific functions:

```powershell
# Source the script to load functions
. .\Deploy-BGInfo.ps1

# Test architecture detection
Get-OSArchitecture

# Test user enumeration
Get-LoggedInUsers

# Test configuration file search
Get-ChildItem -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Filter "*.bgi"
```

### Monitor BGInfo Execution

```powershell
# Watch for BGInfo process creation
while ($true) {
    $proc = Get-Process BGInfo -ErrorAction SilentlyContinue
    if ($proc) {
        Write-Host "BGInfo running: PID $($proc.Id), User: $((Get-CimInstance Win32_Process -Filter "ProcessId=$($proc.Id)").GetOwner().User)"
    }
    Start-Sleep -Seconds 1
}
```

### Check Event Logs

```powershell
# Application errors related to BGInfo
Get-EventLog -LogName Application -After (Get-Date).AddHours(-1) |
    Where-Object {$_.Source -like "*BGInfo*" -or $_.Message -like "*BGInfo*"}

# System errors during script execution
Get-EventLog -LogName System -After (Get-Date).AddHours(-1) -EntryType Error
```

---

## Getting Help

### Information to Collect

When reporting issues, provide:

1. **Script version:** Check header of `Deploy-BGInfo.ps1`
2. **Exit code:** From Datto RMM or script output
3. **Full log output:** From deployment summary
4. **Environment details:**
   ```powershell
   [PSCustomObject]@{
       PSVersion = $PSVersionTable.PSVersion
       OSVersion = [System.Environment]::OSVersion.Version
       Is64Bit = [Environment]::Is64BitOperatingSystem
       RunAsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
   }
   ```
5. **Diagnostic output:** From commands in this guide

### Quick Reference Card

| Symptom | Likely Cause | Quick Fix |
|---------|-------------|-----------|
| Exit code 1 | Permissions | Check SYSTEM context |
| Exit code 2 | Network/No local files | Upload executables |
| Exit code 3 | Missing .bgi | Upload config file |
| Exit code 4 | Registry blocked | Check admin rights |
| Exit code 5 | No logged-in users | Expected - ignore |
| Wallpaper disappears | Group Policy | Disable GP wallpaper |
| Timeout errors | Slow connection | Increase timeout or use local files |
| Access denied | Permissions/AV | Check exclusions |

---

## Additional Resources

- [BGInfo Official Documentation](https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo)
- [Sysinternals Command Line Reference](https://docs.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite)
- [Datto RMM Script Debugging](https://rmm.datto.com/help)
- Main README: [README.md](README.md)
