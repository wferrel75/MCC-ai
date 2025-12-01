# Berry Law - Palo Alto Cloud with Meraki Local Firewall Migration Plan
## Midwest Cloud Computing - Hybrid Network Architecture Design

**Document Version:** 1.0
**Created:** November 20, 2025
**Customer:** Berry Law (John S. Berry Law, PC)
**Project:** RapidScale/VMWare to Palo Alto Azure + Meraki Local Architecture

---

## Executive Summary

This document outlines an alternative hybrid migration plan to replace Berry Law's current RapidScale cloud hub and VMWare edge appliances with a dual-vendor architecture: **Palo Alto Networks in Azure for centralized user security** and **Cisco Meraki MX firewalls at each office for local infrastructure protection**.

This hybrid approach provides:
- **Centralized user security** through Azure PA firewall and GlobalProtect VPN
- **Local infrastructure protection** for printers, phones, IoT devices, servers via Meraki
- **Simplified management** through Meraki cloud dashboard for office infrastructure
- **Best-of-breed** security for users while maintaining simple, reliable local networking

**Key Differences from Pure Palo Alto Design:**
- User endpoints (workstations, laptops) connect via GlobalProtect VPN to Azure PA firewall
- Non-user devices (printers, phones, cameras, IoT) route through local Meraki MX firewalls
- Meraki Auto VPN provides site-to-site connectivity between offices
- Dual-path architecture: PA for users, Meraki for infrastructure

---

## Architecture Philosophy

### Separation of Concerns

**User Traffic Path (via Palo Alto):**
- All user workstations and laptops connect via GlobalProtect VPN to Azure PA firewall
- Internet traffic from users inspected by PA (SSL inspection, App-ID, threat prevention, DLP)
- Centralized security policy enforcement for all users regardless of location
- Meets attorney-client privilege requirements with DLP and encrypted transport

**Infrastructure Traffic Path (via Meraki):**
- Printers, IP phones, security cameras, IoT devices route through local Meraki MX
- Site-to-site connectivity via Meraki Auto VPN (office-to-office communication)
- Local internet breakout for infrastructure devices (no need for centralized inspection)
- Simple, reliable connectivity for non-user endpoints

**Why This Hybrid Approach:**
1. **User security is critical** - Attorneys and staff handle sensitive client data requiring advanced threat protection and DLP
2. **Infrastructure is low-risk** - Printers and phones don't access sensitive data or risky websites
3. **Simplified management** - Meraki cloud dashboard is easy to manage for office infrastructure
4. **Cost optimization** - Right-sized security for each device class
5. **Reliability** - Local Meraki provides redundancy if GlobalProtect has issues
6. **Best of both worlds** - PA advanced security + Meraki simplicity

---

## Current State Architecture

### Existing Infrastructure
```yaml
Current Hub:
  Provider: RapidScale Cloud
  Device: Fortigate Virtual Firewall
  Function: Central hub for SD-WAN mesh
  Connectivity: VPN tunnels to Omaha and Lincoln

Current Edge Devices:
  Omaha:
    Device: VMWare Edge Pair
    ISPs: Cox Fiber (1 Gbps) + UPN Fiber (1 Gbps)
    Connectivity: SD-WAN VPN to RapidScale
    Switches: OMA-SW-01, OMA-SW-02

  Lincoln:
    Device: VMWare Edge Pair
    ISPs: Cox Fiber (1 Gbps) + UPN Fiber (1 Gbps) + Allo Fiber (1 Gbps)
    Connectivity: SD-WAN VPN to RapidScale
    Switches: LNK-SW-01, LNK-SW-02, LNK-SW-03

  Papillion:
    Device: Fortigate 40F
    ISPs: Cox Fiber (1 Gbps)
    Connectivity: Direct Internet (no VPN tunnel)
    Switches: OMA-SW-02

  West Omaha:
    Device: Unknown/TBD
    ISPs: Cox Cable Modem (speed TBD)
    Connectivity: Direct Internet

  Council Bluffs:
    Device: Meraki Z3
    ISPs: Cox Cable Modem (speed TBD)
    Connectivity: Direct Internet
```

---

## Proposed Hybrid Architecture

### Design Overview

**Dual-Path Architecture:**
```
                    ┌─────────────────────────────────┐
                    │   Microsoft Azure (Central)     │
                    │                                 │
                    │  ┌───────────────────────────┐ │
                    │  │  Palo Alto VM-Series      │ │
                    │  │  User Security Gateway    │ │
                    │  │  - GlobalProtect VPN      │ │
                    │  │  - SSL Inspection         │ │
                    │  │  - App-ID & DLP           │ │
                    │  └───────────────────────────┘ │
                    │                                 │
                    └─────────────────────────────────┘
                                 │
                    GlobalProtect VPN (All Users)
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
   ┌────▼─────┐            ┌────▼─────┐            ┌────▼─────┐
   │  Omaha   │            │ Lincoln  │            │Papillion │
   │ Meraki   │◄──────────►│ Meraki   │◄──────────►│ Meraki   │
   │ MX95 (HA)│  Auto VPN  │ MX85/95  │  Auto VPN  │ MX75     │
   └──────────┘            └──────────┘            └──────────┘
        │                        │                        │
   ┌────▼─────┐            ┌────▼─────┐            ┌────▼─────┐
   │ Infra    │            │ Infra    │            │ Infra    │
   │ Devices  │            │ Devices  │            │ Devices  │
   │ (printers│            │ (printers│            │ (printers│
   │  phones) │            │  phones) │            │  phones) │
   └──────────┘            └──────────┘            └──────────┘

        ┌─────────────┐            ┌─────────────┐
        │ West Omaha  │            │Council Bluffs│
        │ Meraki MX68 │◄──────────►│ Meraki MX68 │
        │             │  Auto VPN  │             │
        └─────────────┘            └─────────────┘
              │                          │
        ┌─────▼─────┐            ┌─────▼─────┐
        │ Infra     │            │ Infra     │
        │ Devices   │            │ Devices   │
        └───────────┘            └───────────┘

   ┌──────────────────────────────────────────┐
   │ ALL User Endpoints (Workstations/Laptops)│
   │ Connect via GlobalProtect VPN to Azure   │
   │ regardless of office location            │
   └──────────────────────────────────────────┘
```

### Traffic Flow Examples

**Example 1: Attorney's Laptop in Omaha Office**
```
Attorney Laptop (Omaha)
  ↓ GlobalProtect VPN Tunnel
Azure PA Firewall (SSL Inspect, App-ID, DLP)
  ↓ Internet Access
External Website / Cloud App

Local network access (file server):
  ↓ GlobalProtect Tunnel
Azure PA Firewall
  ↓ Meraki Auto VPN
Omaha Meraki MX → Internal Server
```

**Example 2: Printer in Lincoln Office**
```
Printer (Lincoln)
  ↓ Local LAN
Lincoln Meraki MX (basic security)
  ↓ Direct Internet or Local Route
Internet / Local Resource (no PA inspection needed)

Printer-to-Printer communication (Lincoln to Omaha):
  ↓ Meraki Auto VPN
Omaha Meraki MX → Printer
```

**Example 3: Remote User Working from Home**
```
Remote User Laptop
  ↓ GlobalProtect VPN Tunnel
Azure PA Firewall (full security stack)
  ↓ Internet or Office Resource Access
Cloud App / Office Server

(No interaction with Meraki - direct to PA)
```

### Why Dual-Path Architecture?

**User Devices Need Advanced Security:**
- SSL inspection to detect data exfiltration
- App-ID to control cloud applications
- DLP to protect attorney-client privileged information
- URL filtering and threat prevention
- Visibility into user behavior

**Infrastructure Devices Are Low-Risk:**
- Printers don't browse the web or download malware
- IP phones have fixed communication patterns
- Security cameras stream to local NVR/cloud service
- IoT devices have predictable traffic
- Don't handle sensitive client data directly

