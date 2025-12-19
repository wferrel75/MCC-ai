<#
.SYNOPSIS
    Retrieves an expanded software inventory for a specific Datto RMM site with device-level details.

.DESCRIPTION
    This script connects to the Datto RMM API and retrieves all devices for a specified site,
    then queries the software inventory for each device. The output creates a detailed report
    showing which specific devices have which software installed.

.PARAMETER SiteUid
    The UID of the site to query. Can be found via the Datto RMM portal or API.

.PARAMETER OutputPath
    Optional. Path where the CSV report will be saved. Defaults to current directory.

.PARAMETER MaxDevices
    Optional. Maximum number of devices to query (for testing). Default is unlimited.

.EXAMPLE
    .\Get-SiteSoftwareInventory.ps1 -SiteUid "abc-123-def-456"

.EXAMPLE
    .\Get-SiteSoftwareInventory.ps1 -SiteUid "abc-123-def-456" -OutputPath "C:\Reports\software.csv" -MaxDevices 10

.NOTES
    Requires:
    - DattoRMM PowerShell module installed
    - API credentials configured via dattormm-api-setup.ps1
    - API access enabled in Datto RMM portal
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$SiteUid,

    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".\SoftwareInventory_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv",

    [Parameter(Mandatory=$false)]
    [int]$MaxDevices = 0  # 0 = unlimited
)

# Import the DattoRMM module
try {
    Import-Module DattoRMM -ErrorAction Stop
    Write-Host "✓ DattoRMM module loaded successfully" -ForegroundColor Green
} catch {
    Write-Error "Failed to load DattoRMM module. Run 'Install-Module DattoRMM' first."
    exit 1
}

# Load saved credentials
$credsPath = "$PSScriptRoot\dattormm-credentials.xml"
if (-not (Test-Path $credsPath)) {
    Write-Error "Credentials file not found. Run dattormm-api-setup.ps1 -Action Setup first."
    exit 1
}

try {
    $Creds = Import-Clixml $credsPath

    # Decrypt credentials (they're encrypted with DPAPI)
    $ApiUrl = $Creds.ApiUrl
    $ApiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Creds.ApiKey)
    )
    $ApiSecretKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Creds.ApiSecretKey)
    )

    # Set API parameters
    Set-DrmmApiParameters -Url $ApiUrl -Key $ApiKey -SecretKey $ApiSecretKey
    Write-Host "✓ API credentials loaded successfully" -ForegroundColor Green
} catch {
    Write-Error "Failed to load or decrypt credentials: $_"
    exit 1
}

# Initialize results array
$results = @()
$deviceCount = 0
$softwareCount = 0

Write-Host "`n=== Datto RMM Software Inventory Report ===" -ForegroundColor Cyan
Write-Host "Site UID: $SiteUid"
Write-Host "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"

# Get site information
try {
    Write-Host "Fetching site information..." -ForegroundColor Yellow
    $site = Get-DrmmSite -siteUid $SiteUid
    if (-not $site) {
        Write-Error "Site not found with UID: $SiteUid"
        exit 1
    }
    Write-Host "✓ Site: $($site.name)" -ForegroundColor Green
} catch {
    Write-Error "Failed to retrieve site: $_"
    exit 1
}

# Get all devices for the site
try {
    Write-Host "Fetching devices for site..." -ForegroundColor Yellow
    $devices = Get-DrmmSiteDevices -siteUid $SiteUid

    if ($MaxDevices -gt 0 -and $devices.Count -gt $MaxDevices) {
        Write-Host "⚠ Limiting to first $MaxDevices devices (for testing)" -ForegroundColor Yellow
        $devices = $devices | Select-Object -First $MaxDevices
    }

    Write-Host "✓ Found $($devices.Count) devices" -ForegroundColor Green
} catch {
    Write-Error "Failed to retrieve devices: $_"
    exit 1
}

# Process each device
foreach ($device in $devices) {
    $deviceCount++
    Write-Host "`n[$deviceCount/$($devices.Count)] Processing: $($device.hostname)" -ForegroundColor Cyan

    try {
        # Get software audit data for this device
        $page = 1
        $maxPerPage = 100
        $deviceSoftware = @()

        do {
            Write-Host "  Fetching software (page $page)..." -ForegroundColor Gray

            # API call to get device software
            $softwarePage = Get-DrmmAuditDeviceSoftware -deviceUid $device.uid -page $page -max $maxPerPage

            if ($softwarePage -and $softwarePage.software) {
                $deviceSoftware += $softwarePage.software
                $hasMore = $softwarePage.software.Count -eq $maxPerPage
                $page++
            } else {
                $hasMore = $false
            }
        } while ($hasMore)

        Write-Host "  ✓ Found $($deviceSoftware.Count) installed applications" -ForegroundColor Green

        # Create result objects
        foreach ($software in $deviceSoftware) {
            $results += [PSCustomObject]@{
                SiteName = $site.name
                SiteUID = $site.uid
                DeviceHostname = $device.hostname
                DeviceUID = $device.uid
                DeviceType = $device.deviceType.type
                OperatingSystem = $device.operatingSystem
                DeviceOnline = $device.online
                SoftwareName = $software.name
                SoftwareVersion = $software.version
                LastAuditDate = $device.lastAuditDate
                ReportGeneratedDate = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            }
            $softwareCount++
        }

    } catch {
        Write-Warning "  ⚠ Failed to retrieve software for $($device.hostname): $_"
    }
}

# Export to CSV
try {
    Write-Host "`nExporting results to CSV..." -ForegroundColor Yellow
    $results | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
    Write-Host "✓ Report saved to: $OutputPath" -ForegroundColor Green
} catch {
    Write-Error "Failed to export CSV: $_"
}

# Summary
Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Total Devices Processed: $deviceCount"
Write-Host "Total Software Entries: $softwareCount"
Write-Host "Average Software per Device: $([math]::Round($softwareCount / $deviceCount, 2))"
Write-Host "Report Location: $OutputPath"
Write-Host "`nCompleted: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Green
