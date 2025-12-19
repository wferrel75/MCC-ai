# n8n Data Table Setup Guide
## UserAudit_Master Table Configuration

---

## Quick Start

### Option 1: Import CSV (Recommended)
1. Open n8n: https://n8n.midcloudcomputing.com/
2. Navigate to **Settings** (gear icon) → **Data**
3. Click **"New Data Table"**
4. Name: `UserAudit_Master`
5. Click **"Import from CSV"**
6. Upload: `/home/wferrel/ai/audits/UserAudit_Master_Template.csv`
7. n8n will auto-detect column types
8. Review and adjust column types (see below)
9. Click **"Create Table"**

### Option 2: Manual Creation
If CSV import doesn't work or you prefer manual setup, follow the detailed steps below.

---

## Table Schema Configuration

### Table Name
```
UserAudit_Master
```

### Columns (18 total)

| Column Name | Data Type | Required | Default | Notes |
|------------|-----------|----------|---------|-------|
| `id` | Number (Auto-increment) | Yes | Auto | Primary key |
| `source_platform` | String | Yes | - | Platform name (e.g., "Microsoft Entra ID") |
| `user_id` | String | Yes | - | Platform-specific user ID |
| `username` | String | Yes | - | User's login name |
| `email` | String | No | - | User's email address |
| `display_name` | String | No | - | User's full name for display |
| `first_name` | String | No | - | User's first name |
| `last_name` | String | No | - | User's last name |
| `account_enabled` | Boolean | Yes | true | Account active status |
| `account_created` | DateTime | No | - | When account was created |
| `last_login` | DateTime | No | - | Last successful login |
| `mfa_enabled` | Boolean | No | - | Multi-factor auth status (null if unknown) |
| `roles` | JSON String | No | `[]` | Array of role names as JSON string |
| `permissions` | JSON String | No | `[]` | Array of permissions as JSON string |
| `licenses` | JSON String | No | `[]` | Array of license names as JSON string |
| `tenant_id` | String | Yes | - | Customer/tenant identifier |
| `last_audit_date` | DateTime | Yes | - | When this record was last updated |
| `collection_method` | String | Yes | `api` | "api" or "manual" |
| `raw_data` | JSON String | No | - | Full API response for debugging |

### Important Column Configuration Notes

#### JSON String Fields
n8n Data Tables may not have a native JSON type. Store these as **String** type:
- `roles` - Store as: `["Role1","Role2"]`
- `permissions` - Store as: `["Permission1","Permission2"]`
- `licenses` - Store as: `["License1","License2"]`
- `raw_data` - Store as: `{full JSON object stringified}`

**In your n8n workflows**, use `JSON.stringify()` before storing and `JSON.parse()` when reading.

#### DateTime Fields
n8n will recognize ISO 8601 format:
- Format: `2024-12-17T02:00:00Z`
- Always use UTC timezone (Z suffix)

#### Boolean Fields
- Use: `true` or `false` (lowercase)
- Allow null for unknown values (especially `mfa_enabled`)

---

## Composite Unique Key Setup

### Primary Key
- `id` (auto-increment) - n8n handles this automatically

### Logical Unique Key (for Upsert operations)
You'll want to ensure no duplicate users from the same platform. Use these columns together:
- `source_platform` + `user_id`

### How to Configure Upsert in n8n Workflows

When using the **Data Table** node with **Upsert** operation:

```
Operation: Upsert
Data Table: UserAudit_Master
Matching Column(s):
  - Create custom expression that combines source_platform and user_id

OR use two matching columns if n8n supports:
  - source_platform
  - user_id
```

**Example n8n Code Node for Matching:**
```javascript
// Create a unique key for matching
items = items.map(item => {
  return {
    ...item,
    unique_key: `${item.source_platform}::${item.user_id}`
  };
});

return items;
```

Then match on `unique_key` column (add this as a column if needed).

---

## Manual Column Creation Steps

If creating manually in n8n:

### Step 1: Create Table
1. Settings → Data → New Data Table
2. Name: `UserAudit_Master`

### Step 2: Add Columns (in order)

#### Column 1: id
- Name: `id`
- Type: Number
- Auto-increment: ✅ Yes
- Required: ✅ Yes

#### Column 2: source_platform
- Name: `source_platform`
- Type: String
- Max Length: 100
- Required: ✅ Yes

