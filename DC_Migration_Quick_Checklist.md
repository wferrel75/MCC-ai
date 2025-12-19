# Domain Controller Migration - Quick Reference Checklist

**Project**: Add 2 New Domain Controllers with DHCP, DNS, NPS, and CA Migration

---

## Pre-Flight Checklist

### Documentation & Backups
- [ ] Document current DC names, IPs, FSMO roles (`netdom query fsmo`)
- [ ] Backup all DCs (System State): `wbadmin start systemstatebackup -backupTarget:E:`
- [ ] Export DHCP: `Export-DhcpServer -File "C:\Backup\DHCP.xml" -Leases`
- [ ] Export NPS: `Export-NpsConfiguration -Path "C:\Backup\NPS.xml"`
- [ ] Backup CA: `certutil -backup "C:\Backup\CA"`
- [ ] Document DHCP scopes, reservations, and options
- [ ] Document DNS zones and forwarders
- [ ] List NPS RADIUS clients
- [ ] Document CA templates and hierarchy

### Prerequisites Verification
- [ ] Verify DNS working: `dcdiag /test:dns`
- [ ] Check replication health: `repadmin /replsummary`
- [ ] Verify time sync: `w32tm /query /status`
- [ ] Check domain/forest functional levels
- [ ] Confirm network ports open between DCs (53, 88, 389, 445, 135, 3268)
- [ ] Static IPs assigned for new DCs
- [ ] Windows Server licenses available

---

## Phase 1: Base Server Setup

### DC03 Setup
- [ ] Install Windows Server (with Desktop Experience)
- [ ] Set computer name: `Rename-Computer -NewName "DC03" -Restart`
- [ ] Configure static IP: `New-NetIPAddress -IPAddress 192.168.1.13 -PrefixLength 24 -DefaultGateway 192.168.1.1`
- [ ] Set DNS to existing DCs: `Set-DnsClientServerAddress -ServerAddresses 192.168.1.10,192.168.1.11`
- [ ] Install Windows Updates: `Install-WindowsUpdate -AcceptAll -AutoReboot`
- [ ] Join domain: `Add-Computer -DomainName contoso.com -Restart`
- [ ] Verify domain join: `Get-ComputerInfo | Select CsDomain`

### DC04 Setup
- [ ] Repeat all DC03 steps with IP 192.168.1.14

---

## Phase 2: Promote to Domain Controllers

### DC03 Promotion
- [ ] Install AD DS role: `Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools`
- [ ] Promote to DC:
  ```powershell
  Install-ADDSDomainController -DomainName contoso.com -InstallDns -SafeModeAdministratorPassword (Read-Host -AsSecureString)
  ```
- [ ] **Wait 15-30 minutes after restart**
- [ ] Verify promotion: `dcdiag /v /c`
- [ ] Check replication: `repadmin /showrepl`
- [ ] Verify SYSVOL: `dir \\DC03\SYSVOL`
- [ ] Check DNS registration: `nslookup DC03.contoso.com`

### DC04 Promotion
- [ ] Repeat DC03 promotion steps
- [ ] Verify replication between all DCs: `repadmin /replsummary`
- [ ] Force replication: `repadmin /syncall /AdeP`
- [ ] Verify SYSVOL state: `dfsrmig /getglobalstate` (should show "DFSR")

---

## Phase 3: DNS Migration

- [ ] Verify DNS zones on new DCs: `Get-DnsServerZone`
- [ ] Check zone replication: `Get-DnsServerZone -Name "contoso.com" | Select ZoneName, ReplicationScope`
- [ ] Verify forwarders: `Get-DnsServerForwarder`
- [ ] Test DNS resolution from new DCs:
  ```powershell
  Resolve-DnsName -Name contoso.com -Server DC03
  Resolve-DnsName -Name contoso.com -Server DC04
  ```
- [ ] Update DHCP option 006 (DNS) to include new DCs (after DHCP migration)
- [ ] Configure DNS scavenging if needed: `Set-DnsServerScavenging -ScavengingState $true`

---

## Phase 4: DHCP Migration

### Install & Authorize
- [ ] Install DHCP on DC03: `Install-WindowsFeature -Name DHCP -IncludeManagementTools`
- [ ] Install DHCP on DC04: `Install-WindowsFeature -Name DHCP -IncludeManagementTools`
- [ ] Complete post-install on both: `Add-DhcpServerSecurityGroup; Restart-Service DHCPServer`
- [ ] Authorize DC03: `Add-DhcpServerInDC -DnsName DC03.contoso.com -IPAddress 192.168.1.13`
- [ ] Authorize DC04: `Add-DhcpServerInDC -DnsName DC04.contoso.com -IPAddress 192.168.1.14`
- [ ] Verify: `Get-DhcpServerInDC`

