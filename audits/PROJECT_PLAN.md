# User Account Audit System - Project Plan
## Phase 1 Implementation: Entra ID, Keeper Security, ConnectSecure

---

## Project Team

### All Roles Assigned To: **wferrel**

- **Project Lead:** wferrel
- **Developer:** wferrel
- **Admin (Manual Processes):** wferrel
- **Tester:** wferrel
- **Documentation Owner:** wferrel

---

## Phase 1 Platform Selection

### Selected Platforms (3)
1. **Microsoft Entra ID** - Identity and access management foundation
2. **Keeper Security** - Password and credential management
3. **ConnectSecure** - Vulnerability and compliance management

### Rationale for Selection
- **Entra ID**: Foundational identity platform, well-documented Graph API
- **Keeper**: Critical credential management, comprehensive API/SDK
- **ConnectSecure**: Already familiar (existing n8n workflows), MSP-centric

### Expected Outcomes
- Prove n8n orchestration pattern
- Validate common data schema
- Establish authentication patterns (OAuth, Bearer tokens, REST API)
- Create reusable templates for future platforms

---

## Phase 1 Detailed Timeline

### Week 1: Infrastructure and Schema (Dec 18-24, 2024)

#### Day 1-2: Infrastructure Setup
- [ ] Access n8n instance at https://n8n.midcloudcomputing.com/
- [ ] Create dedicated workflow folder: "User Audit System"
- [ ] Decide on data storage:
  - **Option A:** n8n Data Tables (simpler, built-in)
  - **Option B:** PostgreSQL database (more scalable)
  - **Recommendation:** Start with n8n Data Tables, migrate if needed
- [ ] Create data table: "UserAudit_Master" with common schema
- [ ] Set up credential storage in n8n (or Keeper integration)

#### Day 3-4: Common Data Schema Implementation
- [ ] Create data table with columns:
  ```
  - id (auto-increment)
  - source_platform (string)
  - user_id (string)
  - username (string)
  - email (string)
  - display_name (string)
  - first_name (string)
  - last_name (string)
  - account_enabled (boolean)
  - account_created (datetime)
  - last_login (datetime)
  - mfa_enabled (boolean)
  - roles (JSON string)
  - permissions (JSON string)
  - licenses (JSON string)
  - tenant_id (string)
  - last_audit_date (datetime)
  - collection_method (string: 'api' or 'manual')
  - raw_data (JSON string - full response for debugging)
  ```

#### Day 5: Documentation
- [ ] Document infrastructure decisions
- [ ] Create n8n workflow naming convention
- [ ] Document credential management approach
- [ ] Create troubleshooting log template

**Week 1 Deliverable:** Infrastructure ready, data table created

---

### Week 2: Microsoft Entra ID Integration (Dec 25-31, 2024)

#### Prerequisites
- [ ] Access to Azure AD tenant (admin access)
- [ ] Create app registration:
  - Azure Portal → Azure Active Directory → App registrations → New registration
  - Name: "MCC-UserAudit-Service"
  - Supported account types: Single tenant (or multi-tenant if managing multiple customer tenants)
  - Redirect URI: Not needed for client credentials flow
