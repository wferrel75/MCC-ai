<#
.SYNOPSIS
    Comprehensive Windows Server configuration audit with Datto RMM integration

.DESCRIPTION
    Queries Windows Server and documents all roles/features with multiple export options:
    - Datto RMM UDF variables
    - Central file share upload
    - API webhook posting
    - Email delivery
    - Splunk HEC integration

.PARAMETER ExportToShare
    Enable export to network file share

.PARAMETER SharePath
    UNC path to central repository (e.g., \\server\audits$)

.PARAMETER ShareUsername
    Username for share access (optional if using computer account)

.PARAMETER SharePassword
    Password for share access (optional)

.PARAMETER ExportToAPI
    Enable export to API endpoint

.PARAMETER ApiEndpoint
    URL of API endpoint to receive JSON data

.PARAMETER ApiKey
    API authentication key/token

.PARAMETER ExportToEmail
    Enable email delivery

.PARAMETER SmtpServer
    SMTP server hostname

.PARAMETER SmtpPort
    SMTP port (default: 587)

.PARAMETER EmailFrom
    Sender email address

.PARAMETER EmailTo
    Recipient email address

.PARAMETER EmailUsername
    SMTP authentication username

.PARAMETER EmailPassword
    SMTP authentication password

.PARAMETER ExportToSplunk
    Enable Splunk HEC export

.PARAMETER SplunkHecUrl
    Splunk HTTP Event Collector URL

.PARAMETER SplunkHecToken
    Splunk HEC authentication token

.PARAMETER SetDattoVariables
    Enable setting Datto RMM component variables (default: $true)

.NOTES
    Author: Datto RMM Component
    Version: 2.1
    Compatible: Windows Server 2008 R2 and newer
    Requires: Administrator privileges

.EXAMPLE
    # Basic execution with Datto variables only
    .\Get-ServerConfiguration-WithExport.ps1

.EXAMPLE
    # Export to file share
    .\Get-ServerConfiguration-WithExport.ps1 -ExportToShare -SharePath "\\fileserver\audits$"

.EXAMPLE
    # Export to API and email
    .\Get-ServerConfiguration-WithExport.ps1 -ExportToAPI -ApiEndpoint "https://api.example.com/audits" -ApiKey "abc123" `
        -ExportToEmail -SmtpServer "smtp.office365.com" -EmailFrom "audit@company.com" -EmailTo "reports@company.com"

.EXAMPLE
    # Use with Datto environment variables
    .\Get-ServerConfiguration-WithExport.ps1 -ExportToShare -SharePath $env:CENTRAL_SHARE_PATH `
        -ShareUsername $env:AUDIT_USERNAME -SharePassword $env:AUDIT_PASSWORD
#>

[CmdletBinding()]
param(
    [switch]$ExportToShare,
    [string]$SharePath = "",
    [string]$ShareUsername = "",
    [string]$SharePassword = "",

    [switch]$ExportToAPI,
    [string]$ApiEndpoint = "",
    [string]$ApiKey = "",

    [switch]$ExportToEmail,
    [string]$SmtpServer = "",
    [int]$SmtpPort = 587,
    [string]$EmailFrom = "",
    [string]$EmailTo = "",
    [string]$EmailUsername = "",
    [string]$EmailPassword = "",

    [switch]$ExportToSplunk,
    [string]$SplunkHecUrl = "",
    [string]$SplunkHecToken = "",

    [bool]$SetDattoVariables = $true
)

# Import the main audit functions (assuming they're in the same file or dot-sourced)
# For standalone use, include all the functions from Get-ServerConfiguration.ps1 here

#region Export Functions

