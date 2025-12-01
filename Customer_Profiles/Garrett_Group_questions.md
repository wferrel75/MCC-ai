# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** The Garrett Group
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Defense Contracting/Intelligence Services

---

## Business Overview

### Company Information
- **Number of Employees:** 95%+ with military/government service background
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [ ] B2B [x] B2C [x] B2B2C [ ] Non-Profit [x] Government
- **Critical Business Hours:** 24/7/365 (federal defense sector operations)
- **Time Zone(s):** Central Time (CT) - Sarpy County, Nebraska

### Business Objectives
**Primary Business Goals:**
- Deliver specialized intelligence operations and military operational planning solutions
- Maintain CMMI certification and government security clearances
- Support U.S. Government federal defense sector clients with mission-critical services
- Win and execute complex defense contracting engagements with highest security standards

**Technology Initiatives (Next 12 Months):**
- Enhance cybersecurity posture for classified information handling
- Upgrade IT infrastructure to meet evolving CMMC requirements
- Implement advanced threat detection and response capabilities
- Ensure compliance with Federal Acquisition Regulation (FAR) and Defense Federal Acquisition Regulation Supplement (DFARS)

**Pain Points/Challenges:**
- Managing classified and sensitive government information securely
- Maintaining compliance with evolving federal security standards (NIST, CMMC, etc.)
- Supporting personnel with active security clearances
- Meeting stringent audit and compliance requirements for federal contracts

---

## User Profile

### User Count by Category
```
Total Users: TBD (majority with security clearances)
├─ Executive/Leadership: 5-10
├─ Knowledge Workers (Office/Hybrid): 20-30 (intelligence analysts, planners)
├─ Remote Workers: 10-15 (secure remote access required)
├─ Field/Mobile Workers: TBD
├─ Factory/Warehouse Workers: N/A
├─ Contractors/Temporary: TBD
└─ Service Accounts/Shared Mailboxes: TBD
```

### User Distribution
- **Users requiring full M365 licenses:** 30-40
- **Users requiring basic email only:** TBD
- **Users requiring specialized apps:** Classified communication systems, intelligence analysis tools, secure collaboration platforms
- **External collaborators/partners:** U.S. Government agencies, federal contractors (with proper clearances)

### Work Patterns
- **Percentage Remote Workers:** 20-30% (with strict VPN/access controls)
- **Percentage Hybrid Workers:** 40-50%
- **Percentage On-Site Only:** 20-30% (secure facility required)
- **BYOD Policy:** [ ] Allowed [x] Restricted [x] Prohibited
- **Mobile Device Types:** [ ] iOS [x] Android [x] Windows [ ] Other: Government-issued mobile devices only

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "The Garrett Group - Main Operations Center"
    address: "Sarpy County, Nebraska"
    user_count: 35-45
    internet_provider: TBD
    bandwidth_down: TBD
    bandwidth_up: TBD
    site_type: [x] Primary [ ] Branch [ ] Remote Office [x] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [x] Site-to-Site VPN [ ] SD-WAN [x] Other: Dedicated secure government networks
- **Primary WAN Provider:** Federal government secure networks (DISA, etc.)
- **Backup/Redundant Connections:** [x] Yes [ ] No
  - Details: Redundant secure connections to government networks and backup facilities

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:** TBD (must meet NIST/CMMC requirements)
- **Firmware Version:** TBD
- **Management:** [ ] Cloud-Managed [x] On-Prem [ ] Hybrid
- **Features in Use:** [x] VPN [x] Content Filtering [x] IPS/IDS [x] Application Control

**Network Equipment:**
- **Switch Vendor/Model:** TBD (government-approved vendors)
- **Wireless AP Vendor/Model:** TBD (secure 802.1X required)
- **Network Management:** [ ] Ubiquiti (UniFi) [ ] Cisco Meraki [ ] Aruba [x] Other: Government-standard network management

**Network Services:**
- **DHCP Server:** [ ] Firewall [x] Windows Server [ ] Router [ ] Other: ___
- **DNS Services:** [x] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** TBD (government-compliant addressing scheme)
- **VLANs Configured:** [x] Yes [ ] No
  - VLAN Details: Strict segmentation - classified systems, unclassified systems, guest network, operations network

