# Azure AD Migration - Assessment Checklist
**Crowell Memorial Home**

**Assessment Date:** 2025-12-11 - [End Date]
**Performed By:** MCC MSP Team
**Status:** [ ] Not Started [X] In Progress [ ] Completed

---

## 1. Current Active Directory Assessment

### Domain Configuration
- [X] **Domain Name:** crowell.local
- [X] **Forest Functional Level:** Windows Server 2008 R2 (Level 4)
- [X] **Domain Functional Level:** Windows Server 2008 R2 (Level 4)
- [X] **Total Domain Controllers:** 1 (SERVER-FS1)
- [X] **FSMO Role Holders Documented:** Yes
  - Schema Master: server-fs1.crowell.local
  - Domain Naming Master: server-fs1.crowell.local
  - PDC Emulator: server-fs1.crowell.local
  - RID Master: server-fs1.crowell.local
  - Infrastructure Master: server-fs1.crowell.local
  - **NOTE:** All FSMO roles on single DC - no redundancy

### Users & Groups
- [X] **Total User Accounts:** 59
- [ ] **Active Users:** ___
- [ ] **Disabled Users:** ___
- [ ] **Service Accounts:** ___
- [ ] **User UPN Suffix:** @crowell.local (default - needs verification via PowerShell)
- [ ] **Routable UPN Configured:** [ ] Yes [X] No (need to verify public domain ownership: crowellhome.com)
- [X] **Total Groups:** (TBD - needs documentation)
- [ ] **Security Groups:** ___
- [ ] **Distribution Groups:** ___
- [ ] **Nested Groups:** ___

**Export Commands:**
```powershell
# User account export
Get-ADUser -Filter * -Properties * | Export-Csv C:\temp\AD_Users.csv -NoTypeInformation

# Group membership export
Get-ADGroup -Filter * -Properties * | Export-Csv C:\temp\AD_Groups.csv -NoTypeInformation

# Service account identification
Get-ADUser -Filter {ServicePrincipalName -like "*"} | Select Name, ServicePrincipalName
```

### Organizational Units (OUs)
- [ ] **OU Structure Documented:** [ ] Yes [ ] No
- [ ] **OU Export Completed:** [ ] Yes [ ] No

**Export Command:**
```powershell
Get-ADOrganizationalUnit -Filter * | Select Name, DistinguishedName | Export-Csv C:\temp\AD_OUs.csv
```

### Group Policy Objects (GPOs)
- [ ] **Total GPOs:** ___
- [ ] **GPO Inventory Completed:** [ ] Yes [ ] No
- [ ] **GPO Export Completed:** [ ] Yes [ ] No
- [ ] **Critical GPOs Identified:** [ ] Yes [ ] No

**Critical GPO Categories:**
- [ ] Password policies
- [ ] Security settings
- [ ] Software deployment
- [ ] Drive mappings
- [ ] Printer mappings
- [ ] Scripts (logon/logoff)

**Export Commands:**
```powershell
# GPO inventory
Get-GPO -All | Select DisplayName, GpoStatus, CreationTime | Export-Csv C:\temp\GPOs.csv

# Backup all GPOs
Backup-GPO -All -Path C:\temp\GPO_Backups
```

### Computers
- [X] **Total Computer Accounts:** 68
- [ ] **Active Computers:** ___
- [ ] **Inactive Computers (90+ days):** ___
- [ ] **Operating Systems:**
  - [ ] Windows 11: ___
  - [ ] Windows 10: ___
  - [ ] Windows 8.1 or older: ___
  - [ ] Windows Server: ___

**Export Command:**
```powershell
Get-ADComputer -Filter * -Properties OperatingSystem, OperatingSystemVersion, LastLogonDate |
    Export-Csv C:\temp\AD_Computers.csv -NoTypeInformation
```

---

## 2. DNS & Network Services

### DNS Configuration
- [X] **DNS Server:** SERVER-FS1
- [X] **Total DNS Zones:** 4 (documented in server audit)
  - [X] crowell.local (Primary, 78 records, Secure Dynamic Updates)
  - [X] _msdcs.crowell.local (Primary, 12 records, Secure Dynamic Updates)
  - [X] 0.168.192.in-addr.arpa (Reverse, 22 records, Secure Dynamic Updates)
  - [X] cmh.com (Forwarder, no records)
