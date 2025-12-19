<#
.SYNOPSIS
    Comprehensive Windows Server configuration audit module for Datto RMM

.DESCRIPTION
    Queries a Windows Server system and documents all configured roles, features,
    and services including Active Directory, DNS, DHCP, File Shares, Print Servers, and more.
    Uses modern cmdlets on newer systems while maintaining compatibility with Windows Server 2008 R2.
    Includes system health checks, network connectivity validation, and file share activity analysis.
    Outputs detailed configuration information in a structured format suitable for Datto RMM.

.NOTES
    Author: Datto RMM Component
    Compatible: Windows Server 2008 R2 and newer
    Requires: Administrator privileges
    Version: 2.1
#>

#region Configuration Variables

# Webhook configuration for data submission
$WebhookUrl = "https://your-n8n-instance/webhook/data-capture"
$EnableWebhookSubmission = $true  # Set to $false to disable webhook submission

#endregion

#region Helper Functions

function Write-ComponentOutput {
    param(
        [string]$Section,
        [string]$Message,
        [string]$Type = "INFO"
    )
    Write-Output "[$Type][$Section] $Message"
}

function Test-AdministratorPrivileges {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-WindowsServerVersion {
    $os = Get-WmiObject Win32_OperatingSystem
    $version = [System.Version]$os.Version

    $serverVersion = @{
        'Caption' = $os.Caption
        'Version' = $os.Version
        'BuildNumber' = $os.BuildNumber
        'MajorVersion' = $version.Major
        'MinorVersion' = $version.Minor
    }

    # Determine if modern cmdlets are available
    if ($version.Major -ge 10) {
        $serverVersion['IsModern'] = $true # Server 2016+
    }
    elseif ($version.Major -eq 6 -and $version.Minor -ge 2) {
        $serverVersion['IsModern'] = $true # Server 2012+
    }
    else {
        $serverVersion['IsModern'] = $false # Server 2008 R2
    }

    return $serverVersion
}

function Submit-DataToWebhook {
    param(
        [Parameter(Mandatory=$true)]
        [object]$Data,
        [Parameter(Mandatory=$true)]
        [string]$WebhookUrl
    )

    try {
        Write-ComponentOutput -Section "Webhook" -Message "Submitting data to webhook..."

        # Prepare headers
        $headers = @{
            "Content-Type" = "application/json"
        }

        # Convert data to JSON
        $jsonBody = $Data | ConvertTo-Json -Depth 10 -Compress

        # Submit to webhook
        $response = Invoke-RestMethod -Uri $WebhookUrl -Method Post -Headers $headers -Body $jsonBody -ErrorAction Stop

        Write-ComponentOutput -Section "Webhook" -Message "Data successfully submitted to webhook"
        Write-ComponentOutput -Section "Webhook" -Message "Response: $($response | ConvertTo-Json -Compress)"

        return $true
    }
    catch {
        Write-ComponentOutput -Section "Webhook" -Message "Failed to submit data to webhook: $($_.Exception.Message)" -Type "ERROR"

        # Log additional error details
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            Write-ComponentOutput -Section "Webhook" -Message "HTTP Status Code: $statusCode" -Type "ERROR"
        }

        return $false
    }
}

function Get-InstalledWindowsFeatures {
    try {
        Write-ComponentOutput -Section "Features" -Message "Detecting installed Windows Features..."

        # Check if ServerManager module is available (2008 R2+)
        if (Get-Module -ListAvailable -Name ServerManager) {
            Import-Module ServerManager -ErrorAction SilentlyContinue
            $features = Get-WindowsFeature | Where-Object { $_.Installed -eq $true }
            return $features
        }
        else {
            Write-ComponentOutput -Section "Features" -Message "ServerManager module not available" -Type "WARN"
            return @()
        }
    }
    catch {
        Write-ComponentOutput -Section "Features" -Message "Error detecting features: $($_.Exception.Message)" -Type "ERROR"
        return @()
    }
}

#endregion

#region System Health Functions

