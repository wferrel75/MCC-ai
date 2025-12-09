# Berry Law - Customer Profile
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Berry Law (John S. Berry Law, PC)
**Website:** https://jsberrylaw.com/
**Main Phone:** 402-466-8444 (24/7 availability)
**Profile Created Date:**
**Last Updated:**
**Account Manager:**
**Primary Technical Contact:**
**Industry/Vertical:** Legal Services / Law Firm
**Practice Areas:** Personal Injury Law, Veterans Law/Appeals, Mass Torts

---

## Business Overview

### Company Information
- **Number of Employees:** Approximately 30+ attorneys plus support staff
- **Number of IT Staff:**
- **Annual Revenue Range:**
- **Business Type:** [X] B2B [X] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** 24/7 operations (emergency consultations available)
- **Time Zone(s):** Central Time (CT)
- **Service Coverage:** 50-mile radius from Lincoln/Omaha; Nebraska and Iowa
- **Geographic Markets:** Omaha, Lincoln, Bellevue, Papillion, Grand Island, Sarpy County, Seward (NE); Council Bluffs (IA)

### Business Objectives
**Primary Business Goals:**
- Provide 24/7 client access and emergency consultation availability
- Deliver "best possible outcome" for personal injury and veterans law cases
- Maintain multi-location presence across Nebraska and Iowa
- Handle high-stakes personal injury, mass tort, and veterans appeals cases

**Technology Initiatives (Next 12 Months):**
- TBD - To be discussed with customer
-
-

**Pain Points/Challenges:**
- 24/7 operations require reliable connectivity and system availability
- Multi-office coordination across Nebraska and Iowa
- Secure handling of sensitive client information (attorney-client privilege)
- Case management across distributed offices
- Potential need for video conferencing for client consultations

---

## User Profile

### User Count by Category
```
Total Users: ___
├─ Executive/Leadership: ___
├─ Knowledge Workers (Office/Hybrid): ___
├─ Remote Workers: ___
├─ Field/Mobile Workers: ___
├─ Factory/Warehouse Workers: ___
├─ Contractors/Temporary: ___
└─ Service Accounts/Shared Mailboxes: ___
```

### User Distribution
- **Users requiring full M365 licenses:**
- **Users requiring basic email only:**
- **Users requiring specialized apps:**
- **External collaborators/partners:**

