# n8n Workflow Templates
## Reference Architectures for User Audit System

---

## Template 1: Microsoft Entra ID - User Audit

### Workflow Overview
**Name:** `EntraID - User Audit`
**Schedule:** Daily at 2:00 AM
**Duration:** ~5-10 minutes
**Purpose:** Collect all users from Microsoft Entra ID with roles, MFA status, and licenses

### Node Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    EntraID - User Audit                      │
└─────────────────────────────────────────────────────────────┘

1. [Schedule Trigger]
   - Type: Cron
   - Expression: 0 2 * * * (2:00 AM daily)
   ↓
2. [Get Access Token] (HTTP Request)
   - Method: POST
   - URL: https://login.microsoftonline.com/{{$env.ENTRA_TENANT_ID}}/oauth2/v2.0/token
   - Body: client_credentials grant
   - Output: access_token, expires_in
   ↓
3. [Get All Users] (HTTP Request)
   - Method: GET
   - URL: https://graph.microsoft.com/v1.0/users?$select=...&$top=999
   - Headers: Authorization Bearer {{token}}
   - Handle Pagination: Loop on @odata.nextLink
   ↓
4. [Split In Batches] (10 users per batch)
   - Batch Size: 10
   - Purpose: Avoid rate limits on enrichment calls
   ↓
5. [Get User Details] (Parallel enrichment)
   ├─→ [Get MemberOf] (HTTP Request)
   │   - URL: /users/{{id}}/memberOf
   │   - Returns: Groups and Roles
   │
   ├─→ [Get Auth Methods] (HTTP Request)
   │   - URL: /users/{{id}}/authentication/methods
   │   - Returns: MFA methods
   │
   └─→ [Get Licenses] (HTTP Request)
       - URL: /users/{{id}}/licenseDetails
       - Returns: Assigned licenses
   ↓
6. [Merge Enriched Data] (Code Node)
   - Combine user + memberOf + authMethods + licenses
   - JavaScript function to merge all data
   ↓
7. [Transform to Common Schema] (Code Node)
   - Map Entra ID fields to common schema
   - Convert arrays to JSON strings
   - Set source_platform = 'Microsoft Entra ID'
   - Add last_audit_date, tenant_id
   ↓
8. [Store in Data Table] (Data Table Node)
   - Operation: Upsert
   - Table: UserAudit_Master
   - Matching: user_id (or composite key)
   ↓
9. [Success Notification] (Email/Slack)
   - Subject: "✅ Entra ID Audit Complete"
   - Body: "{{$json.count}} users collected"

[Error Trigger] → [Error Notification] (Email/Slack)
   - Subject: "❌ Entra ID Audit Failed"
   - Body: Error details
```

### Key Code Snippets

#### Node 2: Get Access Token
```javascript
// HTTP Request Configuration
Method: POST
URL: https://login.microsoftonline.com/{{$env.ENTRA_TENANT_ID}}/oauth2/v2.0/token

Body (Form URL Encoded):
{
  "client_id": "{{$env.ENTRA_CLIENT_ID}}",
  "client_secret": "{{$env.ENTRA_CLIENT_SECRET}}",
  "scope": "https://graph.microsoft.com/.default",
  "grant_type": "client_credentials"
}
```

#### Node 7: Transform to Common Schema
```javascript
// Code Node - Transform Data
const items = $input.all();

return items.map(item => {
  const user = item.json;

  // Extract roles from memberOf
  const roles = (user.memberOf || [])
    .filter(m => m['@odata.type'] === '#microsoft.graph.directoryRole')
    .map(r => r.displayName);

  // Check MFA
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
      permissions: JSON.stringify([]),
      licenses: JSON.stringify(licenses),
      tenant_id: $env.TENANT_ID || 'mcc-tenant-001',
      last_audit_date: new Date().toISOString(),
      collection_method: 'api',
      raw_data: JSON.stringify(user)
    }
  };
});
```

---

## Template 2: Keeper Security - User Audit

### Workflow Overview
**Name:** `Keeper - User Audit`
**Schedule:** Daily at 2:30 AM (offset from Entra)
**Duration:** ~3-5 minutes
**Purpose:** Collect all users from Keeper Security with RBAC roles

### Node Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   Keeper - User Audit                        │
└─────────────────────────────────────────────────────────────┘

1. [Schedule Trigger]
   - Type: Cron
   - Expression: 30 2 * * * (2:30 AM daily)
   ↓
2. [Authenticate to Keeper] (HTTP Request)
   - Method: POST (or per Keeper API docs)
   - URL: Keeper auth endpoint
   - Headers: API-Key or Bearer token
   - Output: session_token
   ↓
3. [Get All Users] (HTTP Request)
   - Method: GET
   - URL: Keeper users endpoint
   - Headers: Authorization
   - Handle Pagination: If applicable
   ↓
4. [Get User Roles] (HTTP Request - Optional if not in user list)
   - URL: Keeper roles endpoint
   - Returns: RBAC roles and permissions per user
   ↓
5. [Merge User and Role Data] (Code Node)
   - Combine user data with role information
   ↓
6. [Transform to Common Schema] (Code Node)
   - Map Keeper fields to common schema
   - Set source_platform = 'Keeper Security'
   ↓
7. [Store in Data Table] (Data Table Node)
   - Operation: Upsert
   - Table: UserAudit_Master
   - Matching: user_id
   ↓
8. [Success Notification] (Email/Slack)
   - Subject: "✅ Keeper Audit Complete"

[Error Trigger] → [Error Notification]
```

