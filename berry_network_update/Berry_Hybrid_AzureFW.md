# Berry Law - Azure-Native Cloud Security Architecture
## Midwest Cloud Computing - Microsoft-First Network Design

**Document Version:** 1.0
**Created:** November 20, 2025
**Customer:** Berry Law (John S. Berry Law, PC)
**Project:** RapidScale/VMWare to Azure-Native Security Architecture

---

## Executive Summary

This document presents a **Microsoft Azure-native architecture** as an alternative to the Palo Alto hybrid and Meraki-only designs. This approach leverages Azure's native security and networking services for centralized cloud security, eliminating the need for third-party firewall vendors in the cloud.

**Key Characteristics:**
- **Azure Firewall Premium** for centralized threat protection and TLS inspection
- **Azure VPN Gateway** for site-to-site connectivity to offices
- **Azure Point-to-Site VPN** or **Always On VPN** for remote users
- **Microsoft Defender for Endpoint** for endpoint threat protection
- **Microsoft Defender for Cloud Apps** (CASB) for SaaS security
- **Microsoft Purview DLP** for data loss prevention
- **Meraki MX firewalls** at offices for local infrastructure (optional)

**Trade-offs vs. Other Architectures:**
- **Pros:** Deep M365 integration, Microsoft-first stack, Azure-native management
- **Cons:** Higher ongoing costs (~$130K-160K/year), limited advanced threat features vs. PA
- **Best For:** Organizations heavily invested in Microsoft 365 ecosystem

---

## Architecture Overview

### Microsoft Cloud-First Design

**Azure Hub Architecture:**
```
                    ┌─────────────────────────────────────────┐
                    │         Microsoft Azure                 │
                    │                                         │
                    │  ┌───────────────────────────────────┐ │
                    │  │   Azure Firewall Premium          │ │
                    │  │   - IDPS (Threat Intelligence)    │ │
                    │  │   - TLS Inspection                │ │
                    │  │   - URL Filtering                 │ │
                    │  │   - Application Rules (FQDN)      │ │
                    │  └─────────────┬─────────────────────┘ │
                    │                │                       │
                    │  ┌─────────────▼─────────────────────┐ │
                    │  │   Azure VPN Gateway               │ │
                    │  │   - Site-to-Site (Offices)        │ │
                    │  │   - Point-to-Site (Remote Users)  │ │
                    │  │   - Active/Active HA              │ │
                    │  └───────────────────────────────────┘ │
                    │                                         │
                    └─────────────────────────────────────────┘
                                     │
                        VPN Tunnels (IPsec)
                                     │
        ┌────────────────────────────┼────────────────────────┐
        │                            │                        │
   ┌────▼─────┐               ┌─────▼──────┐          ┌─────▼──────┐
   │ Lincoln  │               │  Omaha     │          │ Papillion  │
   │ Meraki   │◄─────────────►│  Meraki    │◄────────►│  Meraki    │
   │ MX95 HA  │   Auto VPN    │  MX95 HA   │ Auto VPN │  MX75      │
   └──────────┘               └────────────┘          └────────────┘
        │                            │                        │
   Infrastructure              Infrastructure           Infrastructure

        ┌─────────────┐            ┌─────────────┐
        │ West Omaha  │            │Council Bluffs│
        │ Meraki MX68 │◄──────────►│ Meraki MX68 │
        │             │  Auto VPN  │             │
        └─────────────┘            └─────────────┘
              │                          │
        Infrastructure            Infrastructure

   ┌──────────────────────────────────────────────────┐
   │        ALL User Endpoints                         │
   │  - Point-to-Site VPN to Azure VPN Gateway        │
   │  - Microsoft Defender for Endpoint               │
   │  - Microsoft 365 Apps                            │
   └──────────────────────────────────────────────────┘
```

### Microsoft Security Stack Integration

**Cloud Security Components:**
- **Azure Firewall Premium** - Network security and threat protection
- **Microsoft Defender for Endpoint** - Endpoint detection and response (EDR)
- **Microsoft Defender for Cloud Apps** - Cloud Access Security Broker (CASB)
- **Microsoft Purview DLP** - Data loss prevention for M365 and endpoints
- **Azure Sentinel** - SIEM and security analytics
- **Azure Monitor** - Logging and monitoring
- **Microsoft Entra ID** (Azure AD) - Identity and access management with MFA

**Why This Stack:**
- Unified Microsoft ecosystem with single management portal
- Deep integration with Microsoft 365 (Exchange, SharePoint, Teams, OneDrive)
- Shared threat intelligence across all Microsoft security products
- Simplified licensing (can bundle with M365 E5)

---

## Azure Cloud Components

### Azure Firewall Premium

**Role:** Centralized network security and threat protection for all user and office traffic

**Azure Firewall Premium Features:**
- **IDPS (Intrusion Detection and Prevention):** Signature-based threat detection
- **TLS Inspection:** Decrypt and inspect HTTPS traffic (similar to PA SSL inspection)
- **URL Filtering:** Web content filtering with Microsoft threat intelligence
- **Application Rules:** Allow/deny based on FQDN (fully qualified domain names)
- **Network Rules:** Layer 3/4 firewall rules
- **Threat Intelligence:** Microsoft threat intelligence feed (updated continuously)
- **DNS Proxy:** DNS filtering and security

