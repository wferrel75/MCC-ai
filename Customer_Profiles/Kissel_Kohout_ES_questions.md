# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Kissel, Kohout, ES Associates LLC
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Government Relations/Lobbying

---

## Business Overview

### Company Information
- **Number of Employees:** 20-30 (estimated)
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [X] B2B [ ] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** 8 AM - 6 PM during legislative sessions, 8 AM - 5 PM otherwise
- **Time Zone(s):** Central Time (Nebraska)

### Business Objectives
**Primary Business Goals:**
- Maintain effective legislative representation for diverse client base
- Expand client relationships in energy, healthcare, education, and other sectors
- Build strong relationships with Nebraska Unicameral legislators and government
- Support bi-partisan advocacy efforts
- Maintain firm reputation as "Tested. Trusted. Effective."

**Technology Initiatives (Next 12 Months):**
- Implement enhanced client communication and reporting systems
- Improve document management for legislative tracking
- Develop client portal for better transparency and service delivery
- Strengthen cyber security for confidential client information
- Implement advanced regulatory database and tracking systems

**Pain Points/Challenges:**
- Managing confidential client information across multiple sectors
- Rapid information flow during legislative sessions requiring responsive systems
- Tracking complex regulatory changes across federal and state levels
- Managing diverse client needs (energy, healthcare, education, railways, beer distribution)
- Maintaining data security for sensitive lobbying communications
- Coordinating across multiple offices (Lincoln and Omaha)

---

## User Profile

### User Count by Category
```
Total Users: 30+
├─ Executive/Leadership: 4
├─ Knowledge Workers (Office/Hybrid): 22
├─ Remote Workers: 2
├─ Field/Mobile Workers: 2
├─ Factory/Warehouse Workers: 0
├─ Contractors/Temporary: 2
└─ Service Accounts/Shared Mailboxes: 3
```

### User Distribution
- **Users requiring full M365 licenses:** 26 (attorneys, advocates, administrative staff)
- **Users requiring basic email only:** 4 (administrative assistants, reception)
- **Users requiring specialized apps:** 20+ (document management, legislative tracking, client portal)
- **External collaborators/partners:** Clients, legislators, government staff, other advocacy firms

### Work Patterns
- **Percentage Remote Workers:** 10%
- **Percentage Hybrid Workers:** 30%
- **Percentage On-Site Only:** 60%
- **BYOD Policy:** [ ] Allowed [X] Restricted [ ] Prohibited
- **Mobile Device Types:** [X] iOS [X] Android [ ] Windows [ ] Other: Tablets for legislative sessions

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Headquarters/Lincoln Office"
    address: "301 South 13th Street, Suite 400, Lincoln, NE 68508"
    user_count: 18
    internet_provider: "TBD"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [X] Primary [ ] Branch [ ] Remote Office [ ] Data Center

  - name: "Omaha Office"
    address: "Omaha, NE"
    user_count: 12
    internet_provider: "TBD"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [ ] Primary [X] Branch [ ] Remote Office [ ] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [X] Site-to-Site VPN [ ] SD-WAN [ ] None [ ] Other: Cloud-based collaboration
- **Primary WAN Provider:** TBD
- **Backup/Redundant Connections:** [X] Yes [ ] No
  - Details: Cloud backup for legislative session data, redundant internet connections for both offices

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:** TBD
- **Firmware Version:** TBD
- **Management:** [ ] Cloud-Managed [X] On-Prem [ ] Hybrid
- **Features in Use:** [X] VPN [X] Content Filtering [ ] IPS/IDS [ ] Application Control

**Network Equipment:**
- **Switch Vendor/Model:** TBD
- **Wireless AP Vendor/Model:** TBD
- **Network Management:** [ ] Ubiquiti (UniFi) [X] Cisco Meraki [ ] Aruba [ ] Other: TBD

**Network Services:**
- **DHCP Server:** [X] Firewall [ ] Windows Server [ ] Router [ ] Other: TBD
- **DNS Services:** [X] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** 10.0.0.0/8 private range (estimated)
- **VLANs Configured:** [X] Yes [ ] No
  - VLAN Details: Client data VLAN, administrative VLAN, guest network, legislative session VLAN

