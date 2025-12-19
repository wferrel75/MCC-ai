# Datto RMM Software Inventory Workflow - Setup Guide

## Workflow Created

**Name:** Datto RMM Software Inventory Sync
**ID:** `7FvKqNxhnkKOnIHl`
**Status:** Inactive (ready for configuration)
**Node Count:** 15 nodes

## What This Workflow Does

This workflow automatically:
1. Authenticates with the Datto RMM API
2. Retrieves all devices for a specified site
3. Queries software inventory for each device
4. Transforms the data into a structured format
5. Stores results in an n8n Data Table
6. Generates a summary report

## Prerequisites

### 1. Datto RMM Authentication Workflow

✅ **Authentication workflow is already configured and active**

**Workflow Name:** `Datto RMM - Get API Key`
**Workflow ID:** `wXUfFK5UwsXu21j0`

This workflow handles all Datto RMM authentication. No need to configure credentials separately for this workflow.

**To verify authentication workflow:**
1. Open n8n → Workflows
2. Search for "Datto RMM - Get API Key"
3. Verify it's active (green toggle)

### 2. Site UID

✅ You need to know your Site UID

**Default Site UID** (configured in auth workflow):
```
ea514805-d152-4bd4-a3f1-8de6e4b603d4
```

**How to get your Site UID:**
```powershell
# Using PowerShell and DattoRMM module
Import-Module DattoRMM
Set-DrmmApiParameters -Url "YOUR_API_URL" -Key "YOUR_KEY" -SecretKey "YOUR_SECRET"
$sites = Get-DrmmAccountSites
$sites | Select-Object name, uid
```

Or via API:
```bash
# Get all sites
curl -X GET "https://YOUR-PLATFORM-api.centrastage.net/api/v2/account/sites" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 2. n8n Data Table Setup

**IMPORTANT:** The data table must be created before running the workflow.

**Method 1: Import from CSV (Recommended)**

1. Locate the file: `Datto_Software_Inventory_table_setup.csv` (in this directory)
2. Open n8n UI → **Settings** → **Data Tables**
3. Click **Import from CSV**
4. Upload the CSV file
5. Table name: `Datto_Software_Inventory`
6. Set **Matching Columns** (for upserts):
   - DeviceUID
   - SoftwareName
   - SoftwareVersion
7. Click **Import**

**Method 2: Manual Creation**

1. Open n8n UI
2. Go to **Settings** → **Data Tables**
3. Click **Create Data Table**
4. Name: `Datto_Software_Inventory`
5. Add the following columns:

| Column Name | Type | Description |
|-------------|------|-------------|
| SiteUID | String | Site unique identifier |
| DeviceUID | String | Device unique identifier |
| DeviceHostname | String | Device hostname |
| DeviceType | String | Device type (Workstation, Server, etc.) |
| OperatingSystem | String | Operating system name |
| DeviceOnline | Boolean | Device online status |
| SoftwareName | String | Software application name |
| SoftwareVersion | String | Software version number |
| LastAuditDate | DateTime | Last Datto audit timestamp |
| SyncedAt | DateTime | Sync timestamp |

6. Set **Matching Columns** (for upserts):
   - DeviceUID
   - SoftwareName
   - SoftwareVersion

7. Click **Save**

### 3. Site UID Configuration (Optional)

You can optionally set an environment variable to override the default site UID:

**Method 1: n8n UI**
1. Go to **Settings** → **Variables**
2. Add the following variable:

```
DATTO_SITE_UID=your_site_uid_here
```

**Method 2: Docker Environment Variables**
```yaml
# docker-compose.yml
environment:
  - DATTO_SITE_UID=your_site_uid_here
```

**Method 3: .env File**
```bash
# .env
DATTO_SITE_UID=your_site_uid_here
```

**If not set:** The workflow will use the default site UID from the auth workflow (`ea514805-d152-4bd4-a3f1-8de6e4b603d4`)

## Workflow Architecture

### Node Flow

```
Manual Trigger
    ↓
Get Datto Auth (calls sub-workflow "Datto RMM - Get API Key")
    ↓
Set Site UID (extract auth data + set site UID)
    ↓
Get Site Devices (retrieve all devices for site)
    ↓
Extract Device List (prepare data for loop)
    ↓
Split Into Batches (process 10 devices at a time)
    ↓
Loop Through Devices
    ↓
Get Device Software (API call per device)
    ↓
Check Software Exists (validate response)
    ├─ Yes → Transform Software Data
    │         ↓
    │      Wait (Rate Limit) - 200ms delay
    │         ↓
    │      ← Loop back to Split Into Batches
    │
    └─ No → Skip (continue to next device)
            ↓
         ← Loop back to Split Into Batches

After all devices processed:
    ↓
Aggregate All Results
    ↓
Upsert to Data Table
    ↓