- [ ] **DNS Zone Export Completed:** [ ] Yes [ ] No
- [ ] **External DNS Provider:** [ ] GoDaddy [ ] Cloudflare [ ] Other: ___
- [ ] **Public Domain Ownership Verified:** [ ] Yes [ ] No

**DNS Export Commands:**
```powershell
# Export all DNS records
Get-DnsServerZone | ForEach-Object {
    Get-DnsServerResourceRecord -ZoneName $_.ZoneName |
    Export-Csv "C:\temp\DNS_$($_.ZoneName).csv" -NoTypeInformation
}
```

### DHCP Services
- [X] **DHCP Server:** Not on SERVER-FS1
- [ ] **DHCP Location:** [X] Firewall (likely FortiGate 80F) [ ] Router [ ] Other Server: ___
- [ ] **DHCP Scope(s) Documented:** [ ] Yes [ ] No

---

## 3. File Services Assessment

### File Shares
- [X] **Total File Shares:** 10
- [X] **Total Storage Used:** 20.5 GB
- [ ] **Share Permissions Exported:** [ ] Yes [ ] No
- [ ] **NTFS Permissions Exported:** [ ] Yes [ ] No

**Documented Shares:**
| Share Name | Size (GB) | Path | Purpose | Migration Target |
|------------|-----------|------|---------|------------------|
| support | 17.67 | C:\support | Support files | [ ] SharePoint [ ] OneDrive [ ] Azure Files |
| data | 2.25 | C:\data | General data | [ ] SharePoint [ ] OneDrive [ ] Azure Files |
| apps | 0.61 | C:\apps | Applications | [ ] SharePoint [ ] Azure Files [ ] Keep on-prem |
| Nursing Scan | 0.41 | C:\data\Nursing Scan | Nursing scans | [ ] SharePoint [ ] Azure Files |
| Admin_Scan | 0.00 | C:\data\Admin_Scan | Admin scans | [ ] SharePoint [ ] Azure Files |
| Scan | 0.00 | C:\data\Scan | Scanner dest | [ ] SharePoint [ ] Azure Files |
| KRONOS | 0.16 | C:\KRONOS | Time/attendance | [ ] SharePoint [ ] Azure Files [ ] Keep on-prem |
| HHTTemp | 0.01 | C:\HHTTemp | Handheld temp | [ ] Delete [ ] Archive [ ] Migrate |
| NETLOGON | 0.00 | C:\Windows\SYSVOL\... | Logon scripts | [ ] Intune [ ] Azure Files |
| SYSVOL | 0.00 | C:\Windows\SYSVOL\... | Domain policies | [ ] Azure AD [ ] Intune |

**Export Commands:**
```powershell
# Share permissions
Get-SmbShare | Get-SmbShareAccess | Export-Csv C:\temp\Share_Permissions.csv

# Share sizes
Get-SmbShare | ForEach-Object {
    $path = $_.Path
    $size = (Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue |
             Measure-Object -Property Length -Sum).Sum / 1GB
    [PSCustomObject]@{
        Share = $_.Name
        Path = $path
        SizeGB = [math]::Round($size, 2)
    }
} | Export-Csv C:\temp\Share_Sizes.csv
```

### File Share Questions
- [ ] **support share (17.67 GB):** What type of files? Who accesses? Can it move to SharePoint?
- [ ] **apps share (0.61 GB):** What applications? Still needed? SMB required?
- [ ] **KRONOS share (0.16 GB):** Is KRONOS still in use? Cloud or on-prem? SMB requirement?
- [ ] **Scanning shares:** Can scanners work with SharePoint/OneDrive or require SMB?

---

## 4. Application Dependencies

### Applications Using Active Directory
- [ ] **Application Inventory Completed:** [ ] Yes [ ] No

