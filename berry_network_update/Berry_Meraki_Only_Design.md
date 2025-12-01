# Berry Law - Meraki-Only On-Premises Network Design
## Midwest Cloud Computing - Alternative Architecture Comparison

**Document Version:** 1.0
**Created:** November 20, 2025
**Customer:** Berry Law (John S. Berry Law, PC)
**Project:** RapidScale/VMWare Migration - Meraki On-Premises Option

---

## Executive Summary

This document presents a **Meraki-only on-premises architecture** as an alternative to the hybrid Palo Alto Azure + Meraki design. In this approach, Cisco Meraki MX firewalls at **Omaha and Lincoln serve as dual security hubs and VPN concentrators** for all remote offices and remote users. No cloud firewall component is required.

**Key Characteristics:**
- **Dual Hub Architecture:** Lincoln (primary) and Omaha (secondary) act as security gateways
- **All-Meraki Platform:** Single vendor for simplified management
- **On-Premises Control:** No dependency on cloud firewall services
- **Auto VPN Mesh:** Zero-touch site-to-site connectivity between all offices
- **Client VPN:** Remote users connect to Lincoln (primary) or Omaha (backup) via Meraki Client VPN or AnyConnect

**Trade-offs vs. Hybrid (PA + Meraki):**
- **Lower Cost:** ~$50K-80K cheaper over 3 years
- **Simpler Management:** Single vendor, single dashboard
- **Limited Advanced Security:** No SSL inspection, limited DLP, basic App-ID
- **Compliance Considerations:** May not fully meet advanced threat detection requirements for attorney-client privilege protection

---

## Architecture Overview

### Dual-Hub Design

**Omaha and Lincoln as Security Hubs:**

```
                     ┌────────────────────────────────────────┐
                     │              INTERNET                  │
                     └────────────────┬───────────────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              │                       │                       │
     ┌────────▼────────┐     ┌───────▼───────┐               │
     │  Lincoln Office │     │ Omaha Office   │               │
     │  MX250 (HA)     │◄───►│ MX250 (HA)     │               │
     │  PRIMARY HUB    │     │ SECONDARY HUB  │               │
     │  - Security GW  │     │ - Security GW  │               │
     │  - VPN Conc.    │     │ - VPN Conc.    │               │
     │  - Triple ISP   │     │ - Dual ISP     │               │
     └────────┬────────┘     └───────┬────────┘               │
              │    Full Mesh         │                        │
              │    Auto VPN          │                        │
              │                      │                        │
     ┌────────┴──────────────────────┴────────┐              │
     │                                        │              │
┌────▼─────┐    ┌───────────┐    ┌───────────▼┐             │
│Papillion │    │West Omaha │    │Council Blfs │             │
│ MX75     │    │ MX68      │    │ MX68        │             │
│ SPOKE    │    │ SPOKE     │    │ SPOKE       │             │
└──────────┘    └───────────┘    └─────────────┘             │
     │               │                │                       │
     └───────────────┴────────────────┘                       │
              Auto VPN to Hubs                                │
                                                              │
     ┌────────────────────────────────────────────────────────┤
     │                                                        │
     │  ┌──────────────────────────────────────────────┐     │
     │  │           REMOTE USERS                        │     │
     │  │  Laptops with Meraki Client VPN or AnyConnect │     │
     │  │  Connect to Lincoln (primary) or Omaha (backup)│    │
     │  └──────────────────────────────────────────────┘     │
     │                                                        │
     └────────────────────────────────────────────────────────┘
```

### Traffic Flow Patterns

**Pattern 1: Branch Office Internet Access (Centralized)**
```
Branch Office (Papillion) User
  → Local Meraki MX75
  → Auto VPN Tunnel to Lincoln MX250 (hub)
  → Lincoln MX250 applies security policies
  → Internet via Lincoln ISP

Benefits: Centralized security enforcement at hub
Drawback: Latency added by hairpin through hub; hub bandwidth consumed
```

**Pattern 2: Branch Office Internet Access (Local Breakout)**
```
Branch Office (Papillion) User
  → Local Meraki MX75
  → Local security inspection (Meraki threat protection)
  → Internet via local Papillion ISP

Benefits: Lower latency, no hub bandwidth consumption
Drawback: Security policies managed per-site (less centralized)
```

**Pattern 3: Remote User Access**
```
Remote User (Home/Travel)
  → Meraki Client VPN or AnyConnect
  → VPN Tunnel to Lincoln MX250 (or Omaha as backup)
  → Lincoln MX250 applies security policies
  → Internet or internal resource access

Benefits: Secure remote access with MFA
Drawback: All remote user traffic routes through Lincoln hub
```

**Pattern 4: Site-to-Site Communication**
```
Lincoln User → Omaha File Server
  → Lincoln MX250 (local gateway)
  → Auto VPN Tunnel direct to Omaha MX250
  → Omaha internal network → File Server

Benefits: Direct mesh VPN, low latency
Full mesh between hubs; hub-and-spoke for branches
```

### Recommended Traffic Strategy

**For Berry Law, we recommend a hybrid traffic pattern:**

