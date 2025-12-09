# BGInfo Configuration Guide

## Overview

BGInfo is a Sysinternals utility that displays system information on the Windows desktop background. This guide covers the BGInfo implementation in the Config-Server.ps1 script and provides information about configuring BGInfo.

## What Was Added to Config-Server.ps1

### New Function: Install-BGInfo

The `Install-BGInfo` function (Step 6 in the configuration process) performs the following tasks:

1. **Creates Directory Structure**
   - Creates `C:\Tools\BGInfo\` directory
   - All BGInfo files are stored in this location

2. **Downloads BGInfo**
   - Downloads BGInfo64.exe from: https://live.sysinternals.com/Bginfo64.exe
   - Uses TLS 1.2 for secure connection
   - Skips download if already present

3. **Configuration File Handling**
   - BGInfo .bgi files use proprietary binary format
   - Initial installation uses BGInfo's built-in defaults
   - Creates ConfigNotes.txt with customization instructions

4. **Registry Configuration**
   - Registry Path: `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`
   - Registry Name: `BGInfo`
   - Registry Value: `"C:\Tools\BGInfo\Bginfo64.exe" /timer:0 /silent /nolicprompt /accepteula`
   - Applies to all users (HKLM instead of HKCU)

5. **Immediate Application**
   - Runs BGInfo immediately to update desktop
   - Also runs automatically at every user logon

## BGInfo Configuration Files

### About .bgi Files

BGInfo configuration files (.bgi) use a **proprietary binary format** that cannot be created with simple text editing or PowerShell commands. The format includes:

- Field definitions and order
- Display properties (font, color, position)
- Background settings
- Custom field definitions
- WMI query configurations

### Default Fields (When No Config File Exists)

When BGInfo runs without a configuration file, it displays:

- **Host Name** - Computer name
- **IP Address** - All IP addresses
- **Subnet Mask** - Network subnet mask
- **Default Gateway** - Network gateway
- **DHCP Server** - DHCP server address
- **DNS Servers** - DNS server addresses
- **MAC Address** - Network adapter MAC
- **OS Version** - Windows version
- **Service Pack** - Service pack level
- **Boot Time** - Last system boot time
- **Logon Server** - Domain controller
- **User Name** - Currently logged-in user
- **CPU** - Processor information
- **Total RAM** - Total system memory
- **Available RAM** - Free memory
- **Volumes** - All drives with free space

### Creating Custom Configurations

There are three methods to create custom BGInfo configurations:

#### Method 1: Use BGInfo GUI (Recommended)

```powershell
# Launch BGInfo for configuration
C:\Tools\BGInfo\Bginfo64.exe

# Steps:
# 1. Adjust fields (Add/Remove using Fields button)
# 2. Configure appearance (font, colors, position)
# 3. Click "File" > "Save As"
# 4. Save to: C:\Tools\BGInfo\config.bgi
# 5. Click "OK" to apply
```

#### Method 2: Use Helper Scripts

The repository includes helper scripts:

```powershell
# Generate configuration helper files
.\bginfo-example-generator.ps1

