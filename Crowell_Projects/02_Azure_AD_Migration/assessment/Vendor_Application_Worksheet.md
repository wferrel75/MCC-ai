# Vendor & Application Dependency Worksheet
**Crowell Memorial Home - Azure AD Migration**

**Created:** 2025-12-11
**Owner:** [Project Manager]
**Status:** In Progress

---

## Purpose

This worksheet tracks all applications and vendors that need to be contacted to verify Azure AD compatibility before proceeding with the migration. This is a CRITICAL dependency - we cannot migrate until we confirm all clinical and business-critical applications will function with Azure AD.

---

## Critical Applications Assessment

### 1. Electronic Health Records (EHR) System

**Priority:** CRITICAL (24/7 patient care dependency)

#### Current Information
- **Vendor:** [UNKNOWN - TO BE DETERMINED]
- **Product Name:** [TBD]
- **Version:** [TBD]
- **Current Authentication:** Likely Active Directory (crowell.local)
- **Deployment:** [ ] On-Premises [ ] Cloud [ ] Hybrid [ ] Unknown
- **Users:** All nursing staff, physicians, administrative staff
- **Usage:** 24/7/365 (patient care documentation)

#### Contact Information
- **Support Contact:** [TBD]
- **Support Email:** [TBD]
- **Support Phone:** [TBD]
- **Support Portal:** [TBD]
- **Account Manager:** [TBD]
- **Technical Contact:** [TBD]

#### Azure AD Compatibility Questions
- [ ] **Q1:** Does your EHR system support Azure AD authentication?
  - **Answer:** _______________
  - **Date Confirmed:** _______________
- [ ] **Q2:** Does your EHR system support SAML 2.0 or OAuth 2.0 single sign-on (SSO)?
  - **Answer:** _______________
  - **Details:** _______________
- [ ] **Q3:** Are there any special configuration requirements for Azure AD?
  - **Answer:** _______________
  - **Documentation:** _______________
- [ ] **Q4:** Do you have other healthcare customers using Azure AD with your EHR?
  - **Answer:** _______________
  - **References:** _______________
- [ ] **Q5:** What is the migration process/timeline if Azure AD integration is required?
  - **Answer:** _______________
  - **Estimated Time:** _______________
- [ ] **Q6:** Are there any costs associated with Azure AD integration?
  - **Answer:** _______________
  - **Cost:** $_______________

#### Testing Requirements
- [ ] Test user authentication with Azure AD credentials
- [ ] Test SSO/SAML integration
- [ ] Validate role-based access control
- [ ] Test PHI access and audit logging
- [ ] Verify all EHR modules function correctly

#### Decision
- [ ] **Compatible with Azure AD:** [ ] Yes [ ] No [ ] Partial [ ] Unknown
- [ ] **Blocker for Migration:** [ ] Yes [ ] No
- [ ] **Mitigation Required:** [ ] Yes [ ] No
- **Notes:** _______________

---

### 2. Electronic Medication Administration Record (eMAR) System

**Priority:** CRITICAL (medication safety, patient care)

#### Current Information
- **Vendor:** [UNKNOWN - TO BE DETERMINED]
- **Product Name:** [TBD]
- **Version:** [TBD]
- **Current Authentication:** Likely Active Directory (crowell.local)
- **Deployment:** [ ] On-Premises [ ] Cloud [ ] Hybrid [ ] Unknown
- **Users:** Nursing staff (RNs, LPNs)
- **Usage:** 24/7/365 (medication administration tracking)
- **Integration:** May be integrated with EHR or standalone

#### Contact Information
- **Support Contact:** [TBD]
- **Support Email:** [TBD]
- **Support Phone:** [TBD]
- **Support Portal:** [TBD]
- **Account Manager:** [TBD]
- **Technical Contact:** [TBD]

#### Azure AD Compatibility Questions
- [ ] **Q1:** Does your eMAR system support Azure AD authentication?
  - **Answer:** _______________
  - **Date Confirmed:** _______________
- [ ] **Q2:** Does your eMAR system support SAML 2.0 or OAuth 2.0 SSO?
  - **Answer:** _______________
  - **Details:** _______________