### Import Configuration
- [ ] Import to DC03: `Import-DhcpServer -File "\\DC01\Share\DHCP.xml" -Leases -Force`
- [ ] Verify scopes: `Get-DhcpServerv4Scope`
- [ ] Verify reservations: `Get-DhcpServerv4Reservation`
- [ ] Verify options: `Get-DhcpServerv4OptionValue`

### Configure Failover
- [ ] Setup failover DC03↔DC04:
  ```powershell
  Add-DhcpServerv4Failover -Name "DC03-DC04-Failover" -PartnerServer DC04.contoso.com -ScopeId 192.168.1.0 -LoadBalancePercent 50 -Force
  ```
- [ ] Add all scopes to failover: `Get-DhcpServerv4Scope | Add-DhcpServerv4Failover -Name "DC03-DC04-Failover"`
- [ ] Verify failover: `Get-DhcpServerv4Failover`

### Cutover
- [ ] **Test from client**: `ipconfig /release; ipconfig /renew; ipconfig /all`
- [ ] Verify lease from new server
- [ ] Deactivate old server scopes: `Get-DhcpServerv4Scope | Set-DhcpServerv4Scope -State InActive`
- [ ] Monitor for 24-48 hours: `Get-DhcpServerv4Statistics`

---

## Phase 5: NPS/RADIUS Migration

### Install & Configure
- [ ] Install NPS on DC03: `Install-WindowsFeature -Name NPAS -IncludeManagementTools`
- [ ] Install NPS on DC04: `Install-WindowsFeature -Name NPAS -IncludeManagementTools`
- [ ] Import config to DC03: `Import-NpsConfiguration -Path "\\DC01\Share\NPS.xml"`
- [ ] Import config to DC04: `Import-NpsConfiguration -Path "\\DC01\Share\NPS.xml"`
- [ ] Verify import: `Get-NpsRadiusClient; Get-NpsNetworkPolicy`

### Update RADIUS Clients
- [ ] Update wireless access points (add DC03 192.168.1.13, DC04 192.168.1.14)
- [ ] Update VPN servers
- [ ] Update network switches (802.1X)
- [ ] Keep old NPS as tertiary temporarily

### Testing
- [ ] Test wireless 802.1X authentication
- [ ] Test VPN authentication
- [ ] Monitor NPS events: `Get-WinEvent -LogName Security | Where {$_.Id -eq 6272 -or $_.Id -eq 6273}`
- [ ] Verify accounting records

---

## Phase 6: Certificate Services Migration

**⚠️ IMPORTANT: Choose correct CA type (Subordinate if Root CA exists)**

### Install & Configure (Subordinate CA Example)
- [ ] Install AD CS on DC03: `Install-WindowsFeature -Name AD-Certificate -IncludeManagementTools`
- [ ] Configure via Server Manager:
  - [ ] Select "Certification Authority"
  - [ ] Choose "Enterprise CA"
  - [ ] Choose "Subordinate CA"
  - [ ] Create new private key (4096-bit, SHA256)
  - [ ] Name: "Contoso Issuing CA 01"
  - [ ] Request certificate from parent CA
  - [ ] Submit request to Root CA
  - [ ] Import issued certificate

### Configure CDP/AIA
- [ ] Configure CRL locations:
  ```powershell
  certutil -setreg CA\CRLPublicationURLs "1:C:\Windows\System32\CertSrv\CertEnroll\%3%8.crl\n2:http://pki.contoso.com/CertEnroll/%3%8.crl"
  ```
- [ ] Configure AIA:
  ```powershell
  certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\System32\CertSrv\CertEnroll\%1_%3%4.crt\n2:http://pki.contoso.com/CertEnroll/%1_%3%4.crt"
  ```
- [ ] Restart CA: `Restart-Service CertSvc`

### Publish Templates & Test
- [ ] Publish certificate templates on new CA (via certmpl.msc)
- [ ] Update auto-enrollment GPO if needed
- [ ] Test enrollment: `Get-Certificate -Template "Computer" -CertStoreLocation Cert:\LocalMachine\My`
- [ ] Verify chain: `certutil -verify cert.cer`
- [ ] Check CRL: `certutil -CRL`

---

## Phase 7: Post-Deployment Validation

### AD Health
- [ ] Run dcdiag: `dcdiag /v /c /e`
- [ ] Check replication: `repadmin /replsummary`
- [ ] Verify FSMO roles: `netdom query fsmo`
- [ ] Test DNS: `dcdiag /test:dns /v /e`
- [ ] Force sync: `repadmin /syncall /AdeP`

### Service Validation
- [ ] DHCP statistics: `Get-DhcpServerv4Statistics -ComputerName DC03`
- [ ] DHCP failover status: `Get-DhcpServerv4Failover`
- [ ] DNS zones: `Get-DnsServerZone | Where {$_.IsDsIntegrated}`
- [ ] NPS events: Check Security log for EventID 6272/6273
- [ ] CA health: `certutil -ping`

