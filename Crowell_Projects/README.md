# Crowell Memorial Home - Project Management

This directory contains all active and historical projects for Crowell Memorial Home, a nonprofit continuing care retirement community in Blair, Nebraska.

## Customer Information

**Organization:** Crowell Memorial Home
**Website:** http://www.crowellhome.com/
**Address:** 245 South 22nd Street, Blair, NE 68008
**Phone:** (402) 426-2177
**Industry:** Healthcare - CCRC / Skilled Nursing Facility
**Founded:** 1905

**Key Contacts:**
- **Kylea Punke** - Business Office Manager (kpunke@crowellhome.com) - Primary Technical Contact
- **Jaclyn Svendgard** - CEO (jmsvendgard4@gmail.com)

**Critical Requirements:**
- ⚠️ **HIPAA Compliance** - All work must comply with HIPAA Security Rule
- ⚠️ **24/7 Operations** - Healthcare facility requires high availability
- ⚠️ **BAA Required** - Business Associate Agreement must be signed before PHI access

## Active Projects

### 1. Infrastructure Room Relocation
**Priority:** Immediate (0-30 days)
**Status:** Quote requested
**Directory:** `01_Infrastructure_Relocation/`

Move IT equipment from current second-level location to adjacent room on opposite side of wall. Includes firewall, switches, patch panels, servers, and consolidation from 2 wall racks to 1 proper rack.

**Key Stakeholders:** Kylea Punke, Great Plains Communications, Diode Technologies

### 2. Azure AD Migration (CRITICAL)
**Priority:** HIGH - Security Risk
**Status:** Planning phase
**Timeline:** 1-6 months
**Directory:** `02_Azure_AD_Migration/`

Migrate from Windows Server 2008 R2 Active Directory (END OF LIFE since January 2020) to Azure AD (Entra ID). Includes 59 users, 68 computers, and 20.5 GB of file shares.

**Critical Issue:** Unsupported OS handling Protected Health Information (PHI) - HIPAA compliance risk

**Key Stakeholders:** Kylea Punke, Jaclyn Svendgard, all staff

### 3. Policy Files to SharePoint Migration
**Priority:** Medium
**Status:** Planned
**Timeline:** 1-6 months
**Directory:** `03_Policy_Files_Migration/`

Consolidate CEO's policy files to SharePoint Online with proper version control, permissions, and approval workflow.

**Key Stakeholder:** Jaclyn Svendgard (CEO)

### 4. Workstation Replacements
**Priority:** Immediate
**Status:** In progress
**Directory:** `04_Workstation_Replacements/`

Replace aging workstations for:
- Prudy (PC replacement)
- Nancy (Computer: Shaurice, User: Kara) - Also remove Dropbox
- Sydney (Computer: PC02, User: Curtis)

**Key Stakeholder:** Kylea Punke

### 5. Network Documentation
**Priority:** Medium
**Status:** Ongoing
**Directory:** `05_Network_Documentation/`

Create comprehensive network documentation including topology diagrams, IP address management (IPAM), and configuration backups.

## Current Infrastructure Summary

### Network Equipment
- **Firewall:** Fortinet FortiGate 80F
- **Switches:** FortiSwitch 124E, HP 1910-24-POE (172.163.0.249), Ubiquiti USW Pro 24
- **ISP:** Great Plains Communications
- **IP Subnets:** 172.163.0.x (observed), 192.168.0.x (internal AD)

### Active Directory Domain
- **Domain:** crowell.local
- **DC:** SERVER-FS1 (Windows Server 2008 R2 - **END OF LIFE**)
- **IP:** 192.168.0.7
- **Users:** 59
- **Computers:** 68
- **File Shares:** 20.5 GB total

## Project Directory Structure

```
Crowell_Projects/
├── README.md (this file)
├── CLAUDE.md (AI/Claude Code guidance)
│
├── 01_Infrastructure_Relocation/
│   ├── quotes/                 # Vendor quotes and proposals
│   ├── site_surveys/          # Site survey documentation
│   ├── installation_plans/    # Installation schedules and plans
│   └── documentation/         # Photos, diagrams, completion docs
│
├── 02_Azure_AD_Migration/
│   ├── assessment/            # Current state assessment
│   ├── planning/              # Migration plans and schedules
│   ├── testing/               # Test results and validation
│   └── implementation/        # Implementation notes and logs
│
├── 03_Policy_Files_Migration/
│   ├── inventory/             # Policy file inventory
│   ├── sharepoint_structure/  # SharePoint site structure design
│   └── training/              # User training materials
│
├── 04_Workstation_Replacements/
│   ├── inventory/             # Current workstation inventory
│   ├── deployment_plans/      # Deployment schedules
│   └── user_data_migration/   # User data migration plans
│
├── 05_Network_Documentation/
│   ├── topology_diagrams/     # Network topology diagrams
│   ├── ip_address_management/ # IP addressing documentation
│   └── configuration_backups/ # Device configuration backups
│
└── documentation/
    ├── meeting_notes/         # Customer meeting notes
    ├── change_requests/       # Change requests and approvals
    └── project_status/        # Weekly/monthly status reports
```

