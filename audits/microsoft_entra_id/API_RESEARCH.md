# Microsoft Entra ID (Azure AD) - API Research for User Account Auditing

## Platform Overview

**Product:** Microsoft Entra ID (formerly Azure Active Directory)
**Type:** Identity and Access Management (IAM)
**Deployment:** Cloud SaaS
**MCC Usage:** SSO, MFA, conditional access, identity protection across Microsoft 365 and Azure

## API Overview

### General Information
- **API:** Microsoft Graph API
- **Version:** v1.0 (stable) and beta (preview features)
- **Base URL:** `https://graph.microsoft.com/v1.0/`
- **Protocol:** REST over HTTPS
- **Data Format:** JSON
- **Documentation:** https://learn.microsoft.com/en-us/graph/

### API Capabilities
- Comprehensive user management
- Directory role assignments
- Group memberships
- Sign-in activity and audit logs
- MFA status and authentication methods
- License assignments (via Microsoft 365 endpoints)
- Application assignments

## Authentication

### Method: OAuth 2.0

#### Application Registration Required
1. Register app in Azure Portal (Azure Active Directory > App registrations)
2. Generate Client ID and Client Secret
3. Grant API permissions (Microsoft Graph)
4. Admin consent for organization-wide access

#### Required Permissions (Application Permissions)
- `User.Read.All` - Read all users' full profiles
- `Directory.Read.All` - Read directory data
- `AuditLog.Read.All` - Read audit log data (requires Premium license)
- `RoleManagement.Read.Directory` - Read directory roles

#### Authentication Flow (Client Credentials)
```http
POST https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token
Content-Type: application/x-www-form-urlencoded

client_id={client_id}
&scope=https://graph.microsoft.com/.default
&client_secret={client_secret}
&grant_type=client_credentials
```

**Response:**
```json
{
  "token_type": "Bearer",
  "expires_in": 3599,
  "access_token": "<token>"
}
```

#### Token Usage
```http
GET https://graph.microsoft.com/v1.0/users
Authorization: Bearer <access_token>
```

### Token Management
- **Expiry:** 1 hour (3600 seconds)
- **Refresh:** Request new token before expiry (no refresh tokens for client credentials flow)
- **Storage:** Securely cache token, re-authenticate on 401 response

## User Management Endpoints

### List All Users
```http
GET /users
```

**Purpose:** Retrieve all users in the directory

**Response Schema:**
```json
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users",
  "@odata.nextLink": "https://graph.microsoft.com/v1.0/users?$skiptoken=X'1234'",
  "value": [
    {
      "id": "guid",
      "userPrincipalName": "user@domain.com",
      "displayName": "User Name",
      "givenName": "User",
      "surname": "Name",
      "mail": "user@domain.com",
      "accountEnabled": true,
      "createdDateTime": "2023-01-01T00:00:00Z",
      "userType": "Member",
      "jobTitle": "Title",
      "department": "Department",
      "officeLocation": "Office"
    }
  ]
}
```

**Query Parameters:**
- `$select` - Choose specific properties (e.g., `$select=id,displayName,mail`)
- `$filter` - Filter results (e.g., `$filter=accountEnabled eq true`)
- `$top` - Limit results (default: 100, max: 999)
- `$skiptoken` - Pagination token (from @odata.nextLink)
- `$orderby` - Sort results (e.g., `$orderby=displayName`)
- `$expand` - Expand related entities
- `$count` - Include count (requires `ConsistencyLevel: eventual` header)

**Example with Filters:**
```http
GET /users?$select=id,displayName,userPrincipalName,accountEnabled,createdDateTime&$top=999
```

### Get User Details
```http
GET /users/{id}
GET /users/{userPrincipalName}
```

**Purpose:** Get detailed information for a specific user

**Response:** Single user object with all properties

### Get User's Roles and Group Memberships
```http
GET /users/{id}/memberOf
```

**Purpose:** List all directory roles and groups the user belongs to

