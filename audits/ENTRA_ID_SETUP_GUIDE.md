# Microsoft Entra ID - Complete Setup Guide
## Manual Steps Required for n8n Workflow

---

## Overview

You now have a complete n8n workflow JSON file that's ready to import. However, you need to complete several manual setup steps before the workflow can run successfully.

**Workflow File:** `/home/wferrel/ai/audits/workflows/EntraID_User_Audit.json`

---

## ✅ Completed Steps

- [x] Created n8n data table: "UserAudit"
- [x] Imported table schema from CSV
- [x] Generated workflow JSON file

---

## 📋 Manual Steps Remaining

### Phase 1: Azure AD App Registration (15-20 minutes)

#### Step 1: Access Azure Portal
1. Go to https://portal.azure.com/
2. Sign in with your Azure AD admin account
3. Navigate to **Azure Active Directory** (or search for "Azure Active Directory")

#### Step 2: Create App Registration
1. In left sidebar, click **App registrations**
2. Click **+ New registration**
3. Configure the registration:
   ```
   Name: MCC-UserAudit-Service
   Supported account types: Accounts in this organizational directory only (Single tenant)
   Redirect URI: Leave blank (not needed for service principal)
   ```
4. Click **Register**

#### Step 3: Note Your Credentials
After registration, you'll see the app overview page. **SAVE THESE VALUES:**

```
Application (client) ID: ________________________________
Directory (tenant) ID:   ________________________________
```

**Keep this browser tab open** - you'll need it for the next steps.

#### Step 4: Create Client Secret
1. In your app registration, left sidebar: **Certificates & secrets**
2. Click **+ New client secret**
3. Configure:
   ```
   Description: n8n User Audit Integration
   Expires: 24 months (set a calendar reminder to rotate before expiry)
   ```
4. Click **Add**
5. **IMMEDIATELY COPY THE SECRET VALUE** - you can't see it again!
   ```
   Client Secret Value: ________________________________
   ```
   **CRITICAL:** Save this value in Keeper Security or secure note immediately!

#### Step 5: Grant API Permissions
1. In left sidebar: **API permissions**
2. Click **+ Add a permission**
3. Select **Microsoft Graph**
4. Select **Application permissions** (NOT Delegated)
5. Search and add these permissions:
   - `User.Read.All` - Read all users' full profiles
   - `Directory.Read.All` - Read directory data
   - `AuditLog.Read.All` - Read audit log data (optional - requires Premium P1/P2)
6. Click **Add permissions**
7. **CRITICAL:** Click **Grant admin consent for [Your Org]**
   - This requires Global Administrator rights
   - Click **Yes** to confirm
   - Status should show green checkmarks

#### Step 6: Verify Permissions
Your API permissions should now show:
```
✓ User.Read.All (Granted)
✓ Directory.Read.All (Granted)
✓ AuditLog.Read.All (Granted) - if you added it
```

---

### Phase 2: Configure n8n Environment Variables (5 minutes)

#### Step 1: Access n8n Settings
1. Open n8n: https://n8n.midcloudcomputing.com/
2. Click **Settings** (gear icon in bottom left)
3. Navigate to **Environment** or **Variables** section

#### Step 2: Add Environment Variables
Create these environment variables with the values you saved above:

```bash
Variable Name: ENTRA_TENANT_ID
Value: [Your Directory (tenant) ID from Step 3]
Description: Azure AD Tenant ID for authentication

Variable Name: ENTRA_CLIENT_ID
Value: [Your Application (client) ID from Step 3]
Description: Azure AD App Registration Client ID

Variable Name: ENTRA_CLIENT_SECRET
Value: [Your Client Secret Value from Step 4]
Description: Azure AD App Registration Client Secret
Type: Secret (if n8n supports marking as secret)

Variable Name: NOTIFICATION_EMAIL
Value: your-email@midcloudcomputing.com
Description: Email address for workflow notifications
```

#### Alternative: Use n8n Credentials (Recommended)
If your n8n version supports credential storage:

1. Settings → Credentials → + Add Credential
2. Select **Generic Credential** or **OAuth2 API**
3. Store your credentials securely
4. Reference in workflow instead of environment variables

