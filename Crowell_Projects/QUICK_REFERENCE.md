# Crowell Memorial Home - Quick Reference

**Last Updated:** 2025-12-11

## Emergency Contacts

**Primary Technical Contact:**
- Kylea Punke - Business Office Manager
- Email: kpunke@crowellhome.com
- Phone: (402) 426-2177

**CEO:**
- Jaclyn Svendgard
- Email: jmsvendgard4@gmail.com

**Facility:**
- Address: 245 South 22nd Street, Blair, NE 68008
- Main Phone: (402) 426-2177

## Critical System Information

### Domain Controller (CRITICAL - EOL)
- **Server:** SERVER-FS1
- **OS:** Windows Server 2008 R2 (END OF LIFE - January 14, 2020)
- **IP:** 192.168.0.7
- **Domain:** crowell.local
- **Status:** ⚠️ NO SECURITY PATCHES - HIPAA COMPLIANCE RISK

### Network Infrastructure
**Firewall:** Fortinet FortiGate 80F
**Switches:**
- FortiSwitch 124E (24-port)
- HP 1910-24-POE (172.163.0.249)
- Ubiquiti USW Pro 24 (Great Plains managed)

**ISP:** Great Plains Communications
**IP Subnets:**
- 172.163.0.x (external/ISP)
- 192.168.0.x (internal AD)

### Active Directory Stats
- **Users:** 59
- **Computers:** 68
- **File Shares:** 10 (20.5 GB total)
- **Largest Share:** support (17.67 GB)

## Current Projects Status

| Project | Priority | Status | Next Action |
|---------|----------|--------|-------------|
| Infrastructure Relocation | Immediate | Quote Requested | Await approval |
| Azure AD Migration | CRITICAL | Planning | Complete assessment |
| Policy Files Migration | Medium | Planned | Inventory files |
| Workstation Replacements | Immediate | In Progress | Order PCs |
| Network Documentation | Medium | Ongoing | Create diagrams |

## Immediate Action Items

### This Week
- [ ] Schedule kick-off meeting with Kylea and Jaclyn
- [ ] Obtain signed Business Associate Agreement (BAA)
- [ ] Follow up on nursing station connectivity issues
- [ ] Review infrastructure relocation quote

### Workstation Replacements Needed
- **Prudy** - PC replacement
- **Nancy** - Computer: Shaurice, User: Kara (also remove Dropbox)
- **Sydney** - Computer: PC02, User: Curtis

### Nursing Station Issue
- **Location:** 2nd floor nursing stations (including computer "Erica")
- **Issue:** No internet connectivity overnight, restored by 8:00 AM
- **Action:** Follow up to confirm resolution and investigate root cause

## Vendor Contact Information

**Great Plains Communications**
- Services: Internet, Phone (Yealink), Ubiquiti Switch Management
- Contact: TBD
- Equipment: Ubiquiti USW Pro 24, patch panel, phone system
- **Coordination Required:** For infrastructure move and any network changes

**Diode Technologies**
- Phone: (402) 793-5124
- Services: Structured cabling, patch panels
- Equipment: Diode-branded patch panel (AP 1-8, WAN ports)
- **Coordination Required:** For infrastructure room relocation

## File Shares Reference

| Share | Size | Path | Purpose |
|-------|------|------|---------|
| support | 17.67 GB | C:\support | Support files (86% of total) |
| data | 2.25 GB | C:\data | General data |
| apps | 0.61 GB | C:\apps | Applications |
| Nursing Scan | 0.41 GB | C:\data\Nursing Scan | Nursing scans |
| KRONOS | 0.16 GB | C:\KRONOS | Time/attendance system |
| Admin_Scan | 0.00 GB | C:\data\Admin_Scan | Admin scanning |
| Scan | 0.00 GB | C:\data\Scan | OfficeJet scan destination |
| HHTTemp | 0.01 GB | C:\HHTTemp | Handheld temp files |
| NETLOGON | 0.00 GB | SYSVOL | Logon scripts |
| SYSVOL | 0.00 GB | SYSVOL | Domain policies |

## HIPAA Compliance Reminders

⚠️ **All work must comply with HIPAA Security Rule**

### Before Starting Any Work
- [ ] Business Associate Agreement (BAA) signed
- [ ] PHI handling procedures reviewed
- [ ] Secure communication methods used
- [ ] Audit logging enabled
- [ ] Data encryption verified

### Critical HIPAA Gaps (Current State)
1. Windows Server 2008 R2 - Unsupported OS (CRITICAL)
2. No Multi-Factor Authentication (MFA)
3. Weak file share permissions (e.g., "Nursing Scan" = Everyone Full Control)
4. Limited audit logging
5. Need disaster recovery validation

### Post-Migration HIPAA Improvements
- MFA for all users (Azure AD)
- Conditional access policies
- Modern endpoint protection
- Data encryption (SharePoint/OneDrive)
- Enhanced audit logging (Microsoft Purview)
- Improved access controls

## Infrastructure Room Relocation Details

**Current Location:** Second level IT room
**New Location:** Adjacent room, opposite side of same wall
**Current Setup:** 2 wall-mounted shelves/racks
**Proposed Setup:** 1 enclosed rack (consolidation opportunity)