1. **User Workstations at Branches:** Route through hub (Lincoln/Omaha) for centralized security
2. **Infrastructure Devices at Branches:** Local internet breakout (printers don't need hub inspection)
3. **Remote Users:** Always route through Lincoln/Omaha hub via Client VPN
4. **Guests at All Sites:** Local internet breakout (no hub routing)

This mirrors the separation strategy in the hybrid PA+Meraki design, but uses Meraki security features instead of Palo Alto.

---

## Meraki MX Sizing by Office

### Hub Sites (Omaha and Lincoln)

Hub sites require larger MX appliances to handle:
- Local office traffic
- VPN concentrator duties for all branch offices
- Client VPN for all remote users
- Centralized security inspection for branch user traffic

#### Lincoln Office (Primary Hub)
**Recommended Model:** MX250 (High Availability Pair)

**Justification:**
- Primary hub for all branch offices and remote users
- Triple ISP (Cox Fiber 1 Gbps + UPN Fiber 1 Gbps + Allo Fiber 1 Gbps) - Best redundancy
- VPN concentrator for Papillion, West Omaha, Council Bluffs, Omaha
- Client VPN gateway for ~20-40 remote users
- Requires HA for 24/7 operations

**Specifications:**
- **Model:** MX250 (Primary) + MX250 (Warm Spare)
- **Throughput:** 1 Gbps stateful firewall, 500 Mbps VPN throughput
- **Site-to-Site VPN Peers:** 500 (sufficient for all offices + future growth)
- **Client VPN Users:** 1,000 concurrent (more than sufficient)
- **WAN Interfaces:** 2x 1GbE (Cox Fiber + UPN Fiber)
- **LAN Interfaces:** 8x 1GbE (connect to switches)
- **Licensing:** Meraki Advanced Security (per year)
- **Deployment:** Active/Warm Spare HA

**Configuration:**
- WAN1: Cox Fiber (1 Gbps) - Primary
- WAN2: UPN Fiber (1 Gbps) - Secondary
- WAN3: Allo Fiber (1 Gbps) - Tertiary (via load balancer or failover switch)
- LAN: Connected to LNK-SW-01, LNK-SW-02, LNK-SW-03
- Auto VPN: Hub mode (concentrator for all spokes)
- Client VPN: Enabled (Meraki Client VPN or AnyConnect)
- VPN Concentrator Priority: Primary (Omaha is secondary)

**Hub Functions:**
- Default gateway for all Lincoln users and devices
- VPN concentrator for Papillion, West Omaha, Council Bluffs, Omaha
- Primary Client VPN endpoint for remote users
- Centralized security inspection for branch office user traffic (if hub routing enabled)
- Full mesh Auto VPN with Omaha

---

#### Omaha Office (Secondary Hub)
**Recommended Model:** MX250 (High Availability Pair or Single)

**Justification:**
- Secondary hub / failover for remote offices and users
- Dual ISP (Cox Fiber + UPN Fiber - 1 Gbps each)
- Backup VPN concentrator if Lincoln fails
- Backup Client VPN gateway for remote users
- HA recommended for 24/7 operations

**Specifications:**
- **Model:** MX250 (Single or HA pair based on budget)
- **Throughput:** 1 Gbps stateful firewall, 500 Mbps VPN throughput
- **Site-to-Site VPN Peers:** 500
- **Client VPN Users:** 1,000 concurrent
- **WAN Interfaces:** 2x 1GbE (use Cox + UPN; Allo as backup)
- **LAN Interfaces:** 8x 1GbE
- **Licensing:** Meraki Advanced Security (per year)
- **Deployment:** Single or Active/Warm Spare HA

**Configuration:**
- WAN1: Cox Fiber (1 Gbps) - Primary
- WAN2: UPN Fiber (1 Gbps) - Secondary (automatic failover)
- LAN: Connected to OMA-SW-01, OMA-SW-02
- Auto VPN: Hub mode (secondary concentrator)
- Client VPN: Enabled (backup endpoint for remote users)
- VPN Concentrator Priority: Secondary (Lincoln is primary)

**Hub Functions:**
- Default gateway for all Omaha users and devices
- Secondary VPN concentrator (failover from Lincoln)
- Secondary Client VPN endpoint for remote users
- Centralized security inspection for Omaha traffic
- Full mesh Auto VPN with Lincoln

---

### Spoke Sites (Papillion, West Omaha, Council Bluffs)

Spoke sites connect to hub sites via Auto VPN. They can route user traffic through hubs for centralized security or use local breakout.

#### Papillion Office (Spoke)
**Recommended Model:** MX75 (Single Unit)

**Justification:**
- Branch office with ~5-8 users
- Single ISP (Cox Fiber 1 Gbps)
- Connects to Omaha/Lincoln hubs via Auto VPN
- Can route user traffic to hub or local breakout

**Specifications:**
- **Model:** MX75
- **Throughput:** 350 Mbps stateful firewall, 300 Mbps VPN
- **WAN Interfaces:** 2x 1GbE (only 1 ISP currently)
- **LAN Interfaces:** 12x 1GbE
- **Licensing:** Meraki Advanced Security (per year)
- **Deployment:** Single unit (spoke to Omaha/Lincoln)

**Configuration:**
- WAN1: Cox Fiber (1 Gbps)
- WAN2: Available for future 2nd ISP
- LAN: Connected to switches
- Auto VPN: Spoke mode (connects to Lincoln primary, Omaha secondary)
- Hub Routing: Enabled for user VLAN (traffic routes through Lincoln for security)
- Local Breakout: Enabled for infrastructure VLAN (printers, phones)

**Traffic Routing:**
- User workstations → Lincoln hub (centralized security) → Internet
- Infrastructure devices → Local MX75 → Internet (local breakout)

---

#### West Omaha Office (Spoke)
**Recommended Model:** MX68 (Single Unit)

**Justification:**
- Small branch with ~2-5 users
- Cox Cable Modem (speed TBD, asymmetric)
- Minimal infrastructure
- Connects to Omaha/Lincoln hubs via Auto VPN

**Specifications:**
- **Model:** MX68
- **Throughput:** 250 Mbps stateful firewall, 200 Mbps VPN
- **WAN Interfaces:** 2x 1GbE (only 1 ISP)
- **LAN Interfaces:** 12x 1GbE
- **Licensing:** Meraki Advanced Security (per year)
- **Deployment:** Single unit (spoke)

**Configuration:**
- WAN1: Cox Cable Modem
- Auto VPN: Spoke mode (Lincoln primary, Omaha secondary)
- Hub Routing: Enabled for user VLAN
- Local Breakout: Enabled for infrastructure VLAN

---

#### Council Bluffs Office (Spoke)
**Recommended Model:** MX68 (Single Unit) - Replace existing Z3

**Justification:**
- Small Iowa branch with ~2-5 users
- Cox Cable Modem (speed TBD, asymmetric)
- Currently has Meraki Z3 (limited capabilities)
- Upgrade to MX68 for better performance and features

**Specifications:**
- **Model:** MX68 (replaces existing Z3)
- **Throughput:** 250 Mbps stateful firewall, 200 Mbps VPN
- **WAN Interfaces:** 2x 1GbE
- **LAN Interfaces:** 12x 1GbE (vs. 1 LAN port on Z3)
- **Licensing:** Meraki Advanced Security (per year)
- **Deployment:** Single unit (spoke)

**Configuration:**
- WAN1: Cox Cable Modem
- Auto VPN: Spoke mode (Lincoln primary, Omaha secondary)
- Hub Routing: Enabled for user VLAN
- Local Breakout: Enabled for infrastructure VLAN

---

## Remote User VPN Strategy

### Meraki Client VPN

**Overview:**
Meraki MX appliances include built-in Client VPN functionality that allows remote users to securely connect to the corporate network.

**Configuration:**
- **VPN Type:** L2TP/IPsec with Pre-Shared Key and user authentication
- **Authentication:** Active Directory, RADIUS, or Meraki Cloud Authentication
- **MFA Support:** RADIUS with MFA provider (Duo, Azure MFA, etc.)
- **Primary Gateway:** Lincoln MX250 (public IP)
- **Secondary Gateway:** Omaha MX250 (public IP, manual failover)

**Client Support:**
- Windows (built-in L2TP client)
- macOS (built-in L2TP client)
- iOS (built-in L2TP client)
- Android (built-in L2TP client)
- Linux (L2TP client)

**Limitations:**
- **Not Always-On:** Users must manually connect (not transparent like GlobalProtect)
- **Manual Failover:** Users must manually switch to Lincoln if Omaha is unavailable
- **No Pre-Logon VPN:** Cannot authenticate to domain before user login
- **Basic Client:** No advanced features like HIP checks or automatic reconnect

---

### Alternative: Cisco AnyConnect with Meraki MX

**Overview:**
Meraki MX appliances also support Cisco AnyConnect client, which provides a more robust VPN experience.

**Benefits over Meraki Client VPN:**
- **Always-On Option:** Can be configured for automatic connection
- **Automatic Failover:** Can configure primary/secondary gateways
- **Pre-Logon VPN:** Supports machine tunnel for domain authentication
- **Better Client:** More reliable, better reconnection behavior
- **Split Tunnel Support:** More granular control over what routes through VPN

**Requirements:**
- Cisco AnyConnect licenses (additional cost)
- AnyConnect client deployment via MDM or manual install
- Meraki MX firmware that supports AnyConnect

**Configuration:**
- Deploy AnyConnect client to all remote user devices
- Configure Lincoln as primary gateway, Omaha as secondary
- Enable automatic reconnection and always-on mode
- Integrate with Azure AD or RADIUS for MFA

**Recommendation:** Use AnyConnect for better user experience, especially if always-on VPN is desired. Additional licensing cost is offset by improved reliability and user experience.

---

## Security Features: Meraki vs. Palo Alto

### Security Feature Comparison

| Feature | Meraki MX (Advanced Security) | Palo Alto (Azure + GlobalProtect) |
|---------|------------------------------|-----------------------------------|
| **Stateful Firewall** | Yes | Yes |
| **VPN (Site-to-Site)** | Auto VPN (excellent) | IPsec (manual config) |
| **VPN (Client)** | Client VPN / AnyConnect | GlobalProtect (always-on) |
| **Intrusion Prevention (IPS)** | Snort-based signatures | PA IPS (more comprehensive) |
| **Anti-Malware** | Yes (basic file scanning) | WildFire (cloud ML analysis) |
| **URL Filtering** | Yes (category-based) | Yes (category + reputation) |
| **Application Control** | Basic (Layer 7 signatures) | App-ID (5,000+ apps, very comprehensive) |
| **SSL/TLS Inspection** | Limited (HTTPS inspection not full SSL decrypt) | Full SSL decryption and inspection |
| **Data Loss Prevention (DLP)** | No native DLP | Yes (content inspection, block uploads) |
| **DNS Security** | Cisco Umbrella integration | PA DNS Security |
| **Threat Intelligence** | Cisco Talos | Palo Alto Unit 42 |
| **Cloud App Visibility** | Basic | Comprehensive (App-ID) |
| **Management** | Meraki Dashboard (excellent) | Panorama (complex but powerful) |
| **Always-On VPN** | AnyConnect only (extra cost) | GlobalProtect (included) |
| **MFA Integration** | RADIUS-based | Native Azure AD + SAML |

### Key Security Gaps in Meraki-Only Approach

**1. No True SSL/TLS Inspection**

**Impact:** Cannot inspect encrypted HTTPS traffic (90%+ of internet traffic)
- Cannot detect malware in encrypted downloads
- Cannot identify data exfiltration via HTTPS
- Cannot enforce DLP on encrypted uploads to cloud apps
- Limited visibility into cloud application content

**Mitigation:** Use endpoint protection (EDR) for malware detection; accept reduced visibility

**2. No Native Data Loss Prevention (DLP)**

**Impact:** Cannot prevent unauthorized sharing of attorney-client privileged information
- Cannot scan files being uploaded to cloud storage
- Cannot detect sensitive content (case numbers, client names) leaving network
- Cannot block uploads to personal Dropbox, Google Drive, etc.

**Mitigation:** Use Microsoft Purview DLP (requires M365 E5 or DLP add-on); accept reduced protection

**3. Limited Application Control**

**Impact:** Basic application identification vs. Palo Alto's comprehensive App-ID
- May not identify all 5,000+ cloud applications
- Cannot distinguish between personal vs. business versions of apps
- Limited ability to control specific app functions (e.g., allow Dropbox view, block upload)

**Mitigation:** Use URL filtering categories; accept less granular control

**4. Client VPN Limitations**

**Impact:** Meraki native Client VPN is not always-on
- Users must manually connect VPN (may forget or bypass)
- No pre-logon VPN for domain authentication
- Manual failover between Omaha and Lincoln

**Mitigation:** Deploy Cisco AnyConnect with always-on configuration (additional licensing cost)

---

### Meraki Security Features Available

Despite limitations, Meraki MX provides solid security:

**Intrusion Prevention System (IPS):**
- Snort-based signatures
- Updated regularly via Cisco Talos threat intelligence
- Blocks known exploits, vulnerabilities, and attack patterns
- Effective against network-based attacks

**Anti-Malware (AMP):**
- File reputation checking
- Known malware signature detection
- File hash lookup against Cisco Talos database
- Blocks known malware downloads

**URL Filtering (Content Filtering):**
- 80+ content categories
- Block categories: malware, phishing, adult, gambling, etc.
- Allow/block specific URLs
- HTTPS URL filtering (without full SSL decrypt)

**Application Control:**
- Layer 7 application identification
- Block categories: P2P, gaming, social media
- Traffic shaping for applications
- Visibility into top applications by bandwidth

**Geo-IP Blocking:**
- Block traffic from/to specific countries
- Useful for blocking known threat regions

**Advanced Malware Protection (AMP) for Files:**
- Retrospective analysis (alerts if previously clean file becomes known malware)
- File trajectory tracking
- Threat Grid sandbox integration (optional)

---

## VLAN and Routing Design

### VLAN Scheme (All Sites)

```yaml
VLAN 10 - Infrastructure:
  Description: Printers, IP phones, cameras, servers
  Routing: Local internet breakout via local MX
  Security: Local MX security features
  Site-to-Site: Auto VPN to all other offices

VLAN 20 - User Workstations:
  Description: Attorney and staff desktops/laptops
  Routing: Hub routing through Omaha MX250 (centralized security)
  Security: Omaha MX250 security features (IPS, AMP, URL filtering)
  Site-to-Site: Via hub (Omaha/Lincoln)

VLAN 30 - Guest WiFi:
  Description: Visitor wireless access
  Routing: Local internet breakout via local MX
  Security: Basic (no corporate access)
  Isolation: Client isolation, no access to VLAN 10/20
```

### Hub Routing Configuration

**Purpose:** Route branch office user traffic through Lincoln hub for centralized security inspection.

**Meraki Dashboard Configuration:**
1. Navigate to Security & SD-WAN > SD-WAN & Traffic Shaping
2. Enable "VPN traffic" for user VLAN subnets
3. Configure Lincoln as VPN exit hub
4. Branch MX will route user VLAN traffic to Lincoln → Internet

**Traffic Flow (Branch User Internet Access):**
```
Branch User (VLAN 20)
  → Branch MX (e.g., Papillion MX75)
  → Auto VPN Tunnel to Lincoln MX250
  → Lincoln MX250 (security inspection: IPS, AMP, URL filtering)
  → Lincoln WAN (Cox, UPN, or Allo Fiber)
  → Internet
```

**Benefits:**
- Centralized security policy enforcement at hub
- Consistent security for all branch office users
- Simplified policy management (configure once at hub)

**Drawbacks:**
- Added latency (traffic hairpins through Lincoln)
- Hub bandwidth consumption (Lincoln ISPs carry all branch user traffic)
- Hub becomes single point of failure (mitigated by Omaha failover)

---

## Client VPN Architecture

### Dual-Hub Client VPN Design

**Primary VPN Gateway: Lincoln MX250**
- Public IP: [Lincoln static public IP]
- Authentication: RADIUS with Azure AD (or AD on-prem)
- MFA: Azure MFA via RADIUS extension or Duo
- VPN Type: AnyConnect (recommended) or L2TP/IPsec
- Split Tunnel: Disabled (all traffic through VPN)

**Secondary VPN Gateway: Omaha MX250**
- Public IP: [Omaha static public IP]
- Authentication: Same RADIUS/Azure AD
- MFA: Same Azure MFA/Duo
- VPN Type: AnyConnect or L2TP/IPsec
- Purpose: Failover if Lincoln unavailable

**AnyConnect Profile (Recommended):**
```xml
<AnyConnectProfile>
  <ServerList>
    <HostEntry>
      <HostName>Berry Law VPN</HostName>
      <HostAddress>lincoln.berrylaw.vpn.example.com</HostAddress>
      <BackupServerList>
        <HostAddress>omaha.berrylaw.vpn.example.com</HostAddress>
      </BackupServerList>
    </HostEntry>
  </ServerList>
  <AutomaticVPNPolicy>
    <TrustedNetworkPolicy>Disconnect</TrustedNetworkPolicy>
    <UntrustedNetworkPolicy>Connect</UntrustedNetworkPolicy>
  </AutomaticVPNPolicy>
</AnyConnectProfile>
```

**Configuration enables:**
- Automatic connection when on untrusted networks
- Automatic failover to Omaha if Lincoln fails
- Disconnect when on trusted (office) network

---

## Implementation Plan

### Phase 1: Planning and Preparation (Weeks 1-2)

**Week 1: Assessment and Design**
- [ ] Validate user counts and device counts per office
- [ ] Confirm ISP details and static public IPs (Omaha, Lincoln)
- [ ] Plan VLAN scheme and IP addressing
- [ ] Determine AnyConnect licensing needs
- [ ] Get approval from Berry Law leadership

**Week 2: Procurement and Configuration Prep**
- [ ] Order Meraki MX hardware:
  - 2x MX250 (Omaha HA) or 3x MX250 (Omaha HA + Lincoln single) or 4x MX250 (both HA)
  - 1x MX75 (Papillion)
  - 2x MX68 (West Omaha, Council Bluffs)
- [ ] Purchase Meraki licensing (Advanced Security, 3-year or 5-year)
- [ ] Purchase AnyConnect licenses (if using AnyConnect)
- [ ] Set up Meraki dashboard organization
- [ ] Pre-configure all MX devices in dashboard
- [ ] Configure Auto VPN topology (hubs and spokes)
- [ ] Configure Client VPN settings
- [ ] Prepare RADIUS/Azure AD integration

---

### Phase 2: Hub Site Deployments (Weeks 3-5)

**Week 3: Omaha MX250 HA Deployment**
- [ ] Pre-configure MX250 pair in Meraki dashboard
- [ ] Schedule maintenance window (evening/weekend)
- [ ] Install MX250 HA pair at Omaha
- [ ] Cable ISP connections (Cox WAN1, UPN WAN2)
- [ ] Cable LAN to switches
- [ ] Verify HA failover
- [ ] Test local connectivity

**Week 4: Omaha Hub Configuration and Testing**
- [ ] Configure VLANs (Infrastructure, Users, Guest)
- [ ] Enable security features (IPS, AMP, URL filtering)
- [ ] Configure Client VPN on Omaha
- [ ] Test Client VPN connectivity (pilot users)
- [ ] Migrate routing from VMWare Edge to MX250
- [ ] Decommission VMWare Edge pair (after 48-hour soak)

**Week 5: Lincoln MX250 Deployment**
- [ ] Install MX250 (single or HA) at Lincoln
- [ ] Cable ISP connections (Cox WAN1, UPN WAN2)
- [ ] Cable LAN to switches
- [ ] Configure VLANs and security features
- [ ] Configure Client VPN (secondary gateway)
- [ ] Test Auto VPN mesh with Omaha (hub-to-hub)
- [ ] Migrate routing from VMWare Edge to MX250
- [ ] Decommission VMWare Edge pair

---

### Phase 3: Spoke Site Deployments (Weeks 6-8)

**Week 6: Papillion MX75 Deployment**
- [ ] Install MX75 at Papillion
- [ ] Cable Cox Fiber to WAN1
- [ ] Configure VLANs
- [ ] Configure Auto VPN (spoke to Omaha/Lincoln)
- [ ] Configure hub routing for user VLAN
- [ ] Test connectivity and hub routing
- [ ] Decommission Fortigate 40F

**Week 7: West Omaha MX68 Deployment**
- [ ] Install MX68 at West Omaha
- [ ] Cable Cox cable modem to WAN1
- [ ] Configure VLANs
- [ ] Configure Auto VPN (spoke)
- [ ] Configure hub routing for user VLAN
- [ ] Decommission existing firewall (if any)

**Week 8: Council Bluffs MX68 Deployment**
- [ ] Install MX68 at Council Bluffs
- [ ] Cable Cox cable modem to WAN1
- [ ] Configure VLANs
- [ ] Configure Auto VPN (spoke)
- [ ] Configure hub routing for user VLAN
- [ ] Decommission Meraki Z3

---

### Phase 4: Remote User VPN Deployment (Weeks 9-10)

**Week 9: AnyConnect Deployment**
- [ ] Deploy AnyConnect client to pilot users (5-10)
- [ ] Test primary (Lincoln) and secondary (Omaha) connectivity
- [ ] Test automatic failover
- [ ] Configure MFA (Azure MFA or Duo)
- [ ] Test MFA authentication flow
- [ ] Document user instructions

**Week 10: Full Remote User Rollout**
- [ ] Deploy AnyConnect to all remote users
- [ ] User training and support
- [ ] Help desk training for AnyConnect troubleshooting
- [ ] Monitor and troubleshoot issues

---

### Phase 5: RapidScale Decommissioning and Finalization (Weeks 11-12)

**Week 11: RapidScale Cutover**
- [ ] Verify all offices on Meraki (no RapidScale dependency)
- [ ] Verify all remote users on AnyConnect/Client VPN
- [ ] Disconnect RapidScale VPN tunnels
- [ ] Cancel RapidScale contract

**Week 12: Monitoring, Training, Handoff**
- [ ] Configure Meraki dashboard alerting
- [ ] Train Berry Law IT on Meraki dashboard
- [ ] Document network architecture
- [ ] Handoff to managed services
- [ ] Schedule 30-day review

**Total Timeline: 12 weeks** (vs. 18 weeks for hybrid PA + Meraki)

---

## Cost Analysis

### Hardware and Licensing Costs

**Meraki MX Hardware:**

| Device | Location | Quantity | Unit Cost | Total |
|--------|----------|----------|-----------|-------|
| MX250 | Omaha (HA) | 2 | $8,500 | $17,000 |
| MX250 | Lincoln (HA) | 2 | $8,500 | $17,000 |
| MX75 | Papillion | 1 | $1,500 | $1,500 |
| MX68 | West Omaha | 1 | $750 | $750 |
| MX68 | Council Bluffs | 1 | $750 | $750 |
| **Total Hardware** | | **7** | | **$37,000** |

*Alternative: Lincoln single MX250 instead of HA = $28,500 total hardware*

**Meraki Licensing (Advanced Security):**

| Device | Annual Cost | 3-Year Cost |
|--------|-------------|-------------|
| MX250 (x4) | $1,800 each = $7,200 | $18,000 |
| MX75 (x1) | $650 | $1,625 |
| MX68 (x2) | $450 each = $900 | $2,250 |
| **Total Licensing** | **$8,750/year** | **$21,875 (3-year)** |

*3-year prepaid saves ~15% vs annual*

**Cisco AnyConnect Licensing (if used):**
- AnyConnect Plus or Apex license: ~$50-100/user/year
- 50 users: ~$2,500-5,000/year
- 3-year: ~$7,500-15,000

**Professional Services:**
- Design and planning: $8,000-12,000
- Implementation (12 weeks): $25,000-40,000
- Training and documentation: $3,000-5,000
- **Total Professional Services:** $36,000-57,000

### Total Cost Summary (Meraki-Only)

**Option A: Full HA (Omaha HA + Lincoln HA)**
- Hardware: $37,000
- Licensing (3-year prepaid): $21,875
- AnyConnect (3-year, 50 users): $10,000 (mid-estimate)
- Professional Services: $46,500 (mid-estimate)
- **Year 1 Total:** ~$115,375
- **3-Year Total:** ~$125,375

**Option B: Partial HA (Omaha HA + Lincoln Single)**
- Hardware: $28,500
- Licensing (3-year prepaid): $19,500
- AnyConnect (3-year, 50 users): $10,000
- Professional Services: $46,500
- **Year 1 Total:** ~$104,500
- **3-Year Total:** ~$114,500

---

## Architecture Comparison: Meraki-Only vs. Hybrid (PA + Meraki)

### Side-by-Side Comparison

| Aspect | Meraki-Only (On-Prem) | Hybrid (PA Azure + Meraki) |
|--------|----------------------|---------------------------|
| **Architecture** | Dual-hub (Omaha/Lincoln) | Cloud hub (Azure PA) + local Meraki |
| **User Security Gateway** | Omaha/Lincoln MX250 | Azure Palo Alto VM-Series |
| **Infrastructure Security** | Local Meraki MX | Local Meraki MX |
| **VPN (Site-to-Site)** | Meraki Auto VPN | Meraki Auto VPN |
| **VPN (Remote Users)** | AnyConnect to Omaha/Lincoln | GlobalProtect to Azure |
| **SSL/TLS Inspection** | No (limited HTTPS filtering) | Yes (full decryption) |
| **Application Control** | Basic (Layer 7) | Comprehensive (App-ID, 5,000+ apps) |
| **Data Loss Prevention** | No | Yes (content inspection) |
| **IPS/Anti-Malware** | Yes (Snort/AMP) | Yes (PA IPS + WildFire ML) |
| **URL Filtering** | Yes | Yes |
| **Cloud App Visibility** | Basic | Comprehensive |
| **Always-On VPN** | AnyConnect only (extra cost) | GlobalProtect (included) |
| **Pre-Logon VPN** | AnyConnect only | GlobalProtect (included) |
| **Single Vendor** | Yes (Cisco/Meraki) | No (Palo Alto + Meraki) |
| **Cloud Dependency** | No (on-prem hubs) | Yes (Azure PA firewall) |
| **Management Complexity** | Low (single dashboard) | Medium (PA + Meraki) |
| **Hub Bandwidth** | Consumed (user traffic through hub) | Not consumed (users direct to Azure) |
| **Scalability** | Limited by hub capacity | High (Azure scales easily) |

### Cost Comparison

| Cost Category | Meraki-Only | Hybrid (PA + Meraki) | Difference |
|---------------|-------------|---------------------|------------|
| **Hardware (Year 1)** | $37,000 | $11,400 | Meraki +$25,600 |
| **Licensing (3-Year)** | $32,000 | $63,000 | Meraki -$31,000 |
| **Azure Infrastructure (3-Year)** | $0 | $18,000-54,000 | Meraki -$18K-54K |
| **PA VM-Series (3-Year BYOL)** | $0 | $60,000-90,000 | Meraki -$60K-90K |
| **Professional Services** | $46,500 | $67,500 | Meraki -$21,000 |
| **3-Year Total** | **$115,500-125,500** | **$220,000-285,000** | **Meraki saves $95K-170K** |

### Security Comparison

| Security Capability | Meraki-Only | Hybrid | Winner |
|---------------------|-------------|--------|--------|
| SSL/TLS Inspection | No | Yes | **Hybrid** |
| Data Loss Prevention | No | Yes | **Hybrid** |
| Advanced App Control | Basic | Comprehensive | **Hybrid** |
| IPS/Threat Prevention | Good | Excellent | **Hybrid** |
| Anti-Malware | Good (AMP) | Excellent (WildFire ML) | **Hybrid** |
| URL Filtering | Good | Excellent | **Hybrid** |
| Always-On VPN | Extra cost | Included | **Hybrid** |
| Cloud App Visibility | Basic | Comprehensive | **Hybrid** |
| **Overall Security** | **Good** | **Excellent** | **Hybrid** |

### Operational Comparison

| Operational Aspect | Meraki-Only | Hybrid | Winner |
|--------------------|-------------|--------|--------|
| Single Vendor | Yes | No | **Meraki** |
| Management Simplicity | Excellent | Good | **Meraki** |
| Cloud Dependency | None | Yes (Azure) | **Meraki** |
| Hub Bandwidth | Consumed | Not consumed | **Hybrid** |
| Scalability | Hub-limited | High | **Hybrid** |
| Implementation Time | 12 weeks | 18 weeks | **Meraki** |
| Learning Curve | Low | Medium | **Meraki** |

---

## Compliance Considerations

### Attorney-Client Privilege Requirements

**Nebraska and Iowa State Bar Rules require:**
1. Confidentiality of client information
2. Reasonable measures to prevent unauthorized access
3. Encryption of sensitive communications
4. Protection against data breaches

### Meraki-Only Compliance Assessment

| Requirement | Meraki-Only Capability | Assessment |
|-------------|------------------------|------------|
| **Encrypted Communications** | VPN encryption (AES-256) | **Meets** |
| **Unauthorized Access Prevention** | Firewall, IPS, AMP | **Meets** |
| **Data Loss Prevention** | No native DLP | **Gap** |
| **Cloud App Control** | Basic application control | **Partial** |
| **SSL Inspection** | Limited (no full decrypt) | **Gap** |
| **Audit Trail** | Logging and reporting | **Meets** |

**Gaps Identified:**
1. **No DLP:** Cannot prevent attorneys from uploading client files to personal cloud storage
2. **Limited SSL Inspection:** Cannot see encrypted data leaving the network
3. **Basic App Control:** Cannot distinguish personal vs. business cloud apps

**Gap Mitigations:**
- Implement Microsoft Purview DLP (requires M365 E5 or add-on license)
- Deploy endpoint DLP agents
- Create acceptable use policies and user training
- Accept increased risk vs. hybrid approach

### Hybrid Compliance Assessment

| Requirement | Hybrid Capability | Assessment |
|-------------|-------------------|------------|
| **Encrypted Communications** | GlobalProtect VPN + Auto VPN | **Meets** |
| **Unauthorized Access Prevention** | PA IPS, WildFire + Meraki | **Exceeds** |
| **Data Loss Prevention** | PA DLP with content inspection | **Meets** |
| **Cloud App Control** | App-ID (5,000+ apps) | **Meets** |
| **SSL Inspection** | Full SSL decryption | **Meets** |
| **Audit Trail** | Comprehensive logging | **Exceeds** |

**Recommendation:** Hybrid approach better meets compliance requirements for attorney-client privilege protection. Meraki-only requires additional mitigations (M365 E5 DLP, endpoint protection) to close security gaps.

---

## Recommendation Summary

### When to Choose Meraki-Only

**Choose Meraki-Only if:**
- **Budget is primary concern** (~$95K-170K savings over 3 years)
- **Simplicity is valued** (single vendor, single dashboard)
- **Cloud dependency is undesirable** (all on-premises)
- **Advanced threat detection is acceptable** (good but not excellent)
- **DLP can be addressed through M365** (M365 E5 or Purview add-on)
- **Implementation speed is critical** (12 weeks vs. 18 weeks)

**Meraki-Only Risks to Accept:**
- No SSL inspection (encrypted traffic blind spots)
- No native DLP (requires M365 or accept gap)
- Basic app control (less granular than PA)
- Hub bandwidth consumption (Omaha/Lincoln carry branch traffic)
- Hub capacity limits scalability

### When to Choose Hybrid (PA + Meraki)

**Choose Hybrid if:**
- **Attorney-client privilege compliance is paramount** (DLP, SSL inspection)
- **Advanced threat detection is required** (WildFire ML, comprehensive App-ID)
- **Cloud application visibility is important** (shadow IT detection)
- **Scalability is needed** (Azure scales easily, no hub bandwidth limits)
- **Always-on VPN without extra cost** (GlobalProtect included)
- **Budget allows for investment** (~$95K-170K more over 3 years)

**Hybrid Benefits:**
- Full SSL inspection (see all traffic)
- Native DLP (prevent data exfiltration)
- Comprehensive App-ID (5,000+ apps)
- WildFire ML (advanced malware analysis)
- GlobalProtect always-on (included, no AnyConnect cost)
- No hub bandwidth consumption (users go direct to Azure)

### Our Recommendation for Berry Law

**Primary Recommendation: Hybrid (PA + Meraki)**

**Rationale:**
1. **Compliance:** Legal firms handling attorney-client privileged information require advanced security (DLP, SSL inspection) that Meraki-only cannot provide natively
2. **Data Protection:** PA DLP can prevent attorneys from inadvertently uploading client files to personal cloud storage (critical compliance requirement)
3. **Threat Detection:** WildFire ML analysis provides superior malware detection for high-stakes law firm
4. **Cloud Visibility:** App-ID provides comprehensive visibility into cloud app usage (important for law firm risk management)
5. **Budget Justification:** Additional ~$95K-170K investment over 3 years is justified by significantly improved security posture and compliance

**Alternative Recommendation: Meraki-Only with M365 E5**

**If budget is the primary constraint:**
1. Deploy Meraki-only architecture (this document)
2. Upgrade to Microsoft 365 E5 or add Microsoft Purview DLP
3. Deploy Microsoft Defender for Endpoint on all workstations
4. Accept limited SSL inspection capability (endpoint protection compensates partially)
5. Implement strong acceptable use policies and user training

**M365 E5 Addition Cost:**
- M365 E5 vs. E3: ~$22/user/month additional
- 50 users: ~$13,200/year additional
- 3-year: ~$39,600 additional

**Meraki-Only + M365 E5 Total (3-year):** ~$155,000-165,000
**Still saves ~$65K-120K vs. Hybrid**

---

## Appendix A: Meraki MX Model Specifications

### MX250 (Hub Sites)
- Stateful Firewall Throughput: 1 Gbps
- VPN Throughput: 500 Mbps
- Maximum VPN Tunnels: 500
- Concurrent Client VPN Users: 1,000
- WAN Ports: 2x 1GbE
- LAN Ports: 8x 1GbE
- Recommended Users: 500-2,000
- Use Case: Large branch or hub site

### MX95 (Alternative for Omaha/Lincoln)
- Stateful Firewall Throughput: 500 Mbps
- VPN Throughput: 450 Mbps
- Maximum VPN Tunnels: 250
- Concurrent Client VPN Users: 500
- WAN Ports: 2x 1GbE
- LAN Ports: 8x 1GbE
- Recommended Users: 250-1,000
- Use Case: Medium branch or secondary hub
- **Note:** MX95 may be insufficient for hub duties; MX250 recommended for hubs

### MX75 (Branch Site)
- Stateful Firewall Throughput: 350 Mbps
- VPN Throughput: 300 Mbps
- Maximum VPN Tunnels: 75
- WAN Ports: 2x 1GbE
- LAN Ports: 12x 1GbE
- Recommended Users: 50-200
- Use Case: Medium branch office

### MX68 (Small Branch)
- Stateful Firewall Throughput: 250 Mbps
- VPN Throughput: 200 Mbps
- Maximum VPN Tunnels: 50
- WAN Ports: 2x 1GbE
- LAN Ports: 12x 1GbE
- Recommended Users: 25-50
- Use Case: Small branch or home office

---

## Appendix B: AnyConnect Licensing Options

### Cisco AnyConnect Licensing Tiers

**AnyConnect Plus:**
- Basic VPN connectivity
- Network visibility (basic)
- ~$50/user/year (approximate)
- Sufficient for most use cases

**AnyConnect Apex:**
- All Plus features
- Network Access Manager
- Web Security
- Umbrella Roaming
- ~$100/user/year (approximate)
- Recommended for enhanced security

**AnyConnect VPN Only (Meraki included):**
- Basic VPN via Meraki MX
- No additional cost (included with Meraki licensing)
- Limited features vs. full AnyConnect
- Suitable if always-on VPN is not required

**Recommendation:** AnyConnect Plus for always-on VPN with automatic failover. Budget ~$50-75/user/year.

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
