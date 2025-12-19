# Datto RMM Software Inventory - Quick Start

## Quick Answer

**Yes!** The Datto RMM API can pull an expanded software list that links applications to specific devices.

## Key API Endpoint

```
GET /v2/audit/device/{deviceUid}/software
```

This returns all software installed on a specific device with name and version.

## Quick Start

### 1. Run the PowerShell Script

```powershell
# Get your site UID from Datto portal or API
.\Get-SiteSoftwareInventory.ps1 -SiteUid "your-site-uid-here"
```

**Output:** CSV file with software linked to specific devices

### 2. CSV Output Format

```csv
SiteName,DeviceHostname,SoftwareName,SoftwareVersion,OperatingSystem,DeviceOnline
"Customer A","WORKSTATION-01","Microsoft Office","16.0.5","Windows 10 Pro",True
"Customer A","WORKSTATION-01","Google Chrome","120.0.1","Windows 10 Pro",True
"Customer A","WORKSTATION-02","Microsoft Office","16.0.5","Windows 10 Pro",True
```

### 3. Prerequisites

✅ Datto RMM API access enabled
✅ API credentials configured (via `dattormm-api-setup.ps1`)
✅ DattoRMM PowerShell module installed

## What This Solves

**Before (Default Report):**
- "Microsoft Office - 25 devices" ❌ (Can't see which devices)

**After (API Method):**
- Device 1: Microsoft Office 16.0.5 ✅
- Device 2: Microsoft Office 16.0.5 ✅
- Device 3: Microsoft Office 15.0.2 ✅

## Use Cases

✅ License compliance audits ("Show all devices with Office")
✅ Version tracking ("Find outdated Chrome installations")
✅ Customer reporting ("Generate inventory for Customer A")
✅ Asset management integration
✅ Export to Excel/reporting tools

## Files in This Package

- `Get-SiteSoftwareInventory.ps1` - Main PowerShell script
- `SOFTWARE_INVENTORY_README.md` - This file
- `/n8n-workflows/DattoRMM/SOFTWARE_INVENTORY_GUIDE.md` - Detailed implementation guide

## Advanced Usage

### Filter by Software Name
After generating the CSV, use Excel/PowerShell to filter:

```powershell
# Import and filter
$inventory = Import-Csv .\SoftwareInventory.csv
$officeDevices = $inventory | Where-Object { $_.SoftwareName -like "*Office*" }
$officeDevices | Export-Csv .\Office_Devices.csv -NoTypeInformation
```

### Schedule Automated Reports
```powershell
# Windows Task Scheduler
# Schedule this script to run daily at 2 AM
# Output saved to network share for customer access
```

## API Rate Limits

⚠️ **Important:** Datto API allows 600 requests per 60 seconds
- The script includes automatic throttling
- For large environments (200+ devices), run during off-hours

## Support

For questions or issues:
1. Check `/n8n-workflows/DattoRMM/SOFTWARE_INVENTORY_GUIDE.md` for detailed documentation
2. Review Datto API docs: https://rmm.datto.com/help/en/Content/2SETUP/APIv2.htm
3. Check existing integration at `/powershell/DattoRMM-API/dattormm-api-README.md`