**Equipment to Relocate:**
- Fortinet FortiGate 80F firewall
- Fortinet FortiSwitch 124E
- HP 1910-24-POE switch
- Ubiquiti USW Pro 24 (Great Plains managed)
- All patch panels (Diode, Great Plains, ICC)
- Tower servers (quantity TBD)
- Work desk and monitor

**Coordination Required:**
- Great Plains (Ubiquiti switch, phone system)
- Diode Technologies (patch panels)

**Documentation:**
- Photos: `../Customer_Profiles/Crowell/signal-2025-12-03-102320*.jpeg`
- Floor Plans: `../Customer_Profiles/Crowell/Crowell_Floor_Plans_Detailed.drawio`

## Azure AD Migration Overview

### Current State
- Windows Server 2008 R2 AD (crowell.local)
- 59 users, 68 computers
- 20.5 GB file shares
- No MFA, legacy authentication
- END OF LIFE - No patches since January 2020

### Target State
- Azure AD (Entra ID) for identity
- MFA enabled for all users
- SharePoint/OneDrive for files
- Intune for device management
- Modern security and compliance

### Migration Timeline
- **Phase 1:** Assessment & Planning (Weeks 1-2)
- **Phase 2:** Pre-Migration Setup (Weeks 3-4)
- **Phase 3:** Migration Execution (Month 2)
- **Phase 4:** Decommission & Validation (Months 2-3)

### Critical Questions to Answer
1. Is EHR system compatible with Azure AD?
2. Is eMAR system compatible with Azure AD?
3. Is KRONOS still in use? Cloud or on-prem requirement?
4. What is the IIS Default Web Site used for?
5. Can scanners work with cloud storage (SharePoint)?

## Useful PowerShell Commands

### On SERVER-FS1 (Domain Controller)

```powershell
# User and computer counts
Get-ADUser -Filter * | Measure-Object
Get-ADComputer -Filter * | Measure-Object

# Export user list
Get-ADUser -Filter * -Properties * | Export-Csv C:\temp\AD_Users.csv -NoTypeInformation

# Export computer list with OS
Get-ADComputer -Filter * -Properties OperatingSystem, LastLogonDate |
    Export-Csv C:\temp\AD_Computers.csv -NoTypeInformation

# Export group membership
Get-ADGroup -Filter * -Properties * | Export-Csv C:\temp\AD_Groups.csv -NoTypeInformation

# File share analysis
Get-SmbShare | Select-Object Name, Path
Get-ChildItem C:\data -Recurse | Measure-Object -Property Length -Sum

# DNS zones
Get-DnsServerZone

# Network configuration
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4'}
```

## Documentation Locations

### In This Repository
- **Customer Profile:** `../Customer_Profiles/Crowell_Home_profile.md`
- **Server Audit:** `../Customer_Profiles/Crowell/Crowell_server-fs1.md`
- **Infrastructure Photos:** `../Customer_Profiles/Crowell/`
- **Floor Plans (PDF):** `../Customer_Profiles/Crowell/Crowell_Building_Floor_Plan.pdf`
- **Floor Plans (DrawIO):** `../Customer_Profiles/Crowell/Crowell_Floor_Plans_Detailed.drawio`

### Project Documentation Templates
- **Meeting Notes:** `documentation/meeting_notes/TEMPLATE_Meeting_Notes.md`
- **Change Requests:** `documentation/change_requests/TEMPLATE_Change_Request.md`
- **Status Reports:** `documentation/project_status/TEMPLATE_Status_Report.md`

### Azure AD Migration
- **Assessment Checklist:** `02_Azure_AD_Migration/assessment/AD_Assessment_Checklist.md`

## Meeting Schedule

**Preferred Cadence:** Monthly
**Communication:** Email, phone, Teams
**After-Hours Availability:** Required for infrastructure changes (24/7 facility)

## 24/7 Operations Considerations

**Critical Systems (Must Remain Available):**
- Electronic Health Records (EHR)
- Electronic Medication Administration (eMAR)
- Nurse Call System
- Phone System
- Email

**Shift Schedule:**
- 7:00 AM - 3:00 PM (Day shift)
- 3:00 PM - 11:00 PM (Evening shift)
- 11:00 PM - 7:00 AM (Night shift)

**Preferred Maintenance Windows:**
- After hours (after 5:00 PM)
- Weekends
- Maximum downtime: 4 hours
- Advanced notice required

## Budget Notes

- **Organization Type:** Nonprofit
- **Preference:** OpEx over CapEx
- **Reimbursement:** Some IT costs may be Medicare/Medicaid reimbursable
- **Decision Makers:** Administrator, Board of Directors (for major expenditures)
- **Budget Cycle:** TBD

## Quick Links

- [Crowell Memorial Home Website](http://www.crowellhome.com/)
- [Full README](./README.md)
- [CLAUDE.md (AI Guidance)](./CLAUDE.md)
- [Customer Profile](../Customer_Profiles/Crowell_Home_profile.md)
- [MSP Onboarding Checklist](../customer_onboarding/MSP_Transition_Checklist.md)

---

**For MCC Internal Use Only**
**Contains Customer Proprietary Information**
**HIPAA Protected - Do Not Distribute**