### Work Patterns
- **Percentage Remote Workers:**
- **Percentage Hybrid Workers:**
- **Percentage On-Site Only:**
- **BYOD Policy:** [ ] Allowed [ ] Restricted [ ] Prohibited
- **Mobile Device Types:** [ ] iOS [ ] Android [ ] Windows [ ] Other: ___

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Omaha Office (OMA)"
    address: "1414 Harney St, Suite 400, Omaha, NE 68102"
    user_count:
    internet_provider: "Cox Fiber, UPN Fiber"
    bandwidth_down: "1 Gbps (each connection)"
    bandwidth_up: "1 Gbps (each connection)"
    site_type: [X] Primary [ ] Branch [ ] Remote Office [ ] Data Center
    edge_device: "VMWare Edge Pair"
    switches: ["OMA-SW-01", "OMA-SW-02"]
    wireless: "Access Points"
    connectivity: "SD-WAN VPN to RapidScale"
    redundancy: "Dual ISP (Cox + UPN)"

  - name: "Lincoln Office (LNK)"
    address: "6940 O St, Suite 400, Lincoln, NE 68510"
    user_count:
    internet_provider: "Cox Fiber, UPN Fiber, Allo Fiber"
    bandwidth_down: "1 Gbps (each connection)"
    bandwidth_up: "1 Gbps (each connection)"
    site_type: [X] Primary [ ] Branch [ ] Remote Office [ ] Data Center
    edge_device: "VMWare Edge Pair"
    switches: ["LNK-SW-01", "LNK-SW-02", "LNK-SW-03"]
    wireless: "Access Points"
    connectivity: "SD-WAN VPN to RapidScale"
    redundancy: "Triple ISP (Cox + UPN + Allo)"

  - name: "Papillion Office (PAP)"
    address: "TBD - Papillion, NE (confirmed service area)"
    user_count:
    internet_provider: "Cox Fiber"
    bandwidth_down: "1 Gbps"
    bandwidth_up: "1 Gbps"
    site_type: [ ] Primary [X] Branch [ ] Remote Office [ ] Data Center
    edge_device: "Fortigate 40F"
    switches: ["OMA-SW-02 (shared naming)"]
    wireless: "Access Points"
    connectivity: "Direct Internet (no VPN tunnel)"
    redundancy: "Single ISP (no redundancy)"

  - name: "West Omaha Office"
    address: ""
    user_count:
    internet_provider: "Cox Cable Modem"
    bandwidth_down: "TBD (typically 100-500 Mbps)"
    bandwidth_up: "TBD (typically 10-50 Mbps)"
    site_type: [ ] Primary [X] Branch [ ] Remote Office [ ] Data Center
    edge_device: "TBD"
    switches: []
    wireless: "TBD"
    connectivity: "Direct Internet - Not shown in network diagram"
    redundancy: "Single ISP (no redundancy)"
    notes: "Configuration details needed - Cable modem (lower tier than fiber)"

  - name: "Council Bluffs Office (Iowa)"
    address: "215 S Main St, Suite 206, Council Bluffs, IA 51503"
    user_count:
    internet_provider: "Cox Cable Modem"
    bandwidth_down: "TBD (typically 100-500 Mbps)"
    bandwidth_up: "TBD (typically 10-50 Mbps)"
    site_type: [ ] Primary [X] Branch [ ] Remote Office [ ] Data Center
    edge_device: "Meraki Z3"
    switches: "None (endpoints connect directly to Z3)"
    wireless: "Integrated in Meraki Z3"
    connectivity: "Direct Internet (no VPN tunnel)"
    redundancy: "Single ISP (no redundancy)"
    notes: "Cable modem service (lower tier than fiber)"
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [ ] Site-to-Site VPN [X] SD-WAN [ ] None [ ] Other: ___
- **Primary WAN Provider:** RapidScale (Cloud Hosting Provider)
- **Backup/Redundant Connections:** [X] Yes [ ] No
  - Details:
    - **Lincoln:** Triple ISP redundancy (Cox Fiber + UPN Fiber + Allo Fiber) - 1 Gbps each
    - **Omaha:** Dual ISP redundancy (Cox Fiber + UPN Fiber) - 1 Gbps each
    - **Papillion:** Single ISP only (Cox Fiber) - 1 Gbps
    - **West Omaha:** Single ISP only (Cox Cable Modem) - Speed TBD
    - **Council Bluffs:** Single ISP only (Cox Cable Modem) - Speed TBD

**Connectivity Architecture:**
- **Hub:** RapidScale Cloud (Fortigate Virtual Firewall)
- **SD-WAN Sites:** Omaha (OMA), Lincoln (LNK) - Connected via SD-WAN VPN to RapidScale with redundant ISPs
- **Direct Internet Sites:** Papillion (PAP), Council Bluffs (Iowa), West Omaha - No VPN tunnel, direct internet only
- **Fiber vs Cable:** Primary offices have fiber; branch offices have mix of fiber (Papillion) and cable modem (West Omaha, Council Bluffs)

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:**
  - RapidScale Cloud: Fortigate Virtual Firewall (central hub)
  - Omaha/Lincoln: VMWare Edge Pairs (SD-WAN endpoints)
  - Papillion: Fortigate 40F
  - Council Bluffs: Meraki Z3
  - West Omaha: Unknown
- **Firmware Version:**
- **Management:** [ ] Cloud-Managed [ ] On-Prem [X] Hybrid
- **Features in Use:** [X] VPN [X] Content Filtering [X] IPS/IDS [X] Application Control

**Network Equipment:**
- **Switch Vendor/Model:**
  - Omaha: OMA-SW-01, OMA-SW-02
  - Lincoln: LNK-SW-01, LNK-SW-02, LNK-SW-03
  - Papillion: OMA-SW-02 (shares naming with Omaha switches)
  - Council Bluffs: None (direct to Meraki Z3)
  - West Omaha: Unknown
