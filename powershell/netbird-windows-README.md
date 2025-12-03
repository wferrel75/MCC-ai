# NetBird Windows Agent Deployment for DattoRMM

This guide provides instructions for deploying the NetBird Windows agent to your managed endpoints using DattoRMM.

## Overview

The deployment script (`netbird-windows-deployment.ps1`) automates the following tasks:

1. **Downloads** the latest (or specified) NetBird Windows MSI installer
2. **Installs** NetBird silently without user interaction
3. **Configures** the agent to connect to your self-hosted NetBird instance
4. **Registers** the agent automatically using a setup key
5. **Verifies** the service is running and connected

## Prerequisites

### Self-Hosted NetBird Instance

Before deploying to endpoints, you need:

1. **Self-hosted NetBird management server** up and running
   - Management API URL (e.g., `https://netbird.yourdomain.com:33073`)
   - Admin panel URL (e.g., `https://netbird.yourdomain.com`)

2. **Setup Key** from your NetBird dashboard
   - Log into your NetBird admin panel
   - Navigate to **Setup Keys** section
   - Create a new setup key or use an existing one
   - Copy the key for use in the component

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
| **Name** | NetBird Agent Deployment |
| **Category** | Networking / VPN |
| **Description** | Deploys and configures NetBird VPN agent for self-hosted instance |
| **Enabled** | ✓ |

### Step 3: Add PowerShell Script

1. In the **Script** section, paste the entire contents of `netbird-windows-deployment.ps1`
2. Set **Execution Policy**: Bypass
3. Set **Run As**: System

### Step 4: Configure Component Variables

Create the following **Component Variables** to make the script reusable:

| Variable Name | Type | Description | Example Value |
|--------------|------|-------------|---------------|
| `NETBIRD_SETUP_KEY` | **Secure Text** | Setup key from NetBird dashboard | `XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX` |
| `NETBIRD_MANAGEMENT_URL` | Text | Your NetBird management server URL | `https://netbird.yourdomain.com:33073` |
| `NETBIRD_ADMIN_URL` | Text (Optional) | Your NetBird admin panel URL | `https://netbird.yourdomain.com` |
| `NETBIRD_VERSION` | Text (Optional) | Specific version to install (leave empty for latest) | `0.60.2` |

### Step 5: Modify Script Parameters

At the top of the script in the DattoRMM editor, update the param block to use environment variables:

```powershell
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$SetupKey = $env:NETBIRD_SETUP_KEY,

    [Parameter(Mandatory=$true)]
    [string]$ManagementURL = $env:NETBIRD_MANAGEMENT_URL,

    [Parameter(Mandatory=$false)]
    [string]$AdminURL = $env:NETBIRD_ADMIN_URL,

    [Parameter(Mandatory=$false)]
    [string]$NetBirdVersion = $env:NETBIRD_VERSION
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
4. Select **Component**: NetBird Agent Deployment
5. Set component variables if prompted
6. Click **Run**

### Option B: Scheduled Deployment (Policies)

For automated deployment across sites:

1. Navigate to **Policies**
2. Select or create a policy
3. Add **Component Job**:
   - Component: NetBird Agent Deployment
   - Schedule: One-time or recurring
   - Variables: Set required values
4. Apply policy to target sites/devices

### Option C: Monitoring with Auto-Remediation

For continuous compliance:

1. Create a **Monitor** to check NetBird service status:
   ```powershell
   $Service = Get-Service -Name "netbird" -ErrorAction SilentlyContinue
   if ($Service -and $Service.Status -eq "Running") {
       Write-Output "NetBird is running"
       exit 0
   } else {
       Write-Output "NetBird is not running"
       exit 1
   }
   ```

2. Set **Automated Remediation** to run the deployment component if the monitor fails

## Verification

After deployment, verify successful installation:

### Check via DattoRMM

1. Review **Component Results** in the device's activity log
2. Look for: `SUCCESS: NetBird agent installed and connected`
3. Check for any error messages in the output

### Check on Target Device

Run these commands on the target Windows device:

```powershell
# Check service status
Get-Service -Name "netbird"

# Check NetBird status
& "C:\Program Files\NetBird\netbird.exe" status

