# Domain Controller Migration Project Plan

## Project Overview

**Objective:** Add two new domain controllers to an existing Active Directory domain with full migration of DHCP, DNS, NPS (NPAS), and Certificate Services.

**Timeline:** 2-4 weeks (depending on environment complexity and change windows)

**Prerequisites:**
- Windows Server licenses for new DCs
- Hardware meeting Microsoft DC requirements (4GB+ RAM, adequate storage)
- Network connectivity and static IP addresses assigned
- Administrative access to existing domain controllers
- Change control approval and maintenance windows scheduled

---

## Phase 1: Pre-Deployment Planning & Documentation

### 1.1 Environment Assessment

**Document Existing Infrastructure:**

```powershell
# List all domain controllers
Get-ADDomainController -Filter * | Select-Object Name, IPv4Address, OperatingSystem, Site

# Check FSMO role holders
netdom query fsmo

# Verify domain/forest functional levels
Get-ADDomain | Select-Object DomainMode
Get-ADForest | Select-Object ForestMode

# List DNS servers
Get-DnsServer | Select-Object ServerName, ServerVersion

# List DHCP servers
Get-DhcpServerInDC

# Check for Certificate Authority
certutil -ping
```

**Create Documentation Package:**
- Current DC names, IP addresses, and roles
- FSMO role assignments
- DNS zone configuration
- DHCP scope details and reservations
- NPS/RADIUS client list
- CA hierarchy and certificate template list
- Site topology and replication schedule

### 1.2 Backup Critical Services

**Backup Domain Controllers:**

```powershell
# System State backup on existing DCs
wbadmin start systemstatebackup -backupTarget:E: -quiet

# Or use Windows Server Backup GUI
# Ensure backups include System State
```

**Export DHCP Configuration:**

```powershell
# Export DHCP database
Export-DhcpServer -File "C:\Backup\DHCP-Export.xml" -Leases

# Backup DHCP database files (alternative)
Stop-Service DHCPServer
Copy-Item "C:\Windows\System32\dhcp\*" -Destination "C:\Backup\DHCP\" -Recurse
Start-Service DHCPServer
```

**Export NPS Configuration:**

```powershell
# Export NPS configuration
Export-NpsConfiguration -Path "C:\Backup\NPS-Config.xml"
```

**Backup Certificate Services:**

```powershell
# Backup CA database and private key
certutil -backup "C:\Backup\CA-Backup"

# Note: Requires CA administrator permissions
```

**Export DNS Zones:**

```powershell
# Export all DNS zones
$zones = Get-DnsServerZone | Where-Object {!$_.IsAutoCreated}
foreach ($zone in $zones) {
    Export-DnsServerZone -Name $zone.ZoneName -FileName "$($zone.ZoneName).dns"
}
# Files saved to %SystemRoot%\System32\dns\
```

### 1.3 Verify Prerequisites

**Checklist:**
- [ ] DNS working correctly (nslookup, dcdiag /test:dns)
- [ ] Time synchronization configured (w32tm /query /status)
- [ ] All DCs replicating properly (repadmin /replsummary)
- [ ] No critical errors in Event Logs
- [ ] Schema up to date for target OS version
- [ ] Network ports open between DCs (TCP/UDP 389, 636, 88, 135, 445, 3268, 53, 123)
- [ ] Anti-virus exclusions configured for AD database paths

---

## Phase 2: Base Server Setup

### 2.1 Operating System Installation

**Installation Steps:**
1. Install Windows Server (Standard or Datacenter)
2. Select "Server with Desktop Experience" (recommended for initial setup)
3. Configure Administrator password (document in Keeper Security)

**Initial Configuration:**

```powershell
# Set time zone
Set-TimeZone -Name "Central Standard Time"

# Set computer name (before domain join)
Rename-Computer -NewName "DC03" -Restart

# Configure Windows Update settings
# Use Group Policy or local settings to control update behavior
```

### 2.2 Network Configuration

