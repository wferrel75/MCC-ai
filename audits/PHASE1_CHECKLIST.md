# Phase 1 Implementation Checklist
## User Account Audit System - Entra ID, Keeper, ConnectSecure

**Project Owner:** wferrel
**Duration:** 4 weeks (Dec 18, 2024 - Jan 14, 2025)
**Status:** 🔴 Not Started

---

## Week 1: Infrastructure Setup (Dec 18-24, 2024)

### Day 1-2: Infrastructure
- [ ] Access n8n instance: https://n8n.midcloudcomputing.com/
- [ ] Create workflow folder: "User Audit System"
- [ ] Decide: n8n Data Tables or PostgreSQL (Recommendation: Data Tables)
- [ ] **Create data table: "UserAudit_Master"**
  - [ ] **Option A:** Import CSV: `/home/wferrel/ai/audits/UserAudit_Master_Template.csv`
  - [ ] **Option B:** Follow manual setup guide: [N8N_DATA_TABLE_SETUP.md](N8N_DATA_TABLE_SETUP.md)
- [ ] Test data table with sample record (test insert and upsert)
- [ ] Review workflow templates: [N8N_WORKFLOW_TEMPLATES.md](N8N_WORKFLOW_TEMPLATES.md)

### Day 3-4: Data Schema
- [ ] Create table columns (see PROJECT_PLAN.md for schema)
- [ ] Test insert/upsert operations
- [ ] Document schema decisions
- [ ] Create workflow naming convention

### Day 5: Credential Management
- [ ] Document credential storage approach
- [ ] Test credential access in n8n
- [ ] Create troubleshooting log template
- [ ] **WEEK 1 COMPLETE** ✓

---

## Week 2: Microsoft Entra ID (Dec 25-31, 2024)

### 🎉 Workflow Ready!
**Workflow JSON:** `/home/wferrel/ai/audits/workflows/EntraID_User_Audit.json`
**Quick Start:** [ENTRA_ID_QUICK_START.md](ENTRA_ID_QUICK_START.md)
**Full Guide:** [ENTRA_ID_SETUP_GUIDE.md](ENTRA_ID_SETUP_GUIDE.md)

