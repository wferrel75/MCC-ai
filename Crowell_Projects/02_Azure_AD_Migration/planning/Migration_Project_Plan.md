# Azure AD Migration - Project Plan
**Crowell Memorial Home**

**Project Start Date:** 2025-12-11
**Target Completion Date:** 2026-03-15 (90 days)
**Project Manager:** [TBD]
**Technical Lead:** [TBD]

---

## Executive Summary

### Project Objective
Migrate Crowell Memorial Home from Windows Server 2008 R2 Active Directory to Azure AD (Microsoft Entra ID) to eliminate critical security risks, achieve HIPAA compliance, and modernize identity management infrastructure.

### Critical Issue
**Windows Server 2008 R2 End of Life:** The current domain controller (SERVER-FS1) has been unsupported since January 14, 2020 (5+ years). This represents a **CRITICAL HIPAA compliance and security risk** as the server is:
- Not receiving security patches
- Vulnerable to known exploits
- Handling Protected Health Information (PHI)
- A single point of failure (all FSMO roles, no redundancy)

### Current Environment
- **Domain:** crowell.local
- **Users:** 47 employees + 12 service/shared accounts = 59 AD users (server audit)
- **Employees:** 47 active staff (verified from employee list 2025-12-12)
- **Computers:** 68
- **File Shares:** 10 shares (20.5 GB total)
- **Domain Controller:** SERVER-FS1 (Windows Server 2008 R2)
- **Additional Services:** DNS, File Services, IIS, SMTP

### Migration Approach
**Cloud-Only Migration** (Recommended)
- Migrate identity to Azure AD (Entra ID)
- Migrate file shares to SharePoint Online / OneDrive / Azure Files
- Implement Multi-Factor Authentication (MFA) for all users
- Enable Intune for modern device management
- Decommission on-premises SERVER-FS1

**Rationale:**
- Small environment (47 employees, 50-55 total licenses estimated, 20.5 GB data)
- Eliminates Server 2008 R2 risk immediately
- Enables modern security (MFA) required for HIPAA
- Reduces infrastructure costs and maintenance
- Provides cloud-based disaster recovery

### Success Criteria
- ✅ All 47 employees + required service accounts migrated to Azure AD with MFA enabled
- ✅ Total estimated licenses: 50-55 (final count determined in Phase 1)
- ✅ All 68 workstations Azure AD-joined
- ✅ File shares migrated to cloud (data integrity verified)
- ✅ Critical applications functional (EHR, eMAR, KRONOS)
- ✅ Zero data loss
- ✅ No extended downtime (max 4 hours for cutover)
- ✅ SERVER-FS1 decommissioned
- ✅ HIPAA compliance improved

---

## Project Timeline

**Total Duration:** 90 days (12-13 weeks)
**Maintenance Windows:** After hours (after 5:00 PM) and weekends preferred

### High-Level Timeline

| Phase | Duration | Start Date | End Date | Status |
|-------|----------|------------|----------|--------|
| Phase 1: Assessment & Planning | 2 weeks | 2025-12-11 | 2025-12-24 | In Progress |
| Phase 2: Pre-Migration Setup | 2 weeks | 2025-12-25 | 2026-01-07 | Pending |
| Phase 3: Testing & Validation | 3 weeks | 2026-01-08 | 2026-01-28 | Pending |
| Phase 4: Migration Execution | 3 weeks | 2026-01-29 | 2026-02-18 | Pending |
| Phase 5: Decommission & Monitoring | 4 weeks | 2026-02-19 | 2026-03-18 | Pending |

---

## Phase 1: Assessment & Planning (Weeks 1-2)

**Objective:** Complete comprehensive assessment of current environment and finalize migration plan

### Week 1 (Dec 11-17, 2025)

#### Kickoff & Documentation Review
- [X] Kick-off meeting with Kylea Punke and Jaclyn Svendgard
- [X] Obtain signed Business Associate Agreement (BAA)
- [X] Review existing customer profile and server audit
- [X] Create project plan and timeline
- [ ] Establish communication plan and cadence

#### Active Directory Assessment
- [ ] Connect to SERVER-FS1 and export AD data:
  - [ ] User accounts (Get-ADUser export)
  - [ ] Computer accounts (Get-ADComputer export)
  - [ ] Groups (Get-ADGroup export)
  - [ ] Organizational Units (Get-ADOrganizationalUnit export)
  - [ ] Group Policy Objects (GPO backup and inventory)
- [ ] Identify service accounts and their dependencies
- [ ] Document password policies and security settings
- [ ] Review UPN suffixes (current: @crowell.local)

#### DNS & Network Services
- [ ] Export DNS zones and records
- [ ] Identify external DNS provider (likely for crowellhome.com)
- [ ] Verify public domain ownership (crowellhome.com)
- [ ] Document DHCP configuration (FortiGate firewall)

### Week 2 (Dec 18-24, 2025)