**Operational Benefits:**
- Meraki dashboard simplifies management of office infrastructure
- Local breakout for printers/phones reduces VPN overhead
- Site-to-site connectivity via Meraki Auto VPN (zero-touch)
- Users get advanced PA security regardless of location
- Clear separation between user security (complex) and infrastructure (simple)

---

## Azure Cloud Firewall (Palo Alto VM-Series)

### Function: User Security Gateway

**Primary Role:** Centralized security enforcement for ALL user endpoints across all locations and remote workers.

**Palo Alto VM-Series Deployment:**
- **Model:** VM-Series (VM-300 or VM-500)
- **Deployment:** Azure Virtual Network with public and private subnets
- **Redundancy:** Active/Passive HA pair across Azure Availability Zones
- **Licensing:** Bundle 2 (Threat Prevention + WildFire + URL Filtering + GlobalProtect)
- **Throughput:** 2-4 Gbps (VM-300) or 4-6 Gbps (VM-500) based on user count

**Azure Infrastructure:**
- **Region:** US Central (minimal latency to Nebraska/Iowa)
- **VNet:** /24 subnet for firewall HA pair
- **Public IPs:** 2x static public IPs (one per firewall for HA)
- **Storage:** Azure managed disks for logs and WildFire analysis

**Functions:**
- **GlobalProtect VPN Gateway** for all user workstations and laptops
- **SSL/TLS Inspection** for encrypted user traffic
- **App-ID** for cloud application visibility and control
- **DLP** for attorney-client privilege protection
- **Threat Prevention** (IPS, anti-malware, WildFire)
- **URL Filtering** and DNS Security
- **Centralized Logging** to Panorama or Azure Log Analytics

**What Does NOT Route Through PA:**
- Infrastructure device traffic (printers, phones, cameras)
- Site-to-site traffic between offices (uses Meraki Auto VPN)
- Local LAN traffic within an office

---

## Meraki MX Firewall Sizing by Office

### Architecture Principles for Meraki Deployment

**Meraki MX Role:**
1. **Primary Gateway** for each office's local network
2. **Infrastructure Device Protection** (printers, phones, cameras, IoT)
3. **Site-to-Site Connectivity** via Meraki Auto VPN (automatic mesh)
4. **Dual WAN/ISP Management** with automatic failover
5. **Local Internet Breakout** for infrastructure devices
6. **Stateful Firewall** and basic threat protection for non-user devices

**Meraki MX Does NOT Handle:**
- User endpoint security (users connect via GlobalProtect to PA)
- Advanced threat prevention (PA handles user traffic)
- SSL inspection (PA handles user traffic)
- DLP (PA handles user traffic)

---

### Omaha Office (Primary Location)
**Recommended Model:** MX95 (Warm Spare HA)

**Justification:**
- Primary office with ~15-20 users (estimated)
- Dual ISP (Cox Fiber 1 Gbps + UPN Fiber 1 Gbps)
- Requires HA for business continuity (24/7 operations)
- Infrastructure devices: printers, copiers, IP phones, security cameras
- Auto VPN hub for other offices to connect

**Specifications:**
- **Model:** MX95 (Primary) + MX95 (Warm Spare)
- **Throughput:** 500 Mbps stateful firewall, 450 Mbps VPN throughput
- **Site-to-Site VPN Peers:** 250 (sufficient for all offices)
- **WAN Interfaces:** 2x 1GbE (Cox Fiber + UPN Fiber)
- **LAN Interfaces:** 8x 1GbE (connect to switches)
- **Licensing:** Cisco Meraki Advanced Security (per year, per device)
- **Deployment:** Active/Warm Spare HA (automatic failover)

**Configuration:**
- WAN1: Cox Fiber (1 Gbps) - Primary
- WAN2: UPN Fiber (1 Gbps) - Secondary
- LAN: Connected to OMA-SW-01, OMA-SW-02
- Auto VPN: Enabled (hub mode for mesh topology)
- VLAN Configuration:
  - VLAN 10: Infrastructure devices (printers, phones) - routes through Meraki
  - VLAN 20: User workstations - routes through GlobalProtect VPN to PA
  - VLAN 30: Guest WiFi - direct internet through Meraki
- Traffic Routing:
  - Infrastructure VLAN → Direct internet via Meraki MX
  - User VLAN → Forced to GlobalProtect VPN (firewall rule blocks direct internet)
  - Site-to-site traffic → Meraki Auto VPN

**Infrastructure Devices Estimated:**
- 3-5 printers/copiers
- 15-20 IP phones (VoIP)
- 5-10 security cameras
- 2-3 servers (file, print, etc.)

---

### Lincoln Office (Primary Location)
**Recommended Model:** MX95 (Single) or MX85 (Single)

**Justification:**
- Primary office with ~10-15 users (estimated)
- Triple ISP redundancy (Cox + UPN + Allo, all 1 Gbps fiber)
- Infrastructure devices: printers, IP phones, cameras
- Excellent ISP redundancy reduces need for MX HA
- Auto VPN spoke to Omaha and other offices

**Specifications:**
- **Model:** MX95 (if budget allows) or MX85 (cost-effective)
- **Throughput:**
  - MX95: 500 Mbps stateful firewall, 450 Mbps VPN
  - MX85: 450 Mbps stateful firewall, 400 Mbps VPN
- **WAN Interfaces:**
  - MX95: 2x 1GbE WAN + 8x 1GbE LAN
  - MX85: 2x 1GbE WAN + 12x 1GbE LAN (more LAN ports!)
- **Licensing:** Cisco Meraki Advanced Security (per year)
- **Deployment:** Single unit (triple ISP redundancy provides excellent uptime)

**Configuration:**
- WAN1: Cox Fiber (1 Gbps) - Primary
- WAN2: UPN Fiber (1 Gbps) - Secondary
- USB/Cellular: Allo Fiber (1 Gbps) via USB-to-Ethernet adapter OR configure as static route
  - **Note:** MX has only 2 WAN ports; 3rd ISP requires workaround (load balancing switch or USB adapter)
  - **Alternative:** Use Allo as backup via failover switch upstream of MX
- LAN: Connected to LNK-SW-01, LNK-SW-02, LNK-SW-03
- Auto VPN: Enabled (spoke mode)
- VLAN Configuration:
  - VLAN 10: Infrastructure devices - routes through Meraki
  - VLAN 20: User workstations - routes through GlobalProtect VPN
  - VLAN 30: Guest WiFi - direct internet through Meraki
- Traffic Routing:
  - Infrastructure VLAN → Direct internet via Meraki MX
  - User VLAN → Forced to GlobalProtect VPN
  - Site-to-site → Meraki Auto VPN

**Infrastructure Devices Estimated:**
- 2-4 printers/copiers
- 10-15 IP phones
- 5-10 security cameras
- 1-2 servers

**Note on Triple ISP:**
- MX supports only 2 WAN ports natively
- Option 1: Use 2 ISPs on MX (Cox + UPN), keep Allo as manual backup
- Option 2: Deploy load-balancing switch upstream (Peplink Balance, etc.) to aggregate 3 ISPs into 2 feeds
- Option 3: Use 2 ISPs and accept loss of 3rd ISP benefit
- **Recommendation:** Use Cox (WAN1) and UPN (WAN2), keep Allo as cold spare or use for guest WiFi

---

### Papillion Office (Branch Location)
**Recommended Model:** MX75 (Single Unit)

**Justification:**
- Branch office with ~5-8 users (estimated)
- Single ISP (Cox Fiber 1 Gbps)
- Infrastructure devices: printer, phones, camera(s)
- Cost-effective branch office solution
- Auto VPN spoke to Omaha and Lincoln

**Specifications:**
- **Model:** MX75
- **Throughput:** 350 Mbps stateful firewall, 300 Mbps VPN
- **WAN Interfaces:** 2x 1GbE (only 1 ISP, 2nd port available for future)
- **LAN Interfaces:** 12x 1GbE
- **Licensing:** Cisco Meraki Advanced Security (per year)
- **Deployment:** Single unit (no HA - cost optimization)