function Get-SystemHealthInfo {
    try {
        Write-ComponentOutput -Section "Health" -Message "Checking system health..."

        $healthInfo = @{}

        # Get computer info
        $cs = Get-WmiObject Win32_ComputerSystem
        $os = Get-WmiObject Win32_OperatingSystem

        $healthInfo['ComputerName'] = $env:COMPUTERNAME
        $healthInfo['Domain'] = $cs.Domain
        $healthInfo['Model'] = $cs.Model
        $healthInfo['TotalPhysicalMemoryGB'] = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
        $healthInfo['LastBootUpTime'] = $os.ConvertToDateTime($os.LastBootUpTime)
        $healthInfo['UptimeDays'] = [math]::Round((New-TimeSpan -Start $os.ConvertToDateTime($os.LastBootUpTime) -End (Get-Date)).TotalDays, 2)
        $healthInfo['OSArchitecture'] = $os.OSArchitecture

        # System time validation
        $systemTime = Get-Date
        $healthInfo['SystemTime'] = $systemTime.ToString('yyyy-MM-dd HH:mm:ss')

        # Check time service
        $w32timeService = Get-Service -Name w32time -ErrorAction SilentlyContinue
        if ($w32timeService) {
            $healthInfo['TimeService'] = @{
                'Status' = $w32timeService.Status.ToString()
                'StartType' = $w32timeService.StartType.ToString()
            }

            # Get time source
            try {
                $timeSource = w32tm /query /source 2>&1
                $healthInfo['TimeService']['Source'] = $timeSource
            }
            catch {
                $healthInfo['TimeService']['Source'] = "Unknown"
            }
        }

        # Disk space
        $healthInfo['Disks'] = @()
        $disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
        foreach ($disk in $disks) {
            $freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
            $totalSizeGB = [math]::Round($disk.Size / 1GB, 2)
            $percentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)

            $diskInfo = @{
                'DriveLetter' = $disk.DeviceID
                'VolumeName' = $disk.VolumeName
                'TotalSizeGB' = $totalSizeGB
                'FreeSpaceGB' = $freeSpaceGB
                'PercentFree' = $percentFree
            }

            if ($percentFree -lt 10) {
                $diskInfo['Warning'] = "Low disk space"
                Write-ComponentOutput -Section "Health" -Message "$($disk.DeviceID) has only $percentFree% free space" -Type "WARN"
            }

            $healthInfo['Disks'] += $diskInfo
        }

        # CPU and Memory utilization
        $cpu = Get-WmiObject Win32_Processor
        $healthInfo['CPU'] = @{
            'Name' = $cpu.Name
            'Cores' = $cpu.NumberOfCores
            'LogicalProcessors' = $cpu.NumberOfLogicalProcessors
            'CurrentClockSpeedMHz' = $cpu.CurrentClockSpeed
        }

        # Get current memory usage
        $healthInfo['MemoryUsageGB'] = [math]::Round(($cs.TotalPhysicalMemory - $os.FreePhysicalMemory * 1KB) / 1GB, 2)
        $healthInfo['MemoryUsagePercent'] = [math]::Round((($cs.TotalPhysicalMemory - $os.FreePhysicalMemory * 1KB) / $cs.TotalPhysicalMemory) * 100, 2)

        Write-ComponentOutput -Section "Health" -Message "Uptime: $($healthInfo['UptimeDays']) days"
        Write-ComponentOutput -Section "Health" -Message "Memory Usage: $($healthInfo['MemoryUsagePercent'])%"

        return $healthInfo
    }
    catch {
        Write-ComponentOutput -Section "Health" -Message "Error checking system health: $($_.Exception.Message)" -Type "ERROR"
        return @{}
    }
}

function Get-NetworkConnectivityInfo {
    try {
        Write-ComponentOutput -Section "Network" -Message "Checking network connectivity..."

        $networkInfo = @{}
        $networkInfo['Adapters'] = @()

        # Get network adapters
        $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

        foreach ($adapter in $adapters) {
            $adapterInfo = @{
                'Description' = $adapter.Description
                'IPAddress' = $adapter.IPAddress
                'SubnetMask' = $adapter.IPSubnet
                'DefaultGateway' = $adapter.DefaultIPGateway
                'DNSServers' = $adapter.DNSServerSearchOrder
                'DHCPEnabled' = $adapter.DHCPEnabled
                'MACAddress' = $adapter.MACAddress
            }

            # Test gateway connectivity
            if ($adapter.DefaultIPGateway) {
                foreach ($gateway in $adapter.DefaultIPGateway) {
                    $pingResult = Test-Connection -ComputerName $gateway -Count 2 -Quiet -ErrorAction SilentlyContinue
                    $adapterInfo['GatewayReachable'] = $pingResult

                    if ($pingResult) {
                        Write-ComponentOutput -Section "Network" -Message "Gateway $gateway is reachable"
                    }
                    else {
                        Write-ComponentOutput -Section "Network" -Message "Gateway $gateway is NOT reachable" -Type "WARN"
                    }
                }
            }

            # Test DNS resolution
            if ($adapter.DNSServerSearchOrder) {
                $dnsWorking = $false
                try {
                    $dnsTest = Resolve-DnsName -Name "google.com" -Server $adapter.DNSServerSearchOrder[0] -ErrorAction SilentlyContinue
                    if ($dnsTest) {
                        $dnsWorking = $true
                        Write-ComponentOutput -Section "Network" -Message "DNS resolution working on $($adapter.Description)"
                    }
                }
                catch {
                    Write-ComponentOutput -Section "Network" -Message "DNS resolution failed on $($adapter.Description)" -Type "WARN"
                }
                $adapterInfo['DNSResolutionWorking'] = $dnsWorking
            }

            $networkInfo['Adapters'] += $adapterInfo
        }

        # Test internet connectivity
        $internetTest = Test-Connection -ComputerName "8.8.8.8" -Count 2 -Quiet -ErrorAction SilentlyContinue
        $networkInfo['InternetConnectivity'] = $internetTest

        if ($internetTest) {
            Write-ComponentOutput -Section "Network" -Message "Internet connectivity: OK"
        }
        else {
            Write-ComponentOutput -Section "Network" -Message "Internet connectivity: FAILED" -Type "WARN"
        }

        return $networkInfo
    }
    catch {
        Write-ComponentOutput -Section "Network" -Message "Error checking network connectivity: $($_.Exception.Message)" -Type "ERROR"
        return @{}
    }
}

#endregion

#region Active Directory Functions

