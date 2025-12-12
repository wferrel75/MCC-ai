# BGInfo Deployment Scripts for Datto RMM

## Overview

A set of PowerShell scripts designed for deploying and managing BGInfo (Sysinternals) through Datto RMM. These scripts automate the installation, configuration, and execution of BGInfo on Windows systems, displaying system information on desktop wallpapers.

### Scripts Included

1. **Deploy-BGInfo.ps1** (v1.1.2) - Main deployment script (runs as SYSTEM)
2. **Refresh-BGInfo.ps1** (v1.0.0) - Wallpaper refresh script (runs as USER)

---

## Deploy-BGInfo.ps1

Main deployment script for installing BGInfo on devices.

**Current Version:** 1.1.2

## Features

- **Automatic Architecture Detection** - Detects 32-bit or 64-bit Windows and downloads the appropriate BGInfo executable
- **Intelligent Fallback Mechanism** - Falls back to local BGInfo copies if download fails
- **Smart Configuration Selection** - Automatically selects custom .bgi files, preferring non-default configurations
- **Multi-User Support** - Executes BGInfo in all currently logged-in user sessions when run as SYSTEM
- **Registry Autorun** - Configures BGInfo to run silently at every user logon
- **Comprehensive Logging** - Detailed logs for monitoring and troubleshooting in Datto RMM
- **Exit Codes** - Specific exit codes for easy monitoring and alerting

## Requirements

- **PowerShell:** 5.1 or higher
- **Privileges:** Administrator/SYSTEM account
- **OS:** Windows 7/Server 2008 R2 or newer
- **Network:** Internet access for downloading BGInfo (optional if using local fallback)

## Quick Start

### Basic Deployment via Datto RMM

1. Upload the following files to a Datto RMM component:
   - `Deploy-BGInfo.ps1`
   - Your custom `.bgi` configuration file
   - (Optional) `Bginfo64.exe` and/or `Bginfo.exe` for offline deployment

2. Create a component or Quick Job in Datto RMM

3. Run the script (defaults to `C:\MCC\BGInfo`):
   ```powershell
   .\Deploy-BGInfo.ps1
   ```

## Parameters

### `-DestinationPath`
- **Type:** String
- **Default:** `C:\MCC\BGInfo`
- **Description:** Target directory for BGInfo installation

**Example:**
```powershell
.\Deploy-BGInfo.ps1 -DestinationPath "C:\Tools\BGInfo"
```

### `-DownloadTimeout`
- **Type:** Integer
- **Default:** 30 (seconds)
- **Range:** 10-300 seconds
- **Description:** Timeout for web downloads from Sysinternals Live

**Example:**
```powershell
.\Deploy-BGInfo.ps1 -DownloadTimeout 60
```

## Exit Codes

The script uses specific exit codes for monitoring in Datto RMM:

| Exit Code | Description |
|-----------|-------------|
| 0 | Success - BGInfo deployed and configured successfully |
| 1 | Failed to create destination directory |
| 2 | Failed to obtain BGInfo executable (download and fallback both failed) |
| 3 | Failed to obtain BGInfo configuration file (.bgi file not found) |
| 4 | Failed to create registry autorun entry |
| 5 | Failed to execute BGInfo for logged-in users |
| 99 | Generic/unexpected failure |

## Configuration Files (.bgi)

### File Selection Priority

The script searches for `.bgi` files in the script execution directory with the following priority:

1. **First preference:** Any `.bgi` file NOT named `default.bgi`
2. **Second preference:** `default.bgi` if no other `.bgi` files exist
3. **Error:** If no `.bgi` files are found, the script exits with code 3

### Creating Custom .bgi Files

1. Download and run BGInfo manually from [Sysinternals](https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo)
2. Configure the desired fields, layout, colors, and position
3. Click "File" → "Save As" and save your configuration as `custom.bgi`
4. Upload this `.bgi` file alongside the deployment script in Datto RMM

