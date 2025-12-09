# DattoRMM API Integration Guide

This guide explains how to work with the DattoRMM API for automating component deployment and management.

## Important API Limitation

**⚠️ Components Cannot Be Created via API**

After extensive research of the DattoRMM API documentation, I've found that:

- **Components must be created manually** through the DattoRMM web interface
- The API can **reference existing components** by their UID
- The API can **execute components** via Quick Jobs and scheduled tasks
- Component UIDs are **not available via the API** and must be retrieved from the web interface

This is a limitation of the DattoRMM API itself, not a limitation of the scripts provided.

### Why This Limitation Exists

The DattoRMM API is primarily designed for:
- Device management and monitoring
- Job execution and scheduling
- Alert management
- Audit and reporting

Component **creation** is considered a configuration task that requires human review and is therefore restricted to the web interface.

## What We Can Do with the API

While we cannot create components automatically, the API helper script (`dattormm-api-setup.ps1`) provides:

1. **API Connection Setup** - Configure and test your API credentials
2. **PowerShell Module Installation** - Install the DattoRMM PowerShell module
3. **Component Data Export** - Generate detailed setup instructions
4. **Future Automation** - Once components are created, use API to deploy them

## Prerequisites

### 1. Enable API Access

1. Log into your DattoRMM portal
2. Navigate to **Setup** > **Global Settings** > **Access Control**
3. Enable **API Access**

### 2. Generate API Keys

1. Navigate to **Setup** > **Users**
2. Select your user account
3. Click **Generate API Keys**
4. Save your:
   - **API Key**
   - **API Secret Key**
   - **API URL** (your platform URL, e.g., `https://merlot-api.centrastage.net`)

### 3. Identify Your API Platform

DattoRMM uses different regional platforms. Common URLs:

| Platform | API URL |
|----------|---------|
| Merlot | `https://merlot-api.centrastage.net` |
| Pinotage | `https://pinotage-api.centrastage.net` |
| Concord | `https://concord-api.centrastage.net` |
| Syrah | `https://syrah-api.centrastage.net` |
| Zinfandel | `https://zinfandel-api.centrastage.net` |

Your API URL is shown when you generate API keys.

## Using the API Setup Script

The `dattormm-api-setup.ps1` script provides several actions to help you work with DattoRMM.

### Step 1: Install DattoRMM PowerShell Module

```powershell
.\dattormm-api-setup.ps1 -Action InstallModule
```

