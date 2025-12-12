# Refresh-BGInfo.ps1 - User Guide

Quick reference guide for refreshing BGInfo wallpapers on-demand.

## Overview

`Refresh-BGInfo.ps1` is a lightweight companion script to `Deploy-BGInfo.ps1` that forces BGInfo to update the desktop wallpaper immediately. Unlike the deployment script which runs as SYSTEM, this script runs in **user context**.

**Version:** 1.0.0

## Use Cases

✅ **Force immediate wallpaper refresh** after making configuration changes
✅ **Restore BGInfo wallpaper** if it gets overwritten by Group Policy or user
✅ **Scheduled periodic updates** to keep system information current
✅ **Manual on-demand refresh** for troubleshooting or testing
✅ **Post-deployment verification** to confirm BGInfo is working

## Requirements

- **BGInfo must be installed first** via `Deploy-BGInfo.ps1`
- **Run as logged-in user** (not SYSTEM)
- **No admin rights required** (runs in user context)

## Quick Start

### Basic Usage

```powershell
.\Refresh-BGInfo.ps1
```

This will:
1. Check if BGInfo is installed at `C:\MCC\BGInfo`
2. Execute BGInfo with current configuration
3. Update wallpaper immediately

### Custom Installation Path

```powershell
.\Refresh-BGInfo.ps1 -BGInfoPath "C:\Tools\BGInfo"
```

### Silent Mode (Minimal Output)

```powershell
.\Refresh-BGInfo.ps1 -Silent
```

Useful for scheduled tasks where you only want errors reported.

## Datto RMM Deployment

### Method 1: Quick Job (One-Time Refresh)

**Use when:** You need to refresh wallpapers immediately for specific users

1. **Navigate to:** Devices → Select device(s)
2. **Create:** Quick Job → PowerShell Script
3. **Upload:** `Refresh-BGInfo.ps1`
4. **Configure:**
   - Context: **User** (not SYSTEM)
   - Script: `.\Refresh-BGInfo.ps1`
5. **Run:** Execute job

**Important:** Set execution context to **User**, not SYSTEM!

### Method 2: Component (Reusable)

**Use when:** You want a reusable refresh component for repeated use

#### Create Component

1. **Navigate to:** Setup → Components
2. **Create:** New Component
   - Name: `Refresh BGInfo Wallpaper`
   - Type: `PowerShell Script`
   - Category: `Desktop Management`

#### Upload Script

1. **Upload:** `Refresh-BGInfo.ps1`
2. **Script Content:**
   ```powershell
   .\Refresh-BGInfo.ps1
   ```

#### Configure Execution Context

**Critical:** Set component to run as **User**, not SYSTEM

#### Set Monitoring

**Success:** Exit code = 0
**Failure:** Exit codes 1, 2, 3, 99

#### Deploy

**Option A: Run on-demand**
- Devices → Select device(s) → Run Component → `Refresh BGInfo Wallpaper`

**Option B: Add to user login script policy**
- Useful for ensuring wallpaper is always current at logon

### Method 3: Scheduled Refresh

**Use when:** You want BGInfo to refresh automatically on a schedule

#### Create Scheduled Component

1. **Create component** as described in Method 2
2. **Navigate to:** Setup → Policies
3. **Select or create** policy for target devices
4. **Add component:** `Refresh BGInfo Wallpaper`
5. **Configure schedule:**
   - Frequency: Daily, Weekly, or Monthly
   - Time: During business hours (8 AM - 5 PM)
   - Context: **User**

#### Recommended Schedules

**Daily Refresh:**
- Time: 8:00 AM (start of workday)
- Ensures up-to-date info each morning

**Weekly Refresh:**
- Day: Monday
- Time: 8:00 AM
- Good balance of freshness and minimal overhead

**Monthly Refresh:**
- Day: 1st of month
- Time: 8:00 AM
- Minimal approach, good for static environments

## Parameters

### `-BGInfoPath`

- **Type:** String
- **Default:** `C:\MCC\BGInfo`
- **Description:** Path to BGInfo installation directory

**Example:**
```powershell
.\Refresh-BGInfo.ps1 -BGInfoPath "C:\Tools\BGInfo"
```

### `-Silent`

- **Type:** Switch
- **Default:** False
- **Description:** Suppress all output except errors

**Example:**
```powershell
.\Refresh-BGInfo.ps1 -Silent
```

Useful for:
- Scheduled tasks (reduces log noise)
- Background execution
- Login scripts

## Exit Codes

| Exit Code | Meaning | Action Required |
|-----------|---------|-----------------|
| 0 | Success - Wallpaper refreshed | None |
| 1 | BGInfo executable not found | Run Deploy-BGInfo.ps1 first |
| 2 | Configuration file not found | Run Deploy-BGInfo.ps1 first |
| 3 | BGInfo execution failed | Check BGInfo installation |
| 99 | Unexpected error | Review logs |

## Sample Output

### Successful Execution