## How It Works

### Deployment Process

The script follows these steps:

1. **Create Destination Directory**
   - Creates `C:\MCC\BGInfo` (or custom path)
   - Ensures directory exists before proceeding

2. **Detect OS Architecture**
   - Determines if Windows is 32-bit (x86) or 64-bit (x64)
   - Selects appropriate BGInfo executable

3. **Obtain BGInfo Executable**
   - **Primary:** Downloads from Sysinternals Live
     - 64-bit: `https://live.sysinternals.com/Bginfo64.exe`
     - 32-bit: `https://live.sysinternals.com/Bginfo.exe`
   - **Fallback:** Copies from script directory if download fails

4. **Deploy Configuration File**
   - Searches for `.bgi` files in script directory
   - Prefers non-default configurations
   - Copies selected config to destination

5. **Configure Registry Autorun**
   - Creates entry in `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`
   - Key name: `BGInfo`
   - Command: `"C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt`

6. **Execute BGInfo Immediately**
   - Queries for all logged-in users
   - Launches BGInfo in each user's session context
   - Updates wallpaper immediately (no reboot required)

### Multi-User Execution

When run as SYSTEM (typical for Datto RMM):
- Uses `quser` to enumerate all logged-in users
- Creates BGInfo processes in each user session via WMI
- Handles multiple concurrent sessions (local console + RDP)
- Gracefully handles scenarios with no logged-in users

## File Structure

### Deployment Package

```
[Datto RMM Component]/
├── Deploy-BGInfo.ps1           # Main deployment script
├── custom.bgi                  # Your custom BGInfo configuration (preferred)
├── default.bgi                 # Fallback configuration (optional)
├── Bginfo64.exe               # 64-bit executable for offline deployment (optional)
└── Bginfo.exe                 # 32-bit executable for offline deployment (optional)
```

### Installed Structure

```
C:\MCC\BGInfo\
├── BGInfo.exe                 # BGInfo executable
└── BGInfo.bgi                # BGInfo configuration
```

## Usage Examples

### Example 1: Basic Deployment
```powershell
.\Deploy-BGInfo.ps1
```
Deploys BGInfo to default location (`C:\MCC\BGInfo`) with 30-second download timeout.

### Example 2: Custom Location
```powershell
.\Deploy-BGInfo.ps1 -DestinationPath "C:\Tools\BGInfo"
```
Deploys BGInfo to `C:\Tools\BGInfo` instead of default location.

### Example 3: Extended Timeout
```powershell
.\Deploy-BGInfo.ps1 -DownloadTimeout 60
```
Uses 60-second timeout for slow network connections.

### Example 4: Offline Deployment
```powershell
# Upload Bginfo64.exe and Bginfo.exe with the script
.\Deploy-BGInfo.ps1
```
Script will use local executables if internet download fails.

### Example 5: WhatIf Mode (Testing)
```powershell
.\Deploy-BGInfo.ps1 -WhatIf -Verbose
```
Tests the deployment without making actual changes (shows what would happen).

## Datto RMM Integration

### Component Setup

1. **Create New Component:**
   - Name: "Deploy BGInfo"
   - Type: PowerShell Script

2. **Upload Files:**
   - Main script: `Deploy-BGInfo.ps1`
   - Config file: Your `.bgi` configuration
   - (Optional) BGInfo executables for offline deployment

3. **Configure Monitoring:**
   - Success: Exit code = 0
   - Warning: Exit code = 5 (execution failed but autorun configured)
   - Failure: Exit codes 1-4, 99

### Quick Job Deployment

1. Navigate to Devices → Select Device(s)
2. Create Quick Job → PowerShell Script
3. Upload `Deploy-BGInfo.ps1` and `.bgi` file
4. Run job
5. Monitor results via exit codes and logs

### Scheduled Deployment

- Recommended to run once during device onboarding
- Can be re-run to update configuration or executable
- Safe to run multiple times (idempotent)