### Prerequisites - Azure AD App Registration
- [ ] Access Azure Portal with admin rights (portal.azure.com)
- [ ] Create app registration: "MCC-UserAudit-Service"
  - [ ] Note Tenant ID: _______________
  - [ ] Note Client ID: _______________
  - [ ] Generate Client Secret: _______________
  - [ ] **SAVE SECRET IMMEDIATELY** (can't view again!)
  - [ ] Set calendar reminder (24 months - rotate secret)
- [ ] Grant API permissions:
  - [ ] User.Read.All
  - [ ] Directory.Read.All
  - [ ] AuditLog.Read.All (optional - requires Premium P1/P2)
- [ ] **CRITICAL:** Click "Grant admin consent for [Your Org]"
- [ ] Verify green checkmarks on all permissions

### n8n Configuration
- [ ] Add environment variables in n8n Settings:
  - [ ] ENTRA_TENANT_ID = [your tenant ID]
  - [ ] ENTRA_CLIENT_ID = [your client ID]
  - [ ] ENTRA_CLIENT_SECRET = [your client secret]
  - [ ] NOTIFICATION_EMAIL = [your email]

### Import & Test Workflow
- [ ] **Import workflow JSON to n8n**
  - Workflows → + Add workflow → Import from File
  - File: `/home/wferrel/ai/audits/workflows/EntraID_User_Audit.json`
- [ ] Verify workflow imported (should have 23 nodes)
- [ ] Verify data table reference points to "UserAudit"

### Testing Phase
- [ ] **Test 1: Authentication**
  - Execute "Get Access Token" node
  - Verify token received
- [ ] **Test 2: Limited user fetch**
  - Edit "Get Users - First Page" node
  - Change $top=999 to $top=5
  - Execute node, verify 5 users returned
- [ ] **Test 3: Full workflow (5 users)**
  - Execute complete workflow
  - Check UserAudit table has 5 records
  - Verify all columns populated correctly
- [ ] **Test 4: Verify upsert**
  - Run workflow again
  - Confirm still only 5 records (no duplicates)
  - Check last_audit_date updated
- [ ] **Test 5: Full production run**
  - Change $top back to 999
  - Execute workflow (will take 5-15 min)
  - Verify all users collected and stored

### Enable Production
- [ ] Disable "Manual Trigger" node
- [ ] Enable "Schedule Trigger" node
- [ ] Verify schedule: 0 2 * * * (2:00 AM daily)
- [ ] Toggle workflow to "Active"
- [ ] *Optional:* Enable email notifications
- [ ] Monitor first scheduled run
- [ ] **WEEK 2 COMPLETE** ✓

---

## Week 3: Keeper Security (Jan 1-7, 2025)

### Prerequisites
- [ ] Review Keeper docs: https://docs.keeper.io/en/enterprise-guide/
- [ ] Obtain Keeper API credentials
  - [ ] API Key: _______________
  - [ ] Other auth details: _______________
- [ ] Identify user list API endpoint
- [ ] Test authentication manually (curl/Postman)

### Day 1-2: Authentication & Discovery
- [ ] Create n8n workflow: "Keeper - User Audit"
- [ ] Store Keeper credentials in n8n
- [ ] Implement authentication flow
- [ ] Test and verify token/session
- [ ] Identify exact endpoints for users and roles
- [ ] Document Keeper API response schema

### Day 3: Get Users and Roles
- [ ] Create "Get Keeper Users" HTTP Request node
- [ ] Handle pagination (if applicable)
- [ ] Create "Get User Roles" node
- [ ] Test with Keeper instance
- [ ] Verify all expected fields present

### Day 4: Transform Data
- [ ] Create "Transform to Common Schema" Code node
- [ ] Map Keeper fields to common schema
- [ ] Handle null/missing fields gracefully
- [ ] Test transformation with sample data

### Day 5: Store and Schedule
- [ ] Create "Store in Data Table" node (Upsert)
- [ ] Test full workflow end-to-end
- [ ] Add Schedule Trigger (daily at 2:30 AM - offset from Entra)
- [ ] Add error handling and notifications
- [ ] Test scheduled execution
- [ ] **WEEK 3 COMPLETE** ✓

---

## Week 4: ConnectSecure & Reporting (Jan 8-14, 2025)

### Prerequisites
- [ ] Review existing ConnectSecure workflows:
  - [ ] "ConnectSecure New Company" (ID: 6dZa9lPkps3OtXyB)
  - [ ] "ConnectSecure Sync Companies" (ID: LFPxadxdOeH9UGNY)
- [ ] Verify ConnectSecure credentials available
- [ ] Identify customer tenants (if multi-tenant)

### Day 1: Authentication
- [ ] Create n8n workflow: "ConnectSecure - User Audit"
- [ ] Copy authentication nodes from existing workflow
- [ ] Encode credentials: base64(tenant+client_id:client_secret)
- [ ] POST to /w/authorize
- [ ] Test and verify access_token received

### Day 2: Get Users
- [ ] Create "Get Users" HTTP Request node
  - Endpoint: GET /r/user/get_users
- [ ] Implement pagination (skip/limit pattern)
- [ ] Test user retrieval
- [ ] Handle multi-tenant if applicable

### Day 3: Multi-Tenant (if needed)
- [ ] Document MCC customer tenant list
- [ ] Create tenant iteration loop
- [ ] Test with 2-3 tenants
- [ ] Verify tenant_id tagging works

### Day 4: Transform and Store
- [ ] Create "Transform to Common Schema" Code node
- [ ] Map ConnectSecure fields
- [ ] Create "Store in Data Table" node (Upsert)
- [ ] Test full workflow end-to-end
- [ ] Add Schedule Trigger (daily at 3:30 AM)
- [ ] Add error handling and notifications

### Day 5: Basic Reporting
- [ ] Create workflow: "Report - User Counts by Platform"
  - [ ] Query data table, group by source_platform
  - [ ] Format as table
  - [ ] Email/Slack output
- [ ] Create workflow: "Report - All Users Export"
  - [ ] Query all users
  - [ ] Export to CSV
- [ ] Create workflow: "Report - MFA Status"
  - [ ] Count MFA enabled/disabled by platform
  - [ ] Create summary report
- [ ] Test all 3 platforms collecting data
- [ ] Verify scheduled runs work overnight
- [ ] **WEEK 4 COMPLETE** ✓

---

## Phase 1 Final Review (Day 5-7 of Week 4)

### Testing
- [ ] All 3 platforms collecting data daily
- [ ] Data normalizes correctly
- [ ] Upsert logic works (no duplicates)
- [ ] Error notifications working
- [ ] Success notifications working
- [ ] Reports generate correctly
- [ ] Performance acceptable (< 30 min per platform)

### Documentation
- [ ] Update PROJECT_PLAN.md with completion dates
- [ ] Document deviations from plan
- [ ] Create troubleshooting guide (common issues)
- [ ] Document credential rotation procedures
- [ ] Take screenshots of workflows for reference

### Deliverables Checklist
- [ ] ✅ n8n infrastructure set up
- [ ] ✅ UserAudit_Master data table created with schema
- [ ] ✅ Entra ID workflow complete and scheduled
- [ ] ✅ Keeper Security workflow complete and scheduled
- [ ] ✅ ConnectSecure workflow complete and scheduled
- [ ] ✅ 3 basic reports created and tested
- [ ] ✅ Error handling implemented on all workflows
- [ ] ✅ Documentation updated

---

## Success Metrics

### Quantitative
- [ ] 3 platforms automated ✓
- [ ] 100% data collection success rate for 1 week
- [ ] All scheduled runs complete in < 30 minutes
- [ ] 0 manual interventions required for 1 week

### Qualitative
- [ ] Can answer: "How many users do we have in Entra ID?"
- [ ] Can answer: "Which users have MFA enabled?"
- [ ] Can answer: "What roles does user X have in ConnectSecure?"
- [ ] Can generate CSV export of all users
- [ ] Confidence to expand to more platforms in Phase 2

---

## Known Issues / Blockers Log

| Date | Issue | Resolution | Status |
|------|-------|------------|--------|
| | | | |

---

## Questions to Resolve

- [ ] Which Azure AD tenant to use? (MCC's own or customer tenant?)
- [ ] Does MCC have Azure AD Premium? (for audit logs)
- [ ] How many ConnectSecure tenants does MCC manage?
- [ ] What's the preferred notification method? (Email/Slack/Teams?)
- [ ] Who should receive error notifications?

---

## Post-Phase 1 Actions

### Immediate Next Steps
- [ ] Review Phase 1 with stakeholders
- [ ] Document lessons learned
- [ ] Estimate Phase 2 timeline based on actual effort
- [ ] Plan next 7 platforms for Phase 2

### Phase 2 Preview
**Planned Platforms:**
1. Microsoft 365 (similar to Entra ID, easier now)
2. RocketCyber
3. Cisco Meraki
4. Zoho Desk
5. Zoho Projects
6. AWS (if applicable)
7. Azure (if applicable)

**Estimated Duration:** 4 weeks
**Target Start:** January 15, 2025

---

## Quick Reference Links

### Documentation
- [PROJECT_PLAN.md](PROJECT_PLAN.md) - Detailed week-by-week plan
- [API_MATRIX.md](API_MATRIX.md) - API capability matrix
- [microsoft_entra_id/API_RESEARCH.md](microsoft_entra_id/API_RESEARCH.md) - Entra ID details
- [keeper_security/API_RESEARCH.md](keeper_security/API_RESEARCH.md) - Keeper details
- [connectsecure/API_RESEARCH.md](connectsecure/API_RESEARCH.md) - ConnectSecure details

### Tools
- n8n: https://n8n.midcloudcomputing.com/
- Azure Portal: https://portal.azure.com/
- Graph Explorer: https://developer.microsoft.com/en-us/graph/graph-explorer
- ConnectSecure Swagger: /home/wferrel/ai/n8n-workflows/Connect_Secure/swagger.yaml

### External Docs
- Microsoft Graph API: https://learn.microsoft.com/en-us/graph/
- Keeper Docs: https://docs.keeper.io/en/enterprise-guide/
- n8n Docs: https://docs.n8n.io/

---

## Progress Tracking

**Overall Phase 1 Progress:** 0% (0/4 weeks complete)

- Week 1 (Infrastructure): ⚪ Not Started
- Week 2 (Entra ID): ⚪ Not Started
- Week 3 (Keeper): ⚪ Not Started
- Week 4 (ConnectSecure): ⚪ Not Started

**Update this tracker weekly!**

---

*Last Updated: 2025-12-17*
*Next Update: End of Week 1 (Dec 24, 2024)*
*Project Owner: wferrel*
