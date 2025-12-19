<#
.SYNOPSIS
    Validates domain controller migration health and service status.

.DESCRIPTION
    This script performs comprehensive validation of domain controllers during
    and after migration, including AD replication, DNS, DHCP, NPS, and Certificate
    Services health checks.

.PARAMETER DomainControllers
    Array of domain controller names to validate. If not specified, all DCs in
    the domain will be checked.

.PARAMETER CheckDHCP
    Include DHCP service validation.

.PARAMETER CheckNPS
    Include NPS (NPAS) service validation.

.PARAMETER CheckCA
    Include Certificate Authority validation.

.PARAMETER ExportReport
    Export results to HTML report file.

.PARAMETER ReportPath
    Path for HTML report export. Default: C:\Logs\DC-Migration-Report.html

.EXAMPLE
    .\Validate-DCMigration.ps1
    Validates all domain controllers with basic AD and DNS checks.

.EXAMPLE
    .\Validate-DCMigration.ps1 -DomainControllers "DC03","DC04" -CheckDHCP -CheckNPS -CheckCA -ExportReport
    Validates specified DCs with all service checks and exports HTML report.

.NOTES
    Author: Midwest Cloud Computing
    Requires: Domain Admin or Enterprise Admin permissions
    Version: 1.0
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string[]]$DomainControllers,

    [Parameter(Mandatory=$false)]
    [switch]$CheckDHCP,

    [Parameter(Mandatory=$false)]
    [switch]$CheckNPS,

    [Parameter(Mandatory=$false)]
    [switch]$CheckCA,

    [Parameter(Mandatory=$false)]
    [switch]$ExportReport,

    [Parameter(Mandatory=$false)]
    [string]$ReportPath = "C:\Logs\DC-Migration-Report.html"
)

# Initialize results array
$results = @()
$overallStatus = "PASS"

# Color coding for console output
function Write-StatusMessage {
    param(
        [string]$Message,
        [string]$Status  # PASS, FAIL, WARN, INFO
    )

    switch ($Status) {
        "PASS" { Write-Host "✓ $Message" -ForegroundColor Green }
        "FAIL" { Write-Host "✗ $Message" -ForegroundColor Red; $script:overallStatus = "FAIL" }
        "WARN" { Write-Host "⚠ $Message" -ForegroundColor Yellow }
        "INFO" { Write-Host "ℹ $Message" -ForegroundColor Cyan }
    }
}

# Function to add result to report
function Add-Result {
    param(
        [string]$Category,
        [string]$Test,
        [string]$Status,
        [string]$Details
    )

    $script:results += [PSCustomObject]@{
        Category = $Category
        Test = $Test
        Status = $Status
        Details = $Details
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
}

# Main validation function
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Domain Controller Migration Validation" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Get domain controllers if not specified
if (-not $DomainControllers) {
    Write-StatusMessage "Discovering domain controllers..." "INFO"
    $DomainControllers = (Get-ADDomainController -Filter *).Name
    Write-StatusMessage "Found $($DomainControllers.Count) domain controllers" "INFO"
}

Write-Host "`nDomain Controllers to validate:" -ForegroundColor Cyan
$DomainControllers | ForEach-Object { Write-Host "  - $_" }
Write-Host ""

#region Active Directory Health Checks

Write-Host "`n[1/6] Active Directory Health Checks" -ForegroundColor Yellow
Write-Host "=" * 50

# Check AD replication
Write-StatusMessage "Checking AD replication status..." "INFO"
try {
    $replSummary = repadmin /replsummary 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-StatusMessage "AD replication summary completed successfully" "PASS"
        Add-Result -Category "AD Replication" -Test "Replication Summary" -Status "PASS" -Details "All DCs replicating"
    } else {
        Write-StatusMessage "AD replication has errors - check repadmin output" "FAIL"
        Add-Result -Category "AD Replication" -Test "Replication Summary" -Status "FAIL" -Details "Replication errors detected"
    }
} catch {
    Write-StatusMessage "Failed to check replication: $($_.Exception.Message)" "FAIL"
    Add-Result -Category "AD Replication" -Test "Replication Summary" -Status "FAIL" -Details $_.Exception.Message
}

