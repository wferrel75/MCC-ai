# n8n Data Table Setup Pattern

## Standard Practice

**ALWAYS create a CSV template file for n8n Data Table setup.**

## Why Use CSV Import?

✅ **Faster** - Import creates table structure automatically
✅ **Accurate** - No manual column type errors
✅ **Documented** - CSV serves as schema documentation
✅ **Reproducible** - Easy to recreate tables across environments
✅ **Example Data** - Shows expected data format

## CSV File Naming Convention

```
{TableName}_table_setup.csv
```

**Examples:**
- `Datto_Software_Inventory_table_setup.csv`
- `Customer_Contacts_table_setup.csv`
- `Meraki_Devices_table_setup.csv`

## CSV File Structure

### Headers (Required)
First row contains exact column names as they will appear in n8n.

### Sample Data (Required)
Include 2-3 rows of realistic sample data demonstrating:
- Correct data types
- Expected formats
- Example values

### Data Type Examples

**String:**
```csv
SiteUID,DeviceHostname,OperatingSystem
ea514805-d152-4bd4-a3f1-8de6e4b603d4,WORKSTATION-01,Windows 10 Pro
```

**Boolean:**
```csv
DeviceOnline,IsActive,HasError
true,false,true
```

**DateTime (ISO 8601 format):**
```csv
LastAuditDate,SyncedAt,CreatedAt
2025-01-18T10:30:00.000Z,2025-01-18T15:45:00.000Z,2025-01-18T09:00:00.000Z
```

**Number:**
```csv
DeviceCount,SoftwareVersion,Priority
25,120.0.6099.129,1
```

**JSON (as string):**
```csv
Metadata,CustomFields
"{""key"":""value""}","{""field1"":""data1""}"
```

## Complete Example

### Scenario: Meraki Device Inventory Table

**File:** `Meraki_Devices_table_setup.csv`

```csv
NetworkID,DeviceName,DeviceSerial,DeviceModel,DeviceStatus,LastSeen,Tags,IsOnline,Latitude,Longitude,Address,Notes
L_123456789,MX84-HQ,Q2AB-CDEF-GHIJ,MX84,online,2025-01-18T14:30:00.000Z,"[""HQ"",""Critical""]",true,41.8781,-87.6298,"123 Main St, Chicago, IL",Primary firewall
L_123456789,MS225-SW1,Q2KL-MNOP-QRST,MS225-24P,online,2025-01-18T14:28:00.000Z,"[""HQ"",""Switch""]",true,41.8781,-87.6298,"123 Main St, Chicago, IL",Core switch
L_987654321,MR46-AP1,Q2UV-WXYZ-1234,MR46,offline,2025-01-17T22:15:00.000Z,"[""Branch"",""WiFi""]",false,40.7128,-74.0060,"456 Oak Ave, New York, NY",Needs replacement
```

### Table Schema Inference

From the CSV, n8n will create:

| Column | Type | Inferred From |
|--------|------|---------------|
| NetworkID | String | Text value |
| DeviceName | String | Text value |
| DeviceSerial | String | Text value |
| DeviceModel | String | Text value |
| DeviceStatus | String | Text value |
| LastSeen | DateTime | ISO 8601 format |
| Tags | String | JSON array as string |
| IsOnline | Boolean | true/false values |
| Latitude | Number | Decimal value |
| Longitude | Number | Decimal value |
| Address | String | Text value |
| Notes | String | Text value |

## Workflow Integration

### Step 1: Create CSV During Workflow Development

When designing a workflow that needs a data table:

1. Identify all required columns
2. Determine data types
3. Create CSV file with sample data
4. Save in same directory as workflow

### Step 2: Document in Setup Guide

In workflow documentation, include:

```markdown
### Data Table Setup

**Method 1: Import from CSV (Recommended)**

1. Download: `TableName_table_setup.csv`
2. n8n UI → Settings → Data Tables → Import from CSV
3. Upload the CSV file
4. Set matching columns (for upserts): Column1, Column2
5. Click Import

**Method 2: Manual Creation**
[Include manual steps as backup]
```

### Step 3: Reference in Quick Start

```markdown
## Step 2: Create Data Table (1 minute)

Import `TableName_table_setup.csv` via n8n UI → Settings → Data Tables
```

## Common Patterns

### Pattern 1: Simple Inventory Table

```csv
ID,Name,Quantity,LastUpdated
001,Widget A,150,2025-01-18T10:00:00.000Z
002,Widget B,75,2025-01-18T10:00:00.000Z
```

### Pattern 2: Relationship/Mapping Table

