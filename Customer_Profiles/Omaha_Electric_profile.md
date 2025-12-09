# Customer Profile Template
## Omaha Electric Service, Inc. (OES) - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Omaha Electric Service, Inc. (OES)
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Electrical Contracting

---

## Business Overview

### Company Information
- **Number of Employees:** TBD
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [X] B2B [X] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** 8:00 AM - 5:00 PM Central Time (Field technicians may work extended hours and emergency calls)
- **Time Zone(s):** Central Time (US)

### Business Objectives
**Primary Business Goals:**
- Maintain position as one of top electrical contractors in Omaha
- Expand service offerings across commercial, industrial, and residential sectors
- Continue to serve government/municipal facilities and complex projects
- Deliver award-winning services and maintain customer satisfaction

**Technology Initiatives (Next 12 Months):**
- TBD
- TBD
- TBD

**Pain Points/Challenges:**
- TBD
- TBD
- TBD

---

## User Profile

### User Count by Category
```
Total Users: TBD
├─ Executive/Leadership: TBD
├─ Knowledge Workers (Office/Hybrid): TBD (Project managers, estimators, office staff)
├─ Remote Workers: TBD
├─ Field/Mobile Workers: TBD (Electricians, technicians, field supervisors)
├─ Factory/Warehouse Workers: TBD (Warehouse staff for parts/materials)
├─ Contractors/Temporary: TBD
└─ Service Accounts/Shared Mailboxes: TBD
```

### User Distribution
- **Users requiring full M365 licenses:** TBD (Management, project managers, estimators)
- **Users requiring basic email only:** TBD (Field technicians)
- **Users requiring specialized apps:** TBD (Project management, job costing, parts inventory)
- **External collaborators/partners:** TBD (Clients, municipal/government contacts, vendors)

### Work Patterns
- **Percentage Remote Workers:** TBD
- **Percentage Hybrid Workers:** TBD (Office days plus field work)
- **Percentage On-Site Only:** TBD (Field technicians on-site at customer locations)
- **BYOD Policy:** [ ] Allowed [ ] Restricted [ ] Prohibited
- **Mobile Device Types:** [ ] iOS [ ] Android [ ] Windows [ ] Other: ___

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Headquarters & Main Office"
    address: "Omaha, Nebraska"
    user_count: TBD
    internet_provider: "TBD"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [X] Primary [ ] Branch [ ] Remote Office [ ] Data Center

  - name: "Warehouse/Parts Storage"
    address: "Omaha, Nebraska area"
    user_count: TBD
    internet_provider: "TBD"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [ ] Primary [X] Branch [ ] Remote Office [ ] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [ ] Site-to-Site VPN [ ] SD-WAN [ ] None [ ] Other: ___
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
- **Network Management:** [ ] Ubiquiti (UniFi) [ ] Cisco Meraki [ ] Aruba [ ] Other: ___

**Network Services:**
- **DHCP Server:** [ ] Firewall [ ] Windows Server [ ] Router [ ] Other: ___
- **DNS Services:** [ ] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** TBD
- **VLANs Configured:** [ ] Yes [ ] No
  - VLAN Details: TBD

### Internet & WAN
- **Primary Internet Speed:** TBD
- **Backup Internet:** [ ] Yes [ ] No
- **Public IP Addresses:** [ ] Static [ ] Dynamic [ ] Number of IPs: ___

### Remote Access
- **VPN Solution:** TBD
- **VPN Concurrent Users:** TBD (Field technicians accessing job information, quotes, invoicing)
- **Remote Desktop Solution:** [ ] RDP [ ] VPN [ ] Third-party: ___
- **Cloud Access Method:** [ ] Direct Internet [ ] VPN [ ] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** www.omahaelectric.com
- **Additional Domains:** TBD
- **Tenant Type:** [ ] Commercial [ ] GCC [ ] GCC High [ ] DoD

