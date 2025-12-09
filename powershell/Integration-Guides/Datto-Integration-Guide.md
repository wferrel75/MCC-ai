# Datto RMM Integration Guide for Server Configuration Audit

This guide explains how to capture and store the server audit data in Datto RMM and send it to a central repository.

## Overview

Datto RMM provides several methods to capture and transmit component output:

1. **Component Variables (UDFs)** - Store data in custom fields on the device
2. **Datto RMM API** - Send data to external systems via API calls
3. **Email/Webhook Integration** - Send data via email or webhooks
4. **Syslog/SIEM Integration** - Forward to logging systems
5. **File Upload to Network Share** - Store JSON files centrally

---

## Method 1: Using Datto Component Variables (Recommended for Small Data)

### How It Works
Datto RMM components can set **User Defined Fields (UDFs)** that are stored per device in Datto.

### PowerShell Script Modification

```powershell
# At the end of Start-ServerAudit function, add:

# Set Datto UDF variables
$env:ResultVariable1 = $summary['TotalShares']
$env:ResultVariable2 = $summary['ActiveShares']
$env:ResultVariable3 = $summary['InactiveShares']
$env:ResultVariable4 = $summary['DNSZones']
$env:ResultVariable5 = $summary['DHCPScopes']
$env:ResultVariable6 = $summary['SharedPrinters']
$env:ResultVariable7 = $results['SystemHealth']['UptimeDays']
$env:ResultVariable8 = $results['SystemHealth']['MemoryUsagePercent']
$env:ResultVariable9 = $results['NetworkConnectivity']['InternetConnectivity']
$env:ResultVariable10 = $results['AuditDate']

# Store JSON as a variable (truncated to fit UDF limits)
$compressedJson = $jsonResults
if ($compressedJson.Length -gt 64000) {
    $compressedJson = $compressedJson.Substring(0, 64000) + "...[TRUNCATED]"
}
$env:ResultVariable11 = $compressedJson

Write-Output "Datto variables set successfully"
```

### Datto RMM Configuration

1. **Create Custom UDFs** in Datto RMM:
   - Navigate to **Setup → Account Settings → Custom Fields**
   - Create device-level UDFs:
     - `server_total_shares` (Number)
     - `server_active_shares` (Number)
     - `server_inactive_shares` (Number)
     - `server_dns_zones` (Number)
     - `server_dhcp_scopes` (Number)
     - `server_printers` (Number)
     - `server_uptime_days` (Number)
     - `server_memory_usage_pct` (Number)
     - `server_internet_ok` (Text)
     - `server_last_audit` (Date/Text)
     - `server_audit_json` (Text - Large)

2. **Map Component Variables to UDFs**:
   - In your component configuration, go to the **Variables** tab
   - Map each `ResultVariableX` to the corresponding UDF

3. **Query UDFs via Datto API**:
   ```bash
   GET https://pinotage-api.centrastage.net/api/v2/account/devices/{deviceId}
   ```

### Limitations
- UDFs have size limits (typically 64KB for text fields)
- Not ideal for large JSON payloads
- Good for summary statistics and alerts

---

## Method 2: Upload to Central File Share (Recommended for Full Data)

This method saves the complete JSON output to a network share for centralized collection.

### PowerShell Script Addition

```powershell
# Add this function to your script

function Send-AuditToCentralRepository {
    param(
        [Parameter(Mandatory=$true)]
        [string]$JsonData,

        [Parameter(Mandatory=$true)]
        [string]$ServerName,

        [string]$CentralSharePath = "\\your-server\AuditData$",
        [string]$Username = "",
        [string]$Password = ""
    )

    try {
        Write-ComponentOutput -Section "Export" -Message "Sending audit data to central repository..."

        # Create credential if username/password provided
        if ($Username -and $Password) {
            $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
            $credential = New-Object System.Management.Automation.PSCredential($Username, $securePassword)

            # Map network drive temporarily
            New-PSDrive -Name "AuditDrive" -PSProvider FileSystem -Root $CentralSharePath -Credential $credential -ErrorAction Stop | Out-Null
            $outputPath = "AuditDrive:\"
        }
        else {
            # Use current credentials
            $outputPath = $CentralSharePath
        }

        # Create filename with timestamp
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $fileName = "$ServerName-$timestamp.json"
        $fullPath = Join-Path $outputPath $fileName

        # Write JSON to file
        $JsonData | Out-File -FilePath $fullPath -Encoding UTF8 -Force

        Write-ComponentOutput -Section "Export" -Message "Audit data saved to: $fullPath"

        # Clean up mapped drive if created
        if ($Username -and $Password) {
            Remove-PSDrive -Name "AuditDrive" -Force -ErrorAction SilentlyContinue
        }

        return $true
    }
    catch {
        Write-ComponentOutput -Section "Export" -Message "Error sending to repository: $($_.Exception.Message)" -Type "ERROR"
        return $false
    }
}

# Add this to the end of Start-ServerAudit function, before returning $results:

# Send to central repository
$shareSuccess = Send-AuditToCentralRepository -JsonData $jsonResults -ServerName $env:COMPUTERNAME `
    -CentralSharePath "\\fileserver\ServerAudits$" `
    -Username "domain\audituser" `
    -Password "YourPasswordHere"

