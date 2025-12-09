# DattoRMM Site Group Management - n8n Workflow Guide

## Overview

This n8n workflow provides a user-friendly web form interface to add DattoRMM sites to site groups. The workflow fetches all sites and site groups from DattoRMM, presents them in an interactive form, and then processes the user's selections to add the selected site to multiple site groups via the DattoRMM API.

**Workflow ID:** `PgGx0tVxT7ji7eXV`
**Workflow Name:** `DattoRMM - Add Sites to Site Groups`

## Features

- **Dynamic Data Loading**: Automatically fetches current sites and site groups from DattoRMM
- **User-Friendly Form Interface**: Clean web form with dropdown and multi-select checkboxes
- **Bulk Operations**: Add a single site to multiple site groups in one operation
- **Real-time Processing**: Immediate feedback on successful operations
- **Error Handling**: Built-in validation and error handling

## Workflow Architecture

### Node Flow

1. **Webhook Trigger** - Initiates the workflow via HTTP GET request
2. **Get Sites from DattoRMM** - Fetches all sites from DattoRMM API
3. **Get Site Groups from DattoRMM** - Fetches all site groups from DattoRMM API
4. **Format Data for Form** - Transforms API data into form-compatible format
5. **Select Site and Groups** - Displays interactive form to user
6. **Process Form Submission** - Extracts site and group IDs from user selections
7. **Add Site to Group** - Makes API calls to add site to each selected group
8. **Format Success Response** - Creates success message with operation summary
9. **Send Response** - Returns success message to user

### Data Flow

```
Webhook → Fetch Sites → Fetch Groups → Format Data → Display Form
                                                           ↓
Response ← Format Success ← Add to Groups ← Process Submission
```

## Prerequisites

### 1. DattoRMM API Access

You need:
- DattoRMM API URL (e.g., `https://pinetop-api.centrastage.net`)
- DattoRMM API Key with permissions for:
  - Reading sites
  - Reading site groups
  - Modifying site group memberships

### 2. n8n Environment Variables

Configure the following environment variables in your n8n instance:

| Variable | Description | Example |
|----------|-------------|---------|
| `DATTO_RMM_URL` | Your DattoRMM API base URL | `https://pinetop-api.centrastage.net` |
| `DATTO_API_KEY` | Your DattoRMM API key | `your-api-key-here` |

#### Setting Environment Variables

**Option 1: n8n Configuration File**
```bash
# In your n8n .env file or environment configuration
DATTO_RMM_URL=https://pinetop-api.centrastage.net
DATTO_API_KEY=your-api-key-here
```

**Option 2: Docker Environment**
```bash
docker run -d \
  -e DATTO_RMM_URL=https://pinetop-api.centrastage.net \
  -e DATTO_API_KEY=your-api-key-here \
  -p 5678:5678 \
  n8nio/n8n
```

**Option 3: System Environment Variables**
```bash
export DATTO_RMM_URL=https://pinetop-api.centrastage.net
export DATTO_API_KEY=your-api-key-here
```

## Installation & Setup

### Step 1: Import the Workflow

The workflow has already been created in your n8n instance with ID: `PgGx0tVxT7ji7eXV`

To access it:
1. Open your n8n web interface
2. Navigate to **Workflows**
3. Find "DattoRMM - Add Sites to Site Groups"
4. Open the workflow

### Step 2: Configure Environment Variables

Ensure your DattoRMM credentials are configured as environment variables (see Prerequisites section above).

### Step 3: Activate the Workflow

1. Open the workflow in n8n
2. Click the **Activate** toggle in the top right corner
3. Verify the workflow is now active (toggle should be green/on)

### Step 4: Get the Webhook URL

1. Click on the **Webhook Trigger** node
2. Copy the **Production URL** from the node panel
3. The URL will look like: `https://your-n8n-instance.com/webhook/datto-site-groups`

## Usage

### Accessing the Form

