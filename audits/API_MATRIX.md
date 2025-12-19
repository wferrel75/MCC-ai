# API Capability Matrix - User Account & Access Level Auditing

## Overview

This matrix documents the API capabilities of each platform in the MCC technology stack for user account and access level auditing purposes.

## Legend

- ✅ **Full API Support** - Complete REST API with documented user management endpoints
- ⚠️ **Partial API Support** - API exists but limited/undocumented for user management
- ❌ **Manual Required** - No API or requires manual steps
- 🔒 **Requires Premium** - API access requires specific licensing tier
- 📝 **Documentation Available** - Official API documentation exists
- 🔧 **Unofficial API** - Community-documented or reverse-engineered API

## Capability Matrix

| Platform | API Status | User List | Roles/Permissions | Last Login | MFA Status | License Info | Authentication Method | Notes |
|----------|-----------|-----------|-------------------|------------|------------|--------------|----------------------|-------|
| **Microsoft Entra ID** | ✅ 📝 | ✅ | ✅ | ✅ | ✅ | ✅ | OAuth 2.0 / Graph API | Full audit log support, 30-day free tier |
| **Microsoft 365** | ✅ 📝 | ✅ | ✅ | ✅ | ✅ | ✅ | OAuth 2.0 / Graph API | Office 365 Management Activity API |
| **Microsoft Azure** | ✅ 📝 | ✅ | ✅ | ✅ | N/A | N/A | OAuth 2.0 / ARM API | RBAC role assignments, subscriptions |
| **AWS** | ✅ 📝 | ✅ | ✅ | ✅ | ✅ | N/A | IAM Access Keys | Credential reports, policy simulation |
| **ConnectSecure** | ✅ 📝 | ✅ | ✅ | ✅ | ❓ | N/A | Bearer Token (OAuth) | Multi-tenant, /r/user/get_users endpoint |
| **Keeper Security** | ✅ 📝 | ✅ | ✅ | ✅ | ✅ | N/A | REST API / SDK | Commander CLI, RBAC enforcement policies |
| **KnowBe4** | ✅ 🔒 📝 | ✅ | ✅ | ✅ | ❓ | N/A | API Key (Bearer) | Requires Platinum/Diamond subscription |
| **RocketCyber** | ✅ 📝 | ✅ | ✅ | ✅ | ✅ | N/A | API Access Token | Owner/Incident Responder/Viewer roles |
| **Cisco Meraki** | ✅ 📝 | ✅ | ✅ | ✅ | ❓ | N/A | API Key (X-Cisco-Meraki-API-Key) | Dashboard API, org/network admins |
| **Zoho Desk** | ✅ 📝 | ✅ | ✅ | ✅ | ❓ | N/A | OAuth 2.0 / Zoho API | /users and /roles endpoints |
| **Zoho Projects** | ✅ 📝 | ✅ | ✅ | ✅ | ❓ | N/A | OAuth 2.0 / Zoho API | Portal users, project roles |
| **Datto RMM** | ⚠️ 📝 | ❓ | ❓ | ❓ | ❓ | N/A | OAuth 2.0 (API v2) | User endpoints not clearly documented |
| **Ubiquiti UniFi** | ⚠️ 🔧 | ✅ | ⚠️ | ⚠️ | ❓ | N/A | Session Cookie | Unofficial API, limited documentation |
| **Fortinet FortiGate** | ⚠️ 📝 | ✅ | ✅ | ⚠️ | ❓ | N/A | API Key / Token | REST API, admin accounts with RBAC |
| **Barracuda Email** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | Unknown | Limited API documentation found |
| **Acronis Cyber Protect** | ❌ | ❓ | ❓ | ❓ | ❓ | ❓ | Unknown | Requires additional research |

## Detailed API Analysis

### Tier 1: Full API Support (10 platforms)

#### Microsoft Entra ID (Azure AD)
- **API:** Microsoft Graph API
- **Base URL:** `https://graph.microsoft.com/v1.0/`
- **Key Endpoints:**
  - `GET /users` - List all users
  - `GET /users/{id}` - Get user details
  - `GET /users/{id}/memberOf` - Get user's group memberships and roles
  - `GET /users/{id}/signInActivity` - Get last sign-in info
  - `GET /directoryRoles` - List directory roles
  - `GET /auditLogs/signIns` - Sign-in audit logs
  - `GET /auditLogs/directoryAudits` - Directory audit logs
- **Audit Retention:** 30 days (free), 1 year (E5/Premium)
- **Authentication:** OAuth 2.0 with app registration
- **Rate Limits:** Standard throttling applies
- **Documentation:** https://learn.microsoft.com/en-us/graph/api/user-list