Generate Summary
```

### Key Features

**Rate Limiting:**
- Processes devices in batches of 10
- 200ms wait between requests
- Respects Datto's 600 req/60sec limit

**Error Handling:**
- `neverError: true` on API requests
- Conditional check for software existence
- Skips devices with no software gracefully

**Data Transformation:**
- Normalizes device and software data
- Adds sync timestamp
- Handles missing/null values

**Upsert Logic:**
- Updates existing records
- Inserts new software entries
- Uses composite key: DeviceUID + SoftwareName + SoftwareVersion

## Testing the Workflow

### 1. Manual Test Run

1. Open the workflow in n8n UI
2. Click **Execute Workflow** button
3. Monitor execution in real-time
4. Check for errors in each node

**Expected Results:**
- ✅ Authentication successful (access token received)
- ✅ Devices retrieved (device count shown)
- ✅ Software data collected per device
- ✅ Data upserted to table
- ✅ Summary generated

### 2. Verify Data Table

After workflow execution:

1. Go to **Data Tables** → `Datto_Software_Inventory`
2. Verify records exist
3. Check data quality:
   - Device names populated
   - Software names not "Unknown"
   - Versions present
   - Sync timestamps current

### 3. Test with Limited Devices

For initial testing, you can modify the batch size:

1. Open workflow
2. Find **"Split Into Batches"** node
3. Change `batchSize` from `10` to `5` (smaller batches)
4. Run workflow

Or limit devices in **"Get Site Devices"** node:
- Change URL parameter `?max=100` to `?max=10`

## Activating the Workflow

### Schedule-Based Execution

1. Delete the **"Manual Trigger"** node
2. Add a **"Schedule Trigger"** node:
   - **Trigger Interval:** Custom (Cron)
   - **Cron Expression:** `0 2 * * *` (Daily at 2 AM)
3. Connect to **"Load Datto Credentials"**
4. Click **Activate** toggle

### Webhook-Based Execution

1. Delete the **"Manual Trigger"** node
2. Add a **"Webhook"** node:
   - **HTTP Method:** POST
   - **Path:** `datto-sync-software`
3. Connect to **"Load Datto Credentials"**
4. Click **Activate** toggle

**Trigger URL:**
```
https://your-n8n-instance.com/webhook/datto-sync-software
```

**Test with curl:**
```bash
curl -X POST https://your-n8n-instance.com/webhook/datto-sync-software
```

## Monitoring and Alerts

### Add Slack Notification (Optional)

After **"Generate Summary"** node:

1. Add **Slack** node
2. Configure:
   - **Resource:** Message
   - **Operation:** Post
   - **Channel:** #it-reports
   - **Text:**
   ```
   🔄 *Datto Software Inventory Sync Complete*

   • Total Devices: {{ $json.totalDevices }}
   • Software Entries: {{ $json.totalSoftwareEntries }}
   • Avg per Device: {{ $json.averagePerDevice }}
   • Sync Time: {{ $json.syncTime }}
   ```

### Add Email Notification (Optional)

After **"Generate Summary"** node:

1. Add **Send Email** node
2. Configure:
   - **To:** admin@example.com
   - **Subject:** Datto Software Inventory Sync - {{ $json.syncTime }}
   - **Text:** (same as Slack format)

## Troubleshooting

### Error: "Authentication failed"

**Cause:** Invalid API credentials in the auth sub-workflow

**Solution:**
1. Open workflow "Datto RMM - Get API Key" (ID: `wXUfFK5UwsXu21j0`)
2. Check the **Variables** node for correct credentials
3. Verify API key/secret in Datto portal
4. Regenerate credentials in Datto if needed
5. Update credentials in the auth workflow's Variables node
6. Ensure API access is enabled in Datto portal

### Error: "Site not found"

**Cause:** Invalid Site UID

**Solution:**
1. Verify `DATTO_SITE_UID` environment variable
2. Get correct UID from Datto portal or API
3. Update environment variable
4. Restart n8n if using docker

### Error: "Rate limit exceeded"

**Cause:** Too many API requests

**Solution:**
1. Increase wait time in **"Wait (Rate Limit)"** node (0.2 → 0.5 seconds)
2. Reduce batch size in **"Split Into Batches"** (10 → 5)
3. Wait 60 seconds and retry

### Error: "Data table not found"

**Cause:** Table `Datto_Software_Inventory` doesn't exist

**Solution:**
1. Create data table manually (see Prerequisites)
2. Verify exact table name spelling
3. Check matching columns are configured

### Error: "Unrecognized node type: n8n-nodes-base.n8nTable"

**Cause:** Incorrect node type (workflow has been fixed)

**Solution:**
✅ This has been fixed. The workflow now uses the correct node type: `n8n-nodes-base.dataTable`

If you see this error:
1. Re-import/update the workflow
2. The "Upsert to Data Table" node should be type `dataTable` not `n8nTable`

### Workflow hangs during execution

**Cause:** Wait node or loop issue

**Solution:**
1. Check **"Wait (Rate Limit)"** node settings
2. Verify resume method is set to "webhook"
3. Check workflow execution logs
4. Restart workflow execution

### No software data returned

**Cause:** Devices have no software audit data

**Possible Reasons:**
1. Devices offline during audit
2. Audit not yet completed
3. Device class is not "device" (printer/ESXi host)

**Solution:**
1. Run Datto audit manually for test device
2. Wait for scheduled audit to complete
3. Check device class in Datto portal

## Performance Optimization

### For Large Environments (100+ devices)

**1. Increase Batch Size**
```javascript
// Split Into Batches node
batchSize: 20  // Process 20 devices at a time
```

**2. Reduce Wait Time**
```javascript
// Wait (Rate Limit) node
amount: 0.1  // 100ms instead of 200ms
```

**3. Run During Off-Hours**
```
Schedule: 2:00 AM - 6:00 AM
(After Datto audits complete, before business hours)
```

### For Small Environments (<50 devices)

**1. Decrease Batch Size**
```javascript
batchSize: 5  // Smaller batches
```

**2. Run More Frequently**
```
Schedule: Daily or every 12 hours
```

## Data Usage Examples

### Query Software Inventory

**Find all Office installations:**
```sql
SELECT DeviceHostname, SoftwareVersion, OperatingSystem
FROM Datto_Software_Inventory
WHERE SoftwareName LIKE '%Microsoft Office%'
ORDER BY DeviceHostname
```

**Find outdated Chrome versions:**
```sql
SELECT DeviceHostname, SoftwareVersion, DeviceOnline, LastAuditDate
FROM Datto_Software_Inventory
WHERE SoftwareName = 'Google Chrome'
  AND CAST(SUBSTRING(SoftwareVersion, 1, 3) AS INTEGER) < 120