**Current Licenses (by SKU and count):**
```
SKU Name                                    | Count | Notes
-------------------------------------------|-------|-------
Microsoft 365 E3                           | TBD   |
Microsoft 365 E5                           | TBD   |
Microsoft 365 Business Premium             | TBD   |
Office 365 E1                              | TBD   |
Teams Phone Standard                       | TBD   |
Audio Conferencing                         | TBD   |
Power BI Pro                               | TBD   |
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
- [ ] Other: ___

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller"
    os: "TBD"
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha, Nebraska (Headquarters)"

  - role: "File Server"
    os: "TBD"
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha, Nebraska (Headquarters)"

  - role: "Project Management/Job Costing"
    os: "TBD"
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha, Nebraska (Headquarters)"
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
- **Current Usage:** TBD (Project files, blueprints, client documentation, photos)
- **Backup Solution:** TBD

**Database Servers:**
- **SQL Server:** [ ] Yes [ ] No | Version: ___ | Databases: ___
- **Other Databases:** TBD (Job costing database, project management database)

### Line of Business Applications
```
Application Name              | Vendor      | Hosting         | Users | Cloud-Ready?
------------------------------|-------------|-----------------|-------|-------------
Project Management/Scheduling | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Job Costing/Estimating        | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Field Service Management      | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Parts Inventory System        | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Invoicing/Accounting          | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Document Management           | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Electrical Code Reference     | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
```

**Critical Dependencies:**
- Project scheduling system must be reliable and accessible to field technicians
- Job costing and estimating system critical for profitability and client quotes
- Field service management system enables dispatch, time tracking, and job documentation
- Parts inventory system prevents service delays and optimizes stocking levels
- Document management system stores blueprints, permits, inspection certificates, and project photos
- Real-time access to job information by field technicians is essential for customer service

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
- **MFA Method:** [ ] Microsoft Authenticator [ ] SMS [ ] Hardware Token [ ] Other: ___
- **MFA Coverage:** ___% of users

**Conditional Access:**
- **Policies Configured:** [ ] Yes [ ] No
- **Number of Policies:** TBD
- **Key Policies:** TBD

### Compliance Requirements
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [X] Other: NEC (National Electrical Code), State/Local Electrical Licensing, Building Permits, Municipal Inspections
- **Data Retention Requirements:** Permits and inspection certificates (per local requirements, often 7 years), Project documentation and blueprints, Customer contracts and change orders, Compliance records for government/municipal work
- **eDiscovery Needs:** [ ] Yes [X] No (Potential if disputes arise over project scope/changes)
- **Data Loss Prevention (DLP):** [X] Required [ ] Nice-to-have [ ] Not needed (Customer proprietary designs, municipal facility blueprints, pricing/cost information)

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [ ] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [ ] Frequent [ ] Occasional [ ] Rare
- **Security Training:** [ ] Regular [ ] Annual [ ] None

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [ ] On-Prem PBX [ ] Cloud PBX [ ] Teams Phone [ ] Other: ___
- **Vendor/Model:** TBD
- **Number of Lines/Extensions:** TBD
- **Auto Attendant/Call Queue:** [ ] Yes [ ] No
- **Conference Room Phones:** TBD
- **Analog Lines (Fax/Alarm):** TBD (Fax for permits, inspections, client communication)

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
- **RTO (Recovery Time Objective):** TBD
- **RPO (Recovery Point Objective):** TBD
- **DR Site/Failover:** [ ] Yes [ ] No | Location: ___
- **Cloud DR Strategy:** TBD

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [ ] ConnectWise Automate [ ] N-able [ ] Other: ___ [ ] None
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
  - Hardware: ___%
  - Software/Licenses: ___%
  - Services/Support: ___%
  - Projects: ___%

- **Capital Available for Projects:** TBD
- **OpEx vs CapEx Preference:** [ ] Prefer OpEx [ ] Prefer CapEx [ ] No preference

### Timeline & Priorities
**Immediate Needs (0-30 days):**
- TBD
- TBD

**Short-Term Projects (1-6 months):**
- TBD
- TBD

**Long-Term Goals (6-12+ months):**
- TBD
- TBD

**Budget Approval Process:** TBD
**Decision Maker(s):** TBD

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name     | Service Provided           | Contract Term | Satisfaction
----------------|---------------------------|---------------|-------------
TBD             | TBD                       | TBD           | [1-5]
TBD             | TBD                       | TBD           | [1-5]
TBD             | TBD                       | TBD           | [1-5]
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
Omaha Electric Service is a well-established, award-winning electrical contracting
firm with over 30 years of experience. Key considerations for MSP engagement:

1. COMPLEX PROJECT REQUIREMENTS: OES serves diverse market segments with highly
   specialized needs:
   - Commercial electrical wiring/inspection/repairs
   - Automatic electric gates (specialized controls and automation)
   - Government/municipal facilities (high compliance requirements)
   - Industrial services (heavy machinery, complex systems)
   - Residential services (consumer-facing support)
   - Small commercial services
   - Traffic/utilities infrastructure
   - Sports lighting systems

2. REGULATORY COMPLIANCE: Multiple compliance frameworks apply:
   - National Electrical Code (NEC) compliance for all work
   - State/local electrical contractor licensing
   - Building permits and municipal inspections
   - OSHA safety regulations
   - Government facility requirements for public projects
   - Potential federal requirements for infrastructure work

3. FIELD-CENTRIC OPERATIONS: Majority of workforce (electricians, technicians,
   supervisors) works in field at customer sites rather than office. Mobile access
   to job information, scheduling, parts inventory, and time tracking is critical
   to operations.

4. DOCUMENTATION AND COMPLIANCE: Must maintain extensive documentation:
   - Permits and inspection certificates (often required to be retained 7+ years)
   - Project blueprints and schematics
   - Customer contracts and change orders
   - Inspection/completion photos
   - Safety and training documentation
   - License/certification records

5. AWARD-WINNING REPUTATION: Company has built reputation on quality and service.
   IT systems must be reliable and enable field team responsiveness. System
   downtime directly impacts customer satisfaction and revenue.

6. COMPETITIVE DIFFERENTIATION: One of top electrical contractors in Omaha suggests
   strong market position. Opportunities exist to use technology for competitive
   advantage (customer portal, real-time project visibility, quality documentation).
```