- [ ] **Q3:** Is the eMAR system integrated with the EHR? If yes, how does Azure AD affect integration?
  - **Answer:** _______________
  - **Details:** _______________
- [ ] **Q4:** What is the migration process for Azure AD?
  - **Answer:** _______________
  - **Timeline:** _______________
- [ ] **Q5:** Are there any costs associated with Azure AD integration?
  - **Answer:** _______________
  - **Cost:** $_______________

#### Testing Requirements
- [ ] Test user authentication with Azure AD
- [ ] Test medication administration workflow
- [ ] Verify barcode scanning functionality
- [ ] Test EHR integration (if applicable)
- [ ] Validate audit logging and compliance

#### Decision
- [ ] **Compatible with Azure AD:** [ ] Yes [ ] No [ ] Partial [ ] Unknown
- [ ] **Blocker for Migration:** [ ] Yes [ ] No
- [ ] **Mitigation Required:** [ ] Yes [ ] No
- **Notes:** _______________

---

### 3. KRONOS (Time & Attendance System)

**Priority:** MEDIUM (payroll and scheduling)

#### Current Information
- **Vendor:** Kronos (UKG - Ultimate Kronos Group)
- **Product Name:** Kronos Workforce Central or Dimensions
- **Version:** [TBD]
- **Current Authentication:** Likely Active Directory (crowell.local)
- **Deployment:** [ ] On-Premises [ ] Cloud (Workforce Dimensions) [ ] Unknown
- **File Share:** C:\KRONOS (0.16 GB) - may require SMB access
- **Users:** Management, supervisors, all staff (time clocking)
- **Usage:** Daily (time tracking, scheduling, payroll)

#### Contact Information
- **Vendor:** UKG (Ultimate Kronos Group)
- **Support Phone:** [TBD]
- **Support Email:** [TBD]
- **Support Portal:** [TBD]
- **Account Manager:** [TBD]

#### Current Status Questions
- [ ] **Q0:** Is KRONOS still actively used at Crowell Memorial Home?
  - **Answer:** _______________
  - **Confirmed By:** _______________
  - **Date:** _______________
- [ ] **Q0-A:** If retired, when can the KRONOS share be deleted?
  - **Answer:** _______________

#### Azure AD Compatibility Questions (if still in use)
- [ ] **Q1:** Which KRONOS product version is in use?
  - [ ] Workforce Central (on-prem legacy)
  - [ ] Workforce Dimensions (cloud-based)
  - **Answer:** _______________
- [ ] **Q2:** Does KRONOS support Azure AD authentication?
  - **Answer:** _______________
  - **Documentation:** _______________
- [ ] **Q3:** Does KRONOS support SAML 2.0 SSO?
  - **Answer:** _______________
  - **Details:** _______________
- [ ] **Q4:** Does KRONOS require the C:\KRONOS file share? Can it use Azure Files with SMB 3.0?
  - **Answer:** _______________
  - **Details:** _______________
- [ ] **Q5:** If cloud-based (Dimensions), does it require on-premises Active Directory?
  - **Answer:** _______________
- [ ] **Q6:** What is the migration path if Azure AD is not natively supported?
  - **Answer:** _______________

#### Testing Requirements
- [ ] Test user authentication
- [ ] Test time clock functionality
- [ ] Test manager schedule access
- [ ] Verify file share access (if required)
- [ ] Test payroll integration

#### Decision
- [ ] **Still in Use:** [ ] Yes [ ] No
- [ ] **Compatible with Azure AD:** [ ] Yes [ ] No [ ] Partial [ ] N/A
- [ ] **Blocker for Migration:** [ ] Yes [ ] No
- [ ] **Mitigation Required:** [ ] Yes [ ] No (Azure Files for SMB)
- **Notes:** _______________

---

### 4. IIS Default Web Site Application

**Priority:** LOW TO MEDIUM (depends on usage)