function Export-ToCentralShare {
    param(
        [Parameter(Mandatory=$true)]
        [string]$JsonData,

        [Parameter(Mandatory=$true)]
        [string]$ServerName,

        [Parameter(Mandatory=$true)]
        [string]$SharePath,

        [string]$Username = "",
        [string]$Password = ""
    )

    try {
        Write-ComponentOutput -Section "Export" -Message "Exporting to central file share..."

        # Create credential if username/password provided
        $useDrive = $false
        if ($Username -and $Password) {
            $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
            $credential = New-Object System.Management.Automation.PSCredential($Username, $securePassword)

            # Map network drive temporarily
            $driveName = "AuditExport"
            New-PSDrive -Name $driveName -PSProvider FileSystem -Root $SharePath -Credential $credential -ErrorAction Stop | Out-Null
            $outputPath = "${driveName}:\"
            $useDrive = $true
        }
        else {
            # Use current credentials
            $outputPath = $SharePath

            # Test path accessibility
            if (-not (Test-Path $outputPath)) {
                throw "Cannot access share path: $outputPath"
            }
        }

        # Create filename with timestamp
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $fileName = "$ServerName-$timestamp.json"
        $fullPath = Join-Path $outputPath $fileName

        # Write JSON to file
        $JsonData | Out-File -FilePath $fullPath -Encoding UTF8 -Force

        Write-ComponentOutput -Section "Export" -Message "Successfully saved to: $fileName"

        # Clean up mapped drive if created
        if ($useDrive) {
            Remove-PSDrive -Name $driveName -Force -ErrorAction SilentlyContinue
        }

        return @{
            'Success' = $true
            'Path' = $fullPath
            'FileName' = $fileName
        }
    }
    catch {
        Write-ComponentOutput -Section "Export" -Message "Error exporting to share: $($_.Exception.Message)" -Type "ERROR"

        # Clean up on error
        if ($useDrive) {
            Remove-PSDrive -Name $driveName -Force -ErrorAction SilentlyContinue
        }

        return @{
            'Success' = $false
            'Error' = $_.Exception.Message
        }
    }
}

function Export-ToAPI {
    param(
        [Parameter(Mandatory=$true)]
        [string]$JsonData,

        [Parameter(Mandatory=$true)]
        [string]$ApiEndpoint,

        [string]$ApiKey = "",

        [string]$Method = "POST"
    )

    try {
        Write-ComponentOutput -Section "API" -Message "Sending to API endpoint: $ApiEndpoint"

        $headers = @{
            "Content-Type" = "application/json"
        }

        if ($ApiKey) {
            $headers["Authorization"] = "Bearer $ApiKey"
        }

        # Send request
        $response = Invoke-RestMethod -Uri $ApiEndpoint -Method $Method -Body $JsonData -Headers $headers -ErrorAction Stop

        Write-ComponentOutput -Section "API" -Message "Successfully sent to API endpoint"

        return @{
            'Success' = $true
            'Response' = $response
        }
    }
    catch {
        Write-ComponentOutput -Section "API" -Message "Error sending to API: $($_.Exception.Message)" -Type "ERROR"

        return @{
            'Success' = $false
            'Error' = $_.Exception.Message
        }
    }
}