### Customer Strengths
```
1. Established Market Leader: 30+ years in business with reputation as one of top
   electrical contractors in Omaha demonstrates stability, expertise, and customer trust.

2. Award-Winning Services: Explicit mention of award-winning services indicates
   commitment to quality and customer satisfaction.

3. Diverse Service Portfolio: Ability to serve commercial, industrial, residential,
   and government/municipal sectors with specialized services shows broad technical
   expertise and market reach.

4. Specialized Capabilities: Services like automatic electric gates and sports
   lighting indicate advanced technical capabilities and ability to handle complex
   projects beyond standard electrical work.

5. Government/Municipal Experience: Experience serving government and municipal
   facilities indicates ability to work with complex compliance requirements and
   likely established relationships with key decision makers.

6. Service Area Growth: Operating across Omaha and surrounding regions suggests
   successful business model with room for geographic expansion.
```

### Opportunities for Improvement
```
1. Mobile Field Application Enhancement: Develop or enhance mobile app for field
   technicians to improve:
   - Real-time job dispatch and scheduling
   - Photo documentation and job notes
   - Time tracking and material usage
   - Customer signature and job completion
   - Access to blueprints and project specs on-site

2. Digital Project Management: Implement cloud-based project management system
   that provides real-time visibility into:
   - Project status and schedule
   - Resource allocation
   - Budget/cost tracking
   - Change order management
   - Compliance and permit tracking

3. Customer Portal: Develop customer-facing portal for:
   - Project status visibility
   - Invoice and payment history
   - Document access (permits, certificates)
   - Quote and estimate access
   - Service request submission

4. Document Management and Compliance: Implement comprehensive document management
   system with:
   - Automated permit/certificate tracking and retention
   - Project archive organization
   - Compliance checklist automation
   - Document search and retrieval

5. Safety and Training Documentation: Implement system to track:
   - Electrician certifications and licenses
   - OSHA and safety training records
   - Equipment maintenance and inspections
   - Incident/accident reporting and corrective actions

6. Business Intelligence and Analytics: Implement analytics to track:
   - Project profitability by type/segment
   - Technician productivity and utilization
   - Customer satisfaction metrics
   - Market trends and competitive positioning

7. Integration of Line of Business Applications: Ensure seamless integration
   between project management, job costing, invoicing, and accounting systems
   to reduce manual data entry and improve data accuracy.
```

---

## Profile Completion Checklist
- [X] Basic customer information completed
- [ ] User counts and distribution documented
- [ ] All office locations documented with network details
- [ ] Current Microsoft 365 licensing documented
- [ ] Security posture assessed
- [ ] Backup strategy documented
- [X] Pain points and objectives identified
- [ ] Budget and timeline discussed
- [ ] Profile reviewed with customer
- [ ] Profile reviewed with technical team

**Profile Completed By:** Claude Code - MSP Onboarding
**Date:** 2025-11-20
**Next Review Date:** TBD (To be scheduled after initial customer consultation)