**Configure Static IP:**

```powershell
# Example: Configure static IP
$IPAddress = "192.168.1.13"
$DefaultGateway = "192.168.1.1"
$DNSServers = @("192.168.1.10", "192.168.1.11") # Existing DCs
$InterfaceAlias = "Ethernet"

New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress `
    -PrefixLength 24 -DefaultGateway $DefaultGateway

Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $DNSServers
```

**Verify Connectivity:**

```powershell
# Test DNS resolution
nslookup domain.com

# Test connectivity to existing DCs
Test-Connection -ComputerName DC01 -Count 4
Test-NetConnection -ComputerName DC01 -Port 389
Test-NetConnection -ComputerName DC01 -Port 53
```

### 2.3 Windows Updates & Security

```powershell
# Install PSWindowsUpdate module
Install-Module PSWindowsUpdate -Force

# Check for updates
Get-WindowsUpdate

# Install all updates
Install-WindowsUpdate -AcceptAll -AutoReboot

# Configure Windows Firewall
# Domain Controllers typically need firewall enabled with AD-specific rules
# These are automatically configured during DC promotion
```

### 2.4 Domain Join

**Join as Member Server:**

```powershell
# Join domain
$DomainName = "contoso.com"
$Credential = Get-Credential # Domain Admin account

Add-Computer -DomainName $DomainName -Credential $Credential -Restart
```

**Post-Join Verification:**

```powershell
# Verify domain membership
Get-ComputerInfo | Select-Object CsDomain, CsDomainRole

# Verify GPO application
gpupdate /force
gpresult /r
```

---

## Phase 3: Domain Controller Promotion

### 3.1 Install Active Directory Domain Services Role

**Install AD DS:**

```powershell
# Install AD DS role and management tools
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Verify installation
Get-WindowsFeature -Name AD-Domain-Services
```

### 3.2 Promote to Domain Controller

**Promote First New DC (DC03):**

```powershell
# Promotion parameters
$DomainName = "contoso.com"
$SafeModePassword = Read-Host -AsSecureString -Prompt "Enter DSRM Password"
$Credential = Get-Credential # Domain Admin credentials

# Promote to DC with DNS and Global Catalog
Install-ADDSDomainController `
    -DomainName $DomainName `
    -InstallDns `
    -Credential $Credential `
    -SafeModeAdministratorPassword $SafeModePassword `
    -Force

# Server will restart automatically
```

**Post-Promotion Validation (DC03):**

```powershell
# Wait 15-30 minutes after restart for initial replication

# Verify DC is advertising
dcdiag /v /c /e

# Check replication status
repadmin /showrepl

# Verify SYSVOL share
dir \\DC03\SYSVOL

# Check DNS registration
nslookup DC03.contoso.com
```

### 3.3 Promote Second New DC (DC04)

**Repeat promotion process:**

```powershell
# Same process as DC03
Install-ADDSDomainController `
    -DomainName $DomainName `
    -InstallDns `
    -Credential $Credential `
    -SafeModeAdministratorPassword $SafeModePassword `
    -Force
```

### 3.4 Verify Replication Health

**Critical Replication Checks:**

```powershell
# Check replication summary
repadmin /replsummary

# Show replication partners
repadmin /showrepl

# Force replication between all DCs
repadmin /syncall /AdeP

# Verify SYSVOL replication state
dfsrmig /getglobalstate
# Should show "DFSR" (migrated from FRS)

# Check AD database integrity
dcdiag /test:replications
dcdiag /test:netlogons
dcdiag /test:advertising
```

---

## Phase 4: DNS Migration

### 4.1 Verify DNS Installation

**DNS is automatically installed during DC promotion. Verify configuration:**

```powershell
# Check DNS zones
Get-DnsServerZone

# Verify zone replication
Get-DnsServerZone -Name "contoso.com" | Select-Object ZoneName, ZoneType, ReplicationScope

# Check forwarders
Get-DnsServerForwarder