# Check each DC individually
foreach ($dc in $DomainControllers) {
    Write-StatusMessage "Validating $dc..." "INFO"

    # Ping test
    if (Test-Connection -ComputerName $dc -Count 2 -Quiet) {
        Write-StatusMessage "$dc is reachable" "PASS"
        Add-Result -Category "Connectivity" -Test "$dc Ping" -Status "PASS" -Details "DC is online"

        # LDAP connectivity
        try {
            $ldapTest = Test-NetConnection -ComputerName $dc -Port 389 -WarningAction SilentlyContinue
            if ($ldapTest.TcpTestSucceeded) {
                Write-StatusMessage "$dc LDAP port 389 is open" "PASS"
                Add-Result -Category "Connectivity" -Test "$dc LDAP" -Status "PASS" -Details "Port 389 open"
            } else {
                Write-StatusMessage "$dc LDAP port 389 is not accessible" "FAIL"
                Add-Result -Category "Connectivity" -Test "$dc LDAP" -Status "FAIL" -Details "Port 389 closed"
            }
        } catch {
            Write-StatusMessage "$dc LDAP test failed: $($_.Exception.Message)" "FAIL"
            Add-Result -Category "Connectivity" -Test "$dc LDAP" -Status "FAIL" -Details $_.Exception.Message
        }

        # Check DC is advertising
        try {
            $dcInfo = Get-ADDomainController -Identity $dc
            if ($dcInfo.Enabled) {
                Write-StatusMessage "$dc is advertising as DC" "PASS"
                Add-Result -Category "AD Services" -Test "$dc Advertising" -Status "PASS" -Details "DC enabled and advertising"
            } else {
                Write-StatusMessage "$dc is not advertising properly" "FAIL"
                Add-Result -Category "AD Services" -Test "$dc Advertising" -Status "FAIL" -Details "DC not advertising"
            }
        } catch {
            Write-StatusMessage "$dc AD query failed: $($_.Exception.Message)" "FAIL"
            Add-Result -Category "AD Services" -Test "$dc Advertising" -Status "FAIL" -Details $_.Exception.Message
        }

    } else {
        Write-StatusMessage "$dc is not reachable" "FAIL"
        Add-Result -Category "Connectivity" -Test "$dc Ping" -Status "FAIL" -Details "DC is offline or unreachable"
    }
}

# Check FSMO roles
Write-StatusMessage "Checking FSMO role holders..." "INFO"
try {
    $forest = Get-ADForest
    $domain = Get-ADDomain

    $fsmoRoles = @{
        "Schema Master" = $forest.SchemaMaster
        "Domain Naming Master" = $forest.DomainNamingMaster
        "PDC Emulator" = $domain.PDCEmulator
        "RID Master" = $domain.RIDMaster
        "Infrastructure Master" = $domain.InfrastructureMaster
    }

    foreach ($role in $fsmoRoles.GetEnumerator()) {
        Write-StatusMessage "$($role.Key): $($role.Value)" "INFO"
        Add-Result -Category "FSMO Roles" -Test $role.Key -Status "INFO" -Details $role.Value
    }
} catch {
    Write-StatusMessage "Failed to query FSMO roles: $($_.Exception.Message)" "FAIL"
    Add-Result -Category "FSMO Roles" -Test "FSMO Query" -Status "FAIL" -Details $_.Exception.Message
}

#endregion

#region DNS Validation

Write-Host "`n[2/6] DNS Service Validation" -ForegroundColor Yellow
Write-Host "=" * 50