function Get-ActiveDirectoryInfo {
    try {
        Write-ComponentOutput -Section "AD" -Message "Checking Active Directory configuration..."

        # Check if AD DS is installed
        $adFeature = Get-WindowsFeature -Name AD-Domain-Services -ErrorAction SilentlyContinue
        if (-not $adFeature.Installed) {
            Write-ComponentOutput -Section "AD" -Message "Active Directory Domain Services not installed"
            return $null
        }

        Import-Module ActiveDirectory -ErrorAction SilentlyContinue

        $adInfo = @{}

        # Get domain information
        try {
            $domain = Get-ADDomain
            $forest = Get-ADForest
            $domainControllers = Get-ADDomainController -Filter *

            $adInfo['DomainName'] = $domain.DNSRoot
            $adInfo['NetBIOSName'] = $domain.NetBIOSName
            $adInfo['DomainMode'] = $domain.DomainMode
            $adInfo['ForestName'] = $forest.Name
            $adInfo['ForestMode'] = $forest.ForestMode
            $adInfo['SchemaMaster'] = $forest.SchemaMaster
            $adInfo['DomainNamingMaster'] = $forest.DomainNamingMaster
            $adInfo['PDCEmulator'] = $domain.PDCEmulator
            $adInfo['RIDMaster'] = $domain.RIDMaster
            $adInfo['InfrastructureMaster'] = $domain.InfrastructureMaster

            $adInfo['DomainControllers'] = @()
            foreach ($dc in $domainControllers) {
                $adInfo['DomainControllers'] += @{
                    'Name' = $dc.Name
                    'IPAddress' = $dc.IPv4Address
                    'Site' = $dc.Site
                    'IsGlobalCatalog' = $dc.IsGlobalCatalog
                    'IsReadOnly' = $dc.IsReadOnly
                    'OperatingSystem' = $dc.OperatingSystem
                }
            }

            # Get basic user/computer counts
            $userCount = (Get-ADUser -Filter * | Measure-Object).Count
            $computerCount = (Get-ADComputer -Filter * | Measure-Object).Count
            $adInfo['UserCount'] = $userCount
            $adInfo['ComputerCount'] = $computerCount

            Write-ComponentOutput -Section "AD" -Message "Domain: $($adInfo['DomainName'])"
            Write-ComponentOutput -Section "AD" -Message "Users: $userCount, Computers: $computerCount"
        }
        catch {
            Write-ComponentOutput -Section "AD" -Message "Error retrieving AD details: $($_.Exception.Message)" -Type "ERROR"
        }

        return $adInfo
    }
    catch {
        Write-ComponentOutput -Section "AD" -Message "Error checking Active Directory: $($_.Exception.Message)" -Type "ERROR"
        return $null
    }
}

#endregion

#region DNS Functions

function Get-DNSServerInfo {
    param(
        [bool]$IsModern = $false
    )

    try {
        Write-ComponentOutput -Section "DNS" -Message "Checking DNS Server configuration..."

        # Check if DNS is installed
        $dnsFeature = Get-WindowsFeature -Name DNS -ErrorAction SilentlyContinue
        if (-not $dnsFeature.Installed) {
            Write-ComponentOutput -Section "DNS" -Message "DNS Server role not installed"
            return $null
        }

        $dnsInfo = @{}
        $dnsInfo['Zones'] = @()

        # Use modern DnsServer module for Server 2012+
        if ($IsModern) {
            try {
                Import-Module DnsServer -ErrorAction Stop

                $dnsInfo['ServerName'] = $env:COMPUTERNAME
                $zones = Get-DnsServerZone -ErrorAction Stop

                foreach ($zone in $zones) {
                    $zoneInfo = @{
                        'ZoneName' = $zone.ZoneName
                        'ZoneType' = $zone.ZoneType.ToString()
                        'DynamicUpdate' = $zone.DynamicUpdate.ToString()
                        'IsAutoCreated' = $zone.IsAutoCreated
                        'IsDsIntegrated' = $zone.IsDsIntegrated
                        'IsReverseLookupZone' = $zone.IsReverseLookupZone
                        'IsSigned' = $zone.IsSigned
                    }

                    # Get record count
                    try {
                        $records = Get-DnsServerResourceRecord -ZoneName $zone.ZoneName -ErrorAction SilentlyContinue
                        $zoneInfo['RecordCount'] = ($records | Measure-Object).Count
                    }
                    catch {
                        $zoneInfo['RecordCount'] = 0
                    }

                    $dnsInfo['Zones'] += $zoneInfo
                    Write-ComponentOutput -Section "DNS" -Message "Zone: $($zone.ZoneName) - Type: $($zone.ZoneType)"
                }
            }
            catch {
                Write-ComponentOutput -Section "DNS" -Message "Error using DnsServer module, falling back to legacy methods: $($_.Exception.Message)" -Type "WARN"
                $IsModern = $false
            }
        }

        # Use WMI for 2008 R2 compatibility or as fallback
        if (-not $IsModern) {
            try {
                $dnsServer = Get-WmiObject -Namespace "root\MicrosoftDNS" -Class MicrosoftDNS_Server -ErrorAction Stop
                $dnsZones = Get-WmiObject -Namespace "root\MicrosoftDNS" -Class MicrosoftDNS_Zone -ErrorAction Stop

                $dnsInfo['ServerName'] = $env:COMPUTERNAME

                foreach ($zone in $dnsZones) {
                    $zoneInfo = @{
                        'ZoneName' = $zone.Name
                        'ZoneType' = $zone.ZoneType
                        'DynamicUpdate' = $zone.AllowUpdate
                        'DataFile' = $zone.DataFile
                    }

                    # Get record count for zone
                    try {
                        $records = Get-WmiObject -Namespace "root\MicrosoftDNS" -Class MicrosoftDNS_ResourceRecord -Filter "ContainerName='$($zone.Name)'" -ErrorAction SilentlyContinue
                        $zoneInfo['RecordCount'] = ($records | Measure-Object).Count
                    }
                    catch {
                        $zoneInfo['RecordCount'] = 0
                    }

                    $dnsInfo['Zones'] += $zoneInfo
                    Write-ComponentOutput -Section "DNS" -Message "Zone: $($zone.Name) - Type: $($zone.ZoneType)"
                }
            }
            catch {
                Write-ComponentOutput -Section "DNS" -Message "Error querying DNS via WMI: $($_.Exception.Message)" -Type "WARN"

                # Final fallback: Try using dnscmd
                try {
                    $zoneList = dnscmd /enumzones 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        foreach ($line in $zoneList) {
                            if ($line -match '^\s+(\S+)\s+(\S+)') {
                                $dnsInfo['Zones'] += @{
                                    'ZoneName' = $matches[1]
                                    'ZoneType' = $matches[2]
                                }
                            }
                        }
                    }
                }
                catch {
                    Write-ComponentOutput -Section "DNS" -Message "Error using dnscmd: $($_.Exception.Message)" -Type "ERROR"
                }
            }
        }

        return $dnsInfo
    }
    catch {
        Write-ComponentOutput -Section "DNS" -Message "Error checking DNS: $($_.Exception.Message)" -Type "ERROR"
        return $null
    }
}

