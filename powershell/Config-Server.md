# Config-Server.ps1 Documentation

## Overview
First-boot configuration script for Windows Server environments. This script automates common initial setup tasks to prepare a server for production use.

**Script Version:** 1.0
**Last Updated:** 2025-11-17
**PowerShell Version Required:** 5.1 or higher
**Execution Context:** Administrator privileges required

## Purpose
Automates the following first-boot server configuration tasks:
1. Disable Server Manager auto-start at login
2. Enable Remote Desktop Protocol (RDP) for remote management
3. Configure Windows Firewall to allow RDP connections
4. Rename the computer with validation
5. Set system timezone to Central Standard Time
6. Install and configure BGInfo for system information display

---

## Configuration Settings

### 1. Server Manager Auto-Start Disable

**Purpose:** Prevents Server Manager from automatically launching when administrators log in, reducing resource usage and login delays.

**Registry Modifications:**
- **Path:** `HKLM:\SOFTWARE\Microsoft\ServerManager`
- **Value Name:** `DoNotOpenServerManagerAtLogon`
- **Value Type:** `DWORD`
- **Value Data:** `1` (Disabled)

**Impact:**
- Takes effect at next login
- No reboot required
- Administrators can still launch Server Manager manually

---

### 2. Remote Desktop (RDP) Configuration

**Purpose:** Enables remote management capabilities via Remote Desktop Protocol.

**Registry Modifications:**

#### Enable RDP
- **Path:** `HKLM:\System\CurrentControlSet\Control\Terminal Server`
- **Value Name:** `fDenyTSConnections`
- **Value Type:** `DWORD`
- **Value Data:** `0` (Allow connections)

#### Network Level Authentication (NLA)
- **Path:** `HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp`
- **Value Name:** `UserAuthentication`
- **Value Type:** `DWORD`
- **Value Data:** `1` (Enabled)

**Security Notes:**
- Network Level Authentication provides enhanced security by requiring authentication before establishing a full RDP session
- Helps protect against certain types of denial-of-service attacks
- Requires client computers to support NLA (Windows Vista/Server 2008 and later)

**Impact:**
- Takes effect immediately
- No reboot required
- Server becomes accessible via RDP on port 3389 (default)

---

### 3. Windows Firewall Configuration

**Purpose:** Opens necessary firewall ports to allow Remote Desktop connections through Windows Firewall.

**Firewall Rules Modified:**
- **Rule Group:** "Remote Desktop"
- **Action:** Enable all rules in the group
- **Cmdlet Used:** `Enable-NetFirewallRule -DisplayGroup "Remote Desktop"`

**Affected Rules (typical):**
- Remote Desktop - User Mode (TCP-In)
- Remote Desktop - User Mode (UDP-In)
- Remote Desktop - Shadow (TCP-In)

**Ports Opened:**
- TCP 3389 (RDP)
- UDP 3389 (RDP)

**Impact:**
- Takes effect immediately
- No reboot required
- Does not disable Windows Firewall, only enables specific rules

---

### 4. Computer Rename

**Purpose:** Sets a meaningful, standardized computer name for the server.

**Process:**
1. Displays current computer name
2. Prompts user for new computer name
3. Validates input against Windows naming conventions
4. Requires user confirmation before applying

**Validation Rules:**
- Maximum length: 15 characters
- Allowed characters: Letters (A-Z, a-z), numbers (0-9), hyphens (-)
- Pattern: `^[a-zA-Z0-9-]+$`
- No spaces or special characters allowed

**System Modifications:**
- Uses `Rename-Computer` cmdlet
- Updates both computer name and NetBIOS name
- Modifies multiple registry locations (handled by Windows)

**Impact:**
- **Reboot Required:** Yes (mandatory for name change to take effect)
- Network identity changes after reboot
- May affect domain membership (if applicable)
- Active Directory computer object may need updating

**User Options:**
- Can skip renaming by pressing Enter
- Can cancel after entering name
- Can defer reboot

---

### 5. Timezone Configuration

**Purpose:** Standardizes server time to Central Standard Time (US & Canada) for consistency.

**Timezone Setting:**
- **Timezone ID:** `Central Standard Time`
- **Display Name:** `(UTC-06:00) Central Time (US & Canada)`
- **Cmdlet Used:** `Set-TimeZone -Id "Central Standard Time"`

**Behavior:**
- Checks current timezone before applying
- Skips change if already set to Central Standard Time
- Automatically handles Daylight Saving Time transitions

**Impact:**
- Takes effect immediately
- No reboot required
- Affects system time, event log timestamps, scheduled tasks
- May affect time-sensitive applications

---

### 6. BGInfo Installation and Configuration

**Purpose:** Automatically displays system information on the desktop wallpaper for quick reference and identification.