**Configuration:**
- WAN1: Cox Fiber (1 Gbps)
- WAN2: Unused (available for 2nd ISP if added later)
- LAN: Connected to OMA-SW-02 (Papillion switch)
- Auto VPN: Enabled (spoke mode)
- VLAN Configuration:
  - VLAN 10: Infrastructure devices - routes through Meraki
  - VLAN 20: User workstations - routes through GlobalProtect VPN
  - VLAN 30: Guest WiFi (if needed) - direct internet
- Traffic Routing:
  - Infrastructure VLAN → Direct internet via Meraki MX
  - User VLAN → Forced to GlobalProtect VPN
  - Site-to-site → Meraki Auto VPN

**Infrastructure Devices Estimated:**
- 1-2 printers
- 5-8 IP phones
- 2-5 security cameras

---

### West Omaha Office (Small Branch)
**Recommended Model:** MX68 (Single Unit)

**Justification:**
- Small branch office with ~2-5 users (estimated)
- Cox Cable Modem (asymmetric, lower-tier service)
- Minimal infrastructure devices
- Cost-effective small office solution
- Auto VPN spoke for site-to-site connectivity

**Specifications:**
- **Model:** MX68
- **Throughput:** 250 Mbps stateful firewall, 200 Mbps VPN
- **WAN Interfaces:** 2x 1GbE (only 1 ISP, 2nd port available)
- **LAN Interfaces:** 12x 1GbE (PoE+ available on MX68W model)
- **Licensing:** Cisco Meraki Advanced Security (per year)
- **Deployment:** Single unit

**Configuration:**
- WAN1: Cox Cable Modem (speed TBD, typically 100-500 Mbps down)
- WAN2: Unused (available for 2nd ISP if upgraded)
- LAN: Connect workstations, printer, phones directly or via small switch
- Auto VPN: Enabled (spoke mode)
- VLAN Configuration:
  - VLAN 10: Infrastructure devices - routes through Meraki
  - VLAN 20: User workstations - routes through GlobalProtect VPN
- Traffic Routing:
  - Infrastructure VLAN → Direct internet via Meraki MX
  - User VLAN → Forced to GlobalProtect VPN
  - Site-to-site → Meraki Auto VPN

**Infrastructure Devices Estimated:**
- 1 printer
- 2-5 IP phones
- 0-2 security cameras

**Benefits of Meraki vs. Pure GlobalProtect:**
- Local infrastructure devices don't require VPN client
- Provides site-to-site connectivity for office resources
- Simple cloud management
- Cost-effective for small office

---

### Council Bluffs Office (Small Branch - Iowa)
**Recommended Model:** MX68 (Single Unit)

**Justification:**
- Small Iowa branch office with ~2-5 users (estimated)
- Cox Cable Modem (asymmetric, lower-tier service)
- Currently has Meraki Z3 (upgrade to MX68)
- Minimal infrastructure devices
- Auto VPN spoke for site-to-site connectivity

**Specifications:**
- **Model:** MX68 (upgrade from Z3)
- **Throughput:** 250 Mbps stateful firewall, 200 Mbps VPN
- **WAN Interfaces:** 2x 1GbE (only 1 ISP)
- **LAN Interfaces:** 12x 1GbE (more ports than Z3)
- **Licensing:** Cisco Meraki Advanced Security (per year)
- **Deployment:** Single unit

**Configuration:**
- WAN1: Cox Cable Modem
- WAN2: Unused (available for LTE backup or 2nd ISP)
- LAN: Connect workstations, printer, phones directly (no switches needed)
- Auto VPN: Enabled (spoke mode)
- VLAN Configuration:
  - VLAN 10: Infrastructure devices - routes through Meraki
  - VLAN 20: User workstations - routes through GlobalProtect VPN
- Traffic Routing:
  - Infrastructure VLAN → Direct internet via Meraki MX
  - User VLAN → Forced to GlobalProtect VPN
  - Site-to-site → Meraki Auto VPN

**Infrastructure Devices Estimated:**
- 1 printer
- 2-5 IP phones
- 0-2 security cameras

**Upgrade from Z3:**
- Z3 has only 1 LAN port (all devices share), MX68 has 12 ports
- Z3 is cloud-managed but has limited throughput (50 Mbps VPN)
- MX68 provides 200 Mbps VPN throughput (4x improvement)
- MX68 has more advanced security features

---

## Meraki Auto VPN Architecture

### Zero-Touch Site-to-Site VPN

**Meraki Auto VPN Benefits:**
1. **Zero Configuration:** VPN tunnels establish automatically when MX devices check into Meraki cloud
2. **Full Mesh Topology:** Every office can communicate with every other office
3. **Dynamic Routing:** MX devices exchange routes automatically
4. **Automatic Failover:** If primary tunnel fails, traffic reroutes automatically
5. **Cloud Management:** Configure all VPN settings from Meraki dashboard

**Auto VPN Topology:**
```
         Omaha MX95 (Hub/Spoke)
         /    |    \    \
        /     |     \    \
    Lincoln  Pap   West  Council
    MX95/85  MX75  MX68  MX68

All offices have direct Auto VPN tunnels to each other (full mesh)
```

**How Auto VPN Works:**
1. Each MX device connects to Meraki cloud upon installation
2. Administrator configures "Auto VPN" mode in Meraki dashboard
3. MX devices automatically discover each other and establish IPsec tunnels
4. Dynamic routing (OSPF or static) exchanges network routes
5. Traffic between offices flows through Auto VPN tunnels automatically

**Use Cases for Auto VPN:**
- File server access between offices (e.g., Lincoln user accessing Omaha file server)
- Printer access from remote office
- IP phone system traffic (if centralized phone server)
- Security camera access (NVR in one location, cameras in multiple)
- Infrastructure device management from any location

**What Doesn't Use Auto VPN:**
- User endpoint internet traffic (goes through GlobalProtect to PA)
- User endpoint cloud app access (goes through GlobalProtect to PA)
- Infrastructure device internet access (direct through local MX)

---

## GlobalProtect VPN Strategy (User Endpoints)

### All Users Connect via GlobalProtect

**Target Devices:**
- All attorney workstations (desktops and laptops)
- All staff workstations (desktops and laptops)
- Remote workers
- BYOD devices (if permitted by policy)

**GlobalProtect Configuration:**
- **VPN Gateway:** Azure PA-Series firewall
- **Connection Mode:** Always-On (automatic, no user intervention)
- **Split Tunnel:** Disabled - all user traffic routes through PA for security
- **Authentication:** Azure AD with MFA (Microsoft Authenticator or hardware token)
- **Pre-Logon VPN:** Enabled for Windows domain-joined devices
- **Client OS Support:** Windows, macOS, iOS, Android

**Why Always-On VPN for Users:**
1. **Consistent Security:** All users get same security policies regardless of location
2. **Attorney-Client Privilege:** All user communications are encrypted and monitored for DLP
3. **Cloud App Control:** App-ID and URL filtering enforced for all users
4. **Threat Prevention:** SSL inspection, IPS, anti-malware for all user traffic
5. **Compliance:** Meets Nebraska and Iowa bar confidentiality requirements

**User Experience:**
- VPN connects automatically when device boots (pre-logon)
- Users never manually connect/disconnect VPN
- Transparent experience - users don't realize VPN is active
- Automatic reconnection if tunnel drops
- Fast roaming between networks (office WiFi, home, cellular)

---

## VLAN and Routing Strategy

### Network Segmentation per Office

Each office implements VLAN segmentation to separate user endpoints from infrastructure devices and enforce routing policies.

**Standard VLAN Design (All Offices):**