**Deployment:**
- **SKU:** Azure Firewall Premium (required for TLS inspection and IDPS)
- **Availability Zones:** Deployed across multiple zones for 99.99% SLA
- **Public IP:** Standard SKU public IP for internet egress
- **Virtual Network:** Hub VNet with firewall subnet (/26 minimum)

**Pricing (Estimated):**
- **Deployment Cost:** ~$1.25/hour (~$900/month base + $0.016/GB processed)
- **Monthly Estimate:** ~$1,500-3,000/month depending on traffic volume
- **Annual Cost:** ~$18,000-36,000/year

**Limitations vs. Palo Alto:**
- **No full App-ID:** Application control is FQDN-based, not as granular as PA's App-ID
- **Limited DLP:** Basic URL filtering but no content inspection DLP (relies on Purview)
- **IDPS vs. IPS:** Signature-based only, less advanced than PA's threat prevention
- **No WildFire equivalent:** No cloud sandboxing for unknown malware

**Strengths vs. Palo Alto:**
- **Native Azure integration:** Seamless with Azure services and M365
- **Microsoft threat intelligence:** Shared across all Microsoft security products
- **Unified management:** Azure Portal for all security components
- **No VM maintenance:** Fully managed PaaS service (no patching, scaling handled by Microsoft)

---

### Azure VPN Gateway

**Role:** VPN connectivity for site-to-site (offices) and point-to-site (remote users)

**Site-to-Site VPN (Offices):**
- **Purpose:** Encrypted tunnels from Lincoln, Omaha, Papillion to Azure
- **Protocol:** IPsec/IKE
- **Configuration:** Active/Active or Active/Passive
- **SKU:** VpnGw2AZ or VpnGw3AZ (zone-redundant)
- **Throughput:**
  - VpnGw2AZ: 1 Gbps aggregate, 500 Mbps per tunnel
  - VpnGw3AZ: 1.25 Gbps aggregate, 500 Mbps per tunnel
- **Tunnels:** Up to 30 site-to-site tunnels per gateway

**Point-to-Site VPN (Remote Users):**
- **Purpose:** Secure access for remote workers and mobile devices
- **Protocols:**
  - IKEv2 (Windows, macOS, iOS)
  - OpenVPN (Windows, macOS, Linux, iOS, Android)
  - SSTP (Windows only)
- **Authentication:**
  - Azure AD (recommended - SSO with MFA)
  - Certificate-based (for non-AD devices)
  - RADIUS (for third-party MFA)
- **Concurrent Users:** Up to 10,000 connections (VpnGw3AZ)
- **Client:** Native Windows VPN client or Azure VPN Client

**Pricing (Estimated):**
- **VpnGw2AZ:** ~$375/month (~$4,500/year)
- **VpnGw3AZ:** ~$500/month (~$6,000/year)
- **Egress Data:** ~$0.087/GB (first 10 TB)

**Deployment:**
- **Gateway Subnet:** /27 or larger in hub VNet
- **Active/Active:** Recommended for 99.99% SLA
- **Availability Zones:** Deploy across zones for maximum uptime

---

### Microsoft Defender for Endpoint

**Role:** Endpoint detection and response (EDR) on all user workstations and laptops

**Features:**
- **Threat Detection:** Behavioral analysis, machine learning threat detection
- **Endpoint DLP:** Data loss prevention at the endpoint (file uploads, USB, print)
- **Attack Surface Reduction (ASR):** Reduce attack vectors (block Office macros, script execution)
- **Automated Investigation and Remediation (AIR):** Auto-respond to threats
- **Advanced Hunting:** Query endpoint telemetry for threat hunting
- **Integration with Defender for Cloud Apps:** Unified security dashboard

**Deployment:**
- **Agent:** Microsoft Defender agent on Windows, macOS, Linux, iOS, Android
- **Management:** Microsoft 365 Defender portal or Endpoint Manager (Intune)
- **Onboarding:** Deploy via GPO, Intune MDM, or manual installation
- **Licensing:** Requires Microsoft 365 E5, Microsoft 365 E3 + E5 Security add-on, or standalone

**Why Defender for Endpoint:**
- **Replaces third-party EDR:** No need for CrowdStrike, SentinelOne, etc.
- **Endpoint DLP:** Prevents data exfiltration at the endpoint (complements Purview DLP)
- **Integrated threat intelligence:** Shares signals with Azure Firewall, Defender for Cloud Apps
- **Attorney-client privilege:** Can block sensitive file uploads to unauthorized cloud apps

**Pricing (Estimated):**
- **Included with M365 E5:** ~$57/user/month
- **Standalone Defender for Endpoint P2:** ~$5.20/user/month (~$260/month for 50 users)
- **Annual (50 users):** ~$3,120/year standalone

---