#### Application Dependency Assessment
- [ ] **EHR System:** Contact vendor to verify Azure AD compatibility
  - [ ] Identify vendor and support contact
  - [ ] Request Azure AD/cloud compatibility confirmation
  - [ ] Test SSO/SAML integration capabilities
- [ ] **eMAR System:** Contact vendor for compatibility assessment
- [ ] **KRONOS (Time/Attendance):** Verify if still in use and cloud readiness
  - [ ] Current version and deployment (cloud vs. on-prem)
  - [ ] Azure AD authentication support
  - [ ] SMB file share requirements
- [ ] **IIS Default Web Site:** Identify application purpose and usage
  - [ ] Interview staff to determine if actively used
  - [ ] Review IIS logs for recent activity
  - [ ] Plan migration path (Azure App Service vs. retire)

#### File Share Analysis
- [ ] Export share permissions and NTFS ACLs
- [ ] Analyze file types and usage patterns
- [ ] Identify files requiring PHI protection
- [ ] Determine migration targets for each share:
  - [ ] **support (17.67 GB):** SharePoint or OneDrive?
  - [ ] **data (2.25 GB):** SharePoint site library?
  - [ ] **apps (0.61 GB):** Azure Files or retire?
  - [ ] **KRONOS (0.16 GB):** Azure Files if SMB required
  - [ ] **Nursing Scan / Admin_Scan / Scan:** SharePoint or Azure Files?
  - [ ] **HHTTemp:** Archive or delete?

#### Scanner/MFP Compatibility
- [ ] Identify all networked scanners/MFPs
- [ ] Test scan-to-SharePoint functionality
- [ ] Plan for Azure Files if SMB required

#### Workstation Assessment
- [ ] Export computer OS inventory
- [ ] Identify Windows versions:
  - [ ] Windows 11 count (Azure AD join ready)
  - [ ] Windows 10 count (version >= 1803 for Azure AD join)
  - [ ] Older OS requiring upgrades
- [ ] Assess TPM 2.0 availability for Windows Hello

#### Domain & Licensing
- [ ] Verify ownership of public domain (crowellhome.com)
- [ ] **Review existing Microsoft 365 tenant configuration:**
  - [ ] Access Microsoft 365 Admin Center (admin.microsoft.com)
  - [ ] Document Tenant ID and primary domain
  - [ ] Review current 10 FREE Business Premium license assignments
  - [ ] Check for any other licenses or trials (Azure AD P1/P2, standalone products)
  - [ ] Document security baseline (Security Defaults, Conditional Access policies)
  - [ ] Check MFA enrollment status for current 10 license holders
- [ ] **Contact Microsoft support to verify FREE license retention:**
  - Call: 1-800-865-9408 or visit: https://aka.ms/Office365Billing
  - [ ] Confirm: "Can our 10 donated licenses remain free when we add 49 more?"
  - [ ] Request written confirmation via email
  - [ ] Get pricing quote for 49 additional licenses at nonprofit rate
  - [ ] Verify nonprofit status is still active and validated
  - [ ] Confirm no impact to existing FREE licenses during expansion
- [ ] **Verify nonprofit validation status:**
  - [ ] Check if validated through TechSoup
  - [ ] Confirm 501(c)(3) documentation on file with Microsoft
  - [ ] Verify grant renewal date (if applicable)
- [ ] Add and verify domain (crowellhome.com) in Microsoft 365 tenant
- [ ] Plan UPN migration (@crowell.local → @crowellhome.com)
- [ ] **Finalize license purchase plan:**
  - [ ] Document final license count needed (59 total: 10 existing + 49 new)
  - [ ] Confirm pricing: Best Case ($3,234/year) vs. Standard Case ($3,894/year)
  - [ ] Get customer approval for license purchase
  - [ ] Schedule license purchase for Phase 2

#### Risk Assessment & Mitigation Planning
- [ ] Document all identified risks
- [ ] Create mitigation strategies
- [ ] Develop rollback procedures
- [ ] Plan for contingencies (EHR compatibility issues, etc.)

#### Deliverables (End of Phase 1)
- [ ] Completed Assessment Checklist
- [ ] AD export data (users, computers, groups, GPOs)
- [ ] Application compatibility matrix
- [ ] File share migration strategy
- [ ] **Microsoft 365 licensing investigation report:**
  - [ ] Current tenant configuration documented
  - [ ] FREE license retention status confirmed (with written proof from Microsoft)
  - [ ] Final pricing scenario determined (Best Case vs. Standard Case)
  - [ ] License purchase plan approved by customer
- [ ] Risk assessment and mitigation plan
- [ ] Detailed implementation plan for Phase 2-5
- [ ] Customer approval to proceed

---

## Phase 2: Pre-Migration Setup (Weeks 3-4)

**Objective:** Prepare Azure AD tenant, configure licenses, and establish test environment

### Week 3 (Dec 25-31, 2025)