- **Wireless AP Vendor/Model:**
  - Access Points deployed at Omaha, Lincoln, Papillion
  - Council Bluffs: Integrated wireless in Meraki Z3
  - Vendor/Model specifics: TBD
- **Network Management:** [ ] Ubiquiti (UniFi) [ ] Cisco Meraki [X] Aruba [ ] Other: Mixed (VMWare, Fortigate, Meraki)

**Network Services:**
- **DHCP Server:** [ ] Firewall [ ] Windows Server [ ] Router [ ] Other: ___
- **DNS Services:** [ ] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:**
- **VLANs Configured:** [ ] Yes [ ] No
  - VLAN Details:

### Internet & WAN
- **Primary Internet Speed:**
- **Backup Internet:** [ ] Yes [ ] No
- **Public IP Addresses:** [ ] Static [ ] Dynamic [ ] Number of IPs: ___

### Remote Access
- **VPN Solution:**
- **VPN Concurrent Users:**
- **Remote Desktop Solution:** [ ] RDP [ ] VPN [ ] Third-party: ___
- **Cloud Access Method:** [ ] Direct Internet [ ] VPN [ ] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):**
- **Primary Domain:**
- **Additional Domains:**
- **Tenant Type:** [ ] Commercial [ ] GCC [ ] GCC High [ ] DoD

**Current Licenses (by SKU and count):**
```
SKU Name                                    | Count | Notes
-------------------------------------------|-------|-------
Microsoft 365 E3                           |       |
Microsoft 365 E5                           |       |
Microsoft 365 Business Premium             |       |
Office 365 E1                              |       |
Teams Phone Standard                       |       |
Audio Conferencing                         |       |
Power BI Pro                               |       |
[Other]                                    |       |
```

