# Datto RMM Software Inventory - Implementation Guide

## Overview

This guide explains how to pull an expanded software inventory from Datto RMM that links specific applications to individual devices, replacing the default aggregate report that only shows total device counts per software title.

## The Problem

**Default Datto Report:**
- Shows: "Microsoft Office - 25 devices"
- Doesn't show: Which specific 25 devices have Microsoft Office

**What You Need:**
- List of software with device names
- Ability to export as external data
- Queryable dataset for customer reports

## The Solution

Use the Datto RMM API to build a custom dataset that maps software to specific devices.

## API Endpoints Used

### 1. Get Site Devices
```http
GET /v2/site/{siteUid}/devices
Authorization: Bearer {access_token}
```

**Returns:**
- Device UID, hostname, operating system, online status, etc.
- Supports pagination: `?page=1&max=100`
- Can filter with `filterId` parameter

### 2. Get Device Software
```http
GET /v2/audit/device/{deviceUid}/software
Authorization: Bearer {access_token}
```

**Returns:**
- Software name
- Software version
- Paginated results: `?page=1&max=100`

## Implementation Methods

### Method 1: PowerShell Script (Immediate)

**Use the included script:**
```powershell
.\Get-SiteSoftwareInventory.ps1 -SiteUid "your-site-uid"
```

**Output:** CSV file with columns:
- SiteName
- DeviceHostname
- DeviceUID
- SoftwareName
- SoftwareVersion
- OperatingSystem
- DeviceOnline
- LastAuditDate

**Advantages:**
- Quick to implement
- Runs on-demand
- Easy to schedule with Windows Task Scheduler
- Direct CSV export for Excel/reporting tools

**Usage Examples:**
```powershell
# Basic usage
.\Get-SiteSoftwareInventory.ps1 -SiteUid "abc-123-def-456"

# Custom output location
.\Get-SiteSoftwareInventory.ps1 -SiteUid "abc-123-def-456" -OutputPath "C:\Reports\CustomerA_Software.csv"

# Test with limited devices
.\Get-SiteSoftwareInventory.ps1 -SiteUid "abc-123-def-456" -MaxDevices 10
```

### Method 2: n8n Workflow (Automated)

**Workflow Design:**

```
[Schedule Trigger]
    ↓
[Load Datto Credentials]
    ↓
[Authenticate with Datto API]
    ↓
[Get Site Devices]
    ↓
[Loop: For Each Device]
    ↓
    [Get Device Software Inventory]
    ↓
    [Transform Data]
    ↓
[Merge All Results]
    ↓
[Upsert to Data Table: "Datto_Software_Inventory"]
    ↓
[Send Summary Notification]
```

**Data Table Schema:**
```javascript
{
  columns: [
    { name: "SiteUID", type: "string" },
    { name: "SiteName", type: "string" },
    { name: "DeviceUID", type: "string" },
    { name: "DeviceHostname", type: "string" },
    { name: "DeviceType", type: "string" },
    { name: "OperatingSystem", type: "string" },
    { name: "DeviceOnline", type: "boolean" },
    { name: "SoftwareName", type: "string" },
    { name: "SoftwareVersion", type: "string" },
    { name: "LastAuditDate", type: "datetime" },
    { name: "SyncedAt", type: "datetime" }
  ],
  // Use composite key for upserts
  matchingColumns: ["DeviceUID", "SoftwareName", "SoftwareVersion"]
}
```

**Advantages:**
- Fully automated (runs on schedule)
- Data stored in n8n Data Table for querying
- Can trigger notifications or downstream workflows
- Integration with other n8n workflows
- Web UI for manual triggers

**Scheduling Recommendations:**
- Daily sync at night (Datto audits typically run overnight)
- Weekly for stable environments
- On-demand for audits/assessments

### Method 3: Direct API Integration (Custom Application)

If you're building a custom reporting tool or dashboard:

**Authentication Flow:**
```javascript
// 1. Authenticate
const authResponse = await fetch('https://your-platform-api.centrastage.net/api/v2/auth/authenticate', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    apiKey: 'YOUR_API_KEY',
    apiSecretKey: 'YOUR_SECRET_KEY'
  })
});

const { accessToken } = await authResponse.json();

// 2. Get devices
const devicesResponse = await fetch(`https://your-platform-api.centrastage.net/api/v2/site/${siteUid}/devices`, {
  headers: {
    'Authorization': `Bearer ${accessToken}`
  }
});

const devices = await devicesResponse.json();

// 3. Get software for each device
const softwareInventory = [];

for (const device of devices.devices) {
  let page = 1;
  let hasMore = true;

  while (hasMore) {
    const softwareResponse = await fetch(
      `https://your-platform-api.centrastage.net/api/v2/audit/device/${device.uid}/software?page=${page}&max=100`,
      {
        headers: {
          'Authorization': `Bearer ${accessToken}`
        }
      }
    );

    const softwarePage = await softwareResponse.json();

    if (softwarePage.software && softwarePage.software.length > 0) {
      // Add software to inventory with device details
      softwarePage.software.forEach(software => {
        softwareInventory.push({
          siteName: device.siteName,
          deviceHostname: device.hostname,
          deviceUid: device.uid,
          softwareName: software.name,
          softwareVersion: software.version,
          operatingSystem: device.operatingSystem,
          deviceOnline: device.online,
          lastAuditDate: device.lastAuditDate
        });
      });

      // Check if there are more pages
      hasMore = softwarePage.software.length === 100;
      page++;
    } else {
      hasMore = false;
    }
  }

  // Add delay to respect rate limits (600 requests per 60 seconds)
  await sleep(150); // ~6 requests per second = 360 per minute
}

// Export or store the data
console.log(`Collected ${softwareInventory.length} software entries from ${devices.devices.length} devices`);
```

## Use Cases

### 1. License Compliance Audits
**Query:** "Show me all devices with Microsoft Office installed"
```sql
SELECT DeviceHostname, SoftwareVersion, OperatingSystem
FROM Datto_Software_Inventory
WHERE SoftwareName LIKE '%Microsoft Office%'
ORDER BY DeviceHostname
```

### 2. Software Version Tracking
**Query:** "Find all devices running outdated Chrome versions"
```sql
SELECT DeviceHostname, SoftwareVersion, LastAuditDate
FROM Datto_Software_Inventory
WHERE SoftwareName = 'Google Chrome'
  AND SoftwareVersion < '120.0'
ORDER BY SoftwareVersion
```

### 3. Customer Reporting
**Query:** "Generate software inventory for specific customer"
```sql
SELECT
  SoftwareName,
  SoftwareVersion,
  COUNT(*) as DeviceCount,
  GROUP_CONCAT(DeviceHostname) as Devices