**Response:**
```json
{
  "value": [
    {
      "@odata.type": "#microsoft.graph.directoryRole",
      "id": "role-guid",
      "displayName": "Global Administrator",
      "description": "..."
    },
    {
      "@odata.type": "#microsoft.graph.group",
      "id": "group-guid",
      "displayName": "All Users",
      "mail": "allusers@domain.com"
    }
  ]
}
```

### Get Sign-In Activity
```http
GET /users/{id}/signInActivity
```

**Purpose:** Get last sign-in date and time

**Requirements:** Azure AD Premium P1 or P2

**Response:**
```json
{
  "lastSignInDateTime": "2023-12-15T10:30:00Z",
  "lastNonInteractiveSignInDateTime": "2023-12-15T11:00:00Z"
}
```

**Note:** This property is only returned if `$select=signInActivity` is used or if the individual user endpoint is queried.

### Get Authentication Methods (MFA Status)
```http
GET /users/{id}/authentication/methods
```

**Purpose:** List authentication methods configured for user (phone, email, FIDO2, etc.)

**Response:**
```json
{
  "value": [
    {
      "@odata.type": "#microsoft.graph.phoneAuthenticationMethod",
      "id": "method-id",
      "phoneNumber": "+1 555-0100",
      "phoneType": "mobile"
    },
    {
      "@odata.type": "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod",
      "id": "method-id",
      "displayName": "iPhone",
      "deviceTag": "iOS"
    }
  ]
}
```

**MFA Analysis:**
- Multiple authentication methods = MFA likely enabled
- Check for phoneAuthenticationMethod, microsoftAuthenticatorAuthenticationMethod, fido2AuthenticationMethod
- Single passwordAuthenticationMethod only = No MFA

## Audit Log Endpoints

### Sign-In Logs
```http
GET /auditLogs/signIns
```

**Purpose:** Retrieve sign-in events for audit and security analysis

**Requirements:** Azure AD Premium P1 or P2

**Query Parameters:**
- `$filter` - Filter by user, date, status (e.g., `$filter=userPrincipalName eq 'user@domain.com'`)
- `$top` - Limit results
- `$skiptoken` - Pagination

**Response Fields:**
- userPrincipalName
- signInDateTime
- ipAddress
- location
- deviceDetail
- appDisplayName
- status (success/failure)
- riskLevel

**Retention:** 30 days (default), 90+ days (Premium)

### Directory Audit Logs
```http
GET /auditLogs/directoryAudits
```

**Purpose:** Track changes to users, groups, applications, and directory

**Requirements:** Azure AD Premium P1 or P2

**Query Parameters:**
- `$filter` - Filter by activity, date, actor
- Example: `$filter=activityDateTime ge 2023-12-01 and activityDateTime le 2023-12-31`

**Response Fields:**
- activityDateTime
- activityDisplayName (e.g., "Add user", "Update user", "Add member to group")
- category
- result (success/failure)
- targetResources (affected objects)
- initiatedBy (who made the change)

**Retention:** 30 days (default), up to 1 year (Premium)

## Role Management Endpoints

### List Directory Roles
```http
GET /directoryRoles
```

**Purpose:** List all active directory roles

**Response:**
```json
{
  "value": [
    {
      "id": "role-guid",
      "displayName": "Global Administrator",
      "description": "Can manage all aspects of Azure AD and Microsoft services..."
    }
  ]
}
```

### Get Role Members
```http
GET /directoryRoles/{id}/members
```

**Purpose:** List users assigned to a specific directory role

**Response:** Array of user objects

### List All Role Assignments
No direct endpoint - must iterate through each role and get members, or use memberOf for each user.

## License Management

### Get User License Assignments
```http
GET /users/{id}/licenseDetails
```

**Purpose:** List licenses assigned to user

**Response:**
```json
{
  "value": [
    {
      "id": "license-guid",
      "skuId": "sku-guid",
      "skuPartNumber": "ENTERPRISEPACK",
      "servicePlans": [
        {
          "servicePlanId": "guid",
          "servicePlanName": "EXCHANGE_S_ENTERPRISE",
          "provisioningStatus": "Success"
        }
      ]
    }
  ]
}
```

