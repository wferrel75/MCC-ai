# Datto RMM Authentication Pattern

## Standard Authentication Workflow

**All Datto RMM workflows should use the sub-workflow for authentication:**

**Workflow Name:** `Datto RMM - Get API Key`
**Workflow ID:** `wXUfFK5UwsXu21j0`
**Status:** Active

## How to Use

### In Your Workflow

Add an **Execute Workflow** node immediately after your trigger:

```javascript
{
  "node": "Get Datto Auth",
  "type": "n8n-nodes-base.executeWorkflow",
  "parameters": {
    "source": "database",
    "workflowId": "wXUfFK5UwsXu21j0"
  }
}
```

### What You Get Back

The authentication workflow returns:

```json
{
  "apiUrl": "https://zinfandel-api.centrastage.net",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### How to Use the Response

After the Execute Workflow node, extract the values:

```javascript
// In subsequent nodes, reference:
const apiUrl = $('Get Datto Auth').item.json.apiUrl;
const accessToken = $('Get Datto Auth').item.json.access_token;

// Example HTTP Request node
{
  "url": `${apiUrl}/v2/account/sites`,
  "headers": {
    "Authorization": `Bearer ${accessToken}`
  }
}
```

## Complete Pattern Example

```
Your Trigger
    ↓
Execute Workflow: "Datto RMM - Get API Key"
    ↓
Set Variables (extract apiUrl and access_token)
    ↓
Your Business Logic (use apiUrl and accessToken)
```

## Authentication Workflow Details

### What It Does

1. **Variables Node** - Sets credentials (hardcoded in the workflow)
   - `apiUrl`: `https://zinfandel-api.centrastage.net`
   - `apiKey`: API key
   - `apiSecretKey`: API secret key
   - `siteUid`: Default site UID

2. **API Token Node** - Calls OAuth2 token endpoint
   - **Method:** POST
   - **URL:** `{apiUrl}/auth/oauth/token`
   - **Headers:** `Authorization: Basic cHVibGljLWNsaWVudDpwdWJsaWM=`
   - **Body (form-urlencoded):**
     - `grant_type`: password
     - `username`: {apiKey}
     - `password`: {apiSecretKey}

3. **Return Node** - Returns apiUrl and access_token

### Token Lifespan

- **Access tokens expire after 100 hours**
- The workflow can be called multiple times (tokens are fresh each time)
- No need to cache tokens in your workflow

## Standard Workflow Template

### Node 1: Trigger
```javascript
{
  "name": "Manual Trigger",
  "type": "n8n-nodes-base.manualTrigger"
}
```

### Node 2: Get Authentication
```javascript
{
  "name": "Get Datto Auth",
  "type": "n8n-nodes-base.executeWorkflow",
  "parameters": {
    "source": "database",
    "workflowId": "wXUfFK5UwsXu21j0"
  }
}
```

### Node 3: Extract Auth Data (Optional but Recommended)
```javascript
{
  "name": "Set Auth Variables",
  "type": "n8n-nodes-base.set",
  "parameters": {
    "assignments": {
      "assignments": [
        {
          "name": "apiUrl",
          "value": "={{ $json.apiUrl }}",
          "type": "string"
        },
        {
          "name": "accessToken",
          "value": "={{ $json.access_token }}",
          "type": "string"
        }
      ]
    }
  }
}
```

### Node 4+: Your API Calls
```javascript
{
  "name": "Get Account Data",
  "type": "n8n-nodes-base.httpRequest",
  "parameters": {
    "method": "GET",
    "url": "={{ $('Set Auth Variables').item.json.apiUrl }}/v2/account",
    "authentication": "none",
    "sendHeaders": true,
    "headerParameters": {
      "parameters": [
        {
          "name": "Authorization",
          "value": "=Bearer {{ $('Set Auth Variables').item.json.accessToken }}"
        }
      ]
    }
  }
}
```

## Benefits of This Pattern