1. Open a web browser
2. Navigate to the webhook URL (from Step 4 above)
3. The workflow will automatically:
   - Fetch all sites from DattoRMM
   - Fetch all site groups from DattoRMM
   - Display an interactive form

### Using the Form

1. **Select Site**: Choose one site from the dropdown
   - Format: `Site Name (ID: 123)`

2. **Select Site Groups**: Check one or more site groups
   - Multi-select checkboxes
   - Select as many groups as needed
   - Format: `Group Name (ID: 456)`

3. **Submit**: Click the "Add to Groups" button

4. **Confirmation**: You'll receive a success message:
   - Example: `Successfully added site "Acme Corp" to 3 site group(s).`

## API Endpoints Used

### DattoRMM API Calls

The workflow makes the following API calls:

1. **Get Sites** (Read)
   - Endpoint: `GET /api/v2/account/sites`
   - Purpose: Fetch list of all sites

2. **Get Site Groups** (Read)
   - Endpoint: `GET /api/v2/account/site-groups`
   - Purpose: Fetch list of all site groups

3. **Add Site to Site Group** (Write)
   - Endpoint: `PUT /api/v2/account/sites/{siteId}/site-groups/{groupId}`
   - Purpose: Add specific site to specific site group
   - Called once per selected site group

## Technical Details

### Form Configuration

**Form Title:** Add Site to Site Groups
**Form Description:** Select a site and one or more site groups to add the site to.

**Fields:**
- **Select Site** (Required)
  - Type: Dropdown
  - Single selection
  - Populated dynamically from DattoRMM

- **Select Site Groups** (Required)
  - Type: Checkboxes
  - Multi-selection
  - Populated dynamically from DattoRMM

### Code Node Functions

#### Format Data for Form
```javascript
// Transforms DattoRMM API responses into n8n form format
- Input: Sites and Site Groups from API
- Output: Arrays of options for dropdown and checkboxes
- Format: {option: "Name (ID: 123)"}
```

#### Process Form Submission
```javascript
// Extracts IDs from user selections
- Input: Form submission with selected values
- Output: Array of items, one per site group
- Parsing: Regex to extract numeric IDs from formatted strings
```

#### Format Success Response
```javascript
// Creates user-friendly success message
- Input: All successful API responses
- Output: Summary message with count
- Example: "Successfully added site X to Y site group(s)"
```

### HTTP Request Configuration

All HTTP Request nodes use:
- **Authentication**: Generic Credential Type → HTTP Header Auth
- **Header**: `X-API-KEY` with value from `$env.DATTO_API_KEY`
- **Base URL**: From `$env.DATTO_RMM_URL`

## Troubleshooting

### Common Issues

#### 1. "Failed to fetch sites/groups"

**Cause**: API credentials not configured or invalid

**Solution**:
- Verify `DATTO_RMM_URL` is set correctly
- Verify `DATTO_API_KEY` is valid and has proper permissions
- Check DattoRMM API status
- Restart n8n after changing environment variables

#### 2. "Form displays empty dropdowns"

**Cause**: API returned no data or data format mismatch

**Solution**:
- Check execution logs in n8n
- Verify the "Get Sites" and "Get Site Groups" nodes returned data
- Check DattoRMM API response format matches expected structure
- Ensure sites and site groups exist in DattoRMM

#### 3. "Failed to add site to group"

**Cause**: API permissions or invalid site/group ID

**Solution**:
- Verify API key has write permissions for site groups
- Check that site and group IDs are valid
- Review DattoRMM API error response in n8n execution logs
- Ensure site is not already in the group (if API rejects duplicates)

#### 4. "Webhook not accessible"

**Cause**: Workflow not active or n8n not publicly accessible

**Solution**:
- Verify workflow is activated (toggle in top right)
- Ensure n8n instance is accessible from your network
- Check firewall rules and port forwarding
- Verify webhook path is correct: `/webhook/datto-site-groups`

### Debugging Tips

1. **View Execution History**
   - Go to n8n dashboard
   - Click "Executions" in left sidebar
   - Find your workflow execution
   - Review each node's input/output data