#### Current Information
- **Server:** SERVER-FS1
- **IIS Version:** IIS 7.5 (Windows Server 2008 R2)
- **Physical Path:** %SystemDrive%\inetpub\wwwroot
- **Bindings:** HTTP port 80, net.tcp, net.pipe, net.msmq, msmq.formatname
- **Application Pools:** DefaultAppPool, ASP.NET v4.0, ASP.NET v4.0 Classic
- **Usage:** UNKNOWN - need to determine if actively used

#### Investigation Tasks
- [ ] **Task 1:** Interview Kylea and IT staff to determine application purpose
  - **Interviewer:** _______________
  - **Date:** _______________
  - **Purpose:** _______________
- [ ] **Task 2:** Review IIS logs for recent activity
  - **Reviewer:** _______________
  - **Date:** _______________
  - **Last Activity:** _______________
- [ ] **Task 3:** Identify what application/website is hosted
  - **Application:** _______________
  - **Owner:** _______________
  - **Users:** _______________

#### Possible Scenarios

**Scenario A: Application Not Used / Obsolete**
- [ ] **Action:** Retire application, no migration needed
- [ ] **Confirmed With:** _______________
- [ ] **Date:** _______________

**Scenario B: Internal Intranet or Simple Website**
- **Migration Path:** SharePoint intranet site or Azure App Service
- [ ] **Complexity:** [ ] Low [ ] Medium [ ] High
- [ ] **Migration Estimate:** ___ hours
- [ ] **Priority:** [ ] Critical [ ] Medium [ ] Low

**Scenario C: Custom Business Application**
- **Migration Path:** Azure App Service or Azure Virtual Machine
- [ ] **Application Framework:** [ ] ASP.NET [ ] Classic ASP [ ] Other: ___
- [ ] **Database Backend:** [ ] SQL Server [ ] None [ ] Other: ___
- [ ] **Migration Complexity:** [ ] Low [ ] Medium [ ] High
- [ ] **Vendor Support:** [ ] Available [ ] Not Available
- [ ] **Migration Estimate:** ___ hours

**Scenario D: Third-Party Application**
- **Vendor:** _______________
- **Contact:** _______________
- **Azure AD Compatible:** [ ] Yes [ ] No [ ] Unknown
- **Cloud Version Available:** [ ] Yes [ ] No

#### Decision
- [ ] **Application Actively Used:** [ ] Yes [ ] No [ ] Unknown
- [ ] **Blocker for Migration:** [ ] Yes [ ] No [ ] N/A
- [ ] **Migration Required:** [ ] Yes [ ] No [ ] Retire
- **Migration Path:** _______________
- **Notes:** _______________

---

### 5. Other Applications to Assess

#### Email System
- **Current:** [ ] Exchange Online [ ] Exchange On-Prem [ ] Other: ___
- **Azure AD Integration:** [ ] Already integrated [ ] Required [ ] N/A
- **Action Required:** _______________

#### Accounting/Billing System
- **Vendor:** [TBD]
- **Product:** [TBD]
- **Azure AD Compatible:** [ ] Yes [ ] No [ ] Unknown
- **Action Required:** _______________

#### Dietary Management System
- **Vendor:** [TBD]
- **Product:** [TBD]
- **Azure AD Compatible:** [ ] Yes [ ] No [ ] Unknown
- **Action Required:** _______________

#### Activities Tracking System
- **Vendor:** [TBD]
- **Product:** [TBD]
- **Azure AD Compatible:** [ ] Yes [ ] No [ ] Unknown
- **Action Required:** _______________

#### Phone System
- **Vendor:** Great Plains Communications
- **Product:** Yealink phones (hosted PBX)
- **Azure AD Integration:** [ ] Not required (separate system)
- **Action Required:** None (independent system)

---

## Network & Infrastructure Dependencies

### Scanners / Multifunction Printers (MFPs)

#### Current Configuration
- **Number of Scanners/MFPs:** [TBD]
- **Models:** [TBD]
- **Current Scan Destinations:**
  - Nursing Scan share (C:\data\Nursing Scan)
  - Admin_Scan share (C:\data\Admin_Scan)
  - Scan share (C:\data\Scan)

#### Questions for Assessment
- [ ] **Q1:** Can scanners/MFPs scan directly to SharePoint Online?
  - **Answer:** _______________
  - **Documentation:** _______________