foreach ($dc in $DomainControllers) {
    Write-StatusMessage "Checking DNS on $dc..." "INFO"

    # Check DNS service
    try {
        $dnsService = Get-Service -ComputerName $dc -Name DNS -ErrorAction Stop
        if ($dnsService.Status -eq 'Running') {
            Write-StatusMessage "$dc DNS service is running" "PASS"
            Add-Result -Category "DNS" -Test "$dc DNS Service" -Status "PASS" -Details "DNS service running"
        } else {
            Write-StatusMessage "$dc DNS service is not running ($($dnsService.Status))" "FAIL"
            Add-Result -Category "DNS" -Test "$dc DNS Service" -Status "FAIL" -Details "DNS service $($dnsService.Status)"
        }
    } catch {
        Write-StatusMessage "$dc DNS service check failed: $($_.Exception.Message)" "FAIL"
        Add-Result -Category "DNS" -Test "$dc DNS Service" -Status "FAIL" -Details $_.Exception.Message
    }

    # Test DNS resolution
    try {
        $domainName = (Get-ADDomain).DNSRoot
        $dnsTest = Resolve-DnsName -Name $domainName -Server $dc -ErrorAction Stop
        if ($dnsTest) {
            Write-StatusMessage "$dc DNS resolution working for $domainName" "PASS"
            Add-Result -Category "DNS" -Test "$dc DNS Resolution" -Status "PASS" -Details "Resolves $domainName"
        }
    } catch {
        Write-StatusMessage "$dc DNS resolution failed: $($_.Exception.Message)" "FAIL"
        Add-Result -Category "DNS" -Test "$dc DNS Resolution" -Status "FAIL" -Details $_.Exception.Message
    }
}

#endregion

#region DHCP Validation

if ($CheckDHCP) {
    Write-Host "`n[3/6] DHCP Service Validation" -ForegroundColor Yellow
    Write-Host "=" * 50

    # Get authorized DHCP servers
    try {
        $authorizedDHCP = Get-DhcpServerInDC -ErrorAction Stop
        Write-StatusMessage "Found $($authorizedDHCP.Count) authorized DHCP servers" "INFO"

        foreach ($dhcpServer in $authorizedDHCP) {
            $serverName = $dhcpServer.DnsName.Split('.')[0]
            Write-StatusMessage "Checking DHCP on $serverName..." "INFO"

            # Check DHCP service
            try {
                $dhcpService = Get-Service -ComputerName $serverName -Name DHCPServer -ErrorAction Stop
                if ($dhcpService.Status -eq 'Running') {
                    Write-StatusMessage "$serverName DHCP service is running" "PASS"
                    Add-Result -Category "DHCP" -Test "$serverName Service" -Status "PASS" -Details "DHCP service running"

                    # Get DHCP statistics
                    try {
                        $stats = Get-DhcpServerv4Statistics -ComputerName $serverName -ErrorAction Stop
                        Write-StatusMessage "$serverName DHCP stats: $($stats.InUse) leases in use, $($stats.Available) available" "INFO"
                        Add-Result -Category "DHCP" -Test "$serverName Statistics" -Status "INFO" -Details "$($stats.InUse) in use, $($stats.Available) available"

                        # Check for failover
                        try {
                            $failover = Get-DhcpServerv4Failover -ComputerName $serverName -ErrorAction Stop
                            if ($failover) {
                                foreach ($fo in $failover) {
                                    Write-StatusMessage "$serverName Failover: $($fo.Name) with $($fo.PartnerServer) - State: $($fo.State)" "INFO"
                                    Add-Result -Category "DHCP" -Test "$serverName Failover" -Status "INFO" -Details "Partner: $($fo.PartnerServer), State: $($fo.State)"
                                }
                            }
                        } catch {
                            Write-StatusMessage "$serverName No DHCP failover configured" "WARN"
                        }
                    } catch {
                        Write-StatusMessage "$serverName DHCP statistics query failed: $($_.Exception.Message)" "WARN"
                    }
                } else {
                    Write-StatusMessage "$serverName DHCP service is not running ($($dhcpService.Status))" "FAIL"
                    Add-Result -Category "DHCP" -Test "$serverName Service" -Status "FAIL" -Details "DHCP service $($dhcpService.Status)"
                }
            } catch {
                Write-StatusMessage "$serverName DHCP service check failed: $($_.Exception.Message)" "FAIL"
                Add-Result -Category "DHCP" -Test "$serverName Service" -Status "FAIL" -Details $_.Exception.Message
            }
        }
    } catch {
        Write-StatusMessage "Failed to query authorized DHCP servers: $($_.Exception.Message)" "FAIL"
        Add-Result -Category "DHCP" -Test "DHCP Discovery" -Status "FAIL" -Details $_.Exception.Message
    }
} else {
    Write-Host "`n[3/6] DHCP Service Validation - SKIPPED" -ForegroundColor Gray
}