#endregion

#region DHCP Functions

function Get-DHCPServerInfo {
    param(
        [bool]$IsModern = $false
    )

    try {
        Write-ComponentOutput -Section "DHCP" -Message "Checking DHCP Server configuration..."

        # Check if DHCP is installed
        $dhcpFeature = Get-WindowsFeature -Name DHCP -ErrorAction SilentlyContinue
        if (-not $dhcpFeature.Installed) {
            Write-ComponentOutput -Section "DHCP" -Message "DHCP Server role not installed"
            return $null
        }

        $dhcpInfo = @{}
        $dhcpInfo['Scopes'] = @()

        # Use modern DhcpServer module for Server 2012+
        if ($IsModern) {
            try {
                Import-Module DhcpServer -ErrorAction Stop

                $scopes = Get-DhcpServerv4Scope -ErrorAction Stop

                foreach ($scope in $scopes) {
                    $scopeInfo = @{
                        'ScopeId' = $scope.ScopeId.ToString()
                        'Name' = $scope.Name
                        'StartRange' = $scope.StartRange.ToString()
                        'EndRange' = $scope.EndRange.ToString()
                        'SubnetMask' = $scope.SubnetMask.ToString()
                        'State' = $scope.State.ToString()
                        'LeaseDuration' = $scope.LeaseDuration.ToString()
                    }

                    # Get lease statistics
                    try {
                        $stats = Get-DhcpServerv4ScopeStatistics -ScopeId $scope.ScopeId -ErrorAction SilentlyContinue
                        $scopeInfo['AddressesInUse'] = $stats.AddressesInUse
                        $scopeInfo['AddressesFree'] = $stats.AddressesFree
                        $scopeInfo['PercentageInUse'] = $stats.PercentageInUse
                    }
                    catch {
                        Write-ComponentOutput -Section "DHCP" -Message "Could not get statistics for scope $($scope.ScopeId)" -Type "WARN"
                    }

                    # Get scope options
                    try {
                        $options = Get-DhcpServerv4OptionValue -ScopeId $scope.ScopeId -ErrorAction SilentlyContinue
                        $scopeInfo['Options'] = @()
                        foreach ($option in $options) {
                            $scopeInfo['Options'] += @{
                                'OptionId' = $option.OptionId
                                'Name' = $option.Name
                                'Value' = $option.Value -join ', '
                            }
                        }
                    }
                    catch {
                        $scopeInfo['Options'] = @()
                    }

                    $dhcpInfo['Scopes'] += $scopeInfo
                    Write-ComponentOutput -Section "DHCP" -Message "Scope: $($scope.Name) ($($scope.ScopeId)) - $($scopeInfo['AddressesInUse']) leases active"
                }
            }
            catch {
                Write-ComponentOutput -Section "DHCP" -Message "Error using DhcpServer module, falling back to legacy methods: $($_.Exception.Message)" -Type "WARN"
                $IsModern = $false
            }
        }

        # Use netsh for 2008 R2 compatibility or as fallback
        if (-not $IsModern) {
            try {
                $scopeOutput = netsh dhcp server show scope 2>&1

                if ($LASTEXITCODE -eq 0) {
                    $currentScope = $null

                    foreach ($line in $scopeOutput) {
                        # Parse scope information
                        if ($line -match '(\d+\.\d+\.\d+\.\d+)\s+-\s+(.+?)\s+-') {
                            if ($currentScope) {
                                $dhcpInfo['Scopes'] += $currentScope
                            }

                            $scopeIP = $matches[1]
                            $scopeName = $matches[2].Trim()

                            $currentScope = @{
                                'ScopeId' = $scopeIP
                                'Name' = $scopeName
                            }

                            # Get detailed scope info
                            try {
                                $scopeDetail = netsh dhcp server scope $scopeIP show clients 1 2>&1
                                $activeLeases = ($scopeDetail | Select-String -Pattern "Total" | Out-String)
                                if ($activeLeases -match '(\d+)') {
                                    $currentScope['ActiveLeases'] = $matches[1]
                                }

                                # Get scope range
                                $rangeInfo = netsh dhcp server scope $scopeIP show iprange 2>&1
                                foreach ($rangeLine in $rangeInfo) {
                                    if ($rangeLine -match 'Start Address\s+-\s+(\d+\.\d+\.\d+\.\d+)') {
                                        $currentScope['StartRange'] = $matches[1]
                                    }
                                    if ($rangeLine -match 'End Address\s+-\s+(\d+\.\d+\.\d+\.\d+)') {
                                        $currentScope['EndRange'] = $matches[1]
                                    }
                                    if ($rangeLine -match 'Subnet Mask\s+-\s+(\d+\.\d+\.\d+\.\d+)') {
                                        $currentScope['SubnetMask'] = $matches[1]
                                    }
                                }
                            }
                            catch {
                                Write-ComponentOutput -Section "DHCP" -Message "Error getting scope details for $scopeIP" -Type "WARN"
                            }

                            Write-ComponentOutput -Section "DHCP" -Message "Scope: $scopeName ($scopeIP)"
                        }
                    }

                    if ($currentScope) {
                        $dhcpInfo['Scopes'] += $currentScope
                    }
                }
            }
            catch {
                Write-ComponentOutput -Section "DHCP" -Message "Error querying DHCP: $($_.Exception.Message)" -Type "ERROR"
            }
        }

        return $dhcpInfo
    }
    catch {
        Write-ComponentOutput -Section "DHCP" -Message "Error checking DHCP: $($_.Exception.Message)" -Type "ERROR"
        return $null
    }
}