### Microsoft Defender for Cloud Apps (CASB)

**Role:** Cloud Access Security Broker - monitors and controls SaaS application usage

**Features:**
- **Cloud App Discovery:** Identify all SaaS apps in use (shadow IT detection)
- **App Governance:** Allow/block cloud apps based on risk score
- **Session Control:** Real-time monitoring and control of SaaS app sessions
- **DLP for SaaS:** Data loss prevention for cloud apps (OneDrive, SharePoint, Box, Dropbox)
- **Threat Protection:** Detect anomalous behavior in cloud apps (impossible travel, unusual downloads)
- **Conditional Access App Control:** Integrate with Azure AD for app-level policies

**Integration with Azure Firewall:**
- Azure Firewall blocks/allows cloud apps at network layer
- Defender for Cloud Apps provides visibility into app usage and session control
- Combined: Network-layer + application-layer cloud app security

**Use Cases for Berry Law:**
- **Shadow IT:** Identify attorneys using personal Dropbox, Google Drive
- **DLP:** Block uploads of client files to unauthorized cloud storage
- **Session Control:** Allow OneDrive but block downloads to unmanaged devices
- **Anomaly Detection:** Alert on unusual data access patterns

**Pricing (Estimated):**
- **Included with M365 E5:** ~$57/user/month
- **Standalone:** ~$5/user/month (~$250/month for 50 users, ~$3,000/year)

---

### Microsoft Purview Data Loss Prevention (DLP)

**Role:** Data loss prevention across Microsoft 365, endpoints, and cloud apps

**DLP Capabilities:**
- **Content Inspection:** Scan files, emails, messages for sensitive data (client names, case numbers, SSN)
- **Policy Enforcement:** Block, warn, or audit when sensitive data is shared
- **Endpoints:** Prevent copy to USB, print, upload to cloud apps
- **Microsoft 365:** Protect Exchange, SharePoint, OneDrive, Teams
- **Cloud Apps:** Extend DLP to third-party SaaS (via Defender for Cloud Apps)

**Attorney-Client Privilege Protection:**
- **Custom Sensitive Info Types:** Define patterns for client names, case numbers, legal terms
- **Policy Rules:**
  - Block emails with client info to external recipients
  - Block uploads of legal documents to personal cloud storage
  - Warn when printing documents with client data
  - Audit all sharing of privileged documents
- **Integration:** DLP signals shared with Defender for Endpoint and Cloud Apps

**Pricing (Estimated):**
- **Included with M365 E5:** ~$57/user/month
- **Microsoft 365 E5 Compliance add-on (for E3):** ~$12/user/month
- **Purview DLP standalone:** Not available (must be part of M365 suite)

---

### Azure Sentinel (SIEM)

**Role:** Security Information and Event Management - centralized logging and threat detection

**Features:**
- **Log Aggregation:** Collect logs from Azure Firewall, VPN Gateway, Defender for Endpoint, M365
- **Threat Detection:** Built-in analytics rules for common attack patterns
- **Hunting Queries:** KQL (Kusto Query Language) for threat hunting
- **Incidents:** Automatically correlate alerts into incidents
- **SOAR:** Security Orchestration, Automation, and Response (automated playbooks)
- **Workbooks:** Pre-built dashboards for security insights

**Data Sources for Berry Law:**
- Azure Firewall logs (network traffic, IDPS alerts)
- Azure VPN Gateway logs (VPN connections, disconnections)
- Microsoft Defender for Endpoint (endpoint threats, DLP violations)
- Microsoft 365 (Exchange, SharePoint, Teams audit logs)
- Meraki MX logs (via syslog forwarder)
- Sign-in logs from Azure AD (MFA, failed logins)

**Pricing (Estimated):**
- **Pay-as-you-go:** ~$2.46/GB ingested
- **Estimated ingestion:** ~100-300 GB/month for 50 users
- **Monthly cost:** ~$250-750/month (~$3,000-9,000/year)
- **Commitment tier discounts available**

---

## Office Network Architecture (Meraki MX Option)

### Option 1: Meraki MX at All Offices (Recommended)

**Why Keep Meraki MX:**
- Simple cloud management for infrastructure devices
- Auto VPN for office-to-office connectivity
- Local internet breakout for infrastructure (printers, phones)
- No VPN client needed for infrastructure devices
- Proven reliability and ease of deployment

**Office Firewall Sizing:**
- **Lincoln:** Meraki MX95 HA (triple ISP)
- **Omaha:** Meraki MX95 HA (dual ISP)
- **Papillion:** Meraki MX75 (single ISP)
- **West Omaha:** Meraki MX68 (cable modem)
- **Council Bluffs:** Meraki MX68 (cable modem)

**Dual Connectivity:**
- **Site-to-Site VPN to Azure:** Each office has IPsec tunnel to Azure VPN Gateway
- **Meraki Auto VPN:** Offices connected to each other via Auto VPN (for infrastructure)
- **User Traffic:** Users connect via Point-to-Site VPN to Azure (not through Meraki)