- [ ] **Q2:** Can scanners use Azure Files with SMB 3.0?
  - **Answer:** _______________
- [ ] **Q3:** Can scanners send via email to SharePoint document libraries?
  - **Answer:** _______________
- [ ] **Q4:** Do scanners require firmware updates for cloud compatibility?
  - **Answer:** _______________
  - **Update Required:** [ ] Yes [ ] No

#### Testing Requirements
- [ ] Test scan-to-SharePoint functionality
- [ ] Test scan-to-Azure Files
- [ ] Test scan-to-email (to SharePoint library)
- [ ] Validate file naming and organization
- [ ] Test from all scanner/MFP devices

#### Decision
- **Migration Path:** [ ] SharePoint [ ] Azure Files [ ] Email [ ] Other: ___
- **Blocker:** [ ] Yes [ ] No
- **Notes:** _______________

---

## Vendor Engagement Tracker

### Vendor Contact Log

| Date | Vendor | Contact Person | Method | Topic | Outcome | Follow-Up |
|------|--------|----------------|--------|-------|---------|-----------|
| | | | | | | |
| | | | | | | |
| | | | | | | |

### Outstanding Questions

| # | Vendor/Application | Question | Asked Date | Response Due | Status |
|---|-------------------|----------|------------|--------------|--------|
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |

---

## Application Compatibility Summary

**Status as of:** [Date]

| Application | Vendor | Critical? | Azure AD Compatible | Blocker? | Migration Path |
|-------------|--------|-----------|---------------------|----------|----------------|
| EHR | TBD | YES | Unknown | TBD | TBD |
| eMAR | TBD | YES | Unknown | TBD | TBD |
| KRONOS | UKG | MEDIUM | Unknown | TBD | TBD |
| IIS App | TBD | Unknown | Unknown | TBD | TBD |
| Scanners | Various | LOW | Unknown | TBD | TBD |

**Go/No-Go Decision for Migration:**
- [ ] All critical applications verified compatible
- [ ] All blockers resolved or mitigated
- [ ] Migration can proceed to Phase 2

**Blockers Identified:**
1. _______________
2. _______________
3. _______________

**Mitigation Plans:**
1. _______________
2. _______________
3. _______________

---

## Next Steps

### Week 1 Actions
- [ ] Interview Kylea to identify EHR, eMAR, and other application vendors
- [ ] Obtain vendor contact information
- [ ] Send initial inquiry emails to all vendors
- [ ] Schedule vendor calls for detailed assessments
- [ ] Review IIS logs and determine application usage

### Week 2 Actions
- [ ] Follow up on all vendor responses
- [ ] Test scanner cloud compatibility
- [ ] Document all findings in this worksheet
- [ ] Update Migration Project Plan with vendor feedback
- [ ] Make go/no-go decision for Phase 2

---

## Interview Questions for Kylea Punke

**Scheduled Interview Date:** _______________

### EHR / eMAR System
1. What is the name of your Electronic Health Records (EHR) system?
2. What is the name of your Medication Administration (eMAR) system?
3. Are these two systems integrated or separate products?
4. Who is the vendor for each system?
5. Do you have a support contact or account manager?
6. When was the last time you contacted vendor support?
7. Are these systems cloud-based or on-premises?

### KRONOS
1. Is KRONOS still actively used for time and attendance?
2. If yes, which KRONOS product (Workforce Central or Dimensions)?
3. If no, when was it retired and can we delete the C:\KRONOS share?

### IIS Website
1. Is there a website or web application running on SERVER-FS1?
2. What is the purpose of this website/application?
3. Who uses it and how often?
4. Is it still actively used?

### Other Applications
1. What accounting or billing system do you use?
2. What dietary management system do you use?
3. What activities tracking system do you use?
4. Are there any other applications that require Active Directory login?

### Scanners
1. How many scanners/MFPs do you have?
2. What models are they?
3. Where do scanned documents currently go (what file shares)?
4. How critical is scanning functionality to daily operations?

---

**Document Owner:** [Project Manager]
**Last Updated:** 2025-12-11
**Next Review:** Weekly until all vendors assessed