#endregion

#region File Share Functions

function Get-FileShareInfo {
    param(
        [bool]$IsModern = $false
    )

    try {
        Write-ComponentOutput -Section "FileShares" -Message "Checking File Shares..."

        $shareInfo = @()
        $now = Get-Date

        # Get all SMB shares using modern cmdlets if available
        if ($IsModern) {
            try {
                $shares = Get-SmbShare -ErrorAction Stop | Where-Object { $_.Special -eq $false }
                $useModern = $true
            }
            catch {
                Write-ComponentOutput -Section "FileShares" -Message "SmbShare module not available, using WMI" -Type "WARN"
                $useModern = $false
            }
        }
        else {
            $useModern = $false
        }

        # Fallback to WMI for older systems
        if (-not $useModern) {
            $shares = Get-WmiObject -Class Win32_Share | Where-Object { $_.Type -eq 0 -and $_.Name -notmatch '\$$' }
        }

        foreach ($share in $shares) {
            $shareName = if ($useModern) { $share.Name } else { $share.Name }
            $sharePath = if ($useModern) { $share.Path } else { $share.Path }

            $shareDetails = @{
                'Name' = $shareName
                'Path' = $sharePath
                'Description' = if ($useModern) { $share.Description } else { $share.Description }
                'Permissions' = @()
                'ConnectedUsers' = @()
                'OpenFiles' = @()
            }

            # Get share permissions using modern cmdlets
            if ($useModern) {
                try {
                    $shareAccess = Get-SmbShareAccess -Name $shareName -ErrorAction SilentlyContinue
                    foreach ($access in $shareAccess) {
                        $shareDetails['Permissions'] += @{
                            'AccountName' = $access.AccountName
                            'AccessRight' = $access.AccessRight.ToString()
                            'AccessControlType' = $access.AccessControlType.ToString()
                        }
                    }
                }
                catch {
                    Write-ComponentOutput -Section "FileShares" -Message "Error getting modern permissions for $shareName" -Type "WARN"
                }
            }
            else {
                # Use WMI for legacy systems
                try {
                    $shareSec = Get-WmiObject -Class Win32_LogicalShareSecuritySetting -Filter "Name='$shareName'"
                    $secDescriptor = $shareSec.GetSecurityDescriptor().Descriptor

                    foreach ($ace in $secDescriptor.DACL) {
                        $trustee = $ace.Trustee
                        $permission = switch ($ace.AccessMask) {
                            2032127 { "Full Control" }
                            1245631 { "Change" }
                            1179817 { "Read" }
                            default { "0x{0:X}" -f $ace.AccessMask }
                        }

                        $shareDetails['Permissions'] += @{
                            'Trustee' = "$($trustee.Domain)\$($trustee.Name)"
                            'Access' = $permission
                            'Type' = if ($ace.AceType -eq 0) { "Allow" } else { "Deny" }
                        }
                    }
                }
                catch {
                    Write-ComponentOutput -Section "FileShares" -Message "Error getting permissions for ${shareName}: $($_.Exception.Message)" -Type "WARN"
                }
            }

            # Get connected users and open files
            try {
                # Get SMB sessions connected to this share
                if ($useModern) {
                    $sessions = Get-SmbSession -ErrorAction SilentlyContinue
                    foreach ($session in $sessions) {
                        $shareDetails['ConnectedUsers'] += @{
                            'ClientComputerName' = $session.ClientComputerName
                            'ClientUserName' = $session.ClientUserName
                            'NumOpens' = $session.NumOpens
                            'SecondsIdle' = $session.SecondsIdle
                        }
                    }

                    # Get open files for this share
                    $openFiles = Get-SmbOpenFile -ErrorAction SilentlyContinue | Where-Object { $_.ShareRelativePath -ne $null -and $_.Path -like "$sharePath*" }
                    foreach ($file in $openFiles) {
                        $shareDetails['OpenFiles'] += @{
                            'Path' = $file.Path
                            'ClientComputerName' = $file.ClientComputerName
                            'ClientUserName' = $file.ClientUserName
                            'SessionId' = $file.SessionId
                        }
                    }
                }
                else {
                    # Use net session and net file for legacy systems
                    $netSession = net session 2>&1
                    foreach ($line in $netSession) {
                        if ($line -match '^\\\\(\S+)\s+(\S+)') {
                            $shareDetails['ConnectedUsers'] += @{
                                'ClientComputerName' = $matches[1]
                                'ClientUserName' = $matches[2]
                            }
                        }
                    }

                    $netFile = net file 2>&1
                    foreach ($line in $netFile) {
                        if ($line -match '^\s*(\d+)\s+(.+?)\s+(\S+)\s+(\d+)') {
                            $filePath = $matches[2].Trim()
                            if ($filePath -like "$sharePath*") {
                                $shareDetails['OpenFiles'] += @{
                                    'ID' = $matches[1]
                                    'Path' = $filePath
                                    'User' = $matches[3]
                                    'Locks' = $matches[4]
                                }
                            }
                        }
                    }
                }
            }
            catch {
                Write-ComponentOutput -Section "FileShares" -Message "Error getting session info for ${shareName}: $($_.Exception.Message)" -Type "WARN"
            }

            # Analyze file activity if path exists
            if (Test-Path $sharePath) {
                try {
                    Write-ComponentOutput -Section "FileShares" -Message "Analyzing file activity for $shareName..."

                    # Get all files and analyze dates
                    $files = Get-ChildItem -Path $sharePath -Recurse -File -ErrorAction SilentlyContinue

                    if ($files) {
                        $totalSize = ($files | Measure-Object -Property Length -Sum).Sum
                        $shareDetails['SizeGB'] = [math]::Round($totalSize / 1GB, 2)
                        $shareDetails['FileCount'] = ($files | Measure-Object).Count

                        # Find most recent file activity
                        $mostRecentWrite = ($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
                        $mostRecentCreation = ($files | Sort-Object CreationTime -Descending | Select-Object -First 1).CreationTime

                        $mostRecent = $mostRecentWrite
                        if ($mostRecentCreation -gt $mostRecentWrite) {
                            $mostRecent = $mostRecentCreation
                        }

                        $daysSinceActivity = ($now - $mostRecent).Days
                        $shareDetails['MostRecentActivity'] = $mostRecent.ToString('yyyy-MM-dd HH:mm:ss')
                        $shareDetails['DaysSinceActivity'] = $daysSinceActivity

                        # Categorize inactivity period - only report longest applicable period
                        if ($daysSinceActivity -gt 365) {
                            $shareDetails['ActivityStatus'] = "No activity in over 1 year"
                            Write-ComponentOutput -Section "FileShares" -Message "$shareName - No activity in over 1 year (Last: $($mostRecent.ToString('yyyy-MM-dd')))" -Type "WARN"
                        }
                        elseif ($daysSinceActivity -gt 180) {
                            $shareDetails['ActivityStatus'] = "No activity in over 6 months"
                            Write-ComponentOutput -Section "FileShares" -Message "$shareName - No activity in over 6 months (Last: $($mostRecent.ToString('yyyy-MM-dd')))" -Type "WARN"
                        }
                        elseif ($daysSinceActivity -gt 30) {
                            $shareDetails['ActivityStatus'] = "No activity in over 1 month"
                            Write-ComponentOutput -Section "FileShares" -Message "$shareName - No activity in over 1 month (Last: $($mostRecent.ToString('yyyy-MM-dd')))"
                        }
                        elseif ($daysSinceActivity -gt 7) {
                            $shareDetails['ActivityStatus'] = "No activity in over 1 week"
                            Write-ComponentOutput -Section "FileShares" -Message "$shareName - No activity in over 1 week (Last: $($mostRecent.ToString('yyyy-MM-dd')))"
                        }
                        else {
                            $shareDetails['ActivityStatus'] = "Active (recent activity within 7 days)"
                            Write-ComponentOutput -Section "FileShares" -Message "$shareName - Active (Last activity: $($mostRecent.ToString('yyyy-MM-dd')))"
                        }

                        # Get file age distribution
                        $filesLastWeek = ($files | Where-Object { $_.LastWriteTime -gt $now.AddDays(-7) } | Measure-Object).Count
                        $filesLastMonth = ($files | Where-Object { $_.LastWriteTime -gt $now.AddDays(-30) } | Measure-Object).Count
                        $filesLast6Months = ($files | Where-Object { $_.LastWriteTime -gt $now.AddDays(-180) } | Measure-Object).Count

                        $shareDetails['FilesModifiedLastWeek'] = $filesLastWeek
                        $shareDetails['FilesModifiedLastMonth'] = $filesLastMonth
                        $shareDetails['FilesModifiedLast6Months'] = $filesLast6Months
                    }
                    else {
                        $shareDetails['SizeGB'] = 0
                        $shareDetails['FileCount'] = 0
                        $shareDetails['ActivityStatus'] = "Empty share"
                        Write-ComponentOutput -Section "FileShares" -Message "$shareName - Empty share"
                    }
                }
                catch {
                    Write-ComponentOutput -Section "FileShares" -Message "Error analyzing activity for ${shareName}: $($_.Exception.Message)" -Type "WARN"
                    $shareDetails['SizeGB'] = "N/A"
                    $shareDetails['ActivityStatus'] = "Unable to analyze"
                }
            }
            else {
                $shareDetails['ActivityStatus'] = "Path does not exist"
                Write-ComponentOutput -Section "FileShares" -Message "$shareName - Path does not exist: $sharePath" -Type "ERROR"
            }

            $shareInfo += $shareDetails
            Write-ComponentOutput -Section "FileShares" -Message "Share: $shareName - Path: $sharePath - Connected Users: $($shareDetails['ConnectedUsers'].Count)"
        }

        return $shareInfo
    }
    catch {
        Write-ComponentOutput -Section "FileShares" -Message "Error checking file shares: $($_.Exception.Message)" -Type "ERROR"
        return @()
    }
}

#endregion

#region Print Server Functions

function Get-PrintServerInfo {
    try {
        Write-ComponentOutput -Section "PrintServer" -Message "Checking Print Server configuration..."

        # Check if Print Services is installed
        $printFeature = Get-WindowsFeature -Name Print-Services -ErrorAction SilentlyContinue
        if (-not $printFeature.Installed) {
            Write-ComponentOutput -Section "PrintServer" -Message "Print Services role not installed"
            return $null
        }

        $printInfo = @{}
        $printInfo['Printers'] = @()

        # Get all shared printers
        $printers = Get-WmiObject -Class Win32_Printer | Where-Object { $_.Shared -eq $true }

        foreach ($printer in $printers) {
            $printerDetails = @{
                'Name' = $printer.Name
                'ShareName' = $printer.ShareName
                'DriverName' = $printer.DriverName
                'PortName' = $printer.PortName
                'Location' = $printer.Location
                'Comment' = $printer.Comment
                'Status' = $printer.PrinterStatus
            }

            # Get port details
            try {
                $port = Get-WmiObject -Class Win32_TCPIPPrinterPort -Filter "Name='$($printer.PortName)'" -ErrorAction SilentlyContinue
                if ($port) {
                    $printerDetails['PortType'] = "TCP/IP"
                    $printerDetails['IPAddress'] = $port.HostAddress
                    $printerDetails['PortNumber'] = $port.PortNumber
                }
                else {
                    $printerDetails['PortType'] = "Other"
                }
            }
            catch {
                $printerDetails['PortType'] = "Unknown"
            }

            $printInfo['Printers'] += $printerDetails
            Write-ComponentOutput -Section "PrintServer" -Message "Printer: $($printer.Name) - Port: $($printer.PortName)"
        }

        return $printInfo
    }
    catch {
        Write-ComponentOutput -Section "PrintServer" -Message "Error checking print server: $($_.Exception.Message)" -Type "ERROR"
        return $null
    }
}

#endregion

#region IIS Functions

function Get-IISInfo {
    try {
        Write-ComponentOutput -Section "IIS" -Message "Checking IIS configuration..."

        # Check if IIS is installed
        $iisFeature = Get-WindowsFeature -Name Web-Server -ErrorAction SilentlyContinue
        if (-not $iisFeature.Installed) {
            Write-ComponentOutput -Section "IIS" -Message "IIS role not installed"
            return $null
        }

        Import-Module WebAdministration -ErrorAction SilentlyContinue

        $iisInfo = @{}
        $iisInfo['Sites'] = @()
        $iisInfo['AppPools'] = @()

        # Get IIS sites
        try {
            $sites = Get-ChildItem IIS:\Sites -ErrorAction SilentlyContinue

            foreach ($site in $sites) {
                $siteDetails = @{
                    'Name' = $site.Name
                    'ID' = $site.ID
                    'State' = $site.State
                    'PhysicalPath' = $site.PhysicalPath
                    'Bindings' = @()
                }

                foreach ($binding in $site.Bindings.Collection) {
                    $siteDetails['Bindings'] += @{
                        'Protocol' = $binding.Protocol
                        'BindingInformation' = $binding.BindingInformation
                    }
                }

                $iisInfo['Sites'] += $siteDetails
                Write-ComponentOutput -Section "IIS" -Message "Site: $($site.Name) - State: $($site.State)"
            }

            # Get Application Pools
            $appPools = Get-ChildItem IIS:\AppPools -ErrorAction SilentlyContinue
            foreach ($pool in $appPools) {
                $iisInfo['AppPools'] += @{
                    'Name' = $pool.Name
                    'State' = $pool.State
                    'ManagedRuntimeVersion' = $pool.ManagedRuntimeVersion
                    'ManagedPipelineMode' = $pool.ManagedPipelineMode
                }
            }
        }
        catch {
            Write-ComponentOutput -Section "IIS" -Message "Error querying IIS sites: $($_.Exception.Message)" -Type "WARN"
        }

        return $iisInfo
    }
    catch {
        Write-ComponentOutput -Section "IIS" -Message "Error checking IIS: $($_.Exception.Message)" -Type "ERROR"
        return $null
    }
}

#endregion

#region Additional Services

function Get-AdditionalServices {
    try {
        Write-ComponentOutput -Section "Services" -Message "Checking additional services..."

        $servicesInfo = @{}

        # Check for Hyper-V
        $hyperVFeature = Get-WindowsFeature -Name Hyper-V -ErrorAction SilentlyContinue
        if ($hyperVFeature.Installed) {
            $servicesInfo['HyperV'] = @{
                'Installed' = $true
                'VMs' = @()
            }

            try {
                $vms = Get-VM -ErrorAction SilentlyContinue
                foreach ($vm in $vms) {
                    $servicesInfo['HyperV']['VMs'] += @{
                        'Name' = $vm.Name
                        'State' = $vm.State
                        'CPUUsage' = $vm.CPUUsage
                        'MemoryAssigned' = [math]::Round($vm.MemoryAssigned / 1GB, 2)
                    }
                }
                Write-ComponentOutput -Section "Services" -Message "Hyper-V installed with $($vms.Count) VMs"
            }
            catch {
                Write-ComponentOutput -Section "Services" -Message "Hyper-V installed but unable to query VMs" -Type "WARN"
            }
        }

        # Check for WSUS
        $wsusFeature = Get-WindowsFeature -Name UpdateServices -ErrorAction SilentlyContinue
        if ($wsusFeature.Installed) {
            $servicesInfo['WSUS'] = @{ 'Installed' = $true }
            Write-ComponentOutput -Section "Services" -Message "WSUS installed"
        }

        # Check for Remote Desktop Services
        $rdsFeature = Get-WindowsFeature -Name Remote-Desktop-Services -ErrorAction SilentlyContinue
        if ($rdsFeature.Installed) {
            $servicesInfo['RDS'] = @{ 'Installed' = $true }
            Write-ComponentOutput -Section "Services" -Message "Remote Desktop Services installed"
        }

        return $servicesInfo
    }
    catch {
        Write-ComponentOutput -Section "Services" -Message "Error checking additional services: $($_.Exception.Message)" -Type "ERROR"
        return @{}
    }
}

#endregion

#region Main Execution

function Start-ServerAudit {
    Write-ComponentOutput -Section "Main" -Message "========================================="
    Write-ComponentOutput -Section "Main" -Message "Server Configuration Audit v2.0"
    Write-ComponentOutput -Section "Main" -Message "========================================="
    Write-ComponentOutput -Section "Main" -Message "Server: $env:COMPUTERNAME"
    Write-ComponentOutput -Section "Main" -Message "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-ComponentOutput -Section "Main" -Message "========================================="

    # Check administrator privileges
    if (-not (Test-AdministratorPrivileges)) {
        Write-ComponentOutput -Section "Main" -Message "This script requires Administrator privileges" -Type "ERROR"
        return
    }

    # Detect Windows Server version and capabilities
    $serverVersion = Get-WindowsServerVersion
    $isModern = $serverVersion['IsModern']

    Write-ComponentOutput -Section "Main" -Message "OS: $($serverVersion['Caption'])"
    Write-ComponentOutput -Section "Main" -Message "Version: $($serverVersion['Version']) (Build $($serverVersion['BuildNumber']))"
    Write-ComponentOutput -Section "Main" -Message "Using $(if ($isModern) { 'modern' } else { 'legacy' }) cmdlets"
    Write-ComponentOutput -Section "Main" -Message "========================================="

    # Initialize results object
    $results = @{
        'ServerName' = $env:COMPUTERNAME
        'AuditDate' = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        'OSVersion' = $serverVersion['Caption']
        'OSBuild' = $serverVersion['BuildNumber']
        'IsModernOS' = $isModern
        'InstalledFeatures' = @()
    }

    # System Health Checks
    Write-ComponentOutput -Section "Main" -Message "Running system health checks..."
    $results['SystemHealth'] = Get-SystemHealthInfo
    $results['NetworkConnectivity'] = Get-NetworkConnectivityInfo

    # Get installed Windows features
    $installedFeatures = Get-InstalledWindowsFeatures
    foreach ($feature in $installedFeatures) {
        $results['InstalledFeatures'] += $feature.Name
    }

    # Gather configuration for each role/service with version-appropriate cmdlets
    Write-ComponentOutput -Section "Main" -Message "Auditing server roles and features..."

    $results['ActiveDirectory'] = Get-ActiveDirectoryInfo
    $results['DNS'] = Get-DNSServerInfo -IsModern $isModern
    $results['DHCP'] = Get-DHCPServerInfo -IsModern $isModern
    $results['FileShares'] = Get-FileShareInfo -IsModern $isModern
    $results['PrintServer'] = Get-PrintServerInfo
    $results['IIS'] = Get-IISInfo
    $results['AdditionalServices'] = Get-AdditionalServices

    Write-ComponentOutput -Section "Main" -Message "========================================="
    Write-ComponentOutput -Section "Main" -Message "Audit Complete"
    Write-ComponentOutput -Section "Main" -Message "========================================="

    # Generate summary statistics
    $summary = @{
        'TotalShares' = ($results['FileShares'] | Measure-Object).Count
        'ActiveShares' = ($results['FileShares'] | Where-Object { $_.ActivityStatus -like "Active*" } | Measure-Object).Count
        'InactiveShares' = ($results['FileShares'] | Where-Object { $_.ActivityStatus -notlike "Active*" -and $_.ActivityStatus -ne "Empty share" } | Measure-Object).Count
        'TotalDiskSpaceGB' = ($results['SystemHealth']['Disks'] | Measure-Object -Property TotalSizeGB -Sum).Sum
        'FreeDiskSpaceGB' = ($results['SystemHealth']['Disks'] | Measure-Object -Property FreeSpaceGB -Sum).Sum
        'DNSZones' = if ($results['DNS']) { ($results['DNS']['Zones'] | Measure-Object).Count } else { 0 }
        'DHCPScopes' = if ($results['DHCP']) { ($results['DHCP']['Scopes'] | Measure-Object).Count } else { 0 }
        'SharedPrinters' = if ($results['PrintServer']) { ($results['PrintServer']['Printers'] | Measure-Object).Count } else { 0 }
    }
    $results['Summary'] = $summary

    Write-ComponentOutput -Section "Summary" -Message "Total File Shares: $($summary['TotalShares'])"
    Write-ComponentOutput -Section "Summary" -Message "Active File Shares: $($summary['ActiveShares'])"
    Write-ComponentOutput -Section "Summary" -Message "Inactive File Shares: $($summary['InactiveShares'])"
    Write-ComponentOutput -Section "Summary" -Message "DNS Zones: $($summary['DNSZones'])"
    Write-ComponentOutput -Section "Summary" -Message "DHCP Scopes: $($summary['DHCPScopes'])"
    Write-ComponentOutput -Section "Summary" -Message "Shared Printers: $($summary['SharedPrinters'])"

    # Convert results to JSON for easy parsing by Datto RMM
    try {
        $jsonResults = $results | ConvertTo-Json -Depth 10 -Compress
        Write-Output ""
        Write-Output "=== JSON OUTPUT BEGIN ==="
        Write-Output $jsonResults
        Write-Output "=== JSON OUTPUT END ==="
    }
    catch {
        Write-ComponentOutput -Section "Main" -Message "Error converting results to JSON: $($_.Exception.Message)" -Type "ERROR"
    }

    # Submit data to webhook if enabled
    if ($EnableWebhookSubmission) {
        Write-ComponentOutput -Section "Main" -Message "Webhook submission is enabled"

        if ($WebhookUrl -and $WebhookUrl -ne "https://your-n8n-instance/webhook/data-capture") {
            $webhookSuccess = Submit-DataToWebhook -Data $results -WebhookUrl $WebhookUrl

            if ($webhookSuccess) {
                Write-ComponentOutput -Section "Main" -Message "Data successfully submitted to monitoring system"
            }
            else {
                Write-ComponentOutput -Section "Main" -Message "Failed to submit data to monitoring system" -Type "WARN"
            }
        }
        else {
            Write-ComponentOutput -Section "Main" -Message "Webhook URL not configured. Please update the configuration variables." -Type "WARN"
        }
    }
    else {
        Write-ComponentOutput -Section "Main" -Message "Webhook submission is disabled"
    }

    return $results
}

# Execute the audit
Start-ServerAudit

#endregion