**M365 Services in Use:**
- [ ] Exchange Online (Email)
- [ ] SharePoint Online
- [ ] OneDrive for Business
- [ ] Teams (Chat/Meetings)
- [ ] Teams Phone System
- [ ] Intune (MDM/MAM)
- [ ] Azure AD Premium (which tier: ___)
- [ ] Defender for Office 365 (P1/P2)
- [ ] Microsoft Defender for Endpoint
- [ ] Microsoft Purview (Compliance)
- [ ] Power Platform (Power Apps, Power Automate)
- [ ] Other: ___

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller"
    os: ""
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: ""

  - role: "File Server"
    os: ""
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: ""

  - role: ""
    os: ""
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: ""
```

**Active Directory:**
- **Domain Name:**
- **Forest Functional Level:**
- **Azure AD Connect:** [ ] Yes [ ] No [ ] Cloud Sync
- **Hybrid Configuration:** [ ] Yes [ ] No
- **Number of Domain Controllers:**

**File Storage:**
- **File Server Location:** [ ] On-Prem [ ] Cloud [ ] Hybrid
- **Total Storage Capacity:**
- **Current Usage:**
- **Backup Solution:**

**Database Servers:**
- **SQL Server:** [ ] Yes [ ] No | Version: ___ | Databases: ___
- **Other Databases:**

### Line of Business Applications
```
Application Name              | Vendor      | Hosting         | Users | Cloud-Ready?
------------------------------|-------------|-----------------|-------|-------------
Case Management System (TBD)  | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Document Management (TBD)     | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Time/Billing System (TBD)     | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Client Portal (TBD)           | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
```

**Typical Law Firm Applications to Document:**
- Practice Management Software (Clio, MyCase, PracticePanther, etc.)
- Document Management System (NetDocuments, iManage, etc.)
- Time & Billing Software
- Client Relationship Management (CRM)
- eDiscovery/Litigation Support Tools
- Electronic Filing Systems (for court documents)
- Client Intake/Portal Software

**Critical Dependencies:**
- Case management system availability (24/7 for emergency consultations)
- Secure client communication systems
- Document storage and retrieval systems

---

## Security & Compliance

### Security Posture
**Current Security Solutions:**
- **Antivirus/Endpoint Protection:**
- **EDR/MDR Solution:**
- **Email Security:**
- **Web/Content Filtering:**
- **SIEM/Log Management:**
- **Backup Solution:**
  - **Backup Frequency:**
  - **Retention Period:**
  - **Offsite/Cloud Backup:** [ ] Yes [ ] No

**Multi-Factor Authentication:**
- **MFA Enabled:** [ ] Yes [ ] No [ ] Partial
- **MFA Method:** [ ] Microsoft Authenticator [ ] SMS [ ] Hardware Token [ ] Other: ___
- **MFA Coverage:** ___% of users

**Conditional Access:**
- **Policies Configured:** [ ] Yes [ ] No
- **Number of Policies:**
- **Key Policies:**

### Compliance Requirements
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [ ] CMMC [ ] None [X] Other: Legal/Bar Requirements
  - **Specific Requirements:**
    - Attorney-Client Privilege protection (confidentiality)
    - Nebraska State Bar ethical rules
    - Iowa State Bar ethical rules (multi-state practice)
    - ABA Model Rules of Professional Conduct
    - Duty of confidentiality for client information
    - Secure communication requirements
- **Data Retention Requirements:** Legal case files require long-term retention (varies by case type, typically 7+ years)
- **eDiscovery Needs:** [X] Yes [ ] No (essential for litigation support)
- **Data Loss Prevention (DLP):** [X] Required [ ] Nice-to-have [ ] Not needed
  - **Reasoning:** Attorney-client privilege requires preventing unauthorized disclosure of client information

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [ ] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [ ] Frequent [ ] Occasional [ ] Rare
- **Security Training:** [ ] Regular [ ] Annual [ ] None

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [ ] On-Prem PBX [ ] Cloud PBX [ ] Teams Phone [ ] Other: ___
- **Vendor/Model:**
- **Number of Lines/Extensions:**
- **Auto Attendant/Call Queue:** [ ] Yes [ ] No
- **Conference Room Phones:**
- **Analog Lines (Fax/Alarm):**

### Teams Voice
- **Teams Phone Deployment:** [ ] Yes [ ] No [ ] Planned
- **PSTN Connectivity:** [ ] Calling Plan [ ] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911):** [ ] Configured [ ] Not Configured [ ] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:**
- **Items Backed Up:** [ ] Servers [ ] Workstations [ ] M365 [ ] Databases
- **M365 Backup:** [ ] Native [ ] Third-Party: ___ [ ] None
- **Backup Testing Frequency:**

### Disaster Recovery
- **DR Plan Documented:** [ ] Yes [ ] No
- **RTO (Recovery Time Objective):**
- **RPO (Recovery Point Objective):**
- **DR Site/Failover:** [ ] Yes [ ] No | Location: ___
- **Cloud DR Strategy:**

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [ ] ConnectWise Automate [ ] N-able [ ] Other: ___ [ ] None
- **Monitoring Coverage:** [ ] All devices [ ] Servers only [ ] None
- **Alert Response Time SLA:**

### Help Desk/Ticketing
- **PSA/Ticketing System:**
- **User Self-Service Portal:** [ ] Yes [ ] No
- **Current Response Time:**

---

## Budget & Timeline

### Budget Information
- **IT Budget (Annual):**
- **Spending Breakdown:**
  - Hardware: ___%
  - Software/Licenses: ___%
  - Services/Support: ___%
  - Projects: ___%

- **Capital Available for Projects:**
- **OpEx vs CapEx Preference:** [ ] Prefer OpEx [ ] Prefer CapEx [ ] No preference

### Timeline & Priorities
**Immediate Needs (0-30 days):**
-
-

**Short-Term Projects (1-6 months):**
-
-

**Long-Term Goals (6-12+ months):**
-
-

**Budget Approval Process:**
**Decision Maker(s):**

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name     | Service Provided           | Contract Term | Satisfaction
----------------|---------------------------|---------------|-------------
RapidScale      | Cloud Hosting / SD-WAN Hub|               | [1-5]
                |                           |               | [1-5]
                |                           |               | [1-5]
```