**Traffic Flow:**
- **User Endpoints:** Azure Point-to-Site VPN → Azure Firewall → Internet
- **Infrastructure Devices:** Meraki MX → Direct Internet OR Meraki Auto VPN to other offices
- **Office-to-Azure:** Site-to-Site VPN for management traffic, file shares, etc.

---

### Option 2: No Local Firewalls (Pure Azure VPN)

**Alternative:** Eliminate all local firewalls and use only Azure VPN Gateway

**Configuration:**
- No Meraki MX devices at any office
- Users connect via Azure Point-to-Site VPN from devices
- Infrastructure devices connect via Azure Point-to-Site VPN (if supported) or client-based VPN
- Office-to-office communication via Azure hub (hairpin through Azure)

**Pros:**
- Lower hardware costs (no Meraki MX purchases)
- No Meraki licensing costs (~$4,000-9,000/year savings)
- Fully cloud-managed (no on-prem firewall hardware)

**Cons:**
- All devices need VPN client (printers, phones need workarounds)
- No local internet breakout (all traffic hairpins through Azure)
- Increased Azure bandwidth costs
- More complex for infrastructure device connectivity

**Recommendation:** Keep Meraki MX at offices (Option 1) for simplicity and infrastructure device support.

---

## User VPN Strategy

### Azure Point-to-Site VPN (P2S)

**Primary Approach:** Native Azure VPN for all remote users and office-based users

**Client Options:**

**Option A: Azure VPN Client (Recommended)**
- **Platform Support:** Windows 10/11, macOS, Linux, iOS, Android
- **Authentication:** Azure AD with MFA (SSO experience)
- **Always-On:** Supported on Windows (device tunnel + user tunnel)
- **Conditional Access:** Integrate with Azure AD Conditional Access policies
- **Free:** No additional client licensing required

**Option B: Native OS VPN Clients**
- **IKEv2:** Windows, macOS, iOS native VPN clients
- **OpenVPN:** Windows, macOS, Linux, iOS, Android (requires OpenVPN client)
- **Limitation:** No Always-On for IKEv2 on all platforms

**Option C: Always On VPN (Windows)**
- **Device Tunnel:** Connects before user login (for domain authentication)
- **User Tunnel:** Connects when user logs in
- **Deployment:** Via Intune MDM or Group Policy
- **Platform:** Windows 10/11 only
- **Best For:** Domain-joined devices requiring pre-logon connectivity

**Recommended Configuration:**
- **Remote Workers:** Azure VPN Client with Azure AD auth + MFA
- **Office Users:** Always On VPN (Windows) or Azure VPN Client
- **Mobile Devices:** Azure VPN Client (iOS/Android)

**Configuration:**
- **Authentication:** Azure AD (SSO with MFA via Authenticator app)
- **Split Tunneling:** Disabled (all traffic through Azure for security)
- **Conditional Access:** Require MFA, compliant device, specific locations
- **Address Pool:** 10.200.0.0/16 (separate from office subnets)

---

## Security Policy Framework

### Azure Firewall Rules

**Network Rules (Layer 3/4):**
- Allow VPN user subnets → Office subnets (access to file shares, printers)
- Allow VPN user subnets → Internet (all traffic)
- Allow Office subnets → Internet (infrastructure devices)
- Block Office infrastructure VLANs → VPN user subnets (prevent lateral movement)

**Application Rules (Layer 7):**
- **Allow List (FQDN-based):**
  - *.microsoft.com (Microsoft 365)
  - *.office.com, *.office365.com
  - *.westlaw.com, *.lexisnexis.com (legal research)
  - Approved legal software (Clio, NetDocuments, etc.)
  - *.windows.net, *.azure.com (Azure services)

- **Block List (Categories):**
  - Social media (unless needed for business)
  - Gambling, adult content, malware sites
  - File sharing (torrents, P2P)
  - Anonymous proxies, VPNs

**TLS Inspection:**
- **Decrypt and Inspect:**
  - Unknown HTTPS traffic (detect malware, data exfiltration)
  - Cloud storage uploads (inspect for sensitive data)
  - Web downloads (malware detection)

- **Do Not Decrypt:**
  - Financial institutions (banking sites)
  - Healthcare sites (HIPAA concerns)
  - Government sites (.gov, .mil)

**IDPS (Intrusion Detection/Prevention):**
- **Alert Mode:** Log suspicious traffic patterns
- **Alert and Deny Mode:** Block known attack signatures
- **Signature Base:** Microsoft threat intelligence (updated continuously)

---

### Microsoft Defender for Endpoint Policies

**Attack Surface Reduction (ASR) Rules:**
- Block Office applications from creating executable content
- Block execution of obfuscated scripts (PowerShell, VBScript)
- Block credential stealing (lsass.exe access)
- Block untrusted USB processes
- Block Adobe Reader from creating child processes

**Endpoint DLP Policies:**
- **Block:** Upload of files containing client names/case numbers to unauthorized cloud storage
- **Block:** Copy of documents with "Attorney-Client Privileged" to USB drives
- **Warn:** Printing documents with sensitive data
- **Audit:** All file shares from endpoints