#### Microsoft 365
- **API:** Microsoft Graph API + Office 365 Management Activity API
- **Base URL:** `https://graph.microsoft.com/v1.0/` and `https://manage.office.com/api/v1.0/`
- **Key Endpoints:**
  - `GET /users` - List all users (same as Entra ID)
  - `GET /users/{id}/licenseDetails` - User license assignments
  - `GET /subscribedSkus` - Available licenses
  - Management Activity API for audit logs
- **Audit Retention:** 90 days (Standard), 365 days (E5/Audit Premium)
- **Authentication:** OAuth 2.0
- **Notes:** Audit logging enabled by default (except SMB licenses)
- **Documentation:** https://learn.microsoft.com/en-us/office/office-365-management-api/

#### Microsoft Azure
- **API:** Azure Resource Manager (ARM) REST API
- **Base URL:** `https://management.azure.com/`
- **Key Endpoints:**
  - `GET /subscriptions` - List subscriptions
  - `GET /subscriptions/{id}/providers/Microsoft.Authorization/roleAssignments` - Get RBAC assignments
  - `GET /subscriptions/{id}/providers/Microsoft.Authorization/roleDefinitions` - Get role definitions
  - Azure AD Graph API for user info (integrates with Entra ID)
- **Authentication:** OAuth 2.0
- **Notes:** Subscription-level and resource-level RBAC
- **Documentation:** https://learn.microsoft.com/en-us/rest/api/azure/

#### Amazon Web Services (AWS)
- **API:** AWS Identity and Access Management (IAM) API
- **Base URL:** `https://iam.amazonaws.com/`
- **Key Endpoints:**
  - `ListUsers` - List IAM users
  - `ListRoles` - List IAM roles
  - `ListAttachedUserPolicies` - List managed policies for user
  - `ListUserPolicies` - List inline policies for user
  - `GetUser` - Get user details
  - `GetAccountAuthorizationDetails` - Comprehensive policy/user dump
  - `GenerateCredentialReport` / `GetCredentialReport` - Audit report
  - `ListAccessKeys` - List user access keys
- **Authentication:** AWS Access Key ID + Secret Access Key (Signature Version 4)
- **Notes:** Credential reports include password age, MFA status, access key rotation
- **Documentation:** https://docs.aws.amazon.com/IAM/latest/APIReference/

#### ConnectSecure (CyberCNS)
- **API:** REST API (OpenAPI 3.0)
- **Base URL:** `https://pod107.myconnectsecure.com/` (or tenant-specific)
- **Key Endpoints:**
  - `POST /w/authorize` - Authenticate and get bearer token
  - `GET /r/user/get_users` - Retrieve users (with roles, last_login, state)
  - `GET /r/user/get_user_details` - Retrieve user details
  - `GET /r/ad_users_view` - Retrieve Active Directory users
  - `GET /r/ad_user_licenses` - Retrieve AD user licenses
  - `GET /r/ad_group_users` - Retrieve AD group users
- **Authentication:** Base64 encoded `tenant+client_id:client_secret` for auth, then Bearer token
- **Multi-tenant:** Yes - requires tenant context
- **Documentation:** Available via swagger.yaml in /home/wferrel/ai/n8n-workflows/Connect_Secure/
- **Notes:** 226+ endpoints, comprehensive API coverage

#### Keeper Security
- **API:** REST API + Keeper Commander CLI/SDK
- **Base URL:** `https://keepersecurity.com/api/`
- **Key Endpoints:**
  - REST Service Mode API for vault access
  - Account Management APIs for enterprise admin
  - Role-based access controls (RBAC) APIs
  - Enforcement policy APIs
- **Authentication:** Multiple methods (Master password, SSO, 2FA, Passkey support starting July 2025)
- **Notes:** Zero-knowledge encryption model, full vault CRUD operations
- **Documentation:** https://docs.keeper.io/en/enterprise-guide/developer-tools
- **Features:** Role enforcement, delegated admin, biometric login (2025)

#### KnowBe4
- **API:** Reporting API + User Event API
- **Base URL:** Specific to account region
- **Key Endpoints:**
  - Reporting API (Platinum/Diamond only) - pull data from console
  - User Event API (Platinum/Diamond only) - import external events
  - Training status and progress endpoints
  - User enrollment data
- **Authentication:** API Key (Bearer Token)
- **Limitations:** Requires Platinum or Diamond subscription
- **Documentation:** https://developer.knowbe4.com/ and https://support.knowbe4.com/hc/en-us/articles/115016090908
- **Notes:** Training reports, user progress, acknowledgment status

#### RocketCyber (Kaseya MDR)
- **API:** RocketCyber API
- **Base URL:** Provider-specific
- **Key Endpoints:**
  - User management with role-based access
  - Three role types: Owner, Incident Responder, Viewer