ORDER BY SoftwareVersion
```

**Device count by software:**
```sql
SELECT
  SoftwareName,
  SoftwareVersion,
  COUNT(DISTINCT DeviceUID) as DeviceCount
FROM Datto_Software_Inventory
GROUP BY SoftwareName, SoftwareVersion
ORDER BY DeviceCount DESC
```

### Export to CSV

**Via n8n workflow:**

Add after **"Upsert to Data Table"**:

1. **Read from Data Table** node
   - Table: Datto_Software_Inventory
2. **Convert to File** node
   - Format: CSV
3. **Move Binary Data** node
   - Save to FTP/SFTP/SharePoint

## Multi-Site Support

### Option 1: Duplicate Workflow

1. Duplicate this workflow
2. Change `DATTO_SITE_UID` environment variable
3. Activate both workflows

### Option 2: Loop Through Sites

Modify workflow to process multiple sites:

1. After **"Load Datto Credentials"**, add:
   - **Get All Sites** (HTTP Request to `/v2/account/sites`)
2. Add **"Split In Batches"** for sites
3. Modify **"Get Site Devices"** to use current site UID from loop

## Maintenance

### Weekly Tasks
- ✅ Check execution logs for errors
- ✅ Verify data table size is reasonable
- ✅ Compare record count with Datto portal

### Monthly Tasks
- ✅ Review and optimize batch sizes
- ✅ Archive old sync data (if needed)
- ✅ Update API credentials if rotated

### Quarterly Tasks
- ✅ Review Datto API changes/updates
- ✅ Test workflow with new devices
- ✅ Optimize data table indexes

## Support and Resources

**Workflow Details:**
- Workflow ID: `7FvKqNxhnkKOnIHl`
- Location: n8n → Workflows → "Datto RMM Software Inventory Sync"

**Documentation:**
- This Guide: `/n8n-workflows/DattoRMM/WORKFLOW_SETUP_GUIDE.md`
- Implementation Guide: `/n8n-workflows/DattoRMM/SOFTWARE_INVENTORY_GUIDE.md`
- PowerShell Alternative: `/powershell/DattoRMM-API/Get-SiteSoftwareInventory.ps1`

**External Resources:**
- Datto RMM API Docs: https://rmm.datto.com/help/en/Content/2SETUP/APIv2.htm
- n8n Documentation: https://docs.n8n.io
- DattoRMM PowerShell Module: https://github.com/aaronengels/DattoRMM

## Next Steps

1. ✅ Create data table in n8n
2. ✅ Configure environment variables
3. ✅ Test workflow manually
4. ✅ Verify data in table
5. ✅ Activate workflow with schedule
6. ✅ Set up notifications (optional)
7. ✅ Document for team

---

**Last Updated:** 2025-01-18
**Workflow Version:** 1.0
**Author:** MCC MSP Operations Team