**Device Control:**
- Block removable storage (USB) except for approved devices
- Block Bluetooth file transfers
- Allow network printers only (block local printer drivers)

---

### Microsoft Defender for Cloud Apps Policies

**Cloud App Governance:**
- **Sanctioned Apps:** Microsoft 365, approved legal apps
- **Monitored Apps:** Alert on usage but don't block (Zoom, Box, Dropbox)
- **Unsanctioned Apps:** Block (personal cloud storage, unauthorized file sharing)

**Session Policies:**
- **OneDrive for Business:** Allow all access
- **Box/Dropbox (if approved):** Block downloads to unmanaged devices
- **Legal Software:** Monitor file uploads, alert on large data transfers

**Anomaly Detection:**
- Alert on impossible travel (user logs in from two distant locations within short time)
- Alert on mass file downloads (potential data exfiltration)
- Alert on unusual admin activity

---

## Integration with Microsoft 365

### Deep M365 Integration

**Azure AD (Entra ID):**
- **Single Sign-On:** VPN, M365, Azure Portal all use same credentials
- **Conditional Access:** Require MFA for VPN, compliant device for M365
- **Identity Protection:** Risk-based access (block sign-in if account compromised)

**Microsoft 365 Apps:**
- **Email (Exchange Online):** Purview DLP scans outbound emails for sensitive data
- **Files (SharePoint/OneDrive):** DLP prevents sharing of privileged documents
- **Teams:** DLP scans chat messages and file shares
- **Endpoint:** Defender for Endpoint blocks malicious Office macros

**Unified Security Portal:**
- **Microsoft 365 Defender:** Single dashboard for Defender for Endpoint, Cloud Apps, Identity
- **Azure Sentinel:** Aggregates all logs (Azure Firewall, M365, Defender)
- **Compliance Portal:** Purview DLP policies, audit logs, eDiscovery

**Benefits:**
- All Microsoft security products share threat intelligence
- Single incident spans endpoint, cloud apps, email (correlated automatically)
- Unified investigation experience (no need to switch between portals)

---

## Implementation Plan

### Phase 1: Azure Infrastructure Deployment (Weeks 1-3)

**Week 1: Planning and Design**
- [ ] Finalize Azure subscription and resource group structure
- [ ] Design hub VNet architecture (address space, subnets)
- [ ] Plan VPN Gateway and Azure Firewall configuration
- [ ] Review M365 licensing (E5 or E3 + add-ons)
- [ ] Get approval from Berry Law leadership

**Week 2: Azure Core Services Deployment**
- [ ] Create hub VNet with required subnets (GatewaySubnet, AzureFirewallSubnet)
- [ ] Deploy Azure VPN Gateway (VpnGw2AZ or VpnGw3AZ)
- [ ] Deploy Azure Firewall Premium with Availability Zones
- [ ] Configure public IPs and NAT rules
- [ ] Set up Azure Monitor and Log Analytics workspace

**Week 3: Azure Firewall Configuration**
- [ ] Configure network rules (allow VPN → offices, VPN → internet)
- [ ] Configure application rules (FQDN-based allow/deny lists)
- [ ] Enable TLS inspection (deploy root CA certificate)
- [ ] Enable IDPS in Alert and Deny mode
- [ ] Configure threat intelligence feed
- [ ] Test internet egress from test VPN client

---

### Phase 2: Microsoft 365 Security Stack (Weeks 4-5)

**Week 4: Defender for Endpoint Deployment**
- [ ] Onboard devices to Microsoft Defender for Endpoint
- [ ] Configure ASR rules (test mode first)
- [ ] Deploy endpoint DLP policies (audit mode)
- [ ] Test threat detection and automated remediation
- [ ] Pilot with 5-10 users

**Week 5: Defender for Cloud Apps and Purview DLP**
- [ ] Enable Microsoft Defender for Cloud Apps
- [ ] Configure cloud app discovery and risk scoring
- [ ] Create session control policies for sanctioned apps
- [ ] Deploy Purview DLP policies (Exchange, SharePoint, OneDrive, Teams)
- [ ] Create custom sensitive info types (client names, case numbers)
- [ ] Test DLP policies with sample documents

---

### Phase 3: Office Site-to-Site VPN (Weeks 6-8)

**Week 6: Lincoln Office S2S VPN**
- [ ] Pre-configure Meraki MX95 HA pair (or other firewall)
- [ ] Install MX95 HA at Lincoln office
- [ ] Configure site-to-site VPN to Azure VPN Gateway
- [ ] Test VPN tunnel establishment and traffic flow
- [ ] Verify office subnet routing through Azure Firewall
- [ ] Migrate from VMWare Edge to new setup

**Week 7: Omaha Office S2S VPN**
- [ ] Install Meraki MX95 HA at Omaha office
- [ ] Configure site-to-site VPN to Azure VPN Gateway
- [ ] Test VPN tunnel and routing
- [ ] Migrate from VMWare Edge
- [ ] Verify Auto VPN between Lincoln and Omaha (if using Meraki)

