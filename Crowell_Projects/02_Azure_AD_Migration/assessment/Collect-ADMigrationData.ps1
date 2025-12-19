<#
.SYNOPSIS
    Collects Active Directory and infrastructure data for Azure AD migration assessment

.DESCRIPTION
    This script collects comprehensive data from SERVER-FS1 (Crowell Memorial Home) for Azure AD migration planning.
    Exports include: users, computers, groups, OUs, GPOs, DNS zones, file shares, permissions, and system information.

    ⚠️ IMPORTANT: This server is Windows Server 2008 R2 (END OF LIFE since 2020)

.PARAMETER OutputPath
    Path where export files will be saved. Default: C:\ADMigration_Export

.EXAMPLE
    .\Collect-ADMigrationData.ps1

.EXAMPLE
    .\Collect-ADMigrationData.ps1 -OutputPath "C:\Temp\AD_Data"

.NOTES
    Author: MCC MSP Team
    Date: 2025-12-11
    Customer: Crowell Memorial Home
    Domain: crowell.local

    Requirements:
    - Must run on SERVER-FS1 (Domain Controller)
    - Must run as Domain Admin
    - PowerShell 2.0+ (Server 2008 R2 has PowerShell 2.0)

#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$OutputPath = "C:\ADMigration_Export"
)

# Script start
$ErrorActionPreference = "Continue"
$StartTime = Get-Date

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Crowell Memorial Home" -ForegroundColor Cyan
Write-Host "  Azure AD Migration Data Collection" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "[INFO] Script started at: $StartTime" -ForegroundColor Green
Write-Host "[INFO] Output directory: $OutputPath" -ForegroundColor Green

# Create output directory
if (-not (Test-Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
    Write-Host "[OK] Created output directory" -ForegroundColor Green
} else {
    Write-Host "[OK] Output directory exists" -ForegroundColor Green
}

# Log file
$LogFile = Join-Path $OutputPath "Collection_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
function Write-Log {
    param($Message, $Color = "White")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] $Message"
    Add-Content -Path $LogFile -Value $LogMessage
    Write-Host $Message -ForegroundColor $Color
}

Write-Log "=== Data Collection Started ===" "Cyan"
Write-Log "Server: $env:COMPUTERNAME"
Write-Log "Domain: $env:USERDNSDOMAIN"
Write-Log "User: $env:USERNAME"

# Import Active Directory module (Server 2008 R2)
Write-Log "`n[1/15] Loading Active Directory module..." "Yellow"
try {
    Import-Module ActiveDirectory -ErrorAction Stop
    Write-Log "[OK] Active Directory module loaded" "Green"
} catch {
    Write-Log "[ERROR] Failed to load AD module: $_" "Red"
    Write-Log "[ERROR] This script must run on a Domain Controller with AD PowerShell installed" "Red"
    exit 1
}

#
# 1. EXPORT USERS
#
Write-Log "`n[2/15] Exporting Active Directory Users..." "Yellow"
try {
    $Users = Get-ADUser -Filter * -Properties *
    $UserCount = ($Users | Measure-Object).Count

    $Users | Select-Object `
        Name, SamAccountName, UserPrincipalName, EmailAddress, `
        Enabled, PasswordNeverExpires, PasswordLastSet, LastLogonDate, `
        Created, Modified, Description, Title, Department, `
        Manager, DistinguishedName, MemberOf | `
        Export-Csv -Path (Join-Path $OutputPath "AD_Users.csv") -NoTypeInformation

    Write-Log "[OK] Exported $UserCount users to AD_Users.csv" "Green"

    # Identify service accounts
    $ServiceAccounts = Get-ADUser -Filter {ServicePrincipalName -like "*"}
    $ServiceAccounts | Select-Object Name, SamAccountName, ServicePrincipalName | `
        Export-Csv -Path (Join-Path $OutputPath "AD_ServiceAccounts.csv") -NoTypeInformation
    Write-Log "[OK] Exported $($ServiceAccounts.Count) service accounts to AD_ServiceAccounts.csv" "Green"

} catch {
    Write-Log "[ERROR] Failed to export users: $_" "Red"
}