```
[2025-12-11 10:30:15] [Info] BGInfo Wallpaper Refresh Started
[2025-12-11 10:30:15] [Info] Running as user: jsmith
[2025-12-11 10:30:15] [Info] BGInfo Path: C:\MCC\BGInfo
[2025-12-11 10:30:15] [Info] Checking for BGInfo executable...
[2025-12-11 10:30:15] [Success] Found BGInfo executable: C:\MCC\BGInfo\BGInfo.exe
[2025-12-11 10:30:15] [Info] Checking for BGInfo configuration...
[2025-12-11 10:30:15] [Success] Found BGInfo configuration: C:\MCC\BGInfo\BGInfo.bgi
[2025-12-11 10:30:15] [Info] Executing BGInfo to refresh wallpaper...
[2025-12-11 10:30:16] [Success] BGInfo executed successfully - wallpaper updated
[2025-12-11 10:30:16] [Success] BGInfo Wallpaper Refresh Completed Successfully
```

### Silent Mode Output

```
(No output unless error occurs)
```

### Error: BGInfo Not Installed

```
[2025-12-11 10:30:15] [Info] BGInfo Wallpaper Refresh Started
[2025-12-11 10:30:15] [Info] Running as user: jsmith
[2025-12-11 10:30:15] [Info] BGInfo Path: C:\MCC\BGInfo
[2025-12-11 10:30:15] [Info] Checking for BGInfo executable...
[2025-12-11 10:30:15] [Error] BGInfo executable not found at: C:\MCC\BGInfo\BGInfo.exe
[2025-12-11 10:30:15] [Error] Please run Deploy-BGInfo.ps1 first to install BGInfo
[2025-12-11 10:30:15] [Error] BGInfo Wallpaper Refresh Failed
[2025-12-11 10:30:15] [Error] Error: BGInfo not installed
```

## Troubleshooting

### Issue: Exit Code 1 - Executable Not Found

**Symptom:**
```
[Error] BGInfo executable not found at: C:\MCC\BGInfo\BGInfo.exe
```

**Solution:**
1. Verify BGInfo is installed: Run `Deploy-BGInfo.ps1` first
2. Check installation path matches script parameter
3. If custom path, use `-BGInfoPath` parameter

**Verify Installation:**
```powershell
Test-Path "C:\MCC\BGInfo\BGInfo.exe"
```

---

### Issue: Exit Code 2 - Configuration Not Found

**Symptom:**
```
[Error] BGInfo configuration not found at: C:\MCC\BGInfo\BGInfo.bgi
```

**Solution:**
1. Run `Deploy-BGInfo.ps1` to install configuration
2. Verify .bgi file was deployed correctly

**Verify Configuration:**
```powershell
Test-Path "C:\MCC\BGInfo\BGInfo.bgi"
```

---

### Issue: Wallpaper Doesn't Update

**Symptom:**
- Script exits with code 0
- No error messages
- Wallpaper doesn't change

**Possible Causes:**
1. Group Policy overriding wallpaper
2. Wallpaper locked by administrator
3. BGInfo running but display issue

**Solutions:**

**Check Group Policy:**
```powershell
# Check if wallpaper is controlled by GP
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "Wallpaper" -ErrorAction SilentlyContinue
```

**Manual test:**
```powershell
# Run BGInfo manually to see any errors
& "C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0
```

**Force wallpaper refresh:**
```powershell
# Refresh desktop
rundll32.exe user32.dll, UpdatePerUserSystemParameters
```

---

### Issue: "Access Denied" or Permission Errors

**Symptom:**
```
[Error] Access to the path is denied
```

**Cause:** Running as SYSTEM instead of User

**Solution:**
Ensure Datto RMM component is set to run in **User context**, not SYSTEM context

**Verify context in Datto RMM:**
- Component settings → Execution Context → **User**

---

### Issue: Script Runs But Nothing Happens

**Symptom:**
- Exit code 0
- No visible changes
- No errors

**Diagnostic Steps:**

1. **Verify user is logged in:**
   ```powershell
   whoami
   # Should show domain\username, not NT AUTHORITY\SYSTEM
   ```

2. **Check BGInfo process:**
   ```powershell
   Get-Process BGInfo -ErrorAction SilentlyContinue
   ```

3. **Test with verbose output:**
   ```powershell
   .\Refresh-BGInfo.ps1 -Verbose
   ```

4. **Run without Silent flag:**
   ```powershell
   .\Refresh-BGInfo.ps1
   # Review all output messages
   ```

## Use Case Examples

### Example 1: After Configuration Update

**Scenario:** You updated the .bgi file and need all users to see the new layout

**Solution:**
```powershell
# 1. Deploy updated configuration
.\Deploy-BGInfo.ps1

# 2. Force refresh for all logged-in users
# Run as Quick Job in User context on all devices
.\Refresh-BGInfo.ps1
```

---

### Example 2: Daily Refresh Schedule

**Scenario:** Keep system information current with daily updates

