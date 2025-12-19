# Datto RMM Software Inventory Workflow - Updates

## Changes Made

### ✅ Updated Authentication Method

**Before:**
- Workflow used environment variables for credentials
- Authentication logic embedded in the workflow
- Required manual credential configuration

**After:**
- Workflow now calls the existing "Datto RMM - Get API Key" sub-workflow
- Centralized authentication in one place
- No need to set API credentials in environment variables
- Automatic token generation on each run

### Updated Workflow Structure

**New Node Flow:**
```
Manual Trigger
    ↓
Get Datto Auth (Execute Workflow: "Datto RMM - Get API Key")
    ↓
Set Site UID (Extract auth + set site UID)
    ↓
Get Site Devices
    ↓
[Rest of workflow unchanged]
```

**Key Changes:**
1. **Removed:** "Load Datto Credentials" and "Authenticate with Datto" nodes
2. **Added:** "Get Datto Auth" (Execute Workflow node)
3. **Modified:** "Set Site UID" node to extract auth data from sub-workflow

## Authentication Workflow Details

**Sub-Workflow Used:**
- **Name:** Datto RMM - Get API Key
- **ID:** `wXUfFK5UwsXu21j0`
- **Status:** Active
- **Type:** Execute Workflow Trigger (can be called by other workflows)

**What It Returns:**
```json
{
  "apiUrl": "https://zinfandel-api.centrastage.net",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

## Benefits

✅ **Centralized Credentials** - Update once, applies to all workflows
✅ **Consistent Authentication** - All Datto workflows use same method
✅ **Easier Maintenance** - Change credentials in one place
✅ **Simplified Setup** - No need to configure environment variables
✅ **Better Security** - Credentials not duplicated across workflows

## Environment Variables

**Still Required:**
- `DATTO_SITE_UID` (optional - defaults to `ea514805-d152-4bd4-a3f1-8de6e4b603d4`)

**No Longer Required:**
- ~~`DATTO_API_URL`~~ (now from auth workflow)
- ~~`DATTO_API_KEY`~~ (now from auth workflow)
- ~~`DATTO_API_SECRET_KEY`~~ (now from auth workflow)

## Documentation Updates

Updated the following files:

1. ✅ **WORKFLOW_SETUP_GUIDE.md**
   - Updated prerequisites section
   - Removed environment variable configuration steps
   - Updated workflow architecture diagram
   - Updated troubleshooting section

2. ✅ **QUICK_START.md**
   - Reduced setup time from 5 minutes to 3 minutes
   - Added authentication verification step
   - Simplified environment variables section
   - Updated troubleshooting guide

3. ✅ **AUTHENTICATION_PATTERN.md** (NEW)
   - Complete guide to Datto RMM authentication pattern
   - Template for future Datto workflows
   - Best practices and troubleshooting
   - Reference for all developers

## Future Datto RMM Workflows

**IMPORTANT:** All future Datto RMM workflows should use this authentication pattern.

**Standard Pattern:**
```javascript
// Node 1: Your Trigger
{
  "type": "n8n-nodes-base.manualTrigger"
}

// Node 2: Get Datto Auth
{
  "type": "n8n-nodes-base.executeWorkflow",
  "parameters": {
    "source": "database",
    "workflowId": "wXUfFK5UwsXu21j0"  // Datto RMM - Get API Key
  }
}

// Node 3: Extract Auth Data
{
  "type": "n8n-nodes-base.set",
  "parameters": {
    "assignments": {
      "assignments": [
        {
          "name": "apiUrl",
          "value": "={{ $json.apiUrl }}"
        },
        {
          "name": "accessToken",
          "value": "={{ $json.access_token }}"
        }
      ]
    }
  }
}

// Node 4+: Your business logic
```

See **AUTHENTICATION_PATTERN.md** for complete details.

## Migration Notes

### Existing Workflows

The following workflows should be updated to use this pattern:

- [ ] **S_Datto RMM - Get Sites** (ID: `68SgIFz00IQ089Qf`)
- [ ] **S_Datto RMM - Get Site Devices** (ID: `mSkQRCoJKlBASvcX`)
- [ ] **DattoRMM - Add Sites to Site Groups** (ID: `PgGx0tVxT7ji7eXV`)
- [ ] **Datto RMM - Get Sites and Devices** (ID: `uNbmDvuyRSe2FkrU`)
- [ ] **Datto RMM API Tests** (ID: `BirzhKg9sxhuoCfv`)

### Migration Steps

For each workflow:

1. Open the workflow in n8n
2. After the trigger, add "Execute Workflow" node
3. Configure it to call "Datto RMM - Get API Key" (ID: `wXUfFK5UwsXu21j0`)
4. Remove old authentication nodes
5. Update references to use `$('Get Datto Auth').item.json.access_token`
6. Test the workflow
7. Save and activate

## Testing

### Verified Working
- ✅ Authentication sub-workflow call
- ✅ Token retrieval and extraction
- ✅ Site devices API call
- ✅ Device software API call
- ✅ Data transformation
- ✅ Data table upsert

### Test Results
- Workflow executes successfully
- Authentication completes in ~1 second
- All API calls use correct bearer token
- Data properly formatted and stored

## Rollback Plan

If issues arise with the new authentication method:

1. The original workflow structure is documented in git history
2. Environment variables can be re-added if needed
3. The authentication sub-workflow can be modified to accept parameters
4. No data loss - only authentication method changed

## Questions?

- See **AUTHENTICATION_PATTERN.md** for implementation details
- See **WORKFLOW_SETUP_GUIDE.md** for complete setup instructions
- See **QUICK_START.md** for fastest path to running workflow

---

**Date:** 2025-01-18
**Modified Workflow ID:** `7FvKqNxhnkKOnIHl`
**Auth Workflow ID:** `wXUfFK5UwsXu21j0`
**Status:** ✅ Complete and Tested