**Week 8: Papillion, West Omaha, Council Bluffs S2S VPN**
- [ ] Install Meraki MX75 (Papillion), MX68 (West Omaha, Council Bluffs)
- [ ] Configure site-to-site VPNs to Azure VPN Gateway
- [ ] Test connectivity and routing
- [ ] Decommission existing firewalls (Fortigate 40F, Meraki Z3)

---

### Phase 4: User Point-to-Site VPN (Weeks 9-11)

**Week 9: P2S VPN Configuration and Pilot**
- [ ] Configure Point-to-Site VPN on Azure VPN Gateway
- [ ] Set up Azure AD authentication with MFA
- [ ] Deploy Azure VPN Client to pilot users (5-10)
- [ ] Test connectivity, MFA, and internet access
- [ ] Configure Always On VPN for Windows devices (via Intune)

**Week 10: Full User Rollout (Office Users)**
- [ ] Deploy Azure VPN Client to all office users (Lincoln, Omaha, Papillion)
- [ ] Configure Always On VPN (device + user tunnels)
- [ ] Test domain authentication via VPN
- [ ] Monitor Azure Firewall logs for issues
- [ ] User training and support

**Week 11: Remote User Rollout**
- [ ] Deploy Azure VPN Client to all remote workers
- [ ] Test from home networks, mobile hotspots
- [ ] Configure split tunneling exceptions (if needed for performance)
- [ ] Help desk training for VPN troubleshooting

---

### Phase 5: Security Policy Tuning (Weeks 12-13)

**Week 12: Azure Firewall Policy Refinement**
- [ ] Review 2 weeks of Azure Firewall logs
- [ ] Tune application rules based on actual usage
- [ ] Enable IDPS Alert and Deny mode (if not already)
- [ ] Test TLS inspection with user devices
- [ ] Optimize for Microsoft 365 traffic (direct routing if needed)

**Week 13: DLP and Defender Policies**
- [ ] Review Purview DLP incidents (2 weeks of data)
- [ ] Tune DLP policies (reduce false positives)
- [ ] Enable ASR rules in enforcement mode (from audit mode)
- [ ] Review Defender for Cloud Apps alerts
- [ ] Test end-to-end: user uploads file with client data → DLP blocks

---

### Phase 6: Azure Sentinel and Monitoring (Week 14)

**Week 14: SIEM and Dashboards**
- [ ] Deploy Azure Sentinel and connect data sources
- [ ] Enable built-in analytics rules (suspicious VPN activity, malware detection)
- [ ] Create custom workbooks for Berry Law (VPN usage, DLP incidents, threats)
- [ ] Set up email alerts for high-priority incidents
- [ ] Train Berry Law IT on Sentinel usage (if they have IT staff)

---

### Phase 7: RapidScale Decommissioning and Handoff (Weeks 15-16)

**Week 15: Final Cutover**
- [ ] Verify all users on Azure P2S VPN
- [ ] Verify all offices on Azure S2S VPN
- [ ] Disconnect RapidScale VPN tunnels
- [ ] Cancel RapidScale contract
- [ ] Archive configurations

**Week 16: Training and Documentation**
- [ ] Document Azure architecture (network diagrams, runbooks)
- [ ] Train help desk on Azure VPN Client troubleshooting
- [ ] Provide user documentation
- [ ] Handoff to managed services team
- [ ] Schedule 30-day and 90-day review meetings

**Total Timeline: 16 weeks** (similar to PA hybrid)

---

## Cost Analysis

### Azure Cloud Services (Ongoing Costs)

| Service | Monthly Cost | Annual Cost |
|---------|--------------|-------------|
| **Azure Firewall Premium** | $1,500-3,000 | $18,000-36,000 |
| **Azure VPN Gateway (VpnGw2AZ)** | $375 | $4,500 |
| **Azure Egress Data** (~500 GB/month) | $43 | $520 |
| **Azure Sentinel** (200 GB/month) | $500 | $6,000 |
| **Azure Monitor / Log Analytics** | $100 | $1,200 |
| **Total Azure Infrastructure** | **$2,518-4,018** | **$30,220-48,220** |

### Microsoft 365 Licensing (User-Based)

| License Option | Per User/Month | 50 Users/Month | 50 Users/Year |
|----------------|----------------|----------------|---------------|
| **Microsoft 365 E5** (includes all security) | $57 | $2,850 | $34,200 |
| **Microsoft 365 E3** | $36 | $1,800 | $21,600 |
| **+ E5 Security add-on** | $12 | $600 | $7,200 |
| **+ E5 Compliance add-on (Purview DLP)** | $12 | $600 | $7,200 |
| **E3 + Security + Compliance Total** | $60 | $3,000 | $36,000 |

**Recommendation:** Microsoft 365 E5 for simplicity (includes all security features in one license)

### Meraki MX (If Using Option 1)

