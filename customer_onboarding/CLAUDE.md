# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **customer onboarding** repository for Midwest Cloud Computing (MCC), a Managed Service Provider. It contains standardized processes, checklists, and templates for onboarding new MSP customers and managing MSP-to-MSP client transitions.

## Core Purpose

The repository serves two primary functions:
1. **New Customer Onboarding**: Streamlined process for bringing new clients into MCC's managed services
2. **MSP Transition Management**: Comprehensive checklist for inheriting customers from other MSPs

## Repository Structure

```
/home/wferrel/ai/customer_onboarding/
├── Onboarding_Notes.md           # Template for daily onboarding tracking
├── MSP_Transition_Checklist.md   # 18-section checklist for MSP transitions
├── MCC_Profile.md                # MCC company profile and technology stack reference
└── .claude/                      # Claude Code configuration
```

### Related Directories
- `../Customer_Profiles/`: Individual customer profiles (using Template_Customer-profile.md)
- `../powershell/`: PowerShell automation scripts for configuration audit and deployment
- `../sme/`: Subject Matter Expert assignments for customers
- `../team/`: Team member information

## Key Documents

### 1. Onboarding_Notes.md

**Purpose:** Daily tracking template for new customer onboarding

**10-Step Onboarding Process:**
1. Enter customer details into source of truth
2. Datto RMM setup (site creation, agent deployment)
3. Datto AV/EDR organization setup
4. Email filtering (Barracuda) tenant creation and configuration
5. Credentials transfer via Keeper Security
6. Connect Secure agent deployment with RMM variables
7. M365 permissions setup (Global Admin and granular delegation)
8. Ticketing system (Zoho Desk) setup
9. Document employee onboarding/offboarding processes
10. RocketCyber tenant setup, integrations, and agent deployment

**Connect Secure RMM Variables (Site-Level):**
- `cybercnscompany_id`: Customer-specific ID
- `cybercnstenantid`: MCC's tenant ID (constant across all customers)
- `cybercnstoken`: Unique deployment token per customer

Once variables are created, add the site to the "Connect Secure Agent" Site Group for deployment.

### 2. MSP_Transition_Checklist.md

**Purpose:** Comprehensive 550+ line checklist for inheriting customers from other MSPs

**18 Major Sections:**
1. Network Infrastructure Documentation
2. Credentials and Access Information
3. Server and Workstation Inventory
4. Active Directory and Identity Management
5. Email and Collaboration Systems
6. Security Infrastructure
7. Backup and Disaster Recovery
8. Applications and Licensing
9. Telecommunications and VoIP
10. Monitoring and Management Tools
11. Service Delivery Documentation
12. Vendor and Third-Party Relationships
13. Compliance and Audit Documentation
14. Cloud Infrastructure
15. Knowledge Transfer and Handoff
16. Open Issues and Projects
17. Financial and Billing Information
18. Transition Logistics

**Critical Handoff Items:**
- Complete credential inventory (admin accounts, cloud services, vendor portals)
- RMM agent removal and replacement strategy
- Ticket history export (minimum 12 months)
- Documentation repository access
- Known issues and technical debt inventory

### 3. MCC_Profile.md

**Purpose:** Reference document for MCC's technology stack and service delivery approach

**Core Technology Stack:**

**RMM & PSA:**
- Datto RMM (monitoring, patching, remote access)
- Zoho Desk & Projects (ticketing and project management)

**Security Stack:**
- RocketCyber (Kaseya MDR) - EDR with 24/7 SOC
- Barracuda Email Security
- Connect Secure (ConnectSecure) - Vulnerability & compliance management
- KnowBe4 - Security awareness training
- Keeper Security - Password management
- Microsoft Entra ID - Identity & access management

**Backup:**
- Acronis Cyber Protect

**Network Infrastructure (Multi-Vendor):**
- Cisco Meraki (MX/MS/MR series)
- Ubiquiti UniFi (UDM, switches, APs)
- Fortinet FortiGate

**Cloud & Virtualization:**
- Microsoft 365 / Azure
- AWS
- VMware vSphere
- Microsoft Hyper-V

## Customer Profile Integration

Customer profiles are managed in `../Customer_Profiles/` using the standardized template:
- `Template_Customer-profile.md`: Comprehensive template covering business info, technology stack, licensing, security posture, and compliance requirements
- Individual customer profiles follow the naming: `[Customer_Name]_profile.md`

## PowerShell Automation

The `../powershell/` directory contains automation scripts relevant to onboarding:

**Server Configuration Audit:**
- `Get-ServerConfiguration.ps1`: Comprehensive server audit script
- `Get-ServerConfiguration-WithExport.ps1`: Server audit with JSON export
- `Datto-Integration-Guide.md`: Guide for integrating audit data with Datto RMM

**Connectivity Testing:**
- `Test-ADComputerConnectivity.ps1`: Full AD computer connectivity testing
- `Test-ADComputerConnectivity-Simple.ps1`: PowerShell 2.0 compatible version
- `README-Connectivity-Scripts.md`: Usage documentation

**Network Configuration:**
- Scripts support Server 2008 R2+ environments
- Test ping, WinRM, WMI, PSRemoting, and RPC connectivity
- Export detailed CSV reports for inventory and planning

## Workflow Patterns

### New Customer Onboarding Workflow

1. **Pre-Onboarding:**
   - Create customer profile from template
   - Collect customer information (use Onboarding_Notes.md checklist)
   - Verify service agreement and scope