if ($shareSuccess) {
    Write-ComponentOutput -Section "Export" -Message "Successfully exported to central repository"
}
```

### Datto Component Configuration

**Component Variables (for credentials):**
- Create encrypted variables in Datto:
  - `CENTRAL_SHARE_PATH` = `\\fileserver\ServerAudits$`
  - `AUDIT_USERNAME` = `domain\audituser`
  - `AUDIT_PASSWORD` = `YourSecurePassword` (encrypted)

**Updated script call:**
```powershell
$shareSuccess = Send-AuditToCentralRepository -JsonData $jsonResults -ServerName $env:COMPUTERNAME `
    -CentralSharePath $env:CENTRAL_SHARE_PATH `
    -Username $env:AUDIT_USERNAME `
    -Password $env:AUDIT_PASSWORD
```

---

## Method 3: Send via Datto RMM API to External System

### PowerShell Script Addition

```powershell
function Send-AuditViaAPI {
    param(
        [Parameter(Mandatory=$true)]
        [string]$JsonData,

        [Parameter(Mandatory=$true)]
        [string]$ApiEndpoint,

        [string]$ApiKey = ""
    )

    try {
        Write-ComponentOutput -Section "API" -Message "Sending audit data to API endpoint..."

        $headers = @{
            "Content-Type" = "application/json"
        }

        if ($ApiKey) {
            $headers["Authorization"] = "Bearer $ApiKey"
        }

        # Send POST request
        $response = Invoke-RestMethod -Uri $ApiEndpoint -Method Post -Body $JsonData -Headers $headers -ErrorAction Stop

        Write-ComponentOutput -Section "API" -Message "Successfully sent to API endpoint"
        return $true
    }
    catch {
        Write-ComponentOutput -Section "API" -Message "Error sending to API: $($_.Exception.Message)" -Type "ERROR"
        return $false
    }
}

# Usage in Start-ServerAudit:
$apiSuccess = Send-AuditViaAPI -JsonData $jsonResults `
    -ApiEndpoint "https://your-api.example.com/api/server-audits" `
    -ApiKey $env:API_KEY
```

### Common API Targets

#### A. **Azure Logic App**
```powershell
$apiEndpoint = "https://prod-xx.eastus.logic.azure.com:443/workflows/.../triggers/manual/paths/invoke?..."
Send-AuditViaAPI -JsonData $jsonResults -ApiEndpoint $apiEndpoint
```

#### B. **Webhooks (Microsoft Teams, Slack, Discord)**
```powershell
# Teams
$teamsPayload = @{
    text = "Server Audit Complete: $env:COMPUTERNAME"
    attachments = @(
        @{
            contentType = "application/vnd.microsoft.card.adaptive"
            content = @{
                body = @(
                    @{
                        type = "TextBlock"
                        text = "Summary: $($summary['TotalShares']) shares, $($summary['DNSZones']) DNS zones"
                    }
                )
            }
        }
    )
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri $env:TEAMS_WEBHOOK -Method Post -Body $teamsPayload -ContentType "application/json"
```

#### C. **Splunk HTTP Event Collector (HEC)**
```powershell
function Send-ToSplunk {
    param(
        [string]$JsonData,
        [string]$SplunkHecUrl,
        [string]$SplunkHecToken
    )

    $headers = @{
        "Authorization" = "Splunk $SplunkHecToken"
    }

    $splunkEvent = @{
        event = $JsonData | ConvertFrom-Json
        sourcetype = "datto:server:audit"
        source = "datto-rmm"
        host = $env:COMPUTERNAME
    } | ConvertTo-Json -Depth 10

    Invoke-RestMethod -Uri $SplunkHecUrl -Method Post -Headers $headers -Body $splunkEvent
}

Send-ToSplunk -JsonData $jsonResults `
    -SplunkHecUrl "https://splunk.example.com:8088/services/collector" `
    -SplunkHecToken $env:SPLUNK_TOKEN
```

#### D. **Database (SQL Server)**
```powershell
function Send-ToSqlServer {
    param(
        [string]$JsonData,
        [string]$ServerName,
        [string]$DatabaseName,
        [string]$SqlUsername,
        [string]$SqlPassword
    )

    $connectionString = "Server=$ServerName;Database=$DatabaseName;User Id=$SqlUsername;Password=$SqlPassword;"
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()

    $command = $connection.CreateCommand()
    $command.CommandText = @"
        INSERT INTO ServerAudits (ComputerName, AuditDate, AuditData)
        VALUES (@ComputerName, @AuditDate, @AuditData)
"@

    $command.Parameters.AddWithValue("@ComputerName", $env:COMPUTERNAME) | Out-Null
    $command.Parameters.AddWithValue("@AuditDate", (Get-Date)) | Out-Null
    $command.Parameters.AddWithValue("@AuditData", $JsonData) | Out-Null

    $command.ExecuteNonQuery() | Out-Null
    $connection.Close()
}
```