### List Subscribed SKUs (Organization-wide)
```http
GET /subscribedSkus
```

**Purpose:** List all licenses available in the organization

**Response:**
```json
{
  "value": [
    {
      "id": "guid",
      "skuPartNumber": "ENTERPRISEPACK",
      "skuId": "guid",
      "prepaidUnits": {
        "enabled": 100,
        "suspended": 0,
        "warning": 0
      },
      "consumedUnits": 85
    }
  ]
}
```

## Pagination

### Microsoft Graph Pagination
Graph API uses OData pagination:

```javascript
let allUsers = [];
let nextLink = 'https://graph.microsoft.com/v1.0/users?$top=999';

while (nextLink) {
  const response = await fetch(nextLink, {
    headers: { 'Authorization': `Bearer ${token}` }
  });
  const data = await response.json();
  allUsers = allUsers.concat(data.value);
  nextLink = data['@odata.nextLink'] || null;
}
```

**Best Practices:**
- Use `$top=999` for maximum page size (default is 100)
- Always check for `@odata.nextLink` in response
- Handle pagination automatically

## Rate Limiting and Throttling

### Limits
Microsoft Graph applies throttling based on:
- Requests per second per app per tenant
- Concurrent requests
- CPU and memory usage

### Typical Limits
- **User endpoints:** ~2000 requests per second per app per tenant
- **Audit logs:** More restrictive, ~100 requests per minute

### Throttling Response
```http
HTTP/1.1 429 Too Many Requests
Retry-After: 30

{
  "error": {
    "code": "TooManyRequests",
    "message": "Rate limit exceeded"
  }
}
```

### Best Practices
- Implement exponential backoff
- Respect `Retry-After` header
- Use batching for multiple requests
- Cache data where appropriate

## Data Schema for Normalization

### Mapping to Common Schema

```javascript
// Microsoft Entra ID -> Common Schema
{
  "source_platform": "Microsoft Entra ID",
  "user_id": user.id,
  "username": user.userPrincipalName,
  "email": user.mail || user.userPrincipalName,
  "display_name": user.displayName,
  "first_name": user.givenName,
  "last_name": user.surname,
  "account_enabled": user.accountEnabled,
  "account_created": user.createdDateTime,
  "last_login": user.signInActivity?.lastSignInDateTime || null,
  "mfa_enabled": user.authMethods?.length > 1, // Derived from authentication methods
  "roles": user.memberOf?.filter(m => m['@odata.type'] === '#microsoft.graph.directoryRole')
                        .map(r => r.displayName) || [],
  "permissions": [], // Requires separate role definition lookup
  "licenses": user.licenseDetails?.map(l => l.skuPartNumber) || [],
  "tenant_id": "<tenant_id>",
  "last_audit_date": new Date().toISOString()
}
```

### Complete User Profile Request
To get all data in minimal requests:
```http
GET /users/{id}?$select=id,userPrincipalName,displayName,givenName,surname,mail,accountEnabled,createdDateTime,jobTitle,department&$expand=memberOf,licenseDetails
```

Then make separate call for authentication methods:
```http
GET /users/{id}/authentication/methods
```

And if Premium license:
```http
GET /users/{id}?$select=signInActivity
```

## Testing Checklist

- [ ] Register application in Azure AD
- [ ] Grant required API permissions
- [ ] Admin consent for permissions
- [ ] Test authentication flow and token retrieval
- [ ] Test /users endpoint with pagination
- [ ] Test /users/{id} for specific user
- [ ] Test /users/{id}/memberOf for roles
- [ ] Test /users/{id}/authentication/methods for MFA
- [ ] Test /users/{id}/licenseDetails for licenses
- [ ] Test sign-in activity (if Premium available)
- [ ] Verify audit log access (if Premium available)
- [ ] Test rate limiting and throttling handling
- [ ] Validate data normalization

## Manual Steps Required

### None for Basic User Data
Microsoft Graph API provides comprehensive coverage.

### Premium Features (May Require Manual Steps)
- **Sign-In Activity:** Requires Azure AD Premium P1/P2
  - **Manual Alternative:** Azure Portal > Sign-in logs