- **Authentication:** RocketCyber API Access Token (found in Provider Settings)
- **Security Features:**
  - Two-factor authentication (2FA) support
  - SSO with KaseyaOne
  - Automatic user creation from KaseyaOne
- **Documentation:** https://help.rocketcyber.kaseya.com/
- **Notes:** Delegated admin capabilities, configurable access tiers

#### Cisco Meraki
- **API:** Meraki Dashboard API
- **Base URL:** `https://api.meraki.com/api/v1/`
- **Key Endpoints:**
  - Organization administrators
  - Network administrators
  - API key management
  - Role-based permissions (Full Org Admin, Read-only Org Admin, Network Admin, Read-only Network Admin)
- **Authentication:** X-Cisco-Meraki-API-Key header
- **Notes:** API respects administrator permissions, API keys inherit account permissions
- **Documentation:** https://developer.cisco.com/meraki/
- **Best Practices:** Dedicated API admin accounts, principle of least privilege

#### Zoho (Desk + Projects)
- **API:** Zoho REST API
- **Base URL:**
  - Desk: `https://desk.zoho.com/api/v1/`
  - Projects: `https://projectsapi.zoho.com/`
- **Key Endpoints:**
  - `GET /users` - List users (Desk)
  - `GET /roles` - List roles and permissions (Desk)
  - Portal users and project roles (Projects)
- **Authentication:** OAuth 2.0
- **Documentation:**
  - Desk: https://desk.zoho.com/DeskAPIDocument
  - Projects: https://www.zoho.com/projects/help/rest-api/
- **Notes:** Separate APIs for Desk and Projects, unified OAuth

### Tier 2: Partial API Support (3 platforms)

#### Datto RMM
- **API:** Datto RMM API v2
- **Base URL:** `https://rmm.datto.com/api/v2/`
- **Authentication:** OAuth 2.0
- **Known Endpoints:**
  - `/v2/audit/device/macAddress/{macAddress}` - Device audit data
  - API keys generated per user
- **Gaps:** User account management endpoints not clearly documented
- **Status:** Requires additional research or Datto support consultation
- **Documentation:** https://rmm.datto.com/help/en/Content/2SETUP/APIv2.htm
- **Notes:** Swagger UI available for endpoint documentation, focus on device auditing rather than user management

#### Ubiquiti UniFi
- **API:** Unofficial UniFi Controller API
- **Base URL:** `https://<controller-ip>:8443/api/`
- **Authentication:** Session cookie (login required)
- **Capabilities:**
  - List users/clients on network
  - Administrator account management (limited)
  - User groups and firewall rules
  - Block/unblock clients
  - Guest authorization
- **Gaps:** Limited official documentation, community-maintained
- **Status:** Functional but unsupported by Ubiquiti
- **Documentation:** Community GitHub repositories and forums
- **Notes:** API accessed through UniFi Network Application (formerly Controller)

#### Fortinet FortiGate
- **API:** FortiOS REST API
- **Base URL:** `https://<fortigate-ip>/api/v2/`
- **Authentication:** API Key or Token-based
- **Capabilities:**
  - Administrator account management
  - RBAC profile configuration
  - Access profile definitions (read/write permissions)
  - API user accounts
- **Gaps:** Specific endpoints require FortiOS version-specific documentation
- **Status:** API exists but requires version-specific research
- **Documentation:** Fortinet Developer Network (FNDN), FortiOS Administrator Guide
- **Notes:** Different API capabilities per FortiOS version

### Tier 3: Manual Steps Required (3 platforms)

#### Barracuda Email Security
- **API Status:** ❌ Limited or no public API documentation found
- **Manual Alternatives:**
  - Web portal login required
  - User management through web interface
  - May have partner/MSP API (requires Barracuda consultation)
- **Workarounds:**
  - Web scraping (not recommended)
  - Manual export from portal
  - Contact Barracuda for MSP API access
- **Next Steps:** Contact Barracuda support for API documentation
- **Notes:** Common in security appliances to restrict API access

#### Acronis Cyber Protect
- **API Status:** ❌ Requires additional research
- **Known Info:**
  - Acronis has a developer portal
  - Cyber Protection Console should have APIs
  - Multi-tenant management platform
- **Manual Alternatives:**
  - Web portal access
  - PowerShell module (if available)
  - Console exports
- **Next Steps:**
  - Research Acronis Developer Portal
  - Check for PowerShell/CLI tools
  - Contact Acronis support
- **Notes:** Enterprise backup solutions typically have APIs for MSP partners