```yaml
VLAN 10 - Infrastructure:
  Description: Printers, IP phones, cameras, servers, IoT
  Subnet Example: 10.100.10.0/24
  Default Gateway: Meraki MX
  Internet Access: Direct through Meraki MX (no PA)
  Site-to-Site: Via Meraki Auto VPN
  Security: Meraki stateful firewall, basic threat protection

VLAN 20 - User Workstations:
  Description: Attorney and staff desktops and laptops
  Subnet Example: 10.100.20.0/24
  Default Gateway: Meraki MX (but internet is blocked)
  Internet Access: BLOCKED by Meraki firewall rule
  VPN Access: GlobalProtect to Azure PA firewall (REQUIRED)
  Security: Full PA security stack (SSL inspect, App-ID, DLP, threat prevention)

VLAN 30 - Guest WiFi:
  Description: Visitor wireless access
  Subnet Example: 10.100.30.0/24
  Default Gateway: Meraki MX
  Internet Access: Direct through Meraki MX (no PA)
  Isolation: No access to VLAN 10 or VLAN 20
  Security: Meraki stateful firewall, URL filtering
```

### Enforcing User VPN Usage

**Meraki MX Firewall Rules (User VLAN 20):**
```
Priority 1: DENY - Source VLAN 20 → Destination Internet (any) - Block all direct internet
Priority 2: ALLOW - Source VLAN 20 → Destination Azure PA Public IP (UDP 443, ESP, IKE) - Allow GlobalProtect VPN
Priority 3: ALLOW - Source VLAN 20 → Destination Local VLANs (for local resources)
Priority 4: DENY ALL (implicit)
```

**Result:** User workstations cannot access internet unless GlobalProtect VPN is connected.

**Benefits:**
- Forces all user traffic through PA for security
- Prevents users from bypassing VPN
- Ensures compliance with attorney-client privilege requirements
- Provides centralized visibility and control

### Infrastructure Device Routing

**Meraki MX Routing for Infrastructure VLAN 10:**
- Default route → Internet via WAN1 (primary ISP)
- Failover → Internet via WAN2 (secondary ISP, if configured)
- Site-to-site routes → Meraki Auto VPN tunnels to other offices

**Example: Printer in Omaha needs to access internet for firmware updates**
```
Printer (VLAN 10, Omaha)
  → Omaha MX95 (default gateway)
  → WAN1 (Cox Fiber) → Internet

No PA inspection, no GlobalProtect - simple direct internet access
```

**Example: Security camera in Lincoln needs to upload to cloud NVR**
```
Security Camera (VLAN 10, Lincoln)
  → Lincoln MX95/85 (default gateway)
  → WAN1 (Cox Fiber) → Cloud NVR Service

Direct internet access, no PA involvement
```

---

## Cloud Application Traffic Management

### Centralized User Traffic Control via PA

The Azure PA firewall enforces security policies for all user endpoint traffic.

#### App-ID and SaaS Application Control

**Visibility (User Traffic Only):**
- **App-ID Technology:** Identifies 5,000+ cloud applications
- **SaaS Security:** Visibility into Office 365, legal apps, cloud storage
- **Shadow IT Detection:** Identifies unauthorized apps being used by attorneys/staff
- **Cloud App Usage Reports:** Track which SaaS apps are used and by whom

**Control Policies:**

**Approved Applications (Allow with Inspection):**
- Microsoft 365 (Exchange, SharePoint, Teams, OneDrive)
- Legal practice management (Clio, MyCase, PracticePanther)
- Document management (NetDocuments, iManage)
- Legal research (Westlaw, LexisNexis)
- Authorized cloud storage (OneDrive for Business)
- Video conferencing (Teams, Zoom if approved)

**Blocked Applications:**
- Unauthorized cloud storage (personal Dropbox, Google Drive, Box)
- Peer-to-peer file sharing
- Anonymous proxies and VPNs
- Torrents and file-sharing
- High-risk applications

**Controlled Applications:**
- Social media (LinkedIn for business only, block Facebook/Twitter)
- Personal webmail (block Gmail, Yahoo personal accounts)
- Consumer cloud apps (require approval)

#### SSL/TLS Inspection (User Traffic)

**Decryption Policy:**
- **Decrypt and Inspect:** Office 365 traffic for DLP and threat inspection
- **Decrypt and Inspect:** Unknown SSL traffic to identify applications
- **Decrypt and Inspect:** SaaS applications to enforce DLP policies
- **Do Not Decrypt:** Healthcare, financial sites (HIPAA, PCI-DSS concerns)
- **Do Not Decrypt:** Government sites (.gov, .mil)

**Benefits:**
- Visibility into 90%+ of user internet traffic (HTTPS everywhere)
- DLP enforcement for attorney-client privileged information in cloud apps
- Malware detection in encrypted streams
- Block data exfiltration attempts via SSL

#### Data Loss Prevention (DLP)

**Attorney-Client Privilege Protection:**
- **DLP Policies:** Prevent sensitive client information from unauthorized cloud uploads
- **Content Inspection:** Scan files being uploaded for PII, case numbers, client names
- **Block Actions:** Block uploads to unauthorized cloud apps (personal Dropbox, etc.)
- **Alert Actions:** Alert security team on suspicious data exfiltration
- **Compliance:** Meet Nebraska and Iowa state bar confidentiality requirements

**DLP Integration:**
- Palo Alto DLP profiles
- Integration with Microsoft Purview DLP (if in use)
- Custom data patterns for legal case information (case numbers, client names)

#### Office 365 Optimization

**Microsoft 365 Traffic Handling:**
- **App-ID Recognition:** Automatic identification of M365 services
- **URL Filtering:** Categorize M365 domains as business-approved
- **QoS Policies:** Prioritize Teams real-time media (voice, video)
- **Selective Decryption:** Decrypt for DLP, bypass for real-time media (performance)
- **Direct Routing:** Efficient routing from Azure PA to Microsoft 365 (same Azure region)

**Office 365 Categories:**
- Exchange Online (email, calendaring)
- SharePoint Online (document collaboration)
- OneDrive for Business (file storage)
- Microsoft Teams (chat, meetings, calling)
- Power Platform (Power Apps, Power Automate)

---

## Infrastructure Device Security (Meraki)

### Local Threat Protection for Non-User Devices

While user endpoints get advanced PA security, infrastructure devices receive basic protection from Meraki MX.

**Meraki Advanced Security Features:**
- **Stateful Firewall:** Layer 3/4 firewall with session tracking
- **Intrusion Detection/Prevention (IDS/IPS):** Snort-based signature detection
- **Content Filtering:** URL filtering for web access (if devices browse web)
- **Anti-Malware:** Basic malware scanning for file downloads
- **Application Control:** Block unwanted applications (P2P, etc.)

**Why Basic Security is Sufficient for Infrastructure:**
1. **Limited Attack Surface:** Printers/phones don't browse risky websites
2. **Predictable Traffic:** IoT devices have fixed communication patterns
3. **No Sensitive Data Handling:** Printers don't directly access client files (users print via secure method)
4. **Cost-Effective:** Avoids overhead of inspecting printer firmware updates through PA

**Security Posture:**
- Infrastructure devices are lower-value targets
- Basic threat prevention is adequate
- Focus advanced security budget on user endpoints (where data exfiltration occurs)

---

## Implementation Plan

### Phase 1: Planning and Preparation (Weeks 1-3)

**Week 1: Assessment and Design Finalization**
- [ ] Conduct detailed user count per office (for GlobalProtect licensing)
- [ ] Conduct detailed infrastructure device count per office (printers, phones, cameras)
- [ ] Document current VLANs, subnets, IP addressing
- [ ] Map all cloud applications in use (SaaS discovery)
- [ ] Finalize Meraki MX sizing per office
- [ ] Determine Azure PA VM-Series size (VM-300 vs VM-500)
- [ ] Review VLAN design with Berry Law IT (if any)
- [ ] Get approval from Berry Law leadership