### Internet & WAN
- **Primary Internet Speed:** TBD
- **Backup Internet:** [x] Yes [ ] No
- **Public IP Addresses:** [x] Static [ ] Dynamic [ ] Number of IPs: TBD (government-assigned)

### Remote Access
- **VPN Solution:** Multi-factor authenticated VPN with certificate-based authentication
- **VPN Concurrent Users:** 10-20
- **Remote Desktop Solution:** [x] RDP [x] VPN [x] Third-party: Government-approved secure access systems
- **Cloud Access Method:** [ ] Direct Internet [x] VPN [x] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** TBD
- **Additional Domains:** TBD
- **Tenant Type:** [x] Commercial [ ] GCC [x] GCC High [ ] DoD

**Current Licenses (by SKU and count):**
```
SKU Name                                    | Count | Notes
-------------------------------------------|-------|-------
Microsoft 365 E5                           | 25-35 | Full compliance suite required
Microsoft 365 GCC High                     | 10-15 | For sensitive government work
Office 365 E1                              | TBD   |
Teams Phone Standard                       | 15-20 | Secure communications
Audio Conferencing                         | 5-10  | Classified discussions
Power BI Pro                               | 5-10  | Intelligence analysis
Information Protection (P2)                | 30-40 | Classified document handling
Defender for Endpoint                      | 30-40 | Threat detection
[Other]                                    | TBD   |
```

**M365 Services in Use:**
- [x] Exchange Online (Email)
- [x] SharePoint Online
- [x] OneDrive for Business
- [x] Teams (Chat/Meetings)
- [x] Teams Phone System
- [x] Intune (MDM/MAM)
- [x] Azure AD Premium (which tier: P2)
- [x] Defender for Office 365 (P1/P2)
- [x] Microsoft Defender for Endpoint
- [x] Microsoft Purview (Compliance)
- [x] Power Platform (Power Apps, Power Automate)
- [x] Other: Azure Information Protection for classified document marking/handling

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller"
    os: "Windows Server 2022"
    virtualization: [x] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Sarpy County Operations Center"

  - role: "File Server"
    os: "Windows Server 2022"
    virtualization: [x] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Sarpy County Operations Center"

  - role: "Intelligence Analysis Platform"
    os: "Linux/Windows"
    virtualization: [ ] Physical [x] Hyper-V [x] VMware [ ] Azure
    location: "Sarpy County Operations Center"

  - role: "Security Operations Center (SOC) Systems"
    os: "Windows Server 2022"
    virtualization: [ ] Physical [x] Hyper-V [x] VMware [ ] Azure
    location: "Sarpy County Operations Center"

  - role: "Classified Network Server"
    os: "Windows Server 2022"
    virtualization: [x] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Sarpy County Operations Center"