**What is BGInfo:**
BGInfo is a Microsoft Sysinternals utility that displays system configuration information on the desktop background. This is particularly useful for:
- Quick server identification in RDP sessions
- Monitoring system resource usage at a glance
- Compliance and documentation purposes
- Distinguishing between multiple servers

**Installation Details:**

#### Download Source
- **URL:** https://live.sysinternals.com/Bginfo64.exe
- **Publisher:** Microsoft Sysinternals
- **File:** Bginfo64.exe (64-bit version)

#### Installation Directory
- **Path:** `C:\Tools\BGInfo\`
- **Files Created:**
  - `Bginfo64.exe` - Main executable
  - `ConfigNotes.txt` - Configuration instructions
  - `config.bgi` - Configuration file (if created)

**Registry Modifications:**

#### Auto-Start at Logon (All Users)
- **Path:** `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`
- **Value Name:** `BGInfo`
- **Value Type:** `REG_SZ` (String)
- **Value Data:** `"C:\Tools\BGInfo\Bginfo64.exe" /timer:0 /silent /nolicprompt /accepteula`

**Command-Line Parameters:**
- `/timer:0` - Apply settings immediately (no countdown)
- `/silent` - Suppress configuration dialog
- `/nolicprompt` - Don't prompt for license acceptance
- `/accepteula` - Automatically accept end-user license agreement

**Default Information Displayed:**
When no custom configuration file exists, BGInfo displays standard fields including:
- Computer Name
- IP Address(es)
- Subnet Mask / Default Gateway
- MAC Address
- OS Version & Build
- Service Pack level
- Boot Time / Uptime
- Logged On User
- CPU Information (Model, Speed, Cores)
- Total Physical Memory
- Available Memory
- Page File Usage
- Disk Volumes (Drive letters, Total/Free space)
- Network Adapter Information

**Configuration File (.bgi):**
- BGInfo configuration files use a **proprietary binary format**
- Cannot be created via PowerShell or text files
- Must be created using BGInfo GUI application
- Optional - if not present, BGInfo uses built-in defaults

**Creating Custom Configuration:**

Option 1 - Manual Configuration:
```powershell
# Launch BGInfo configuration GUI
C:\Tools\BGInfo\Bginfo64.exe

# After customizing:
# 1. Click "File" > "Save As"
# 2. Save to: C:\Tools\BGInfo\config.bgi
# 3. Close BGInfo (it will apply at next logon)
```

Option 2 - Use Helper Script:
```powershell
.\Create-BGInfoConfig.ps1 -Interactive
```

**Impact:**
- Takes effect immediately after installation
- Background wallpaper updated with system information
- Information refreshes at each logon
- No reboot required
- Applies to all users (HKLM registry location)

**Disk Space Requirements:**
- BGInfo executable: ~1 MB
- Configuration file: <1 KB
- Total directory size: ~1-2 MB

**Network Requirements:**
- Internet connection required for initial download
- Downloaded from: live.sysinternals.com (Microsoft domain)

**Customization Options:**
- Font size, color, and family
- Background color and transparency
- Position on screen (centered, top-left, etc.)
- Which fields to display
- Field order and formatting
- Custom fields using WMI queries
- Desktop wallpaper image (overlays on existing)

---

## Execution Requirements

### Prerequisites
- Windows Server operating system (any supported version)
- PowerShell 5.1 or higher
- Administrative privileges
- Local or domain administrator account
- Internet connection (for BGInfo download)

### Execution Policy
Script may require setting execution policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Running the Script
```powershell
# Navigate to script location
cd C:\Path\To\Script

