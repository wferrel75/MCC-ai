# PowerShell Scripts Collection

Organized collection of PowerShell scripts for MSP operations, server management, deployment automation, and system administration tasks.

## Directory Structure

### [AD-Computer-Connectivity](./AD-Computer-Connectivity/)
Active Directory computer connectivity testing and activity tracking scripts.

**Scripts:**
- `Test-ADComputerConnectivity.ps1` - Full-featured AD computer connectivity testing
- `Test-ADComputerConnectivity-Simple.ps1` - PowerShell 2.0 compatible version
- `README-Connectivity-Scripts.md` - Complete documentation

**Features:**
- Enumerate computers from Active Directory
- Track last AD check-in times (lastLogon, lastLogonTimestamp)
- Test connectivity (Ping, WinRM, WMI, PSRemoting, RPC)
- Identify stale/inactive computer accounts
- Detailed logging and CSV export

### [Domain-Admin-Account](./Domain-Admin-Account/)
Scripts for creating and managing domain administrator accounts with Datto RMM integration.

**Scripts:**
- `New-DomainAdminAccount.ps1` - Main domain admin creation script
- `Test-NewDomainAdminComponent.ps1` - Testing and validation script

**Documentation:**
- `New-DomainAdminAccount-README.md` - Main documentation
- `New-DomainAdminAccount-OVERVIEW.md` - Overview and concepts
- `New-DomainAdminAccount-DattoSetup.md` - Datto RMM integration guide
- `New-DomainAdminAccount-SecurityChecklist.md` - Security best practices

**Features:**
- Create dedicated MSP admin accounts
- Set strong random passwords
- Configure group memberships
- Integrate with Datto RMM for password management
- Comprehensive security controls

### [Server-Configuration](./Server-Configuration/)
Server documentation, configuration, and inventory scripts.

**Scripts:**
- `Get-ServerConfiguration.ps1` - Comprehensive server inventory script
- `Get-ServerConfiguration-WithExport.ps1` - Enhanced version with JSON/Markdown export
- `Config-Server.ps1` - Server configuration and setup automation

**Documentation:**
- `Config-Server.md` - Server configuration guide

**Features:**
- Hardware inventory (CPU, RAM, disks, network adapters)
- Software inventory (OS, roles, features, installed applications)
- Network configuration details
- Storage configuration and capacity
- Export to multiple formats (JSON, Markdown, HTML)

### [BGInfo-Configuration](./BGInfo-Configuration/)
BGInfo configuration and automation scripts for displaying system information on desktop backgrounds.

**Scripts:**
- `Create-BGInfoConfig.ps1` - Generate BGInfo configurations
- `bginfo-example-generator.ps1` - Example configuration generator

**Documentation:**
- `BGInfo-README.md` - Complete guide

**Features:**
- Automated BGInfo configuration
- Custom field definitions
- Deployment automation
- Template generation

### [DattoRMM-API](./DattoRMM-API/)
Datto RMM API integration and automation scripts.

**Scripts:**
- `dattormm-api-setup.ps1` - API authentication and setup

**Documentation:**
- `dattormm-api-README.md` - API integration guide

**Features:**
- API authentication configuration
- Device management automation
- Integration with other MSP tools
- Bulk operations support

### [Netbird-Deployment](./Netbird-Deployment/)
Netbird VPN client deployment automation for Windows.

**Scripts:**
- `netbird-windows-deployment.ps1` - Automated Netbird installation and configuration

**Documentation:**
- `netbird-windows-README.md` - Deployment guide

**Assets:**
- `netbird-icon.png` - Netbird branding icon

**Features:**
- Silent installation
- Automated configuration
- Setup key deployment
- Registry configuration

### [RustDesk-Deployment](./RustDesk-Deployment/)
RustDesk remote desktop client deployment for Windows.

**Scripts:**
- `rustdesk-windows-deployment.ps1` - Automated RustDesk installation and configuration

**Documentation:**
- `rustdesk-windows-README.md` - Deployment guide

**Assets:**
- `rustdesk-icon.png` - RustDesk branding icon

**Features:**
- Silent installation
- Custom relay server configuration
- ID and password automation
- MSI deployment support

### [Splunk-Installer](./Splunk-Installer/)
Splunk Universal Forwarder deployment for Datto RMM environments.

**Scripts:**
- `splunk_Datto_Installer.ps1` - Automated Splunk forwarder installation

**Features:**
- Automated download and installation
- Configuration for Splunk Cloud or Enterprise
- Datto RMM integration
- Deployment index configuration

### [Integration-Guides](./Integration-Guides/)
Integration documentation for connecting various MSP tools and platforms.

**Guides:**
- `Datto-Integration-Guide.md` - General Datto integration patterns
- `n8n-webhook-setup-guide.md` - N8N webhook configuration
- `DattoRMM-n8n-SiteGroups-Workflow-Guide.md` - N8N workflow automation
- `DattoRMM-n8n-QuickStart.md` - Quick start guide for N8N integration

**Topics:**
- Webhook setup and security
- Workflow automation
- API integration patterns
- Event-driven automation

## Requirements

Most scripts in this collection require:
- **PowerShell 5.1** or higher (some scripts support PowerShell 2.0 as noted)
- **Windows Server 2008 R2** or higher (varies by script)
- **Administrator privileges** (varies by operation)
- **Active Directory** (for AD-related scripts)
- **Internet connectivity** (for deployment scripts)

Specific requirements are documented in each directory's README.

## Usage

Navigate to the specific directory for detailed documentation on each script collection:

```powershell
# Example: Running AD connectivity tests
cd AD-Computer-Connectivity
.\Test-ADComputerConnectivity.ps1

# Example: Creating domain admin account
cd Domain-Admin-Account
.\New-DomainAdminAccount.ps1 -Username "MSP-Admin"

# Example: Getting server configuration
cd Server-Configuration
.\Get-ServerConfiguration.ps1
```

## Configuration

### Claude AI Configuration
This directory includes a `.claude` subdirectory with settings for Claude Code integration:
- Permission settings for web searches and API access
- MCP (Model Context Protocol) tool permissions
- These settings enable AI-assisted script development and documentation

## Best Practices

1. **Test in Dev First**: Always test scripts in a non-production environment
2. **Review Permissions**: Check required permissions before running scripts
3. **Read Documentation**: Each directory contains specific documentation
4. **Backup Before Changes**: Create backups before running configuration scripts
5. **Log Everything**: Use the `-LogPath` parameters for audit trails
6. **Validate Credentials**: Securely manage credentials using appropriate methods

## Security Considerations

- Scripts that modify Active Directory require Domain Admin privileges
- Deployment scripts may download files from the internet - validate sources
- Password management scripts should be run on secure systems
- API credentials should be stored securely (use credential managers)
- Review security checklists in each directory before deployment

## Support and Documentation

Each subdirectory contains its own README with:
- Detailed usage instructions
- Parameter documentation
- Examples and use cases
- Troubleshooting guides
- Security considerations

## Contributing

When adding new scripts to this collection:
1. Create a new directory for the script category
2. Include a comprehensive README
3. Add examples and usage documentation
4. Document requirements and prerequisites
5. Include security considerations
6. Update this main README

## License

These scripts are provided as-is for MSP and system administration use. Review and test before using in production environments.

## Recent Updates

- **2024-12-09**: Reorganized directory structure into logical categories
- **2024-12-08**: Added AD activity tracking and detailed logging to connectivity scripts
- **2024-12**: Added Domain Admin Account creation scripts
- **2024-12**: Added RustDesk and Netbird deployment automation
- **2024-11**: Initial collection of server configuration and BGInfo scripts
