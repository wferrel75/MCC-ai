# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** VINTON BALL (Molycop)
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Manufacturing - Industrial Products (Grinding Media/Ball-Related Equipment)

---

## Business Overview

### Company Information
- **Number of Employees:** TBD (International parent company: Molycop)
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [x] B2B [ ] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** Standard Manufacturing Hours (24/7 production operations)
- **Time Zone(s):** Mountain Time (MT)

### Business Objectives
**Primary Business Goals:**
- Manufacture and distribute high-quality grinding media and ball-related industrial products
- Support international Molycop operations and supply chain
- Expand e-commerce and digital customer engagement
- Maintain production efficiency and quality standards

**Technology Initiatives (Next 12 Months):**
- Enhance company website and digital presence
- Improve online ordering and customer portal
- Streamline supply chain and inventory management systems
- Upgrade HR recruitment and talent management systems

**Pain Points/Challenges:**
- Managing operations as part of larger international corporation
- Coordinating digital presence and e-commerce platforms
- Ensuring consistency between corporate and local systems
- Supporting global supply chain and customer base

---

## User Profile

### User Count by Category
```
Total Users: TBD
├─ Executive/Leadership: 5-10
├─ Knowledge Workers (Office/Hybrid): 20-30 (sales, customer service, administration)
├─ Remote Workers: 5-10
├─ Field/Mobile Workers: 10-15 (sales representatives, logistics)
├─ Factory/Warehouse Workers: 30-50 (production, QA, shipping)
├─ Contractors/Temporary: 5-10
└─ Service Accounts/Shared Mailboxes: TBD
```

### User Distribution
- **Users requiring full M365 licenses:** 25-35
- **Users requiring basic email only:** 20-30 (warehouse, production workers)
- **Users requiring specialized apps:** ERP system, customer portal, CRM, inventory management
- **External collaborators/partners:** Molycop international offices, distributors, major OEM customers

### Work Patterns
- **Percentage Remote Workers:** 15-20%
- **Percentage Hybrid Workers:** 25-35%
- **Percentage On-Site Only:** 45-55% (manufacturing facility workers)
- **BYOD Policy:** [ ] Allowed [x] Restricted [ ] Prohibited
- **Mobile Device Types:** [x] iOS [x] Android [x] Windows [ ] Other: ___

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Vinton Ball Manufacturing Facility & Headquarters"
    address: "Suite 1/ 8100 Border Steel Road, Vinton, TX 79821, USA"
    user_count: 60-80
    internet_provider: TBD
    bandwidth_down: TBD
    bandwidth_up: TBD
    site_type: [x] Primary [ ] Branch [ ] Remote Office [x] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [x] Site-to-Site VPN [ ] SD-WAN [x] Other: Internet connectivity to Molycop international network
- **Primary WAN Provider:** TBD
- **Backup/Redundant Connections:** [x] Yes [ ] No
  - Details: Connection to parent company Molycop network and failover to backup ISP

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:** TBD
- **Firmware Version:** TBD
- **Management:** [ ] Cloud-Managed [x] On-Prem [ ] Hybrid
- **Features in Use:** [x] VPN [x] Content Filtering [x] IPS/IDS [x] Application Control

**Network Equipment:**
- **Switch Vendor/Model:** TBD
- **Wireless AP Vendor/Model:** TBD (Manufacturing facility may have limited wireless)
- **Network Management:** [ ] Ubiquiti (UniFi) [ ] Cisco Meraki [ ] Aruba [ ] Other: TBD

**Network Services:**
- **DHCP Server:** [ ] Firewall [x] Windows Server [ ] Router [ ] Other: ___
- **DNS Services:** [x] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** TBD (coordinated with Molycop international)
- **VLANs Configured:** [x] Yes [ ] No
  - VLAN Details: Office network, production network, guest network, Molycop international connection

### Internet & WAN
- **Primary Internet Speed:** TBD
- **Backup Internet:** [x] Yes [ ] No
- **Public IP Addresses:** [x] Static [ ] Dynamic [ ] Number of IPs: TBD

### Remote Access
- **VPN Solution:** Corporate VPN for remote workers and Molycop international access
- **VPN Concurrent Users:** 10-20
- **Remote Desktop Solution:** [x] RDP [x] VPN [ ] Third-party: ___
- **Cloud Access Method:** [x] Direct Internet [x] VPN [ ] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** TBD
- **Additional Domains:** TBD
- **Tenant Type:** [x] Commercial [ ] GCC [ ] GCC High [ ] DoD

**Current Licenses (by SKU and count):**
```
SKU Name                                    | Count | Notes
-------------------------------------------|-------|-------
Microsoft 365 E3                           | 20-25 | Office and administrative staff
Microsoft 365 E5                           | 5-10  | Management and strategic planning
Microsoft 365 Business Premium             | TBD   | Smaller teams or locations
Office 365 E1                              | 15-20 | Basic email for factory/warehouse staff
Teams Phone Standard                       | 10-15 | Office locations
Audio Conferencing                         | 3-5   | Management meetings
Power BI Pro                               | 3-5   | Production analytics and reporting
[Other]                                    | TBD   |
```