```csv
SourceID,TargetID,RelationType,CreatedAt,IsActive
user-123,group-456,member,2025-01-18T09:00:00.000Z,true
user-789,group-456,admin,2025-01-18T09:05:00.000Z,true
```

### Pattern 3: Time-Series Data

```csv
Timestamp,MetricName,MetricValue,DeviceID,SiteID
2025-01-18T10:00:00.000Z,CPU_Usage,45.2,device-001,site-abc
2025-01-18T10:05:00.000Z,CPU_Usage,52.8,device-001,site-abc
2025-01-18T10:00:00.000Z,Memory_Usage,68.5,device-001,site-abc
```

### Pattern 4: Multi-Tenant Data

```csv
TenantID,TenantName,RecordID,RecordType,RecordData,SyncedAt
tenant-001,Acme Corp,rec-123,contact,"{""name"":""John Doe""}",2025-01-18T10:00:00.000Z
tenant-001,Acme Corp,rec-456,contact,"{""name"":""Jane Smith""}",2025-01-18T10:00:00.000Z
tenant-002,Beta Inc,rec-789,contact,"{""name"":""Bob Jones""}",2025-01-18T10:00:00.000Z
```

## Special Considerations

### Matching Columns (Upserts)

When using upsert operation, document which columns form the unique key:

```markdown
**Matching Columns:** DeviceUID, SoftwareName, SoftwareVersion
```

In CSV, include examples that demonstrate uniqueness:

```csv
DeviceUID,SoftwareName,SoftwareVersion,LastSeen
device-001,Chrome,120.0,2025-01-18T10:00:00.000Z
device-001,Chrome,121.0,2025-01-18T11:00:00.000Z
device-001,Firefox,122.0,2025-01-18T10:00:00.000Z
device-002,Chrome,120.0,2025-01-18T10:00:00.000Z
```

### Large Text Fields

For columns that may contain large text:

```csv
ID,Description,Notes
001,Short description,This is a longer note field that may contain multiple sentences and detailed information about the record.
002,Another item,"Multi-line notes can be included using quotes.
They can span multiple lines if needed.
Just ensure proper CSV escaping."
```

### Null Values

Show how nulls are represented:

```csv
ID,Name,OptionalField,RequiredField
001,Item A,,Value1
002,Item B,Has Value,Value2
003,Item C,,Value3
```

## File Location

Store CSV files in the same directory as the workflow:

```
n8n-workflows/
├── DattoRMM/
│   ├── Datto_Software_Inventory_table_setup.csv
│   ├── WORKFLOW_SETUP_GUIDE.md
│   └── QUICK_START.md
├── Meraki/
│   ├── Meraki_Devices_table_setup.csv
│   └── README.md
└── ConnectSecure/
    ├── CS_Companies_table_setup.csv
    └── README.md
```

## Git Management

### .gitignore Considerations

**DO commit:**
```
*_table_setup.csv
```

**DO NOT commit:**
```
*_production_data.csv
*_backup_*.csv
```

### Naming for Environments

If different schemas needed per environment:

```
TableName_table_setup_dev.csv
TableName_table_setup_staging.csv
TableName_table_setup_prod.csv
```

## Testing

Before finalizing CSV:

1. ✅ Import CSV into test n8n instance
2. ✅ Verify all columns created with correct types
3. ✅ Test workflow with imported table
4. ✅ Verify upsert logic with matching columns
5. ✅ Check data validation rules

## Documentation Checklist

When creating a table setup CSV:

- [ ] CSV file created with descriptive name
- [ ] 2-3 sample rows included
- [ ] All data types represented correctly
- [ ] DateTime fields use ISO 8601 format
- [ ] Boolean fields use true/false (lowercase)
- [ ] Matching columns documented
- [ ] CSV referenced in QUICK_START.md
- [ ] Import instructions in WORKFLOW_SETUP_GUIDE.md
- [ ] File committed to git repository

## Benefits Summary

### For Developers
- ✅ Faster table creation
- ✅ Schema documentation in code
- ✅ Version controlled structure
- ✅ Easy environment replication

### For Users
- ✅ One-click table setup
- ✅ Clear data examples
- ✅ Reduced setup errors
- ✅ Faster workflow deployment

### For Maintenance
- ✅ Schema changes tracked in git
- ✅ Easy to update structure
- ✅ Clear migration path
- ✅ Documented data contracts

---

**Note for Claude Code:** When creating workflows that require n8n Data Tables, ALWAYS create a corresponding `_table_setup.csv` file following this pattern.

**Created:** 2025-01-18
**Pattern Version:** 1.0