# View configuration
Get-Content "C:\ProgramData\NetBird\config.json"
```

### Check in NetBird Dashboard

1. Log into your NetBird admin panel
2. Navigate to **Peers** section
3. Verify the new device appears in the list
4. Confirm it shows as **Connected**

## Troubleshooting

### Deployment Fails with "Download Error"

**Cause**: Network connectivity issue or GitHub is unreachable

**Solution**:
- Verify the target device has internet access
- Check firewall rules allow HTTPS to `github.com`
- Try specifying a specific version instead of "latest"

### Deployment Succeeds but Agent Not Connected

**Cause**: Incorrect management URL or setup key

**Solution**:
- Verify `NETBIRD_MANAGEMENT_URL` is correct and accessible
- Confirm setup key is valid and not expired
- Check setup key hasn't reached its usage limit
- Review logs at `C:\ProgramData\NetBird\deployment.log`

### Service Installed but Not Running

**Cause**: Firewall blocking NetBird or port conflicts

**Solution**:
- Check Windows Firewall rules
- Verify UDP port 51820 (WireGuard) is not blocked
- Review service logs in Event Viewer
- Manually restart service: `Restart-Service netbird`

### "Must be run as Administrator" Error

**Cause**: Script not running with elevated privileges

**Solution**:
- Ensure DattoRMM component is set to **Run As: System**
- DattoRMM should automatically provide admin rights
- If testing manually, right-click PowerShell and "Run as Administrator"

### Configuration File Not Updated

**Cause**: Timing issue or permissions problem

**Solution**:
- The script uses command-line parameters as fallback
- Check `C:\ProgramData\NetBird\config.json` permissions
- Verify the NetBird service account has write access

## Logs and Diagnostics

The script generates logs in multiple locations:

| Log File | Purpose |
|----------|---------|
| `C:\ProgramData\NetBird\deployment.log` | Main deployment script log |
| `%TEMP%\netbird_install.log` | MSI installer detailed log |
| `%TEMP%\netbird_up_stdout.txt` | NetBird connection output |
| `%TEMP%\netbird_up_stderr.txt` | NetBird connection errors |

To retrieve logs via DattoRMM Quick Job:

```powershell
Get-Content "C:\ProgramData\NetBird\deployment.log" -Tail 50
```

## Advanced Configuration

### Installing Specific Version

Set the `NETBIRD_VERSION` variable to a specific version:

```
NETBIRD_VERSION=0.59.3
```

Available versions: [NetBird Releases](https://github.com/netbirdio/netbird/releases)

### Multiple Setup Keys for Different Groups

You can create multiple components with different setup keys for different purposes:

- **NetBird Agent - Servers** (using server setup key)
- **NetBird Agent - Workstations** (using workstation setup key)
- **NetBird Agent - Remote Workers** (using remote worker setup key)

### Custom Admin URL

If your admin panel is on a different URL than the management server:

```
NETBIRD_ADMIN_URL=https://admin.netbird.yourdomain.com
```

### Firewall Configuration

NetBird requires the following network access:

| Direction | Protocol | Port | Destination | Purpose |
|-----------|----------|------|-------------|---------|
| Outbound | HTTPS | 443 | github.com | Download installer |
| Outbound | HTTPS/HTTP | Custom | Your Management Server | API communication |
| Outbound | UDP | 51820 | Peer IPs | WireGuard tunnels |

## Uninstallation

To remove NetBird from devices, create a separate component:

```powershell
# Stop service
Stop-Service -Name "netbird" -Force -ErrorAction SilentlyContinue

# Get uninstall string
$App = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
       Where-Object { $_.DisplayName -like "*NetBird*" }

if ($App) {
    # Uninstall silently
    $UninstallString = $App.UninstallString -replace "msiexec.exe", "" -replace "/I", "/X"
    Start-Process "msiexec.exe" -ArgumentList "$UninstallString /qn /norestart" -Wait
    Write-Output "NetBird uninstalled successfully"
} else {
    Write-Output "NetBird not found"
}
```

## Security Considerations

### Setup Key Protection

- Use **Secure Text** variable type for setup keys in DattoRMM
- Rotate setup keys periodically
- Use different keys for different device groups
- Set usage limits and expiration dates on keys

### Network Security

- Ensure your NetBird management server uses HTTPS with valid certificates
- Implement proper firewall rules on your management server
- Consider using a VPN or private network for management traffic
- Enable 2FA on your NetBird admin panel

### Access Control

- Use NetBird's built-in access control policies
- Implement network segmentation based on device groups
- Regular audit of connected peers
- Disable or delete peers that are no longer needed

## Updates and Maintenance

### Updating NetBird Agents

To update all agents to a new version:

1. Update the `NETBIRD_VERSION` variable to the desired version
2. Re-run the component on target devices
3. The script will install the new version over the existing one

### Monitoring for Updates

Create a monitoring script to check for outdated versions:

```powershell
$InstalledVersion = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
                     Where-Object { $_.DisplayName -like "*NetBird*" }).DisplayVersion

# Compare with desired version
if ($InstalledVersion -lt "0.60.0") {
    Write-Output "NetBird outdated: $InstalledVersion"
    exit 1
} else {
    Write-Output "NetBird up to date: $InstalledVersion"
    exit 0
}
```

## References and Resources

### Official Documentation

- [NetBird Windows Installation Guide](https://docs.netbird.io/how-to/installation/windows)
- [NetBird Setup Keys Documentation](https://docs.netbird.io/how-to/register-machines-using-setup-keys)
- [NetBird GitHub Releases](https://github.com/netbirdio/netbird/releases)
- [NetBird CLI Documentation](https://docs.netbird.io/how-to/cli)

### Community Resources

- [NetBird GitHub Repository](https://github.com/netbirdio/netbird)
- [NetBird MSI Installer Issue #995](https://github.com/netbirdio/netbird/issues/995)
- [Management URL Configuration Issue #2171](https://github.com/netbirdio/netbird/issues/2171)

### Related Integrations

- [Deploying NetBird with Intune](https://docs.netbird.io/how-to/intune-netbird-integration)
- [Deploying NetBird with Acronis](https://docs.netbird.io/how-to/acronis-netbird-integration)

## Support

For issues specific to:

- **Script/Component**: Review logs and troubleshooting section above
- **DattoRMM**: Contact Datto support or consult DattoRMM documentation
- **NetBird Software**: Visit [NetBird GitHub Issues](https://github.com/netbirdio/netbird/issues) or NetBird community forums
- **Self-Hosted Instance**: Review your NetBird server logs and configuration

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-02 | Initial release with automatic installation, configuration, and connection |

## License

This deployment script is provided as-is for use with NetBird and DattoRMM. NetBird is licensed under BSD-3-Clause. Review NetBird's license at their [GitHub repository](https://github.com/netbirdio/netbird).