**Datto RMM Configuration:**
1. Create component: `Refresh BGInfo Wallpaper`
2. Add to policy
3. Schedule: Daily at 8:00 AM
4. Context: User
5. Apply to: All workstations

---

### Example 3: Login Script Integration

**Scenario:** Refresh BGInfo every time user logs in

**Datto RMM Configuration:**
1. Create component: `Refresh BGInfo Wallpaper`
2. Add to user login policy
3. Trigger: On User Login
4. Context: User
5. Script:
   ```powershell
   # Add small delay to allow desktop to load
   Start-Sleep -Seconds 5
   .\Refresh-BGInfo.ps1 -Silent
   ```

---

### Example 4: Manual User-Initiated Refresh

**Scenario:** Allow users to refresh their own wallpaper

**Create desktop shortcut:**
```powershell
# Create shortcut on user desktop
$ShortcutPath = "$env:USERPROFILE\Desktop\Refresh System Info.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"C:\MCC\BGInfo\Refresh-BGInfo.ps1`" -Silent"
$Shortcut.Description = "Refresh desktop system information"
$Shortcut.IconLocation = "C:\MCC\BGInfo\BGInfo.exe,0"
$Shortcut.Save()
```

Users can double-click the shortcut to refresh their wallpaper.

---

### Example 5: Post-Deployment Verification

**Scenario:** Verify BGInfo is working after initial deployment

**Create verification job:**
```powershell
# Step 1: Deploy BGInfo (as SYSTEM)
.\Deploy-BGInfo.ps1

# Step 2: Wait for deployment to complete
Start-Sleep -Seconds 10

# Step 3: Refresh wallpaper (as User)
.\Refresh-BGInfo.ps1

# Step 4: Verify wallpaper changed
# (Manual verification or screenshot capture)
```

## Best Practices

### Execution Context

✅ **Always run as User** - This script needs user context to update wallpaper
❌ **Never run as SYSTEM** - SYSTEM context can't update user wallpapers

### Scheduling

✅ **Schedule during business hours** - Users will see the update
✅ **Avoid excessive frequency** - Daily or weekly is sufficient
❌ **Don't run every hour** - Unnecessary and may impact performance

### Silent Mode

✅ **Use `-Silent` for scheduled tasks** - Reduces log noise
✅ **Omit `-Silent` for troubleshooting** - See detailed output
❌ **Don't use `-Silent` when testing** - You'll miss error messages

### Integration

✅ **Combine with Deploy-BGInfo.ps1** - Deploy first, then refresh
✅ **Add to user login policies** - Ensures fresh info at logon
✅ **Create user-accessible shortcuts** - Empower users to refresh themselves

## Integration with Deploy-BGInfo.ps1

### Deployment Workflow

**Step 1: Initial Deployment (as SYSTEM)**
```powershell
# Deploy BGInfo to device
.\Deploy-BGInfo.ps1
```

**Step 2: User Context Refresh (as User)**
```powershell
# Refresh for currently logged-in users
.\Refresh-BGInfo.ps1
```

### Datto RMM Job Sequence

**Create multi-step job:**
1. **Job 1:** Deploy BGInfo (SYSTEM context)
   - Component: `Deploy BGInfo`
   - Context: SYSTEM

2. **Job 2:** Refresh wallpaper (User context)
   - Component: `Refresh BGInfo Wallpaper`
   - Context: User
   - Delay: 15 seconds after Job 1

**Note:** Datto RMM components cannot directly sequence jobs, but you can create separate Quick Jobs and run them in sequence.

## Monitoring & Alerts

### Success Monitoring

**Create Datto RMM monitor:**
- Component: `Refresh BGInfo Wallpaper`
- Schedule: Daily at 8:00 AM
- Alert on: Exit code ≠ 0
- Notification: Email to IT team

### Failure Alerts

**Alert on exit code 1 or 2:**
- Indicates BGInfo not installed
- Trigger: Run `Deploy-BGInfo.ps1` automatically

**Alert on exit code 3:**
- Indicates execution failure
- Action: Manual investigation required

## Quick Reference

### Common Commands

| Task | Command |
|------|---------|
| Basic refresh | `.\Refresh-BGInfo.ps1` |
| Custom path | `.\Refresh-BGInfo.ps1 -BGInfoPath "C:\Tools\BGInfo"` |
| Silent mode | `.\Refresh-BGInfo.ps1 -Silent` |
| Verify installation | `Test-Path "C:\MCC\BGInfo\BGInfo.exe"` |
| Manual BGInfo run | `& "C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt` |

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Executable not found |
| 2 | Configuration not found |
| 3 | Execution failed |
| 99 | Unexpected error |

## Related Documentation

- **Deployment Guide:** [DEPLOYMENT-GUIDE.md](DEPLOYMENT-GUIDE.md)
- **Main Documentation:** [README.md](README.md)
- **Troubleshooting:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Main Script:** `Deploy-BGInfo.ps1`

## Support

For deployment issues, see `Deploy-BGInfo.ps1` documentation.
For BGInfo configuration, see [Microsoft Sysinternals BGInfo](https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo).