### Internet & WAN
- **Primary Internet Speed:** TBD
- **Backup Internet:** [X] Yes [ ] No
- **Public IP Addresses:** [X] Static [ ] Dynamic [ ] Number of IPs: TBD

### Remote Access
- **VPN Solution:** TBD (secure for confidential data)
- **VPN Concurrent Users:** 10+
- **Remote Desktop Solution:** [X] RDP [ ] VPN [ ] Third-party: Cloud apps
- **Cloud Access Method:** [ ] Direct Internet [X] VPN [X] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** TBD (likely @kisselkohoutes.com or similar)
- **Additional Domains:** TBD
- **Tenant Type:** [X] Commercial [ ] GCC [ ] GCC High [ ] DoD

**Current Licenses (by SKU and count):**
```
SKU Name                                    | Count | Notes
-------------------------------------------|-------|-------
Microsoft 365 Business Premium             | 26    | Attorneys and advocates
Office 365 E1                              | 4     | Administrative staff
Teams Phone Standard                       | 5     | Main offices
Audio Conferencing                         | 3     | Client calls/meetings
Power BI Pro                               | 2     | Analytics/reporting
[Other]                                    | TBD   | Industry-specific
```

**M365 Services in Use:**
- [X] Exchange Online (Email)
- [X] SharePoint Online
- [X] OneDrive for Business
- [X] Teams (Chat/Meetings)
- [X] Teams Phone System
- [X] Intune (MDM/MAM)
- [X] Azure AD Premium (which tier: P1)
- [X] Defender for Office 365 (P1)
- [ ] Microsoft Defender for Endpoint
- [X] Microsoft Purview (Compliance)
- [ ] Power Platform (Power Apps, Power Automate)
- [X] Other: Secure email encryption for confidential communications

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller"
    os: "Windows Server 2019+"
    virtualization: [ ] Physical [X] Hyper-V [ ] VMware [ ] Azure
    location: "Lincoln, NE Headquarters"

  - role: "File Server"
    os: "Windows Server 2019+"
    virtualization: [ ] Physical [X] Hyper-V [ ] VMware [ ] Azure
    location: "Lincoln, NE Headquarters"

  - role: "Document Management Server"
    os: "Windows Server 2019+"
    virtualization: [ ] Physical [X] Hyper-V [ ] VMware [ ] Azure
    location: "Lincoln, NE Headquarters"
