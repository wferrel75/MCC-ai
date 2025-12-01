# Customer Profile Template
## MaxumStaffing (Maxum Group) - MSP Customer Profile

---

## Customer Identification

**Customer Name:** MaxumStaffing (Maxum Group)
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** Rich M. (richm@maxumgrp.com)
**Industry/Vertical:** Staffing/Recruiting - Light Industrial

---

## Business Overview

### Company Information
- **Number of Employees:** TBD
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [X] B2B [X] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** 8:00 AM - 5:00 PM Central Time (Standard business hours plus placement call-outs)
- **Time Zone(s):** Central Time (US)

### Business Objectives
**Primary Business Goals:**
- Serve as a local alternative to national staffing firms in the Greater Omaha area
- Expand client base with light industrial job placements (welding, warehouse, day labor)
- Maintain strong community relationships and employee satisfaction
- Build reputation as a community-focused staffing solutions provider

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
├─ Knowledge Workers (Office/Hybrid): TBD (Recruiters, HR)
├─ Remote Workers: TBD
├─ Field/Mobile Workers: TBD (Job placement coordinators)
├─ Factory/Warehouse Workers: TBD
├─ Contractors/Temporary: TBD
└─ Service Accounts/Shared Mailboxes: TBD
```

### User Distribution
- **Users requiring full M365 licenses:** TBD (Recruiters, Management)
- **Users requiring basic email only:** TBD (Field placement coordinators)
- **Users requiring specialized apps:** TBD (Applicant tracking, job board)
- **External collaborators/partners:** TBD (Employer clients, job candidates)

### Work Patterns
- **Percentage Remote Workers:** TBD
- **Percentage Hybrid Workers:** TBD
- **Percentage On-Site Only:** TBD
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
- **VPN Concurrent Users:** TBD
- **Remote Desktop Solution:** [ ] RDP [ ] VPN [ ] Third-party: ___
- **Cloud Access Method:** [ ] Direct Internet [ ] VPN [ ] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** TBD
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
    location: "Omaha, Nebraska"

  - role: "File Server"
    os: "TBD"
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha, Nebraska"
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
- **Other Databases:** TBD (Applicant tracking system database)

### Line of Business Applications
```
Application Name              | Vendor      | Hosting         | Users | Cloud-Ready?
------------------------------|-------------|-----------------|-------|-------------
Applicant Tracking System     | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Job Board/Posting System      | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Recruiter CRM                 | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Payroll/HR System             | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Mobile Job Dispatch App       | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
```

**Critical Dependencies:**
- Applicant Tracking System must maintain high availability for recruiter productivity
- Job posting system must be accessible 24/7 for candidates applying for positions
- Mobile dispatch capability critical for field placement coordinators
- Integration between recruiting system and payroll for temporary worker management

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
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [X] Other: Background check regulations, Worker classification compliance, Safety regulations
- **Data Retention Requirements:** Candidate records (application history, interviews), Worker employment records, Tax documentation (I-9 verification), Background check results
- **eDiscovery Needs:** [ ] Yes [ ] No
- **Data Loss Prevention (DLP):** [X] Required [ ] Nice-to-have [ ] Not needed (Personal information - SSN, addresses, background check data)

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
- **Auto Attendant/Call Queue:** [ ] Yes [ ] No (Phone: 402-682-8005 published for recruiter contact)
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
**Decision Maker(s):** Rich M. / Maxum Group leadership

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
- **Escalation Preferences:** richm@maxumgrp.com / 402-682-8005

---

## Additional Notes

### Special Considerations
```
MaxumStaffing positions itself as a local alternative to national staffing firms,
emphasizing community focus and personalized service. Key considerations:

1. SENSITIVE PERSONNEL DATA: Handles extensive personal information including:
   - Social Security numbers for I-9 verification and tax documentation
   - Background check results (criminal history, etc.)
   - Personal addresses and contact information
   - Employment history and verification
   - Banking information (direct deposit)
   Must implement strong access controls and data protection measures.

2. REGULATORY COMPLIANCE: Light industrial staffing requires compliance with:
   - Worker classification rules (employee vs. contractor)
   - Safety regulations and worker safety documentation
   - Background check compliance (Fair Credit Reporting Act)
   - I-9 employment eligibility verification
   - Tax withholding and reporting requirements

3. BUSINESS CRITICALITY: Applicant Tracking System and job posting platform are
   mission-critical. Downtime directly impacts ability to place workers and serve
   clients. High availability requirements for both systems.

4. COMMUNITY-FOCUSED POSITIONING: "Inspiring Staffing Solutions" - Company emphasizes
   local presence and relationships. Reliable, responsive IT support reinforces
   professional image and client trust.

5. SERVICE AREA FOCUS: Greater Omaha, Nebraska area operations. All staff likely
   based in or near Omaha. Opportunity for local MSP partnership and support.

6. MOBILE WORKFORCE: Field placement coordinators require mobile access to dispatch
   system and candidate information. Mobile device security and remote access must
   be secure.
```

### Customer Strengths
```
1. Local Market Focus: Deep community relationships and reputation in Greater Omaha
   area provide competitive advantage against national firms.

2. Specialization: Focus on light industrial placements (welding, warehouse, day labor)
   suggests deep expertise in specific job categories and employer relationships.

3. Responsive Service Model: Community-focused positioning suggests emphasis on
   personalized, responsive service that larger national firms may not provide.

4. Growing Business: Expansion of recruiter services and job placement offerings
   indicates growth trajectory and potential for increased IT support needs.

5. Clear Leadership: Direct contact with Rich M. (richm@maxumgrp.com) suggests
   engaged leadership accessible for technology decisions.
```

### Opportunities for Improvement
```
1. Cloud-Based ATS Migration: Evaluate migration to cloud-based Applicant Tracking System
   for improved scalability, accessibility, and disaster recovery compared to on-premises
   solutions. SaaS options may reduce IT overhead.

2. Mobile Application Enhancement: Develop or enhance mobile app for field placement
   coordinators to improve job dispatch, real-time communication, and worker matching.

3. Automation and Workflow Optimization: Implement workflow automation in recruitment
   process (candidate screening, communication, offer generation) to improve recruiter
   productivity and reduce manual work.

4. Data Security and Compliance Strengthening: Given sensitive nature of personal
   information (SSN, background checks, addresses), implement:
   - Field-level encryption for sensitive data
   - Role-based access controls
   - Audit logging for compliance
   - Security awareness training on sensitive data handling

5. Business Intelligence: Implement analytics and reporting on placement success rates,
   client satisfaction, recruiter productivity, and market trends to inform business
   decisions and competitive positioning.

6. Integration and Interoperability: Ensure seamless integration between ATS, payroll
   system, and other business applications to reduce manual data entry and improve
   data accuracy.
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
**Next Review Date:** TBD (To be scheduled after initial customer consultation with Rich M.)
