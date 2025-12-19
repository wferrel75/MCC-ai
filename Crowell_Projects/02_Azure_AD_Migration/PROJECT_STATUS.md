# Azure AD Migration Project - Current Status
**Crowell Memorial Home**

**Last Updated:** 2025-12-11
**Phase:** Phase 1 - Assessment & Planning (Week 1)
**Overall Status:** 🟢 On Track

---

## Project Overview

**Objective:** Migrate from Windows Server 2008 R2 Active Directory to Azure AD
**Priority:** CRITICAL (Server 2008 R2 EOL, HIPAA compliance risk)
**Timeline:** 90 days (12-13 weeks)
**Target Completion:** March 2026

---

## Accomplishments Today (2025-12-11)

### ✅ Completed Tasks

1. **Crowell_Projects Directory Structure Created**
   - Organized project directories for all active projects
   - Created templates for meeting notes, change requests, and status reports
   - Established comprehensive CLAUDE.md and README.md documentation

2. **Azure AD Migration Assessment Checklist** (`02_Azure_AD_Migration/assessment/AD_Assessment_Checklist.md`)
   - 13-section comprehensive assessment framework
   - Pre-populated with known information from server audit
   - Marked current state (47 employees + 12 service/shared accounts = 59 AD users, 68 computers, 20.5 GB data)
   - Employee list verified: 47 active staff (updated 2025-12-12)
   - Identified Server 2008 R2 as CRITICAL risk

3. **Azure AD Migration Project Plan** (`02_Azure_AD_Migration/planning/Migration_Project_Plan.md`)
   - Comprehensive 90-day timeline with 5 phases
   - Detailed weekly breakdown of all tasks
   - Risk assessment and mitigation strategies
   - Budget estimates ($58,824 Year 1, $19,824/year ongoing)
   - Communication plan and stakeholder engagement
   - Success criteria and metrics
   - Rollback procedures

4. **Vendor & Application Dependency Worksheet** (`02_Azure_AD_Migration/assessment/Vendor_Application_Worksheet.md`)
   - Structured assessment for EHR, eMAR, KRONOS, IIS applications
   - Scanner/MFP compatibility tracking
   - Vendor contact log and engagement tracker
   - Interview questions for Kylea Punke
   - Application compatibility summary matrix

5. **PowerShell Data Collection Script** (`02_Azure_AD_Migration/assessment/Collect-ADMigrationData.ps1`)
   - Comprehensive script to export all AD data from SERVER-FS1
   - Exports: users, computers, groups, OUs, GPOs, DNS, file shares, permissions
   - Automated GPO backups
   - Network and system configuration data
   - IIS configuration (if applicable)
   - Ready to run on SERVER-FS1

6. **Nonprofit Licensing Research** (`02_Azure_AD_Migration/planning/Nonprofit_Licensing_Options.md`)
   - Comprehensive research on Microsoft 365 nonprofit pricing
   - Discovered 80% ongoing cost savings ($15,930/year)
   - Documented Windows 11 Pro upgrade options via TechSoup ($16/license vs. $199 commercial)
   - Identified 501(c)(3) eligibility and application process
   - Documented July 1, 2025 licensing changes (end of free Business Premium grants)
   - Updated Migration Project Plan budget with nonprofit pricing
   - 5-year savings: $93,182 (61% reduction vs. commercial pricing)

---

## Current Week Focus (Week 1: Dec 11-17)

### High Priority Tasks

#### Immediate Actions Needed
- [ ] **Schedule kick-off meeting with Kylea Punke and Jaclyn Svendgard**
  - Ideal date: This week (Dec 11-17)
  - Duration: 60-90 minutes
  - Topics: Project overview, timeline, vendor engagement, application assessment

- [ ] **Obtain signed Business Associate Agreement (BAA)**
  - Critical for HIPAA compliance
  - Must be in place before any PHI access or migration work
  - Contact: MCC legal/compliance team

- [ ] **Run PowerShell data collection script on SERVER-FS1**
  - Script: `Collect-ADMigrationData.ps1`
  - Coordinate with Kylea for access
  - Requires Domain Admin privileges
  - Output will populate assessment checklist

#### Application & Vendor Engagement
- [ ] **Interview Kylea to identify vendors**
  - EHR system vendor and version
  - eMAR system vendor and version
  - KRONOS status (still in use?)
  - IIS application purpose
  - Other critical applications

- [ ] **Begin vendor outreach**
  - Contact EHR vendor for Azure AD compatibility
  - Contact eMAR vendor for compatibility assessment
  - Contact KRONOS/UKG if still in use
  - Document all responses in Vendor_Application_Worksheet.md

#### Infrastructure Assessment
- [ ] **Follow up on nursing station connectivity issues**
  - Issue: 2nd floor PCs (including "Erica") lose internet overnight
  - Restore: Connectivity returns by 8:00 AM
  - Action: Investigate root cause before migration

---

## Key Deliverables Ready