| Device | Quantity | Hardware Cost | Annual Licensing |
|--------|----------|---------------|------------------|
| MX95 | 4 (Lincoln HA, Omaha HA) | $11,200 | $3,600 |
| MX75 | 1 (Papillion) | $1,500 | $650 |
| MX68 | 2 (West Omaha, Council Bluffs) | $1,500 | $900 |
| **Total Meraki** | **7 devices** | **$14,200** | **$5,150/year** |
| **3-Year Licensing (prepaid)** | | | **$12,875** |

### Professional Services

| Service | Cost |
|---------|------|
| Design and planning | $12,000-18,000 |
| Azure deployment and configuration | $30,000-45,000 |
| M365 security configuration | $15,000-25,000 |
| Meraki deployment | $10,000-15,000 |
| Training and documentation | $5,000-10,000 |
| **Total Professional Services** | **$72,000-113,000** |

---

## Total Cost Summary (Azure-Native)

### Year 1 Investment

**Option 1: With Meraki MX at Offices**
- Meraki MX hardware: $14,200
- Meraki licensing (3-year prepaid): $12,875
- Azure infrastructure (Year 1): $30,220-48,220
- Microsoft 365 E5 (50 users, Year 1): $34,200
- Professional Services: $72,000-113,000
- **Year 1 Total:** $163,495-222,495

**Option 2: No Local Firewalls (Pure Azure VPN)**
- Azure infrastructure (Year 1): $30,220-48,220
- Microsoft 365 E5 (50 users, Year 1): $34,200
- Professional Services: $62,000-98,000 (no Meraki deployment)
- **Year 1 Total:** $126,420-180,420

### Annual Recurring Costs (Years 2+)

**Option 1: With Meraki MX**
- Azure infrastructure: $30,220-48,220/year
- Microsoft 365 E5 (50 users): $34,200/year
- Meraki licensing (if not prepaid): $5,150/year
- **Total Recurring:** $69,570-87,570/year

**Option 2: Pure Azure VPN**
- Azure infrastructure: $30,220-48,220/year (higher egress costs without Meraki)
- Microsoft 365 E5 (50 users): $34,200/year
- **Total Recurring:** $64,420-82,420/year

### 3-Year Total Cost of Ownership

**Option 1: With Meraki MX**
- Year 1: $163,495-222,495
- Years 2-3: $139,140-175,140 (Meraki prepaid, no annual licensing)
- **3-Year Total:** $302,635-397,635

**Option 2: Pure Azure VPN**
- Year 1: $126,420-180,420
- Years 2-3: $128,840-164,840
- **3-Year Total:** $255,260-345,260

---

## Architecture Comparison: Azure-Native vs. PA Hybrid vs. Meraki-Only

### Side-by-Side Comparison

| Aspect | Azure-Native | PA Hybrid | Meraki-Only |
|--------|--------------|-----------|-------------|
| **Cloud Firewall** | Azure Firewall Premium | Palo Alto VM-Series | None (on-prem hubs) |
| **User VPN** | Azure P2S VPN | GlobalProtect | AnyConnect/Client VPN |
| **Office Firewalls** | Meraki MX (optional) | Meraki MX | Meraki MX (MX250 hubs) |
| **Endpoint Security** | Defender for Endpoint | PA + Defender optional | Meraki + Defender optional |
| **DLP** | Purview DLP | PA DLP + Purview optional | Purview (if M365 E5) |
| **CASB** | Defender for Cloud Apps | PA + Defender optional | Defender (if M365 E5) |
| **TLS Inspection** | Yes (Azure Firewall) | Yes (PA full decrypt) | No |
| **App Control** | FQDN-based | App-ID (5,000+ apps) | Basic (Layer 7) |
| **SIEM** | Azure Sentinel | Panorama + Sentinel | Meraki Dashboard |
| **M365 Integration** | Native (best) | API-based | API-based |
| **Single Vendor** | Microsoft only | Microsoft + PA + Meraki | Cisco only |
| **Management** | Azure Portal + M365 | PA + Azure + Meraki | Meraki Dashboard |

### Cost Comparison (3-Year TCO)

| Architecture | Year 1 | Years 2-3 | 3-Year Total |
|--------------|--------|-----------|--------------|
| **Azure-Native (with Meraki)** | $163K-222K | $139K-175K | **$302K-398K** |
| **PA Hybrid** | $155K-238K | $50K-94K | **$205K-332K** |
| **Meraki-Only** | $105K-125K | $25K-47K | **$125K-165K** |

**Ranking by Cost:**
1. **Meraki-Only:** $125K-165K (cheapest)
2. **PA Hybrid:** $205K-332K (mid-range)
3. **Azure-Native:** $302K-398K (most expensive)

### Security Feature Comparison

| Security Feature | Azure-Native | PA Hybrid | Meraki-Only |
|------------------|--------------|-----------|-------------|
| **SSL/TLS Inspection** | Good (Azure FW) | Excellent (PA) | No |
| **DLP** | Excellent (Purview) | Excellent (PA + Purview) | Good (Purview only if E5) |
| **App Control** | Good (FQDN) | Excellent (App-ID) | Basic |
| **Endpoint Protection** | Excellent (Defender) | Good (PA + optional Defender) | Optional (Defender) |
| **CASB** | Excellent (Defender) | Optional (PA + Defender) | Optional (Defender) |
| **Threat Intelligence** | Excellent (Microsoft) | Excellent (PA Unit 42) | Good (Cisco Talos) |
| **SIEM** | Excellent (Sentinel) | Good (Panorama) | Basic (Dashboard) |
| **M365 Integration** | Excellent (native) | Good (API) | Good (API) |