### Client Testing
- [ ] Test domain login from multiple clients
- [ ] Test Group Policy: `gpupdate /force; gpresult /r`
- [ ] Test DNS resolution
- [ ] Test DHCP: `ipconfig /release; ipconfig /renew`
- [ ] Test wireless (802.1X with new NPS)
- [ ] Test certificate enrollment

---

## Phase 8: 30-Day Monitoring Period

### Daily Checks (Week 1)
- [ ] Replication health: `repadmin /replsummary`
- [ ] Event log errors (all DCs)
- [ ] DHCP lease activity
- [ ] NPS authentication logs
- [ ] Client connectivity issues

### Weekly Checks (Weeks 2-4)
- [ ] Run full dcdiag on all DCs
- [ ] Check DHCP failover statistics
- [ ] Review NPS success/failure rates
- [ ] Certificate enrollment success
- [ ] Client DNS resolution issues

### Continuous Monitoring
- [ ] Event log alerts configured
- [ ] No replication errors for 14+ days
- [ ] All services operating normally
- [ ] No client complaints or issues

---

## Phase 9: Old DC Decommission (After 30 Days)

**⚠️ DO NOT PROCEED UNTIL 30+ DAYS OF STABLE OPERATION**

### Pre-Decommission
- [ ] Verify 30+ days stable operation
- [ ] Zero replication errors for 14+ days
- [ ] All services migrated successfully
- [ ] Change control approval obtained

### Transfer FSMO Roles (If Needed)
- [ ] Check current holders: `netdom query fsmo`
- [ ] Transfer if needed:
  ```powershell
  Move-ADDirectoryServerOperationMasterRole -Identity "DC03" -OperationMasterRole SchemaMaster,DomainNamingMaster,PDCEmulator,RIDMaster,InfrastructureMaster
  ```

### Demote Old DC
- [ ] Demote gracefully:
  ```powershell
  Uninstall-ADDSDomainController -DemoteOperationMasterRole -RemoveApplicationPartitions
  ```
- [ ] Verify metadata removed: `Get-ADDomainController -Filter *`
- [ ] Clean orphaned metadata if needed (ntdsutil)
- [ ] Remove from DHCP server list: `Remove-DhcpServerInDC -DnsName OldDC.contoso.com`
- [ ] Remove orphaned DNS records

---

## Documentation & Closeout

- [ ] Update network diagram with new DC IPs and roles
- [ ] Update server inventory
- [ ] Update customer profile in repository:
  ```markdown
  ## Domain Controllers
  - **DC03** (192.168.1.13) - Windows Server 2022
    - Roles: AD DS, DNS, DHCP, NPS, CA
  - **DC04** (192.168.1.14) - Windows Server 2022
    - Roles: AD DS, DNS, DHCP, NPS
  ```
- [ ] Document DSRM passwords in Keeper Security
- [ ] Document CA recovery key in Keeper
- [ ] Document DHCP failover shared secret in Keeper
- [ ] Update disaster recovery procedures
- [ ] Verify System State backups configured for new DCs
- [ ] Update runbooks and operational procedures
- [ ] Close change control ticket
- [ ] Schedule follow-up review (90 days)

---

## Emergency Rollback Procedures

**If critical issues arise:**

1. **Stop** - Do not proceed with additional changes
2. **Assess** - Document all symptoms and errors
3. **Revert DNS/DHCP** - Reactivate services on old servers
4. **Check logs** - Review Event Viewer on all DCs
5. **Engage support** - Contact Microsoft Support if needed
6. **Plan remediation** - Address root cause before continuing

**Common rollback actions:**
- DHCP: `Set-DhcpServerv4Scope -State Active` (on old server)
- DHCP: `Set-DhcpServerv4Scope -State InActive` (on new servers)
- DNS: Update DHCP option 006 to point to old DCs
- NPS: Revert RADIUS client configurations to old NPS

---

## Quick Command Reference

```powershell
# Replication
repadmin /replsummary
repadmin /showrepl
repadmin /syncall /AdeP

# DNS
Get-DnsServerZone
Resolve-DnsName -Name contoso.com -Server DC03

# DHCP
Get-DhcpServerv4Scope
Get-DhcpServerv4Failover
Get-DhcpServerv4Statistics

# NPS
Get-NpsRadiusClient
Get-NpsNetworkPolicy

# Certificate Services
certutil -ping
certutil -CRL
certutil -verify cert.cer

# AD Health
dcdiag /v /c /e
netdom query fsmo
```

---

## Success Criteria

✅ **Project complete when:**
- Both new DCs promoting and replicating successfully
- DNS, DHCP, NPS, CA migrated and tested
- Zero replication errors for 14+ days
- 30-day monitoring period completed
- Old DCs gracefully decommissioned
- All documentation updated

---

**Project Lead**: ___________________
**Customer**: ___________________
**Start Date**: ___________________
**Target Completion**: ___________________

**Sign-off**:
- [ ] Technical validation complete
- [ ] Customer acceptance
- [ ] Documentation complete
- [ ] Project closed
