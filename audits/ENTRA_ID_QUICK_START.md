# Entra ID Workflow - Quick Start
## Get Running in 1 Hour

---

## ✅ What You Have

- ✅ **n8n data table created:** "UserAudit"
- ✅ **Workflow JSON ready:** `/home/wferrel/ai/audits/workflows/EntraID_User_Audit.json`
- ✅ **Complete setup guide:** `ENTRA_ID_SETUP_GUIDE.md`

---

## 🚀 Quick Setup (3 Steps, ~1 hour)

### Step 1: Azure AD Setup (20 minutes)

#### Create App Registration
```
1. Go to https://portal.azure.com/
2. Azure Active Directory → App registrations → + New registration
3. Name: "MCC-UserAudit-Service"
4. Register
```

#### Save These Values
```
Tenant ID:     ________________________________
Client ID:     ________________________________
Client Secret: ________________________________ (create in Certificates & secrets)
```
⚠️ **Save client secret immediately - you can't view it again!**

#### Grant Permissions
```
API permissions → + Add permission → Microsoft Graph → Application permissions:
  ✓ User.Read.All
  ✓ Directory.Read.All
  ✓ AuditLog.Read.All (optional, requires Premium)

Then click: "Grant admin consent for [Your Org]"
```

---

### Step 2: n8n Configuration (10 minutes)

#### Add Environment Variables
In n8n Settings → Environment, create:
```bash
ENTRA_TENANT_ID = [your tenant ID]
ENTRA_CLIENT_ID = [your client ID]
ENTRA_CLIENT_SECRET = [your client secret]
NOTIFICATION_EMAIL = your-email@midcloudcomputing.com
```

#### Import Workflow
```
1. n8n → Workflows → + Add workflow → Import from File
2. Select: /home/wferrel/ai/audits/workflows/EntraID_User_Audit.json
3. Import
```

---

### Step 3: Test & Activate (30 minutes)

#### Quick Test (5 users)
```
1. In workflow, find "Get Users - First Page" node
2. Edit URL: Change $top=999 to $top=5
3. Click "Execute Workflow"
4. Verify: 5 users appear in UserAudit table
```

#### Full Test (all users)
```
1. Change URL back to $top=999
2. Execute Workflow
3. Wait 5-15 minutes (depends on user count)
4. Check UserAudit table for all users
```

#### Enable Schedule
```
1. Disable "Manual Trigger" node
2. Enable "Schedule Trigger" node (runs daily 2:00 AM)
3. Toggle workflow to "Active"
```

---

## 🎯 Success Checklist

- [ ] App registration created with permissions granted
- [ ] Environment variables configured in n8n
- [ ] Workflow imported successfully
- [ ] Test with 5 users passed
- [ ] Full workflow test passed
- [ ] Data visible in UserAudit table
- [ ] Re-run test passed (no duplicates = upsert working)
- [ ] Schedule enabled and workflow activated

---

## 🐛 Quick Troubleshooting

### Authentication Fails
- Check tenant ID, client ID are correct
- Regenerate client secret (may have been truncated)
- Verify admin consent was granted

### No Data in Table
- Check table name is exactly "UserAudit" (case-sensitive)
- Try "Insert" operation instead of "Upsert" for testing
- Check node execution logs for errors

### Need Help?
See complete guide: `ENTRA_ID_SETUP_GUIDE.md`

---

## 📊 What Happens Next

The workflow will:
1. ✅ Run daily at 2:00 AM automatically
2. ✅ Collect all Entra ID users
3. ✅ Get roles, MFA status, licenses for each user
4. ✅ Store/update in UserAudit table
5. ✅ Send notification (if configured)

---

## ⏭️ After Entra ID Works

**Week 3:** Build Keeper Security workflow
**Week 4:** Build ConnectSecure workflow + reports

---

## 📁 Your Files

```
audits/
├── workflows/
│   └── EntraID_User_Audit.json        ← Import this to n8n
├── ENTRA_ID_SETUP_GUIDE.md            ← Complete detailed guide
└── ENTRA_ID_QUICK_START.md            ← This file
```

---

**Ready? Start with Azure Portal (Step 1)!** 🚀

*Estimated Time: 1 hour total*
*Then you'll have automated daily Entra ID user audits!*