---

## Method 4: Email JSON Report

### PowerShell Script Addition

```powershell
function Send-AuditEmail {
    param(
        [string]$JsonData,
        [string]$ServerName,
        [string]$SmtpServer,
        [int]$SmtpPort = 587,
        [string]$From,
        [string]$To,
        [string]$Username,
        [string]$Password
    )

    try {
        Write-ComponentOutput -Section "Email" -Message "Sending audit report via email..."

        $subject = "Server Audit Report: $ServerName - $(Get-Date -Format 'yyyy-MM-dd')"

        # Create readable summary
        $auditObj = $JsonData | ConvertFrom-Json
        $body = @"
Server Audit Report for: $ServerName
Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

SUMMARY:
- Total File Shares: $($auditObj.Summary.TotalShares)
- Active Shares: $($auditObj.Summary.ActiveShares)
- DNS Zones: $($auditObj.Summary.DNSZones)
- DHCP Scopes: $($auditObj.Summary.DHCPScopes)
- System Uptime: $($auditObj.SystemHealth.UptimeDays) days
- Memory Usage: $($auditObj.SystemHealth.MemoryUsagePercent)%

Full JSON data is attached.
"@

        # Save JSON to temp file for attachment
        $tempFile = "$env:TEMP\$ServerName-audit.json"
        $JsonData | Out-File -FilePath $tempFile -Encoding UTF8

        # Send email
        $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential($Username, $securePassword)

        Send-MailMessage -SmtpServer $SmtpServer -Port $SmtpPort -UseSsl `
            -From $From -To $To -Subject $subject -Body $body `
            -Attachments $tempFile -Credential $credential

        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

        Write-ComponentOutput -Section "Email" -Message "Email sent successfully"
        return $true
    }
    catch {
        Write-ComponentOutput -Section "Email" -Message "Error sending email: $($_.Exception.Message)" -Type "ERROR"
        return $false
    }
}
```

---

## Method 5: Datto RMM API Integration (Query from Central System)

Instead of pushing data, you can have Datto store it and pull from a central system.

### Step 1: Store in Datto UDFs (as in Method 1)

### Step 2: Query via Datto API

```python
# Python example - Central collection script
import requests
import json
from datetime import datetime

# Datto API credentials
DATTO_API_URL = "https://pinotage-api.centrastage.net/api/v2"
API_KEY = "your-api-key"
API_SECRET = "your-api-secret"

headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
}

# Authenticate
auth_response = requests.post(
    f"{DATTO_API_URL}/account/oauth/token",
    headers=headers,
    auth=(API_KEY, API_SECRET)
)
token = auth_response.json()['access_token']
headers["Authorization"] = f"Bearer {token}"

# Get all devices
devices = requests.get(f"{DATTO_API_URL}/account/devices", headers=headers).json()

# Collect audit data from all servers
audit_collection = []

for device in devices['devices']:
    device_id = device['uid']
    device_name = device['hostname']

    # Get device details including UDFs
    device_detail = requests.get(
        f"{DATTO_API_URL}/account/devices/{device_id}",
        headers=headers
    ).json()

    # Extract audit data from UDFs
    udf_values = device_detail.get('udf', {})

    audit_data = {
        'server_name': device_name,
        'collection_time': datetime.now().isoformat(),
        'total_shares': udf_values.get('server_total_shares'),
        'active_shares': udf_values.get('server_active_shares'),
        'dns_zones': udf_values.get('server_dns_zones'),
        'last_audit': udf_values.get('server_last_audit'),
        'full_json': udf_values.get('server_audit_json')
    }

    audit_collection.append(audit_data)

# Save to central database/file
with open('server_audits.json', 'w') as f:
    json.dump(audit_collection, f, indent=2)

print(f"Collected audit data from {len(audit_collection)} servers")
```

---

## Recommended Architecture

### Small-to-Medium Deployments (< 50 servers)
**Method 2 (File Share) + Method 1 (UDFs for summary)**
- Simple to implement
- No external dependencies
- Easy to parse JSON files
- UDFs provide quick dashboard view

### Large Deployments (50+ servers)
**Method 3 (API to SIEM/Database) + Method 1 (UDFs)**
- Splunk/Azure Log Analytics/SQL Database
- Real-time ingestion
- Advanced analytics and alerting
- Historical trending

### Hybrid Approach (Recommended)
1. **Store summary in UDFs** - Quick dashboard access
2. **Upload full JSON to file share** - Complete data retention
3. **Send alerts via webhook** - Notify on issues (inactive shares, low disk, etc.)

---

## Complete Integration Script

I'll create a modified version of the main script with all export options built-in...