#
# 2. EXPORT COMPUTERS
#
Write-Log "`n[3/15] Exporting Active Directory Computers..." "Yellow"
try {
    $Computers = Get-ADComputer -Filter * -Properties *
    $ComputerCount = ($Computers | Measure-Object).Count

    $Computers | Select-Object `
        Name, DNSHostName, OperatingSystem, OperatingSystemVersion, `
        Enabled, LastLogonDate, Created, Modified, `
        IPv4Address, DistinguishedName | `
        Export-Csv -Path (Join-Path $OutputPath "AD_Computers.csv") -NoTypeInformation

    Write-Log "[OK] Exported $ComputerCount computers to AD_Computers.csv" "Green"

    # OS Summary
    $Computers | Group-Object OperatingSystem | `
        Select-Object Name, Count | `
        Export-Csv -Path (Join-Path $OutputPath "AD_Computers_OS_Summary.csv") -NoTypeInformation
    Write-Log "[OK] Exported OS summary to AD_Computers_OS_Summary.csv" "Green"

} catch {
    Write-Log "[ERROR] Failed to export computers: $_" "Red"
}

#
# 3. EXPORT GROUPS
#
Write-Log "`n[4/15] Exporting Active Directory Groups..." "Yellow"
try {
    $Groups = Get-ADGroup -Filter * -Properties *
    $GroupCount = ($Groups | Measure-Object).Count

    $Groups | Select-Object `
        Name, SamAccountName, GroupCategory, GroupScope, `
        Description, ManagedBy, Created, Modified, `
        MemberOf, Members, DistinguishedName | `
        Export-Csv -Path (Join-Path $OutputPath "AD_Groups.csv") -NoTypeInformation

    Write-Log "[OK] Exported $GroupCount groups to AD_Groups.csv" "Green"

    # Group memberships detail
    $GroupMemberships = @()
    foreach ($Group in $Groups) {
        $Members = Get-ADGroupMember -Identity $Group -ErrorAction SilentlyContinue
        foreach ($Member in $Members) {
            $GroupMemberships += [PSCustomObject]@{
                GroupName = $Group.Name
                MemberName = $Member.Name
                MemberType = $Member.objectClass
                MemberSamAccountName = $Member.SamAccountName
            }
        }
    }
    $GroupMemberships | Export-Csv -Path (Join-Path $OutputPath "AD_GroupMemberships.csv") -NoTypeInformation
    Write-Log "[OK] Exported group memberships to AD_GroupMemberships.csv" "Green"

} catch {
    Write-Log "[ERROR] Failed to export groups: $_" "Red"
}

#
# 4. EXPORT ORGANIZATIONAL UNITS
#
Write-Log "`n[5/15] Exporting Organizational Units..." "Yellow"
try {
    $OUs = Get-ADOrganizationalUnit -Filter * -Properties *
    $OUCount = ($OUs | Measure-Object).Count

    $OUs | Select-Object `
        Name, DistinguishedName, Description, Created, Modified, `
        ManagedBy, ProtectedFromAccidentalDeletion | `
        Export-Csv -Path (Join-Path $OutputPath "AD_OUs.csv") -NoTypeInformation

    Write-Log "[OK] Exported $OUCount OUs to AD_OUs.csv" "Green"
} catch {
    Write-Log "[ERROR] Failed to export OUs: $_" "Red"
}

#
# 5. EXPORT GROUP POLICY OBJECTS
#
Write-Log "`n[6/15] Exporting Group Policy Objects..." "Yellow"
try {
    Import-Module GroupPolicy -ErrorAction Stop

    $GPOs = Get-GPO -All
    $GPOCount = ($GPOs | Measure-Object).Count

    $GPOs | Select-Object `
        DisplayName, Id, GpoStatus, CreationTime, ModificationTime, `
        Description, Owner | `
        Export-Csv -Path (Join-Path $OutputPath "AD_GPOs.csv") -NoTypeInformation

    Write-Log "[OK] Exported $GPOCount GPOs to AD_GPOs.csv" "Green"

    # Backup all GPOs
    $GPOBackupPath = Join-Path $OutputPath "GPO_Backups"
    if (-not (Test-Path $GPOBackupPath)) {
        New-Item -Path $GPOBackupPath -ItemType Directory -Force | Out-Null
    }

    Backup-GPO -All -Path $GPOBackupPath | Out-Null
    Write-Log "[OK] Backed up all GPOs to GPO_Backups\" "Green"

    # GPO Links
    $GPOLinks = @()
    foreach ($GPO in $GPOs) {
        $Links = Get-GPO -Name $GPO.DisplayName | Get-GPInheritance -Target "DC=$env:USERDNSDOMAIN"
        if ($Links) {
            $GPOLinks += [PSCustomObject]@{
                GPOName = $GPO.DisplayName
                LinkedTo = $Links.Path
                Enforced = $Links.Enforced
                Enabled = $Links.Enabled
            }
        }
    }
    $GPOLinks | Export-Csv -Path (Join-Path $OutputPath "AD_GPO_Links.csv") -NoTypeInformation
    Write-Log "[OK] Exported GPO links to AD_GPO_Links.csv" "Green"

} catch {
    Write-Log "[ERROR] Failed to export GPOs: $_" "Red"
}

#
# 6. EXPORT DNS ZONES
#
Write-Log "`n[7/15] Exporting DNS Zones..." "Yellow"
try {
    $DNSZones = Get-DnsServerZone
    $ZoneCount = ($DNSZones | Measure-Object).Count

    $DNSZones | Select-Object `
        ZoneName, ZoneType, DynamicUpdate, IsAutoCreated, `
        IsDsIntegrated, IsReverseLookupZone, IsSigned | `
        Export-Csv -Path (Join-Path $OutputPath "DNS_Zones.csv") -NoTypeInformation

    Write-Log "[OK] Exported $ZoneCount DNS zones to DNS_Zones.csv" "Green"

    # Export DNS records for each zone
    foreach ($Zone in $DNSZones) {
        try {
            $Records = Get-DnsServerResourceRecord -ZoneName $Zone.ZoneName
            $SafeZoneName = $Zone.ZoneName -replace "[^a-zA-Z0-9]", "_"
            $Records | Select-Object `
                HostName, RecordType, Timestamp, TimeToLive, `
                RecordData | `
                Export-Csv -Path (Join-Path $OutputPath "DNS_Records_$SafeZoneName.csv") -NoTypeInformation
            Write-Log "[OK] Exported DNS records for zone: $($Zone.ZoneName)" "Green"
        } catch {
            Write-Log "[WARNING] Failed to export records for zone $($Zone.ZoneName): $_" "Yellow"
        }
    }

} catch {
    Write-Log "[ERROR] Failed to export DNS zones: $_" "Red"
}