#endregion

#region NPS Validation

if ($CheckNPS) {
    Write-Host "`n[4/6] NPS/RADIUS Validation" -ForegroundColor Yellow
    Write-Host "=" * 50

    foreach ($dc in $DomainControllers) {
        Write-StatusMessage "Checking NPS on $dc..." "INFO"

        # Check if NPS role is installed
        try {
            $npsFeature = Get-WindowsFeature -Name NPAS -ComputerName $dc -ErrorAction Stop
            if ($npsFeature.Installed) {
                Write-StatusMessage "$dc NPS role is installed" "PASS"
                Add-Result -Category "NPS" -Test "$dc Role Installed" -Status "PASS" -Details "NPS role present"

                # Check IAS service (NPS service)
                try {
                    $npsService = Get-Service -ComputerName $dc -Name IAS -ErrorAction Stop
                    if ($npsService.Status -eq 'Running') {
                        Write-StatusMessage "$dc NPS service is running" "PASS"
                        Add-Result -Category "NPS" -Test "$dc Service" -Status "PASS" -Details "NPS service running"

                        # Check for RADIUS clients (requires remote PowerShell)
                        try {
                            $radiusClients = Invoke-Command -ComputerName $dc -ScriptBlock {
                                Get-NpsRadiusClient
                            } -ErrorAction Stop

                            if ($radiusClients) {
                                Write-StatusMessage "$dc has $($radiusClients.Count) RADIUS clients configured" "INFO"
                                Add-Result -Category "NPS" -Test "$dc RADIUS Clients" -Status "INFO" -Details "$($radiusClients.Count) clients configured"
                            } else {
                                Write-StatusMessage "$dc has no RADIUS clients configured" "WARN"
                                Add-Result -Category "NPS" -Test "$dc RADIUS Clients" -Status "WARN" -Details "No RADIUS clients"
                            }
                        } catch {
                            Write-StatusMessage "$dc RADIUS client query failed: $($_.Exception.Message)" "WARN"
                        }
                    } else {
                        Write-StatusMessage "$dc NPS service is not running ($($npsService.Status))" "FAIL"
                        Add-Result -Category "NPS" -Test "$dc Service" -Status "FAIL" -Details "NPS service $($npsService.Status)"
                    }
                } catch {
                    Write-StatusMessage "$dc NPS service check failed: $($_.Exception.Message)" "FAIL"
                    Add-Result -Category "NPS" -Test "$dc Service" -Status "FAIL" -Details $_.Exception.Message
                }
            } else {
                Write-StatusMessage "$dc NPS role is not installed" "INFO"
                Add-Result -Category "NPS" -Test "$dc Role Installed" -Status "INFO" -Details "NPS role not present"
            }
        } catch {
            Write-StatusMessage "$dc NPS feature check failed: $($_.Exception.Message)" "WARN"
            Add-Result -Category "NPS" -Test "$dc Role Installed" -Status "WARN" -Details $_.Exception.Message
        }
    }
} else {
    Write-Host "`n[4/6] NPS/RADIUS Validation - SKIPPED" -ForegroundColor Gray
}

#endregion

#region Certificate Authority Validation