- [ ] Generate Client Secret:
  - App registration → Certificates & secrets → New client secret
  - Description: "n8n User Audit Integration"
  - Expires: 24 months (set reminder to rotate)
  - **Save Client Secret immediately** (won't be shown again)
- [ ] Grant API permissions:
  - App registration → API permissions → Add a permission
  - Microsoft Graph → Application permissions
  - Add: `User.Read.All`, `Directory.Read.All`, `AuditLog.Read.All` (if Premium)
  - **Admin consent required** - Click "Grant admin consent for [tenant]"
- [ ] Note Tenant ID and Client ID (Application ID)

#### Development Tasks

##### Day 1: Authentication
- [ ] Create n8n workflow: "EntraID - User Audit"
- [ ] Add credential in n8n:
  - Type: OAuth2 API OR Generic Credential
  - Store: tenant_id, client_id, client_secret
- [ ] Create "Get Access Token" node:
  ```
  HTTP Request:
    Method: POST
    URL: https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token
    Body (Form):
      client_id: {client_id}
      client_secret: {client_secret}
      scope: https://graph.microsoft.com/.default
      grant_type: client_credentials
  ```
- [ ] Test authentication, verify token received
- [ ] Store token in workflow variable for reuse

##### Day 2: Get Users List
- [ ] Create "Get Users" node:
  ```
  HTTP Request:
    Method: GET
    URL: https://graph.microsoft.com/v1.0/users?$select=id,userPrincipalName,displayName,givenName,surname,mail,accountEnabled,createdDateTime,jobTitle,department&$top=999
    Headers:
      Authorization: Bearer {{$node["Get Access Token"].json.access_token}}
  ```
- [ ] Handle pagination:
  - Check for @odata.nextLink in response
  - Loop until no more pages
- [ ] Test with your tenant, verify user list retrieved

##### Day 3: Enrich User Data
- [ ] For each user, create parallel enrichment nodes:
  - **Get MemberOf** (roles and groups):
    ```
    GET /users/{id}/memberOf
    ```
  - **Get Authentication Methods** (MFA status):
    ```
    GET /users/{id}/authentication/methods
    ```
  - **Get License Details**:
    ```
    GET /users/{id}/licenseDetails
    ```
  - **Get Sign-In Activity** (if Premium available):
    ```
    GET /users/{id}?$select=signInActivity
    ```
- [ ] Use "Split in Batches" node to avoid overwhelming API
- [ ] Test enrichment for 5-10 users

##### Day 4: Data Transformation
- [ ] Create "Transform to Common Schema" Code node:
  ```javascript
  const items = $input.all();
  const transformed = items.map(item => {
    const user = item.json;

    // Extract roles from memberOf
    const roles = (user.memberOf || [])
      .filter(m => m['@odata.type'] === '#microsoft.graph.directoryRole')
      .map(r => r.displayName);

    // Check MFA enabled
    const authMethods = user.authenticationMethods || [];
    const mfaEnabled = authMethods.length > 1;

    // Extract licenses
    const licenses = (user.licenseDetails || [])
      .map(l => l.skuPartNumber);

    return {
      json: {
        source_platform: 'Microsoft Entra ID',
        user_id: user.id,
        username: user.userPrincipalName,
        email: user.mail || user.userPrincipalName,
        display_name: user.displayName,
        first_name: user.givenName,
        last_name: user.surname,
        account_enabled: user.accountEnabled,
        account_created: user.createdDateTime,
        last_login: user.signInActivity?.lastSignInDateTime || null,
        mfa_enabled: mfaEnabled,
        roles: JSON.stringify(roles),
        permissions: JSON.stringify([]), // Not detailed in this version
        licenses: JSON.stringify(licenses),
        tenant_id: $('Get Access Token').first().json.tenant_id,
        last_audit_date: new Date().toISOString(),
        collection_method: 'api',
        raw_data: JSON.stringify(user)
      }
    };
  });

  return transformed;
  ```
- [ ] Test transformation, verify all fields populated correctly

##### Day 5: Store Data and Schedule
- [ ] Create "Store in Data Table" node:
  - Operation: Upsert
  - Data Table: UserAudit_Master
  - Matching Column: user_id + source_platform (composite unique key)
- [ ] Test full workflow end-to-end
- [ ] Add Schedule Trigger:
  - Type: Cron
  - Schedule: Daily at 2:00 AM (or appropriate time)
- [ ] Add error handling:
  - Error Workflow node
  - Email/Slack notification on failure
- [ ] Add success notification with summary:
  - "Entra ID audit complete: X users collected"

**Week 2 Deliverable:** Entra ID integration complete and scheduled

---

### Week 3: Keeper Security Integration (Jan 1-7, 2025)

#### Prerequisites Research
- [ ] Review Keeper API documentation:
  - https://docs.keeper.io/en/enterprise-guide/developer-tools
  - https://docs.keeper.io/en/enterprise-guide/keeper-msp/account-management-apis
- [ ] Determine API access method:
  - **Option A:** Keeper Commander CLI in REST mode
  - **Option B:** Direct REST API
  - **Recommendation:** REST API for simpler n8n integration
- [ ] Obtain API credentials:
  - Keeper Console → Settings → API Access
  - Generate API key
  - Note authentication method (verify in documentation)

#### Development Tasks

##### Day 1-2: Authentication and Endpoint Discovery
- [ ] Create n8n workflow: "Keeper - User Audit"
- [ ] Store Keeper credentials in n8n
- [ ] Implement authentication:
  - Review Keeper auth flow (may be simpler than OAuth)
  - Test authentication endpoint
  - Store session/token
- [ ] Identify user list endpoint:
  - Review Keeper API docs for enterprise user management
  - Test user list retrieval
  - Document response schema

##### Day 3: Get Users and Roles
- [ ] Create "Get Keeper Users" node:
  - HTTP Request to user list endpoint
  - Handle pagination if applicable
- [ ] Create "Get User Roles" node:
  - Retrieve RBAC roles per user
  - Get role enforcement policies
- [ ] Test with Keeper instance

##### Day 4: Data Transformation
- [ ] Create transformation node similar to Entra ID:
  ```javascript
  // Map Keeper user data to common schema
  {
    source_platform: 'Keeper Security',
    user_id: keeper_user.id,
    username: keeper_user.username,
    email: keeper_user.email,
    display_name: keeper_user.full_name || keeper_user.username,
    first_name: keeper_user.first_name,
    last_name: keeper_user.last_name,
    account_enabled: keeper_user.status === 'active',
    account_created: keeper_user.created_date,
    last_login: keeper_user.last_login,
    mfa_enabled: keeper_user.mfa_enabled || null,
    roles: JSON.stringify(keeper_user.roles || []),
    permissions: JSON.stringify(keeper_user.permissions || []),
    licenses: JSON.stringify([]), // Not applicable
    tenant_id: '<mcc_tenant>',
    last_audit_date: new Date().toISOString(),
    collection_method: 'api',
    raw_data: JSON.stringify(keeper_user)
  }
  ```
- [ ] Test transformation

##### Day 5: Integration and Scheduling
- [ ] Connect to UserAudit_Master data table (upsert)
- [ ] Add Schedule Trigger (daily, offset from Entra ID by 30 min)
- [ ] Add error handling and notifications
- [ ] Test full workflow end-to-end

**Week 3 Deliverable:** Keeper Security integration complete and scheduled

---

### Week 4: ConnectSecure Integration (Jan 8-14, 2025)

#### Prerequisites
- [ ] Access existing ConnectSecure workflows:
  - Review `/home/wferrel/ai/n8n-workflows/ConnectSecure New Company`
  - Review `/home/wferrel/ai/n8n-workflows/ConnectSecure Sync Companies`
  - Use as authentication template
- [ ] Verify ConnectSecure credentials:
  - Tenant + Client ID + Client Secret
  - Stored in n8n or environment variables
- [ ] Review API endpoint:
  - `GET /r/user/get_users` (documented at line 31979 in swagger.yaml)

#### Development Tasks

##### Day 1: Authentication (Use Existing Pattern)
- [ ] Create n8n workflow: "ConnectSecure - User Audit"
- [ ] Copy authentication nodes from existing workflow:
  - Load credentials
  - Encode to base64: `tenant+client_id:client_secret`
  - POST to `/w/authorize`
  - Extract access_token and user_id
- [ ] Test authentication

##### Day 2: Get Users
- [ ] Create "Get ConnectSecure Users" node:
  ```
  HTTP Request:
    Method: GET
    URL: https://pod107.myconnectsecure.com/r/user/get_users?skip=0&limit=100
    Headers:
      Authorization: Bearer {{$node["Authenticate"].json.access_token}}
      X-USER-ID: {{$node["Authenticate"].json.user_id}}
  ```
- [ ] Implement pagination loop:
  ```javascript
  // Pagination logic
  let allUsers = [];
  let skip = 0;
  const limit = 100;

  while (true) {
    const response = await fetch(url + `?skip=${skip}&limit=${limit}`);
    const data = response.data;
    allUsers = allUsers.concat(data);

    if (data.length < limit) break;
    skip += limit;
  }
  ```
- [ ] Test user retrieval

##### Day 3: Multi-Tenant Consideration
- [ ] Identify if MCC manages multiple ConnectSecure tenants
- [ ] If yes, create loop for tenant iteration:
  - Store tenant list (from customer profiles)
  - Authenticate per tenant
  - Collect users per tenant
  - Tag with customer/tenant identifier
- [ ] If no, single tenant flow is sufficient

##### Day 4: Data Transformation
- [ ] Create transformation node:
  ```javascript
  {
    source_platform: 'ConnectSecure',
    user_id: cs_user.id,
    username: cs_user.user_name,
    email: cs_user.email,
    display_name: `${cs_user.first_name} ${cs_user.last_name}`,
    first_name: cs_user.first_name,
    last_name: cs_user.last_name,
    account_enabled: cs_user.state === 'active',
    account_created: cs_user.created_date,
    last_login: cs_user.last_login,
    mfa_enabled: null, // Check if available in response
    roles: JSON.stringify(cs_user.roles || []),
    permissions: JSON.stringify([]),
    licenses: JSON.stringify([]),
    tenant_id: '<customer_tenant_id>', // From loop or config
    last_audit_date: new Date().toISOString(),
    collection_method: 'api',
    raw_data: JSON.stringify(cs_user)
  }
  ```
- [ ] Test transformation

##### Day 5: Integration and Scheduling
- [ ] Connect to UserAudit_Master data table (upsert)
- [ ] Add Schedule Trigger (daily, offset by 1 hour from Keeper)
- [ ] Add error handling and notifications
- [ ] Test full workflow end-to-end with all 3 platforms

**Week 4 Deliverable:** ConnectSecure integration complete and scheduled

---

## End of Phase 1: Review and Reporting (Week 4, Day 5-7)

### Create Basic Reports

#### Report 1: User Count by Platform
- [ ] Create n8n workflow: "Report - User Counts"
- [ ] Query data table:
  ```sql
  SELECT source_platform, COUNT(*) as user_count
  FROM UserAudit_Master
  GROUP BY source_platform
  ORDER BY user_count DESC
  ```
- [ ] Format as table and send via email/Slack

#### Report 2: All Users Consolidated
- [ ] Create n8n workflow: "Report - All Users"
- [ ] Query all users from data table
- [ ] Export to CSV
- [ ] Include filters: platform, enabled/disabled, MFA status

#### Report 3: MFA Status Dashboard
- [ ] Query users by MFA status:
  ```sql
  SELECT source_platform,
         SUM(CASE WHEN mfa_enabled = TRUE THEN 1 ELSE 0 END) as mfa_enabled,
         SUM(CASE WHEN mfa_enabled = FALSE THEN 1 ELSE 0 END) as mfa_disabled,
         COUNT(*) as total
  FROM UserAudit_Master
  GROUP BY source_platform
  ```
- [ ] Create summary report

#### Report 4: Recent Changes
- [ ] Query users where last_audit_date is recent:
  ```sql
  SELECT *
  FROM UserAudit_Master
  WHERE last_audit_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)
  ORDER BY last_audit_date DESC
  ```
- [ ] Flag new accounts, disabled accounts, role changes

### Testing Checklist
- [ ] All 3 platforms collecting data daily
- [ ] Data normalizes correctly to common schema
- [ ] Upsert logic works (updates existing, inserts new)
- [ ] Error handling catches and reports failures
- [ ] Notifications working (success and failure)
- [ ] Reports generate correctly
- [ ] Performance acceptable (< 30 minutes per platform)

### Documentation
- [ ] Update `PROJECT_PLAN.md` with actual completion dates
- [ ] Document any deviations from plan
- [ ] Create troubleshooting guide with common issues encountered
- [ ] Document credential rotation procedures
- [ ] Update `IMPLEMENTATION_ROADMAP.md` with lessons learned

---

## Success Criteria - Phase 1

### Must Have ✅
- [x] Infrastructure set up (n8n + data storage)
- [ ] 3 platforms integrated (Entra ID, Keeper, ConnectSecure)
- [ ] Common data schema implemented and working
- [ ] Data collected automatically on schedule (daily)
- [ ] Basic reports available

### Should Have 📋
- [ ] Error handling and notifications
- [ ] Multi-tenant support (if applicable)
- [ ] CSV export functionality
- [ ] Documentation complete

### Nice to Have 🎯
- [ ] Dashboard visualization
- [ ] Advanced filtering
- [ ] Historical trend tracking
- [ ] Anomaly detection alerts

---

## Risk Log and Mitigation

### Risk 1: Multi-Tenant Complexity
**Risk:** MCC manages multiple customer tenants, requiring iteration logic
**Status:** TBD - Need to verify tenant count
**Mitigation:**
- Phase 1: Focus on single tenant (MCC's own)
- Phase 2: Add multi-tenant support with customer mapping

### Risk 2: API Rate Limiting
**Risk:** Hitting API rate limits during collection
**Status:** Low probability (small user counts)
**Mitigation:**
- Implement delays between requests
- Offset scheduled runs by 30-60 minutes
- Monitor for 429 errors

### Risk 3: Keeper API Documentation Gaps
**Risk:** Keeper API may be less documented than Microsoft
**Status:** Medium probability
**Mitigation:**
- Allocate extra time in Week 3
- Contact Keeper support if needed
- Test with small dataset first

### Risk 4: Credential Expiry
**Risk:** API tokens/secrets expire during development
**Status:** Medium probability
**Mitigation:**
- Set calendar reminders for expiry dates
- Document rotation procedures
- Use long-lived credentials where possible

### Risk 5: Data Schema Changes
**Risk:** Common schema doesn't accommodate all platforms
**Status:** Low probability (designed with flexibility)
**Mitigation:**
- Schema includes `raw_data` field for debugging
- Can modify schema as needed (n8n tables are flexible)
- Document schema version

---

## Daily Standup Template

### What did I accomplish yesterday?
- [ ] List completed tasks

### What will I work on today?
- [ ] List planned tasks

### Any blockers or issues?
- [ ] List impediments

---

## Communication Plan

### Weekly Updates (Fridays)
- **To:** Management / Stakeholders
- **Format:** Email summary
- **Content:**
  - Progress this week (% complete)
  - Deliverables completed
  - Blockers encountered
  - Plan for next week

### Completion Notifications
- **To:** Self / Team
- **Trigger:** Each workflow goes live
- **Content:** Platform name, user count, any issues

---

## Post-Phase 1 Next Steps

### Immediate (Week 5)
- [ ] Review Phase 1 outcomes
- [ ] Identify improvement opportunities
- [ ] Plan Phase 2 platforms (7 more)
- [ ] Refine timeline based on actual effort

### Phase 2 Preview (Weeks 5-8)
**Additional Platforms:**
1. Microsoft 365 (similar to Entra ID)
2. RocketCyber
3. Cisco Meraki
4. Zoho Desk
5. Zoho Projects
6. AWS (if applicable)
7. Azure (if applicable)

---

## Resources and References

### Documentation
- **Entra ID:** `/home/wferrel/ai/audits/microsoft_entra_id/API_RESEARCH.md`
- **Keeper:** `/home/wferrel/ai/audits/keeper_security/API_RESEARCH.md`
- **ConnectSecure:** `/home/wferrel/ai/audits/connectsecure/API_RESEARCH.md`
- **API Matrix:** `/home/wferrel/ai/audits/API_MATRIX.md`

### External Links
- **Microsoft Graph Explorer:** https://developer.microsoft.com/en-us/graph/graph-explorer
- **Keeper Docs:** https://docs.keeper.io/en/enterprise-guide/
- **ConnectSecure Swagger:** `/home/wferrel/ai/n8n-workflows/Connect_Secure/swagger.yaml`
- **n8n Documentation:** https://docs.n8n.io/

### Tools
- **n8n Instance:** https://n8n.midcloudcomputing.com/
- **Azure Portal:** https://portal.azure.com/
- **Keeper Console:** (URL TBD)
- **ConnectSecure:** https://pod107.myconnectsecure.com/

---

## Project Timeline Gantt Chart

```
Week 1 (Dec 18-24): Infrastructure Setup
|████████████████████| Infrastructure + Schema

Week 2 (Dec 25-31): Microsoft Entra ID
|████████████████████| Entra ID Integration

Week 3 (Jan 1-7): Keeper Security
|████████████████████| Keeper Integration

Week 4 (Jan 8-14): ConnectSecure + Review
|████████████████████| ConnectSecure + Reports
```

---

## Effort Tracking

| Task | Estimated | Actual | Notes |
|------|-----------|--------|-------|
| Infrastructure Setup | 8 hours | | |
| Entra ID Integration | 16 hours | | |
| Keeper Integration | 16 hours | | |
| ConnectSecure Integration | 12 hours | | |
| Reporting | 8 hours | | |
| **Total Phase 1** | **60 hours** | | |

---

*Last Updated: 2025-12-17*
*Project Owner: wferrel (all roles)*
*Status: Ready to Begin*
*Start Date: December 18, 2024*
*Target Completion: January 14, 2025*