- **Audit Logs:** Requires Azure AD Premium P1/P2
  - **Manual Alternative:** Azure Portal > Audit logs
- **Risk Detection:** Requires Azure AD Premium P2
  - **Manual Alternative:** Azure Portal > Identity Protection

### License Verification
- Check if MCC customers have Premium licenses
- Document which features are available per customer
- Plan manual exports for customers without Premium

## n8n Implementation Notes

### Workflow Structure
```
1. [Schedule Trigger] - Daily/Weekly
   ↓
2. [Get Access Token]
   - HTTP Request to token endpoint
   - Store token in variable
   ↓
3. [Get All Users Loop]
   - HTTP Request to /users with pagination
   - Handle @odata.nextLink
   ↓
4. [Enrich User Data]
   - For each user:
     - Get memberOf (roles/groups)
     - Get authentication methods (MFA)
     - Get license details
   ↓
5. [Transform Data]
   - Normalize to common schema
   ↓
6. [Store Results]
   - n8n Data Table or external DB
   ↓
7. [Success Notification]
```

### n8n Nodes
- Schedule Trigger
- HTTP Request (OAuth2 configuration OR manual token management)
- Loop Over Items
- Code (for data transformation)
- Data Table OR Postgres/MySQL
- Error handling nodes

### Optimization Tips
- Use `$select` to reduce response size
- Use `$expand` to reduce number of requests
- Batch authentication method checks
- Cache token until near expiry
- Implement retry logic for throttling

## Security Considerations

### Least Privilege
- Use application permissions, not delegated
- Grant only required permissions (User.Read.All, Directory.Read.All)
- Avoid User.ReadWrite.All unless write operations needed

### Credential Storage
- Store client_id and client_secret securely
- Use Azure Key Vault or n8n encrypted credentials
- Never commit credentials to repository
- Rotate secrets periodically

### Data Handling
- User data is highly sensitive
- Implement data retention policies
- Consider GDPR/privacy requirements
- Encrypt data at rest and in transit

### Audit Trail
- Log all API calls
- Monitor for unusual access patterns
- Alert on failed authentication attempts

## Integration Opportunities

### Cross-Reference with Other Systems
- **Microsoft 365:** Same tenant, shared user base
- **Azure:** Same identity provider, RBAC integration
- **ConnectSecure:** Cross-reference AD users
- **Keeper Security:** SSO integration
- **Other SAML/SSO Apps:** Entra ID as IdP

### Unified Identity View
Entra ID can serve as the "source of truth" for identity:
- Compare against other platforms
- Identify orphaned accounts
- Detect inconsistencies
- Track SSO usage

## Dependencies

### Required for Implementation
- Azure AD tenant access
- Global Administrator or appropriate role for app registration
- Client ID and Client Secret
- Tenant ID
- n8n instance or scripting environment

### Optional but Recommended
- Azure AD Premium P1/P2 for full audit capabilities
- Dedicated service account for automation
- Monitoring and alerting system

## Reference Links

- **Microsoft Graph API Documentation:** https://learn.microsoft.com/en-us/graph/
- **User API Reference:** https://learn.microsoft.com/en-us/graph/api/user-list
- **Authentication Methods:** https://learn.microsoft.com/en-us/graph/api/authentication-list-methods
- **Audit Logs:** https://learn.microsoft.com/en-us/graph/api/directoryaudit-list
- **Sign-In Logs:** https://learn.microsoft.com/en-us/graph/api/signin-list
- **Graph Explorer (Testing Tool):** https://developer.microsoft.com/en-us/graph/graph-explorer

## Next Steps

1. **Register application** in MCC's Azure AD tenant(s)
2. **Document tenant IDs** for each customer
3. **Verify Premium license** availability per tenant
4. **Create ENDPOINTS.md** with detailed API specifications
5. **Create DATA_SCHEMA.md** with complete field mappings
6. **Develop n8n workflow** for user audit
7. **Create test script** for authentication and data retrieval

---

*Last Updated: 2025-12-17*
*Status: API Research Complete*
*Priority: Phase 1 - High Priority*
