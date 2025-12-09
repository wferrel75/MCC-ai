# RustDesk Windows Agent Deployment for DattoRMM

This guide provides instructions for deploying the RustDesk Windows agent to your managed endpoints using DattoRMM with automated configuration for self-hosted servers.

## Overview

The deployment script (`rustdesk-windows-deployment.ps1`) automates the following tasks:

1. **Downloads** the latest (or specified) RustDesk Windows installer (EXE or MSI)
2. **Installs** RustDesk silently without user interaction
3. **Configures** the agent to connect to your self-hosted RustDesk server
4. **Retrieves** and displays the RustDesk ID for remote access
5. **Optionally sets** a permanent password for unattended access
6. **Verifies** the service is running correctly

## Prerequisites

### Self-Hosted RustDesk Server

Before deploying to endpoints, you need:

1. **Self-hosted RustDesk server** (hbbs and hbbr) up and running
   - ID/Signal Server (hbbs) - typically on port 21116
   - Relay Server (hbbr) - typically on port 21117
   - Optional: API Server for RustDesk Pro - port 21114

2. **Server Public Key** from your RustDesk server
   - Located in the file `id_ed25519.pub` in your server's working directory
   - This is the encryption key (NOT your Pro license key)
   - Copy the entire key string for use in the component

### Getting Your Server Public Key

SSH into your RustDesk server and run:

```bash
cat ~/rustdesk-server/id_ed25519.pub
```

Or if using Docker:

```bash
docker exec rustdesk-hbbs cat /root/id_ed25519.pub
```

Copy the entire output string (e.g., `AbCdEfGh1234567890...`)

### Target Systems

- **Operating System**: Windows 10/11 or Windows Server 2016+
- **PowerShell**: Version 5.1 or higher
- **Permissions**: Administrator/SYSTEM privileges (automatic with DattoRMM)
- **Internet Access**: Required to download installer from GitHub

## DattoRMM Component Configuration

### Step 1: Create New Component

1. Log into your **DattoRMM** portal
2. Navigate to **Comodo** > **Components**
3. Click **New Component**
4. Select **Component Type**: PowerShell

### Step 2: Configure Component Details

| Field | Value |
|-------|-------|
| **Name** | RustDesk Agent Deployment |
| **Category** | Remote Access |
| **Description** | Deploys and configures RustDesk remote desktop agent for self-hosted server |
| **Enabled** | ✓ |

### Step 3: Add PowerShell Script

1. In the **Script** section, paste the entire contents of `rustdesk-windows-deployment.ps1`
2. Set **Execution Policy**: Bypass
3. Set **Run As**: System

### Step 4: Configure Component Variables

Create the following **Component Variables** to make the script reusable:

#### Required Variables

| Variable Name | Type | Description | Example Value |
|--------------|------|-------------|---------------|
| `RUSTDESK_SERVER_HOST` | Text | Your RustDesk server hostname or IP | `rustdesk.yourdomain.com` or `192.168.1.100` |
| `RUSTDESK_SERVER_KEY` | **Secure Text** | Public key from id_ed25519.pub file | `AbCdEfGh1234567890...` |

#### Optional Variables

| Variable Name | Type | Description | Example Value |
|--------------|------|-------------|---------------|
| `RUSTDESK_RELAY_SERVER` | Text | Relay server (if different from main server) | `relay.yourdomain.com` |
| `RUSTDESK_API_SERVER` | Text | API server URL (for Pro users) | `https://rustdesk.yourdomain.com:21114` |
| `RUSTDESK_PASSWORD` | **Secure Text** | Permanent password for unattended access | Leave empty for temporary passwords |
| `RUSTDESK_VERSION` | Text | Specific version to install | `1.4.4` (leave empty for latest) |
| `RUSTDESK_INSTALLER_TYPE` | Text | Installer type: 'exe' or 'msi' | `exe` (default) |
| `RUSTDESK_INSTALL_PATH` | Text | Custom install path (MSI only) | `C:\Program Files\RustDesk` |

### Step 5: Modify Script Parameters