#### Column 3: user_id
- Name: `user_id`
- Type: String
- Max Length: 255
- Required: ✅ Yes

#### Column 4: username
- Name: `username`
- Type: String
- Max Length: 255
- Required: ✅ Yes

#### Column 5: email
- Name: `email`
- Type: String
- Max Length: 255
- Required: ❌ No

#### Column 6: display_name
- Name: `display_name`
- Type: String
- Max Length: 255
- Required: ❌ No

#### Column 7: first_name
- Name: `first_name`
- Type: String
- Max Length: 100
- Required: ❌ No

#### Column 8: last_name
- Name: `last_name`
- Type: String
- Max Length: 100
- Required: ❌ No

#### Column 9: account_enabled
- Name: `account_enabled`
- Type: Boolean
- Required: ✅ Yes
- Default: true

#### Column 10: account_created
- Name: `account_created`
- Type: DateTime
- Required: ❌ No

#### Column 11: last_login
- Name: `last_login`
- Type: DateTime
- Required: ❌ No

#### Column 12: mfa_enabled
- Name: `mfa_enabled`
- Type: Boolean
- Required: ❌ No (allow null for "unknown")

#### Column 13: roles
- Name: `roles`
- Type: String (for JSON)
- Max Length: 2000
- Required: ❌ No
- Default: `[]`

#### Column 14: permissions
- Name: `permissions`
- Type: String (for JSON)
- Max Length: 2000
- Required: ❌ No
- Default: `[]`

#### Column 15: licenses
- Name: `licenses`
- Type: String (for JSON)
- Max Length: 1000
- Required: ❌ No
- Default: `[]`

#### Column 16: tenant_id
- Name: `tenant_id`
- Type: String
- Max Length: 100
- Required: ✅ Yes

#### Column 17: last_audit_date
- Name: `last_audit_date`
- Type: DateTime
- Required: ✅ Yes

#### Column 18: collection_method
- Name: `collection_method`
- Type: String
- Max Length: 50
- Required: ✅ Yes
- Default: `api`

#### Column 19: raw_data
- Name: `raw_data`
- Type: String (for JSON) OR Text (if n8n has Text type)
- Max Length: 65535 (or unlimited if Text type)
- Required: ❌ No

---

## Testing Your Table

### Test Insert
Create a simple n8n workflow:

```
1. [Manual Trigger]
   ↓
2. [Code Node] - Create test data:
   ```javascript
   return [{
     json: {
       source_platform: 'Test Platform',
       user_id: 'test-001',
       username: 'test.user@test.com',
       email: 'test.user@test.com',
       display_name: 'Test User',
       first_name: 'Test',
       last_name: 'User',
       account_enabled: true,
       account_created: new Date().toISOString(),
       last_login: new Date().toISOString(),
       mfa_enabled: false,
       roles: JSON.stringify(['Test Role']),
       permissions: JSON.stringify(['test.permission']),
       licenses: JSON.stringify([]),
       tenant_id: 'test-tenant',
       last_audit_date: new Date().toISOString(),
       collection_method: 'api',
       raw_data: JSON.stringify({test: 'data'})
     }
   }];
   ```
   ↓
3. [Data Table Node]
   - Operation: Insert
   - Data Table: UserAudit_Master
```

### Test Upsert
Modify the workflow above:
- Change Operation to **Upsert**
- Set Matching Column: `user_id` (or your composite key)
- Run twice - should update, not duplicate

### Test Query
Create another workflow:

```
1. [Manual Trigger]
   ↓
2. [Data Table Node]
   - Operation: Get All
   - Data Table: UserAudit_Master
   ↓
3. [View Results]
```

---

## Workflow Integration Examples

### Insert New Record
```javascript
// In your Code node after transforming data:
const record = {
  source_platform: 'Microsoft Entra ID',
  user_id: user.id,
  username: user.userPrincipalName,
  email: user.mail,
  display_name: user.displayName,
  first_name: user.givenName,
  last_name: user.surname,
  account_enabled: user.accountEnabled,
  account_created: user.createdDateTime,
  last_login: user.signInActivity?.lastSignInDateTime || null,
  mfa_enabled: authMethods.length > 1,
  roles: JSON.stringify(roles),
  permissions: JSON.stringify([]),
  licenses: JSON.stringify(licenses),
  tenant_id: 'mcc-tenant-001',
  last_audit_date: new Date().toISOString(),
  collection_method: 'api',
  raw_data: JSON.stringify(user)
};

return [{ json: record }];
```

