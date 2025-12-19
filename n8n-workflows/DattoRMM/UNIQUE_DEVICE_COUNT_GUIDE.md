# Datto Software Inventory - Unique Device Count

## Workflow Overview

**Name:** Datto Software Inventory - Unique Device Count
**ID:** `R956RZEiVCAOcoXV`
**Purpose:** Count unique devices from the Datto Software Inventory data table

## What This Workflow Does

This workflow:
1. Reads all records from the `Datto_Software_Inventory` data table
2. Extracts unique device hostnames
3. Calculates statistics:
   - Total software records
   - Number of unique devices
   - Average software applications per device
4. Provides a sorted list of all unique device hostnames

## Quick Start (30 seconds)

1. Open n8n → Workflows
2. Search for "Datto Software Inventory - Unique Device Count"
3. Click **Execute Workflow**
4. View results in the "Format Report" node

## Workflow Architecture

```
Manual Trigger
    ↓
Read Software Inventory Table (all records)
    ↓
Count Unique Devices (JavaScript)
    ↓
Format Report (generate summary)
```

## Output Format

The workflow outputs a JSON object with:

```json
{
  "summary": {
    "totalSoftwareRecords": 1234,
    "uniqueDeviceCount": 25,
    "averageSoftwarePerDevice": 49.4
  },
  "devices": [
    "DEVICE-001",
    "DEVICE-002",
    "SERVER-01",
    ...
  ],
  "generatedAt": "2025-12-19T12:00:00.000Z"
}
```

## Use Cases

### 1. Quick Device Count
Get the total number of devices being monitored:
```
uniqueDeviceCount: 25
```

### 2. Software Density Analysis
See how many applications on average each device has:
```
averageSoftwarePerDevice: 49.4
```

### 3. Device Inventory List
Export all unique device hostnames:
```
devices: ["DEVICE-001", "DEVICE-002", ...]
```

## Extending This Workflow

### Add Device Details

Modify the "Count Unique Devices" node to include more details:

```javascript
// Current output: just hostnames
devices: ["DEVICE-001", "DEVICE-002"]

// Enhanced output: include device info
devices: [
  {
    hostname: "DEVICE-001",
    deviceType: "Workstation",
    operatingSystem: "Windows 10 Pro",
    isOnline: true,
    siteUid: "ea514805-d152-4bd4-a3f1-8de6e4b603d4"
  }
]
```

### Group by Site

Add a node after "Count Unique Devices" to group by SiteUID:

```javascript
const items = $input.all();
const bySite = {};

for (const item of items) {
  const site = item.json.SiteUID;
  if (!bySite[site]) {
    bySite[site] = new Set();
  }
  bySite[site].add(item.json.DeviceHostname);
}

// Convert Sets to counts
const siteStats = {};
for (const [site, devices] of Object.entries(bySite)) {
  siteStats[site] = {
    deviceCount: devices.size,
    devices: Array.from(devices).sort()
  };
}

return [{ json: { siteStats } }];
```

### Export to CSV

Add after "Format Report":
1. **Code** node to convert to CSV format
2. **Write Binary File** node to save CSV
3. Or **Send Email** node to email the report

## Scheduling

To run this automatically:

1. Replace "Manual Trigger" with "Schedule Trigger"
2. Set schedule:
   - **Hourly:** `0 * * * *`
   - **Daily at 8 AM:** `0 8 * * *`
   - **Weekly Monday 9 AM:** `0 9 * * 1`

## Performance

### Data Volume Estimates

| Records | Devices | Processing Time |
|---------|---------|-----------------|
| 1,000   | 20      | ~1 second       |
| 10,000  | 200     | ~2 seconds      |
| 50,000  | 500     | ~5 seconds      |
| 100,000 | 1,000   | ~10 seconds     |

### Optimization Tips

**For Large Tables (100K+ records):**
1. Add limit to "Read Software Inventory Table" if testing
2. Use pagination if memory is an issue
3. Consider running during off-peak hours

## Troubleshooting

### Error: "Data table not found"

**Cause:** Table `Datto_Software_Inventory` doesn't exist

**Solution:**
1. Verify table exists in n8n → Data Tables
2. Run the "Datto RMM Software Inventory Sync" workflow first
3. Check table ID matches in "Read Software Inventory Table" node

### No output or empty results

**Cause:** Table is empty

**Solution:**
1. Run "Datto RMM Software Inventory Sync" workflow
2. Wait for sync to complete
3. Verify data exists in table
4. Re-run this workflow

### Performance is slow

**Cause:** Large dataset

**Solution:**
1. Add limit parameter: `options: { limit: 1000 }`
2. Filter by recent records only (add WHERE clause)
3. Run during off-peak hours

## Integration Examples

### Send to Slack

After "Format Report", add **Slack** node:

```
Message:
📊 *Device Inventory Summary*

• Total Devices: {{ $json.summary.uniqueDeviceCount }}
• Software Records: {{ $json.summary.totalSoftwareRecords }}
• Avg Software/Device: {{ $json.summary.averageSoftwarePerDevice }}

Generated: {{ $json.generatedAt }}
```

### Update Dashboard

After "Format Report", add **HTTP Request** node:
- Method: POST
- URL: Your dashboard API endpoint
- Body: `{{ $json }}`

### Store Historical Data

After "Format Report", add **Data Table** node:
- Operation: Insert
- Table: `Device_Count_History`
- Columns:
  - Date: `{{ $json.generatedAt }}`
  - DeviceCount: `{{ $json.summary.uniqueDeviceCount }}`
  - RecordCount: `{{ $json.summary.totalSoftwareRecords }}`

## Related Workflows

- **Datto RMM Software Inventory Sync** - Populates the source data
- **Datto Site Selector** - Select site for inventory sync

## Next Steps

1. ✅ Run the workflow to see current device count
2. ✅ Review the output format
3. ✅ Consider scheduling for regular reports
4. ✅ Add integrations (Slack, email, etc.)
5. ✅ Export device list if needed

---

**Created:** 2025-12-19
**Workflow Version:** 1.0
**Author:** MCC MSP Operations Team