# Test DNS resolution
Resolve-DnsName -Name contoso.com -Server DC03
Resolve-DnsName -Name DC03.contoso.com -Server DC04
```

### 4.2 Update DHCP DNS Options

**Configure clients to use new DCs for DNS:**

```powershell
# Update DHCP scope option 006 (DNS Servers)
# Do this AFTER DHCP migration, or update on existing DHCP server first

Set-DhcpServerv4OptionValue -ScopeId 192.168.1.0 -DnsServer 192.168.1.13,192.168.1.14,192.168.1.10
```

**Gradual DNS Cutover Approach:**
1. Add new DCs as secondary/tertiary DNS in DHCP options
2. Monitor DNS query logs for 24-48 hours
3. Move new DCs to primary positions
4. Remove old DCs from DNS server list (after full decommission)

### 4.3 DNS Best Practices

**Configure DNS Settings:**

```powershell
# Set DNS scavenging (if not already enabled)
Set-DnsServerScavenging -ScavengingState $true -ApplyOnAllZones

# Configure aging/scavenging on AD-integrated zones
Set-DnsServerZoneAging -Name "contoso.com" -Aging $true -RefreshInterval 7.00:00:00 -NoRefreshInterval 7.00:00:00
```

---

## Phase 5: DHCP Migration

### 5.1 Install DHCP Server Role

**Install on both new DCs:**

```powershell
# Install DHCP role
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Complete post-install configuration
Add-DhcpServerSecurityGroup
Restart-Service DHCPServer
```

### 5.2 Authorize DHCP Servers in Active Directory

**Authorization is required for domain-joined DHCP servers:**

```powershell
# Authorize new DHCP servers
Add-DhcpServerInDC -DnsName DC03.contoso.com -IPAddress 192.168.1.13
Add-DhcpServerInDC -DnsName DC04.contoso.com -IPAddress 192.168.1.14

# Verify authorization
Get-DhcpServerInDC
```

### 5.3 Export and Import DHCP Configuration

**Export from old DHCP server:**

```powershell
# On old DHCP server
Export-DhcpServer -File "\\DC01\Share\DHCP-Full-Export.xml" -Leases -Force
```

**Import to first new DC (DC03):**

```powershell
# On DC03
Import-DhcpServer -File "\\DC01\Share\DHCP-Full-Export.xml" -BackupPath "C:\Windows\System32\dhcp\backup" -Leases -Force

# Verify scopes imported
Get-DhcpServerv4Scope

# Verify reservations
Get-DhcpServerv4Reservation -ScopeId 192.168.1.0

# Verify server options
Get-DhcpServerv4OptionValue
```

### 5.4 Configure DHCP Failover

**Setup failover between DC03 and DC04 (recommended):**

```powershell
# On DC03, configure failover with DC04
Add-DhcpServerv4Failover `
    -Name "DC03-DC04-Failover" `
    -PartnerServer DC04.contoso.com `
    -ScopeId 192.168.1.0 `
    -LoadBalancePercent 50 `
    -SharedSecret (Read-Host -AsSecureString -Prompt "Enter shared secret") `
    -Force

# For multiple scopes, add each or use wildcards
Get-DhcpServerv4Scope | Add-DhcpServerv4Failover -Name "DC03-DC04-Failover" -PartnerServer DC04.contoso.com -Force
```

**Failover Configuration Options:**
- **Load Balance Mode** (recommended): 50/50 split, both servers actively serving leases
- **Hot Standby Mode**: Primary/secondary configuration
- **MCLT (Maximum Client Lead Time)**: Default 1 hour

### 5.5 DHCP Cutover

**Cutover Process:**

```powershell
# Test DHCP on new servers (from test client)
ipconfig /release
ipconfig /renew
ipconfig /all # Verify lease from new DHCP server

# After successful testing, deactivate scopes on old server
# On old DHCP server:
Get-DhcpServerv4Scope | Set-DhcpServerv4Scope -State InActive

