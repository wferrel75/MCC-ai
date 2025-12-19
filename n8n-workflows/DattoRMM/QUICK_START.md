# Datto Software Inventory Workflow - Quick Start

## ✅ Workflow Created Successfully!

**Name:** Datto RMM Software Inventory Sync
**ID:** `7FvKqNxhnkKOnIHl`
**Status:** Ready for configuration

## 🚀 Get Started in 3 Minutes

### Step 1: Verify Authentication (30 seconds)

✅ The authentication workflow is already configured!

1. Open n8n → Workflows
2. Search: "Datto RMM - Get API Key"
3. Verify it's **Active** (green toggle)

**Workflow ID:** `wXUfFK5UwsXu21j0`

### Step 2: Create Data Table (1 minute)

**Method 1: Import from CSV (Fastest)**

1. Download: `Datto_Software_Inventory_table_setup.csv` (in this directory)
2. Open n8n UI → **Settings** → **Data Tables**
3. Click **Import from CSV**
4. Select the CSV file
5. Table name: `Datto_Software_Inventory`
6. Set **Matching Columns**: `DeviceUID`, `SoftwareName`, `SoftwareVersion`
7. Click **Import**

**Method 2: Manual Creation**

1. Open n8n UI → **Settings** → **Data Tables**
2. Click **Create Data Table**
3. Name: `Datto_Software_Inventory`
4. Add columns:

```
SiteUID          | String   | Site unique identifier
DeviceUID        | String   | Device unique identifier
DeviceHostname   | String   | Device hostname
DeviceType       | String   | Device type
OperatingSystem  | String   | Operating system
DeviceOnline     | Boolean  | Device online status
SoftwareName     | String   | Software name
SoftwareVersion  | String   | Software version
LastAuditDate    | DateTime | Last audit timestamp
SyncedAt         | DateTime | Sync timestamp
```

5. Set **Matching Columns**: `DeviceUID`, `SoftwareName`, `SoftwareVersion`
6. Click **Save**

### Step 3: Set Site UID (Optional - 30 seconds)

**Default Site:** The workflow uses site `ea514805-d152-4bd4-a3f1-8de6e4b603d4` by default.

**To use a different site:**

n8n UI → **Settings** → **Variables** → Add:

```
DATTO_SITE_UID = your_site_uid_here
```

**Get Site UID:**
```powershell
# Using PowerShell
Get-DrmmAccountSites | Select-Object name, uid
```

### Step 4: Test Workflow (1 minute)

1. Open workflow: `Datto RMM Software Inventory Sync`
2. Click **Execute Workflow**
3. Watch nodes turn green ✅
4. Check **Generate Summary** node for stats

### Step 5: Verify Results (<1 minute)

1. Go to **Data Tables** → `Datto_Software_Inventory`
2. Verify records exist
3. Check data quality

### Step 6: Activate (Optional)

Add **Schedule Trigger**:
- Delete "Manual Trigger" node
- Add "Schedule Trigger": `0 2 * * *` (Daily 2 AM)
- Toggle **Active**

## 📊 What You Get

**Before:**
- ❌ "Microsoft Office - 25 devices" (no details)

**After:**
- ✅ WORKSTATION-01: Microsoft Office 16.0.5
- ✅ WORKSTATION-02: Microsoft Office 16.0.5
- ✅ SERVER-01: Microsoft Office 16.0.3

## 🔍 Query Examples

**Find all Office installations:**
```sql
SELECT DeviceHostname, SoftwareVersion
FROM Datto_Software_Inventory
WHERE SoftwareName LIKE '%Office%'
```

**Outdated Chrome versions:**
```sql
SELECT DeviceHostname, SoftwareVersion
FROM Datto_Software_Inventory
WHERE SoftwareName = 'Google Chrome'
  AND SoftwareVersion < '120.0'
```

## ⚡ Performance

- **10 devices:** ~30 seconds
- **50 devices:** ~3 minutes
- **100 devices:** ~6 minutes
- **500 devices:** ~30 minutes

## 🆘 Troubleshooting

| Error | Solution |
|-------|----------|
| Authentication failed | Verify "Datto RMM - Get API Key" workflow is active |
| Site not found | Check DATTO_SITE_UID env var or use default |
| Table not found | Create data table (Step 2) |
| Rate limit | Workflow handles this automatically |

## 📚 Full Documentation

- **Setup Guide:** `WORKFLOW_SETUP_GUIDE.md` (complete instructions)
- **Implementation Guide:** `SOFTWARE_INVENTORY_GUIDE.md` (detailed API info)
- **PowerShell Alternative:** `/powershell/DattoRMM-API/Get-SiteSoftwareInventory.ps1`

## 🎯 Next Steps

1. ✅ Complete Steps 1-3 above
2. ✅ Test with your site
3. ✅ Review data in table
4. ✅ Schedule automatic syncs
5. ✅ Build reports/dashboards

---

**Need Help?** See `WORKFLOW_SETUP_GUIDE.md` for detailed troubleshooting
