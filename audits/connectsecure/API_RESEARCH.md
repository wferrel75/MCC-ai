# ConnectSecure (CyberCNS) - API Research for User Account Auditing

## Platform Overview

**Product:** ConnectSecure (formerly CyberCNS)
**Type:** Vulnerability & Compliance Management Platform
**Deployment:** Multi-tenant SaaS
**MCC Usage:** Security assessments, compliance tracking, MSP client management

## API Overview

### General Information
- **API Type:** REST API
- **Specification:** OpenAPI 3.0
- **Base URL:** `https://pod107.myconnectsecure.com/` (tenant-specific pods)
- **Documentation:** Local swagger.yaml at `/home/wferrel/ai/n8n-workflows/Connect_Secure/swagger.yaml`
- **Total Endpoints:** 226+
- **API Lines:** 32,566 lines

### API Architecture
ConnectSecure API follows a path convention:
- `/w/` prefix = Write/Create operations
- `/r/` prefix = Read/Retrieve operations
- `/d/` prefix = Delete operations

## Authentication

### Method
Bearer Token authentication with two-step process:

#### Step 1: Authorize
```
POST /w/authorize
Header: Client-Auth-Token: <base64_encoded_credentials>
```

**Credential Format:**
```
tenant+client_id:client_secret
```

**Base64 Encoding Example:**
```bash
echo -n "tenant_name+client_12345:secret_abcdef" | base64
```

#### Step 2: Use Bearer Token
```
GET /r/user/get_users
Header: Authorization: Bearer <access_token>
Header: X-USER-ID: <user_id_from_auth>
```

### Required Headers
- `Client-Auth-Token` (for /w/authorize only)
- `Authorization: Bearer <token>` (for all authenticated requests)
- `X-USER-ID` (for all authenticated requests)
- `Content-Type: application/json` (for POST/PUT requests)

### Token Lifespan
- Variable (check token response for expiry)
- Refresh strategy: Re-authenticate when token expires

## User Management Endpoints

### Primary User Endpoint

#### GET /r/user/get_users
**Purpose:** Retrieve all users in the ConnectSecure tenant

**Request:**
```http
GET /r/user/get_users?skip=0&limit=100&order_by=created_date HTTP/1.1
Host: pod107.myconnectsecure.com
Authorization: Bearer <access_token>
X-USER-ID: <user_id>
```

**Query Parameters:**
- `condition` (string, optional) - Filter condition query
- `skip` (integer, optional) - Pagination offset (default: 0)
- `limit` (integer, optional) - Results per page (default: 100, recommend testing max)
- `order_by` (string, optional) - Sort field (e.g., "created_date", "email")

**Response Schema:**
```json
{
  "status": true,
  "data": [
    {
      "id": "string",
      "user_name": "string",
      "email": "string",
      "first_name": "string",
      "last_name": "string",
      "phone": "string",
      "roles": ["string"],
      "state": "string",
      "last_login": "string",
      "created_date": "datetime",
      "included": "string",
      "excluded": "string"
    }
  ]
}
```

**Key Fields for Auditing:**
- `id` - Unique user identifier
- `user_name` - Username
- `email` - Email address
- `first_name` + `last_name` - Full name
- `roles` - Array of assigned roles
- `state` - Account state (active, inactive, etc.)
- `last_login` - Last login timestamp
- `created_date` - Account creation date

### Related User Endpoints

#### GET /r/user/get_user_details
**Purpose:** Get detailed information for a specific user

**Line Number:** ~28960 in swagger.yaml

**Use Case:** Get additional user details not included in list endpoint

---

#### GET /r/ad_users_view
**Purpose:** Retrieve Active Directory user information

**Line Number:** ~27931 in swagger.yaml

**Use Case:** Audit AD-synchronized users, cross-reference with directory

---

#### GET /r/ad_user_licenses
**Purpose:** Retrieve Active Directory user license assignments

**Line Number:** ~26743 in swagger.yaml

**Use Case:** Track license assignments for cost optimization

---

#### GET /r/ad_group_users
**Purpose:** Retrieve users within AD groups

**Line Number:** ~28596 in swagger.yaml

**Use Case:** Group membership auditing

---

#### GET /report_queries/user_event_stats
**Purpose:** User event statistics

**Line Number:** ~30044 in swagger.yaml

**Use Case:** Activity monitoring and usage analytics

---

#### GET /report_queries/user_locked_stats
**Purpose:** Locked user account statistics

**Line Number:** ~30108 in swagger.yaml

**Use Case:** Security auditing - locked accounts

---

#### GET /report_queries/user_enabled_stats
**Purpose:** Enabled user statistics

**Line Number:** ~30169 in swagger.yaml

**Use Case:** Active user counts and trends

## Multi-Tenant Considerations

### Tenant Context
- ConnectSecure is multi-tenant
- Authentication includes tenant identifier in credentials
- Each tenant has isolated user base
- MSP portal allows management of multiple tenants

### MSP Portal
- MSSP Portal feature for managing multiple MSPs
- Multi-tenant dashboard manager
- Separate API keys per tenant
- Data segregation between tenants

### Implementation Note
For MCC use case:
- Iterate through each client/tenant
- Authenticate per tenant
- Collect user data per tenant
- Tag data with tenant/customer identifier

## Role-Based Access Control

### User Roles
ConnectSecure supports role-based access with configurable permissions:

- **Company Level Access** - Roles can be assigned at company level
- **Custom Roles** - Role configuration available in Global > Settings > Users
- **API Key Generation** - Per-user API keys with role-based permissions

### Permission Model
- Three-dot action menu per user (Edit, Reset MFA, Delete, API Key)
- Admin accounts can manage API keys
- Role determines Company Level Access

