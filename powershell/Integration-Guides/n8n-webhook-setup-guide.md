# n8n Webhook Setup Guide for Server Audit Reports

## Workflow Created
**Name:** Server Audit Reports - Webhook Receiver
**Workflow ID:** dUSm7o1iWskIz8n8

## Webhook Details

### Webhook URL
Your webhook will be accessible at:
```
https://your-n8n-instance.com/webhook/server-audit
```

Or for production webhooks:
```
https://your-n8n-instance.com/webhook-prod/server-audit
```

Replace `your-n8n-instance.com` with your actual n8n server domain.

### Important Setup Steps

#### 1. Set the API Token Variable
Before using the webhook, you MUST set the `API_TOKEN` workflow variable:

1. In n8n, open the "Server Audit Reports - Webhook Receiver" workflow
2. Click on "Workflow" menu → "Settings" → "Variables"
3. Add a new variable:
   - **Name:** `API_TOKEN`
   - **Value:** Your secure API token (e.g., `your-secure-api-token-here`)

#### 2. Activate the Workflow
1. Open the workflow in n8n
2. Toggle the "Active" switch in the top-right corner
3. Once active, the webhook will be ready to receive data

## PowerShell Script Configuration

### Basic Usage
Use these parameters with your PowerShell script:

```powershell
.\Get-ServerConfiguration-WithExport.ps1 `
    -ExportToAPI `
    -ApiEndpoint "https://your-n8n-instance.com/webhook/server-audit" `
    -ApiKey "your-secure-api-token-here"
```

### Datto RMM Component Setup
Create these encrypted component variables in Datto RMM:

| Variable Name | Value | Type |
|--------------|-------|------|
| `N8N_WEBHOOK_URL` | `https://your-n8n-instance.com/webhook/server-audit` | Text |
| `N8N_API_TOKEN` | `your-secure-api-token-here` | Encrypted |

### Datto RMM Component Command
```powershell
powershell.exe -ExecutionPolicy Bypass -File "%ComponentPath%" `
    -ExportToAPI `
    -ApiEndpoint "%N8N_WEBHOOK_URL%" `
    -ApiKey "%N8N_API_TOKEN%"
```

## How the Workflow Works

### 1. Webhook Trigger
- Receives POST requests at `/webhook/server-audit`
- Accepts JSON data in the request body

### 2. Bearer Token Validation
- Validates the `Authorization: Bearer <token>` header
- Compares against the `API_TOKEN` workflow variable
- Returns 401 Unauthorized if token is invalid

### 3. Data Extraction
Extracts key fields from the audit report:
- Server name
- Audit date
- OS version
- Health score
- Full audit data
- Timestamp of receipt

### 4. Optional Processing (Currently Disabled)
The workflow includes optional nodes you can enable:

#### **Save to File**
- Saves JSON reports to `/tmp/server-audits/`
- Filename format: `SERVERNAME_YYYYMMDD-HHMMSS.json`
- To enable: Click the node and toggle "Disabled" off

#### **Store in Database**
- Stores audit data in PostgreSQL
- Requires database credentials setup
- Schema:
  ```sql
  CREATE TABLE server_audits (
      id SERIAL PRIMARY KEY,
      server_name VARCHAR(255),
      audit_date TIMESTAMP,
      os_version VARCHAR(255),
      health_score INTEGER,
      audit_data JSONB,
      received_at TIMESTAMP DEFAULT NOW()
  );
  ```
- To enable:
  1. Set up PostgreSQL credentials in n8n
  2. Create the table above
  3. Enable the node

#### **Send Notification**
- Sends Slack notification when audit received
- To enable:
  1. Set up Slack credentials in n8n
  2. Update the channel ID in the node
  3. Enable the node

### 5. Success Response
Returns JSON confirmation:
```json
{
  "success": true,
  "message": "Server audit received successfully",
  "serverName": "SERVER-01",
  "receivedAt": "2025-12-05T21:50:00.000Z"
}
```

## Testing the Webhook

### Test with curl
```bash
curl -X POST \
  https://your-n8n-instance.com/webhook/server-audit \
  -H "Authorization: Bearer your-secure-api-token-here" \
  -H "Content-Type: application/json" \
  -d '{
    "ServerName": "TEST-SERVER",
    "ComputerName": "TEST-SERVER",
    "AuditDate": "2025-12-05T21:50:00Z",
    "OSVersion": "Windows Server 2022",
    "HealthScore": 95,
    "Summary": {
      "TotalShares": 5,
      "ActiveShares": 4,
      "InactiveShares": 1
    }
  }'
```

### Test with PowerShell
```powershell
$headers = @{
    "Authorization" = "Bearer your-secure-api-token-here"
    "Content-Type" = "application/json"
}

$body = @{
    ServerName = "TEST-SERVER"
    AuditDate = (Get-Date).ToString("o")
    OSVersion = "Windows Server 2022"
    HealthScore = 95
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://your-n8n-instance.com/webhook/server-audit" `
    -Method POST `
    -Headers $headers `
    -Body $body
```

## Security Considerations

1. **Use HTTPS:** Always use HTTPS for your n8n instance in production
2. **Secure API Token:** Use a strong, random API token (minimum 32 characters)
3. **Rotate Tokens:** Regularly rotate your API tokens
4. **Network Security:** Consider IP whitelisting if possible
5. **Datto Encryption:** Use Datto's encrypted variables for sensitive data

## Troubleshooting

### Webhook Returns 401 Unauthorized
- Verify the `API_TOKEN` workflow variable is set correctly
- Check that the PowerShell script is sending the correct token
- Ensure the header format is: `Authorization: Bearer <token>`

### Workflow Not Receiving Data
- Confirm the workflow is active (green toggle)
- Check the webhook URL is correct
- Verify n8n is accessible from the server running the script
- Check firewall rules

### Data Not Being Processed
- Check the n8n execution logs for errors
- Verify the JSON structure matches expected format
- Enable individual optional nodes to see specific errors

## Extending the Workflow

### Add Email Notifications
1. Add an "Email" node after "Extract Audit Data"
2. Configure SMTP settings
3. Use template with `{{ $json.serverName }}` expressions

### Add to Ticketing System
1. Add appropriate integration node (Jira, ServiceNow, etc.)
2. Create tickets for servers with low health scores:
   ```
   {{ $json.healthScore < 70 ? "Create ticket" : "Skip" }}
   ```

### Add Dashboard Updates
1. Add HTTP Request node
2. Send data to your dashboard API
3. Visualize health scores and trends

## Data Structure Reference

The webhook expects JSON in this format:
```json
{
  "ServerName": "string",
  "ComputerName": "string",
  "AuditDate": "ISO 8601 datetime",
  "OSVersion": "string",
  "OSBuild": "string",
  "HealthScore": 0-100,
  "Summary": {
    "TotalShares": "number",
    "ActiveShares": "number",
    "InactiveShares": "number",
    "DNSZones": "number",
    "DHCPScopes": "number",
    "SharedPrinters": "number",
    "TotalDiskSpaceGB": "number",
    "FreeDiskSpaceGB": "number"
  },
  "SystemHealth": {
    "UptimeDays": "number",
    "MemoryUsagePercent": "number",
    "TotalPhysicalMemoryGB": "number",
    "Disks": []
  },
  "NetworkConnectivity": {
    "InternetConnectivity": "boolean"
  }
}
```

## Support

For n8n-specific issues:
- n8n Documentation: https://docs.n8n.io
- n8n Community: https://community.n8n.io

For PowerShell script issues:
- Review the script documentation
- Check Datto RMM component logs