```

**Active Directory:**
- **Domain Name:** TBD (kisselkohoutes.local estimated)
- **Forest Functional Level:** 2016 or higher
- **Azure AD Connect:** [X] Yes [ ] No [ ] Cloud Sync
- **Hybrid Configuration:** [X] Yes [ ] No
- **Number of Domain Controllers:** 2 (one per office)

**File Storage:**
- **File Server Location:** [X] On-Prem [ ] Cloud [ ] Hybrid
- **Total Storage Capacity:** TBD
- **Current Usage:** TBD (extensive document storage for legislative files)
- **Backup Solution:** TBD (with encryption and secure offsite backup)

**Database Servers:**
- **SQL Server:** [X] Yes [ ] No | Version: 2019+ | Databases: Client records, legislative tracking, analytics
- **Other Databases:** Document management database

### Line of Business Applications
```
Application Name                           | Vendor      | Hosting         | Users | Cloud-Ready?
-------------------------------------------|-------------|-----------------|-------|-------------
Legislative Tracking/Monitoring System     | TBD         | Cloud           | 25    | Y
Client Database/Relationship Mgmt (CRM)    | TBD         | Cloud           | 20    | Y
Document Management System                 | TBD         | On-Prem/Cloud   | 30    | N
Bill Tracking System                       | TBD         | Cloud           | 25    | Y
Regulatory Database                        | TBD         | Cloud/On-Prem   | 20    | Y
Client Portal                              | TBD         | Cloud           | 50+   | Y
Time/Billing Tracking                      | TBD         | Cloud/On-Prem   | 15    | Y
Secure Communications Platform             | TBD         | Cloud           | 30    | Y
```

**Critical Dependencies:**
- Legislative tracking system (critical during sessions)
- Client database/CRM (core business function)
- Document management system
- Secure communications for confidential client matters
- Bill tracking and compliance

---

## Security & Compliance

### Security Posture
**Current Security Solutions:**
- **Antivirus/Endpoint Protection:** TBD
- **EDR/MDR Solution:** TBD
- **Email Security:** Email encryption and DLP for confidential information
- **Web/Content Filtering:** TBD
- **SIEM/Log Management:** TBD
- **Backup Solution:** Secure encrypted backup with offsite storage
  - **Backup Frequency:** Daily
  - **Retention Period:** 3-5 years
  - **Offsite/Cloud Backup:** [X] Yes [ ] No

**Multi-Factor Authentication:**
- **MFA Enabled:** [X] Yes [ ] No [ ] Partial
- **MFA Method:** [X] Microsoft Authenticator [ ] SMS [X] Hardware Token [ ] Other: TBD
- **MFA Coverage:** 100% of staff accessing client data

**Conditional Access:**
- **Policies Configured:** [X] Yes [ ] No
- **Number of Policies:** 4+
- **Key Policies:** Client data access restrictions, multi-office authentication, legislative session access controls

### Compliance Requirements
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [X] Lobbying Disclosure Rules [ ] None [ ] Other: State ethics laws, client confidentiality requirements
- **Data Retention Requirements:** 3-5 years for client files, legislative records retention per state law
- **eDiscovery Needs:** [X] Yes [ ] No
- **Data Loss Prevention (DLP):** [X] Required [ ] Nice-to-have [ ] Not needed

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [ ] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [ ] Frequent [X] Occasional [ ] Rare
- **Security Training:** [X] Regular [ ] Annual [ ] None

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [X] On-Prem PBX [ ] Cloud PBX [ ] Teams Phone [ ] Other: TBD
- **Vendor/Model:** TBD (Avaya or similar legacy PBX)
- **Number of Lines/Extensions:** 15+
- **Auto Attendant/Call Queue:** [X] Yes [ ] No
- **Conference Room Phones:** 3-4 (includes secure conference rooms)
- **Analog Lines (Fax/Alarm):** 1-2 (legacy fax for government documents)

### Teams Voice
- **Teams Phone Deployment:** [ ] Yes [X] No [ ] Planned
- **PSTN Connectivity:** [ ] Calling Plan [X] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911):** [X] Configured [ ] Not Configured [ ] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** Encrypted backup with geographic redundancy
- **Items Backed Up:** [X] Servers [X] Workstations [X] M365 [X] Databases
- **M365 Backup:** [ ] Native [X] Third-Party: Secure backup service [ ] None
- **Backup Testing Frequency:** Quarterly

### Disaster Recovery
- **DR Plan Documented:** [X] Yes [ ] No
- **RTO (Recovery Time Objective):** 2 hours (important for legislative sessions)
- **RPO (Recovery Point Objective):** 1 hour
- **DR Site/Failover:** [ ] Yes [X] No | Location: TBD (cloud-based failover considered)
- **Cloud DR Strategy:** Cloud backup with rapid failover to secondary location

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [X] ConnectWise Automate [ ] N-able [ ] Other: TBD [ ] None
- **Monitoring Coverage:** [X] All devices [ ] Servers only [ ] None
- **Alert Response Time SLA:** 2-4 hours for critical systems

### Help Desk/Ticketing
- **PSA/Ticketing System:** ConnectWise Manage (estimated)
- **User Self-Service Portal:** [X] Yes [ ] No
- **Current Response Time:** 4-8 hours for non-critical issues

---

## Budget & Timeline

### Budget Information
- **IT Budget (Annual):** TBD
- **Spending Breakdown:**
  - Hardware: 15%
  - Software/Licenses: 40%
  - Services/Support: 35%
  - Projects: 10%

- **Capital Available for Projects:** TBD
- **OpEx vs CapEx Preference:** [X] Prefer OpEx [ ] Prefer CapEx [ ] No preference

### Timeline & Priorities
**Immediate Needs (0-30 days):**
- Ensure secure communications capabilities
- Support legislative session operations

**Short-Term Projects (1-6 months):**
- Implement client portal for improved transparency
- Enhance document management system
- Upgrade legislative tracking capabilities
- Strengthen confidentiality/encryption protections

**Long-Term Goals (6-12+ months):**
- Migrate legacy PBX to cloud-based solution
- Implement advanced analytics for client service delivery
- Develop integrated regulatory tracking system
- Expand multi-office collaboration capabilities

**Budget Approval Process:** Partner approval, operations manager sign-off
**Decision Maker(s):** Partners/Managing Director

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name                    | Service Provided           | Contract Term | Satisfaction
-------------------------------|---------------------------|---------------|-------------
ConnectWise (estimated)        | RMM/Monitoring             | Annual        | TBD
TBD                            | Legislative Tracking       | Annual        | TBD
TBD                            | Document Management        | Annual        | TBD
TBD                            | Secure Communications      | Annual        | TBD
```

