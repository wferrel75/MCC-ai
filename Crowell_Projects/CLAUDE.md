# CLAUDE.md - Crowell Memorial Home Projects

This file provides guidance to Claude Code (claude.ai/code) when working with Crowell Memorial Home customer projects.

## Customer Overview

**Customer:** Crowell Memorial Home
**Website:** http://www.crowellhome.com/
**Location:** 245 South 22nd Street, Blair, NE 68008
**Industry:** Healthcare - Continuing Care Retirement Community (CCRC) / Skilled Nursing Facility
**Founded:** 1905 (119+ years)
**Business Type:** Nonprofit, 24/7/365 operations

**Key Contacts:**
- **Primary Technical Contact:** Kylea Punke - Business Office Manager (kpunke@crowellhome.com)
- **CEO:** Jaclyn Svendgard (jmsvendgard4@gmail.com)

**Facility Capacity:**
- 88 Skilled Nursing Beds
- 80 Private Rooms
- 18 Assisted Living Apartments
- 8 Independent Living Apartments
- Memory Care Unit (Alzheimer's and dementia care)

## Critical Compliance Requirements

**HIPAA Compliance:** All work must comply with HIPAA Security Rule requirements
- Protected Health Information (PHI) handling
- Business Associate Agreement (BAA) required before any work
- Annual HIPAA risk assessments
- Audit trails and logging (6+ years retention)
- MFA required for all systems accessing PHI
- Encryption at rest and in transit
- Regular security awareness training

**Additional Regulations:**
- Medicare/Medicaid Conditions of Participation
- State healthcare licensing requirements
- CMS quality reporting requirements

## Current Infrastructure

### Network Infrastructure
**Firewall:** Fortinet FortiGate 80F (Second level IT room)
**Switches:**
- FortiSwitch 124E (24-port managed)
- HP 1910-24-POE (IP: 172.163.0.249)
- Ubiquiti USW Pro 24 port (managed by Great Plains - coordination required)

**Patch Panels:**
- Diode Technologies patch panel (AP 1-8, WAN ports)
- Great Plains patch panel (with Ubiquiti switch)
- ICC branded equipment

**IP Addressing:** 172.163.0.x subnet (observed) and 192.168.0.x (internal AD)

**ISP:** Great Plains Communications
- Phone system (Yealink phones)
- Network management (Ubiquiti switch)
- Overhead paging: Extension 820

### Active Directory Domain
**⚠️ CRITICAL - END OF LIFE SYSTEM:**
- **Domain:** crowell.local
- **Domain Controller:** SERVER-FS1
- **OS:** Windows Server 2008 R2 Standard (EOL: January 14, 2020)
- **IP Address:** 192.168.0.7
- **Total Users:** 59
- **Total Computers:** 68
- **All FSMO Roles:** Hosted on single DC (SERVER-FS1)

**Forest/Domain Functional Level:** Windows Server 2008 R2

### File Shares (20.5 GB Total)
Located on SERVER-FS1:
- support (17.67 GB) - Largest share, 86% of total
- data (2.25 GB)
- apps (0.61 GB)
- Nursing Scan (0.41 GB)
- KRONOS (0.16 GB) - Time/attendance system
- Admin_Scan, HHTTemp, Scan, NETLOGON, SYSVOL

### Additional Services on SERVER-FS1
- **DNS Server:** Authoritative for crowell.local
- **IIS 7.5:** Default Web Site running (usage TBD)
- **SMTP Server:** Application email relay
- **SNMP Services:** Monitoring

## Active Projects

### 1. Infrastructure Room Relocation (Immediate Priority)
**Status:** Quote requested, awaiting approval
**Timeline:** 0-30 days
**Location:** Second level - move to opposite side of same wall (adjacent room)

**Equipment to Relocate:**
- Fortinet FortiGate 80F firewall
- Fortinet FortiSwitch 124E
- HP 1910-24-POE switch (172.163.0.249)
- Ubiquiti USW Pro 24 port (Great Plains managed)
- All patch panels (Diode, Great Plains, ICC)
- Tower servers (quantity TBD)
- Work desk and monitor

**Coordination Required:**
- Great Plains Communications (Ubiquiti, phone system)
- Diode Technologies (402.793.5124)

**Opportunities:**
- Consolidate 2 wall-mounted racks to 1 proper enclosed rack
- Improve cable management
- Document IP addressing and network topology

**Documentation:**
- Floor plans: `../Customer_Profiles/Crowell/Crowell_Floor_Plans_Detailed.drawio` (recommended)
- Current state photos: `../Customer_Profiles/Crowell/signal-2025-12-03-102320*.jpeg`

### 2. Server 2008 R2 to Azure AD Migration (CRITICAL)
**Status:** Planning phase
**Timeline:** 1-6 months (HIGH PRIORITY)
**Security Risk:** Unsupported OS, no security patches since January 2020

**Current State:**
- Windows Server 2008 R2 Domain Controller (END OF LIFE)
- 59 users, 68 computers
- Single DC with all FSMO roles
- 20.5 GB file shares
- IIS, DNS, SMTP, SNMP services

**Recommended Migration Path:**
1. Azure AD (Entra ID) for identity management
2. SharePoint Online / OneDrive for file shares
3. Azure Files for legacy app shares (KRONOS)
4. Decommission on-premises SERVER-FS1

**Benefits:**
- Modern security with MFA (HIPAA requirement)
- No hardware refresh needed
- Reduced maintenance overhead
- Improved disaster recovery
- HIPAA compliance improvements

**Pre-Migration Assessment:**
- [ ] Document current AD structure, OUs, GPOs
- [ ] Identify all application dependencies
- [ ] Assess workstation compatibility with Azure AD
- [ ] Review current authentication methods
- [ ] Confirm KRONOS system requirements (time/attendance)
- [ ] Test scanner compatibility with cloud storage
- [ ] Identify IIS website purpose and usage

**Migration Phases:**
- Phase 1: Assessment & Planning (Weeks 1-2)
- Phase 2: Pre-Migration Setup (Weeks 3-4)
- Phase 3: Migration Execution (Month 2)
- Phase 4: Decommission & Validation (Months 2-3)

### 3. Policy Files to SharePoint Migration
**Status:** Planned
**Timeline:** 1-6 months
**Owner:** Jaclyn Svendgard (CEO)

**Scope:**
- Consolidate Jaclyn's policy files to SharePoint
- Configure appropriate permissions and access controls
- Ensure HIPAA compliance for PHI-related policies
- Establish version control and approval workflow
- Train staff on accessing policies from SharePoint

### 4. User Workstation Tasks (Immediate)
**PC Replacements Needed:**
- Prudy - PC replacement
- Nancy - PC replacement | Computer: Shaurice, User: Kara
- Sydney - PC replacement | Computer: PC02, User: Curtis

**Software Issues:**
- Nancy's computer: Remove Dropbox (logs in as Kara)

**Network Connectivity Issues:**
- 2nd floor nursing station computers (including "Erica")
- Symptom: No internet connectivity overnight, restored by 8:00 AM
- **ACTION:** Follow up to confirm resolution and investigate root cause

## Project Directory Structure

```
Crowell_Projects/
├── 01_Infrastructure_Relocation/
│   ├── quotes/
│   ├── site_surveys/
│   ├── installation_plans/
│   └── documentation/
├── 02_Azure_AD_Migration/
│   ├── assessment/
│   ├── planning/
│   ├── testing/
│   └── implementation/
├── 03_Policy_Files_Migration/
│   ├── inventory/
│   ├── sharepoint_structure/
│   └── training/
├── 04_Workstation_Replacements/
│   ├── inventory/
│   ├── deployment_plans/
│   └── user_data_migration/
├── 05_Network_Documentation/
│   ├── topology_diagrams/
│   ├── ip_address_management/
│   └── configuration_backups/
└── documentation/
    ├── meeting_notes/
    ├── change_requests/
    └── project_status/
```

## Customer Profile Reference

**Full Customer Profile:** `../Customer_Profiles/Crowell_Home_profile.md`
**Server Documentation:** `../Customer_Profiles/Crowell/Crowell_server-fs1.md`
**Infrastructure Photos:** `../Customer_Profiles/Crowell/signal-2025-12-03-102320*.jpeg`
**Floor Plans:**
- PDF: `../Customer_Profiles/Crowell/Crowell_Building_Floor_Plan.pdf`
- DrawIO (Detailed): `../Customer_Profiles/Crowell/Crowell_Floor_Plans_Detailed.drawio` ⭐ Recommended

## Common Tasks & Commands

### Infrastructure Assessment
```powershell
# Server inventory (when running on SERVER-FS1)
Get-ADComputer -Filter * | Select-Object Name, OperatingSystem
Get-ADUser -Filter * | Measure-Object

# File share analysis
Get-SmbShare | Select-Object Name, Path
Get-ChildItem C:\data -Recurse | Measure-Object -Property Length -Sum

# DNS zone review
Get-DnsServerZone
Get-DnsServerResourceRecord -ZoneName crowell.local
```

### Network Documentation
```powershell
# IP configuration
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4'}
Get-NetRoute | Where-Object {$_.DestinationPrefix -eq '0.0.0.0/0'}

# Network adapter details
Get-NetAdapter | Select-Object Name, Status, LinkSpeed, MacAddress
```

### Azure AD Migration Prep
```powershell
# Azure AD Connect prerequisites
# Install Azure AD Connect on a domain-joined server
# Download from: https://www.microsoft.com/en-us/download/details.aspx?id=47594

# Pre-migration checks
Get-ADUser -Filter * | Select-Object SamAccountName, UserPrincipalName
Get-ADGroup -Filter * | Select-Object Name, GroupScope
```

## Security Considerations

### HIPAA-Specific Requirements
- **Access Controls:** MFA required for all users accessing PHI
- **Audit Logging:** Enable comprehensive logging for all systems
- **Data Encryption:** At rest and in transit for all PHI
- **Automatic Logoff:** Configure session timeouts
- **Physical Safeguards:** Secure IT room, workstation security
- **Contingency Planning:** Disaster recovery and emergency mode operations

### Current Security Gaps
1. ⚠️ **CRITICAL:** Unsupported Windows Server 2008 R2 OS
2. ⚠️ Legacy AD without MFA
3. ⚠️ "Nursing Scan" share has Everyone - Full Control
4. Need for enhanced audit logging and monitoring
5. Backup and disaster recovery plan validation needed

### Security Improvements (Post-Migration)
- Azure AD with MFA for all users
- Conditional access policies
- Advanced threat protection (Microsoft Defender)
- Automated security patching
- Cloud-based backup and disaster recovery
- Enhanced audit logging (Microsoft Purview)

## Vendor Coordination

### Great Plains Communications
- **Services:** Internet, phone system (Yealink), network management
- **Equipment:** Ubiquiti USW Pro 24 port switch, patch panel
- **Coordination Required:** Infrastructure move, phone system changes
- **Contact:** TBD

### Diode Technologies
- **Phone:** (402) 793-5124
- **Services:** Structured cabling, patch panel infrastructure
- **Coordination Required:** Patch panel relocation

### MCC (MSP)
- **Service Level:** Fully Managed
- **Meeting Cadence:** Monthly preferred
- **BAA Status:** Required - must be signed before PHI access
- **24/7 Support:** Critical for clinical systems

## Documentation Standards

### Project Documentation
- Meeting notes in `documentation/meeting_notes/`
- Change requests in `documentation/change_requests/`
- Project status updates in `documentation/project_status/`

### File Naming Conventions
- Meeting notes: `YYYY-MM-DD_Meeting_Topic.md`
- Change requests: `CR-YYYYMMDD-Description.md`
- Status reports: `Status_YYYY-MM-DD.md`

### Required Documentation for Changes
1. Change request with business justification
2. Impact assessment (users, systems, downtime)
3. Rollback plan
4. Testing results
5. Customer approval
6. Implementation notes
7. Post-implementation validation

## Critical Success Factors

### For Infrastructure Relocation
- Minimal downtime (< 4 hours during off-hours)
- All equipment functional post-move
- No impact to 24/7 nursing operations
- Improved cable management and organization
- Updated network documentation

### For Azure AD Migration
- Zero data loss
- MFA enabled for all users (HIPAA compliance)
- File shares accessible to authorized users
- No impact to clinical operations (EHR, eMAR, nurse call)
- HIPAA compliance maintained/improved
- Cost-effective (OpEx preferred over CapEx)
- Decommission of unsupported Server 2008 R2

### For All Projects
- HIPAA compliance maintained at all times
- 24/7 operations not disrupted
- Clear communication with Kylea and Jaclyn
- User training provided as needed
- Comprehensive documentation
- BAA in place before any PHI access

## Key Stakeholders

**Decision Makers:**
- Jaclyn Svendgard (CEO) - Strategic decisions, policy files
- Kylea Punke (Business Office Manager) - Technical contact, day-to-day IT

**Affected Departments:**
- Nursing staff (24/7 shifts) - Clinical systems, file shares
- Administrative staff - Office systems, email, SharePoint
- Dietary - Meal planning systems
- Activities - Resident activity tracking
- Billing - Medicare/Medicaid claims
- IT (if applicable) - System administration

**External Stakeholders:**
- Great Plains Communications - Network and phone services
- Diode Technologies - Structured cabling
- EHR vendor (TBD) - Electronic health records system
- KRONOS vendor (TBD) - Time/attendance system

## Next Steps Checklist

### Immediate (This Week)
- [ ] Schedule meeting with Kylea and Jaclyn to review priorities
- [ ] Obtain signed Business Associate Agreement (BAA)
- [ ] Follow up on nursing station connectivity issues
- [ ] Begin infrastructure relocation planning

### Short-Term (Next Month)
- [ ] Complete infrastructure room relocation
- [ ] Begin Azure AD migration assessment
- [ ] Document current AD structure and dependencies
- [ ] Identify KRONOS and IIS requirements
- [ ] Order PC replacements (Prudy, Nancy, Sydney)

### Long-Term (Next 3-6 Months)
- [ ] Execute Azure AD migration
- [ ] Migrate policy files to SharePoint
- [ ] Implement MFA for all users
- [ ] Decommission SERVER-FS1
- [ ] Update all documentation
- [ ] Conduct HIPAA compliance review

## Additional Resources

- **Customer Profile:** `../Customer_Profiles/Crowell_Home_profile.md`
- **Server Audit:** `../Customer_Profiles/Crowell/Crowell_server-fs1.md`
- **Infrastructure Photos:** `../Customer_Profiles/Crowell/` directory
- **MCC MSP Operations:** `../customer_onboarding/MSP_Transition_Checklist.md`
- **Azure AD Migration Guide:** TBD (create in project directory)
- **HIPAA Compliance Guide:** TBD (create in project directory)