At the top of the script in the DattoRMM editor, update the param block to use environment variables:

```powershell
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$ServerHost = $env:RUSTDESK_SERVER_HOST,

    [Parameter(Mandatory=$true)]
    [string]$ServerKey = $env:RUSTDESK_SERVER_KEY,

    [Parameter(Mandatory=$false)]
    [string]$RelayServer = $env:RUSTDESK_RELAY_SERVER,

    [Parameter(Mandatory=$false)]
    [string]$ApiServer = $env:RUSTDESK_API_SERVER,

    [Parameter(Mandatory=$false)]
    [string]$PermanentPassword = $env:RUSTDESK_PASSWORD,

    [Parameter(Mandatory=$false)]
    [string]$RustDeskVersion = $env:RUSTDESK_VERSION,

    [Parameter(Mandatory=$false)]
    [ValidateSet('exe', 'msi')]
    [string]$InstallerType = $(if ($env:RUSTDESK_INSTALLER_TYPE) { $env:RUSTDESK_INSTALLER_TYPE } else { 'exe' }),

    [Parameter(Mandatory=$false)]
    [string]$InstallPath = $(if ($env:RUSTDESK_INSTALL_PATH) { $env:RUSTDESK_INSTALL_PATH } else { "C:\Program Files\RustDesk" }),

    [Parameter(Mandatory=$false)]
    [bool]$CreateDesktopShortcut = $false,

    [Parameter(Mandatory=$false)]
    [bool]$CreateStartMenuShortcut = $true
)
```

### Step 6: Save Component

1. Click **Save** to create the component
2. The component is now ready for deployment

## Deployment Options

### Option A: One-Time Deployment (Quick Jobs)

For immediate deployment to specific devices:

1. Navigate to **Devices** in DattoRMM
2. Select target device(s)
3. Click **Quick Job**
4. Select **Component**: RustDesk Agent Deployment
5. Set component variables:
   - `RUSTDESK_SERVER_HOST`: Your server address
   - `RUSTDESK_SERVER_KEY`: Your public key
   - Optional: Set password, version, etc.
6. Click **Run**

### Option B: Scheduled Deployment (Policies)

For automated deployment across sites:

1. Navigate to **Policies**
2. Select or create a policy
3. Add **Component Job**:
   - Component: RustDesk Agent Deployment
   - Schedule: One-time or recurring
   - Variables: Set required values
4. Apply policy to target sites/devices

### Option C: Monitoring with Auto-Remediation

For continuous compliance:

1. Create a **Monitor** to check RustDesk service status:
   ```powershell
   $Service = Get-Service -Name "RustDesk" -ErrorAction SilentlyContinue
   if ($Service -and $Service.Status -eq "Running") {
       Write-Output "RustDesk is running"
       exit 0
   } else {
       Write-Output "RustDesk is not running"
       exit 1
   }
   ```

2. Set **Automated Remediation** to run the deployment component if the monitor fails

## Verification

After deployment, verify successful installation:

### Check via DattoRMM

1. Review **Component Results** in the device's activity log
2. Look for the deployment summary with:
   - `SUCCESS: RustDesk agent installed and configured`
   - RustDesk ID (9+ digit number)
   - Server configuration details
3. **IMPORTANT**: Copy the RustDesk ID from the output - you'll need this to connect remotely

### Check on Target Device

Run these commands on the target Windows device:

```powershell
# Check service status
Get-Service -Name "RustDesk"

# Check RustDesk ID
& "C:\Program Files\RustDesk\rustdesk.exe" --get-id

# View configuration file
Get-Content "$env:APPDATA\RustDesk\config\RustDesk2.toml"
```

### Test Remote Connection

1. Open RustDesk client on your workstation
2. Configure it to use the same self-hosted server
3. Enter the RustDesk ID from the deployed device
4. Enter the password (permanent password if set, or temporary if not)
5. Connect to verify functionality

## Configuration Methods Explained

### Method 1: Using --config Parameter (Used by This Script)

The script uses the command-line configuration method:

```
rustdesk.exe --config "host=SERVER,key=KEY"
```

This automatically configures the server settings without manual intervention.

### Method 2: Manual Configuration (Alternative)

If needed, you can manually configure via the RustDesk GUI:
1. Open RustDesk
2. Click the three dots (...) menu
3. Select **Network**
4. Enter:
   - **ID Server**: Your server hostname
   - **Relay Server**: Your relay server (usually same as ID server)
   - **Key**: Your public key
   - **API Server**: (Pro only) Your API server URL

## Troubleshooting

### Deployment Fails with "Download Error"

**Cause**: Network connectivity issue or GitHub is unreachable

**Solution**:
- Verify the target device has internet access
- Check firewall rules allow HTTPS to `github.com`
- Try specifying a specific version instead of "latest"
- Use `InstallerType = 'msi'` if EXE download fails

### Agent Installed but Cannot Connect

**Cause**: Incorrect server configuration or network issues

**Solution**:
- Verify `RUSTDESK_SERVER_HOST` is correct and accessible from the device
- Confirm `RUSTDESK_SERVER_KEY` matches your server's `id_ed25519.pub` file exactly
- Check firewall allows outbound connections to ports 21116 and 21117
- Verify your RustDesk server (hbbs and hbbr) are running
- Review logs at `C:\ProgramData\RustDesk\deployment.log`

### "Unable to Retrieve ID" Message

**Cause**: Service not fully started or configuration issue

**Solution**:
- Wait 30 seconds and manually run: `& "C:\Program Files\RustDesk\rustdesk.exe" --get-id`
- Restart RustDesk service: `Restart-Service RustDesk`
- Check service is running: `Get-Service RustDesk`
- Review Event Viewer for service errors

### Configuration Not Applied

**Cause**: RustDesk was running during configuration

**Solution**:
- The script stops the service before configuration, but if it fails:
  ```powershell
  Stop-Service RustDesk -Force
  & "C:\Program Files\RustDesk\rustdesk.exe" --config "host=YOUR_SERVER,key=YOUR_KEY"
  Start-Service RustDesk
  ```

### "Must be run as Administrator" Error

**Cause**: Script not running with elevated privileges

**Solution**:
- Ensure DattoRMM component is set to **Run As: System**
- DattoRMM should automatically provide admin rights
- If testing manually, right-click PowerShell and "Run as Administrator"

### Connection Works but Password Doesn't

**Cause**: Permanent password not set correctly

**Solution**:
- Verify `RUSTDESK_PASSWORD` variable is set
- Manually set password:
  ```powershell
  Stop-Service RustDesk
  & "C:\Program Files\RustDesk\rustdesk.exe" --password "YourPassword"
  Start-Service RustDesk
  ```
- Or use temporary passwords (leave RUSTDESK_PASSWORD empty)

## Logs and Diagnostics

The script generates logs in multiple locations:

| Log File | Purpose |
|----------|---------|
| `C:\ProgramData\RustDesk\deployment.log` | Main deployment script log |
| `%TEMP%\rustdesk_install.log` | MSI installer detailed log (MSI only) |
| `%APPDATA%\RustDesk\config\RustDesk2.toml` | RustDesk configuration file |

To retrieve logs via DattoRMM Quick Job:

```powershell
# Deployment log
Get-Content "C:\ProgramData\RustDesk\deployment.log" -Tail 50

# Configuration
Get-Content "$env:APPDATA\RustDesk\config\RustDesk2.toml"

# Service status
Get-Service RustDesk | Format-List *
```

## Advanced Configuration

### Installing Specific Version

Set the `RUSTDESK_VERSION` variable to a specific version:

```
RUSTDESK_VERSION=1.4.4
```