FROM Datto_Software_Inventory
WHERE SiteName = 'Customer A'
GROUP BY SoftwareName, SoftwareVersion
ORDER BY SoftwareName
```

### 4. Asset Management Integration
Export the dataset to:
- Excel/Google Sheets for customer sharing
- IT asset management platforms
- Compliance reporting tools
- Custom dashboards

## Performance Considerations

### API Rate Limits
- **Limit:** 600 requests per 60 seconds per account
- **Throttling:** Delays introduced at 90% quota (540 requests)
- **Best Practice:** Add 100-150ms delay between requests

### Optimization Strategies

**For Large Environments (100+ devices):**
```powershell
# Process in batches
$batchSize = 50
$devices | ForEach-Object -Parallel {
    Get-DrmmAuditDeviceSoftware -deviceUid $_.uid
} -ThrottleLimit $batchSize
```

**For n8n Workflows:**
- Use "Split In Batches" node (batch size: 50)
- Add "Wait" node between batches (1 second)
- Enable "Continue on Fail" for resilience

### Data Volume Estimates
- Average device: 50-150 software titles
- 100 devices = 5,000-15,000 records
- CSV size: ~1-3 MB for 100 devices
- Database: Plan for 100-200 KB per device

## Error Handling

### Common Issues

**1. Authentication Failures (401)**
```
Error: Request can not be authorized
Solution: Re-generate API keys or check token expiration
```

**2. Device Not Found (404)**
```
Error: Device was not found
Solution: Device may have been deleted - update device list first
```

**3. Rate Limit Exceeded (429)**
```
Error: Too Many Requests
Solution: Add delays, reduce concurrent requests, wait 60 seconds
```

**4. Device Class Mismatch (400)**
```
Error: Device is not of class 'device'
Solution: Skip printers/ESXi hosts - only query class='device'
```

### PowerShell Error Handling
```powershell
try {
    $software = Get-DrmmAuditDeviceSoftware -deviceUid $device.uid
} catch {
    if ($_.Exception.Response.StatusCode -eq 429) {
        Write-Warning "Rate limit hit, waiting 60 seconds..."
        Start-Sleep -Seconds 60
        # Retry
        $software = Get-DrmmAuditDeviceSoftware -deviceUid $device.uid
    } elseif ($_.Exception.Response.StatusCode -eq 400) {
        Write-Warning "Skipping non-device: $($device.hostname)"
    } else {
        Write-Error "Failed to get software for $($device.hostname): $_"
    }
}
```

## Data Maintenance

### Recommended Practices

**1. Regular Syncs**
- Schedule: Daily at 2 AM (after Datto audits complete)
- Retention: Keep 30 days of historical data for trending

**2. Data Cleanup**
- Remove entries for deleted devices weekly
- Archive old versions to separate table monthly

**3. Validation**
- Compare record counts against Datto portal
- Flag devices with 0 software (audit failures)
- Alert on significant changes (±20% devices)

## Integration Examples

### Export to Customer Portal
```powershell
# After generating report, upload to SharePoint/FTP
$reportPath = ".\SoftwareInventory_20250118.csv"
$customerPortal = "https://portal.customer.com/uploads"

Invoke-RestMethod -Uri $customerPortal `
    -Method Post `
    -InFile $reportPath `
    -Headers @{ "Authorization" = "Bearer $customerToken" }
```

### Slack Notification
```javascript
// n8n Slack node after data sync
{
  "channel": "#it-reports",
  "text": "🔄 Software Inventory Sync Complete",
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": `*Software Inventory Updated*\n• Devices: ${deviceCount}\n• Software Entries: ${softwareCount}\n• Last Sync: ${syncTime}`
      }
    }
  ]
}
```

### Ticket Creation for Outdated Software
```javascript
// n8n workflow: Query for old versions, create Zoho tickets
const outdatedSoftware = await query(`
  SELECT * FROM Datto_Software_Inventory
  WHERE SoftwareName = 'Java'
    AND CAST(SoftwareVersion AS FLOAT) < 8.0
`);

for (const entry of outdatedSoftware) {
  // Create Zoho ticket
  await createZohoTicket({
    subject: `Outdated Java on ${entry.DeviceHostname}`,
    description: `Device has Java ${entry.SoftwareVersion}, needs update to 8.0+`,
    priority: 'Medium',
    customerSite: entry.SiteName
  });
}
```

## Next Steps

1. **Immediate:** Run PowerShell script to test the concept
2. **Short-term:** Build n8n workflow for automated syncing
3. **Long-term:** Integrate with reporting tools and customer portals

## Support Resources

- **Datto RMM API Docs:** https://rmm.datto.com/help/en/Content/2SETUP/APIv2.htm
- **PowerShell Module:** https://github.com/aaronengels/DattoRMM
- **MCC Datto Scripts:** `/powershell/DattoRMM-API/`
- **n8n Workflows:** `/n8n-workflows/DattoRMM/`