function Export-ToEmail {
    param(
        [Parameter(Mandatory=$true)]
        [string]$JsonData,

        [Parameter(Mandatory=$true)]
        [string]$ServerName,

        [Parameter(Mandatory=$true)]
        [string]$SmtpServer,

        [int]$SmtpPort = 587,

        [Parameter(Mandatory=$true)]
        [string]$From,

        [Parameter(Mandatory=$true)]
        [string]$To,

        [string]$Username = "",
        [string]$Password = ""
    )

    try {
        Write-ComponentOutput -Section "Email" -Message "Sending audit report via email..."

        $subject = "Server Audit Report: $ServerName - $(Get-Date -Format 'yyyy-MM-dd')"

        # Parse JSON to create summary
        try {
            $auditObj = $JsonData | ConvertFrom-Json

            $body = @"
Server Audit Report
==================

Server: $ServerName
Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
OS: $($auditObj.OSVersion)

SUMMARY STATISTICS:
-------------------
Total File Shares: $($auditObj.Summary.TotalShares)
Active Shares: $($auditObj.Summary.ActiveShares)
Inactive Shares: $($auditObj.Summary.InactiveShares)
DNS Zones: $($auditObj.Summary.DNSZones)
DHCP Scopes: $($auditObj.Summary.DHCPScopes)
Shared Printers: $($auditObj.Summary.SharedPrinters)

SYSTEM HEALTH:
--------------
Uptime: $($auditObj.SystemHealth.UptimeDays) days
Memory Usage: $($auditObj.SystemHealth.MemoryUsagePercent)%
Total Disk Space: $($auditObj.Summary.TotalDiskSpaceGB) GB
Free Disk Space: $($auditObj.Summary.FreeDiskSpaceGB) GB
Internet Connectivity: $(if($auditObj.NetworkConnectivity.InternetConnectivity){'OK'}else{'FAILED'})

Full JSON audit data is attached.

---
Generated by Datto RMM Server Audit Component
"@
        }
        catch {
            $body = "Server Audit Report for $ServerName`n`nFull JSON data is attached."
        }

        # Save JSON to temp file for attachment
        $tempFile = Join-Path $env:TEMP "$ServerName-audit-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        $JsonData | Out-File -FilePath $tempFile -Encoding UTF8

        # Prepare email parameters
        $mailParams = @{
            SmtpServer = $SmtpServer
            Port = $SmtpPort
            From = $From
            To = $To
            Subject = $subject
            Body = $body
            Attachments = $tempFile
            UseSsl = $true
        }

        # Add credentials if provided
        if ($Username -and $Password) {
            $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
            $credential = New-Object System.Management.Automation.PSCredential($Username, $securePassword)
            $mailParams['Credential'] = $credential
        }

        # Send email
        Send-MailMessage @mailParams -ErrorAction Stop

        # Clean up temp file
        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

        Write-ComponentOutput -Section "Email" -Message "Email sent successfully to $To"

        return @{
            'Success' = $true
            'Recipient' = $To
        }
    }
    catch {
        Write-ComponentOutput -Section "Email" -Message "Error sending email: $($_.Exception.Message)" -Type "ERROR"

        # Clean up temp file on error
        if (Test-Path $tempFile) {
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        }

        return @{
            'Success' = $false
            'Error' = $_.Exception.Message
        }
    }
}

function Export-ToSplunk {
    param(
        [Parameter(Mandatory=$true)]
        [string]$JsonData,

        [Parameter(Mandatory=$true)]
        [string]$HecUrl,

        [Parameter(Mandatory=$true)]
        [string]$HecToken,

        [string]$Source = "datto-rmm",
        [string]$SourceType = "datto:server:audit"
    )

    try {
        Write-ComponentOutput -Section "Splunk" -Message "Sending to Splunk HEC..."

        # Parse JSON to object
        $auditData = $JsonData | ConvertFrom-Json

        # Create Splunk HEC event
        $splunkEvent = @{
            event = $auditData
            sourcetype = $SourceType
            source = $Source
            host = $env:COMPUTERNAME
            time = [int][double]::Parse((Get-Date -UFormat %s))
        } | ConvertTo-Json -Depth 20

        # Prepare headers
        $headers = @{
            "Authorization" = "Splunk $HecToken"
            "Content-Type" = "application/json"
        }

        # Send to Splunk
        $response = Invoke-RestMethod -Uri $HecUrl -Method Post -Headers $headers -Body $splunkEvent -ErrorAction Stop

        Write-ComponentOutput -Section "Splunk" -Message "Successfully sent to Splunk HEC"

        return @{
            'Success' = $true
            'Response' = $response
        }
    }
    catch {
        Write-ComponentOutput -Section "Splunk" -Message "Error sending to Splunk: $($_.Exception.Message)" -Type "ERROR"

        return @{
            'Success' = $false
            'Error' = $_.Exception.Message
        }
    }
}

