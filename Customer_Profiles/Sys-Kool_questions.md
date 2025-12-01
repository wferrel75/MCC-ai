# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Sys-Kool, LLC
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Industrial Services - Cooling Towers

---

## Business Overview

### Company Information
- **Number of Employees:** 50+ (including multiple construction crews and superintendents)
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [x] B2B [ ] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** Extended hours (field service operations vary by location)
- **Time Zone(s):** Central Time (CT), Mountain Time (MT), Central Time (CT variations across service areas)

### Business Objectives
**Primary Business Goals:**
- Expand cooling tower service and maintenance across 15-state region
- Maintain high-quality field service delivery with experienced crews
- Support rapid deployment and rental of cooling tower units
- Build partnerships with key industry manufacturers (Evapco, EvapTech, Lakos, Innovas, Edwards Fiberglass)

**Technology Initiatives (Next 12 Months):**
- Enhance field service management and scheduling
- Improve customer communication across multiple office locations
- Deploy mobile solutions for field crews
- Strengthen supply chain and parts management

**Pain Points/Challenges:**
- Managing operations across 5 regional office locations
- Coordinating field crews with 10+ years experience and high retention
- Maintaining inventory and parts availability across service areas
- Supporting both service and equipment rental operations

---

## User Profile

### User Count by Category
```
Total Users: 50+
├─ Executive/Leadership: 5-10
├─ Knowledge Workers (Office/Hybrid): 15-20
├─ Remote Workers: 5-10
├─ Field/Mobile Workers: 25-30 (construction crews, service technicians)
├─ Factory/Warehouse Workers: 5-10 (parts/inventory management)
├─ Contractors/Temporary: TBD
└─ Service Accounts/Shared Mailboxes: TBD
```

### User Distribution
- **Users requiring full M365 licenses:** 30-40
- **Users requiring basic email only:** 10-15 (field workers)
- **Users requiring specialized apps:** Field service management, inventory management, GPS/routing
- **External collaborators/partners:** Evapco, EvapTech, Lakos, Innovas, Edwards Fiberglass representatives

### Work Patterns
- **Percentage Remote Workers:** 20-30%
- **Percentage Hybrid Workers:** 20-30%
- **Percentage On-Site Only:** 40-50% (field-based workers)
- **BYOD Policy:** [ ] Allowed [x] Restricted [ ] Prohibited
- **Mobile Device Types:** [x] iOS [x] Android [x] Windows [ ] Other: ___

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Corporate Office - Omaha, Nebraska"
    address: "11313 S. 146th Street, Omaha, Nebraska 68138"
    user_count: 15-20
    internet_provider: TBD
    bandwidth_down: TBD
    bandwidth_up: TBD
    site_type: [x] Primary [ ] Branch [ ] Remote Office [ ] Data Center

  - name: "Kansas City Office"
    address: "116 Congress Street, Belton, MO 64012"
    user_count: 8-12
    internet_provider: TBD
    bandwidth_down: TBD
    bandwidth_up: TBD
    site_type: [ ] Primary [x] Branch [ ] Remote Office [ ] Data Center

  - name: "Colorado Office"
    address: "14704 East 33rd Place, Unit A, Aurora, CO 80011"
    user_count: 6-10
    internet_provider: TBD
    bandwidth_down: TBD
    bandwidth_up: TBD
    site_type: [ ] Primary [x] Branch [ ] Remote Office [ ] Data Center

  - name: "Arkansas Office"
    address: "Little Rock, AR"
    user_count: 4-8
    internet_provider: TBD
    bandwidth_down: TBD
    bandwidth_up: TBD
    site_type: [ ] Primary [x] Branch [ ] Remote Office [ ] Data Center

  - name: "Oklahoma Office"
    address: "Tulsa, OK"
    user_count: 4-8
    internet_provider: TBD
    bandwidth_down: TBD
    bandwidth_up: TBD
    site_type: [ ] Primary [x] Branch [ ] Remote Office [ ] Data Center

  - name: "Tennessee Office"
    address: "Memphis, TN"
    user_count: 4-8
    internet_provider: TBD
    bandwidth_down: TBD
    bandwidth_up: TBD
    site_type: [ ] Primary [x] Branch [ ] Remote Office [ ] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [x] Site-to-Site VPN [ ] SD-WAN [ ] None [ ] Other: ___
- **Primary WAN Provider:** TBD
- **Backup/Redundant Connections:** [ ] Yes [x] No
  - Details: Required for operational continuity across regional offices

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
- **Wireless AP Vendor/Model:** TBD
- **Network Management:** [ ] Ubiquiti (UniFi) [ ] Cisco Meraki [ ] Aruba [ ] Other: TBD

