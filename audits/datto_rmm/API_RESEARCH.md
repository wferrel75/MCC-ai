# Datto RMM - API Research for User Account Auditing

## Platform Overview

**Product:** Datto RMM (Remote Monitoring and Management)
**Type:** Remote Monitoring & Management Platform
**Deployment:** Cloud SaaS
**MCC Usage:** Endpoint monitoring, patch management, remote access, automation

## API Overview

### General Information
- **API Version:** v2 (current)
- **API Type:** REST API
- **Protocol:** HTTPS
- **Authentication:** OAuth 2.0
- **Base URL:** `https://rmm.datto.com/api/v2/`
- **Documentation:** https://rmm.datto.com/help/en/Content/2SETUP/APIv2.htm
- **API Explorer:** Swagger UI available

### API Status for User Management
⚠️ **Partial API Support**

**Issue:** While Datto RMM has a comprehensive v2 API, user account management endpoints are not clearly documented in public documentation. The API appears focused on device/asset management rather than user/administrator management.

## Authentication

### OAuth 2.0 Flow
Datto RMM API v2 implements OAuth 2.0 as the industry-standard protocol for authorization.

#### API Key Generation
1. Enable API access in Datto RMM portal
2. API keys generated on a user-by-user basis
3. Navigate to user settings
4. Click "Generate API Keys"
5. Receive API Key and API Secret Key

#### Authentication Method
- **API Key:** Public identifier
- **API Secret Key:** Private secret
- **Grant Type:** client_credentials (assumed)

#### Token Request (Format TBD)
```http
POST /oauth/token (endpoint TBD)
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id={api_key}
&client_secret={api_secret_key}
```

**Note:** Exact token endpoint requires verification from Datto documentation or support.

### Token Usage
```http
GET /api/v2/endpoint
Authorization: Bearer <access_token>
```

## Known Endpoints

### Device/Asset Auditing
```http
GET /v2/audit/device/macAddress/{macAddress}
```

**Purpose:** Fetch audit data of generic devices identified by MAC address

**Response:** Device audit information

**Note:** This endpoint is documented, but user-specific endpoints are not.

### Potential User-Related Endpoints (Unconfirmed)
Based on typical RMM API patterns, possible endpoints might include:
- `/v2/users` or `/v2/account/users`
- `/v2/account/admins`
- `/v2/account/technicians`
- `/v2/account/api-keys`

**Status:** ⚠️ Requires verification via Swagger UI or Datto support

## Documented Features

### What IS Available
1. **Device Auditing** - Hardware/software inventory
2. **Alert Management** - Monitoring and alerting
3. **Patch Management** - Software update tracking
4. **Remote Access** - Session management
5. **Automation** - Component and job management

### What MIGHT Be Available
- User list (technicians/admins)
- API key management
- User permissions and roles
- Activity logs

### What Requires Confirmation
- Specific user management endpoint paths
- Response schemas for user data
- Role and permission structures
- Last login tracking
- MFA status

## Research Required

### Investigation Steps

#### 1. Access Swagger UI Documentation
```
URL: https://rmm.datto.com/help/en/Content/API/SwaggerUI.htm (if available)
Or: Within Datto RMM portal under Settings > API
```

**Action Items:**
- [ ] Log into Datto RMM portal
- [ ] Navigate to API documentation section
- [ ] Explore Swagger UI for user-related endpoints
- [ ] Document all available endpoints
- [ ] Test endpoints with API credentials

#### 2. Review Datto RMM Integrations Whitepaper
**Document:** "Datto RMM Integrations Whitepaper for Third Parties February 2025 · Build 12"
**URL:** https://rmm.datto.com/help/Integrations/DattoRMMIntegrationsWhitepaper.pdf

**Action Items:**
- [ ] Download and review whitepaper
- [ ] Look for user management API references
- [ ] Check for authentication flow details
- [ ] Document any partner API capabilities

#### 3. Contact Datto Support
If API documentation doesn't reveal user management endpoints:

**Questions for Datto Support:**
1. Does the Datto RMM API v2 expose user/administrator management endpoints?
2. What are the endpoint paths for:
   - Listing all users/technicians
   - Getting user details
   - Retrieving user roles and permissions
   - Accessing user activity logs
3. Is there API access to audit logs for user actions?
4. What permissions are required for user management API calls?
5. Are there rate limits specific to user queries?

#### 4. Test with Existing Credentials
MCC likely has Datto RMM API credentials:
- Check PowerShell scripts in `/powershell/DattoRMM-API/`
- Review any existing Datto integrations
- Test authentication and explore available endpoints

## Workarounds (if API Not Available)

### Alternative 1: Web Portal Manual Export
**If API doesn't provide user management:**
1. Log into Datto RMM web portal
2. Navigate to Account Settings > Users
3. Export user list (if available)
4. Parse CSV/Excel for auditing

**Limitations:**
- Manual process, not automatable
- Export frequency limited by manual effort
- May not include all desired fields

### Alternative 2: Activity Log Export
**If user list not available but activity logs are:**
1. Export activity/audit logs via portal
2. Parse logs to extract user activity
3. Infer active users from recent activity
4. Limited to users who have logged in during log retention period

### Alternative 3: Datto RMM Database Query
**If direct database access is possible (unlikely for SaaS):**
- Contact Datto about database exports
- MSP-specific reporting options
- Dedicated reporting API

### Alternative 4: Screen Scraping (Last Resort)
**Not recommended but possible:**
- Automate browser interaction with Selenium/Puppeteer
- Log into portal programmatically
- Extract user data from web pages
- Fragile and violates ToS in many cases

## Data Schema (Hypothetical)

