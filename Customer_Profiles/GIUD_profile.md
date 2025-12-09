# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Grand Island Utilities Department
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Municipal Utilities

---

## Business Overview

### Company Information
- **Number of Employees:** TBD
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [X] Government [ ] B2B [ ] B2C [ ] B2B2C [ ] Non-Profit
- **Critical Business Hours:** 24/7 (Utility operations)
- **Time Zone(s):** Central Time (Nebraska)

### Business Objectives
**Primary Business Goals:**
- Ensure reliable utility service delivery to Grand Island residents and businesses
- Maintain critical infrastructure systems uptime
- Modernize IT infrastructure to support grid management

**Technology Initiatives (Next 12 Months):**
- Assess current technical infrastructure and modernization needs
- Evaluate cloud migration opportunities for non-critical systems
- Implement enhanced monitoring capabilities

**Pain Points/Challenges:**
- Limited website information available - suggests potential IT communication/documentation needs
- Technical infrastructure complexity
- TBD - Requires additional discovery

---

## User Profile

### User Count by Category
```
Total Users: TBD
├─ Executive/Leadership: TBD
├─ Knowledge Workers (Office/Hybrid): TBD
├─ Remote Workers: TBD
├─ Field/Mobile Workers: TBD
├─ Factory/Warehouse Workers: TBD
├─ Contractors/Temporary: TBD
└─ Service Accounts/Shared Mailboxes: TBD
```

### User Distribution
- **Users requiring full M365 licenses:** TBD
- **Users requiring basic email only:** TBD
- **Users requiring specialized apps:** TBD
- **External collaborators/partners:** TBD

### Work Patterns
- **Percentage Remote Workers:** TBD
- **Percentage Hybrid Workers:** TBD
- **Percentage On-Site Only:** TBD
- **BYOD Policy:** [ ] Allowed [ ] Restricted [ ] Prohibited
- **Mobile Device Types:** [ ] iOS [ ] Android [ ] Windows [ ] Other: TBD

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Headquarters"
    address: "Grand Island, NE"
    user_count: TBD
    internet_provider: "TBD"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [X] Primary [ ] Branch [ ] Remote Office [ ] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [ ] Site-to-Site VPN [ ] SD-WAN [ ] None [ ] Other: TBD
- **Primary WAN Provider:** TBD
- **Backup/Redundant Connections:** [ ] Yes [ ] No
  - Details: TBD

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:** TBD
- **Firmware Version:** TBD
- **Management:** [ ] Cloud-Managed [ ] On-Prem [ ] Hybrid
- **Features in Use:** [ ] VPN [ ] Content Filtering [ ] IPS/IDS [ ] Application Control

**Network Equipment:**
- **Switch Vendor/Model:** TBD
- **Wireless AP Vendor/Model:** TBD
- **Network Management:** [ ] Ubiquiti (UniFi) [ ] Cisco Meraki [ ] Aruba [ ] Other: TBD

**Network Services:**
- **DHCP Server:** [ ] Firewall [ ] Windows Server [ ] Router [ ] Other: TBD
- **DNS Services:** [ ] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** TBD
- **VLANs Configured:** [ ] Yes [ ] No
  - VLAN Details: TBD

### Internet & WAN
- **Primary Internet Speed:** TBD
- **Backup Internet:** [ ] Yes [ ] No
- **Public IP Addresses:** [ ] Static [ ] Dynamic [ ] Number of IPs: TBD

### Remote Access
- **VPN Solution:** TBD
- **VPN Concurrent Users:** TBD
- **Remote Desktop Solution:** [ ] RDP [ ] VPN [ ] Third-party: TBD
- **Cloud Access Method:** [ ] Direct Internet [ ] VPN [ ] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** TBD
- **Additional Domains:** TBD
- **Tenant Type:** [ ] Commercial [ ] GCC [X] GCC High [ ] DoD

**Current Licenses (by SKU and count):**
```
SKU Name                                    | Count | Notes
-------------------------------------------|-------|-------
Microsoft 365 E3                           | TBD   |
Microsoft 365 E5                           | TBD   |
Office 365 E1                              | TBD   |
[Other]                                    | TBD   |
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
- [ ] Other: TBD

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller"
    os: "TBD"
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Grand Island, NE"

  - role: "File Server"
    os: "TBD"
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Grand Island, NE"

  - role: "TBD"
    os: "TBD"
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "TBD"
```

**Active Directory:**
- **Domain Name:** TBD
- **Forest Functional Level:** TBD
- **Azure AD Connect:** [ ] Yes [ ] No [ ] Cloud Sync
- **Hybrid Configuration:** [ ] Yes [ ] No
- **Number of Domain Controllers:** TBD

**File Storage:**
- **File Server Location:** [ ] On-Prem [ ] Cloud [ ] Hybrid
- **Total Storage Capacity:** TBD
- **Current Usage:** TBD
- **Backup Solution:** TBD

**Database Servers:**
- **SQL Server:** [ ] Yes [ ] No | Version: ___ | Databases: ___
- **Other Databases:** TBD

### Line of Business Applications
```
Application Name                    | Vendor      | Hosting         | Users | Cloud-Ready?
------------------------------------|-------------|-----------------|-------|-------------
SCADA Systems (Utility Grid Mgmt)   | TBD         | On-Prem         | TBD   | N
Customer Billing System             | TBD         | On-Prem/Cloud   | TBD   | TBD
Maintenance Management System       | TBD         | On-Prem         | TBD   | N
Water/Gas Distribution Management   | TBD         | On-Prem         | TBD   | N
GIS System (Asset Mapping)          | TBD         | On-Prem/Cloud   | TBD   | TBD
```