### Key Code Snippet

#### Node 6: Transform to Common Schema
```javascript
const items = $input.all();

return items.map(item => {
  const user = item.json;

  return {
    json: {
      source_platform: 'Keeper Security',
      user_id: user.id || user.user_id,
      username: user.username || user.email,
      email: user.email,
      display_name: user.full_name || user.username,
      first_name: user.first_name || null,
      last_name: user.last_name || null,
      account_enabled: user.status === 'active',
      account_created: user.created_date || null,
      last_login: user.last_login || null,
      mfa_enabled: user.mfa_enabled || null,
      roles: JSON.stringify(user.roles || []),
      permissions: JSON.stringify(user.permissions || []),
      licenses: JSON.stringify([]),
      tenant_id: $env.TENANT_ID || 'mcc-tenant-001',
      last_audit_date: new Date().toISOString(),
      collection_method: 'api',
      raw_data: JSON.stringify(user)
    }
  };
});
```

---

## Template 3: ConnectSecure - User Audit

### Workflow Overview
**Name:** `ConnectSecure - User Audit`
**Schedule:** Daily at 3:30 AM
**Duration:** ~5-10 minutes (depends on tenant count)
**Purpose:** Collect users from ConnectSecure, support multi-tenant

### Node Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                ConnectSecure - User Audit                    │
└─────────────────────────────────────────────────────────────┘

1. [Schedule Trigger]
   - Type: Cron
   - Expression: 30 3 * * * (3:30 AM daily)
   ↓
2. [Load Credentials] (Code Node)
   - Load: tenant, client_id, client_secret
   - Encode to Base64: tenant+client_id:client_secret
   ↓
3. [Authenticate] (HTTP Request)
   - Method: POST
   - URL: https://pod107.myconnectsecure.com/w/authorize
   - Headers: Client-Auth-Token: {{base64_creds}}
   - Output: access_token, user_id
   ↓
4. [Get Users with Pagination] (Code Node + HTTP Loop)
   - URL: /r/user/get_users?skip=0&limit=100
   - Loop: Increment skip by 100 until batch < 100
   - Headers: Authorization Bearer, X-USER-ID
   ↓
5. [Transform to Common Schema] (Code Node)
   - Map ConnectSecure fields
   - Set source_platform = 'ConnectSecure'
   - Include tenant_id for customer tracking
   ↓
6. [Store in Data Table] (Data Table Node)
   - Operation: Upsert
   - Table: UserAudit_Master
   - Matching: user_id
   ↓
7. [Success Notification] (Email/Slack)

[Error Trigger] → [Error Notification]
```

### Key Code Snippets

#### Node 2: Load and Encode Credentials
```javascript
// Code Node - Encode Credentials
const tenant = $env.CS_TENANT;
const clientId = $env.CS_CLIENT_ID;
const clientSecret = $env.CS_CLIENT_SECRET;

const credentials = `${tenant}+${clientId}:${clientSecret}`;
const encoded = Buffer.from(credentials).toString('base64');

return [{
  json: {
    base64_credentials: encoded,
    tenant: tenant
  }
}];
```

#### Node 4: Pagination Logic
```javascript
// Code Node - Get All Users with Pagination
const token = $node["Authenticate"].json.access_token;
const userId = $node["Authenticate"].json.user_id;
const baseUrl = 'https://pod107.myconnectsecure.com';

let allUsers = [];
let skip = 0;
const limit = 100;