**Week 2: Procurement and Licensing**
- [ ] Order Palo Alto Azure VM-Series license:
  - VM-300 or VM-500 license (BYOL or PAYG)
  - Bundle 2 subscription (Threat Prevention + WildFire + URL Filtering)
  - GlobalProtect Gateway license (50-100 users)
- [ ] Order Meraki MX firewalls:
  - 2x MX95 (Omaha HA pair)
  - 1x MX95 or MX85 (Lincoln)
  - 1x MX75 (Papillion)
  - 1x MX68 (West Omaha)
  - 1x MX68 (Council Bluffs - replace Z3)
- [ ] Purchase Meraki licensing (Advanced Security, per year):
  - 3-year or 5-year license (discounted vs annual)
  - All MX devices
- [ ] Provision Azure infrastructure:
  - Azure subscription
  - VNet and subnets
  - Public IP addresses
  - Storage for logging
- [ ] Set up Meraki dashboard organization

**Week 3: Lab Testing and Configuration Preparation**
- [ ] Build lab environment for testing
- [ ] Test GlobalProtect always-on VPN configuration
- [ ] Test Meraki Auto VPN with 2 MX devices
- [ ] Test VLAN routing enforcement (user VLAN blocks direct internet)
- [ ] Document configuration templates for all MX devices
- [ ] Prepare GlobalProtect client packages
- [ ] Create security policy templates for PA
- [ ] Schedule maintenance windows with Berry Law

---

### Phase 2: Azure Cloud Firewall Deployment (Weeks 4-5)

**Week 4: Azure Infrastructure and PA Firewall Deployment**
- [ ] Deploy Azure VNet and configure subnets
- [ ] Deploy PA VM-Series firewall pair (Active/Passive HA)
- [ ] Configure basic firewall settings (interfaces, zones, routing)
- [ ] Configure public IP addresses and NAT policies
- [ ] Set up HA between firewall pair
- [ ] Configure basic security policies for testing
- [ ] Set up logging to Panorama or Azure Log Analytics

**Week 5: GlobalProtect VPN Gateway Configuration**
- [ ] Configure GlobalProtect VPN gateway on Azure PA firewall
- [ ] Configure authentication (Azure AD integration)
- [ ] Configure MFA (Microsoft Authenticator)
- [ ] Test GlobalProtect client connectivity (pilot users)
- [ ] Configure always-on VPN settings
- [ ] Test pre-logon VPN for domain-joined devices
- [ ] Validate App-ID and SSL inspection functionality
- [ ] Performance baseline testing

---

### Phase 3: Omaha Office Deployment (Weeks 6-7)

**Week 6: Omaha Meraki MX95 HA Deployment**
- [ ] Pre-configure MX95 pair in Meraki dashboard
- [ ] Configure VLAN 10 (Infrastructure), VLAN 20 (Users), VLAN 30 (Guest)
- [ ] Configure Auto VPN settings
- [ ] Configure firewall rules (block VLAN 20 direct internet, allow GlobalProtect)
- [ ] Schedule maintenance window (evening or weekend)
- [ ] Install MX95 HA pair at Omaha office
- [ ] Cable ISP connections (Cox WAN1, UPN WAN2)
- [ ] Cable internal network to MX95 (connect to switches)
- [ ] Verify HA failover functionality
- [ ] Test basic connectivity

**Week 7: Omaha GlobalProtect and Cutover**
- [ ] Deploy GlobalProtect client to pilot user group (2-3 users)
- [ ] Test always-on VPN from user workstations
- [ ] Verify users can access internet through PA (not direct through MX)
- [ ] Test site-to-site connectivity (once other offices deployed)
- [ ] Roll out GlobalProtect to all Omaha users
- [ ] Migrate routing from VMWare Edge to Meraki MX95
- [ ] Monitor and troubleshoot connectivity issues
- [ ] Decommission VMWare Edge pair (after 48-hour soak test)
- [ ] User acceptance testing

---

### Phase 4: Lincoln Office Deployment (Weeks 8-9)

**Week 8: Lincoln Meraki MX95/85 Deployment**
- [ ] Pre-configure MX95 or MX85 in Meraki dashboard
- [ ] Configure VLANs (Infrastructure, Users, Guest)
- [ ] Configure Auto VPN settings (spoke to Omaha)
- [ ] Configure firewall rules (block VLAN 20 direct internet)
- [ ] Determine 3rd ISP strategy (Allo - use as backup or cold spare)
- [ ] Schedule maintenance window
- [ ] Install MX95/85 at Lincoln office
- [ ] Cable ISP connections (Cox WAN1, UPN WAN2)
- [ ] Cable internal network to MX
- [ ] Test basic connectivity and Auto VPN to Omaha

**Week 9: Lincoln GlobalProtect and Cutover**
- [ ] Deploy GlobalProtect client to Lincoln users
- [ ] Test always-on VPN functionality
- [ ] Verify Auto VPN to Omaha (test file share access)
- [ ] Migrate routing from VMWare Edge to Meraki MX
- [ ] Monitor and troubleshoot connectivity issues
- [ ] Decommission VMWare Edge pair (after 48-hour soak test)
- [ ] User acceptance testing

---

### Phase 5: Papillion Office Deployment (Week 10)

**Week 10: Papillion Meraki MX75 Deployment and Cutover**
- [ ] Pre-configure MX75 in Meraki dashboard
- [ ] Configure VLANs and Auto VPN
- [ ] Configure firewall rules
- [ ] Schedule maintenance window
- [ ] Install MX75 at Papillion office
- [ ] Cable Cox Fiber ISP to MX75 WAN1
- [ ] Cable internal network to MX75
- [ ] Test Auto VPN to Omaha and Lincoln
- [ ] Deploy GlobalProtect client to Papillion users
- [ ] Test always-on VPN functionality
- [ ] Migrate routing from Fortigate 40F to MX75
- [ ] Decommission Fortigate 40F (after 48-hour soak test)
- [ ] User acceptance testing

---

### Phase 6: Small Branch Deployments (Weeks 11-12)

**Week 11: West Omaha Office - MX68 Deployment**
- [ ] Pre-configure MX68 in Meraki dashboard
- [ ] Configure VLANs and Auto VPN
- [ ] Schedule maintenance window
- [ ] Install MX68 at West Omaha office
- [ ] Cable Cox cable modem to MX68 WAN1
- [ ] Cable workstations and infrastructure devices to MX68 LAN
- [ ] Test Auto VPN to other offices
- [ ] Deploy GlobalProtect client to all West Omaha devices
- [ ] Test always-on VPN functionality
- [ ] Decommission existing firewall/router (if any)
- [ ] User training and support

**Week 12: Council Bluffs Office - MX68 Deployment (Replace Z3)**
- [ ] Pre-configure MX68 in Meraki dashboard
- [ ] Configure VLANs and Auto VPN
- [ ] Schedule maintenance window
- [ ] Install MX68 at Council Bluffs office
- [ ] Cable Cox cable modem to MX68 WAN1
- [ ] Cable workstations and infrastructure devices to MX68 LAN
- [ ] Test Auto VPN to other offices
- [ ] Deploy GlobalProtect client to all Council Bluffs devices
- [ ] Test always-on VPN functionality
- [ ] Decommission Meraki Z3
- [ ] Return or repurpose Z3 hardware
- [ ] User training and support

---

### Phase 7: Remote User Deployment (Week 13)

**Week 13: Remote Worker GlobalProtect Deployment**
- [ ] Deploy GlobalProtect client to all remote user devices
- [ ] Configure always-on VPN for remote workers
- [ ] Pilot deployment with 5-10 remote users
- [ ] Test connectivity from home networks, cellular, public WiFi
- [ ] Full deployment to all remote users
- [ ] Create user documentation and support procedures
- [ ] Help desk training for GlobalProtect troubleshooting

---

### Phase 8: Cloud Application Control and Policy Refinement (Weeks 14-15)