# Monitor for 24-48 hours
# Verify all clients obtaining leases from new servers
Get-DhcpServerv4Lease -ScopeId 192.168.1.0
```

---

## Phase 6: NPS/RADIUS Migration

### 6.1 Install Network Policy Server Role

**Install NPS on both new DCs:**

```powershell
# Install NPS role
Install-WindowsFeature -Name NPAS -IncludeManagementTools

# Verify installation
Get-WindowsFeature -Name NPAS
```

### 6.2 Export NPS Configuration

**Export from existing NPS server:**

```powershell
# On old NPS server
Export-NpsConfiguration -Path "\\DC01\Share\NPS-Config.xml"
```

### 6.3 Import NPS Configuration

**Import to new DCs:**

```powershell
# On DC03
Import-NpsConfiguration -Path "\\DC01\Share\NPS-Config.xml"

# On DC04
Import-NpsConfiguration -Path "\\DC01\Share\NPS-Config.xml"

# Verify import
Get-NpsRadiusClient
Get-NpsNetworkPolicy
Get-NpsConnectionRequestPolicy
```

### 6.4 Update RADIUS Clients

**Update network devices to use new NPS servers:**

This must be done on each RADIUS client device (wireless access points, VPN servers, switches):

1. **Wireless Access Points (Meraki, Ubiquiti, etc.)**
   - Add DC03 and DC04 as RADIUS servers
   - Use same shared secret as old server
   - Configure as primary/secondary or load balance

2. **VPN Servers**
   - Update RADIUS authentication settings
   - Add new NPS servers to RADIUS server list

3. **Network Switches (802.1X)**
   - Update RADIUS server configuration
   - Test with sample port authentication

**Example Meraki Configuration:**
- Dashboard → Wireless → SSID → Access Control
- Add RADIUS servers: DC03 (192.168.1.13), DC04 (192.168.1.14)
- Keep old server temporarily as tertiary for rollback

### 6.5 Testing NPS/RADIUS

**Test authentication:**

1. Test wireless authentication (802.1X)
2. Test VPN authentication
3. Monitor NPS event logs during testing:

```powershell
# Monitor NPS authentication events
Get-WinEvent -LogName "Security" -FilterXPath "*[System[(EventID=6272 or EventID=6273)]]" | Select-Object -First 10
```

4. Verify accounting records being generated

---

## Phase 7: Certificate Services Migration

### 7.1 Certificate Authority Planning

**Important Considerations:**

- **Do NOT run multiple Enterprise Root CAs** in the same forest
- If existing CA is Enterprise Root → New CA should be Enterprise Subordinate
- If migrating CA entirely → Requires CA migration process (complex)
- Recommended approach: **Install Subordinate CA or migrate existing CA**

### 7.2 Install Active Directory Certificate Services

**Install AD CS role on DC03:**

```powershell
# Install AD CS role
Install-WindowsFeature -Name AD-Certificate -IncludeManagementTools

# Note: Configuration done through GUI for CA setup
```

### 7.3 Configure Enterprise Subordinate CA (Recommended)

**Configuration via GUI (certlm.msc or Server Manager):**

1. Open Server Manager → Add Roles → Active Directory Certificate Services
2. Select "Certification Authority" and "Certification Authority Web Enrollment"
3. Choose "Enterprise CA"
4. Choose "Subordinate CA"
5. Create new private key
6. Specify CA name (e.g., "Contoso Issuing CA 01")
7. Request certificate from parent CA
8. Submit request to existing Root CA
9. Import issued certificate

**Or use PowerShell for basic configuration:**

```powershell
# This is a simplified example - actual subordinate CA setup requires parent CA request
Install-AdcsCertificationAuthority `
    -CAType EnterpriseSubordinateCA `
    -CACommonName "Contoso Issuing CA 01" `
    -KeyLength 4096 `
    -HashAlgorithm SHA256 `
    -CryptoProviderName "RSA#Microsoft Software Key Storage Provider"
```