## Quick Links

### Customer Documentation
- [Full Customer Profile](../Customer_Profiles/Crowell_Home_profile.md)
- [Server Audit Report (FS1)](../Customer_Profiles/Crowell/Crowell_server-fs1.md)
- [Infrastructure Photos](../Customer_Profiles/Crowell/)
- [Floor Plans (Detailed)](../Customer_Profiles/Crowell/Crowell_Floor_Plans_Detailed.drawio)

### MCC Resources
- [MSP Transition Checklist](../customer_onboarding/MSP_Transition_Checklist.md)
- [Customer Onboarding Guide](../customer_onboarding/Onboarding_Notes.md)
- [PowerShell Scripts](../powershell/)

## Communication & Meetings

**Preferred Meeting Cadence:** Monthly
**Communication Methods:** Email, phone, Teams
**Primary Contact:** Kylea Punke (kpunke@crowellhome.com)

**Escalation Path:**
1. Kylea Punke (Business Office Manager) - Technical issues
2. Jaclyn Svendgard (CEO) - Strategic decisions, policy matters
3. MCC Account Manager - Service escalation

## Compliance & Security

### HIPAA Requirements
- ✅ Business Associate Agreement (BAA) must be signed
- ✅ Access controls and MFA for all users accessing PHI
- ✅ Audit logging (6+ years retention)
- ✅ Data encryption at rest and in transit
- ✅ Annual HIPAA training for all staff
- ✅ Breach notification procedures
- ✅ Regular risk assessments

### Current Security Gaps
1. ⚠️ **CRITICAL:** Windows Server 2008 R2 (unsupported since 2020)
2. ⚠️ No MFA on legacy Active Directory
3. ⚠️ File share permissions need review ("Nursing Scan" = Everyone Full Control)
4. Need enhanced audit logging and monitoring
5. Backup and DR plan validation required

## Project Status Dashboard

| Project | Status | Priority | Timeline | Next Action |
|---------|--------|----------|----------|-------------|
| Infrastructure Relocation | Quote Requested | Immediate | 0-30 days | Await approval |
| Azure AD Migration | Planning | CRITICAL | 1-6 months | Assessment phase |
| Policy Files Migration | Planned | Medium | 1-6 months | Inventory files |
| Workstation Replacements | In Progress | Immediate | 0-30 days | Order equipment |
| Network Documentation | Ongoing | Medium | Ongoing | Create diagrams |

## Recent Activity

### 2025-12-11
- Created Crowell_Projects directory structure
- Established project organization and documentation

### 2025-12-05
- Server audit completed (SERVER-FS1)
- Identified critical Windows Server 2008 R2 EOL issue
- Documented file shares (20.5 GB total)

### 2025-12-03
- Infrastructure photos captured
- Floor plans created (DrawIO format)
- Network equipment inventory completed

## Next Steps

### This Week
- [ ] Schedule kick-off meeting with Kylea and Jaclyn
- [ ] Obtain signed Business Associate Agreement (BAA)
- [ ] Follow up on nursing station connectivity issues
- [ ] Review infrastructure relocation quote

### Next Month
- [ ] Complete infrastructure room relocation
- [ ] Begin Azure AD migration assessment
- [ ] Order PC replacements for Prudy, Nancy, Sydney
- [ ] Document current AD structure and dependencies

### Next Quarter
- [ ] Execute Azure AD migration
- [ ] Migrate policy files to SharePoint
- [ ] Implement MFA for all users
- [ ] Decommission SERVER-FS1

## Notes & Considerations

### 24/7 Healthcare Operations
- All work must minimize impact to patient care
- Clinical systems (EHR, eMAR, nurse call) are critical
- Nursing staff works three shifts (7a-3p, 3p-11p, 11p-7a)
- After-hours work preferred for infrastructure changes

### Budget Preferences
- Nonprofit organization typically prefers OpEx over CapEx
- Medicare/Medicaid reimbursement may cover some IT costs
- Board approval likely required for significant expenditures

### Vendor Coordination
- **Great Plains Communications:** Phone system, Ubiquiti switch - coordination required
- **Diode Technologies:** (402) 793-5124 - Structured cabling and patch panels
- **EHR Vendor:** TBD - Critical dependency for migration planning
- **KRONOS Vendor:** TBD - Time/attendance system requirements

## Contact Information

### MCC Account Team
- **Account Manager:** TBD
- **Technical Lead:** TBD
- **Project Manager:** TBD

### Support
- **24/7 Support Required:** Yes (critical clinical systems)
- **Response Time:** 2 hours for P1 issues (EHR, nurse call, email)
- **BAA Status:** Required before PHI access

---

**Document Owner:** MCC MSP Team
**Last Updated:** 2025-12-11
**Next Review:** Weekly during active projects
