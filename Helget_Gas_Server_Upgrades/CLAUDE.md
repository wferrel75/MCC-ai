# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **customer-specific project workspace** for Helget Gas server upgrades, part of Midwest Cloud Computing's (MCC) MSP operations repository. The workspace serves as a dedicated environment for planning, documenting, and implementing server infrastructure upgrades for Helget Gas.

## Purpose

Helget Gas is a propane/gas distribution company requiring 24/7 availability for emergency services. This workspace is for:
- Server infrastructure assessment and upgrade planning
- Configuration documentation and change tracking
- Implementation planning and execution
- Post-upgrade validation and documentation

## Workspace Structure

```
/home/wferrel/ai/Helget_Gas_Server_Upgrades/
├── Helget_Gas_profile.md -> ../Customer_Profiles/Helget_Gas_profile.md (symlink)
├── MCC_Profile.md -> ../MCC_Profile/MCC_Profile.md (symlink)
└── .claude/
    └── settings.local.json
```

## Related Resources

### Customer Profile
The `Helget_Gas_profile.md` symlink provides comprehensive customer information:
- Business overview and critical operational requirements
- Current technology infrastructure
- Microsoft 365 licensing and services
- Network infrastructure details
- Security and compliance requirements (DOT, PHMSA regulations)
- Line of business applications (dispatch, tank monitoring, fleet management)

**Location:** `../Customer_Profiles/Helget_Gas_profile.md`

### MCC Technology Stack
The `MCC_Profile.md` symlink documents MCC's standard tooling and service delivery approach:
- RMM: Datto RMM
- Security: RocketCyber (EDR), Barracuda Email Security, Connect Secure
- Backup: Acronis Cyber Protect
- Network Infrastructure: Cisco Meraki, Ubiquiti UniFi, Fortinet FortiGate

**Location:** `../MCC_Profile/MCC_Profile.md`

### Related Directories
- `../Customer_Profiles/`: All MCC customer profiles
- `../powershell/`: PowerShell automation scripts for server configuration audits
- `../customer_onboarding/`: Onboarding processes and checklists
- `../team/`: MCC team member information
- `../sme/`: Subject Matter Expert assignments

## Key Customer Requirements

### Critical Business Needs
- **24/7 Operations:** Emergency propane service availability is critical
- **Dispatch System:** Core dispatch and routing systems must have minimal downtime
- **Tank Monitoring:** Telemetry and automated monitoring systems require constant connectivity
- **Fleet Operations:** GPS tracking and delivery systems are business-critical
- **Regulatory Compliance:** DOT and PHMSA regulations require proper documentation

### Industry Context
Helget Gas operates in the propane/gas distribution industry:
- Hazardous materials transportation (DOT regulations)
- Pipeline and hazmat safety (PHMSA)
- NFPA propane safety codes (NFPA 58, NFPA 54)
- Driver qualification and hours of service compliance
- Vehicle inspection and maintenance records

## Common Server Upgrade Tasks

### Pre-Upgrade Assessment
1. **Inventory Current Environment:**
   - Use `../powershell/Get-ServerConfiguration.ps1` for comprehensive server audits
   - Export results with `Get-ServerConfiguration-WithExport.ps1` for JSON output
   - Document Active Directory configuration and domain functional levels
   - Identify all server roles and dependencies

2. **Application Dependencies:**
   - Document line of business applications (dispatch, tank monitoring, fleet management)
   - Identify database servers and versions
   - Map application dependencies and integration points
   - Test application compatibility with newer OS versions

3. **Network Configuration:**
   - Document IP addressing, VLANs, and routing
   - Identify firewall rules and port requirements
   - Document VPN configurations for remote access
   - Map inter-site connectivity requirements

### Planning Considerations

**Maintenance Windows:**
- Coordinate with 24/7 operations requirements
- Avoid seasonal peak periods (winter heating season)
- Plan for emergency service continuity
- Schedule during lowest-impact timeframes

**Backup and Recovery:**
- Full system backups before any changes
- Test restoration procedures in advance
- Document rollback procedures
- Maintain Acronis Cyber Protect backups current

**Regulatory Compliance:**
- Maintain compliance documentation during transitions
- Ensure DOT records remain accessible
- Preserve driver qualification files and delivery records
- Keep hazmat training documentation available

### Implementation Approach

**Recommended Workflow:**
1. Read customer profile to understand current state
2. Run PowerShell audit scripts from `../powershell/` directory
3. Document findings in this workspace
4. Create implementation plan with rollback procedures
5. Schedule change with customer approval
6. Execute changes with proper backups
7. Validate all systems post-upgrade
8. Update customer profile with new configuration