while (true) {
  const url = `${baseUrl}/r/user/get_users?skip=${skip}&limit=${limit}`;

  const response = await $http.request({
    method: 'GET',
    url: url,
    headers: {
      'Authorization': `Bearer ${token}`,
      'X-USER-ID': userId
    }
  });

  const users = response.data;
  allUsers = allUsers.concat(users);

  if (users.length < limit) {
    break; // No more pages
  }

  skip += limit;
}

return allUsers.map(user => ({ json: user }));
```

#### Node 5: Transform to Common Schema
```javascript
const items = $input.all();
const tenantId = $node["Load Credentials"].json.tenant;

return items.map(item => {
  const user = item.json;

  return {
    json: {
      source_platform: 'ConnectSecure',
      user_id: user.id,
      username: user.user_name,
      email: user.email,
      display_name: `${user.first_name} ${user.last_name}`.trim(),
      first_name: user.first_name,
      last_name: user.last_name,
      account_enabled: user.state === 'active',
      account_created: user.created_date || null,
      last_login: user.last_login || null,
      mfa_enabled: null, // Check if available in API
      roles: JSON.stringify(user.roles || []),
      permissions: JSON.stringify([]),
      licenses: JSON.stringify([]),
      tenant_id: tenantId,
      last_audit_date: new Date().toISOString(),
      collection_method: 'api',
      raw_data: JSON.stringify(user)
    }
  };
});
```

---

## Template 4: Basic Report - User Count by Platform

### Workflow Overview
**Name:** `Report - User Counts`
**Trigger:** Manual or Weekly
**Purpose:** Generate summary of users by platform

### Node Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                  Report - User Counts                        │
└─────────────────────────────────────────────────────────────┘

1. [Manual Trigger or Schedule]
   ↓
2. [Get All Users] (Data Table Node)
   - Operation: Get All
   - Table: UserAudit_Master
   ↓
3. [Group by Platform] (Code Node)
   - Aggregate: COUNT(*) GROUP BY source_platform
   - Calculate: enabled vs disabled
   ↓
4. [Format Report] (Code Node)
   - Create table format
   - Add totals
   ↓
5. [Send Report] (Email/Slack)
   - Subject: "📊 User Audit Report"
   - Body: Formatted table
```

### Key Code Snippet

#### Node 3: Group and Aggregate
```javascript
const items = $input.all();

// Group by platform
const grouped = {};
items.forEach(item => {
  const platform = item.json.source_platform;
  if (!grouped[platform]) {
    grouped[platform] = {
      total: 0,
      enabled: 0,
      disabled: 0,
      mfa_enabled: 0,
      mfa_disabled: 0
    };
  }

  grouped[platform].total++;
  if (item.json.account_enabled) {
    grouped[platform].enabled++;
  } else {
    grouped[platform].disabled++;
  }

  if (item.json.mfa_enabled === true) {
    grouped[platform].mfa_enabled++;
  } else if (item.json.mfa_enabled === false) {
    grouped[platform].mfa_disabled++;
  }
});

// Convert to array for output
const results = Object.keys(grouped).map(platform => ({
  json: {
    platform: platform,
    ...grouped[platform]
  }
}));

return results;
```

#### Node 4: Format Report
```javascript
const items = $input.all();

let report = `📊 User Account Audit Report\n`;
report += `Generated: ${new Date().toLocaleString()}\n\n`;
report += `─────────────────────────────────────────────────\n`;
report += `Platform               Total  Enabled  MFA On\n`;
report += `─────────────────────────────────────────────────\n`;

let grandTotal = 0;
let grandEnabled = 0;
let grandMFA = 0;

items.forEach(item => {
  const d = item.json;
  report += `${d.platform.padEnd(20)} ${String(d.total).padStart(5)}  ${String(d.enabled).padStart(7)}  ${String(d.mfa_enabled).padStart(6)}\n`;

  grandTotal += d.total;
  grandEnabled += d.enabled;
  grandMFA += d.mfa_enabled;
});

report += `─────────────────────────────────────────────────\n`;
report += `TOTAL                  ${String(grandTotal).padStart(5)}  ${String(grandEnabled).padStart(7)}  ${String(grandMFA).padStart(6)}\n`;
report += `─────────────────────────────────────────────────\n`;

return [{
  json: {
    report: report,
    grand_total: grandTotal,
    grand_enabled: grandEnabled,
    grand_mfa: grandMFA
  }
}];
```

---

## Template 5: Export All Users to CSV