#### KnowBe4 (Subscription Limitation)
- **API Status:** ✅ Available BUT 🔒 Requires Platinum/Diamond Subscription
- **Issue:** Reporting API access locked behind premium tier
- **Current Tier:** Unknown - needs verification
- **Manual Alternatives:**
  - Export reports from web console
  - Schedule automated report emails
  - Upgrade to Platinum/Diamond tier
- **Cost Consideration:** Subscription upgrade cost vs. automation value
- **Next Steps:** Verify current MCC subscription tier with KnowBe4

## Authentication Summary

| Platform | Auth Method | Credentials Required | Token Expiry | Notes |
|----------|-------------|---------------------|--------------|-------|
| Microsoft Entra ID | OAuth 2.0 | Client ID + Secret | 1 hour (refresh available) | App registration required |
| Microsoft 365 | OAuth 2.0 | Client ID + Secret | 1 hour (refresh available) | Same as Entra ID |
| Microsoft Azure | OAuth 2.0 | Client ID + Secret | 1 hour (refresh available) | Service Principal |
| AWS | Signature V4 | Access Key + Secret | N/A (static) | IAM User or Role |
| ConnectSecure | Bearer Token | Tenant + Client ID + Secret | Variable | Base64 encoded auth |
| Keeper Security | Multiple | Master Password / API Key | Session-based | Zero-knowledge model |
| KnowBe4 | API Key | API Token | N/A (static) | Enable in console |
| RocketCyber | API Token | Access Token | N/A (static) | Found in Provider Settings |
| Cisco Meraki | API Key | API Key | N/A (static) | Per-admin account |
| Zoho | OAuth 2.0 | Client ID + Secret | 1 hour (refresh available) | Unified across Zoho products |
| Datto RMM | OAuth 2.0 | Client ID + Secret | Variable | Per-user API keys |
| Ubiquiti UniFi | Session Cookie | Username + Password | Session timeout | Unofficial API |
| Fortinet FortiGate | API Key/Token | API Key | Variable | Version-dependent |

## Rate Limiting Considerations

| Platform | Rate Limit | Throttling | Batch Operations | Notes |
|----------|-----------|------------|------------------|-------|
| Microsoft Graph | Variable by endpoint | Yes | Yes | Standard throttling |
| AWS IAM | Moderate | Yes | Limited | Credential reports throttled |
| ConnectSecure | Unknown | Likely | Yes | Use skip/limit parameters |
| Keeper Security | Unknown | Likely | Yes | REST service mode |
| KnowBe4 | Unknown | Likely | No | Report-based |
| RocketCyber | Unknown | Likely | Unknown | Check documentation |
| Cisco Meraki | 5 requests/sec | Yes | Limited | Dashboard API limits |
| Zoho | 100 API calls/min (default) | Yes | Yes | Quota increases available |

## Data Normalization Schema

To create a unified reporting view, each platform's user data should be normalized to:

```json
{
  "source_platform": "string",
  "user_id": "string",
  "username": "string",
  "email": "string",
  "display_name": "string",
  "first_name": "string",
  "last_name": "string",
  "account_enabled": "boolean",
  "account_created": "datetime",
  "last_login": "datetime",
  "mfa_enabled": "boolean",
  "roles": ["array of strings"],
  "permissions": ["array of strings"],
  "licenses": ["array of strings"],
  "tenant_id": "string",
  "last_audit_date": "datetime"
}
```

## Implementation Priority

Recommended implementation order based on API maturity and business value:

### Phase 1: High Priority (Full API + High Business Impact)
1. Microsoft Entra ID - Foundation for identity
2. Microsoft 365 - Email and collaboration
3. ConnectSecure - Security compliance
4. RocketCyber - Security monitoring
5. AWS - Cloud infrastructure (if used)

### Phase 2: Medium Priority (Full API + Moderate Impact)
6. Keeper Security - Credential management
7. Zoho Desk/Projects - Service management
8. Cisco Meraki - Network infrastructure

### Phase 3: Lower Priority (Partial API or Research Required)
9. Datto RMM - Endpoint management
10. KnowBe4 - Training (subscription dependent)
11. Azure - Cloud infrastructure (if used)
12. Fortinet FortiGate - Network security

### Phase 4: Manual/Future (Requires Additional Work)
13. Ubiquiti UniFi - Network management
14. Barracuda Email Security - Email filtering
15. Acronis Cyber Protect - Backup and DR

## Next Steps

1. **Document specific endpoints** for Phase 1 platforms in individual component directories
2. **Create authentication test scripts** for each platform
3. **Design normalized data schema** in detail with field mappings
4. **Build proof-of-concept** for 2-3 platforms (suggest: Entra ID, ConnectSecure, Meraki)
5. **Develop n8n orchestration workflow** with error handling and logging

---

*Last Updated: 2025-12-17*
*Research Phase Complete*