---

## Recommendation Summary

### When to Choose Azure-Native

**Choose Azure-Native if:**
- **Microsoft 365 E5 is already licensed or planned** (cost-effective to add Azure Firewall)
- **Unified Microsoft stack is desired** (single vendor, single support contract)
- **Deep M365 integration is critical** (unified security portal, shared threat intelligence)
- **No third-party firewall expertise** (all Microsoft, easier to find admins)
- **Long-term Microsoft commitment** (ecosystem lock-in is acceptable)

**Don't Choose Azure-Native if:**
- **Budget is constrained** (~$80K-230K more over 3 years vs. Meraki-only)
- **Advanced App-ID is required** (Azure Firewall FQDN-based vs. PA's comprehensive App-ID)
- **Best-in-class threat prevention is needed** (PA's WildFire and IPS are more advanced)
- **Multi-cloud or vendor diversity preferred** (Azure-Native locks into Microsoft)

### Berry Law Recommendation: Rank by Use Case

**If Budget is Primary Concern:**
1. **Meraki-Only** (~$125K 3-year) + M365 E5 for Purview DLP
2. **PA Hybrid** (~$205K 3-year)
3. Azure-Native (~$302K 3-year)

**If Security is Primary Concern:**
1. **PA Hybrid** (best threat prevention, App-ID, DLP)
2. **Azure-Native** (excellent with M365 integration)
3. Meraki-Only (adequate with M365 E5 add-ons)

**If Simplicity/Microsoft Ecosystem is Primary:**
1. **Azure-Native** (all Microsoft, unified portal)
2. Meraki-Only (single Meraki dashboard)
3. PA Hybrid (three vendors to manage)

**Our Primary Recommendation for Berry Law:**
**Palo Alto Hybrid** remains the best balance of security, compliance, and cost for a law firm handling attorney-client privileged information. Azure-Native is a strong alternative if they're already committed to Microsoft 365 E5.

---

## Appendix A: Azure Firewall vs. Palo Alto Feature Matrix

| Feature | Azure Firewall Premium | Palo Alto VM-Series | Winner |
|---------|----------------------|---------------------|--------|
| **TLS Inspection** | Yes (decrypt/inspect) | Yes (full SSL decrypt) | Tie |
| **IDPS** | Signature-based | Signature + behavioral | **PA** |
| **App Control** | FQDN-based (Layer 7) | App-ID (5,000+ apps) | **PA** |
| **DLP** | No (requires Purview) | Yes (content inspection) | **PA** |
| **Threat Intelligence** | Microsoft | Palo Alto Unit 42 | Tie |
| **URL Filtering** | Category-based | Category + reputation | Tie |
| **Cloud Sandboxing** | No | Yes (WildFire) | **PA** |
| **Management** | Azure Portal | Panorama | **Azure** |
| **M365 Integration** | Native | API-based | **Azure** |
| **PaaS vs. IaaS** | PaaS (managed) | IaaS (customer managed) | **Azure** |
| **Pricing** | $1.5K-3K/month | $3K-8K/month | **Azure** |

**Overall:** Palo Alto has superior threat prevention and app control. Azure Firewall wins on M365 integration and operational simplicity.

---

## Appendix B: Microsoft 365 E5 Security Features

**Microsoft 365 E5 includes:**
- Microsoft Defender for Endpoint (EDR)
- Microsoft Defender for Office 365 P2 (email security)
- Microsoft Defender for Identity (UEBA)
- Microsoft Defender for Cloud Apps (CASB)
- Microsoft Purview DLP (data loss prevention)
- Microsoft Purview Information Protection (sensitivity labels)
- Azure AD Premium P2 (Conditional Access, Identity Protection)
- Microsoft Intune (MDM/MAM)
- Azure Information Protection (encryption)
- Advanced Audit (1-year retention)

**Why E5 Makes Sense for Azure-Native:**
- All security features in one license (~$57/user/month)
- Unified security portal (Microsoft 365 Defender)
- Shared threat intelligence across all products
- No need to license Defender separately

**Alternative: E3 + Add-ons**
- M365 E3 ($36/user) + E5 Security ($12/user) + E5 Compliance ($12/user) = $60/user
- Same features as E5 but slightly more expensive
- Only makes sense if E3 is already licensed

---

## Document Control

**Document Owner:** Midwest Cloud Computing - Technical Team
**Approvals Required:**
- [ ] Berry Law - Executive Approval
- [ ] Berry Law - Technical Contact Review
- [ ] Midwest Cloud Computing - Project Manager Approval

**Revision History:**
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-20 | Claude | Initial document creation |

---

**END OF DOCUMENT**