**Network Services:**
- **DHCP Server:** [ ] Firewall [x] Windows Server [ ] Router [ ] Other: ___
- **DNS Services:** [x] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** TBD
- **VLANs Configured:** [x] Yes [ ] No
  - VLAN Details: Separate VLANs for office, field operations, inventory management

### Internet & WAN
- **Primary Internet Speed:** TBD
- **Backup Internet:** [x] Yes [ ] No
- **Public IP Addresses:** [x] Static [ ] Dynamic [ ] Number of IPs: TBD

### Remote Access
- **VPN Solution:** Corporate VPN for remote field operations
- **VPN Concurrent Users:** 15-25
- **Remote Desktop Solution:** [x] RDP [ ] VPN [x] Third-party: Field service management system
- **Cloud Access Method:** [x] Direct Internet [ ] VPN [x] Conditional Access Only

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
Microsoft 365 E3                           | 25-30 | Office workers and management
Microsoft 365 E5                           | 5-10  | Senior management
Microsoft 365 Business Premium             | TBD   | Field operations/mobile
Office 365 E1                              | 10-15 | Basic email for field staff
Teams Phone Standard                       | 15-20 | Office locations
Audio Conferencing                         | 5-10  | Management conferencing
Power BI Pro                               | 3-5   | Analytics and reporting
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
- [x] Other: Advanced field service scheduling apps

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller"
    os: "Windows Server 2019/2022"
    virtualization: [x] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha Corporate Office"

  - role: "File Server"
    os: "Windows Server 2019"
    virtualization: [x] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha Corporate Office"

  - role: "Inventory Management Server"
    os: "Windows Server 2019"
    virtualization: [ ] Physical [x] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha Corporate Office"

  - role: "Field Service Management"
    os: "Windows Server"
    virtualization: [ ] Physical [ ] Hyper-V [x] VMware [ ] Azure
    location: "Omaha Corporate Office"
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
- **SQL Server:** [x] Yes [ ] No | Version: 2019/2022 | Databases: Inventory, Service Records, Customer Data
- **Other Databases:** Field service management database

### Line of Business Applications
```
Application Name                 | Vendor      | Hosting         | Users | Cloud-Ready?
---------------------------------|-------------|-----------------|-------|-------------
Field Service Management         | TBD         | [On-Prem/Cloud] | 30-40 | Y
Inventory/Parts Management       | TBD         | [On-Prem/Cloud] | 15-20 | Y
Customer Management System       | TBD         | [On-Prem/Cloud] | 20-25 | Y
GPS/Route Optimization          | TBD         | Cloud          | 30-40 | Y
Cooling Tower Monitoring System  | TBD         | Cloud          | 15-20 | Y
Service Scheduling Software      | TBD         | [On-Prem/Cloud] | 25-35 | Y
Mobile Crew Communication        | TBD         | Cloud          | 25-30 | Y
```

**Critical Dependencies:**
- Real-time field crew coordination and GPS tracking
- Equipment rental tracking and inventory synchronization
- Customer service request management across 15-state service area
- Parts ordering and supply chain integration

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
  - **Retention Period:** 30 days (minimum), 90 days (archived)
  - **Offsite/Cloud Backup:** [x] Yes [ ] No

**Multi-Factor Authentication:**
- **MFA Enabled:** [ ] Yes [ ] No [x] Partial
- **MFA Method:** [x] Microsoft Authenticator [ ] SMS [ ] Hardware Token [ ] Other: ___
- **MFA Coverage:** 60-70% of users

**Conditional Access:**
- **Policies Configured:** [x] Yes [ ] No
- **Number of Policies:** 5-8
- **Key Policies:** Field device access restrictions, VPN requirements for sensitive data

### Compliance Requirements
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [ ] CMMC [x] Other: OSHA compliance for industrial equipment
- **Data Retention Requirements:** 3-7 years for equipment service records and warranty documentation
- **eDiscovery Needs:** [ ] Yes [x] No
- **Data Loss Prevention (DLP):** [ ] Required [x] Nice-to-have [ ] Not needed

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [x] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [ ] Frequent [x] Occasional [ ] Rare
- **Security Training:** [x] Regular [ ] Annual [ ] None

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [ ] On-Prem PBX [x] Cloud PBX [ ] Teams Phone [ ] Other: ___
- **Vendor/Model:** TBD
- **Number of Lines/Extensions:** 20-30
- **Auto Attendant/Call Queue:** [x] Yes [ ] No
- **Conference Room Phones:** 8-10 (across multiple offices)
- **Analog Lines (Fax/Alarm):** 3-5