#### Azure AD Tenant Configuration (Existing Tenant)
- [ ] **Review existing tenant configuration** (already has 10 FREE Business Premium licenses)
- [ ] Verify custom domain (crowellhome.com) in Azure AD
- [ ] **Enhance Azure AD security baseline:**
  - [ ] Review and update Security Defaults or Conditional Access policies
  - [ ] Configure self-service password reset (SSPR) for all users
  - [ ] Enable Azure AD audit logging (extended retention for HIPAA)
  - [ ] Configure sign-in and user risk policies (requires Entra ID P1 - already included)
  - [ ] Set up named locations (office IP addresses)
  - [ ] Configure MFA registration policy

#### Microsoft 365 Licensing
- [ ] **Purchase 49 additional Microsoft 365 Business Premium licenses** (nonprofit pricing)
  - [ ] Verify final pricing: $269.50/month if FREE licenses retained, or $324.50/month
  - [ ] Confirm purchase with customer approval
  - [ ] Complete purchase through Microsoft 365 Admin Center
- [ ] **Assign licenses strategically:**
  - [ ] Keep existing 10 FREE licenses assigned to current users
  - [ ] Assign 5-10 new licenses to pilot users for Phase 3 testing
  - [ ] Reserve remaining licenses for full migration in Phase 4
- [ ] Verify Intune and security features available (included in Business Premium)

#### Intune Configuration
- [ ] Set up Intune tenant
- [ ] Create device compliance policies:
  - [ ] Require encryption
  - [ ] Minimum OS version
  - [ ] Firewall enabled
  - [ ] Antivirus enabled
- [ ] Create device configuration profiles:
  - [ ] WiFi profiles
  - [ ] VPN profiles (if needed)
  - [ ] Security baselines
- [ ] Plan app deployment strategy

### Week 4 (Jan 1-7, 2026)

#### Multi-Factor Authentication (MFA)
- [ ] Plan MFA rollout strategy
- [ ] Configure MFA methods (Microsoft Authenticator preferred)
- [ ] Create MFA exclusion groups (for staged rollout)
- [ ] Prepare user communication and training materials