### Expected User Data Fields
If API becomes available, expected response might include:

```json
{
  "users": [
    {
      "id": "user-id",
      "username": "technician@mcc.com",
      "email": "technician@mcc.com",
      "first_name": "John",
      "last_name": "Doe",
      "role": "Administrator",
      "permissions": ["full_access", "device_management", "reporting"],
      "active": true,
      "last_login": "2023-12-15T10:30:00Z",
      "created_date": "2023-01-01T00:00:00Z",
      "mfa_enabled": true,
      "api_access": true
    }
  ]
}
```

### Mapping to Common Schema
```javascript
// Datto RMM -> Common Schema (Hypothetical)
{
  "source_platform": "Datto RMM",
  "user_id": user.id,
  "username": user.username,
  "email": user.email,
  "display_name": `${user.first_name} ${user.last_name}`,
  "first_name": user.first_name,
  "last_name": user.last_name,
  "account_enabled": user.active,
  "account_created": user.created_date,
  "last_login": user.last_login,
  "mfa_enabled": user.mfa_enabled,
  "roles": [user.role],
  "permissions": user.permissions,
  "licenses": [], // Not applicable to RMM
  "tenant_id": "<mcc_tenant_id>",
  "last_audit_date": new Date().toISOString()
}
```

## n8n Implementation (if API Available)

### Workflow Structure
```
1. [Schedule Trigger]
   ↓
2. [Authenticate] - OAuth 2.0 token request
   ↓
3. [Get Users] - API call to user endpoint
   ↓
4. [Transform Data] - Normalize to common schema
   ↓
5. [Store Results] - Database or data table
   ↓
6. [Notification]
```

## Testing Checklist

- [ ] Verify Datto RMM API v2 access
- [ ] Generate API keys for testing
- [ ] Access Swagger UI documentation
- [ ] Identify user management endpoints
- [ ] Test authentication flow
- [ ] Test user list retrieval (if available)
- [ ] Document response schema
- [ ] Verify pagination (if needed)
- [ ] Test error handling
- [ ] Document rate limits
- [ ] Verify what data is and isn't available

## Manual Steps Required

### Current Status: ⚠️ LIKELY REQUIRED

Until API research is complete, assume manual steps will be needed:

1. **User List Export**
   - Frequency: Monthly or quarterly
   - Source: Datto RMM web portal
   - Format: CSV or manual entry
   - Process: Admin logs in, exports users, provides to audit system

2. **Role/Permission Documentation**
   - May require manual documentation of role definitions
   - Screenshot or document permission sets
   - Maintain mapping of roles to permissions

3. **Activity Monitoring**
   - If API doesn't provide last login, monitor manually
   - Export activity logs periodically
   - Parse for user activity

## Priority and Impact

### Impact of API Gap
- **High Impact:** Datto RMM is a core MCC platform
- **Moderate Workaround:** Manual export is feasible but not ideal
- **Frequency:** User changes are relatively infrequent in RMM platforms
- **Urgency:** Medium - important but not critical if manual process works

### Recommended Action
1. **Phase 1:** Investigate API thoroughly (high priority)
2. **Phase 2:** If API unavailable, implement manual export process
3. **Phase 3:** Revisit quarterly in case API capabilities expand

## Integration with Other Systems

### Datto RMM Component Execution
MCC already has PowerShell scripts for Datto RMM:
- Located in `/powershell/DattoRMM/` and `/powershell/DattoRMM-API/`
- May contain API access patterns
- Check for any existing user management calls

### Related MCC Documentation
- **Datto RMM API Setup:** Check `/powershell/DattoRMM-API/` directory
- **Domain Admin Account Creation:** May use Datto API
- **Existing Integrations:** Review any n8n workflows using Datto

## Dependencies

### Required for Investigation
- Datto RMM portal access (admin level)
- Datto RMM API credentials
- Swagger UI access

### Required for Implementation (if API available)
- Documented API endpoints
- OAuth 2.0 configuration
- n8n or script environment

### Required for Manual Process (if API unavailable)
- Admin portal access
- Export procedure documentation
- Schedule for manual exports

## Next Steps

### Immediate Actions (Priority 1)
1. **Access Datto RMM API Swagger UI**
   - Document user management endpoints
   - Test with API credentials
   - Document response schemas

2. **Review Existing MCC Datto Integrations**
   - Check `/powershell/DattoRMM-API/` for API usage
   - Review any n8n workflows
   - Interview MCC staff about API experience

3. **Contact Datto Support** (if needed)
   - Submit support ticket
   - Ask specific questions about user management API
   - Request documentation

### Secondary Actions (Priority 2)
4. **Create ENDPOINTS.md** (once API confirmed)
5. **Create MANUAL_STEPS.md** (if API gaps identified)
6. **Develop n8n workflow or manual process**
7. **Document findings** and update API_MATRIX.md

## Notes

- Datto RMM is a critical platform for MCC operations
- User management may be intentionally restricted via API for security
- MSP partners may have access to additional API features
- Consider Datto's partner program for enhanced API access

## Reference Links

- **Datto RMM API v2 Documentation:** https://rmm.datto.com/help/en/Content/2SETUP/APIv2.htm
- **Datto Integrations Whitepaper:** https://rmm.datto.com/help/Integrations/DattoRMMIntegrationsWhitepaper.pdf
- **MCC Datto Scripts:** `/home/wferrel/ai/powershell/DattoRMM-API/`
- **Datto Support:** Contact through partner portal

---

*Last Updated: 2025-12-17*
*Status: Research Required - API Capabilities Unclear*
*Priority: Phase 1 - High Priority (Pending Verification)*
*Action Required: Investigate Swagger UI and Datto Support*