### Workflow Overview
**Name:** `Report - Export Users CSV`
**Trigger:** Manual or Weekly
**Purpose:** Export complete user list to CSV

### Node Architecture

```
1. [Manual Trigger]
   ↓
2. [Get All Users] (Data Table)
   ↓
3. [Transform for CSV] (Code Node)
   - Parse JSON strings (roles, licenses)
   - Format dates
   ↓
4. [Convert to CSV] (n8n CSV Node OR Code Node)
   ↓
5. [Send via Email] (Email Node with attachment)
   OR
   [Save to File] (Write Binary File)
```

---

## Common Patterns and Best Practices

### Pattern 1: Error Handling
**Every workflow should have:**
```
[Main Flow]
   ↓
[Success] → [Success Notification]

[Error Trigger]
   ↓
[Error Notification with Details]
   - Include: workflow name, error message, timestamp
   - Send to: Admin email or Slack channel
```

### Pattern 2: Pagination Handling
**For any API that paginates:**
```javascript
let allItems = [];
let nextLink = initialUrl;

while (nextLink) {
  const response = await $http.request(nextLink);
  allItems = allItems.concat(response.data);
  nextLink = response.nextLink || null; // Adjust field name
}

return allItems.map(item => ({ json: item }));
```

### Pattern 3: Rate Limit Handling
**Add delays between batches:**
```javascript
// In Split in Batches node
Batch Size: 10

// Between batches, add Wait node:
Wait Time: 1 second
```

### Pattern 4: Credential Management
**Store credentials as n8n credentials or environment variables:**
```javascript
// Reference in Code nodes:
const clientId = $env.ENTRA_CLIENT_ID;
const clientSecret = $env.ENTRA_CLIENT_SECRET;

// Or use n8n credential system:
// Configure in node settings instead of hardcoding
```

### Pattern 5: Logging for Debugging
**Add logging nodes during development:**
```javascript
// In Code node:
console.log('Processing user:', user.id);
console.log('Roles found:', roles.length);

// Or add a "Log to Table" node that stores execution logs
```

---

## Testing Workflows

### Test Mode
**Always test with small data first:**

1. **Limit Test Data:**
   ```javascript
   // In Get Users node, add $top parameter
   URL: ...users?$top=5  // Only 5 users for testing
   ```

2. **Disable Schedule:**
   - Start with Manual Trigger
   - Add Schedule Trigger only after testing

3. **Check Each Node:**
   - Execute each node individually
   - Verify output before moving to next
   - Use "View Results" to inspect data

### Debugging Tips

**Issue: Workflow fails with no clear error**
```
Solution: Add Code nodes between steps to log data:
console.log('Data at this point:', JSON.stringify($input.all()));
```

**Issue: Data not appearing in table**
```
Solution:
1. Check Data Table node configuration
2. Verify column names match exactly
3. Check for required fields
4. Try Insert instead of Upsert first
```

**Issue: API authentication fails**
```
Solution:
1. Test auth endpoint manually (Postman/curl)
2. Verify credentials are correct
3. Check token expiry
4. Verify URL is correct (no typos)
```

---

## Environment Variables Setup

### Create these in n8n Settings:

```bash
# Microsoft Entra ID
ENTRA_TENANT_ID=your-tenant-id
ENTRA_CLIENT_ID=your-client-id
ENTRA_CLIENT_SECRET=your-client-secret

# Keeper Security
KEEPER_API_KEY=your-api-key
KEEPER_API_SECRET=your-api-secret

# ConnectSecure
CS_TENANT=your-tenant-name
CS_CLIENT_ID=your-client-id
CS_CLIENT_SECRET=your-client-secret

# General
TENANT_ID=mcc-tenant-001
NOTIFICATION_EMAIL=admin@midcloudcomputing.com
NOTIFICATION_SLACK_WEBHOOK=https://hooks.slack.com/...
```

---

## Workflow Naming Convention

```
[Platform] - [Action]

Examples:
- EntraID - User Audit
- Keeper - User Audit
- ConnectSecure - User Audit
- Report - User Counts
- Report - Export Users CSV
- Report - MFA Status
- Maintenance - Cleanup Old Records
```

---

## Next Steps

1. ✅ Review these templates
2. ✅ Set up environment variables in n8n
3. ✅ Start with Template 1 (Entra ID) in Week 2
4. ✅ Test each node individually before full workflow
5. ✅ Add error handling and notifications
6. ✅ Schedule after successful testing

---

*Last Updated: 2025-12-17*
*Templates Version: 1.0*
*Compatible with: n8n 1.x*