### 7.4 Configure CDP and AIA Locations

**Configure Certificate Distribution Points:**

```powershell
# Add CDP locations
# These allow clients to check certificate revocation status

# Example: Configure HTTP CDP location
# This requires web server hosting CRL files
certutil -setreg CA\CRLPublicationURLs "1:C:\Windows\System32\CertSrv\CertEnroll\%3%8.crl\n2:http://pki.contoso.com/CertEnroll/%3%8.crl"

# Configure AIA locations
certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\System32\CertSrv\CertEnroll\%1_%3%4.crt\n2:http://pki.contoso.com/CertEnroll/%1_%3%4.crt"

# Restart CA service
Restart-Service CertSvc
```

### 7.5 Migrate Certificate Templates

**Copy certificate templates from old CA:**

Certificate templates are stored in AD and automatically replicate, but you need to publish them on the new CA:

```powershell
# Via GUI: certmpl.msc or CA console
# Select templates to publish on new CA

# Via PowerShell (requires PSPKI module)
Install-Module -Name PSPKI

# Get templates from old CA
$templates = Get-CATemplate -CertificationAuthority "OldCA.contoso.com"

# Publish on new CA
$templates | Add-CATemplate -CertificationAuthority "DC03.contoso.com"
```

### 7.6 Update Auto-Enrollment GPO

**Configure clients to use new CA:**

```powershell
# Via Group Policy:
# Computer Configuration → Policies → Windows Settings → Security Settings → Public Key Policies
# 1. Update "Certificate Services Client - Auto-Enrollment"
# 2. Verify "Certificate Services Client - Certificate Enrollment Policy"

# New CA will be automatically discovered via AD, but verify:
certutil -pulse # On client to force certificate auto-enrollment
```

### 7.7 Certificate Services Testing

**Test certificate enrollment:**

```powershell
# Request certificate from new CA
# Via GUI: certlm.msc → Personal → All Tasks → Request New Certificate

# Via PowerShell:
Get-Certificate -Template "Computer" -CertStoreLocation Cert:\LocalMachine\My

# Verify certificate chain
certutil -verify "C:\path\to\certificate.cer"

# Check CRL distribution
certutil -URL "C:\path\to\certificate.cer"
```

---

## Phase 8: Post-Deployment Validation

### 8.1 Active Directory Health Checks

**Run comprehensive diagnostics:**

```powershell
# Run dcdiag on all DCs
dcdiag /v /c /e /f:C:\Logs\dcdiag.txt

# Check replication status
repadmin /replsummary
repadmin /showrepl /verbose

# Verify FSMO roles are accessible
netdom query fsmo

# Check DNS health
dcdiag /test:dns /v /e

# Verify SYSVOL replication
dfsrmig /getglobalstate
repadmin /syncall /AdeP
```

### 8.2 Service-Specific Validation

**DHCP Validation:**

```powershell
# Check DHCP statistics
Get-DhcpServerv4Statistics -ComputerName DC03
Get-DhcpServerv4Statistics -ComputerName DC04

# Verify failover status
Get-DhcpServerv4Failover

# Check active leases
Get-DhcpServerv4Lease -ScopeId 192.168.1.0 | Measure-Object
```

**DNS Validation:**

```powershell
# Verify zone replication
Get-DnsServerZone | Where-Object {$_.IsDsIntegrated} | Select-Object ZoneName, ReplicationScope

# Test DNS resolution from clients
nslookup domain.com DC03
nslookup domain.com DC04
```

**NPS Validation:**

```powershell
# Check NPS event logs for authentication events
Get-WinEvent -LogName "Security" -MaxEvents 50 | Where-Object {$_.Id -eq 6272 -or $_.Id -eq 6273}

# Verify RADIUS client configuration
Get-NpsRadiusClient | Format-Table Name, Address, Enabled
```

**Certificate Services Validation:**