### MSP Service Expectations
- **Desired Service Level:** [ ] Co-Managed IT [ ] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [ ] Email [ ] Phone [ ] Teams [ ] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [ ] Bi-Weekly [ ] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:**

---

## Additional Notes

### Special Considerations
```
Network Architecture:
- Hub-and-spoke topology with RapidScale cloud as central hub
- Mixed connectivity: SD-WAN VPN (Omaha/Lincoln) vs Direct Internet (Papillion/Council Bluffs/West Omaha)
- Branch offices (Papillion, Council Bluffs, West Omaha) have direct internet without VPN tunnels - security concern
- West Omaha office not documented in current network diagram - needs discovery
- Mixed vendor environment: VMWare, Fortigate, Meraki
- Switch naming inconsistency (Papillion shows OMA-SW-02, same as Omaha)

Internet Connectivity Tiers:
- Tier 1 (Best): Lincoln - 3x 1Gbps fiber (Cox + UPN + Allo) with SD-WAN
- Tier 2 (Good): Omaha - 2x 1Gbps fiber (Cox + UPN) with SD-WAN
- Tier 3 (Adequate): Papillion - 1x 1Gbps fiber (Cox) without VPN
- Tier 4 (Limited): West Omaha, Council Bluffs - Cox cable modem (speed TBD, typically asymmetric) without VPN

Industry Vertical:
- Personal Injury and Veterans Law Firm - Subject to attorney-client privilege protections
- Approximately 30+ attorneys plus support staff across 5 locations
- 24/7 operations for emergency consultations require high availability
- Compliance requirements include data security, confidentiality, and state bar regulations (NE, IA)
- Branch offices without VPN represent potential security/compliance risk for attorney-client communications
- High-stakes cases (personal injury, mass torts, veterans appeals) require secure document handling
- Multi-state operations (Nebraska and Iowa) may have different regulatory requirements
```

### Customer Strengths
```
Internet Connectivity & Redundancy:
- Excellent ISP redundancy at primary offices (Lincoln with 3 ISPs, Omaha with 2 ISPs)
- All fiber connections at primary offices providing symmetric 1 Gbps speeds
- SD-WAN deployment at primary offices provides intelligent failover and load balancing
- Hub-and-spoke architecture with RapidScale provides centralized security and management

Business Continuity Planning:
- Multiple ISPs at critical locations ensures high availability
- Geographic distribution across Nebraska and Iowa
```

### Opportunities for Improvement
```
Network Security & Architecture:
1. Extend SD-WAN VPN connectivity to Papillion and Council Bluffs offices for better security
2. Document and assess West Omaha office network configuration
3. Standardize switch naming conventions across all sites
4. Consider unified network management platform to reduce vendor fragmentation
5. Implement consistent security policies across all branch locations

Internet Connectivity Improvements:
1. Upgrade West Omaha and Council Bluffs from cable modem to fiber for better reliability/performance
2. Consider adding backup ISPs to branch offices (Papillion, West Omaha, Council Bluffs)
3. Document actual cable modem speeds for West Omaha and Council Bluffs
4. Evaluate if cable modem asymmetric upload speeds impact business operations

Security Considerations for Law Firm:
- Ensure encrypted communications between all offices and cloud resources (especially branches without VPN)
- Implement DLP policies for client data protection
- Consider compliance requirements (attorney-client privilege, state bar rules)
- Evaluate backup/DR strategy for legal documents and case files
- Address security risk of branch offices with direct internet access (no VPN tunnel)
```

---

## Profile Completion Checklist
- [ ] Basic customer information completed
- [ ] User counts and distribution documented
- [ ] All office locations documented with network details
- [ ] Current Microsoft 365 licensing documented
- [ ] Security posture assessed
- [ ] Backup strategy documented
- [ ] Pain points and objectives identified
- [ ] Budget and timeline discussed
- [ ] Profile reviewed with customer
- [ ] Profile reviewed with technical team

**Profile Completed By:** ___________________
**Date:** ___________________
**Next Review Date:** ___________________