### Teams Voice
- **Teams Phone Deployment:** [x] Yes [ ] No [ ] Planned
- **PSTN Connectivity:** [x] Calling Plan [ ] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911):** [x] Configured [ ] Not Configured [ ] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** TBD
- **Items Backed Up:** [x] Servers [x] Workstations [x] M365 [x] Databases
- **M365 Backup:** [ ] Native [x] Third-Party: TBD [ ] None
- **Backup Testing Frequency:** Quarterly

### Disaster Recovery
- **DR Plan Documented:** [x] Yes [ ] No
- **RTO (Recovery Time Objective):** 4 hours
- **RPO (Recovery Point Objective):** 1 hour
- **DR Site/Failover:** [x] Yes [ ] No | Location: Secondary data center or cloud-based failover
- **Cloud DR Strategy:** Hybrid approach with critical systems in cloud

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [x] ConnectWise Automate [ ] N-able [ ] Other: ___ [ ] None
- **Monitoring Coverage:** [x] All devices [ ] Servers only [ ] None
- **Alert Response Time SLA:** 30 minutes for critical alerts, 4 hours for standard

### Help Desk/Ticketing
- **PSA/Ticketing System:** TBD
- **User Self-Service Portal:** [x] Yes [ ] No
- **Current Response Time:** 2-4 hours

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
- Enhance field crew device management and mobile security
- Improve inter-site VPN connectivity and redundancy

**Short-Term Projects (1-6 months):**
- Deploy advanced field service analytics
- Implement equipment tracking and monitoring system
- Upgrade backup infrastructure

**Long-Term Goals (6-12+ months):**
- Full cloud migration of non-critical systems
- Advanced predictive maintenance analytics
- Regional office infrastructure optimization

**Budget Approval Process:** TBD
**Decision Maker(s):** TBD

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name                    | Service Provided           | Contract Term | Satisfaction
-------------------------------|---------------------------|---------------|-------------
Evapco                         | Equipment/Parts            | Ongoing       | [1-5]
EvapTech                       | Equipment/Parts            | Ongoing       | [1-5]
Lakos                          | Equipment/Parts            | Ongoing       | [1-5]
Innovas                        | Equipment/Parts            | Ongoing       | [1-5]
Edwards Fiberglass            | Equipment/Parts            | Ongoing       | [1-5]
ConnectWise                   | RMM/PSA                    | Annual        | [1-5]
```

### MSP Service Expectations
- **Desired Service Level:** [x] Co-Managed IT [ ] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [ ] Email [x] Phone [x] Teams [ ] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [x] Bi-Weekly [ ] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:** Direct contact to operations manager for field service outages

---

## Additional Notes

### Special Considerations
```
FIELD SERVICE OPERATIONS CRITICAL:
- Multiple construction crews and experienced superintendents (avg 10+ years experience) require reliable mobile communications
- High-touch field service delivery requires real-time scheduling and GPS tracking
- Equipment rental operations require rapid deployment and tracking capabilities
- Partnership with major cooling tower manufacturers (Evapco, EvapTech, Lakos, Innovas, Edwards Fiberglass) requires integration capabilities
- Membership in CTI and ASHRAE requires industry compliance standards
- Active social media presence (Facebook, LinkedIn) for marketing and customer engagement
- Operational hours extended across multiple time zones requiring 24/7 monitoring capability
- Website: sys-kool.com
- Tagline: "A More Efficient Way to Cool"
- Contact: 402-597-1449, Sys-Kool@Sys-Kool.com
- Service area covers 15 states with varying compliance requirements
```

### Customer Strengths
```
- Experienced field workforce with high retention rates
- Strong industry partnerships and certifications (CTI, ASHRAE)
- Well-established multi-regional presence
- Modern cloud PBX deployment
- Documented disaster recovery procedures
- Regular security training implementation
```

### Opportunities for Improvement
```
- Implement comprehensive endpoint detection and response (EDR) solution
- Expand MFA coverage to 100% of users
- Deploy advanced data loss prevention (DLP) for sensitive customer data
- Enhance field crew security training with mobile device best practices
- Implement redundant internet connectivity across all regional offices
- Modernize on-premises infrastructure to hybrid cloud approach
- Develop comprehensive asset management system integrating all equipment tracking
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