2. **Technical Setup (Steps 1-10 in Onboarding_Notes.md):**
   - Deploy RMM and monitoring
   - Configure security stack (email, EDR, vulnerability scanning)
   - Establish credential management
   - Configure ticketing and documentation

3. **Post-Onboarding:**
   - Document employee lifecycle processes
   - Establish SLA baselines
   - Schedule recurring maintenance and reviews

### MSP Transition Workflow

1. **Discovery Phase:**
   - Use MSP_Transition_Checklist.md sections 1-10
   - Document existing infrastructure and services
   - Collect credentials and access

2. **Knowledge Transfer:**
   - Use sections 11-15 of checklist
   - Schedule handoff sessions
   - Review documentation and tribal knowledge

3. **Transition Execution:**
   - Use sections 16-18 of checklist
   - Deploy MCC tooling
   - Remove outgoing MSP access
   - Client sign-off

## MCC Service Philosophy

**Key Principles:**
- Customer empowerment over vendor lock-in
- Transparent communication and realistic expectations
- Long-term partnership approach
- 24/7 support availability
- Lean operations with internet-dependent model

**Target Market:** SMBs seeking strategic technology partnership

## Common Patterns

### Barracuda Email Security Setup
1. Create tenant in Barracuda portal
2. Import/invite users
3. Configure DNS records (MX, SPF, DKIM)
4. Configure mail hosting (typically M365)
5. Schedule quarantine notifications
6. Enable whitelisting rules
7. Test mailflow
8. Add domains to MX monitoring

### Connect Secure Deployment
1. Create customer in Connect Secure portal
2. Create three site-level RMM variables (cybercnscompany_id, cybercnstenantid, cybercnstoken)
3. Add site to "Connect Secure Agent" Site Group in Datto RMM
4. Agent deploys automatically
5. Verify initial scan and discovery

### Credential Management with Keeper
1. Create customer vault/folder in Keeper
2. Use secure transfer method for initial population
3. Implement least-privilege access model
4. Document credential rotation schedule
5. Integrate with MFA where possible

## Important Notes

### Licensing Considerations
- Understand customer's current Microsoft 365 licensing (document in customer profile)
- ConnectSecure requires per-company setup with API credentials
- RocketCyber licensing typically bundled with service agreements

### Compliance Requirements
Common compliance frameworks for MCC customers:
- HIPAA (healthcare clients)
- PCI-DSS (retail/payment processing)
- SOC 2 (service providers)
- General data protection and privacy

Document compliance requirements in customer profiles and configure tools accordingly.

### Change Management
- Maintenance windows should be documented during onboarding
- Critical business periods must be identified to avoid service disruptions
- Changes require customer approval per service agreement

### Documentation Standards
- Update customer profiles after significant changes
- Track onboarding progress in Onboarding_Notes.md
- Maintain MSP transition documentation for 12+ months post-transition
- Use consistent naming conventions across all documentation

## Working in This Repository

### Creating New Customer Onboarding
1. Copy `Onboarding_Notes.md` and rename with customer name and date
2. Create corresponding customer profile in `../Customer_Profiles/`
3. Follow the 10-step process systematically
4. Document blockers and issues as they arise
5. Track follow-ups and key actions

### Managing MSP Transitions
1. Copy `MSP_Transition_Checklist.md` for the specific transition
2. Work through sections 1-18 methodically
3. Schedule knowledge transfer sessions early
4. Document gaps and missing information
5. Obtain sign-off from all parties upon completion

### Updating Documentation
- Customer profiles should be updated quarterly or after major changes
- Onboarding templates should be refined based on lessons learned
- MCC_Profile.md should reflect current technology stack and vendor changes
- Keep PowerShell scripts synchronized with current RMM/security tools

## Technical Context

### Datto RMM Site Variables
Site-level variables are stored in Datto RMM and can be referenced by components:
- Access via `$env:VariableName` in PowerShell components
- Use for customer-specific configuration (API keys, tenant IDs, etc.)
- Encrypt sensitive values in Datto interface

### n8n Integration Available
The parent repository (`/home/wferrel/ai/`) has n8n MCP server configured. Workflows can be created to automate:
- Customer creation in Connect Secure
- Barracuda tenant provisioning
- Automated reporting and alerting
- Integration between tools

Refer to `../n8n-workflows/` for examples.

## Security Considerations

### Credential Handling
- Never commit credentials to this repository
- Use Keeper Security for customer credential storage
- RMM variables should be encrypted in Datto
- API keys should be rotated regularly

### Access Control
- Customer profiles may contain sensitive business information
- Limit repository access to authorized MCC staff
- Follow least-privilege principles for tool access
- Document who has access to what in customer profiles

## Getting Started

**For New Customer Onboarding:**
1. Read `Onboarding_Notes.md` to understand the 10-step process
2. Review `MCC_Profile.md` to understand MCC's technology stack
3. Create customer profile from `../Customer_Profiles/Template_Customer-profile.md`
4. Begin Step 1 and work systematically through the process

**For MSP Transitions:**
1. Read `MSP_Transition_Checklist.md` in full before starting
2. Schedule initial meeting with outgoing MSP
3. Begin documentation collection (sections 1-10)
4. Plan knowledge transfer sessions (section 15)
5. Execute transition logistics (section 18)

**For Updates:**
- Customer information goes in `../Customer_Profiles/`
- Onboarding process refinements update this repository
- Technology stack changes update `MCC_Profile.md`
- New automation scripts go in `../powershell/`