```

**Active Directory:**
- **Domain Name:** TBD
- **Forest Functional Level:** TBD (Windows 2016 or higher)
- **Azure AD Connect:** [x] Yes [ ] No [ ] Cloud Sync
- **Hybrid Configuration:** [x] Yes [ ] No
- **Number of Domain Controllers:** 3+ (redundancy required)

**File Storage:**
- **File Server Location:** [x] On-Prem [ ] Cloud [ ] Hybrid
- **Total Storage Capacity:** TBD
- **Current Usage:** TBD
- **Backup Solution:** Classified data backup (secure, encrypted, government-approved)

**Database Servers:**
- **SQL Server:** [x] Yes [ ] No | Version: 2019/2022 | Databases: Intelligence data, classified information, operations logs
- **Other Databases:** Proprietary intelligence databases, classified analysis systems

### Line of Business Applications
```
Application Name                    | Vendor      | Hosting         | Users | Cloud-Ready?
------------------------------------|-------------|-----------------|-------|-------------
Intelligence Analysis Platform      | TBD         | On-Prem         | 20-25 | N
Military Operational Planning Tool  | TBD         | On-Prem         | 15-20 | N
Personnel Security Clearance Mgmt   | TBD         | [On-Prem/Cloud] | 10-15 | Y
Secure Document Management          | TBD         | [On-Prem/Cloud] | 30-40 | N
Physical Security System            | TBD         | On-Prem         | TBD   | N
Modeling & Simulation Suite         | TBD         | On-Prem         | 10-15 | N
Classified Communications Platform  | TBD         | On-Prem         | 25-35 | N
IT/Cybersecurity Defense Suite      | TBD         | On-Prem         | 15-20 | N
```

**Critical Dependencies:**
- Uninterrupted availability of intelligence analysis systems
- Secure classified document handling and storage
- Compliance with federal security standards (NIST SP 800-171, CMMC, DFARS)
- Personnel security clearance management and tracking
- Multi-factor authentication for all classified system access

---

## Security & Compliance

### Security Posture
**Current Security Solutions:**
- **Antivirus/Endpoint Protection:** Government-approved endpoint protection (Defender for Endpoint)
- **EDR/MDR Solution:** Microsoft Defender for Endpoint with 24/7 SOC monitoring
- **Email Security:** Defender for Office 365 (P2) with advanced phishing/malware protection
- **Web/Content Filtering:** TBD
- **SIEM/Log Management:** TBD (NIST-compliant logging and monitoring)
- **Backup Solution:** Classified data backup solution (government-approved)
  - **Backup Frequency:** Continuous/real-time for critical systems
  - **Retention Period:** Per government data retention regulations
  - **Offsite/Cloud Backup:** [x] Yes [ ] No (Government-approved secure backup facility)

**Multi-Factor Authentication:**
- **MFA Enabled:** [x] Yes [ ] No [ ] Partial
- **MFA Method:** [x] Microsoft Authenticator [x] Hardware Token [ ] SMS [ ] Other: Government PKI certificates
- **MFA Coverage:** 100% of users

**Conditional Access:**
- **Policies Configured:** [x] Yes [ ] No
- **Number of Policies:** 10+
- **Key Policies:** Location-based access control, device compliance mandatory, time-based restrictions for sensitive roles, classified data access gates

### Compliance Requirements
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [x] CMMC [x] Other: NIST SP 800-171, DFARS, FAR, Executive Order 14028
- **Data Retention Requirements:** Per federal records management standards (7-25 years depending on document classification)
- **eDiscovery Needs:** [x] Yes [ ] No (For federal investigations and legal holds)
- **Data Loss Prevention (DLP):** [x] Required [ ] Nice-to-have [ ] Not needed

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [x] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [ ] Frequent [x] Occasional [ ] Rare
- **Security Training:** [x] Regular [ ] Annual [ ] None (CMMC-mandated security awareness training)

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [ ] On-Prem PBX [x] Cloud PBX [x] Teams Phone [ ] Other: ___
- **Vendor/Model:** Microsoft Teams Phone (government-compliant tenant)
- **Number of Lines/Extensions:** 20-30
- **Auto Attendant/Call Queue:** [x] Yes [ ] No
- **Conference Room Phones:** Secure conference systems with encrypted calling
- **Analog Lines (Fax/Alarm):** Secure fax system for classified documents

### Teams Voice
- **Teams Phone Deployment:** [x] Yes [ ] No [ ] Planned
- **PSTN Connectivity:** [x] Calling Plan [x] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911:** [x] Configured [ ] Not Configured [ ] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** Government-approved classified data backup system
- **Items Backed Up:** [x] Servers [x] Workstations [x] M365 [x] Databases
- **M365 Backup:** [x] Native [x] Third-Party: Government-approved third-party backup [ ] None
- **Backup Testing Frequency:** Monthly (with documented validation)

### Disaster Recovery
- **DR Plan Documented:** [x] Yes [ ] No
- **RTO (Recovery Time Objective):** 2 hours (critical intelligence systems)
- **RPO (Recovery Point Objective):** 15 minutes
- **DR Site/Failover:** [x] Yes [ ] No | Location: Government-approved secure facility with redundant systems
- **Cloud DR Strategy:** Hybrid approach with government GCC High and on-premises failover

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [ ] ConnectWise Automate [ ] N-able [x] Other: Government-approved monitoring platform [ ] None
- **Monitoring Coverage:** [x] All devices [ ] Servers only [ ] None
- **Alert Response Time SLA:** 15 minutes for critical alerts, 1 hour for standard

### Help Desk/Ticketing
- **PSA/Ticketing System:** Government-compliant ticketing system (TBD)
- **User Self-Service Portal:** [x] Yes [ ] No (Limited to unclassified systems)
- **Current Response Time:** 1 hour for critical, 4 hours for standard

---

## Budget & Timeline

### Budget Information
- **IT Budget (Annual):** TBD
- **Spending Breakdown:**
  - Hardware: ___%
  - Software/Licenses: ___%
  - Services/Support: ___%
  - Projects: ___%

- **Capital Available for Projects:** TBD
- **OpEx vs CapEx Preference:** [ ] Prefer OpEx [ ] Prefer CapEx [x] No preference (Government contract driven)

### Timeline & Priorities
**Immediate Needs (0-30 days):**
- Security compliance audit for CMMC Level 3
- Evaluate NIST SP 800-171 compliance posture
- Review and update incident response procedures

**Short-Term Projects (1-6 months):**
- Implement advanced threat detection for classified systems
- Deploy additional redundancy for mission-critical systems
- Enhance secure remote access capabilities

**Long-Term Goals (6-12+ months):**
- Achieve CMMC Level 3 certification
- Upgrade classified network infrastructure
- Implement zero-trust security model for federal compliance

**Budget Approval Process:** Federal contracting and procurement rules apply
**Decision Maker(s):** Executive leadership (Tommy Garrett, CEO)

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name                    | Service Provided           | Contract Term | Satisfaction
-------------------------------|---------------------------|---------------|-------------
Microsoft (Government)         | M365, Azure, Defender     | Government    | [1-5]
DISA                          | Network connectivity      | Government    | [1-5]
TBD                           | Classified system vendor  | Government    | [1-5]
TBD                           | Security consulting       | Contract      | [1-5]
```