# This creates:
# - BGInfo-Configuration-Guide.txt
# - Launch-BGInfo-Config.ps1
# - Apply-BGInfo-Default.ps1
```

#### Method 3: Use Default Configuration

Simply run BGInfo without a config file:

```powershell
C:\Tools\BGInfo\Bginfo64.exe /timer:0 /silent /nolicprompt /accepteula
```

## BGInfo Command-Line Parameters

### Essential Parameters

| Parameter | Description | Usage |
|-----------|-------------|-------|
| `/timer:N` | Countdown in seconds before applying | `/timer:0` for immediate |
| `/silent` | Don't display configuration dialog | Always use for automation |
| `/nolicprompt` | Suppress license prompt | Required for automation |
| `/accepteula` | Auto-accept license agreement | Required for first run |

### Additional Parameters

| Parameter | Description |
|-----------|-------------|
| `/all` | Apply to all users (requires config file) |
| `/popup` | Display in popup window instead of desktop |
| `/rtf:<path>` | Write output to RTF file |
| `/taskbar` | Place in taskbar notification area |

## Registry Configuration

### HKLM vs HKCU

The script uses **HKLM** (Local Machine) to apply BGInfo for all users:

```powershell
# Apply to all users (recommended for servers)
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$registryName = "BGInfo"
$registryValue = '"C:\Tools\BGInfo\Bginfo64.exe" /timer:0 /silent /nolicprompt /accepteula'
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type String
```

To apply only to current user:

```powershell
# Apply to current user only
$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
```

## Customization Examples

### Minimal Field Configuration

For a cleaner look with fewer fields:

1. Run BGInfo GUI
2. Remove unwanted fields
3. Keep only:
   - Host Name
   - IP Address
   - OS Version
   - Boot Time
   - User Name
   - CPU
   - Total RAM
   - Volume C:\

### Custom WMI Fields

BGInfo supports custom fields using WMI queries:

1. Click "Custom" button in BGInfo
2. Add custom field with WMI query
3. Example queries:
   - Computer manufacturer: `SELECT Manufacturer FROM Win32_ComputerSystem`
   - BIOS version: `SELECT SMBIOSBIOSVersion FROM Win32_BIOS`
   - Windows install date: `SELECT InstallDate FROM Win32_OperatingSystem`

### Appearance Customization

Recommended settings for servers:

- **Position**: Top-Left or Center
- **Font**: Tahoma, 11pt (readable but not intrusive)
- **Text Color**: Yellow or White (visible on most backgrounds)
- **Background**: Use existing wallpaper
- **Transparency**: Enable for better aesthetics

## Troubleshooting

### BGInfo Doesn't Appear

1. Check if BGInfo is running: `Get-Process Bginfo*`
2. Verify registry entry: `Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name BGInfo`
3. Check position settings (may be off-screen on multi-monitor setups)

### Fields Show as Blank

1. Verify WMI service is running: `Get-Service Winmgmt`
2. Check network connectivity for network-related fields
3. Run BGInfo manually to see error messages

### BGInfo Won't Run at Logon

1. Verify registry entry exists and is correct
2. Check file paths are valid (no spaces without quotes)
3. Ensure BGInfo64.exe exists at specified path
4. Check Group Policy isn't blocking Run registry keys

### Remove BGInfo

```powershell
# Remove registry entry
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo"

# Stop current instance
Stop-Process -Name Bginfo64 -Force -ErrorAction SilentlyContinue

# Optionally delete files
Remove-Item -Path "C:\Tools\BGInfo" -Recurse -Force
```

## Files Created by Config-Server.ps1

After running Config-Server.ps1, the following structure is created:

```
C:\Tools\BGInfo\
├── Bginfo64.exe          # BGInfo executable
└── ConfigNotes.txt       # Configuration instructions
```

After creating a custom configuration:

```
C:\Tools\BGInfo\
├── Bginfo64.exe          # BGInfo executable
├── config.bgi            # Your custom configuration
└── ConfigNotes.txt       # Configuration instructions
```

## Helper Scripts Included

### 1. Create-BGInfoConfig.ps1

Creates BGInfo configuration with guidance and helper files.

```powershell
# Run with defaults
.\Create-BGInfoConfig.ps1

# Run interactively (launches GUI)
.\Create-BGInfoConfig.ps1 -Interactive

# Custom output path
.\Create-BGInfoConfig.ps1 -OutputPath "D:\Custom\mybginfo.bgi"
```

### 2. bginfo-example-generator.ps1

Generates helper scripts and comprehensive documentation.

```powershell
# Generate helper files
.\bginfo-example-generator.ps1

# Creates:
# - BGInfo-Configuration-Guide.txt (comprehensive guide)
# - Launch-BGInfo-Config.ps1 (quick launcher)
# - Apply-BGInfo-Default.ps1 (apply defaults)
```

## Security Considerations

1. **Download Source**: BGInfo is downloaded from official Microsoft Sysinternals site
2. **TLS 1.2**: Script enforces TLS 1.2 for secure download
3. **Auto-Execution**: BGInfo runs at logon for all users (HKLM registry)
4. **No Elevation**: BGInfo runs in user context (no admin required at logon)
5. **Information Disclosure**: Be aware BGInfo displays system info on desktop

## Best Practices

1. **Test Configuration**: Always test custom configurations before deploying
2. **Backup Configs**: Save custom .bgi files to version control or backup location
3. **Document Fields**: Keep notes on custom fields and WMI queries used
4. **Consider Privacy**: Be mindful of displaying sensitive information
5. **Update Regularly**: Check for BGInfo updates periodically
6. **Use Defaults**: Default configuration is suitable for most scenarios

## Additional Resources

- **BGInfo Documentation**: https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo
- **Sysinternals Suite**: https://docs.microsoft.com/en-us/sysinternals/
- **WMI Query Reference**: https://docs.microsoft.com/en-us/windows/win32/wmisdk/

## Version History

- **v1.0**: Initial implementation in Config-Server.ps1
  - Auto-download BGInfo64.exe
  - Registry configuration for all users
  - Default configuration support
  - Helper scripts and documentation