function Set-DattoComponentVariables {
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$AuditResults,

        [Parameter(Mandatory=$true)]
        [string]$JsonData
    )

    try {
        Write-ComponentOutput -Section "Datto" -Message "Setting Datto RMM component variables..."

        # Set summary variables
        $env:audit_total_shares = $AuditResults['Summary']['TotalShares']
        $env:audit_active_shares = $AuditResults['Summary']['ActiveShares']
        $env:audit_inactive_shares = $AuditResults['Summary']['InactiveShares']
        $env:audit_dns_zones = $AuditResults['Summary']['DNSZones']
        $env:audit_dhcp_scopes = $AuditResults['Summary']['DHCPScopes']
        $env:audit_shared_printers = $AuditResults['Summary']['SharedPrinters']
        $env:audit_disk_total_gb = [math]::Round($AuditResults['Summary']['TotalDiskSpaceGB'], 2)
        $env:audit_disk_free_gb = [math]::Round($AuditResults['Summary']['FreeDiskSpaceGB'], 2)

        # System health variables
        $env:audit_uptime_days = [math]::Round($AuditResults['SystemHealth']['UptimeDays'], 2)
        $env:audit_memory_usage_pct = [math]::Round($AuditResults['SystemHealth']['MemoryUsagePercent'], 2)
        $env:audit_memory_total_gb = $AuditResults['SystemHealth']['TotalPhysicalMemoryGB']

        # Network connectivity
        $env:audit_internet_ok = if ($AuditResults['NetworkConnectivity']['InternetConnectivity']) { "Yes" } else { "No" }

        # Audit metadata
        $env:audit_date = $AuditResults['AuditDate']
        $env:audit_os_version = $AuditResults['OSVersion']
        $env:audit_os_build = $AuditResults['OSBuild']

        # Store compressed JSON (truncate if too large for Datto UDF)
        $compressedJson = $JsonData
        if ($compressedJson.Length -gt 64000) {
            $compressedJson = $compressedJson.Substring(0, 63950) + "...[TRUNCATED]"
            Write-ComponentOutput -Section "Datto" -Message "JSON data truncated to fit UDF size limit" -Type "WARN"
        }
        $env:audit_json_data = $compressedJson

        # Calculate and set health score (0-100)
        $healthScore = 100

        # Deduct points for issues
        if ($AuditResults['Summary']['InactiveShares'] -gt 0) {
            $healthScore -= ($AuditResults['Summary']['InactiveShares'] * 5)
        }
        if ($AuditResults['SystemHealth']['MemoryUsagePercent'] -gt 90) {
            $healthScore -= 15
        }
        elseif ($AuditResults['SystemHealth']['MemoryUsagePercent'] -gt 80) {
            $healthScore -= 10
        }
        if (-not $AuditResults['NetworkConnectivity']['InternetConnectivity']) {
            $healthScore -= 20
        }

        # Check for low disk space
        foreach ($disk in $AuditResults['SystemHealth']['Disks']) {
            if ($disk['PercentFree'] -lt 10) {
                $healthScore -= 15
            }
            elseif ($disk['PercentFree'] -lt 20) {
                $healthScore -= 10
            }
        }

        $healthScore = [math]::Max(0, $healthScore)
        $env:audit_health_score = $healthScore

        Write-ComponentOutput -Section "Datto" -Message "Datto variables set - Health Score: $healthScore"

        return @{
            'Success' = $true
            'VariablesSet' = 17
            'HealthScore' = $healthScore
        }
    }
    catch {
        Write-ComponentOutput -Section "Datto" -Message "Error setting Datto variables: $($_.Exception.Message)" -Type "ERROR"

        return @{
            'Success' = $false
            'Error' = $_.Exception.Message
        }
    }
}

#endregion

# Note: Include all functions from Get-ServerConfiguration.ps1 here
# For brevity, assuming they are available. In production, either:
# 1. Combine both files into one
# 2. Use dot-sourcing: . .\Get-ServerConfiguration.ps1
# 3. Copy all functions into this file