---

### Phase 3: Import Workflow to n8n (5 minutes)

#### Step 1: Import Workflow File
1. In n8n, go to **Workflows**
2. Click **+ Add workflow** dropdown
3. Select **Import from File**
4. Navigate to: `/home/wferrel/ai/audits/workflows/EntraID_User_Audit.json`
5. Click **Open** or **Import**

#### Step 2: Verify Workflow Import
You should see a workflow named **"EntraID - User Audit"** with 23 nodes:
- 2 triggers (Manual and Schedule)
- Authentication nodes
- User collection and pagination
- Data enrichment (roles, MFA, licenses)
- Data transformation
- Data table storage
- Success/error notifications

#### Step 3: Update Data Table Reference
The workflow references the table name **"UserAudit"** which matches your table.

**If you named your table differently**, update the "Store in Data Table" node:
1. Click on **"Store in Data Table"** node
2. In the **Data Table** dropdown, select your table name
3. Save the node

---

### Phase 4: Testing the Workflow (15-20 minutes)

#### Test 1: Authentication Test
1. Ensure **Manual Trigger** is the active trigger
2. Ensure **Schedule Trigger** is DISABLED (it should be by default)
3. Click on **"Get Access Token"** node
4. Click **"Execute Node"** (or **"Test step"**)
5. Check the output - you should see:
   ```json
   {
     "token_type": "Bearer",
     "expires_in": 3599,
     "access_token": "eyJ0eXAiOiJKV1QiLCJub..."
   }
   ```
6. **If this fails:**
   - Check environment variables are correct
   - Verify client secret wasn't truncated
   - Check tenant ID and client ID are correct
   - Verify app permissions were granted admin consent

#### Test 2: Get Users (Limited Test)
1. Click on **"Get Users - First Page"** node
2. **TEMPORARILY modify the URL** to limit results:
   - Change `$top=999` to `$top=5`
   - This prevents overwhelming your system during testing
3. Click **"Execute Node"**
4. You should see 5 users in the output
5. **Verify user data includes:**
   - id, userPrincipalName, displayName
   - givenName, surname, mail
   - accountEnabled, createdDateTime

#### Test 3: Full Workflow (5 Users)
1. Keep the `$top=5` limit for now
2. Click **"Execute Workflow"** (play button at top)
3. Watch the workflow execute through all nodes
4. **Expected flow:**
   - Get token ✓
   - Get users (5) ✓
   - Handle pagination ✓
   - Split users ✓
   - Batch processing ✓
   - Get roles/MFA/licenses for each user ✓
   - Merge data ✓
   - Transform to schema ✓
   - Store in data table ✓
   - Success notification ✓

#### Test 4: Verify Data in Table
1. Go to **Settings** → **Data** → **UserAudit** table
2. You should see 5 new records
3. **Verify columns are populated:**
   - source_platform: "Microsoft Entra ID"
   - user_id, username, email, display_name
   - account_enabled, mfa_enabled
   - roles (JSON string)
   - licenses (JSON string)
   - last_audit_date (recent timestamp)

#### Test 5: Test Upsert (Update Existing)
1. Run the workflow again (still with `$top=5`)
2. Check the data table - should still have only 5 records (not 10)
3. Check `last_audit_date` - should be updated to new timestamp
4. This confirms upsert is working (update, not duplicate)

#### Test 6: Full Production Run
1. **ONLY after tests 1-5 pass successfully**
2. Edit **"Get Users - First Page"** node
3. Change URL back to `$top=999` (or remove $top entirely)
4. Click **"Execute Workflow"**
5. **This will take longer** (5-15 minutes depending on user count)
6. Monitor progress in execution log
7. Check data table for all users

---

### Phase 5: Enable Scheduling (After Testing) (2 minutes)

#### Step 1: Disable Manual Trigger
1. Click on **"Manual Trigger"** node
2. Toggle **"Disabled"** to ON
3. Save the node