| Document | Status | Location | Purpose |
|----------|--------|----------|---------|
| Project Plan | ✅ Complete | `planning/Migration_Project_Plan.md` | 90-day roadmap, budget, timeline |
| Nonprofit Licensing | ✅ Complete | `planning/Nonprofit_Licensing_Options.md` | Nonprofit pricing & eligibility |
| Assessment Checklist | 🟡 In Progress | `assessment/AD_Assessment_Checklist.md` | Data collection tracking |
| Vendor Worksheet | ✅ Complete | `assessment/Vendor_Application_Worksheet.md` | Application compatibility |
| Data Collection Script | ✅ Complete | `assessment/Collect-ADMigrationData.ps1` | AD data export tool |
| CLAUDE.md | ✅ Complete | `../CLAUDE.md` | AI/LLM guidance |
| README.md | ✅ Complete | `../README.md` | Project overview |
| Quick Reference | ✅ Complete | `../QUICK_REFERENCE.md` | One-page reference |

---

## Critical Path Items

### Blockers (Must Resolve Before Proceeding)
1. **EHR System Compatibility** - CRITICAL
   - Must verify EHR works with Azure AD
   - If incompatible, migration at risk
   - Mitigation: Hybrid approach or vendor engagement

2. **eMAR System Compatibility** - CRITICAL
   - Medication safety system must function
   - May be integrated with EHR
   - Critical for patient care

3. **Business Associate Agreement (BAA)** - CRITICAL
   - Required for HIPAA compliance
   - Must be signed before PHI access
   - Legal requirement

### High-Priority Dependencies
4. **KRONOS System Assessment** - HIGH
   - Determine if still in use
   - If yes, verify Azure AD compatibility or SMB requirements
   - Affects file share migration strategy

5. **IIS Application Identification** - MEDIUM
   - Determine purpose and usage
   - Decision: migrate, retire, or keep

6. **Scanner/MFP Compatibility** - MEDIUM
   - Test scan-to-SharePoint or Azure Files
   - Affects file share migration strategy

---

## Phase 1 Milestones (Weeks 1-2)

### Week 1 Milestones (Dec 11-17)
- [X] Create project structure and documentation
- [X] Develop assessment checklist
- [X] Create project plan and timeline
- [X] Prepare data collection tools
- [ ] Schedule and conduct kick-off meeting
- [ ] Obtain signed BAA
- [ ] Run AD data collection script
- [ ] Begin vendor engagement

### Week 2 Milestones (Dec 18-24)
- [ ] Complete vendor compatibility assessments
- [ ] Identify all application dependencies
- [ ] Analyze file shares and migration targets
- [ ] Test scanner cloud compatibility
- [ ] Assess workstation OS inventory
- [ ] Verify domain ownership (crowellhome.com)
- [ ] Complete risk assessment
- [ ] Customer approval to proceed to Phase 2

---

## Risks & Mitigation

### Active Risks

| Risk | Impact | Likelihood | Mitigation | Status |
|------|--------|------------|------------|--------|
| EHR incompatible with Azure AD | CRITICAL | Medium | Engage vendor early, test thoroughly, hybrid fallback | 🟡 Monitoring |
| eMAR incompatible | CRITICAL | Medium | Vendor engagement, testing | 🟡 Monitoring |
| KRONOS requires on-prem AD | Medium | Medium | Azure Files SMB, cloud version | 🟡 Monitoring |
| Extended downtime during cutover | HIGH | Low | Thorough testing, rollback plan | 🟢 Mitigated |
| Server 2008 R2 failure during project | CRITICAL | Medium | Urgent migration, no delay | 🔴 Ongoing Risk |

### Critical Risk: Server 2008 R2 Could Fail Anytime
⚠️ **ONGOING RISK:** SERVER-FS1 is running Windows Server 2008 R2, which has been unsupported for 5+ years. Hardware or software failure could occur at any time, potentially causing:
- Complete domain outage
- Loss of authentication (no user logins)
- File share unavailability
- PHI data access interruption
- Patient care impact

**Mitigation:** Prioritize migration execution, no delays in timeline.

---

## Budget Summary

### Year 1 Costs (NONPROFIT PRICING)
- **Microsoft 365 Licensing:** $3,300-3,630/year (revised based on employee count)
  - Employee Count: 47 active employees (verified from employee list 2025-12-12)
  - Estimated Total Licenses: 50-55 (includes shared/service accounts)
  - M365 Business Premium (includes Entra ID P1): 50-55 users × $5.50/user/month × 12
  - **Conservative estimate: 55 licenses = $3,630/year**
  - Original estimate was 59 licenses = $3,894/year
  - **Savings from revised count: $264/year**
  - Nonprofit discount: 75% savings vs. commercial ($11,682/year saved)
- **Windows 11 Pro Upgrades:** $800-1,088 (one-time)
  - TechSoup nonprofit pricing: 50-68 licenses @ $16/license
  - Commercial pricing: $199/license (92% nonprofit discount)