```powershell
# Verify CA health
certutil -ping

# Check CRL publication
certutil -CRL

# Verify certificate chain
certutil -verify -urlfetch "C:\test-cert.cer"
```

### 8.3 Client Testing

**Test from multiple clients:**

1. **Authentication**: Log in with domain accounts
2. **Group Policy**: Run `gpupdate /force` and `gpresult /r`
3. **DNS**: Test name resolution for internal and external names
4. **DHCP**: Release/renew IP address, verify lease from new server
5. **Wireless**: Test 802.1X authentication with new RADIUS servers
6. **Certificates**: Request computer/user certificates, verify enrollment
7. **File Access**: Test SYSVOL/NETLOGON access

### 8.4 Monitoring Period

**Monitor for 30 days minimum:**

- Event logs on all DCs (System, Directory Service, DNS, DHCP)
- Replication health daily
- DHCP lease activity
- NPS authentication success/failure rates
- Certificate enrollment and CRL distribution
- Client connectivity issues

**Set up monitoring alerts:**

```powershell
# Create scheduled task to run daily health check
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File C:\Scripts\DC-HealthCheck.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 6AM
Register-ScheduledTask -TaskName "DC Health Check" -Action $action -Trigger $trigger -User "SYSTEM"
```

---

## Phase 9: Old Domain Controller Decommission

### 9.1 Pre-Decommission Checklist

**Do NOT decommission until:**

- [ ] Minimum 30 days of successful operation on new DCs
- [ ] Zero replication errors for 14+ days
- [ ] All services migrated and tested (DNS, DHCP, NPS, CA)
- [ ] FSMO roles transferred (if old DCs held any roles)
- [ ] Monitoring confirms no dependencies on old DCs
- [ ] Change control approval obtained

### 9.2 Transfer FSMO Roles (If Needed)

**Check current FSMO role holders:**

```powershell
netdom query fsmo
```

**Transfer roles if old DC holds any:**

```powershell
# Transfer all roles to DC03 (example)
Move-ADDirectoryServerOperationMasterRole -Identity "DC03" -OperationMasterRole SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster, InfrastructureMaster
```

### 9.3 Graceful Demotion

**Demote old DC properly:**

```powershell
# On old DC
Uninstall-ADDSDomainController -DemoteOperationMasterRole -RemoveApplicationPartitions

# Follow prompts to complete demotion
# Server will revert to member server or workgroup
```

**Post-Demotion Cleanup:**

```powershell
# On any remaining DC, verify old DC metadata is removed
# Check for orphaned DC objects
Get-ADDomainController -Filter * | Select-Object Name, Enabled

# If metadata remains after demotion, clean it up
ntdsutil
metadata cleanup
connections
connect to server DC03
quit
select operation target
list sites
select site 0
list servers in site
select server <old-dc-number>
quit
remove selected server
quit
quit
```

### 9.4 Remove Old Services

**Decommission old DHCP server:**

```powershell
# Unauthorize old DHCP server
Remove-DhcpServerInDC -DnsName OldDC.contoso.com -IPAddress 192.168.1.10
```

**Remove old CA (if migrated):**

This is complex and requires careful planning. Follow Microsoft CA migration guides if performing full CA replacement.

**Update DNS records:**

```powershell
# Remove old DC DNS records
# Check for orphaned records
Get-DnsServerResourceRecord -ZoneName "contoso.com" -ComputerName DC03 | Where-Object {$_.HostName -like "OldDC"}
```

---

## Phase 10: Documentation & Knowledge Transfer

### 10.1 Update Documentation

**Required documentation updates:**

1. **Network Diagram**: Update with new DC IP addresses and roles
2. **Server Inventory**: Add DC03 and DC04, remove old DCs
3. **DHCP Scope Documentation**: Update DHCP server references
4. **DNS Server List**: Update for client configuration
5. **RADIUS Client Configuration**: Document new NPS servers
6. **Certificate Services**: Document new CA hierarchy
7. **Disaster Recovery Plan**: Update DC restore procedures
8. **Runbooks**: Update operational procedures