**M365 Services in Use:**
- [x] Exchange Online (Email)
- [x] SharePoint Online
- [x] OneDrive for Business
- [x] Teams (Chat/Meetings)
- [x] Teams Phone System
- [x] Intune (MDM/MAM)
- [x] Azure AD Premium (which tier: P1)
- [ ] Defender for Office 365 (P1/P2)
- [ ] Microsoft Defender for Endpoint
- [ ] Microsoft Purview (Compliance)
- [x] Power Platform (Power Apps, Power Automate)
- [x] Other: SharePoint for document management, Teams for manufacturing floor coordination

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller"
    os: "Windows Server 2019/2022"
    virtualization: [x] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Vinton, TX Headquarters"

  - role: "File Server"
    os: "Windows Server 2019"
    virtualization: [ ] Physical [x] Hyper-V [ ] VMware [ ] Azure
    location: "Vinton, TX Headquarters"

  - role: "ERP Server"
    os: "Windows Server"
    virtualization: [ ] Physical [x] Hyper-V [ ] VMware [ ] Azure
    location: "Vinton, TX Headquarters"

  - role: "Web Server (WordPress-based site)"
    os: "Linux"
    virtualization: [ ] Physical [ ] Hyper-V [x] VMware [ ] Azure
    location: "Vinton, TX Headquarters"
```

**Active Directory:**
- **Domain Name:** TBD
- **Forest Functional Level:** TBD
- **Azure AD Connect:** [x] Yes [ ] No [ ] Cloud Sync
- **Hybrid Configuration:** [x] Yes [ ] No
- **Number of Domain Controllers:** 2

**File Storage:**
- **File Server Location:** [x] On-Prem [ ] Cloud [ ] Hybrid
- **Total Storage Capacity:** TBD
- **Current Usage:** TBD
- **Backup Solution:** TBD

**Database Servers:**
- **SQL Server:** [x] Yes [ ] No | Version: 2019/2022 | Databases: ERP, Customer Data, Inventory, Production Records
- **Other Databases:** Manufacturing execution system (MES), Product databases

### Line of Business Applications
```
Application Name                 | Vendor      | Hosting         | Users | Cloud-Ready?
---------------------------------|-------------|-----------------|-------|-------------
ERP System                       | TBD         | On-Prem         | 30-40 | N
Production Management System     | TBD         | On-Prem         | 40-50 | N
Customer Relationship Management | TBD         | [On-Prem/Cloud] | 20-25 | Y
Inventory Management             | TBD         | On-Prem         | 25-30 | N
E-Commerce Platform              | TBD (WP)    | Cloud           | 10-15 | Y
Website (WordPress)              | TBD         | Cloud           | 5-10  | Y
HR/Recruitment System            | TBD         | [On-Prem/Cloud] | 5-10  | Y
Quality Assurance System         | TBD         | On-Prem         | 20-25 | N
Supply Chain Management          | TBD         | [On-Prem/Cloud] | 15-20 | Y
```

**Critical Dependencies:**
- Manufacturing execution system (MES) and production control
- ERP system for inventory, orders, and operations
- Website and e-commerce platform for customer orders
- Customer portal for order tracking and support

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
  - **Backup Frequency:** Daily
  - **Retention Period:** 30-90 days (with archived backups)
  - **Offsite/Cloud Backup:** [x] Yes [ ] No

**Multi-Factor Authentication:**
- **MFA Enabled:** [ ] Yes [ ] No [x] Partial
- **MFA Method:** [x] Microsoft Authenticator [ ] SMS [ ] Hardware Token [ ] Other: ___
- **MFA Coverage:** 50-60% of users

**Conditional Access:**
- **Policies Configured:** [x] Yes [ ] No
- **Number of Policies:** 3-5
- **Key Policies:** Require MFA for remote access, device compliance checks

### Compliance Requirements
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [x] Other: Manufacturing safety standards (OSHA), product quality standards, export controls for industrial products
- **Data Retention Requirements:** 3-7 years for production records, quality documentation, customer orders
- **eDiscovery Needs:** [ ] Yes [x] No
- **Data Loss Prevention (DLP):** [ ] Required [x] Nice-to-have [ ] Not needed

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [x] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [ ] Frequent [x] Occasional [ ] Rare
- **Security Training:** [ ] Regular [x] Annual [ ] None

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [ ] On-Prem PBX [x] Cloud PBX [ ] Teams Phone [ ] Other: ___
- **Vendor/Model:** TBD
- **Number of Lines/Extensions:** 20-30
- **Auto Attendant/Call Queue:** [x] Yes [ ] No
- **Conference Room Phones:** 3-5
- **Analog Lines (Fax/Alarm):** 2-3 (fax for orders, alarm monitoring)

### Teams Voice
- **Teams Phone Deployment:** [ ] Yes [ ] No [x] Planned
- **PSTN Connectivity:** [ ] Calling Plan [ ] Direct Routing [ ] Operator Connect [x] N/A
- **Emergency Calling (E911):** [ ] Configured [ ] Not Configured [x] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** TBD
- **Items Backed Up:** [x] Servers [x] Workstations [x] M365 [x] Databases
- **M365 Backup:** [ ] Native [x] Third-Party: TBD [ ] None
- **Backup Testing Frequency:** Quarterly

### Disaster Recovery
- **DR Plan Documented:** [x] Yes [ ] No
- **RTO (Recovery Time Objective):** 8 hours (non-critical), 4 hours (critical manufacturing systems)
- **RPO (Recovery Point Objective):** 2 hours
- **DR Site/Failover:** [x] Yes [ ] No | Location: Cloud-based failover or secondary facility
- **Cloud DR Strategy:** Hybrid approach with critical systems in cloud

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [ ] ConnectWise Automate [ ] N-able [x] Other: TBD [ ] None
- **Monitoring Coverage:** [x] All devices [ ] Servers only [ ] None
- **Alert Response Time SLA:** 4 hours for critical manufacturing systems, 24 hours for non-critical

### Help Desk/Ticketing
- **PSA/Ticketing System:** TBD
- **User Self-Service Portal:** [x] Yes [ ] No
- **Current Response Time:** 4-8 hours

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
- **OpEx vs CapEx Preference:** [ ] Prefer OpEx [x] Prefer CapEx [ ] No preference

### Timeline & Priorities
**Immediate Needs (0-30 days):**
- Website optimization and performance review
- E-commerce platform security assessment
- HR recruitment system modernization planning

**Short-Term Projects (1-6 months):**
- Deploy Teams Phone system to replace legacy PBX
- Implement manufacturing floor communication system
- Enhance backup and disaster recovery procedures

**Long-Term Goals (6-12+ months):**
- Migrate to cloud-based ERP system
- Implement predictive maintenance analytics for manufacturing
- Regional expansion infrastructure planning

**Budget Approval Process:** TBD
**Decision Maker(s):** TBD

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name              | Service Provided           | Contract Term | Satisfaction
------------------------|---------------------------|---------------|-------------
Molycop (Parent Co.)    | Corporate IT Services     | Ongoing       | [1-5]
WordPress Support       | Website/CMS Management    | Ongoing       | [1-5]
TBD                     | ERP Support               | Contract      | [1-5]
TBD                     | Cloud Hosting             | Contract      | [1-5]
LinkedIn               | Recruitment/HR Platform   | Ongoing       | [1-5]
```