# Run as Administrator
.\Config-Server.ps1
```

---

## Exit Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 0 | Success | All configuration steps completed successfully |
| 1 | Not Administrator | Script not running with administrative privileges |
| 2 | Critical Error | Unhandled exception during execution |

---

## Error Handling

### Graceful Degradation
- Non-critical failures do not stop script execution
- Each step wrapped in try-catch blocks
- Errors logged to console with clear messaging
- Script continues to attempt remaining steps

### User Notifications
- **Success Messages:** Green text with [SUCCESS] prefix
- **Error Messages:** Red text with [ERROR] prefix
- **Informational Messages:** Yellow text with [INFO] prefix
- **Step Headers:** Cyan text with separators

---

## Reboot Requirements

### Automatic Reboot Scenarios
The script will prompt for reboot if:
- Computer name is successfully changed

### Reboot Prompt Behavior
1. Displays reboot requirement warning
2. Asks user: "Would you like to reboot now? (Y/N)"
3. If Yes: 10-second countdown with option to cancel (Ctrl+C)
4. If No: Advises manual reboot when ready

### Manual Reboot Command
```powershell
Restart-Computer -Force
```

---

## Configuration Summary

| Setting | Default State | Configured State | Reboot Required |
|---------|--------------|------------------|-----------------|
| Server Manager Auto-Start | Enabled | Disabled | No |
| Remote Desktop | Disabled | Enabled (with NLA) | No |
| RDP Firewall Rules | Disabled | Enabled | No |
| Computer Name | Random/Default | User-specified | **Yes** |
| Timezone | Varies | Central Standard Time | No |
| BGInfo | Not Installed | Installed & Auto-Start | No |

---

## Security Considerations

### Enhanced Security Features
- Network Level Authentication required for RDP
- No automatic port forwarding (firewall rules only)
- No user account modifications
- No password changes
- Administrative approval required for computer rename

### Potential Security Impacts
- RDP enabled increases attack surface (ensure strong passwords)
- Firewall rules allow external connections (if server is internet-facing)
- NLA mitigates some RDP-based attacks

### Recommendations
- Use strong, complex passwords for all accounts
- Consider changing default RDP port (3389) if internet-facing
- Implement account lockout policies
- Enable Windows Defender or other endpoint protection
- Keep Windows Server updated with latest security patches

---

## Troubleshooting

### Common Issues

#### Script won't run
- **Cause:** Not running as Administrator
- **Solution:** Right-click PowerShell and select "Run as Administrator"

#### Server Manager still opens
- **Cause:** User not logged out/in since change
- **Solution:** Log out and log back in

#### Can't connect via RDP
- **Cause:** Firewall rules not enabled or network issue
- **Solution:** Manually enable firewall rules or check network connectivity

#### Computer rename fails
- **Cause:** Domain-joined computer or insufficient privileges
- **Solution:** Use domain admin account or remove from domain first

#### Timezone change fails
- **Cause:** Invalid timezone ID or GPO override
- **Solution:** Verify timezone ID or check Group Policy settings

#### BGInfo download fails
- **Cause:** No internet connection or firewall blocking
- **Solution:** Check internet connectivity, verify proxy settings, or manually download BGInfo from https://live.sysinternals.com/Bginfo64.exe

#### BGInfo not appearing on desktop
- **Cause:** Registry entry not created or BGInfo not executed
- **Solution:** Check registry at HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run for "BGInfo" entry, or manually run `C:\Tools\BGInfo\Bginfo64.exe`

#### BGInfo showing outdated information
- **Cause:** BGInfo only refreshes at logon by default
- **Solution:** Manually run BGInfo or configure a scheduled task for periodic refresh

---

## Maintenance Notes

### When to Update Documentation
This documentation file (`Config-Server.md`) must be updated whenever:
- Registry paths or values are modified in the script
- New configuration steps are added
- Existing configuration steps are removed
- Validation rules change
- Error handling behavior changes
- New parameters or options are added

### Version Control
- Document all changes in git commit messages
- Update "Last Updated" date in this file
- Increment script version if significant changes are made

---

## Related Files
- **Config-Server.ps1** - Main PowerShell script
- **Config-Server.md** - This documentation file (maintained in sync)
- **Create-BGInfoConfig.ps1** - Helper script for creating BGInfo configurations
- **bginfo-example-generator.ps1** - Generates BGInfo helper scripts and documentation
- **BGInfo-README.md** - Comprehensive BGInfo documentation and usage guide
- **Launch-BGInfo-Config.ps1** - Quick launcher for BGInfo GUI (generated)
- **Apply-BGInfo-Default.ps1** - Apply default BGInfo configuration (generated)
- **BGInfo-Configuration-Guide.txt** - Text-based BGInfo usage guide (generated)

---

## Support and Modification

### Customization Options
The script can be modified to:
- Use different timezone (change `$timeZoneId` variable)
- Skip specific configuration steps (comment out function calls)
- Add additional registry modifications
- Include custom validation rules
- Implement logging to file

### Future Enhancements (Potential)
- Support for custom firewall rules
- Windows Update configuration
- Network adapter configuration
- Disk initialization and formatting
- Role and feature installation
- Domain join automation
- Custom user account creation
- Logging to event log or file
- Pre-configured BGInfo templates for different server roles
- Scheduled BGInfo refresh task

---

## Changelog

### Version 1.1 (2025-11-17)
- Added BGInfo installation and configuration
- Downloads BGInfo64.exe from Microsoft Sysinternals
- Creates C:\Tools\BGInfo\ directory structure
- Configures auto-start at logon for all users
- Applies BGInfo immediately to desktop
- Includes helper scripts for custom configuration
- Comprehensive BGInfo documentation added

### Version 1.0 (2025-11-17)
- Initial release
- Server Manager auto-start disable
- Remote Desktop enablement with NLA
- Firewall configuration for RDP
- Interactive computer rename with validation
- Central Standard Time timezone configuration
- Comprehensive error handling
- Color-coded console output
- Reboot management