## PowerShell Scripts Available

### Server Configuration Audit
**Location:** `../powershell/`

- `Get-ServerConfiguration.ps1`: Comprehensive server audit
  - OS version, roles, and features
  - Hardware specifications
  - Network configuration
  - Installed applications
  - Security settings

- `Get-ServerConfiguration-WithExport.ps1`: Audit with JSON export
  - Same as above with structured JSON output
  - Integration-ready for Datto RMM
  - See `Datto-Integration-Guide.md` for RMM integration

### Connectivity Testing
**Location:** `../powershell/`

- `Test-ADComputerConnectivity.ps1`: Full connectivity testing
  - Ping, WinRM, WMI, PSRemoting, RPC
  - CSV export for inventory
  - Useful for pre/post upgrade validation

- `Test-ADComputerConnectivity-Simple.ps1`: PowerShell 2.0 compatible version
  - For legacy server environments

### Domain Administration
**Location:** `../powershell/`

- `New-DomainAdminAccount.ps1`: Automated admin account creation
  - See accompanying documentation:
    - `New-DomainAdminAccount-README.md`: Usage guide
    - `New-DomainAdminAccount-OVERVIEW.md`: Architecture overview
    - `New-DomainAdminAccount-SecurityChecklist.md`: Security best practices
    - `New-DomainAdminAccount-DattoSetup.md`: Datto RMM integration

## Best Practices for Server Upgrades

### Documentation Requirements
1. **Pre-Upgrade:**
   - Complete system inventory
   - Application compatibility matrix
   - Network configuration baseline
   - Backup verification and test restores

2. **During Upgrade:**
   - Change log with timestamps
   - Issues encountered and resolutions
   - Configuration changes made
   - Rollback decision points

3. **Post-Upgrade:**
   - Validation test results
   - Performance baseline comparisons
   - User acceptance testing
   - Updated customer profile

### Communication
- Provide advance notice per service agreement
- Identify emergency contacts for 24/7 operations
- Establish clear escalation procedures
- Schedule post-implementation review

### Risk Mitigation
- Always have tested rollback procedures
- Keep original configurations documented
- Maintain business continuity for critical systems
- Test integrations (dispatch ↔ tank monitoring ↔ billing)

## Working in This Workspace

### Creating Server Upgrade Documentation
1. Review `Helget_Gas_profile.md` for current state
2. Run audit scripts from `../powershell/` directory
3. Create upgrade plan document in this workspace
4. Document all changes and configurations
5. Update customer profile upon completion

### Running PowerShell Scripts
All PowerShell scripts are in `../powershell/` directory. Example usage:

```powershell
# From this workspace
..\powershell\Get-ServerConfiguration.ps1 -ComputerName SERVER01 -Verbose

# Export to JSON for documentation
..\powershell\Get-ServerConfiguration-WithExport.ps1 -ComputerName SERVER01 -OutputPath ./audit_results.json
```

### Security Considerations
- Never commit credentials to repository
- Use Keeper Security for credential storage
- Encrypt sensitive configuration data
- Follow least-privilege principles
- Document who has access to what systems

## n8n Integration Available

The parent repository has n8n MCP server configured for automation:
- Automated reporting and alerting
- Integration between monitoring tools
- Workflow automation for common tasks

Refer to `../n8n-workflows/` for examples and `../n8n-workflows/CLAUDE.md` for guidance.

## Critical Reminders

### Industry-Specific Considerations
1. **24/7 Emergency Service:** All changes must account for emergency dispatch capabilities
2. **Tank Telemetry:** Automated tank monitoring requires constant connectivity
3. **DOT Compliance:** Maintain access to required transportation records
4. **Seasonal Demand:** Winter heating season is high-risk for changes
5. **Fleet Operations:** GPS and routing systems are critical for daily operations

### MCC Service Standards
- Changes require customer approval per service agreement
- Maintain documentation in customer profile
- Follow MCC's technology stack where applicable
- Coordinate with assigned SME (check `../sme/customer_smes.md`)
- Use Zoho Desk for ticket tracking and communication

## Getting Started

**For Server Upgrades:**
1. Read `Helget_Gas_profile.md` to understand current environment
2. Review `MCC_Profile.md` for MCC's standard technology stack
3. Run audit scripts from `../powershell/` to baseline current state
4. Create upgrade plan with proper maintenance windows
5. Obtain customer approval before proceeding
6. Execute with tested rollback procedures ready
7. Update customer profile with new configuration

**For Emergency Support:**
1. Check customer profile for critical system information
2. Review 24/7 operations requirements
3. Coordinate with emergency dispatch team
4. Follow escalation procedures in profile
5. Document all emergency changes for review