Available versions: [RustDesk Releases](https://github.com/rustdesk/rustdesk/releases)

### Using MSI Installer Instead of EXE

The MSI installer provides more control over installation:

```
RUSTDESK_INSTALLER_TYPE=msi
RUSTDESK_INSTALL_PATH=D:\Programs\RustDesk
```

MSI advantages:
- Custom installation directory
- Better integration with enterprise deployment tools
- Detailed installation logs
- Group Policy deployment support

### Generating Random Passwords

If you want to set random passwords per device, create a wrapper component:

```powershell
# Generate random password
$Password = -join ((33..126) | Get-Random -Count 16 | ForEach-Object {[char]$_})

# Set environment variable
$env:RUSTDESK_PASSWORD = $Password

# Run main deployment script
# ... (your deployment script here)

# Output password for DattoRMM to capture
Write-Output "GENERATED_PASSWORD=$Password"
```

### Multiple Server Configurations

You can create multiple components for different RustDesk servers:

- **RustDesk - Production Server** (using production server credentials)
- **RustDesk - Test Server** (using test server credentials)
- **RustDesk - Remote Sites** (using regional server credentials)

### Separate Relay Server

If your relay server (hbbr) is on a different host:

```
RUSTDESK_SERVER_HOST=id.rustdesk.example.com
RUSTDESK_RELAY_SERVER=relay.rustdesk.example.com
```

### RustDesk Pro with API Server

For RustDesk Pro deployments with web console:

```
RUSTDESK_SERVER_HOST=rustdesk.example.com
RUSTDESK_API_SERVER=https://rustdesk.example.com:21114
```

Or if using standard HTTPS port:

```
RUSTDESK_API_SERVER=https://rustdesk.example.com
```

## Security Considerations

### Password Management

**Permanent Passwords:**
- Pros: No need to retrieve temporary passwords
- Cons: Static credentials that could be compromised
- Best for: Servers and unattended systems

**Temporary Passwords:**
- Pros: Changes regularly, more secure
- Cons: Must retrieve password each time
- Best for: Workstations with occasional support needs

**Recommendations:**
- Use **Secure Text** variable type for passwords in DattoRMM
- Use strong passwords (16+ characters, mixed case, numbers, symbols)
- Rotate passwords periodically
- Store passwords in a password manager
- Consider using temporary passwords for workstations

### Network Security

- Ensure your RustDesk server uses TLS/SSL encryption
- Implement firewall rules to restrict access to RustDesk ports
- Use VPN or private networks when possible
- Monitor RustDesk server logs for unauthorized access attempts
- Keep RustDesk server and clients updated

### Access Control

- Use RustDesk Pro's access control features if available
- Implement network segmentation
- Regular audit of deployed agents
- Disable or uninstall RustDesk from decommissioned devices

### Key Management

- **Protect your server public key** - treat it as sensitive
- Use **Secure Text** variable type in DattoRMM
- Don't commit keys to version control
- Rotate server keys periodically (requires redeployment)

## Firewall Requirements

RustDesk requires the following network access:

### Client (Managed Endpoints)

| Direction | Protocol | Port | Destination | Purpose |
|-----------|----------|------|-------------|---------|
| Outbound | HTTPS | 443 | github.com | Download installer |
| Outbound | TCP | 21116 | Your RustDesk Server | ID/Signal server (hbbs) |
| Outbound | TCP | 21117 | Your RustDesk Server | Relay server (hbbr) |
| Outbound | TCP | 21114 | Your RustDesk Server | API server (Pro only) |
| Outbound | UDP | 21116 | Your RustDesk Server | Direct P2P connections |

### Server (Self-Hosted)

| Direction | Protocol | Port | Service | Purpose |
|-----------|----------|------|---------|---------|
| Inbound | TCP | 21116 | hbbs | ID/Signal server |
| Inbound | TCP | 21117 | hbbr | Relay server |
| Inbound | TCP | 21114 | hbbs | API server (Pro) |
| Inbound | TCP | 21115 | hbbs | NAT type test |
| Inbound | UDP | 21116 | hbbs | Direct connections |

## Collecting RustDesk IDs

To maintain an inventory of RustDesk IDs for all deployed devices, create a monitor component:

```powershell
# Get RustDesk ID
$RustDeskExe = "C:\Program Files\RustDesk\rustdesk.exe"

if (Test-Path $RustDeskExe) {
    $ID = & $RustDeskExe --get-id 2>&1

    if ($ID -match '\d{9,}') {
        Write-Output "RustDesk ID: $($matches[0])"
        exit 0
    } else {
        Write-Output "RustDesk installed but ID not available"
        exit 1
    }
} else {
    Write-Output "RustDesk not installed"
    exit 1
}
```

Set this as a **Data Gathering** monitor to collect IDs from all devices into DattoRMM.

## Updates and Maintenance

### Updating RustDesk Agents

To update all agents to a new version:

1. Update the `RUSTDESK_VERSION` variable to the desired version
2. Re-run the component on target devices
3. The script will install the new version over the existing one

Or leave `RUSTDESK_VERSION` empty to always get the latest:

```
RUSTDESK_VERSION=
```

### Monitoring for Updates

Create a monitoring script to check for outdated versions:

```powershell
$InstalledVersion = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
                     Where-Object { $_.DisplayName -like "*RustDesk*" }).DisplayVersion

# Get latest version from GitHub
$LatestVersion = (Invoke-RestMethod "https://api.github.com/repos/rustdesk/rustdesk/releases/latest").tag_name

# Compare versions
if ($InstalledVersion -lt $LatestVersion) {
    Write-Output "RustDesk outdated: $InstalledVersion (Latest: $LatestVersion)"
    exit 1
} else {
    Write-Output "RustDesk up to date: $InstalledVersion"
    exit 0
}
```

### Changing Server Configuration

If you need to point agents to a different server:

1. Update `RUSTDESK_SERVER_HOST` and `RUSTDESK_SERVER_KEY` variables
2. Re-run the component on affected devices
3. The script will reconfigure without reinstalling

## Uninstallation

To remove RustDesk from devices, create a separate component:

```powershell
# Stop and disable service
Stop-Service -Name "RustDesk" -Force -ErrorAction SilentlyContinue
Set-Service -Name "RustDesk" -StartupType Disabled -ErrorAction SilentlyContinue

# Get uninstall information
$App = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
       Where-Object { $_.DisplayName -like "*RustDesk*" }

if ($App) {
    $UninstallString = $App.UninstallString

    if ($UninstallString -like "*.exe*") {
        # EXE uninstaller
        $UninstallExe = $UninstallString -replace '"', ''
        Start-Process -FilePath $UninstallExe -ArgumentList "--silent-install" -Wait
    }
    elseif ($UninstallString -like "*msiexec*") {
        # MSI uninstaller
        $ProductCode = $UninstallString -replace "msiexec.exe /I", "" -replace "msiexec.exe /X", "" -replace "{", "" -replace "}", "" -replace " ", ""
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/X{$ProductCode} /qn /norestart" -Wait
    }

    Write-Output "RustDesk uninstalled successfully"
} else {
    Write-Output "RustDesk not found"
}

# Clean up remaining files
Remove-Item -Path "$env:APPDATA\RustDesk" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\RustDesk" -Recurse -Force -ErrorAction SilentlyContinue
```

## Comparison: EXE vs MSI Installer

| Feature | EXE Installer | MSI Installer |
|---------|--------------|---------------|
| **Installation Speed** | Faster | Slightly slower |
| **Custom Path** | No | Yes (INSTALLFOLDER) |
| **Shortcuts Control** | Limited | Full control |
| **Logging** | Basic | Detailed (/L*v) |
| **Group Policy** | No | Yes |
| **Silent Install** | --silent-install | /qn |
| **Best For** | Quick deployments | Enterprise environments |

**Recommendation**: Use **EXE** for simplicity and speed. Use **MSI** if you need custom paths or detailed logging.

## Integration with Password Managers

To store RustDesk credentials in a password manager:

### Using DattoRMM Custom Fields

1. Create a custom device field: `RustDesk_ID`
2. Create a custom device field: `RustDesk_Password` (if using permanent passwords)
3. Modify the deployment script to set these fields via API

### Using CSV Export

Create a monitor to export to CSV:

```powershell
$RustDeskID = & "C:\Program Files\RustDesk\rustdesk.exe" --get-id 2>&1
$DeviceName = $env:COMPUTERNAME

# Output in CSV format
"DeviceName,RustDeskID"
"$DeviceName,$RustDeskID"
```

## References and Resources

### Official Documentation

- [RustDesk Official Website](https://rustdesk.com/)
- [RustDesk Self-Host Documentation](https://rustdesk.com/docs/en/self-host/)
- [RustDesk Client Configuration](https://rustdesk.com/docs/en/self-host/client-configuration/)
- [RustDesk Client Deployment Guide](https://rustdesk.com/docs/en/self-host/client-deployment/)
- [RustDesk MSI Installer Documentation](https://rustdesk.com/docs/en/client/windows/msi/)
- [RustDesk GitHub Repository](https://github.com/rustdesk/rustdesk)
- [RustDesk Server GitHub Repository](https://github.com/rustdesk/rustdesk-server)

### Community Resources

- [RustDesk GitHub Releases](https://github.com/rustdesk/rustdesk/releases)
- [RustDesk Silent Installation Discussion](https://github.com/rustdesk/rustdesk/discussions/3481)
- [Windows Installer Silent Install Issue](https://github.com/rustdesk/rustdesk/issues/212)
- [Command Line Configuration Discussion](https://github.com/rustdesk/rustdesk/discussions/7613)
- [RustDesk on Tactical RMM](https://docs.tacticalrmm.com/3rdparty_rustdesk/)

### Third-Party Guides

- [RustDesk Silent Install Guide](https://silentinstallhq.com/rustdesk-silent-install-how-to-guide/)
- [Install Self-Hosted RustDesk Server](https://suar.services/install-and-configure-a-self-hosted-rustdesk-server/)

## Support

For issues specific to:

- **Script/Component**: Review logs and troubleshooting section above
- **DattoRMM**: Contact Datto support or consult DattoRMM documentation
- **RustDesk Software**: Visit [RustDesk GitHub Issues](https://github.com/rustdesk/rustdesk/issues) or [RustDesk Discussions](https://github.com/rustdesk/rustdesk/discussions)
- **Self-Hosted Server**: Review [RustDesk Server Documentation](https://rustdesk.com/docs/en/self-host/) and server logs

## FAQ

### Q: Do I need RustDesk Pro for this script?

**A:** No. This script works with both free (OSS) and Pro versions of RustDesk server. Pro features (API server, web console) are optional.

### Q: Can I use this with the public RustDesk servers?

**A:** This script is designed for self-hosted servers. For public RustDesk servers, you don't need server configuration - just install RustDesk normally.

### Q: How do I find my RustDesk server's public key?

**A:** SSH to your server and run: `cat ~/rustdesk-server/id_ed25519.pub` or check your server's working directory.

### Q: What's the difference between ID Server and Relay Server?

**A:**
- **ID Server (hbbs)**: Handles registration and signaling
- **Relay Server (hbbr)**: Routes traffic when P2P connection fails
- Usually they're the same host, but can be separated for load balancing

### Q: Should I use permanent or temporary passwords?

**A:**
- **Permanent**: Better for servers and headless systems
- **Temporary**: More secure for workstations
- **Recommendation**: Temporary for user devices, permanent for servers

### Q: Can I pre-configure RustDesk before installation?

**A:** No, RustDesk must be installed first. This script installs then configures. That's the standard RustDesk deployment workflow.

### Q: The RustDesk ID keeps changing!

**A:** The ID should be stable once generated. If it changes:
- Check if RustDesk is being reinstalled
- Verify the service stays running
- Check for conflicts with other remote access tools

### Q: Can I deploy this offline?

**A:** Partially. You'd need to:
1. Download the installer manually
2. Host it on a local file server
3. Modify the script to download from your server instead of GitHub

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-02 | Initial release with silent installation, server configuration, and password management |

## License

This deployment script is provided as-is for use with RustDesk and DattoRMM. RustDesk is licensed under AGPL-3.0. Review RustDesk's license at their [GitHub repository](https://github.com/rustdesk/rustdesk).