## Data Schema for Normalization

### Mapping to Common Schema

```javascript
// ConnectSecure -> Common Schema Mapping
{
  "source_platform": "ConnectSecure",
  "user_id": data.id,
  "username": data.user_name,
  "email": data.email,
  "display_name": `${data.first_name} ${data.last_name}`,
  "first_name": data.first_name,
  "last_name": data.last_name,
  "account_enabled": data.state === "active", // verify state values
  "account_created": data.created_date,
  "last_login": data.last_login,
  "mfa_enabled": null, // Not in current endpoint, check /r/user/get_user_details
  "roles": data.roles,
  "permissions": [], // Extract from roles if role definitions available
  "licenses": [], // From /r/ad_user_licenses if applicable
  "tenant_id": "<customer_tenant_id>", // From config/context
  "last_audit_date": new Date().toISOString()
}
```

## Pagination Strategy

### Recommended Approach
```
1. Start with skip=0, limit=100
2. Retrieve batch of users
3. Check if data.length === limit
4. If yes, increment skip by limit and repeat
5. If no, all users retrieved
6. Consider total_count if available in response
```

### Pseudo-code
```javascript
let allUsers = [];
let skip = 0;
const limit = 100;
let hasMore = true;

while (hasMore) {
  const response = await fetch(`/r/user/get_users?skip=${skip}&limit=${limit}`);
  const batch = response.data;
  allUsers = allUsers.concat(batch);

  if (batch.length < limit) {
    hasMore = false;
  } else {
    skip += limit;
  }
}
```

## Rate Limiting

### Status: Unknown
- Documentation does not specify rate limits
- Recommend implementing:
  - Delays between requests (100-500ms)
  - Exponential backoff on errors
  - Request monitoring and logging

### Error Handling
- HTTP 401: Token expired, re-authenticate
- HTTP 403: Insufficient permissions
- HTTP 429: Rate limit (if implemented)
- HTTP 500: Server error, retry with backoff

## n8n Implementation Notes

### Existing Workflow Reference
MCC already has n8n workflows for ConnectSecure:
- **ConnectSecure New Company** (ID: 6dZa9lPkps3OtXyB)
- **ConnectSecure Sync Companies** (ID: LFPxadxdOeH9UGNY)

These can be used as templates for authentication and API patterns.

### Workflow Structure for User Audit
```
1. [Manual Trigger / Schedule Trigger]
   ↓
2. [Load Credentials] - Environment variables
   ↓
3. [Encode Credentials] - Base64 encoding
   ↓
4. [Authenticate] - POST /w/authorize
   ↓
5. [Get Users Loop]
   - GET /r/user/get_users (paginated)
   ↓
6. [Transform Data] - Normalize to common schema
   ↓
7. [Store Results] - n8n Data Table or external DB
   ↓
8. [Success Notification]
```

### n8n Nodes Required
- HTTP Request (for API calls)
- Code (for credential encoding and data transformation)
- Loop/Split in Batches (for pagination)
- Data Table (for storage) OR Postgres/MySQL
- Schedule Trigger (for automated runs)

## Testing Checklist

- [ ] Verify credentials and authentication flow
- [ ] Test /r/user/get_users with small limit
- [ ] Verify pagination works correctly
- [ ] Check all fields populate correctly
- [ ] Test with multiple tenants (if applicable)
- [ ] Validate data normalization
- [ ] Test error handling (invalid token, network error)
- [ ] Verify rate limiting behavior
- [ ] Test AD user endpoints (if AD integration exists)
- [ ] Document any missing fields or gaps

## Manual Steps Required

### None Expected
ConnectSecure has comprehensive API coverage for user management.

### Potential Gaps
- **MFA Status:** Not confirmed in /r/user/get_users response
  - Check /r/user/get_user_details endpoint
  - May require separate endpoint or manual verification
- **Role Definitions:** Role permissions may not be detailed
  - May need separate endpoint to map roles to permissions
- **License Information:** Requires /r/ad_user_licenses endpoint

## Security Considerations

### Credential Storage
- Store tenant, client_id, client_secret securely
- Use environment variables or encrypted secrets in n8n
- Never commit credentials to repository

### API Key Management
- Rotate API keys periodically
- Use service accounts, not personal user accounts
- Document which API keys are used for automation

### Data Handling
- User data is sensitive - handle per privacy policies
- Implement data retention policies
- Consider GDPR/privacy implications for storage

## Integration with Other Systems

### Potential Correlations
- **Microsoft Entra ID:** Cross-reference AD users via /r/ad_users_view
- **Customer Profiles:** Link tenant_id to MCC customer records
- **Ticketing:** Create tickets for access anomalies
- **Reporting:** Aggregate with other platforms for unified view

## Dependencies

### Required for Implementation
- ConnectSecure tenant credentials (per customer)
- n8n instance configured
- Target database or data table for storage

### Optional Enhancements
- Customer mapping database
- Alert/notification system
- Dashboard for visualization

## Reference Links

- **Local Swagger Spec:** `/home/wferrel/ai/n8n-workflows/Connect_Secure/swagger.yaml`
- **ConnectSecure Documentation:** https://cybercns.atlassian.net/wiki/spaces/CVB/
- **n8n Workflow:** `/home/wferrel/ai/n8n-workflows/` (existing workflows)
- **MCC n8n Instance:** https://n8n.midcloudcomputing.com/

## Next Steps

1. **Create ENDPOINTS.md** with detailed endpoint specifications
2. **Create DATA_SCHEMA.md** with field mappings
3. **Develop n8n workflow JSON** for user audit
4. **Create test script** for authentication and data retrieval
5. **Document tenant/customer mapping** process

---

*Last Updated: 2025-12-17*
*Status: API Research Complete*