# For this example, we'll assume Start-ServerAudit and supporting functions are available

#region Main Execution with Export Options

# Run the audit (this would call the Start-ServerAudit function from the main script)
Write-Output "Starting server configuration audit with export options..."

# Execute audit (assuming Start-ServerAudit function is available)
# In production, either include all functions above or dot-source them
# $auditResults = Start-ServerAudit

# For demonstration, we'll show the export logic that would be added to Start-ServerAudit:

<#
# Add this section at the end of Start-ServerAudit function, after JSON generation:

# Store export results
$exportResults = @{
    'Share' = $null
    'API' = $null
    'Email' = $null
    'Splunk' = $null
    'DattoVariables' = $null
}

# Export to central file share
if ($ExportToShare -and $SharePath) {
    $exportResults['Share'] = Export-ToCentralShare -JsonData $jsonResults -ServerName $env:COMPUTERNAME `
        -SharePath $SharePath -Username $ShareUsername -Password $SharePassword
}

# Export to API endpoint
if ($ExportToAPI -and $ApiEndpoint) {
    $exportResults['API'] = Export-ToAPI -JsonData $jsonResults -ApiEndpoint $ApiEndpoint -ApiKey $ApiKey
}

# Export via email
if ($ExportToEmail -and $SmtpServer -and $EmailFrom -and $EmailTo) {
    $exportResults['Email'] = Export-ToEmail -JsonData $jsonResults -ServerName $env:COMPUTERNAME `
        -SmtpServer $SmtpServer -SmtpPort $SmtpPort -From $EmailFrom -To $EmailTo `
        -Username $EmailUsername -Password $EmailPassword
}

# Export to Splunk
if ($ExportToSplunk -and $SplunkHecUrl -and $SplunkHecToken) {
    $exportResults['Splunk'] = Export-ToSplunk -JsonData $jsonResults `
        -HecUrl $SplunkHecUrl -HecToken $SplunkHecToken
}

# Set Datto component variables
if ($SetDattoVariables) {
    $exportResults['DattoVariables'] = Set-DattoComponentVariables -AuditResults $results -JsonData $jsonResults
}

# Add export results to main results
$results['ExportResults'] = $exportResults

# Display export summary
Write-ComponentOutput -Section "Export" -Message "========================================="
Write-ComponentOutput -Section "Export" -Message "Export Summary"
Write-ComponentOutput -Section "Export" -Message "========================================="

if ($exportResults['Share']) {
    $status = if ($exportResults['Share']['Success']) { "SUCCESS" } else { "FAILED" }
    Write-ComponentOutput -Section "Export" -Message "File Share: $status"
    if ($exportResults['Share']['Success']) {
        Write-ComponentOutput -Section "Export" -Message "  File: $($exportResults['Share']['FileName'])"
    }
}

if ($exportResults['API']) {
    $status = if ($exportResults['API']['Success']) { "SUCCESS" } else { "FAILED" }
    Write-ComponentOutput -Section "Export" -Message "API Endpoint: $status"
}

if ($exportResults['Email']) {
    $status = if ($exportResults['Email']['Success']) { "SUCCESS" } else { "FAILED" }
    Write-ComponentOutput -Section "Export" -Message "Email: $status"
    if ($exportResults['Email']['Success']) {
        Write-ComponentOutput -Section "Export" -Message "  To: $($exportResults['Email']['Recipient'])"
    }
}

if ($exportResults['Splunk']) {
    $status = if ($exportResults['Splunk']['Success']) { "SUCCESS" } else { "FAILED" }
    Write-ComponentOutput -Section "Export" -Message "Splunk HEC: $status"
}