### MSP Service Expectations
- **Desired Service Level:** [x] Co-Managed IT [ ] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [x] Email [ ] Phone [x] Teams [ ] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [ ] Bi-Weekly [x] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:** Contact manufacturing operations manager for production system outages

---

## Additional Notes

### Special Considerations
```
MANUFACTURING & PARENT COMPANY OPERATIONS CRITICAL:
- Part of Molycop international corporation - coordination with parent company required
- WordPress-based website and e-commerce platform requires specialized support
- LinkedIn presence for recruitment and employer branding
- Manufacturing facility operates 24/7 with production system uptime critical
- Global supply chain integration with parent company Molycop
- Multiple time zones and international operational considerations
- Quality assurance and product documentation requirements
- Website: www.vintonball.com
- Contact: (915) 800 2195, admin@vintonball.com, sales@vintonball.com
- Address: Suite 1/ 8100 Border Steel Road, Vinton, TX 79821, USA
- Active HR recruitment section on website
- Manufacturing grinding media and ball-related industrial products
- Industry: Grinding media manufacturing, industrial product distribution
```

### Customer Strengths
```
- Part of established international corporation (Molycop) with global resources
- Modern website platform using WordPress
- Active digital presence and e-commerce operations
- Documented disaster recovery planning
- Backup and redundancy approach in place
- Clear understanding of manufacturing IT requirements
- Professional e-commerce and customer portal implementation
```

### Opportunities for Improvement
```
- Expand multi-factor authentication coverage to 100% of users
- Implement advanced endpoint detection and response (EDR) solution
- Modernize legacy ERP system with cloud-based alternatives
- Deploy advanced email security and phishing protection
- Enhance manufacturing floor network security and segmentation
- Implement predictive maintenance and IoT monitoring for equipment
- Develop comprehensive supply chain risk management program
- Strengthen incident response and business continuity procedures
- Implement advanced backup validation and testing procedures
- Consider cloud-first approach for non-production workloads
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