2. **Test Nodes Individually**
   - Open the workflow
   - Click "Execute Workflow" button
   - Watch each node execute
   - Inspect data at each step

3. **Check API Responses**
   - Click on HTTP Request nodes
   - View the response data
   - Verify JSON structure matches expectations

4. **Enable Detailed Logging**
   - Set n8n log level to debug
   - Check n8n logs for detailed error messages

## Security Considerations

### API Key Protection

- **Never expose API keys** in client-side code
- Store API keys in environment variables only
- Use n8n's credential system for additional security
- Rotate API keys regularly

### Access Control

- **Webhook Security**: Consider adding authentication to the webhook
  - Option 1: Use n8n's built-in Basic Auth on the webhook node
  - Option 2: Place behind a reverse proxy with authentication
  - Option 3: Use IP whitelisting

### Audit Logging

- Monitor workflow executions in n8n
- Review DattoRMM audit logs for site group changes
- Track who has access to the webhook URL

## Customization Options

### 1. Add Site Name Search

Modify the form to include a search/filter field:
```javascript
// In "Format Data for Form" node
// Add search functionality to filter sites by name
```

### 2. Limit Site Group Selection

Add validation to limit number of groups that can be selected:
```javascript
// In form configuration
"limitSelection": "range",
"minSelections": 1,
"maxSelections": 5
```

### 3. Add Confirmation Email

Add email notification node after success:
```javascript
// Insert "Send Email" node before "Send Response"
// Configure SMTP credentials
// Send confirmation to admin
```

### 4. Batch Processing

Modify to support multiple sites at once:
- Change "Select Site" to checkboxes instead of dropdown
- Update processing logic to handle multiple sites
- Loop through site/group combinations

### 5. Error Handling

Add error handling nodes:
```javascript
// Add "IF" node after API calls
// Check for error responses
// Route to error handler
// Send error notification
```

## Maintenance

### Regular Tasks

**Weekly:**
- Review execution logs for errors
- Verify workflow is active and responding

**Monthly:**
- Test workflow end-to-end
- Review API usage and performance
- Update documentation if needed

**Quarterly:**
- Rotate DattoRMM API keys
- Review and update security settings
- Check for n8n updates

### Monitoring

Set up monitoring for:
- Workflow execution failures
- API response times
- Unusual activity patterns
- Failed authentication attempts

### Backup

**Export Workflow:**
1. Open workflow in n8n
2. Click three-dot menu (⋮)
3. Select "Download"
4. Save JSON file securely

**Restore from Backup:**
1. Go to n8n workflows page
2. Click "Import from File"
3. Select saved JSON file
4. Reconfigure environment variables if needed

## API Rate Limits

### DattoRMM API Limits

Be aware of DattoRMM API rate limits:
- Typical limit: 300 requests per minute
- This workflow makes: 2 + N requests (where N = number of selected groups)
- Example: Selecting 5 groups = 7 total API calls

### Optimization

For high-volume usage:
- Implement caching for sites/groups data
- Add rate limiting to webhook
- Consider batch API operations if available

## Support & Resources

### DattoRMM API Documentation
- API Reference: Check DattoRMM partner portal
- API Status: Monitor DattoRMM status page

### n8n Documentation
- n8n Docs: https://docs.n8n.io
- Community Forum: https://community.n8n.io
- GitHub: https://github.com/n8n-io/n8n

### Getting Help

1. Check n8n execution logs
2. Review this documentation
3. Consult DattoRMM API documentation
4. Ask in n8n community forum
5. Contact DattoRMM support for API issues

## Changelog

### Version 1.0 (2025-12-08)
- Initial workflow creation
- Basic site-to-group assignment functionality
- Form-based user interface
- Multi-group selection support

## License & Credits

This workflow integrates with:
- **n8n**: Fair-code workflow automation platform
- **DattoRMM**: Datto Remote Monitoring and Management platform

Created for MSP operations and automation.