if ($exportResults['DattoVariables']) {
    $status = if ($exportResults['DattoVariables']['Success']) { "SUCCESS" } else { "FAILED" }
    Write-ComponentOutput -Section "Export" -Message "Datto Variables: $status"
    if ($exportResults['DattoVariables']['Success']) {
        Write-ComponentOutput -Section "Export" -Message "  Variables Set: $($exportResults['DattoVariables']['VariablesSet'])"
        Write-ComponentOutput -Section "Export" -Message "  Health Score: $($exportResults['DattoVariables']['HealthScore'])"
    }
}

Write-ComponentOutput -Section "Export" -Message "========================================="
#>

#endregion

Write-Output @"

DATTO RMM INTEGRATION GUIDE
============================

This script supports multiple export methods. Configure in Datto RMM using component variables:

COMPONENT VARIABLES TO CREATE:
------------------------------
CENTRAL_SHARE_PATH       = \\fileserver\ServerAudits$
AUDIT_USERNAME          = domain\serviceaccount (encrypted)
AUDIT_PASSWORD          = YourPassword (encrypted)
API_ENDPOINT            = https://your-api.example.com/audits
API_KEY                 = your-api-key (encrypted)
SMTP_SERVER             = smtp.office365.com
SMTP_PORT               = 587
EMAIL_FROM              = serveraudit@company.com
EMAIL_TO                = reports@company.com
EMAIL_USERNAME          = smtp-user@company.com (encrypted)
EMAIL_PASSWORD          = smtp-password (encrypted)
SPLUNK_HEC_URL          = https://splunk.company.com:8088/services/collector
SPLUNK_HEC_TOKEN        = your-splunk-token (encrypted)

USAGE EXAMPLES IN DATTO:
-----------------------
1. Export to file share only:
   powershell.exe -ExecutionPolicy Bypass -File "%ComponentPath%" -ExportToShare -SharePath "%CENTRAL_SHARE_PATH%" -ShareUsername "%AUDIT_USERNAME%" -SharePassword "%AUDIT_PASSWORD%"

2. Export to multiple destinations:
   powershell.exe -ExecutionPolicy Bypass -File "%ComponentPath%" -ExportToShare -SharePath "%CENTRAL_SHARE_PATH%" -ShareUsername "%AUDIT_USERNAME%" -SharePassword "%AUDIT_PASSWORD%" -ExportToAPI -ApiEndpoint "%API_ENDPOINT%" -ApiKey "%API_KEY%"

3. Full export (all methods):
   powershell.exe -ExecutionPolicy Bypass -File "%ComponentPath%" -ExportToShare -SharePath "%CENTRAL_SHARE_PATH%" -ShareUsername "%AUDIT_USERNAME%" -SharePassword "%AUDIT_PASSWORD%" -ExportToAPI -ApiEndpoint "%API_ENDPOINT%" -ApiKey "%API_KEY%" -ExportToEmail -SmtpServer "%SMTP_SERVER%" -EmailFrom "%EMAIL_FROM%" -EmailTo "%EMAIL_TO%" -EmailUsername "%EMAIL_USERNAME%" -EmailPassword "%EMAIL_PASSWORD%"

UDF MAPPINGS IN DATTO:
--------------------
Map these environment variables to Custom Device UDFs:

audit_total_shares       -> server_total_shares (Number)
audit_active_shares      -> server_active_shares (Number)
audit_inactive_shares    -> server_inactive_shares (Number)
audit_dns_zones          -> server_dns_zones (Number)
audit_dhcp_scopes        -> server_dhcp_scopes (Number)
audit_shared_printers    -> server_printers (Number)
audit_disk_total_gb      -> server_disk_total_gb (Number)
audit_disk_free_gb       -> server_disk_free_gb (Number)
audit_uptime_days        -> server_uptime_days (Number)
audit_memory_usage_pct   -> server_memory_pct (Number)
audit_internet_ok        -> server_internet_ok (Text)
audit_date               -> server_last_audit (Date)
audit_health_score       -> server_health_score (Number)
audit_json_data          -> server_audit_json (Text/Memo)

"@
