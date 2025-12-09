# Quick Start: DattoRMM Site Group Management Workflow

## 5-Minute Setup Guide

### Prerequisites Checklist
- [ ] n8n instance installed and running
- [ ] DattoRMM API access (URL + API Key)
- [ ] Workflow imported/created in n8n

### Setup Steps

#### 1. Configure Environment Variables (2 minutes)

Add these to your n8n environment:

```bash
# Your DattoRMM API URL (replace with your region)
DATTO_RMM_URL=https://pinetop-api.centrastage.net

# Your DattoRMM API Key
DATTO_API_KEY=your-api-key-here
```

**How to set:**
- Docker: Add to docker run command with `-e` flag
- Docker Compose: Add to environment section
- Standalone: Add to `.env` file or system environment

**Restart n8n after setting variables**

#### 2. Activate Workflow (1 minute)

1. Open n8n web interface
2. Go to **Workflows**
3. Find "DattoRMM - Add Sites to Site Groups"
4. Click the **Activate** toggle (top right)
5. Verify toggle is green/on

#### 3. Get Webhook URL (30 seconds)

1. Open the workflow
2. Click on **Webhook Trigger** node
3. Copy the **Production URL**
   - Example: `https://your-n8n.com/webhook/datto-site-groups`
4. Save this URL for accessing the form

#### 4. Test the Workflow (1 minute)

1. Open the webhook URL in your browser
2. Wait for form to load (fetches data from DattoRMM)
3. Select a test site from dropdown
4. Select one or more site groups
5. Click "Add to Groups"
6. Verify success message appears

### Usage

**Quick Access:**
- Bookmark the webhook URL
- Share URL with authorized team members
- Access from any browser

**Workflow:**
1. Open URL → 2. Select site → 3. Select groups → 4. Submit

**Expected Result:**
```
Successfully added site "Client Name" to 3 site group(s).
```

### Troubleshooting

| Problem | Quick Fix |
|---------|-----------|
| Empty form dropdowns | Check environment variables are set |
| "Cannot fetch sites" | Verify DATTO_API_KEY has read permissions |
| Webhook not found | Ensure workflow is activated |
| Form won't load | Restart n8n after setting env vars |

### Common DattoRMM API URLs by Region

```
US: https://pinetop-api.centrastage.net
EU: https://concord-api.centrastage.net
ANZ: https://merlot-api.centrastage.net
```

Replace `DATTO_RMM_URL` with your region's URL.

### Security Best Practices

- [ ] Use HTTPS for n8n instance
- [ ] Don't share API keys in plain text
- [ ] Restrict webhook access (IP whitelist or Basic Auth)
- [ ] Monitor workflow execution logs
- [ ] Rotate API keys quarterly

### Next Steps

- Read full documentation: `DattoRMM-n8n-SiteGroups-Workflow-Guide.md`
- Set up monitoring and alerts
- Configure backup/export of workflow
- Train team members on usage

### Support

**Check execution logs:**
n8n → Executions → Find your workflow run → Review node outputs

**Verify environment variables:**
```bash
# In your n8n environment/container
echo $DATTO_RMM_URL
echo $DATTO_API_KEY
```

**Test DattoRMM API directly:**
```bash
curl -H "X-API-KEY: your-key" \
  https://pinetop-api.centrastage.net/api/v2/account/sites
```

### Workflow Details

**Workflow ID:** `PgGx0tVxT7ji7eXV`
**Workflow Name:** DattoRMM - Add Sites to Site Groups
**Webhook Path:** `/webhook/datto-site-groups`
**Required Permissions:** Read sites, Read site groups, Write site group memberships

### Advanced Configuration

See full guide for:
- Custom form styling
- Email notifications
- Batch processing
- Error handling
- Rate limiting
- Access control