if ($CheckCA) {
    Write-Host "`n[5/6] Certificate Authority Validation" -ForegroundColor Yellow
    Write-Host "=" * 50

    foreach ($dc in $DomainControllers) {
        Write-StatusMessage "Checking Certificate Services on $dc..." "INFO"

        # Check if AD CS role is installed
        try {
            $adcsFeature = Get-WindowsFeature -Name AD-Certificate -ComputerName $dc -ErrorAction Stop
            if ($adcsFeature.Installed) {
                Write-StatusMessage "$dc AD CS role is installed" "PASS"
                Add-Result -Category "Certificate Services" -Test "$dc Role Installed" -Status "PASS" -Details "AD CS role present"

                # Check CertSvc service
                try {
                    $certService = Get-Service -ComputerName $dc -Name CertSvc -ErrorAction Stop
                    if ($certService.Status -eq 'Running') {
                        Write-StatusMessage "$dc Certificate Services is running" "PASS"
                        Add-Result -Category "Certificate Services" -Test "$dc Service" -Status "PASS" -Details "CertSvc running"

                        # Try to ping the CA
                        try {
                            $caPing = certutil -ping -config "$dc\*" 2>&1
                            if ($LASTEXITCODE -eq 0) {
                                Write-StatusMessage "$dc CA is responding to ping" "PASS"
                                Add-Result -Category "Certificate Services" -Test "$dc CA Ping" -Status "PASS" -Details "CA responding"
                            } else {
                                Write-StatusMessage "$dc CA ping failed" "FAIL"
                                Add-Result -Category "Certificate Services" -Test "$dc CA Ping" -Status "FAIL" -Details "CA not responding"
                            }
                        } catch {
                            Write-StatusMessage "$dc CA ping test failed: $($_.Exception.Message)" "WARN"
                        }
                    } else {
                        Write-StatusMessage "$dc Certificate Services is not running ($($certService.Status))" "FAIL"
                        Add-Result -Category "Certificate Services" -Test "$dc Service" -Status "FAIL" -Details "CertSvc $($certService.Status)"
                    }
                } catch {
                    Write-StatusMessage "$dc Certificate Services check failed: $($_.Exception.Message)" "FAIL"
                    Add-Result -Category "Certificate Services" -Test "$dc Service" -Status "FAIL" -Details $_.Exception.Message
                }
            } else {
                Write-StatusMessage "$dc AD CS role is not installed" "INFO"
                Add-Result -Category "Certificate Services" -Test "$dc Role Installed" -Status "INFO" -Details "AD CS not present"
            }
        } catch {
            Write-StatusMessage "$dc AD CS feature check failed: $($_.Exception.Message)" "WARN"
            Add-Result -Category "Certificate Services" -Test "$dc Role Installed" -Status "WARN" -Details $_.Exception.Message
        }
    }
} else {
    Write-Host "`n[5/6] Certificate Authority Validation - SKIPPED" -ForegroundColor Gray
}

#endregion

#region Summary Report

Write-Host "`n[6/6] Validation Summary" -ForegroundColor Yellow
Write-Host "=" * 50

$passCount = ($results | Where-Object {$_.Status -eq "PASS"}).Count
$failCount = ($results | Where-Object {$_.Status -eq "FAIL"}).Count
$warnCount = ($results | Where-Object {$_.Status -eq "WARN"}).Count
$infoCount = ($results | Where-Object {$_.Status -eq "INFO"}).Count

Write-Host "`nTest Results:" -ForegroundColor Cyan
Write-Host "  PASS: $passCount" -ForegroundColor Green
Write-Host "  FAIL: $failCount" -ForegroundColor Red
Write-Host "  WARN: $warnCount" -ForegroundColor Yellow
Write-Host "  INFO: $infoCount" -ForegroundColor Cyan

if ($failCount -gt 0) {
    Write-Host "`nFailed Tests:" -ForegroundColor Red
    $results | Where-Object {$_.Status -eq "FAIL"} | ForEach-Object {
        Write-Host "  ✗ [$($_.Category)] $($_.Test): $($_.Details)" -ForegroundColor Red
    }
}

if ($warnCount -gt 0) {
    Write-Host "`nWarnings:" -ForegroundColor Yellow
    $results | Where-Object {$_.Status -eq "WARN"} | ForEach-Object {
        Write-Host "  ⚠ [$($_.Category)] $($_.Test): $($_.Details)" -ForegroundColor Yellow
    }
}