| Application | Vendor | AD Dependency | Azure AD Compatible? | Migration Plan |
|-------------|--------|---------------|---------------------|----------------|
| EHR System | TBD | [ ] Yes [ ] No | [ ] Yes [ ] No [ ] Unknown | |
| eMAR | TBD | [ ] Yes [ ] No | [ ] Yes [ ] No [ ] Unknown | |
| KRONOS | TBD | [ ] Yes [ ] No | [ ] Yes [ ] No [ ] Unknown | |
| IIS Web App | TBD | [ ] Yes [ ] No | [ ] Yes [ ] No [ ] Unknown | |
| | | | | |

### Services Running on SERVER-FS1
- [X] **Active Directory Domain Services** - Migrate to Azure AD
- [X] **DNS Server** - Azure AD DNS / External DNS
- [X] **File Services (SMB)** - SharePoint / OneDrive / Azure Files
- [X] **IIS 7.5** - Need to identify application and migration path
- [X] **SMTP Server** - O365 SMTP relay / Azure
- [X] **SNMP Services** - Cloud monitoring alternatives

**IIS Investigation:**
- [ ] **IIS Application Identified:** [ ] Yes [ ] No
- [ ] **Application Purpose:** ___________
- [ ] **Still in Use:** [ ] Yes [ ] No
- [ ] **Migration Path:** [ ] Azure App Service [ ] Keep on-prem [ ] Retire

---

## 5. Security Assessment