- **Professional Services:** $39,000 (one-time)
  - Assessment & Planning: $6,000
  - Pre-Migration Setup: $6,000
  - Testing & Validation: $9,000
  - Migration Execution: $12,000
  - Decommission & Closeout: $6,000
- **Total Year 1:** $43,694 (nonprofit pricing)
  - **vs. $72,356 commercial pricing**
  - **Year 1 Savings: $28,662 (40%)**

### Ongoing Costs (Year 2+)
- **Licensing:** $3,894/year (nonprofit OpEx)
  - **vs. $19,824/year commercial**
  - **Annual Savings: $15,930/year (80%)**
- **No hardware refresh needed**
- **No server maintenance**

### 5-Year Total Cost Comparison
- **Nonprofit Pricing:** $59,270
- **Commercial Pricing:** $152,452
- **5-Year Savings: $93,182 (61% reduction)**

### Cost Avoidance (vs. New On-Prem Server)
- Hardware: $8,000-15,000 (avoided)
- Windows Server licenses: $1,000-2,000 (avoided)
- Ongoing maintenance: $3,000-5,000/year (avoided)
- 5-year hardware refresh: $8,000-15,000 (avoided)

**Reference:** See `planning/Nonprofit_Licensing_Options.md` for complete nonprofit pricing details and eligibility requirements.

---

## Next Meeting Agenda

**Kick-Off Meeting with Kylea & Jaclyn**

**Duration:** 60-90 minutes

**Agenda:**
1. **Project Overview** (10 min)
   - Critical issue: Server 2008 R2 EOL
   - Migration approach: Azure AD cloud-only
   - Timeline: 90 days (5 phases)

2. **Application Assessment** (20 min)
   - Identify EHR and eMAR vendors
   - KRONOS status and usage
   - IIS application purpose
   - Other critical applications

3. **Vendor Engagement Plan** (15 min)
   - Who to contact for each system
   - Timeline for vendor responses
   - Testing requirements

4. **Timeline & Phases** (15 min)
   - Phase 1: Assessment (Weeks 1-2)
   - Phase 2: Pre-Migration Setup (Weeks 3-4)
   - Phase 3: Testing (Weeks 5-7)
   - Phase 4: Migration (Weeks 8-10)
   - Phase 5: Decommission (Weeks 11-14)

5. **Communication & Training** (10 min)
   - User communication plan
   - Training schedule
   - Support during migration

6. **Q&A and Next Steps** (15 min)
   - Address concerns
   - Confirm action items
   - Schedule follow-up

---

## Success Metrics (Target)

### Technical Targets
- ✅ All 47 employees migrated to Azure AD (+ shared/service accounts as needed)
- ✅ MFA enabled for 100% of users (all 50-55 licenses)
- ✅ All 68 workstations Azure AD-joined
- ✅ 20.5 GB file shares migrated (zero data loss)
- ✅ Critical apps functional (EHR, eMAR)
- ✅ <4 hours planned downtime
- ✅ SERVER-FS1 decommissioned

### HIPAA Compliance Targets
- ✅ MFA coverage: 100%
- ✅ Audit logging: 6+ years retention
- ✅ Data encryption: at rest and in transit
- ✅ Azure AD Security Score: >80%
- ✅ Zero security incidents

---

## Communication Log

| Date | Type | Participants | Topic | Outcome |
|------|------|--------------|-------|---------|
| 2025-12-11 | Internal | MCC Team | Project initiation | Documentation created |
| TBD | Meeting | Kylea, Jaclyn, MCC | Kick-off | Pending |

---

## Next Steps Summary

### This Week (Dec 11-17)
1. Schedule kick-off meeting with Kylea and Jaclyn
2. Obtain signed BAA from customer
3. **Apply for TechSoup nonprofit validation** (for Windows 11 Pro licenses)
4. **Register with Microsoft Nonprofit Portal** (for M365 nonprofit pricing)
5. Run PowerShell data collection script on SERVER-FS1
6. Interview Kylea to identify all vendor contacts
7. Begin vendor outreach (EHR, eMAR, KRONOS)
8. Investigate nursing station connectivity issue

### Next Week (Dec 18-24)
1. Complete vendor compatibility assessments
2. Analyze collected AD data
3. Test scanner cloud compatibility
4. Plan file share migration strategy
5. Verify public domain ownership
6. Complete risk assessment
7. **Finalize nonprofit licensing application** (TechSoup + Microsoft)
8. **Order 50 Windows 11 Pro licenses from TechSoup** ($800)
9. Prepare Phase 1 deliverables for customer approval

---

**Project Manager:** [TBD]
**Technical Lead:** [TBD]
**Customer Primary Contact:** Kylea Punke (kpunke@crowellhome.com)
**Customer Executive:** Jaclyn Svendgard (jmsvendgard4@gmail.com)

---

**Status:** 🟢 On Track
**Next Update:** 2025-12-18 (weekly updates)