**Critical Dependencies:**
- SCADA and control systems (critical for utility operations)
- Customer database systems
- Geographic Information Systems (GIS)

---

## Security & Compliance

### Security Posture
**Current Security Solutions:**
- **Antivirus/Endpoint Protection:** TBD
- **EDR/MDR Solution:** TBD
- **Email Security:** TBD
- **Web/Content Filtering:** TBD
- **SIEM/Log Management:** TBD
- **Backup Solution:** TBD
  - **Backup Frequency:** TBD
  - **Retention Period:** TBD
  - **Offsite/Cloud Backup:** [ ] Yes [ ] No

**Multi-Factor Authentication:**
- **MFA Enabled:** [ ] Yes [ ] No [ ] Partial
- **MFA Method:** [ ] Microsoft Authenticator [ ] SMS [ ] Hardware Token [ ] Other: TBD
- **MFA Coverage:** TBD% of users

**Conditional Access:**
- **Policies Configured:** [ ] Yes [ ] No
- **Number of Policies:** TBD
- **Key Policies:** TBD

### Compliance Requirements
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [X] NERC-CIP [ ] None [ ] Other: OASIS Standards
- **Data Retention Requirements:** TBD - Government records retention standards
- **eDiscovery Needs:** [ ] Yes [ ] No
- **Data Loss Prevention (DLP):** [ ] Required [ ] Nice-to-have [X] Not needed

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [ ] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [ ] Frequent [ ] Occasional [ ] Rare
- **Security Training:** [ ] Regular [ ] Annual [ ] None

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [ ] On-Prem PBX [ ] Cloud PBX [ ] Teams Phone [ ] Other: TBD
- **Vendor/Model:** TBD
- **Number of Lines/Extensions:** TBD
- **Auto Attendant/Call Queue:** [ ] Yes [ ] No
- **Conference Room Phones:** TBD
- **Analog Lines (Fax/Alarm):** TBD

### Teams Voice
- **Teams Phone Deployment:** [ ] Yes [ ] No [ ] Planned
- **PSTN Connectivity:** [ ] Calling Plan [ ] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911):** [ ] Configured [ ] Not Configured [ ] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** TBD
- **Items Backed Up:** [ ] Servers [ ] Workstations [ ] M365 [ ] Databases
- **M365 Backup:** [ ] Native [ ] Third-Party: ___ [ ] None
- **Backup Testing Frequency:** TBD

### Disaster Recovery
- **DR Plan Documented:** [ ] Yes [ ] No
- **RTO (Recovery Time Objective):** TBD - Critical for utility operations
- **RPO (Recovery Point Objective):** TBD - Should be minimal for SCADA systems
- **DR Site/Failover:** [ ] Yes [ ] No | Location: TBD
- **Cloud DR Strategy:** TBD

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [ ] ConnectWise Automate [ ] N-able [ ] Other: TBD [ ] None
- **Monitoring Coverage:** [ ] All devices [ ] Servers only [ ] None
- **Alert Response Time SLA:** TBD

### Help Desk/Ticketing
- **PSA/Ticketing System:** TBD
- **User Self-Service Portal:** [ ] Yes [ ] No
- **Current Response Time:** TBD

---

## Budget & Timeline

### Budget Information
- **IT Budget (Annual):** TBD
- **Spending Breakdown:**
  - Hardware: TBD%
  - Software/Licenses: TBD%
  - Services/Support: TBD%
  - Projects: TBD%

- **Capital Available for Projects:** TBD
- **OpEx vs CapEx Preference:** [ ] Prefer OpEx [ ] Prefer CapEx [ ] No preference

### Timeline & Priorities
**Immediate Needs (0-30 days):**
- Conduct comprehensive IT infrastructure assessment
- Document current technology inventory

**Short-Term Projects (1-6 months):**
- Identify cloud-ready systems for migration evaluation
- Implement baseline security improvements

**Long-Term Goals (6-12+ months):**
- Modernize legacy systems
- Implement advanced monitoring and threat detection

**Budget Approval Process:** TBD
**Decision Maker(s):** TBD

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name     | Service Provided           | Contract Term | Satisfaction
----------------|---------------------------|---------------|-------------
TBD             | TBD                       | TBD           | TBD
TBD             | TBD                       | TBD           | TBD
TBD             | TBD                       | TBD           | TBD
```

### MSP Service Expectations
- **Desired Service Level:** [ ] Co-Managed IT [ ] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [ ] Email [ ] Phone [ ] Teams [ ] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [ ] Bi-Weekly [ ] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:** TBD

---

## Additional Notes

### Special Considerations
```
CRITICAL INFRASTRUCTURE CONSIDERATIONS:
- Utility operations are mission-critical 24/7 services with no downtime tolerance
- SCADA and control systems require air-gapped or highly secured networks
- Regulatory compliance with NERC CIP and OASIS standards essential
- Any IT changes must be coordinated with Operations team
- Potential need for compliance auditing and documentation support
- Legacy systems likely present - compatibility testing critical before migrations
- Government procurement processes may apply to vendor selection and contracts
- Public sector transparency and records retention requirements
- Potential need for redundant systems and failover capabilities
```

### Customer Strengths
```
- Municipal utility provides stable, predictable business
- Essential service with consistent operational needs
- Government funding model provides budget stability
- Well-established operational procedures
```

### Opportunities for Improvement
```
- Website presence suggests potential need for improved IT communication/documentation
- Limited publicly available information indicates need for professional marketing of IT capabilities
- Potential for modernizing legacy infrastructure
- Opportunity to implement proactive monitoring and threat detection
- Possibility of implementing cloud solutions for non-critical systems
- Need for formal disaster recovery planning
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

**Profile Completed By:** Initial Profile
**Date:** 2025-11-20
**Next Review Date:** TBD