### Upsert (Update or Insert)
```
Data Table Node:
  Operation: Upsert
  Data Table: UserAudit_Master
  Matching Column: user_id
  (Or use composite key if supported)
```

### Query Specific Platform
```javascript
// Query via Code node if n8n doesn't support WHERE in Data Table
const allRecords = $input.all();
const entraUsers = allRecords.filter(item =>
  item.json.source_platform === 'Microsoft Entra ID'
);
return entraUsers;
```

---

## Backup and Export

### Export Table Data
1. n8n Settings → Data → UserAudit_Master
2. Click **Export** (if available)
3. Save as CSV for backup

### Scheduled Backup Workflow
```
[Schedule Trigger - Weekly]
   ↓
[Data Table - Get All]
   ↓
[CSV Node - Convert to CSV]
   ↓
[Email/Save to File]
```

---

## Troubleshooting

### Issue: CSV Import Fails
**Solution:** Create table manually using column definitions above

### Issue: Upsert Creates Duplicates
**Solution:** Verify matching column(s) are correctly set. Consider using composite key approach.

### Issue: JSON Fields Show as "[object Object]"
**Solution:** Always use `JSON.stringify()` before storing, `JSON.parse()` after reading

### Issue: DateTime Format Errors
**Solution:** Ensure ISO 8601 format with Z suffix: `new Date().toISOString()`

### Issue: Boolean Fields Store as String
**Solution:** Ensure you're passing actual boolean (`true`/`false`), not string (`"true"`/`"false"`)

### Issue: Table Too Slow with Large Data
**Solutions:**
- Consider migrating to PostgreSQL (more scalable)
- Add indexes (if n8n supports)
- Archive old data periodically
- Limit queries with date ranges

---

## Data Retention Policy

### Recommendation
- **Active Users:** Keep indefinitely
- **Disabled Users:** Retain for 90 days after last seen
- **Deleted Users:** Retain for 365 days for audit trail

### Cleanup Workflow (Future)
```
[Schedule Trigger - Monthly]
   ↓
[Data Table - Get All]
   ↓
[Filter] - account_enabled = false AND last_audit_date > 90 days ago
   ↓
[Data Table - Delete]
```

---

## Performance Considerations

### Expected Data Volume
- **Phase 1:** ~100-500 users (3 platforms)
- **Phase 2:** ~1,000-2,000 users (10 platforms)
- **Full Implementation:** ~3,000-5,000 users (16 platforms)

### n8n Data Tables Limitations
- Check n8n documentation for row limits
- If exceeding limits, migrate to PostgreSQL
- Consider partitioning by `source_platform` if needed

---

## Migration to PostgreSQL (Future)

If n8n Data Tables become limiting:

### PostgreSQL Table Creation
```sql
CREATE TABLE user_audit_master (
  id SERIAL PRIMARY KEY,
  source_platform VARCHAR(100) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  display_name VARCHAR(255),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  account_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  account_created TIMESTAMP,
  last_login TIMESTAMP,
  mfa_enabled BOOLEAN,
  roles JSONB,
  permissions JSONB,
  licenses JSONB,
  tenant_id VARCHAR(100) NOT NULL,
  last_audit_date TIMESTAMP NOT NULL,
  collection_method VARCHAR(50) NOT NULL DEFAULT 'api',
  raw_data JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(source_platform, user_id)
);

CREATE INDEX idx_source_platform ON user_audit_master(source_platform);
CREATE INDEX idx_tenant_id ON user_audit_master(tenant_id);
CREATE INDEX idx_last_audit_date ON user_audit_master(last_audit_date);
CREATE INDEX idx_account_enabled ON user_audit_master(account_enabled);
```

---

## Next Steps

1. ✅ Import CSV or create table manually
2. ✅ Test insert and upsert operations
3. ✅ Verify all column types are correct
4. ✅ Document any deviations from this guide
5. ✅ Proceed to Week 2: Build Entra ID workflow

---

*Last Updated: 2025-12-17*
*Table Version: 1.0*
*Compatibility: n8n 1.x*