**Week 14: App-ID and Cloud App Policies**
- [ ] Enable App-ID on Azure PA firewall
- [ ] Review cloud application usage reports (2 weeks of data)
- [ ] Identify shadow IT and unauthorized cloud apps
- [ ] Create security policies for approved cloud apps
- [ ] Create blocking policies for unauthorized apps
- [ ] Test cloud app policies with pilot users

**Week 15: SSL Inspection and DLP**
- [ ] Deploy SSL inspection certificates to user devices (GPO or MDM)
- [ ] Enable SSL inspection policies on PA firewall
- [ ] Test SSL inspection with user devices (ensure no breakage)
- [ ] Configure DLP policies for attorney-client privileged information
- [ ] Test DLP policies (upload test documents to cloud apps)
- [ ] Enable WildFire cloud-based malware analysis
- [ ] Enable URL filtering for all users
- [ ] Review and tune security policies based on logs

---

### Phase 9: RapidScale Decommissioning (Week 16)

**Week 16: RapidScale Cutover and Cleanup**
- [ ] Verify all offices are operational via Meraki MX + PA GlobalProtect
- [ ] Verify all users are connected via GlobalProtect
- [ ] Verify all infrastructure devices route through Meraki Auto VPN
- [ ] Run parallel operation with RapidScale for 48 hours (if possible)
- [ ] Disconnect VPN tunnels to RapidScale Fortigate
- [ ] Decommission RapidScale cloud firewall service
- [ ] Cancel RapidScale contract (after retention period)
- [ ] Archive RapidScale configurations for reference

---

### Phase 10: Monitoring, Optimization, and Handoff (Weeks 17-18)

**Week 17: Monitoring and Alerting Setup**
- [ ] Configure Panorama for centralized PA management (if not already done)
- [ ] Set up log forwarding to SIEM or Azure Sentinel
- [ ] Configure Meraki dashboard alerting (Auto VPN down, high utilization)
- [ ] Configure PA alerting (VPN tunnel failures, high threat activity)
- [ ] Create dashboards for security team and leadership
- [ ] Document monitoring procedures

**Week 18: Training and Handoff**
- [ ] Train Berry Law IT staff on Meraki dashboard
- [ ] Train Berry Law IT staff on PA firewall management (if applicable)
- [ ] Train help desk on GlobalProtect troubleshooting
- [ ] Provide end-user documentation for GlobalProtect
- [ ] Conduct tabletop exercise for failure scenarios
- [ ] Document escalation procedures
- [ ] Handoff to managed services team
- [ ] Schedule 30-day and 90-day review meetings

---

## Cost Considerations

### Hardware and Licensing Costs (Estimated)

**Azure Palo Alto VM-Series Firewall:**
- VM-Series VM-300: ~$3,000-5,000/month (PAYG) or ~$40,000-60,000 (BYOL perpetual + support)
- VM-Series VM-500: ~$5,000-8,000/month (PAYG) or ~$60,000-90,000 (BYOL perpetual + support)
- Bundle 2 Subscription (per year): ~$10,000-15,000
- GlobalProtect Gateway (50-100 users/year): ~$5,000-10,000
- Azure infrastructure (compute, storage, bandwidth): ~$500-1,500/month

**Meraki MX Firewalls - Hardware:**
- 2x MX95 (Omaha HA): ~$2,800 each = $5,600 total
- 1x MX95 or MX85 (Lincoln): ~$2,800 (MX95) or ~$1,800 (MX85)
- 1x MX75 (Papillion): ~$1,500
- 2x MX68 (West Omaha, Council Bluffs): ~$750 each = $1,500 total
- **Total Meraki Hardware:** ~$11,400 (with MX95 Lincoln) or ~$10,400 (with MX85 Lincoln)

**Meraki MX Licensing - Advanced Security (per year):**
- 2x MX95 (Omaha): ~$900/year each = $1,800/year
- 1x MX95 or MX85 (Lincoln): ~$900/year (MX95) or ~$700/year (MX85)
- 1x MX75 (Papillion): ~$650/year
- 2x MX68 (West Omaha, Council Bluffs): ~$450/year each = $900/year
- **Total Meraki Licensing (Year 1):** ~$4,250/year (with MX95) or ~$4,050/year (with MX85)
- **3-Year Licensing (prepaid discount ~15%):** ~$10,800 (save ~$1,600 vs annual)

**Professional Services:**
- Design and planning: ~$12,000-18,000
- Implementation and deployment: ~$35,000-55,000
- Training and documentation: ~$5,000-10,000

**Total Estimated Investment:**

**Option 1: PA BYOL + Meraki**
- Meraki MX hardware (all sites): ~$11,400
- Meraki licensing (3-year prepaid): ~$10,800
- Azure PA VM-Series (3-year BYOL): ~$60,000-90,000
- PA subscriptions and support (Year 1): ~$15,000-25,000
- Azure infrastructure (Year 1): ~$6,000-18,000
- Professional services: ~$52,000-83,000
- **Grand Total (Year 1):** ~$155,000-238,000

**Option 2: PA PAYG + Meraki**
- Meraki MX hardware: ~$11,400
- Meraki licensing (3-year prepaid): ~$10,800
- Azure PA VM-Series (PAYG): ~$3,000-8,000/month = ~$36,000-96,000/year
- PA subscriptions (included in PAYG)
- Azure infrastructure: ~$6,000-18,000/year
- Professional services: ~$52,000-83,000
- **Grand Total (Year 1):** ~$116,000-219,000
- **Recurring (Years 2-3):** ~$42,000-114,000/year + Meraki licensing

**Annual Recurring Costs (Years 2+):**
- Meraki licensing (if not prepaid): ~$4,250/year
- PA subscriptions and support (BYOL): ~$15,000-25,000/year
- Azure PA PAYG (if chosen): ~$36,000-96,000/year
- Azure infrastructure: ~$6,000-18,000/year
- **Total Recurring (BYOL):** ~$25,000-47,000/year
- **Total Recurring (PAYG):** ~$46,000-118,000/year

### Cost Comparison: Hybrid vs. Pure Palo Alto

**Hybrid (PA + Meraki) Savings:**
- **Hardware:** Meraki MX (~$11K) vs. Palo Alto PA-850/PA-440 (~$75K-120K) = **Save $64K-109K**
- **Licensing (3-year):** Meraki (~$11K) vs. PA subscriptions (~$90K-150K) = **Save $79K-139K**
- **Total 3-Year Savings:** ~$143K-248K on office firewalls

**Trade-offs:**
- Meraki provides basic security (adequate for infrastructure devices)
- PA provides advanced security (essential for user endpoints)
- Dual-vendor management (Meraki dashboard + PA/Panorama)
- Additional licensing costs for Meraki (ongoing)

**Recommendation:** Hybrid approach significantly reduces costs while maintaining advanced security where it matters (user endpoints). Total 3-year cost is ~50-60% lower than pure Palo Alto.

---

## Benefits and Business Value

### Security Improvements

1. **Advanced User Endpoint Security**
   - Full Palo Alto security stack for all user devices (SSL inspect, App-ID, DLP, threat prevention)
   - Attorney-client privilege protection with DLP policies
   - Consistent security regardless of user location (office, home, travel)
   - Meets Nebraska and Iowa state bar confidentiality requirements

2. **Appropriate Infrastructure Security**
   - Basic threat protection for printers, phones, cameras (adequate for low-risk devices)
   - Cost-effective security posture for infrastructure
   - Meraki IDS/IPS and content filtering for infrastructure devices

3. **Zero-Touch Site-to-Site VPN**
   - Meraki Auto VPN eliminates manual VPN configuration
   - Full mesh topology with automatic failover
   - Infrastructure devices can communicate between offices seamlessly

4. **Unified Visibility**
   - PA provides deep visibility into user behavior and cloud app usage
   - Meraki dashboard provides visibility into infrastructure device traffic and Auto VPN health
   - Centralized logging for compliance and forensics

### Operational Improvements