### 10.2 Update Customer Profile

**Update repository customer profile:**

```markdown
## Domain Controllers

- **DC03** (192.168.1.13) - Windows Server 2022
  - Roles: AD DS, DNS, DHCP, NPS, CA
  - FSMO Roles: [If applicable]

- **DC04** (192.168.1.14) - Windows Server 2022
  - Roles: AD DS, DNS, DHCP, NPS
  - DHCP Failover Partner: DC03
```

### 10.3 Credential Management

**Update in Keeper Security:**

- DSRM passwords for DC03 and DC04
- CA recovery key/password
- DHCP failover shared secret
- NPS shared secrets (if changed)

### 10.4 Backup Validation

**Verify backups include new DCs:**

```powershell
# Verify System State backup configured
Get-WBSummary
Get-WBPolicy

# Test restore procedure (in lab if possible)
```

---

## Appendix A: Commands Quick Reference

### Replication Commands

```powershell
# Force replication
repadmin /syncall /AdeP

# Show replication summary
repadmin /replsummary

# Show replication partners
repadmin /showrepl

# Check for replication errors
repadmin /showrepl * /csv | ConvertFrom-Csv | Where-Object {$_."Number of Failures" -gt 0}
```

### DHCP Commands

```powershell
# Export DHCP
Export-DhcpServer -File "C:\dhcp-backup.xml" -Leases

# Import DHCP
Import-DhcpServer -File "C:\dhcp-backup.xml" -Leases -Force

# Configure failover
Add-DhcpServerv4Failover -Name "Failover-Name" -PartnerServer DC04 -ScopeId 192.168.1.0 -LoadBalancePercent 50
```

### NPS Commands

```powershell
# Export NPS
Export-NpsConfiguration -Path "C:\nps-config.xml"

# Import NPS
Import-NpsConfiguration -Path "C:\nps-config.xml"

# List RADIUS clients
Get-NpsRadiusClient
```

### Certificate Services Commands

```powershell
# Check CA health
certutil -ping

# Publish CRL
certutil -CRL

# Verify certificate chain
certutil -verify -urlfetch cert.cer

# Force certificate enrollment
certutil -pulse
```

---

## Appendix B: Rollback Procedures

### If DC Promotion Fails

1. Review dcpromo logs: `%SystemRoot%\debug\dcpromoui.log`
2. Verify DNS resolution and network connectivity
3. Check for port blockages (firewall)
4. Demote failed DC: `Uninstall-ADDSDomainController -LocalAdministratorPassword (Read-Host -AsSecureString)`
5. Review and remediate issues before retry

### If DHCP Migration Fails

1. Reactivate scopes on old DHCP server
2. Deactivate scopes on new DHCP server
3. Review event logs on both servers
4. Verify failover configuration if using
5. Test with single scope before migrating all

### If Replication Fails

1. Check network connectivity between DCs
2. Verify DNS resolution
3. Check firewall rules
4. Force replication: `repadmin /syncall /AdeP`
5. Check FRS/DFSR status: `dfsrmig /getglobalstate`
6. Review Event ID 4013, 13508, 13509 in DFSR logs

### Emergency Rollback

If critical issues arise within 30 days:

1. **Stop promoting new services** to new DCs
2. **Revert DNS/DHCP** to old servers
3. **Document issues** thoroughly
4. **Engage Microsoft Support** if needed
5. **Plan remediation** before continuing

---

## Appendix C: Troubleshooting Common Issues

### DNS Replication Issues

**Symptom**: DNS zones not appearing on new DCs

**Solution**:
```powershell
# Force zone replication
dnscmd /ZoneResetType domain.com /DsPrimary /DP /domain

# Check DNS event log
Get-WinEvent -LogName "DNS Server" -MaxEvents 50
```

### DHCP Failover Problems

**Symptom**: Failover relationship shows error state