✅ **Centralized credential management** - All credentials in one workflow
✅ **Easy to update** - Change credentials in one place
✅ **Consistent authentication** - All workflows use same method
✅ **Simplified workflows** - No need to repeat auth logic
✅ **Version control** - Authentication logic is versioned
✅ **Testing** - Can test auth independently

## Updating Credentials

To update Datto RMM credentials:

1. Open workflow: `Datto RMM - Get API Key`
2. Edit the **Variables** node
3. Update:
   - `apiUrl` (if changing platforms)
   - `apiKey` (new API key)
   - `apiSecretKey` (new secret key)
   - `siteUid` (default site, optional)
4. Save the workflow
5. All workflows using this will automatically use new credentials

## Alternative: Environment Variables

If you prefer environment variables, you can modify the auth workflow's Variables node:

```javascript
{
  "assignments": [
    {
      "name": "apiUrl",
      "value": "={{ $env.DATTO_API_URL }}",
      "type": "string"
    },
    {
      "name": "apiKey",
      "value": "={{ $env.DATTO_API_KEY }}",
      "type": "string"
    },
    {
      "name": "apiSecretKey",
      "value": "={{ $env.DATTO_API_SECRET_KEY }}",
      "type": "string"
    }
  ]
}
```

## Existing Workflows Using This Pattern

1. ✅ **Datto RMM Software Inventory Sync** (ID: `7FvKqNxhnkKOnIHl`)
2. **S_Datto RMM - Get Sites** (ID: `68SgIFz00IQ089Qf`)
3. **S_Datto RMM - Get Site Devices** (ID: `mSkQRCoJKlBASvcX`)
4. **DattoRMM - Add Sites to Site Groups** (ID: `PgGx0tVxT7ji7eXV`)

## Troubleshooting

### Error: "Workflow not found"

**Cause:** The authentication workflow ID is incorrect or workflow was deleted

**Solution:**
1. Verify workflow exists: Go to n8n → Workflows → Search "Datto RMM - Get API Key"
2. Check workflow ID: Should be `wXUfFK5UwsXu21j0`
3. Update Execute Workflow node if ID changed

### Error: "Authentication failed"

**Cause:** Invalid credentials in the auth workflow

**Solution:**
1. Open `Datto RMM - Get API Key` workflow
2. Check Variables node credentials
3. Regenerate API keys in Datto portal if needed
4. Update credentials in Variables node

### Error: "Token expired"

**Cause:** Access token expired (after 100 hours)

**Solution:**
- Simply re-run your workflow
- The auth workflow generates a new token each time
- No need to manually refresh tokens

## API Reference

### OAuth2 Token Endpoint

```http
POST https://zinfandel-api.centrastage.net/auth/oauth/token
Authorization: Basic cHVibGljLWNsaWVudDpwdWJsaWM=
Content-Type: application/x-www-form-urlencoded

grant_type=password&username={apiKey}&password={apiSecretKey}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 360000,
  "scope": "read write"
}
```

### Using the Access Token

All subsequent API calls:

```http
GET https://zinfandel-api.centrastage.net/v2/{endpoint}
Authorization: Bearer {access_token}
```

## Rate Limiting

**Datto RMM API Rate Limits:**
- 600 requests per 60 seconds per account
- Authentication requests count toward this limit
- Consider calling auth workflow once per workflow execution (not per loop iteration)

## Security Notes

⚠️ **The authentication workflow contains hardcoded credentials**
- Credentials are visible to anyone with access to the workflow
- Consider moving to environment variables for better security
- Rotate API keys regularly
- Use Datto RMM's role-based access to limit API key permissions

## Future Improvements

Consider these enhancements:

1. **Token Caching** - Store token in global variable with expiration check
2. **Error Handling** - Add retry logic for failed auth attempts
3. **Multi-Account Support** - Pass account identifier to select different credentials
4. **Audit Logging** - Log all auth requests for security monitoring

---

**Last Updated:** 2025-01-18
**Auth Workflow Version:** 1.0
**Pattern Version:** 1.0