## Registry Configuration

### Autorun Entry

**Path:** `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`

**Value Name:** `BGInfo`

**Value Type:** `REG_SZ` (String)

**Value Data:** `"C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt`

### BGInfo Command Line Flags

- `/timer:0` - Display immediately and exit (no countdown)
- `/silent` - Suppress all dialogs
- `/nolicprompt` - Don't prompt for license acceptance

## Logging

### Log Format

```
[YYYY-MM-DD HH:MM:SS] [LEVEL] Message
```

**Log Levels:**
- `INFO` - Informational messages
- `SUCCESS` - Successful operations
- `WARNING` - Non-critical issues
- `ERROR` - Critical failures

### Sample Output

```
========== BGInfo Deployment Started ==========
[2025-12-10 15:39:45] [INFO] Script Path: C:\ProgramData\CentraStage\Packages\...
[2025-12-10 15:39:45] [INFO] Destination Path: C:\MCC\BGInfo
[2025-12-10 15:39:45] [INFO] PowerShell Version: 5.1.19041.4894
[2025-12-10 15:39:45] [INFO] Step 1: Creating destination directory...
[2025-12-10 15:39:45] [SUCCESS] Created directory: C:\MCC\BGInfo
[2025-12-10 15:39:45] [INFO] Step 2: Detecting OS architecture...
[2025-12-10 15:39:45] [INFO] Detected OS Architecture: x64
[2025-12-10 15:39:45] [INFO] Step 3: Obtaining BGInfo executable...
[2025-12-10 15:39:45] [INFO] Attempting to download BGInfo from https://live.sysinternals.com/Bginfo64.exe...
[2025-12-10 15:39:47] [SUCCESS] Successfully downloaded BGInfo to C:\MCC\BGInfo\BGInfo.exe
[2025-12-10 15:39:47] [INFO] Step 4: Obtaining BGInfo configuration file...
[2025-12-10 15:39:47] [INFO] Selected preferred configuration file: corporate.bgi
[2025-12-10 15:39:47] [SUCCESS] Successfully deployed configuration file to C:\MCC\BGInfo\BGInfo.bgi
[2025-12-10 15:39:47] [INFO] Step 5: Creating registry autorun entry...
[2025-12-10 15:39:47] [SUCCESS] Successfully created registry autorun entry
[2025-12-10 15:39:47] [INFO] Step 6: Executing BGInfo immediately...
[2025-12-10 15:39:47] [INFO] Querying for logged-in users...
[2025-12-10 15:39:47] [INFO] Found 1 logged-in user(s)
[2025-12-10 15:39:47] [INFO] Executing BGInfo for user 'jsmith' in session 2...
[2025-12-10 15:39:48] [SUCCESS] BGInfo launched successfully for user 'jsmith' (PID: 5432)
[2025-12-10 15:39:48] [SUCCESS] Successfully executed BGInfo for 1 of 1 user(s)
========== BGInfo Deployment Completed Successfully ==========
```

## Best Practices

### Configuration Management

1. **Test .bgi files** before deploying to production
2. **Use descriptive filenames** for custom configs (e.g., `corporate.bgi`, `helpdesk.bgi`)
3. **Avoid `default.bgi`** as the filename for custom configurations
4. **Version control** your .bgi files for change tracking

### Deployment Strategy

1. **Test on pilot group** before organization-wide deployment
2. **Include offline executables** for air-gapped or restricted networks
3. **Monitor exit codes** in Datto RMM for deployment success
4. **Schedule during maintenance windows** if deploying to production servers

### Security Considerations