#### SharePoint & OneDrive Setup
- [ ] Create SharePoint sites for departments:
  - [ ] Administration
  - [ ] Nursing
  - [ ] Support/IT
  - [ ] Policies (for Jaclyn's policy files)
- [ ] Configure SharePoint permissions and security
- [ ] Enable OneDrive for Business for all users
- [ ] Plan OneDrive Known Folder Move (Desktop, Documents, Pictures)

#### Azure Files (for legacy SMB shares)
- [ ] Create Azure Storage Account
- [ ] Configure Azure Files shares:
  - [ ] KRONOS share (if SMB required)
  - [ ] Apps share (if needed)
  - [ ] Scanner shares (if cloud scanning not possible)
- [ ] Configure Azure AD authentication for Azure Files
- [ ] Test file access from workstations

#### Test Environment
- [ ] Create test user accounts in Azure AD (5-10 users)
- [ ] Azure AD-join test workstation(s)
- [ ] Test file access (SharePoint, OneDrive, Azure Files)
- [ ] Test application access (EHR, eMAR, KRONOS)
- [ ] Validate MFA enrollment and sign-in

#### User Communication
- [ ] Draft migration announcement email
- [ ] Create user training guides:
  - [ ] Azure AD sign-in changes
  - [ ] MFA enrollment (Microsoft Authenticator)
  - [ ] OneDrive file access
  - [ ] SharePoint file access
- [ ] Schedule training sessions

#### Deliverables (End of Phase 2)
- [ ] Azure AD tenant fully configured
- [ ] Licenses assigned and validated
- [ ] Intune policies created
- [ ] SharePoint sites and OneDrive configured
- [ ] Test environment validated
- [ ] User communication materials ready

---

## Phase 3: Testing & Validation (Weeks 5-7)

**Objective:** Thoroughly test migration procedures and validate application compatibility

### Week 5 (Jan 8-14, 2026)

#### Pilot User Migration (5-10 users)
- [ ] Select pilot users (mix of roles):
  - [ ] 1-2 administrative staff
  - [ ] 1-2 nursing staff
  - [ ] 1-2 support/IT staff
- [ ] Migrate pilot user accounts to Azure AD
- [ ] Enroll pilot users in MFA
- [ ] Azure AD-join pilot user workstations
- [ ] Migrate pilot user files to OneDrive
- [ ] Monitor pilot user experience for 1 week

#### Application Testing
- [ ] Test EHR system access with Azure AD accounts
  - [ ] User authentication
  - [ ] SSO/SAML (if applicable)
  - [ ] Role-based access
  - [ ] PHI access and documentation
- [ ] Test eMAR system access
- [ ] Test KRONOS system (if in use)
- [ ] Test email (Exchange Online or existing email)
- [ ] Test any other critical applications

### Week 6 (Jan 15-21, 2026)

#### File Share Migration Testing
- [ ] Migrate pilot file shares to cloud:
  - [ ] Test folder → SharePoint document library
  - [ ] Test user files → OneDrive
  - [ ] KRONOS share → Azure Files (if needed)
- [ ] Validate file permissions after migration
- [ ] Test file access from workstations
- [ ] Verify file integrity (checksums, file counts)
- [ ] Test scanner functionality (scan-to-SharePoint or Azure Files)

#### Network and Infrastructure Testing
- [ ] Test DNS resolution after Azure AD join
- [ ] Verify network connectivity
- [ ] Test VPN access (if applicable)
- [ ] Validate printer access
- [ ] Test shared resources

### Week 7 (Jan 22-28, 2026)

#### Pilot Review & Issue Resolution
- [ ] Gather feedback from pilot users
- [ ] Document any issues or challenges
- [ ] Resolve identified issues
- [ ] Refine migration procedures
- [ ] Update training materials based on pilot feedback

#### Migration Scripts & Automation
- [ ] Develop PowerShell scripts for:
  - [ ] User account migration
  - [ ] UPN updates
  - [ ] Group membership replication
  - [ ] License assignment
- [ ] Create workstation migration checklist
- [ ] Prepare file migration automation

#### Final Readiness Review
- [ ] Review all test results
- [ ] Validate rollback procedures
- [ ] Confirm customer readiness
- [ ] Schedule migration cutover dates
- [ ] Finalize go/no-go criteria

#### Deliverables (End of Phase 3)
- [ ] Pilot migration success validation
- [ ] Application compatibility confirmed
- [ ] File migration procedures validated
- [ ] Issues identified and resolved
- [ ] Migration scripts and automation ready
- [ ] Customer approval to proceed to Phase 4

---

## Phase 4: Migration Execution (Weeks 8-10)

**Objective:** Migrate all users, workstations, and file shares to Azure AD

### Week 8 (Jan 29 - Feb 4, 2026)

#### User Account Migration (Batch 1 - 17 users)
- [ ] Migrate first batch of user accounts
  - [ ] Executive/Administration: 3 (CEO, Jacqui Slinkard, Terry Wulf)
  - [ ] Business Office: 2 (Kylea Punke, Mimi Cemer)
  - [ ] RN/Administrative: 7 (Prudence Cemer, Nancy Pedersen, etc.)
  - [ ] Social Services: 1 (Teresa Modahl)
  - [ ] Activities: 2 (Sydney Baird, Allison Dovico)
  - [ ] Dietary: 1 (Jill Nelson)
  - [ ] Housekeeping: 1 (Katie Keller)
- [ ] Update UPN from @crowell.local to @crowellhome.com
- [ ] Assign Azure AD licenses
- [ ] Configure MFA enrollment
- [ ] Migrate user files to OneDrive (for those with dedicated computers)
- [ ] Send welcome emails with instructions
- [ ] Provide hands-on support during first week

#### Workstation Migration (Batch 1 - 12 computers)
- [ ] Migrate dedicated workstations (administrative/office staff)
- [ ] Schedule workstation migrations (after hours)
- [ ] Un-join from crowell.local domain
- [ ] Azure AD-join workstations
- [ ] Enroll in Intune
- [ ] Configure OneDrive Known Folder Move
- [ ] Validate application access
- [ ] Provide user support

### Week 9 (Feb 5-11, 2026)

#### User Account Migration (Batch 2 - 15 users)
- [ ] Migrate second batch of user accounts (Nursing Staff - Day/Evening Shifts)
  - [ ] LPNs: 3 (Tanya Gaver, Mary Flora, Jodi Smith)
  - [ ] Med Aides/CNAs: 12 (day/evening shift staff)
- [ ] Same migration steps as Batch 1
- [ ] Stagger training to accommodate shift schedules
- [ ] Provide 24/7 support during nursing staff migration
- [ ] Note: These users primarily use shared nursing station workstations

#### Workstation Migration (Batch 2 - 28 computers)
- [ ] Continue workstation migrations (nursing stations + shared workstations)
- [ ] Focus on nursing stations and clinical areas
- [ ] Ensure no disruption to patient care
- [ ] Validate nurse call system integration
- [ ] Test EHR and eMAR access
- [ ] Configure shared workstation logins

### Week 10 (Feb 12-18, 2026)

#### User Account Migration (Batch 3 - 15 users + Service Accounts)
- [ ] Migrate remaining user accounts
  - [ ] Med Aides/CNAs: 15 (night shift and remaining staff)
  - [ ] Maintenance: 2 (Derick Austin, Warren Austin)
  - [ ] Service Accounts: 3-5 (nursing station shared logins, department accounts)
- [ ] Complete all user migrations (47 employees + 3-5 service accounts)
- [ ] Verify all users can access MFA and cloud resources

#### Workstation Migration (Batch 3 - 28 computers)
- [ ] Complete all remaining workstation migrations
- [ ] Verify all 68 computers Azure AD-joined
- [ ] Validate Intune enrollment across all devices
- [ ] Confirm application access across all workstations
- [ ] Test shared workstation login functionality

#### File Share Migration (Final)
- [ ] Migrate all remaining file shares:
  - [ ] support (17.67 GB) → SharePoint/OneDrive
  - [ ] data (2.25 GB) → SharePoint
  - [ ] apps (0.61 GB) → Azure Files or retire
  - [ ] Nursing Scan → Azure Files or SharePoint
  - [ ] KRONOS → Azure Files (if needed)
- [ ] Validate file integrity
- [ ] Update file share mappings on workstations
- [ ] Test file access from all departments

#### Deliverables (End of Phase 4)
- [ ] All 47 employees + 3-5 service accounts migrated and MFA-enabled (50-52 total)
- [ ] All 68 workstations Azure AD-joined
- [ ] All file shares migrated to cloud (20.5 GB)
- [ ] No critical issues or blockers
- [ ] User adoption and satisfaction high
- [ ] Shared workstation functionality validated

---

## Phase 5: Decommission & Monitoring (Weeks 11-14)

**Objective:** Decommission SERVER-FS1, monitor for issues, and complete project

### Week 11 (Feb 19-25, 2026)

#### Validation & Monitoring
- [ ] Verify all users successfully migrated
- [ ] Confirm all workstations functioning normally
- [ ] Validate all applications accessible
- [ ] Monitor Azure AD sign-in logs
- [ ] Review Intune compliance reports
- [ ] Check for any authentication or access issues

#### DNS Cutover (if applicable)
- [ ] Update DNS settings to point to Azure AD DNS
- [ ] Verify DNS resolution
- [ ] Monitor for DNS-related issues

#### Service Account Migration
- [ ] Identify service accounts still dependent on SERVER-FS1
- [ ] Migrate service accounts to Azure AD (or create new)
- [ ] Update application configurations

### Week 12 (Feb 26 - Mar 4, 2026)

#### Continued Monitoring
- [ ] Monitor user sign-ins and MFA enrollments
- [ ] Track help desk tickets related to migration
- [ ] Resolve any remaining issues
- [ ] Validate backup and disaster recovery
- [ ] Review security posture (Azure AD Security Score)

#### Documentation Updates
- [ ] Update network documentation
- [ ] Document Azure AD configuration
- [ ] Update HIPAA compliance documentation
- [ ] Create Azure AD administration guide
- [ ] Document Intune policies and configurations

### Week 13 (Mar 5-11, 2026)

#### SERVER-FS1 Decommission Preparation
- [ ] Final validation: No users or computers authenticating to SERVER-FS1
- [ ] Verify no applications dependent on SERVER-FS1
- [ ] Confirm all file shares migrated and accessible
- [ ] Review AD audit logs for any remaining activity
- [ ] Create final backup of SERVER-FS1
- [ ] Document SERVER-FS1 configuration for historical records

#### Graceful Shutdown
- [ ] Power down SERVER-FS1 (leave offline for 1 week)
- [ ] Monitor for any issues or dependencies
- [ ] Confirm no impact to operations
- [ ] Keep backup available for emergency recovery

### Week 14 (Mar 12-18, 2026)

#### Final Decommission
- [ ] If no issues for 1 week, proceed with decommission
- [ ] Archive SERVER-FS1 backups (retain per HIPAA requirements)
- [ ] Remove SERVER-FS1 from network
- [ ] Update asset inventory
- [ ] Document decommission date and process

#### Project Closeout
- [ ] Final project status report
- [ ] Customer satisfaction survey
- [ ] Lessons learned documentation
- [ ] Knowledge transfer to customer
- [ ] Project retrospective with MCC team
- [ ] Archive project documentation

#### Post-Migration HIPAA Compliance Review
- [ ] Update HIPAA risk assessment
- [ ] Review Business Associate Agreement (BAA)
- [ ] Validate audit logging configuration
- [ ] Confirm data encryption (at rest and in transit)
- [ ] Verify access controls and MFA
- [ ] Document compliance improvements

#### Deliverables (End of Phase 5)
- [ ] SERVER-FS1 decommissioned
- [ ] All documentation updated
- [ ] HIPAA compliance validated
- [ ] Customer satisfaction confirmed
- [ ] Project formally closed

---

## Cutover Events & Maintenance Windows

### Critical Cutover Events

**Event 1: DNS Cutover (if applicable)**
- **Date:** TBD (Week 11)
- **Time:** After hours (after 7:00 PM or weekend)
- **Duration:** 1-2 hours
- **Impact:** Minimal (transparent to users)
- **Rollback:** Revert DNS changes

**Event 2: Final File Share Cutover**
- **Date:** TBD (Week 10)
- **Time:** After hours (after 7:00 PM or weekend)
- **Duration:** 4 hours
- **Impact:** File shares unavailable during migration
- **Rollback:** Revert to SERVER-FS1 shares

**Event 3: SERVER-FS1 Shutdown**
- **Date:** TBD (Week 13)
- **Time:** After hours (after 7:00 PM)
- **Duration:** Indefinite (leave offline for 1 week)
- **Impact:** None (all services migrated)
- **Rollback:** Power on SERVER-FS1

### Maintenance Windows
- **Preferred Days:** Weekends (Saturday/Sunday)
- **Preferred Times:** After 7:00 PM Central Time
- **Maximum Downtime:** 4 hours
- **Notification:** 1 week advance notice to customer
- **24/7 Support:** On-call support during all maintenance windows

---

## Communication Plan

### Stakeholder Communication

#### Executive Leadership (CEO - Jaclyn Svendgard)
- **Frequency:** Bi-weekly
- **Method:** Email + phone call
- **Content:** High-level status, major milestones, budget, risks

#### Primary Technical Contact (Kylea Punke)
- **Frequency:** Weekly
- **Method:** Email + Teams meeting
- **Content:** Detailed project status, technical issues, next steps

#### End Users (All Staff)
- **Frequency:** As needed (pre-migration, during migration, post-migration)
- **Method:** Email announcements + training sessions
- **Content:** Migration timeline, what to expect, training, support

### Communication Materials

#### Pre-Migration
- [ ] Project announcement email (3 weeks before)
- [ ] Training session invitations (2 weeks before)
- [ ] FAQ document
- [ ] MFA enrollment guide

#### During Migration
- [ ] Scheduled maintenance notifications
- [ ] Daily status updates (during active migration weeks)
- [ ] Support contact information

#### Post-Migration
- [ ] Migration completion announcement
- [ ] New sign-in instructions
- [ ] Support resources
- [ ] Feedback survey

---

## Risk Management

### High-Priority Risks

| Risk | Likelihood | Impact | Mitigation | Owner |
|------|------------|--------|------------|-------|
| EHR incompatible with Azure AD | Medium | Critical | Engage vendor early, test thoroughly, hybrid option fallback | Tech Lead |
| KRONOS requires on-prem AD | Medium | Medium | Test cloud version, use Azure Files for SMB, worst case keep limited on-prem | Tech Lead |
| User resistance to MFA | High | Low | Strong training program, executive support, gradual rollout | PM |
| Extended downtime during cutover | Low | High | Thorough testing, detailed runbooks, rollback procedures | Tech Lead |
| Data loss during file migration | Low | Critical | Pilot migrations, checksums, backups, validation procedures | Tech Lead |
| Critical application failure | Low | Critical | Testing in Phase 3, rollback procedures, vendor support on standby | Tech Lead |
| Scanner incompatibility | Medium | Low | Test scan-to-SharePoint, Azure Files fallback | Tech Lead |
| Network connectivity issues | Low | Medium | Pre-migration network assessment, on-site support during cutover | Tech Lead |

### Rollback Procedures

#### If migration must be aborted:
1. **Immediate:** Power on SERVER-FS1 if offline
2. **User Accounts:** Users can still authenticate to crowell.local domain
3. **Workstations:** Re-join to crowell.local domain (can be done individually)
4. **File Shares:** Revert to SERVER-FS1 SMB shares
5. **Applications:** Revert to on-prem authentication
6. **Communication:** Notify all stakeholders immediately

#### Rollback Criteria:
- Critical application failure affecting patient care
- Data loss or corruption
- Extended downtime (>8 hours)
- Customer request to abort
- Unforeseen blocker preventing completion

---

## Budget & Resources

### Estimated Costs

#### Microsoft 365 Licensing (Annual)

**EXISTING LICENSES:** Crowell currently has **10 FREE Microsoft 365 Business Premium licenses** (donated under nonprofit program)
- Invoice: E0700Y4IH2 (November 2025)
- Status: $0.00/month (donation)
- Includes: Entra ID Premium P1, Intune, Office apps, Exchange, SharePoint, OneDrive, Teams

**NONPROFIT PRICING** (75-100% discount vs. commercial):

**Total Licenses Required:** 50-55 user licenses (revised based on employee count)
- **Employee Count:** 47 active employees (verified 2025-12-12)
- **Service/Shared Accounts:** 3-8 estimated (nursing stations, departments)
- **Conservative Estimate:** 55 licenses total
- **Note:** Final count to be determined during Phase 1 AD assessment

**Cost Scenarios:**

**Scenario A: FREE Licenses Retained + 45 Additional (BEST CASE)**
- 10 existing licenses: $0.00/month (FREE - grandfathered donation)
- 45 additional licenses: $247.50/month ($5.50 × 45)
- **Annual: $2,970/year** ($247.50 × 12)
- Commercial equivalent: $14,520/year (55 × $22/month × 12)
- **Nonprofit savings: $11,550/year (80% discount)**

**Scenario B: All Licenses Paid at Nonprofit Rate (STANDARD CASE)**
- 55 licenses: $302.50/month ($5.50 × 55)
- **Annual: $3,630/year** ($302.50 × 12)
- Commercial equivalent: $14,520/year
- **Nonprofit savings: $10,890/year (75% discount)**

**Scenario C: If 59 Licenses Needed (Original Estimate)**
- 59 licenses: $324.50/month ($5.50 × 59)
- **Annual: $3,894/year** (original estimate)

**Note:** Crowell Memorial Home qualifies for Microsoft Nonprofit pricing as a registered 501(c)(3) organization. Business Premium includes Entra ID Premium P1, eliminating the need for separate Azure AD licensing. During Phase 1, we will verify with Microsoft whether the 10 FREE licenses can be retained when adding 49 more licenses.

**Reference:** See `Nonprofit_Licensing_Options.md` for complete details on eligibility, pricing, and current licensing status.

#### Windows 11 Pro Upgrade Licensing (One-Time)
- **Windows 11 Pro Upgrade Licenses:** 50-68 licenses via TechSoup
  - TechSoup nonprofit pricing: $16/license
  - Estimated cost for 50 devices: **$800** (one-time)
  - Estimated cost for 68 devices: **$1,088** (one-time, if all upgrades needed)
  - Commercial pricing: $199/license (92% nonprofit discount)

**Note:** Some devices may qualify for Windows 11 Pro upgrade rights through Microsoft 365 Business Premium subscription.

#### Professional Services
- **Assessment & Planning (Phase 1):** 40 hours × $150/hr = $6,000
- **Pre-Migration Setup (Phase 2):** 40 hours × $150/hr = $6,000
- **Testing & Validation (Phase 3):** 60 hours × $150/hr = $9,000
- **Migration Execution (Phase 4):** 80 hours × $150/hr = $12,000
- **Decommission & Closeout (Phase 5):** 40 hours × $150/hr = $6,000
- **Total Professional Services:** $39,000 (one-time)

#### Total Project Cost (NONPROFIT PRICING - Revised for 55 Licenses)

**Scenario A: Best Case (10 FREE licenses retained + 45 new)**
- **Year 1:**
  - Microsoft 365 licenses: $2,970 (10 FREE + 45 paid)
  - Windows 11 Pro upgrades (est. 50 devices): $800
  - Professional services: $39,000
  - **Year 1 Total: $42,770**

- **Ongoing (Year 2+):** $2,970/year (Microsoft 365 licenses only)
- **5-Year Total:** $54,650**

**Scenario B: Standard Case (all 55 licenses paid nonprofit rate)**
- **Year 1:**
  - Microsoft 365 licenses: $3,630 (55 licenses)
  - Windows 11 Pro upgrades (est. 50 devices): $800
  - Professional services: $39,000
  - **Year 1 Total: $43,430**

- **Ongoing (Year 2+):** $3,630/year (Microsoft 365 licenses only)
- **5-Year Total:** $58,350**

**Scenario C: If 59 Licenses Needed (Original Estimate)**
- **Year 1 Total:** $43,694
- **5-Year Total:** $59,270

#### Cost Comparison: Nonprofit vs. Commercial Pricing (Revised for 55 Licenses)

| Item | Commercial (55) | Nonprofit (Best Case)* | Nonprofit (Standard) | Best Case Savings |
|------|----------------|----------------------|---------------------|-------------------|
| M365 Business Premium (annual) | $14,520 | $2,970 | $3,630 | $11,550/year (80%) |
| Azure AD Premium P1 (annual) | $3,960 | Included | Included | $3,960/year (100%) |
| Windows 11 Pro (one-time) | $13,532 | $800 | $800 | $12,732 (94%) |
| **Year 1 Total** | **$67,012** | **$42,770** | **$43,430** | **$24,242 (36%)** |
| **Year 2+ (annual)** | **$18,480** | **$2,970** | **$3,630** | **$15,510/year (84%)** |
| **5-Year Total** | **$141,932** | **$54,650** | **$58,350** | **$87,282 (61%)** |

*Best Case assumes 10 existing FREE licenses are retained + 45 new licenses; requires Microsoft confirmation during Phase 1

**Note:** Revised calculations based on 47 employees + estimated 8 service/shared accounts = 55 total licenses. Original estimate was 59 licenses. Final license count to be determined during Phase 1 Active Directory assessment.

### Cost Savings (vs. New On-Prem Server)
- **Hardware:** $8,000-15,000 (new Windows Server 2022 + storage)
- **Windows Server Licensing:** $1,000-2,000
- **Ongoing Maintenance:** $3,000-5,000/year
- **Hardware Refresh (5 years):** $8,000-15,000

**Cloud-Only Advantages:**
- No upfront hardware costs
- Predictable OpEx vs. CapEx
- Modern security (MFA, Conditional Access)
- Automatic updates and patching
- Cloud-based disaster recovery
- Scalable (add users easily)
- **80% ongoing cost reduction with nonprofit pricing**

### Resource Requirements

#### MCC Team
- **Project Manager:** 1 person (20% allocation for 90 days)
- **Technical Lead:** 1 person (50% allocation for 90 days)
- **Support Engineer:** 1 person (20% allocation during migration weeks)

#### Customer Team
- **Primary Contact (Kylea):** Weekly meetings, decision-making, testing coordination
- **Executive Sponsor (Jaclyn):** Bi-weekly updates, budget approval, executive support
- **Power Users:** 5-10 users for pilot testing and peer support

---

## Success Metrics

### Technical Metrics
- [ ] **User Migration:** 100% (47 employees + service accounts = 50-55 total users migrated)
- [ ] **MFA Enrollment:** 100% (all licensed users enrolled)
- [ ] **Workstation Migration:** 100% (68/68 computers Azure AD-joined)
- [ ] **File Migration:** 100% (20.5 GB migrated, zero data loss)
- [ ] **Application Uptime:** 99.5%+ (critical apps: EHR, eMAR)
- [ ] **Downtime:** <4 hours (planned maintenance)
- [ ] **Unplanned Downtime:** 0 hours
- [ ] **Rollback Events:** 0 (successful first-time migration)

### HIPAA Compliance Metrics
- [ ] **MFA Coverage:** 100% (all users accessing PHI)
- [ ] **Audit Logging:** Enabled and retained for 6+ years
- [ ] **Data Encryption:** At rest and in transit (SharePoint, OneDrive)
- [ ] **Access Controls:** Role-based access implemented
- [ ] **Security Score:** Azure AD Security Score >80%
- [ ] **Breach Prevention:** Zero security incidents post-migration

### Business Metrics
- [ ] **User Satisfaction:** >90% (post-migration survey)
- [ ] **Training Effectiveness:** >85% confident with new systems
- [ ] **Help Desk Tickets:** <10 per week (post-migration)
- [ ] **Patient Care Impact:** Zero disruption
- [ ] **Budget Variance:** Within 10% of estimate
- [ ] **Timeline Variance:** Within 2 weeks of target

---

## Appendices

### Appendix A: Vendor Contact List
(To be populated during Phase 1)

| Vendor | Product/Service | Contact Name | Email | Phone | Support Portal |
|--------|-----------------|--------------|-------|-------|----------------|
| TBD | EHR System | | | | |
| TBD | eMAR System | | | | |
| TBD | KRONOS | | | | |
| Microsoft | M365/Azure AD | | | | https://admin.microsoft.com |
| Great Plains | Internet/Phone | | | | |

### Appendix B: Application Compatibility Matrix
(To be completed during Phase 1)

| Application | Vendor | Current Auth | Azure AD Compatible? | SSO/SAML? | Migration Notes |
|-------------|--------|--------------|---------------------|-----------|-----------------|
| EHR | TBD | | | | |
| eMAR | TBD | | | | |
| KRONOS | TBD | | | | |
| IIS App | TBD | | | | |

### Appendix C: File Share Migration Matrix
(To be finalized during Phase 1)

| Share | Size | Source | Destination | Migration Method | Validation |
|-------|------|--------|-------------|------------------|------------|
| support | 17.67 GB | C:\support | SharePoint/OneDrive | Robocopy + validation | Checksum |
| data | 2.25 GB | C:\data | SharePoint | Migration tool | File count |
| apps | 0.61 GB | C:\apps | Azure Files | Manual copy | Testing |
| KRONOS | 0.16 GB | C:\KRONOS | Azure Files | Robocopy | Testing |
| Nursing Scan | 0.41 GB | C:\data\Nursing Scan | Azure Files | Migration tool | Testing |
| Admin_Scan | 0.00 GB | C:\data\Admin_Scan | SharePoint | Manual | Testing |
| Scan | 0.00 GB | C:\data\Scan | SharePoint | Manual | Testing |
| HHTTemp | 0.01 GB | C:\HHTTemp | Archive/Delete | N/A | N/A |

### Appendix D: Training Materials
(To be created during Phase 2)

- [ ] Azure AD Sign-In Guide
- [ ] MFA Enrollment Guide (Microsoft Authenticator)
- [ ] OneDrive Quick Start
- [ ] SharePoint File Access Guide
- [ ] Password Reset (Self-Service)
- [ ] FAQ Document

### Appendix E: Escalation Contacts
(To be populated before migration)

| Role | Name | Phone | Email | Availability |
|------|------|-------|-------|--------------|
| Project Manager | TBD | | | Business hours |
| Technical Lead | TBD | | | 24/7 during migration |
| Customer Primary | Kylea Punke | (402) 426-2177 | kpunke@crowellhome.com | Business hours |
| Customer Executive | Jaclyn Svendgard | | jmsvendgard4@gmail.com | Business hours |
| Microsoft Support | | | | 24/7 |

---

**Document Version:** 1.0
**Last Updated:** 2025-12-11
**Next Review:** Weekly during active project
**Approvals:**

- [ ] **Project Manager:** _______________ Date: __________
- [ ] **Technical Lead:** _______________ Date: __________
- [ ] **Customer (Kylea Punke):** _______________ Date: __________
- [ ] **Customer (Jaclyn Svendgard):** _______________ Date: __________