### MSP Service Expectations
- **Desired Service Level:** [X] Co-Managed IT [ ] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [X] Email [X] Phone [X] Teams [ ] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [X] Bi-Weekly [ ] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:** During legislative sessions, priority support required

---

## Additional Notes

### Special Considerations
```
GOVERNMENT RELATIONS & LOBBYING CONSIDERATIONS:
- Client confidentiality is paramount - all systems must ensure data security and privilege protection
- Lobbying disclosure regulations may require document retention and audit trails
- Legislative session periods (typically 60+ days annually) create high-demand IT support periods
- Multiple client sectors (energy, healthcare, education, railways, beer distribution) have different needs
- Bi-partisan nature requires careful neutrality in systems and communications
- Relationships with Nebraska Unicameral and county/city government officials are core business asset
- Government procurement timelines for legislative tracking systems can be lengthy
- Document management must support legal discovery and confidentiality
- Email communications may be subject to public records requests - careful handling required
- Multi-office coordination (Lincoln and Omaha) critical during legislative sessions
- Attorneys and advocates may have professional liability requirements for systems/communications
- Client billing and time tracking critical for law firm operations
- Reputation management critical - "Tested. Trusted. Effective" requires reliable systems
- Integration with state legislature systems (bills, voting records, committee information) important
- Potential need for integration with federal lobbying disclosure systems
```

### Customer Strengths
```
- Established firm (since 1994) shows longevity and client trust
- Bi-partisan approach provides stability across political administrations
- Diverse client base (energy, healthcare, education, railways, beer distribution) reduces risk
- Strong reputation ("Tested. Trusted. Effective.") indicates quality service
- Multiple offices show growth and expansion capability
- Experienced team of advocates and attorneys
```

### Opportunities for Improvement
```
- Implement modern client portal for better transparency and service delivery
- Upgrade legacy PBX to cloud-based solution for better flexibility
- Implement advanced legislative tracking with AI/ML analysis
- Enhance secure communications platform capabilities
- Implement integrated regulatory database across all sectors served
- Develop predictive analytics for legislative outcomes
- Implement advanced document management with AI-assisted search
- Create integrated time tracking and billing system
- Implement automated lobbying disclosure compliance reporting
- Develop mobile applications for legislators and clients
- Implement advanced cyber security for confidential information
```

---

## Profile Completion Checklist
- [X] Basic customer information completed
- [X] User counts and distribution documented
- [X] All office locations documented with network details
- [X] Current Microsoft 365 licensing documented
- [X] Security posture assessed
- [X] Backup strategy documented
- [X] Pain points and objectives identified
- [X] Budget and timeline discussed
- [ ] Profile reviewed with customer
- [ ] Profile reviewed with technical team

**Profile Completed By:** Initial Profile
**Date:** 2025-11-20
**Next Review Date:** TBD (Recommend before next legislative session)
