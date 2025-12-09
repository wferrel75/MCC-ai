# SERVER-FS1 - Infrastructure Audit Summary
**Crowell Memorial Home**

**Audit Date:** 2025-12-05 10:52:48

---

## Server Overview

**Server Name:** SERVER-FS1
**Operating System:** Microsoft Windows Server 2008 R2 Standard
**IP Address:** 192.168.0.7
**Status:** ⚠️ **END OF LIFE - CRITICAL UPGRADE REQUIRED**

> **SECURITY ALERT:** Windows Server 2008 R2 reached End of Life on January 14, 2020. This server is no longer receiving security updates and poses a significant HIPAA compliance risk.

---

## Active Directory Configuration

### Domain Information
- **Domain Name:** crowell.local
- **NetBIOS Name:** CROWELL
- **Forest Name:** crowell.local
- **Forest Functional Level:** 4 (Windows Server 2008 R2)
- **Domain Functional Level:** 4 (Windows Server 2008 R2)

### Domain Statistics
- **Total Users:** 59
- **Total Computers:** 68

### Domain Controller Details
- **Name:** SERVER-FS1
- **Operating System:** Windows Server 2008 R2 Standard
- **IP Address:** 192.168.0.7
- **Site:** Default-First-Site-Name
- **Read-Only DC:** No
- **Global Catalog:** Yes

### FSMO Roles (All hosted on SERVER-FS1)
- **Schema Master:** server-fs1.crowell.local
- **Domain Naming Master:** server-fs1.crowell.local
- **PDC Emulator:** server-fs1.crowell.local
- **RID Master:** server-fs1.crowell.local
- **Infrastructure Master:** server-fs1.crowell.local

---

## File Shares

### Share Overview
Total of 10 file shares configured with approximately **20.5 GB** of data.

| Share Name | Path | Size (GB) | Description |
|------------|------|-----------|-------------|
| Admin_Scan | C:\data\Admin_Scan | 0.00 | Administrative scanning |
| apps | C:\apps | 0.61 | Applications |
| data | C:\data | 2.25 | General data storage |
| HHTTemp | C:\HHTTemp | 0.01 | Handheld temporary files |
| KRONOS | C:\KRONOS | 0.16 | Kronos time/attendance system |
| NETLOGON | C:\Windows\SYSVOL\sysvol\crowell.local\SCRIPTS | 0.00 | Domain logon scripts |
| Nursing Scan | C:\data\Nursing Scan | 0.41 | Nursing department scanning |
| Scan | C:\data\Scan | 0.00 | OfficeJet 9010 scan destination |
| support | C:\support | 17.67 | Support files (largest share) |
| SYSVOL | C:\Windows\SYSVOL\sysvol | 0.00 | Domain policy storage |

### Key Share Permissions

**Admin_Scan:**
- CROWELL\wrksystems - Full Control
- CROWELL\Scan_Admin_Group - Full Control
- CROWELL\Scan_Admin - Full Control
- CROWELL\scanner - Full Control

**apps & data:**
- CROWELL\Domain Admins - Full Control
- CROWELL\Domain Users - Full Control

**KRONOS:**
- CROWELL\Domain Admins - Full Control
- CROWELL\Domain Users - Full Control

**Nursing Scan:**
- BUILTIN\Administrators - Full Control
- Everyone - Full Control ⚠️ (May need review for HIPAA)

**Scan:**
- Everyone - Read
- CROWELL\nursing - Full Control

**support:**
- CROWELL\Domain Users - Change (17.67 GB - largest share)

---

## DNS Server Configuration

**DNS Server:** SERVER-FS1

### DNS Zones

| Zone Name | Type | Dynamic Update | Records |
|-----------|------|----------------|---------|
| _msdcs.crowell.local | Primary (1) | Secure (2) | 12 |
| 0.168.192.in-addr.arpa | Primary (1) | Secure (2) | 22 |
| crowell.local | Primary (1) | Secure (2) | 78 |
| cmh.com | Forwarder (4) | None (0) | 0 |

**Note:** DNS zones are configured with secure dynamic updates, which is appropriate for Active Directory integration.

---

## Internet Information Services (IIS)

### IIS Status
- **IIS Installed:** Yes
- **Version:** IIS 7.5 (included with Server 2008 R2)

### Application Pools
1. **ASP.NET v4.0** - Integrated Pipeline - Started
2. **ASP.NET v4.0 Classic** - Classic Pipeline - Started
3. **DefaultAppPool** - Integrated Pipeline - Started

### Websites
**Default Web Site:**
- **Status:** Started
- **Physical Path:** %SystemDrive%\inetpub\wwwroot
- **Bindings:**
  - HTTP: *:80
  - net.tcp: 808:*
  - net.pipe: *
  - net.msmq: localhost
  - msmq.formatname: localhost

**Usage Assessment Needed:** Confirm if IIS is actively used for any applications (EHR, custom apps, etc.)

---

## DHCP Server

**Status:** Not Installed

DHCP services are likely provided by network infrastructure (FortiGate firewall or other network device).

---

## Print Server

**Status:** Not Installed

Print services are likely managed directly by workstations or network-attached printers.

---

## Installed Windows Features/Roles

### Core Roles
- **Active Directory Domain Services (AD DS)**
  - Domain Controller
  - Global Catalog
  - All 5 FSMO Roles

- **DNS Server**
  - Authoritative for crowell.local domain
  - Reverse lookup zone for 192.168.0.x