# Overall status
Write-Host "`nOverall Status: " -NoNewline
if ($overallStatus -eq "PASS" -and $failCount -eq 0) {
    Write-Host "✓ HEALTHY" -ForegroundColor Green
} else {
    Write-Host "✗ ISSUES DETECTED" -ForegroundColor Red
}

#endregion

#region HTML Report Export

if ($ExportReport) {
    Write-Host "`nExporting HTML report to $ReportPath..." -ForegroundColor Cyan

    # Ensure directory exists
    $reportDir = Split-Path -Path $ReportPath -Parent
    if (-not (Test-Path $reportDir)) {
        New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
    }

    # Generate HTML
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>DC Migration Validation Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        h1 { color: #333; border-bottom: 3px solid #007bff; padding-bottom: 10px; }
        h2 { color: #555; margin-top: 30px; border-bottom: 2px solid #6c757d; padding-bottom: 5px; }
        .summary { background-color: white; padding: 20px; border-radius: 5px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .summary-item { display: inline-block; margin-right: 30px; padding: 10px 20px; border-radius: 3px; }
        .pass { background-color: #d4edda; color: #155724; }
        .fail { background-color: #f8d7da; color: #721c24; }
        .warn { background-color: #fff3cd; color: #856404; }
        .info { background-color: #d1ecf1; color: #0c5460; }
        table { width: 100%; border-collapse: collapse; background-color: white; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th { background-color: #007bff; color: white; padding: 12px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f1f1f1; }
        .status-pass { color: #28a745; font-weight: bold; }
        .status-fail { color: #dc3545; font-weight: bold; }
        .status-warn { color: #ffc107; font-weight: bold; }
        .status-info { color: #17a2b8; font-weight: bold; }
        .footer { margin-top: 30px; padding: 20px; background-color: white; border-radius: 5px; text-align: center; color: #666; }
    </style>
</head>
<body>
    <h1>Domain Controller Migration Validation Report</h1>
    <p><strong>Generated:</strong> $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
    <p><strong>Domain Controllers:</strong> $($DomainControllers -join ", ")</p>

    <div class="summary">
        <h2>Summary</h2>
        <div class="summary-item pass">✓ PASS: $passCount</div>
        <div class="summary-item fail">✗ FAIL: $failCount</div>
        <div class="summary-item warn">⚠ WARN: $warnCount</div>
        <div class="summary-item info">ℹ INFO: $infoCount</div>
    </div>
"@

    # Group results by category
    $categories = $results | Group-Object -Property Category

    foreach ($category in $categories) {
        $html += "`n    <h2>$($category.Name)</h2>`n"
        $html += "    <table>`n"
        $html += "        <tr><th>Test</th><th>Status</th><th>Details</th><th>Timestamp</th></tr>`n"

        foreach ($result in $category.Group) {
            $statusClass = "status-$($result.Status.ToLower())"
            $html += "        <tr>`n"
            $html += "            <td>$($result.Test)</td>`n"
            $html += "            <td class='$statusClass'>$($result.Status)</td>`n"
            $html += "            <td>$($result.Details)</td>`n"
            $html += "            <td>$($result.Timestamp)</td>`n"
            $html += "        </tr>`n"
        }

        $html += "    </table>`n"
    }

    $html += @"
    <div class="footer">
        <p>Midwest Cloud Computing - Domain Controller Migration Validation</p>
        <p>Report generated by Validate-DCMigration.ps1</p>
    </div>
</body>
</html>
"@

    # Save HTML report
    $html | Out-File -FilePath $ReportPath -Encoding UTF8
    Write-StatusMessage "Report exported to $ReportPath" "PASS"

    # Try to open report in default browser
    try {
        Start-Process $ReportPath
    } catch {
        Write-StatusMessage "Report saved, but could not auto-open: $($_.Exception.Message)" "WARN"
    }
}

#endregion

Write-Host "`n========================================`n" -ForegroundColor Cyan