1. **Simplified Management**
   - Meraki cloud dashboard for all office firewalls (no on-prem management)
   - Single PA management (Panorama) for user security policies
   - Auto VPN eliminates VPN troubleshooting (zero-touch)
   - Reduced complexity vs. pure Palo Alto (no need to manage PA at every small office)

2. **Scalability**
   - Easy to add new offices (order Meraki MX, plug in, Auto VPN establishes automatically)
   - Easy to add remote users (deploy GlobalProtect client)
   - No need to configure site-to-site VPN manually for new offices

3. **Cost Optimization**
   - Significant hardware savings ($64K-109K vs. pure PA)
   - Significant licensing savings ($79K-139K over 3 years vs. pure PA)
   - Right-sized security for device class (don't overspend on printer security)
   - Reduced management overhead (Meraki is simpler than PA for basic tasks)

4. **Reliability**
   - Dual-path redundancy (GlobalProtect + Meraki)
   - If PA or GlobalProtect has issues, infrastructure devices still have connectivity via Meraki
   - Meraki HA at critical sites (Omaha)
   - Auto VPN automatic failover between ISPs

### Compliance and Risk Reduction

1. **Attorney-Client Privilege Compliance**
   - All user communications encrypted (GlobalProtect VPN)
   - DLP prevents unauthorized disclosure of client information
   - Audit trail for all user data access
   - Meets state bar confidentiality requirements (NE, IA)

2. **Incident Response**
   - PA centralized logging for forensic analysis of user activity
   - Meraki logging for infrastructure device activity
   - Automated threat detection and blocking (PA for users, Meraki for infrastructure)
   - Clear separation of user traffic (high-risk) from infrastructure (low-risk)

3. **Business Continuity**
   - HA at critical sites (Omaha MX HA, Azure PA HA)
   - Dual-path architecture (GlobalProtect + Meraki) provides redundancy
   - Automatic failover for ISPs (Meraki dual WAN)
   - Rapid disaster recovery (Meraki config in cloud, PA config in Panorama)

---

## Risk Assessment and Mitigation

### Implementation Risks

**Risk 1: Dual-Vendor Complexity**
- **Impact:** Managing two platforms (PA + Meraki) increases complexity
- **Likelihood:** Low-Medium
- **Mitigation:**
  - Meraki is very simple to manage (cloud dashboard, intuitive UI)
  - PA is only managed centrally (Azure), not at each office
  - Clear separation of responsibilities (PA for users, Meraki for infrastructure)
  - Training for administrators on both platforms
  - Managed services can handle ongoing management

**Risk 2: User VPN Connectivity Issues**
- **Impact:** Users unable to access internet/cloud apps
- **Likelihood:** Medium
- **Mitigation:**
  - Extensive testing in pilot phase
  - Always-on VPN is transparent to users
  - Fallback: Temporarily allow direct internet via Meraki for critical users (while troubleshooting)
  - Help desk training for GlobalProtect support
  - Pre-logon VPN ensures domain authentication works

**Risk 3: VLAN Routing Misconfiguration**
- **Impact:** Users accidentally get direct internet (bypassing PA security)
- **Likelihood:** Low
- **Mitigation:**
  - Thoroughly test VLAN firewall rules in lab
  - Verify firewall rules block VLAN 20 direct internet before cutover
  - Monitoring alerts if VLAN 20 traffic bypasses GlobalProtect
  - Configuration templates for all offices (consistency)

**Risk 4: Meraki Auto VPN Failure**
- **Impact:** Offices cannot communicate site-to-site
- **Likelihood:** Low (Meraki Auto VPN is very reliable)
- **Mitigation:**
  - Meraki Auto VPN has 99.9%+ uptime track record
  - Automatic failover if primary tunnel fails
  - Meraki support for Auto VPN issues
  - Infrastructure devices can still access internet directly (only site-to-site affected)

**Risk 5: Cost Overruns**
- **Impact:** Budget exceeded
- **Likelihood:** Low-Medium
- **Mitigation:**
  - Meraki hardware and licensing costs are fixed and predictable
  - PA Azure costs monitored (PAYG allows cost control)
  - Prepay Meraki licensing (3-year) for discount
  - Build contingency budget (15-20%)

### Post-Implementation Risks

**Risk 1: Azure PA Outage**
- **Impact:** Users lose internet access (GlobalProtect down)
- **Likelihood:** Low (Azure SLA 99.99%)
- **Mitigation:**
  - PA deployed in HA configuration (Active/Passive)
  - Temporary fallback: Allow VLAN 20 direct internet via Meraki during outage
  - Azure SLA credits for outages
  - Users can still access local resources via Meraki Auto VPN

**Risk 2: Meraki Cloud Dashboard Outage**
- **Impact:** Cannot manage Meraki MX devices
- **Likelihood:** Very Low (Meraki cloud SLA 99.99%)
- **Mitigation:**
  - MX devices continue operating during dashboard outage (dataplane unaffected)
  - Auto VPN continues working (no configuration changes needed)
  - Outages are typically short (<1 hour)
  - Cannot make config changes during outage, but traffic flows normally

---

## Success Criteria

### Technical Success Metrics

- [ ] All users successfully connected via GlobalProtect always-on VPN
- [ ] All infrastructure devices routing through local Meraki MX
- [ ] Meraki Auto VPN operational between all offices (full mesh)
- [ ] User VLAN firewall rules enforced (no direct internet, only GlobalProtect)
- [ ] Internet connectivity maintained or improved (latency, throughput)
- [ ] PA security policies enforced for all user traffic (App-ID, SSL inspect, DLP)
- [ ] Meraki MX HA tested and operational (Omaha)
- [ ] Zero unencrypted user connections (all via GlobalProtect)
- [ ] VPN tunnel uptime >99.5% (GlobalProtect and Auto VPN)
- [ ] Infrastructure devices can communicate site-to-site via Auto VPN

### Business Success Metrics

- [ ] Total 3-year cost savings vs. pure PA: $143K-248K
- [ ] Zero security incidents related to user endpoint traffic
- [ ] Compliance with attorney-client privilege requirements (NE, IA bars)
- [ ] User satisfaction with VPN connectivity (transparent experience)
- [ ] Leadership visibility into cloud app usage and security posture
- [ ] Successful decommissioning of RapidScale service
- [ ] Reduced management time for site-to-site VPN (Auto VPN vs. manual)

### Operational Success Metrics

- [ ] Mean time to add new office: <1 day (order Meraki MX, plug in, Auto VPN establishes)
- [ ] Mean time to add remote user: <30 minutes (deploy GlobalProtect client)
- [ ] Centralized logging operational (PA and Meraki)
- [ ] Security team trained on PA and Meraki platforms
- [ ] Help desk trained on GlobalProtect troubleshooting
- [ ] Documentation complete (runbooks, SOPs, network diagrams)
- [ ] Monitoring and alerting operational

---

## Comparison: Hybrid vs. Pure Palo Alto

### Architecture Comparison

| Aspect | Hybrid (PA + Meraki) | Pure Palo Alto |
|--------|---------------------|----------------|
| **User Endpoint Security** | Full PA stack (SSL inspect, App-ID, DLP) | Full PA stack |
| **Infrastructure Device Security** | Basic Meraki (IDS/IPS, content filter) | Full PA stack |
| **Site-to-Site VPN** | Meraki Auto VPN (zero-touch) | PA IPsec VPN (manual config) |
| **Management** | Meraki dashboard + PA/Panorama | PA/Panorama only |
| **Hardware Cost (3-year)** | ~$11K Meraki | ~$75K-120K PA |
| **Licensing Cost (3-year)** | ~$11K Meraki + ~$30K PA | ~$90K-150K PA |
| **Complexity** | Medium (dual-vendor) | Medium-High (PA at every office) |
| **Scalability** | High (Auto VPN zero-touch) | Medium (manual VPN config) |
| **Reliability** | High (dual-path) | High |

### When to Choose Hybrid (PA + Meraki)

**Choose Hybrid If:**
- Budget is a significant constraint (~$150K-250K savings over 3 years)
- You want simplified management for office infrastructure (Meraki cloud dashboard)
- You want zero-touch site-to-site VPN (Meraki Auto VPN)
- Infrastructure devices are low-risk (printers, phones, cameras)
- You want to minimize on-premises firewall hardware

**Choose Pure Palo Alto If:**
- You require consistent security platform across all devices
- You want unified management (single vendor)
- Infrastructure devices require advanced threat protection
- You have regulatory requirements for infrastructure device inspection
- Budget allows for higher upfront investment

**Recommendation for Berry Law:** Hybrid approach is recommended due to:
1. Significant cost savings ($150K-250K over 3 years)
2. Appropriate security for device class (advanced for users, basic for infrastructure)
3. Simplified management with Meraki cloud dashboard and Auto VPN
4. Meets attorney-client privilege requirements (users get full PA security)
5. Infrastructure devices (printers, phones) are low-risk and don't require PA-level security

---

## Next Steps

1. **Executive Approval**
   - Present hybrid architecture to Berry Law leadership
   - Compare costs: Hybrid (~$155K-238K Year 1) vs. Pure PA (~$210K-335K Year 1)
   - Highlight savings: ~$150K-250K over 3 years
   - Get budget approval and project authorization

2. **Technical Review**
   - Review with Berry Law IT/technical contact
   - Validate user count and infrastructure device count per office
   - Confirm ISP details and bandwidth
   - Review VLAN design and IP addressing

3. **Vendor Engagement**
   - Engage Palo Alto partner for PA VM-Series quote
   - Engage Cisco Meraki partner for MX hardware and licensing quote
   - Review Meraki licensing options (annual vs. 3-year vs. 5-year)
   - Review PA licensing options (BYOL vs. PAYG)

4. **Kickoff**
   - Schedule project kickoff meeting
   - Assign project manager and technical leads
   - Establish communication cadence with Berry Law
   - Begin Phase 1 (Planning and Preparation)

---

## Appendix A: Alternative Design Considerations

### Option 1: Pure Meraki (No Palo Alto)

**Description:** Use Meraki MX at all offices with Advanced Security licenses, GlobalProtect VPN removed, all traffic inspected locally by Meraki.

**Pros:**
- Single vendor (Cisco Meraki) - simplified management
- Lowest cost (~$25K-40K total investment)
- Cloud-managed (Meraki dashboard)
- Auto VPN for site-to-site

**Cons:**
- Limited SSL inspection capabilities (Meraki cannot decrypt most SSL traffic)
- No App-ID (basic application control only)
- No DLP (cannot protect attorney-client privileged information)
- Does not meet legal industry security requirements

**Recommendation:** Not recommended. Legal firms handling attorney-client privileged information require advanced security (SSL inspect, DLP) that Meraki MX cannot provide.

---

### Option 2: Prisma Access (SASE) Instead of Azure PA

**Description:** Use Palo Alto Prisma Access (cloud-delivered SASE) instead of Azure VM-Series + Meraki.

**Pros:**
- Fully managed by Palo Alto (no Azure infrastructure)
- Global PoPs for low latency
- Includes GlobalProtect and security services
- Eliminates on-premises firewalls (all sites use Prisma Access)

**Cons:**
- Higher per-user costs (~$50-100/user/month)
- No local breakout for infrastructure devices (all traffic to cloud)
- Vendor lock-in to Palo Alto cloud
- Still need local network infrastructure (switches, WiFi)

**Cost Comparison:**
- Prisma Access: ~$60K-120K/year for 50-100 users
- Hybrid (PA + Meraki): ~$25K-47K/year recurring (after Year 1)

**Recommendation:** Consider for future if customer wants to eliminate all on-premises firewalls. Current hybrid design provides more control and lower cost.

---

### Option 3: Keep Z3 at Council Bluffs (Don't Upgrade to MX68)

**Description:** Retain existing Meraki Z3 at Council Bluffs instead of upgrading to MX68.

**Pros:**
- Saves ~$750 hardware cost + ~$450/year licensing
- Z3 is already deployed and working

**Cons:**
- Z3 has only 1 LAN port (all devices share, requires switch)
- Z3 has limited VPN throughput (50 Mbps vs. 200 Mbps on MX68)
- Z3 has fewer security features than MX68
- Inconsistent platform (Z3 vs. MX series at other offices)

**Recommendation:** Upgrade to MX68 for consistency and future-proofing. The ~$1,200 total cost is minimal compared to project budget, and provides 4x VPN throughput improvement.

---

## Appendix B: VLAN Design Details

### Standard VLAN Scheme (All Offices)

```yaml
VLAN 10 - Infrastructure:
  Name: "INFRASTRUCTURE"
  Subnet: 10.{site_id}.10.0/24
  Gateway: Meraki MX (10.{site_id}.10.1)
  DHCP: Enabled (Meraki MX)
  DNS: Meraki MX or internal DNS server
  Devices: Printers, IP phones, cameras, servers, IoT
  Internet Access: Direct via Meraki MX WAN
  Site-to-Site: Meraki Auto VPN
  Firewall Rules:
    - Allow all to Internet
    - Allow all to other office VLAN 10 subnets (via Auto VPN)
    - Block access to VLAN 20 (user workstations)
    - Block access to VLAN 30 (guest WiFi)

VLAN 20 - User Workstations:
  Name: "USERS"
  Subnet: 10.{site_id}.20.0/24
  Gateway: Meraki MX (10.{site_id}.20.1)
  DHCP: Enabled (Meraki MX)
  DNS: Meraki MX or internal DNS server
  Devices: Attorney/staff desktops, laptops
  Internet Access: BLOCKED (must use GlobalProtect VPN)
  VPN Access: GlobalProtect to Azure PA firewall (REQUIRED)
  Firewall Rules:
    - DENY all to Internet (explicit block)
    - ALLOW to Azure PA public IP (UDP 443, ESP, IKE) for GlobalProtect
    - ALLOW to local VLAN 10 (infrastructure devices)
    - ALLOW to other office VLAN 10 (via Auto VPN, for file servers)

VLAN 30 - Guest WiFi:
  Name: "GUEST"
  Subnet: 10.{site_id}.30.0/24
  Gateway: Meraki MX (10.{site_id}.30.1)
  DHCP: Enabled (Meraki MX)
  DNS: Public DNS (1.1.1.1, 8.8.8.8)
  Devices: Visitor laptops, phones
  Internet Access: Direct via Meraki MX (no VPN required)
  Isolation: Client isolation enabled
  Firewall Rules:
    - ALLOW to Internet (HTTP, HTTPS only)
    - DENY all to VLAN 10 (infrastructure)
    - DENY all to VLAN 20 (user workstations)
    - DENY all site-to-site access
```

### Site ID Assignments
- Omaha: site_id = 100 → VLANs use 10.100.10.0/24, 10.100.20.0/24, 10.100.30.0/24
- Lincoln: site_id = 110 → VLANs use 10.110.10.0/24, 10.110.20.0/24, 10.110.30.0/24
- Papillion: site_id = 120 → VLANs use 10.120.10.0/24, 10.120.20.0/24, 10.120.30.0/24
- West Omaha: site_id = 130 → VLANs use 10.130.10.0/24, 10.130.20.0/24, 10.130.30.0/24
- Council Bluffs: site_id = 140 → VLANs use 10.140.10.0/24, 10.140.20.0/24, 10.140.30.0/24

---

## Document Control

**Document Owner:** Midwest Cloud Computing - Technical Team
**Approvals Required:**
- [ ] Berry Law - Executive Approval
- [ ] Berry Law - Technical Contact Review
- [ ] Midwest Cloud Computing - Project Manager Approval
- [ ] Cisco Meraki Partner - Technical Review
- [ ] Palo Alto Networks Partner - Technical Review

**Revision History:**
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-20 | Claude | Initial document creation |

---

**END OF DOCUMENT**