1. **Review .bgi contents** before deployment (they're XML files)
2. **Avoid displaying sensitive information** in BGInfo (passwords, keys, etc.)
3. **Use HTTPS sources** for downloads (Sysinternals Live uses HTTPS)
4. **Validate script integrity** before uploading to Datto RMM

## Troubleshooting

For detailed troubleshooting steps, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

### Quick Diagnostics

**Check installation:**
```powershell
Test-Path "C:\MCC\BGInfo\BGInfo.exe"
Test-Path "C:\MCC\BGInfo\BGInfo.bgi"
```

**Check registry entry:**
```powershell
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo"
```

**Check logged-in users:**
```powershell
quser
```

**Manual execution:**
```powershell
& "C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt
```

---

## Refresh-BGInfo.ps1

Companion script for refreshing BGInfo wallpaper on-demand.

**Current Version:** 1.0.0

### Purpose

This lightweight script forces BGInfo to update the desktop wallpaper immediately. Unlike `Deploy-BGInfo.ps1` which runs as SYSTEM, this script **runs in user context**.

### Quick Start

```powershell
# Basic usage
.\Refresh-BGInfo.ps1

# Custom path
.\Refresh-BGInfo.ps1 -BGInfoPath "C:\Tools\BGInfo"

# Silent mode (for scheduled tasks)
.\Refresh-BGInfo.ps1 -Silent
```

### Use Cases

- **Force immediate refresh** after configuration changes
- **Restore wallpaper** if overwritten by Group Policy
- **Scheduled periodic updates** to keep info current
- **Manual on-demand refresh** for troubleshooting

### Datto RMM Usage

**Important:** Must run in **USER context**, not SYSTEM!

1. Create component or Quick Job
2. Upload `Refresh-BGInfo.ps1`
3. Set execution context to **User**
4. Run on-demand or schedule

### Exit Codes

- **0** - Success
- **1** - BGInfo executable not found
- **2** - Configuration file not found
- **3** - BGInfo execution failed
- **99** - Unexpected error

### Documentation

For detailed usage, scheduling, and troubleshooting, see [REFRESH-GUIDE.md](REFRESH-GUIDE.md)

---

## Version History

### Deploy-BGInfo.ps1

### 1.1.2 (2025-12-11)
- Fixed WMI class invocation to use `[wmiclass]` instead of `Get-WmiObject`

### 1.1.1 (2025-12-11)
- Fixed WMI/CIM API mixing error in Invoke-BGInfoAsUser function

### 1.1.0 (2025-12-10)
- Added multi-user support - BGInfo now executes in all logged-in user sessions
- Improved SYSTEM context execution for Datto RMM deployments
- Added `Get-LoggedInUsers` and `Invoke-BGInfoAsUser` functions

### 1.0.1 (2025-12-10)
- Fixed Write-Output pipeline pollution in logging function
- Improved function return value handling

### 1.0.0 (2025-12-10)
- Initial release
- Basic deployment functionality
- Download with local fallback
- Registry autorun configuration
- Datto RMM integration

### Refresh-BGInfo.ps1

### 1.0.0 (2025-12-11)
- Initial release
- User-context wallpaper refresh
- Silent mode support
- Custom path support
- Datto RMM integration

## Support & Resources

### Project Documentation
- **Main README:** [README.md](README.md) - This file
- **Deployment Guide:** [DEPLOYMENT-GUIDE.md](DEPLOYMENT-GUIDE.md) - Step-by-step deployment instructions
- **Refresh Guide:** [REFRESH-GUIDE.md](REFRESH-GUIDE.md) - Wallpaper refresh script documentation
- **Troubleshooting:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues and solutions

### Scripts
- **Deploy-BGInfo.ps1** - Main deployment script (SYSTEM context)
- **Refresh-BGInfo.ps1** - Wallpaper refresh script (USER context)

### Official Documentation
- [BGInfo on Microsoft Docs](https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo)
- [Sysinternals Live](https://live.sysinternals.com/)
- [Datto RMM Documentation](https://rmm.datto.com/help)

## License

This script is provided as-is for use with Datto RMM deployments. BGInfo is a Microsoft Sysinternals utility and subject to the [Sysinternals Software License Terms](https://docs.microsoft.com/en-us/sysinternals/license-terms).