#### Step 2: Enable Schedule Trigger
1. Click on **"Schedule Trigger"** node
2. Toggle **"Disabled"** to OFF
3. **Verify schedule:** `0 2 * * *` (2:00 AM daily)
4. **Optional:** Adjust time if needed (use cron expression)
5. Save the node

#### Step 3: Activate Workflow
1. At the top of the workflow, toggle **"Inactive"** to **"Active"**
2. The workflow will now run automatically at 2:00 AM daily
3. You can also manually execute any time using **"Execute Workflow"** button

---

### Phase 6: Enable Notifications (Optional) (5 minutes)

#### Success Email Notification
1. Click on **"Send Success Email"** node
2. Configure email settings:
   ```
   From Email: noreply@midcloudcomputing.com
   To Email: {{$env.NOTIFICATION_EMAIL}} (uses environment variable)
   SMTP Settings: Configure based on your email provider
   ```
3. Toggle **"Disabled"** to OFF
4. Save and test

#### Error Email Notification
1. Click on **"Send Error Email"** node
2. Configure the same email settings
3. Toggle **"Disabled"** to OFF
4. Save

#### Alternative: Use Slack Notifications
If you prefer Slack:
1. Delete email nodes
2. Add **Slack** nodes
3. Configure webhook URL
4. Send formatted messages to Slack channel

---

## 🎯 Verification Checklist

Before considering setup complete, verify:

### Azure AD Configuration
- [ ] App registration created
- [ ] Tenant ID, Client ID, Client Secret saved securely
- [ ] API permissions granted:
  - [ ] User.Read.All
  - [ ] Directory.Read.All
  - [ ] AuditLog.Read.All (optional)
- [ ] Admin consent granted (green checkmarks visible)

### n8n Configuration
- [ ] Environment variables created:
  - [ ] ENTRA_TENANT_ID
  - [ ] ENTRA_CLIENT_ID
  - [ ] ENTRA_CLIENT_SECRET
  - [ ] NOTIFICATION_EMAIL
- [ ] Workflow imported successfully
- [ ] Data table "UserAudit" exists and is accessible

### Testing
- [ ] Authentication test passed
- [ ] Get users test passed (5 users)
- [ ] Full workflow test passed (5 users)
- [ ] Data visible in UserAudit table
- [ ] Upsert test passed (no duplicates)
- [ ] Full production run completed successfully
- [ ] All users collected and stored

### Production Readiness
- [ ] Schedule trigger enabled (disabled manual trigger)
- [ ] Workflow activated
- [ ] Notifications configured (optional)
- [ ] First scheduled run completed successfully
- [ ] No errors in execution log

---

## 🐛 Troubleshooting Common Issues

### Issue 1: "Authentication Failed" Error
**Symptoms:** Get Access Token node fails with 401 or authentication error

**Solutions:**
1. Verify `ENTRA_TENANT_ID` is correct (from Azure Portal)
2. Verify `ENTRA_CLIENT_ID` is correct
3. **Check client secret:**
   - Secret may have been truncated when copying
   - Regenerate a new secret in Azure Portal
   - Update environment variable immediately
4. Verify OAuth endpoint URL:
   - Should be: `https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token`
   - NOT: `.../oauth2/token` (v1 endpoint)

### Issue 2: "Insufficient Privileges" Error
**Symptoms:** Get Users succeeds but enrichment calls fail

**Solutions:**
1. Go to Azure Portal → App Registration → API permissions
2. Verify **Admin Consent** was granted (green checkmarks)
3. If not granted, click **"Grant admin consent for [Your Org]"**
4. Wait 5-10 minutes for permissions to propagate
5. Try workflow again

### Issue 3: Pagination Not Working
**Symptoms:** Only getting 999 users when you have more

**Solutions:**
1. Check "Handle Pagination" node output
2. Verify `@odata.nextLink` is being detected
3. Check for rate limit errors in logs
4. Add delays between pagination calls (already in code)

### Issue 4: Data Not Appearing in Table
**Symptoms:** Workflow succeeds but no data in UserAudit table

**Solutions:**
1. Check "Store in Data Table" node configuration
2. Verify table name is exactly **"UserAudit"** (case-sensitive)
3. Check column names match exactly (case-sensitive)
4. Try changing operation to **"Insert"** temporarily for testing
5. Check for error messages in "Store in Data Table" execution log