### Current Security Posture
- [ ] **MFA Enabled:** [X] No (legacy AD doesn't support modern MFA)
- [ ] **Password Policy Documented:** [ ] Yes [ ] No
- [ ] **Account Lockout Policy:** [ ] Yes [ ] No
- [ ] **Fine-Grained Password Policies:** [ ] Yes [ ] No [ ] N/A
- [ ] **Privileged Access Workstations:** [ ] Yes [ ] No
- [ ] **Admin Account Separation:** [ ] Yes [ ] No

**Current Password Policy:**
```powershell
Get-ADDefaultDomainPasswordPolicy
```

### Security Gaps (Pre-Migration)
- [X] **No MFA** - Critical HIPAA compliance gap
- [X] **Windows Server 2008 R2 EOL** - No security patches since 2020
- [ ] **Legacy authentication protocols** - Need to identify and remediate
- [ ] **Weak password policies** - Need assessment
- [ ] **Overly permissive share permissions** - "Nursing Scan" = Everyone Full Control

### Audit & Logging
- [ ] **AD Audit Logging Enabled:** [ ] Yes [ ] No
- [ ] **Log Retention Period:** ___ days
- [ ] **SIEM Integration:** [ ] Yes [ ] No
- [ ] **Log Review Process:** [ ] Yes [ ] No

---

## 6. Azure AD Readiness

### Microsoft 365 Licensing
- [ ] **Current M365 Licenses:** [ ] Yes [ ] No
- [ ] **License Inventory Completed:** [ ] Yes [ ] No
- [ ] **Azure AD Premium Required:** [ ] P1 [ ] P2
- [ ] **License Quantities:**
  - [ ] Microsoft 365 Business Premium: ___
  - [ ] Azure AD Premium P1: ___
  - [ ] Azure AD Premium P2: ___
  - [ ] Office 365 E3: ___
  - [ ] Other: ___

**Azure AD Premium Features Needed:**
- [ ] Multi-Factor Authentication (HIPAA requirement)
- [ ] Conditional Access policies
- [ ] Self-service password reset
- [ ] Group-based licensing
- [ ] Cloud App Discovery
- [ ] Azure AD Connect Health (if hybrid)
- [ ] Identity Protection (P2)
- [ ] Privileged Identity Management (P2)

### Domain & UPN
- [ ] **Public Domain Owned:** [ ] crowellhome.com [ ] Other: ___
- [ ] **Domain Verified in M365:** [ ] Yes [ ] No
- [ ] **UPN Suffix Routable:** [ ] Yes [ ] No
- [ ] **UPN Matches Email:** [ ] Yes [ ] No

**UPN Remediation:**
```powershell
# Check current UPNs
Get-ADUser -Filter * | Select Name, UserPrincipalName

# Update UPN suffix (if needed)
Get-ADUser -Filter * | Set-ADUser -UserPrincipalName {"$($_.SamAccountName)@crowellhome.com"}
```

### Azure AD Connect vs. Cloud-Only
**Decision:** [ ] Hybrid (Azure AD Connect) [ ] Cloud-Only Migration

**Hybrid (Azure AD Connect) Considerations:**
- Pros: Gradual migration, keep on-prem AD for legacy apps
- Cons: Continued Server 2008 R2 risk, requires new DC, ongoing maintenance

**Cloud-Only Considerations:**
- Pros: Eliminate on-prem server, modern security (MFA), no ongoing DC maintenance
- Cons: All apps must support Azure AD, file shares must migrate to cloud
- **Recommendation:** Cloud-only preferred (20.5 GB data, 59 users, no obvious blockers)

---

## 7. Workstation Assessment

### Operating System Inventory
- [ ] **Workstation OS Report:** [ ] Yes [ ] No

**Expected Compatibility:**
- Windows 11: Full Azure AD join support
- Windows 10 (1803+): Full Azure AD join support
- Windows 10 (older): May need updates
- Windows 8.1 or older: Requires upgrade

**Export Command:**
```powershell
Get-ADComputer -Filter * -Properties OperatingSystem, OperatingSystemVersion |
    Group-Object OperatingSystem |
    Select Name, Count
```

### Azure AD Join Readiness
- [ ] **All workstations meet minimum OS:** [ ] Yes [ ] No
- [ ] **TPM 2.0 present (for Windows Hello):** [ ] Yes [ ] No [ ] Unknown
- [ ] **Intune enrollment planned:** [ ] Yes [ ] No

---

## 8. Migration Path Decision

### Recommended Approach: Cloud-Only Migration

**Justification:**
1. ✅ Small environment (59 users, 68 computers)
2. ✅ Limited data (20.5 GB easily migrates to cloud)
3. ✅ Eliminate Server 2008 R2 security risk
4. ✅ Enable modern MFA (HIPAA requirement)
5. ✅ Reduce infrastructure and maintenance costs
6. ⚠️ Need to validate: EHR, eMAR, KRONOS, IIS app compatibility

**Migration Components:**

| Component | Current | Target | Method |
|-----------|---------|--------|--------|
| Identity | AD (Server 2008 R2) | Azure AD | Cloud migration |
| Authentication | NTLM/Kerberos | Azure AD + MFA | Modern auth |
| File Shares | SMB on SERVER-FS1 | SharePoint / OneDrive | Cloud sync |
| Legacy App Shares | KRONOS, apps | Azure Files (SMB 3.0) | Cloud SMB |
| Email | TBD | Exchange Online | Already cloud? |
| Workstations | Domain-joined | Azure AD-joined | Re-join |
| Device Mgmt | GPO | Intune | Cloud MDM |
| DNS | On-prem | Azure AD DNS | Cloud DNS |

**Alternative: Hybrid Approach** (if blockers found)
- Deploy new Windows Server 2022 DC
- Migrate FSMO roles
- Implement Azure AD Connect
- Keep limited on-prem presence for legacy apps
- Decommission SERVER-FS1

---

## 9. Application Validation

### Critical Applications to Test
- [ ] **EHR System:** Vendor: ___ | Azure AD compatible: [ ] Yes [ ] No [ ] Testing
- [ ] **eMAR System:** Vendor: ___ | Azure AD compatible: [ ] Yes [ ] No [ ] Testing
- [ ] **KRONOS:** Vendor: ___ | Azure AD compatible: [ ] Yes [ ] No [ ] Testing
- [ ] **IIS Application:** Purpose: ___ | Azure AD compatible: [ ] Yes [ ] No [ ] Testing
- [ ] **Scanner/MFP:** Model: ___ | Cloud scanning: [ ] Yes [ ] No [ ] Testing

### Vendor Engagement
- [ ] **EHR Vendor contacted:** [ ] Yes [ ] No | Contact: ___
- [ ] **eMAR Vendor contacted:** [ ] Yes [ ] No | Contact: ___
- [ ] **KRONOS Vendor contacted:** [ ] Yes [ ] No | Contact: ___

---

## 10. HIPAA Compliance Assessment

### Pre-Migration HIPAA Gaps
- [X] **Windows Server 2008 R2 EOL** - CRITICAL risk
- [X] **No MFA** - CRITICAL gap
- [ ] **Weak file share permissions** - High risk
- [ ] **Limited audit logging** - Medium risk
- [ ] **No data encryption at rest** - Medium risk

### Post-Migration HIPAA Improvements
- [ ] **MFA for all users** - Azure AD MFA
- [ ] **Conditional access policies** - Device compliance, location, risk-based
- [ ] **Modern endpoint protection** - Microsoft Defender for Endpoint
- [ ] **Data encryption** - SharePoint/OneDrive encrypted at rest
- [ ] **Enhanced audit logging** - Microsoft Purview
- [ ] **Data loss prevention** - Microsoft Purview DLP
- [ ] **Information protection** - Sensitivity labels
- [ ] **Secure score monitoring** - Azure AD Security Score

---

## 11. Timeline & Milestones

### Phase 1: Assessment & Planning (Weeks 1-2)
- [ ] Complete this assessment checklist
- [ ] Document AD structure (users, groups, OUs, GPOs)
- [ ] Identify application dependencies
- [ ] Engage vendors (EHR, eMAR, KRONOS)
- [ ] Verify domain ownership
- [ ] Choose migration path (cloud-only vs. hybrid)

### Phase 2: Pre-Migration Setup (Weeks 3-4)
- [ ] Set up Azure AD tenant (if new)
- [ ] Verify domain in M365
- [ ] Configure Azure AD licenses
- [ ] Set up test users in Azure AD
- [ ] Test file migration to SharePoint/OneDrive
- [ ] Configure Intune policies
- [ ] Plan user communication

### Phase 3: Migration Execution (Month 2)
- [ ] Migrate user accounts to Azure AD
- [ ] Configure MFA for all users
- [ ] Migrate file shares to SharePoint/OneDrive/Azure Files
- [ ] Migrate workstations to Azure AD join
- [ ] Implement Intune device management
- [ ] Cutover DNS (if applicable)
- [ ] User training and support

### Phase 4: Decommission & Validation (Months 2-3)
- [ ] Validate all services migrated
- [ ] Monitor for 2-4 weeks
- [ ] Address any issues
- [ ] Decommission SERVER-FS1
- [ ] Update documentation
- [ ] Conduct post-migration review

---

## 12. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| EHR not compatible with Azure AD | Medium | High | Engage vendor early, test thoroughly, hybrid option |
| KRONOS requires on-prem AD | Medium | Medium | Azure Files for SMB, or keep limited on-prem |
| User resistance to MFA | High | Low | Training, communication, gradual rollout |
| Scanner compatibility issues | Medium | Low | Test cloud scanning, Azure Files fallback |
| Downtime during migration | Low | High | Phased approach, after-hours work, rollback plan |
| Data loss during file migration | Low | Critical | Pilot migration, validation, backups |

---

## 13. Success Criteria

### Technical Success Criteria
- [ ] All 59 users migrated to Azure AD
- [ ] MFA enabled for 100% of users
- [ ] All 68 workstations joined to Azure AD
- [ ] File shares accessible from cloud
- [ ] Critical applications functional (EHR, eMAR, KRONOS)
- [ ] No data loss
- [ ] SERVER-FS1 decommissioned

### Business Success Criteria
- [ ] Zero impact to patient care
- [ ] No extended downtime (>4 hours)
- [ ] User satisfaction high (training effective)
- [ ] HIPAA compliance improved
- [ ] Cost savings realized (no server hardware)
- [ ] Security posture improved (MFA, modern auth)

### HIPAA Compliance Success Criteria
- [ ] MFA implemented (administrative, technical safeguards)
- [ ] Audit logging enhanced (accountability)
- [ ] Data encryption verified (transmission security)
- [ ] Access controls improved (role-based access)
- [ ] Risk assessment updated
- [ ] BAA reviewed and updated with Microsoft

---

## Assessment Completion

**Assessment Completed By:** _______________
**Date Completed:** _______________
**Reviewed By (Kylea/Jaclyn):** _______________
**Review Date:** _______________

**Recommendation:**
- [ ] Proceed with Cloud-Only Migration
- [ ] Proceed with Hybrid Migration (Azure AD Connect)
- [ ] Further Investigation Required

**Next Steps:**
1.
2.
3.

---

**Document Version:** 1.0
**Last Updated:** YYYY-MM-DD