**Solution**:
```powershell
# Check failover status
Get-DhcpServerv4Failover -Name "Failover-Name"

# Replicate failover scopes
Invoke-DhcpServerv4FailoverReplication -Name "Failover-Name" -Force

# Verify time sync between partners (critical)
w32tm /query /status
```

### SYSVOL Replication Stuck

**Symptom**: SYSVOL not replicating to new DCs

**Solution**:
```powershell
# Check DFSR state
dfsrmig /getmigrationstate

# Check DFSR health
dfsrdiag replicationstate /all

# Force DFSR replication
dfsrdiag pollad
dfsrdiag syncnow /partner:DC03 /RGname:"Domain System Volume" /Time:1
```

### Certificate Enrollment Failures

**Symptom**: Clients cannot enroll certificates from new CA

**Solution**:
```powershell
# Verify CA is publishing to AD
certutil -adca

# Check certificate templates
certutil -CATemplates

# Force policy update on client
certutil -pulse

# Check CRL validity
certutil -URL certificate.cer
```

---

## Appendix D: Security Considerations

### Antivirus Exclusions

**Add these exclusions on all DCs:**

- `%SystemRoot%\NTDS\` (AD database)
- `%SystemRoot%\SYSVOL\` (Group Policy)
- `%SystemRoot%\System32\dhcp\` (DHCP database)
- `C:\Windows\System32\CertLog\` (CA database)
- DFSR staging folders

### Firewall Rules

**Required ports between DCs:**

- TCP/UDP 389 - LDAP
- TCP/UDP 88 - Kerberos
- TCP/UDP 53 - DNS
- TCP 135 - RPC
- TCP 3268-3269 - Global Catalog
- TCP/UDP 445 - SMB
- TCP/UDP 123 - NTP
- Dynamic RPC ports (49152-65535)

### Secure Admin Practices

- Use separate admin accounts for DC management
- Enable PowerShell logging
- Implement LAPS for local admin passwords
- Regular review of privileged group membership
- Enable Advanced Audit Policy for DCs

---

## Timeline Estimate

| Phase | Duration | Notes |
|-------|----------|-------|
| Planning & Documentation | 1-2 days | Depends on environment complexity |
| Base Server Setup | 1 day | Both servers in parallel |
| DC Promotion | 1 day | Includes initial replication wait |
| DNS Migration | 2 hours | Mostly automated |
| DHCP Migration | 4-8 hours | Includes testing period |
| NPS Migration | 2-4 hours | Plus device configuration time |
| Certificate Services | 1-2 days | Complex, may require CA planning |
| Testing & Validation | 3-5 days | Concurrent with monitoring |
| Monitoring Period | 30 days | Before decommission consideration |
| Old DC Decommission | 1 day | After monitoring period |

**Total project duration: 2-4 weeks** (with 30-day monitoring overlap)

---

## Success Criteria

**Project is complete when:**

- [ ] Both new DCs promoting and replicating successfully
- [ ] All FSMO roles accessible and healthy
- [ ] DNS zones fully replicated, clients resolving names
- [ ] DHCP serving leases in failover mode
- [ ] NPS authenticating RADIUS clients
- [ ] Certificate Services issuing certificates (if applicable)
- [ ] Zero replication errors for 14+ consecutive days
- [ ] All services tested from multiple clients
- [ ] Documentation updated in customer profile and Keeper
- [ ] 30-day monitoring period completed
- [ ] Old DCs gracefully decommissioned
- [ ] Backup/DR procedures validated with new DCs

---

## Contact & Support

**Project Lead**: [Your Name]
**Customer**: [Customer Name]
**Escalation**: Midwest Cloud Computing NOC

**Microsoft Resources**:
- Active Directory Replication: https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/replication/
- DHCP Failover: https://learn.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-failover
- Certificate Services: https://learn.microsoft.com/en-us/windows-server/networking/core-network-guide/cncg/server-certs/

**Change Control**: Document all changes in customer ticketing system (Zoho Desk)