### Issue 5: MFA Status Always False
**Symptoms:** All users show `mfa_enabled: false`

**Solutions:**
1. Check "Get Authentication Methods" node output
2. Verify you have permissions to read authentication methods
3. Some tenants may restrict this data
4. May need `UserAuthenticationMethod.Read.All` permission

### Issue 6: No License Data
**Symptoms:** `licenses` field is always empty array

**Solutions:**
1. Check "Get License Details" node output
2. Verify users actually have licenses assigned
3. May need additional Graph API permission
4. Some license types may not be visible via API

### Issue 7: Sign-In Activity Empty
**Symptoms:** `last_login` is always null

**Solutions:**
1. **Azure AD Premium P1/P2 Required** for sign-in activity
2. If you don't have Premium, disable "Get Sign-In Activity" node:
   - It's already disabled by default
   - Sign-in data won't be available
3. Alternative: Check Azure Portal audit logs manually

---

## 📊 Expected Results

### Data Volume
- **Small tenant:** 10-50 users (runtime: ~2-5 minutes)
- **Medium tenant:** 50-500 users (runtime: ~5-15 minutes)
- **Large tenant:** 500+ users (runtime: ~15-30 minutes)

### Data Quality
- **100%** users should have: source_platform, user_id, username, email, display_name
- **90-95%** should have: first_name, last_name, account_enabled, account_created
- **70-80%** should have: MFA status (depends on your MFA adoption)
- **50-70%** should have: roles (many users have no directory roles)
- **Variable** license data (depends on license assignments)
- **Requires Premium** last_login (sign-in activity)

---

## 🔄 Ongoing Maintenance

### Daily
- Monitor workflow execution log for errors
- Check success/error notifications

### Weekly
- Verify data table record count matches expected user count
- Spot-check a few users for data accuracy

### Monthly
- Review MFA adoption rate
- Check for orphaned/stale accounts
- Review role assignments

### Every 6 Months
- Test workflow manually to ensure still working
- Review and update API permissions if needed
- Check for Microsoft Graph API changes

### Before Client Secret Expiry (24 months)
- Generate new client secret in Azure Portal
- Update `ENTRA_CLIENT_SECRET` environment variable
- Test workflow with new secret
- Delete old secret from Azure Portal

---

## 📈 Next Steps After Entra ID is Working

1. ✅ **Entra ID workflow complete**
2. ⏭️ **Week 3:** Build Keeper Security workflow
3. ⏭️ **Week 4:** Build ConnectSecure workflow
4. ⏭️ **Week 4:** Create basic reports
5. ⏭️ **Future:** Expand to remaining 13 platforms

---

## 📞 Support Resources

### Microsoft Documentation
- **Graph API Users:** https://learn.microsoft.com/en-us/graph/api/user-list
- **App Registration:** https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app
- **API Permissions:** https://learn.microsoft.com/en-us/graph/permissions-reference

### Testing Tools
- **Graph Explorer:** https://developer.microsoft.com/en-us/graph/graph-explorer
  - Test API calls before implementing in n8n
  - Sign in with your admin account
  - Try GET https://graph.microsoft.com/v1.0/users

### n8n Documentation
- **HTTP Request Node:** https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/
- **Code Node:** https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.code/
- **Data Table:** https://docs.n8n.io/ (search for data table)

---

## ✅ Completion Criteria

You can mark Entra ID integration as complete when:

- [ ] Workflow runs successfully end-to-end
- [ ] All users from your tenant are collected
- [ ] Data is stored correctly in UserAudit table
- [ ] Upsert is working (no duplicates on re-run)
- [ ] Scheduled trigger is enabled and working
- [ ] First automated run completed successfully
- [ ] Notifications configured (if desired)
- [ ] No errors in execution log for 2-3 runs

**Estimated Time:**
- **Setup:** 30-40 minutes
- **Testing:** 20-30 minutes
- **Total:** ~1 hour

---

*Last Updated: 2025-12-17*
*Workflow Version: 1.0*
*Status: Ready for Import*