- **File Services**
  - File Server role
  - 10 active file shares

- **Web Server (IIS)**
  - Full IIS installation with application development features
  - ASP.NET support
  - ISAPI filters
  - Authentication (Basic, Windows)
  - Compression (static and dynamic)

### Additional Features
- **.NET Framework**
  - .NET Framework Core

- **Group Policy Management Console (GPMC)**

- **Remote Server Administration Tools (RSAT)**
  - AD Administration Tools
  - DNS Server Tools
  - Web Server Tools

- **SMTP Server**
  - Likely used for application email relay

- **SNMP Services**
  - SNMP Service
  - WMI Provider

- **PowerShell ISE**
  - Scripting and automation

---

## Migration Priorities

### ⚠️ CRITICAL - Immediate Action Required

**Windows Server 2008 R2 End of Life:**
- No security patches since January 14, 2020
- HIPAA compliance risk (unsupported OS handling PHI)
- Vulnerability to known exploits
- Potential liability in data breach scenarios

### Recommended Migration Path

**Option 1: Azure AD + Cloud Services (Recommended)**
1. Migrate Active Directory to Azure AD (Entra ID)
2. Migrate file shares to SharePoint Online / OneDrive
3. Decommission on-premises server
4. Benefits: Modern security, MFA, no hardware refresh, reduced maintenance

**Option 2: Hybrid Approach**
1. Deploy new Windows Server 2022 as domain controller
2. Migrate FSMO roles to new server
3. Migrate file shares to new server
4. Implement Azure AD Connect for hybrid identity
5. Decommission SERVER-FS1

**Option 3: On-Premises Only (Not Recommended)**
1. Deploy new Windows Server 2022
2. Migrate all roles to new server
3. Note: Still requires ongoing maintenance and eventual replacement

---

## File Share Migration Considerations

### Data to Migrate (20.5 GB Total)

**Largest Shares:**
- support (17.67 GB) - 86% of total storage
- data (2.25 GB)
- apps (0.61 GB)
- Nursing Scan (0.41 GB)

**Migration Options:**
1. **SharePoint Online** - Policy files, administrative documents
2. **OneDrive for Business** - Individual user files
3. **Azure Files** - Legacy application file shares (KRONOS, apps)
4. **New Windows Server** - If specific shares require SMB protocol

**Special Considerations:**
- KRONOS share (0.16 GB) - May require SMB for time/attendance system
- Scanning shares - Confirm if scanners can work with cloud storage or need SMB
- Apps share (0.61 GB) - May need to remain on file server for legacy apps

---

## Security & Compliance Concerns

### HIPAA Compliance Issues
1. ⚠️ **Unsupported Operating System** - Critical vulnerability
2. ⚠️ **Nursing Scan share** - Everyone has Full Control
3. ⚠️ Lack of Multi-Factor Authentication (legacy AD)
4. Need for audit logging and monitoring enhancements

### Recommendations
1. Immediate migration planning for Server 2008 R2
2. Review and tighten file share permissions
3. Implement Azure AD with MFA
4. Enable advanced logging and monitoring
5. Regular security audits

---

## Questions for Customer

1. **IIS Usage:** Is the Default Web Site actively used? What application(s)?
2. **KRONOS System:** Is this time/attendance system still in use? Cloud or on-prem?
3. **Scanning Workflow:** Can scanners work with cloud storage (SharePoint) or require SMB shares?
4. **apps Share:** What applications are stored here? Are they still needed?
5. **support Share (17.67 GB):** What type of data? Who uses it? Can it move to SharePoint?
6. **Migration Preference:** Azure AD + Cloud vs. Hybrid vs. New On-Prem Server?
7. **Budget & Timeline:** What is the priority and budget for this migration?

---

## Next Steps

### Phase 1: Assessment & Planning (Week 1-2)
- [ ] Review findings with Kylea Punke and Jaclyn Svendgard
- [ ] Identify application dependencies on file shares
- [ ] Determine KRONOS system requirements
- [ ] Assess scanner compatibility with cloud storage
- [ ] Choose migration path (Azure AD vs. Hybrid vs. On-Prem)

### Phase 2: Pre-Migration (Week 3-4)
- [ ] Set up Azure AD tenant (if cloud migration)
- [ ] Configure Microsoft 365 licenses
- [ ] Test file share access from cloud
- [ ] Plan user communication and training
- [ ] Document current state and migration plan

### Phase 3: Migration Execution (Month 2)
- [ ] Migrate user accounts to Azure AD
- [ ] Migrate file shares to cloud/new server
- [ ] Configure MFA for all users
- [ ] Migrate workstations to Azure AD join
- [ ] Cutover and testing

### Phase 4: Decommission (Month 2-3)
- [ ] Validate all services migrated
- [ ] Monitor for 2-4 weeks
- [ ] Gracefully decommission SERVER-FS1
- [ ] Update documentation

---

## Summary

SERVER-FS1 is serving as a single point of failure for all critical identity and file services at Crowell Memorial Home. The server's End of Life status presents a **critical security and compliance risk** that requires immediate attention.

**Recommended Action:** Prioritize migration to Azure AD with cloud-based file services (SharePoint/OneDrive) to eliminate on-premises server dependency, improve security posture, enable MFA, and ensure HIPAA compliance.

**Estimated Total Data:** 20.5 GB (easily migrated to cloud)
**Total Users:** 59
**Total Computers:** 68
**Timeline:** 60-90 days for full migration