#
# 7. EXPORT FILE SHARES
#
Write-Log "`n[8/15] Exporting File Shares..." "Yellow"
try {
    $Shares = Get-WmiObject -Class Win32_Share | Where-Object { $_.Type -eq 0 }
    $ShareCount = ($Shares | Measure-Object).Count

    $Shares | Select-Object Name, Path, Description | `
        Export-Csv -Path (Join-Path $OutputPath "FileShares.csv") -NoTypeInformation

    Write-Log "[OK] Exported $ShareCount file shares to FileShares.csv" "Green"

    # Share permissions
    $SharePerms = @()
    foreach ($Share in $Shares) {
        try {
            $ShareSecurity = Get-WmiObject -Class Win32_LogicalShareSecuritySetting -Filter "Name='$($Share.Name)'"
            $SecurityDescriptor = $ShareSecurity.GetSecurityDescriptor().Descriptor

            foreach ($ACE in $SecurityDescriptor.DACL) {
                $Trustee = $ACE.Trustee.Name
                if ($ACE.Trustee.Domain) {
                    $Trustee = "$($ACE.Trustee.Domain)\$($ACE.Trustee.Name)"
                }

                $SharePerms += [PSCustomObject]@{
                    ShareName = $Share.Name
                    Trustee = $Trustee
                    AccessMask = $ACE.AccessMask
                    AceType = $ACE.AceType
                }
            }
        } catch {
            Write-Log "[WARNING] Failed to get permissions for share: $($Share.Name)" "Yellow"
        }
    }
    $SharePerms | Export-Csv -Path (Join-Path $OutputPath "FileShare_Permissions.csv") -NoTypeInformation
    Write-Log "[OK] Exported share permissions to FileShare_Permissions.csv" "Green"

    # Share sizes
    $ShareSizes = @()
    foreach ($Share in $Shares) {
        if ($Share.Path) {
            try {
                $Size = (Get-ChildItem -Path $Share.Path -Recurse -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                $SizeGB = [math]::Round($Size / 1GB, 2)

                $ShareSizes += [PSCustomObject]@{
                    ShareName = $Share.Name
                    Path = $Share.Path
                    SizeGB = $SizeGB
                }
            } catch {
                Write-Log "[WARNING] Failed to calculate size for: $($Share.Name)" "Yellow"
            }
        }
    }
    $ShareSizes | Export-Csv -Path (Join-Path $OutputPath "FileShare_Sizes.csv") -NoTypeInformation
    Write-Log "[OK] Exported share sizes to FileShare_Sizes.csv" "Green"

} catch {
    Write-Log "[ERROR] Failed to export file shares: $_" "Red"
}

#
# 8. EXPORT DOMAIN INFORMATION
#
Write-Log "`n[9/15] Exporting Domain Information..." "Yellow"
try {
    $Domain = Get-ADDomain
    $Forest = Get-ADForest

    $DomainInfo = [PSCustomObject]@{
        DomainName = $Domain.DNSRoot
        NetBIOSName = $Domain.NetBIOSName
        DomainMode = $Domain.DomainMode
        ForestMode = $Forest.ForestMode
        DomainSID = $Domain.DomainSID
        PDCEmulator = $Domain.PDCEmulator
        RIDMaster = $Domain.RIDMaster
        InfrastructureMaster = $Domain.InfrastructureMaster
        SchemaMaster = $Forest.SchemaMaster
        DomainNamingMaster = $Forest.DomainNamingMaster
    }

    $DomainInfo | Export-Csv -Path (Join-Path $OutputPath "Domain_Info.csv") -NoTypeInformation
    Write-Log "[OK] Exported domain information to Domain_Info.csv" "Green"

} catch {
    Write-Log "[ERROR] Failed to export domain information: $_" "Red"
}

#
# 9. EXPORT DOMAIN CONTROLLERS
#
Write-Log "`n[10/15] Exporting Domain Controllers..." "Yellow"
try {
    $DCs = Get-ADDomainController -Filter *
    $DCCount = ($DCs | Measure-Object).Count

    $DCs | Select-Object `
        Name, HostName, IPv4Address, OperatingSystem, `
        IsGlobalCatalog, IsReadOnly, Site, Enabled | `
        Export-Csv -Path (Join-Path $OutputPath "DomainControllers.csv") -NoTypeInformation

    Write-Log "[OK] Exported $DCCount domain controllers to DomainControllers.csv" "Green"
} catch {
    Write-Log "[ERROR] Failed to export domain controllers: $_" "Red"
}

#
# 10. EXPORT PASSWORD POLICY
#
Write-Log "`n[11/15] Exporting Password Policy..." "Yellow"
try {
    $PasswordPolicy = Get-ADDefaultDomainPasswordPolicy

    $PasswordPolicy | Select-Object `
        ComplexityEnabled, DistinguishedName, LockoutDuration, `
        LockoutObservationWindow, LockoutThreshold, MaxPasswordAge, `
        MinPasswordAge, MinPasswordLength, PasswordHistoryCount, `
        ReversibleEncryptionEnabled | `
        Export-Csv -Path (Join-Path $OutputPath "PasswordPolicy.csv") -NoTypeInformation

    Write-Log "[OK] Exported password policy to PasswordPolicy.csv" "Green"

    # Fine-Grained Password Policies (if any)
    try {
        $FGPPs = Get-ADFineGrainedPasswordPolicy -Filter *
        if ($FGPPs) {
            $FGPPs | Export-Csv -Path (Join-Path $OutputPath "FineGrainedPasswordPolicies.csv") -NoTypeInformation
            Write-Log "[OK] Exported fine-grained password policies" "Green"
        }
    } catch {
        Write-Log "[INFO] No fine-grained password policies found" "White"
    }

} catch {
    Write-Log "[ERROR] Failed to export password policy: $_" "Red"
}

#
# 11. EXPORT SYSTEM INFORMATION
#
Write-Log "`n[12/15] Exporting System Information..." "Yellow"
try {
    $OS = Get-WmiObject -Class Win32_OperatingSystem
    $Computer = Get-WmiObject -Class Win32_ComputerSystem

    $SystemInfo = [PSCustomObject]@{
        ComputerName = $Computer.Name
        Domain = $Computer.Domain
        OSName = $OS.Caption
        OSVersion = $OS.Version
        OSArchitecture = $OS.OSArchitecture
        ServicePackMajorVersion = $OS.ServicePackMajorVersion
        ServicePackMinorVersion = $OS.ServicePackMinorVersion
        InstallDate = $OS.InstallDate
        LastBootUpTime = $OS.LastBootUpTime
        TotalPhysicalMemoryGB = [math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)
        NumberOfProcessors = $Computer.NumberOfProcessors
        NumberOfLogicalProcessors = $Computer.NumberOfLogicalProcessors
    }

    $SystemInfo | Export-Csv -Path (Join-Path $OutputPath "SystemInfo.csv") -NoTypeInformation
    Write-Log "[OK] Exported system information to SystemInfo.csv" "Green"

} catch {
    Write-Log "[ERROR] Failed to export system information: $_" "Red"
}

#
# 12. EXPORT NETWORK CONFIGURATION
#
Write-Log "`n[13/15] Exporting Network Configuration..." "Yellow"
try {
    $NetAdapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

    $NetAdapters | Select-Object `
        Description, IPAddress, IPSubnet, DefaultIPGateway, `
        DNSServerSearchOrder, DHCPEnabled, DHCPServer, `
        MACAddress | `
        Export-Csv -Path (Join-Path $OutputPath "NetworkConfig.csv") -NoTypeInformation

    Write-Log "[OK] Exported network configuration to NetworkConfig.csv" "Green"
} catch {
    Write-Log "[ERROR] Failed to export network configuration: $_" "Red"
}

#
# 13. EXPORT INSTALLED FEATURES/ROLES
#
Write-Log "`n[14/15] Exporting Installed Windows Features..." "Yellow"
try {
    Import-Module ServerManager -ErrorAction SilentlyContinue
    $Features = Get-WindowsFeature | Where-Object { $_.Installed -eq $true }
    $FeatureCount = ($Features | Measure-Object).Count

    $Features | Select-Object Name, DisplayName, FeatureType, Path | `
        Export-Csv -Path (Join-Path $OutputPath "InstalledFeatures.csv") -NoTypeInformation

    Write-Log "[OK] Exported $FeatureCount installed features to InstalledFeatures.csv" "Green"
} catch {
    Write-Log "[ERROR] Failed to export installed features: $_" "Red"
}

#
# 14. EXPORT IIS CONFIGURATION (if IIS is installed)
#
Write-Log "`n[15/15] Exporting IIS Configuration..." "Yellow"
try {
    Import-Module WebAdministration -ErrorAction Stop

    # Websites
    $Websites = Get-Website
    $Websites | Select-Object Name, Id, State, PhysicalPath, ApplicationPool | `
        Export-Csv -Path (Join-Path $OutputPath "IIS_Websites.csv") -NoTypeInformation
    Write-Log "[OK] Exported IIS websites to IIS_Websites.csv" "Green"

    # Application Pools
    $AppPools = Get-ChildItem IIS:\AppPools
    $AppPools | Select-Object Name, State, ManagedRuntimeVersion, ManagedPipelineMode | `
        Export-Csv -Path (Join-Path $OutputPath "IIS_AppPools.csv") -NoTypeInformation
    Write-Log "[OK] Exported IIS application pools to IIS_AppPools.csv" "Green"

} catch {
    Write-Log "[INFO] IIS not installed or WebAdministration module not available" "White"
}

#
# SUMMARY
#
$EndTime = Get-Date
$Duration = $EndTime - $StartTime

Write-Log "`n=== Data Collection Completed ===" "Cyan"
Write-Log "Start Time: $StartTime"
Write-Log "End Time: $EndTime"
Write-Log "Duration: $($Duration.ToString('mm\:ss'))"
Write-Log "Output Directory: $OutputPath"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Collection Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "All data exported to: $OutputPath" -ForegroundColor Green
Write-Host "`nKey Files:" -ForegroundColor Yellow
Write-Host "  - AD_Users.csv ($UserCount users)" -ForegroundColor White
Write-Host "  - AD_Computers.csv ($ComputerCount computers)" -ForegroundColor White
Write-Host "  - AD_Groups.csv ($GroupCount groups)" -ForegroundColor White
Write-Host "  - AD_OUs.csv ($OUCount OUs)" -ForegroundColor White
Write-Host "  - AD_GPOs.csv ($GPOCount GPOs)" -ForegroundColor White
Write-Host "  - DNS_Zones.csv ($ZoneCount zones)" -ForegroundColor White
Write-Host "  - FileShares.csv ($ShareCount shares)" -ForegroundColor White
Write-Host "  - Collection_Log_*.txt (full log)" -ForegroundColor White
Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "  1. Copy entire $OutputPath folder to your workstation" -ForegroundColor White
Write-Host "  2. Review all CSV files for accuracy" -ForegroundColor White
Write-Host "  3. Update the Azure AD Migration Assessment Checklist" -ForegroundColor White
Write-Host "  4. Proceed with vendor engagement for application compatibility" -ForegroundColor White
Write-Host "`n" -ForegroundColor White

Write-Log "`n[COMPLETE] Data collection script finished successfully" "Green"