This installs the community-maintained [DattoRMM PowerShell module](https://github.com/aaronengels/DattoRMM) which simplifies API interactions.

### Step 2: Configure API Credentials

```powershell
.\dattormm-api-setup.ps1 -Action Setup `
    -ApiUrl "https://merlot-api.centrastage.net" `
    -ApiKey "YOUR_API_KEY" `
    -ApiSecretKey "YOUR_SECRET_KEY"
```

This will:
- Configure the PowerShell module with your credentials
- Save encrypted credentials to `dattormm-credentials.xml`
- Store them securely for future use

**⚠️ Security Note:** The credentials file is encrypted using Windows DPAPI and can only be decrypted by the same user on the same machine. **Do not commit this file to version control.**

### Step 3: Test API Connection

```powershell
.\dattormm-api-setup.ps1 -Action TestConnection
```

This will:
- Load your saved credentials
- Connect to the DattoRMM API
- Retrieve and display your account information
- Show the number of sites in your account

If successful, you'll see:
```
=== Testing DattoRMM API Connection ===
Connection successful!
Account Name: Your Account Name
Account UID: 12345
Total Sites: 10
```

### Step 4: View Component Configuration Data

```powershell
.\dattormm-api-setup.ps1 -Action ShowComponentData
```

This displays all the configuration details for both NetBird and RustDesk components, including:
- Component names and descriptions
- Required variables
- Variable types and examples
- Step-by-step setup instructions

### Step 5: Export Component Instructions

```powershell
.\dattormm-api-setup.ps1 -Action ExportComponentScripts
```

This creates detailed instruction files:
- `NetBird-Component-Instructions.txt`
- `RustDesk-Component-Instructions.txt`

These files contain everything you need to create the components manually in the DattoRMM interface.

## Creating Components Manually

Since components cannot be created via API, follow these steps:

### For NetBird Component

1. **Navigate to** DattoRMM Portal > **Comodo** > **Components** > **New Component**

2. **Configure Basic Settings:**
   - **Name**: `NetBird Agent Deployment`
   - **Category**: `Networking / VPN`
   - **Description**: `Deploys and configures NetBird VPN agent for self-hosted instance`
   - **Component Type**: `PowerShell`

3. **Script Configuration:**
   - **Execution Policy**: `Bypass`
   - **Run As**: `System`
   - **Script**: Copy entire contents from `netbird-windows-deployment.ps1`

4. **Modify Script Parameters** (at the top of the script):
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

5. **Create Component Variables:**

   | Variable Name | Type | Required | Description |
   |--------------|------|----------|-------------|
   | `NETBIRD_SETUP_KEY` | Secure Text | Yes | Setup key from NetBird dashboard |
   | `NETBIRD_MANAGEMENT_URL` | Text | Yes | Management server URL |
   | `NETBIRD_ADMIN_URL` | Text | No | Admin panel URL |
   | `NETBIRD_VERSION` | Text | No | Specific version (or leave empty) |

6. **Save Component** and note the **Component UID** (displayed at the top of the page)

### For RustDesk Component

1. **Navigate to** DattoRMM Portal > **Comodo** > **Components** > **New Component**

2. **Configure Basic Settings:**
   - **Name**: `RustDesk Agent Deployment`
   - **Category**: `Remote Access`
   - **Description**: `Deploys and configures RustDesk remote desktop agent for self-hosted server`
   - **Component Type**: `PowerShell`

3. **Script Configuration:**
   - **Execution Policy**: `Bypass`
   - **Run As**: `System`
   - **Script**: Copy entire contents from `rustdesk-windows-deployment.ps1`

4. **Modify Script Parameters** (at the top of the script):
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
       [string]$InstallerType = $(if ($env:RUSTDESK_INSTALLER_TYPE) { $env:RUSTDESK_INSTALLER_TYPE } else { 'exe' })
   )
   ```

5. **Create Component Variables:**

   | Variable Name | Type | Required | Description |
   |--------------|------|----------|-------------|
   | `RUSTDESK_SERVER_HOST` | Text | Yes | Server hostname or IP |
   | `RUSTDESK_SERVER_KEY` | Secure Text | Yes | Public key from id_ed25519.pub |
   | `RUSTDESK_RELAY_SERVER` | Text | No | Relay server (if different) |
   | `RUSTDESK_API_SERVER` | Text | No | API server (Pro only) |
   | `RUSTDESK_PASSWORD` | Secure Text | No | Permanent password |
   | `RUSTDESK_VERSION` | Text | No | Specific version |
   | `RUSTDESK_INSTALLER_TYPE` | Text | No | 'exe' or 'msi' |

6. **Save Component** and note the **Component UID** (displayed at the top of the page)

## Using the API After Component Creation

Once components are created manually, you can use the API to automate deployment!

### Example: Deploy to Specific Device

```powershell
# Load DattoRMM module and credentials
Import-Module DattoRMM

# Configure API (if not already done)
$Creds = Import-Clixml "$PSScriptRoot\dattormm-credentials.xml"
Set-DrmmApiParameters -Url $Creds.ApiUrl -Key $DecryptedKey -SecretKey $DecryptedSecret

# Get device UID
$Devices = Get-DrmmAccountDevices
$TargetDevice = $Devices | Where-Object { $_.hostname -eq "WORKSTATION-01" }

# Create quick job to run NetBird component
# Note: You need the component UID from the web interface
$ComponentUid = "your-netbird-component-uid-from-web-interface"

# Execute component on device
# (API call structure - exact implementation depends on available endpoints)
```

### Example: Get All Devices for Bulk Deployment

```powershell
# Get all online Windows devices
$Devices = Get-DrmmAccountDevices | Where-Object {
    $_.online -eq $true -and
    $_.operatingSystem -like "*Windows*"
}

Write-Host "Found $($Devices.Count) online Windows devices ready for deployment"

foreach ($Device in $Devices) {
    Write-Host "Device: $($Device.hostname) - Site: $($Device.siteName)"
}
```

### Example: Check Component Results

```powershell
# Get job status
$JobUid = "job-uid-from-previous-execution"
$JobStatus = Get-DrmmJobStatus -jobUid $JobUid

# Get job results
$JobResults = Get-DrmmJobResults -jobUid $JobUid
```

## DattoRMM PowerShell Module Cmdlets

The DattoRMM PowerShell module provides many useful cmdlets:

### Account & Site Management
- `Get-DrmmAccount` - Retrieve account information
- `Get-DrmmAccountSites` - List all sites
- `Get-DrmmAccountDevices` - Get all devices
- `Get-DrmmSiteDevices` - Get devices for specific site
- `Get-DrmmAccountVariables` - Account-level variables

### Device Management
- `Get-DrmmDevice` - Get specific device details
- `Set-DrmmDeviceUdf` - Set custom device fields
- `Set-DrmmDeviceWarranty` - Configure warranty info
- `Move-DrmmDeviceToSite` - Move device between sites

### Job Management
- `Get-DrmmJobStatus` - Check job execution status
- `Get-DrmmJobResults` - Retrieve job output
- `Get-DrmmDeviceQuickJob` - Execute quick jobs

### Alert Management
- `Get-DrmmAlert` - Retrieve alerts
- `Set-DrmmAlertMute` - Mute alerts
- `Set-DrmmAlertUnmute` - Unmute alerts
- `Set-DrmmAlertResolve` - Resolve alerts

### Audit & Reporting
- `Get-DrmmAuditDevice` - Device audit information
- `Get-DrmmAuditDeviceSoftware` - Software inventory

For complete documentation, visit: [DattoRMM PowerShell Module GitHub](https://github.com/aaronengels/DattoRMM)

## API Rate Limiting

**Important:** DattoRMM API has rate limits:
- **600 requests per 60 seconds** per account (not per user)
- Exceeding 90% quota introduces 1-second delays
- Breaching the limit returns HTTP 429
- Persistent violations trigger HTTP 403 and temporary IP blocking

When automating deployments to many devices:
- Batch your operations
- Add delays between API calls
- Monitor your request count
- Use bulk operations when available

## API Authentication

### Access Token Lifespan
- Access tokens expire after **100 hours**
- After expiration, request a new token
- 401 errors indicate expired tokens

### Security Best Practices
1. **Never hardcode credentials** in scripts
2. **Use encrypted credential files** (like the one generated by the setup script)
3. **Restrict API key permissions** to only what's needed
4. **Rotate API keys** periodically
5. **Monitor API usage** for unauthorized access
6. **Store credentials securely** and never commit to version control

## Accessing Swagger UI Documentation

For complete API documentation, access your platform's Swagger UI:

```
https://[YOUR-PLATFORM]-api.centrastage.net/api/swagger-ui/index.html
```

Example:
```
https://merlot-api.centrastage.net/api/swagger-ui/index.html
```

You'll need to authenticate with your API credentials to explore endpoints.

## Alternative: Manual Bulk Import

If you need to deploy to many devices at scale, consider:

1. **Export device list** via API
2. **Create CSV** with device UIDs and configuration
3. **Use DattoRMM policies** to apply components to device groups
4. **Schedule deployments** during maintenance windows
5. **Monitor results** via API

## Troubleshooting

### "Module not found" Error

**Solution:** Run the install action first:
```powershell
.\dattormm-api-setup.ps1 -Action InstallModule
```

### "401 Unauthorized" Error

**Causes:**
- Invalid API credentials
- Expired access token
- API access not enabled

**Solutions:**
1. Verify credentials in DattoRMM portal
2. Re-run setup action with correct credentials
3. Ensure API access is enabled in Global Settings

### "429 Too Many Requests" Error

**Cause:** Rate limit exceeded

**Solution:**
- Wait 60 seconds
- Reduce request frequency
- Add delays between bulk operations

### "Cannot find saved credentials"

**Cause:** Setup action hasn't been run or credentials file is missing

**Solution:**
```powershell
.\dattormm-api-setup.ps1 -Action Setup `
    -ApiUrl "YOUR_API_URL" `
    -ApiKey "YOUR_KEY" `
    -ApiSecretKey "YOUR_SECRET"
```

### Component UID Not Found

**Cause:** Component hasn't been created yet

**Solution:**
1. Create component via web interface
2. Navigate to the component in DattoRMM
3. Copy the UID from the top of the page
4. Use that UID in API calls

## Workflow Summary

Here's the complete workflow from start to finish:

```
1. Install API Helper & Module
   ↓
2. Configure API Credentials
   ↓
3. Test API Connection
   ↓
4. Export Component Instructions
   ↓
5. Manually Create Components in Web Interface
   ↓
6. Note Component UIDs
   ↓
7. Use API to Deploy Components to Devices
   ↓
8. Monitor Job Results via API
```

## Future Enhancements

If DattoRMM adds component creation to their API in the future, we can extend these scripts to:

- Automatically create components
- Update existing components
- Clone components across accounts
- Backup/restore component configurations
- Version control component scripts

Until then, manual component creation is required.

## Support Resources

### Official DattoRMM Documentation
- [DattoRMM API Documentation](https://rmm.datto.com/help/en/Content/2SETUP/APIv2.htm)
- [Creating Components Guide](https://rmm.datto.com/help/en/Content/3NEWUI/Automation/Components/CreateAComponent.htm)
- [DattoRMM Help Portal](https://rmm.datto.com/help/)

### Community Resources
- [DattoRMM PowerShell Module](https://github.com/aaronengels/DattoRMM)
- [DattoRMM Integrations Whitepaper](https://rmm.datto.com/help/Integrations/DattoRMMIntegrationsWhitepaper.pdf)

### Getting Help
- **DattoRMM Support**: Contact through your DattoRMM portal
- **API Issues**: Check Swagger UI documentation for your platform
- **Module Issues**: [GitHub Issues](https://github.com/aaronengels/DattoRMM/issues)

## License

The API helper script is provided as-is for use with DattoRMM. The DattoRMM PowerShell module is maintained by the community and licensed separately.

## Conclusion

While we cannot create components automatically via the API, the tools provided here streamline the process by:

✅ Setting up API access quickly
✅ Testing connectivity
✅ Generating detailed component instructions
✅ Providing templates for manual creation
✅ Enabling future automation once components exist

Once components are created manually (one-time task), you can use the API to deploy them automatically to thousands of devices!