### MSP Service Expectations
- **Desired Service Level:** [x] Co-Managed IT [ ] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [x] Phone [x] Teams [ ] Email [ ] Portal
- **Preferred Meeting Cadence:** [x] Weekly [ ] Bi-Weekly [ ] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:** Direct escalation to Security Officer and CEO for classified matter breaches

---

## Additional Notes

### Special Considerations
```
FEDERAL DEFENSE CONTRACTING CRITICAL:
- 95%+ of employees have military/government service background
- Organization: Veteran-owned Small Business (SBDVOSB)
- Company Values: I C.A.R.E. (Integrity, Commitment, Accountability, Responsiveness, Excellence)
- CMMI Certified and pursuing CMMC Level 3 certification
- All systems must comply with NIST SP 800-171, DFARS, FAR, and Executive Order 14028
- Personnel Security Clearance requirements: Secret, Top Secret, and higher classifications
- Website: www.garrettgp.com
- Tagline: "Solutions for a Changing World"
- Services include: Intelligence operations, military operational planning, personnel/physical security, IT/cybersecurity, joint training/exercises, modeling/simulation
- 2024 Awards: Veteran Owned Business of the Year, Sarpy County Defense Contractor of the Year, HIRE Vets Gold Award
- Service Area: U.S. Government/federal defense sector exclusively
- Founder/CEO: Tommy Garrett
- Physical security facility requirements for classified work
- All IT activities subject to federal audit and compliance reviews
- Zero tolerance for security incidents involving classified information
```

### Customer Strengths
```
- Highly experienced workforce with military/government background
- CMMI certification demonstrates process maturity
- Strong compliance focus and security culture
- Award-winning organization with proven track record
- Leadership alignment on security and compliance priorities
- Established relationships with government agencies and contractors
- Federal contractor experience and compliance infrastructure in place
```

### Opportunities for Improvement
```
- Achieve CMMC Level 3 certification (if not already obtained)
- Implement zero-trust security architecture for all classified systems
- Enhance supply chain risk management (SCRM) program
- Deploy advanced insider threat detection capabilities
- Expand security awareness training to cover emerging threats
- Implement hardware-based full-disk encryption on all endpoint devices
- Develop comprehensive incident response plan specific to classified data breaches
- Establish redundant communications paths for 24/7 operations center
- Implement continuous monitoring and logging for all classified systems
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

**Profile Completed By:** Midwest Cloud Computing MSP
**Date:** 2025-11-20
**Next Review Date:** 2026-02-20
