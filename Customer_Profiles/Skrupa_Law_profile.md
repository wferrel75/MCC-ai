# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Skrupa Law Office
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Legal Services - Bankruptcy Law

---

## Business Overview

### Company Information
- **Number of Employees:** TBD
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [x] B2B [ ] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** Standard Business Hours (9 AM - 5 PM)
- **Time Zone(s):** Central Time (CT)

### Business Objectives
**Primary Business Goals:**
- Provide compassionate, client-focused bankruptcy law representation
- Maintain secure and confidential client case management
- Offer free consultations to prospective clients

**Technology Initiatives (Next 12 Months):**
- Enhance client communication and case management systems
- Improve document security and retention for legal compliance
- Evaluate practice management software solutions

**Pain Points/Challenges:**
- Managing confidential client information securely
- Ensuring compliance with legal and ethical regulations
- Maintaining disaster recovery and backup for critical case files

---

## User Profile

### User Count by Category
```
Total Users: TBD
├─ Executive/Leadership: TBD
├─ Knowledge Workers (Office/Hybrid): TBD
├─ Remote Workers: TBD
├─ Field/Mobile Workers: TBD
├─ Factory/Warehouse Workers: N/A
├─ Contractors/Temporary: TBD
└─ Service Accounts/Shared Mailboxes: TBD
```

### User Distribution
- **Users requiring full M365 licenses:** TBD
- **Users requiring basic email only:** TBD
- **Users requiring specialized apps:** Legal practice management software users
- **External collaborators/partners:** TBD

### Work Patterns
- **Percentage Remote Workers:** TBD
- **Percentage Hybrid Workers:** TBD
- **Percentage On-Site Only:** TBD
- **BYOD Policy:** [ ] Allowed [ ] Restricted [x] Prohibited
- **Mobile Device Types:** TBD

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Skrupa Law Office - Main Office"
    address: "Nebraska"
    user_count: TBD
    internet_provider: TBD
    bandwidth_down: TBD
    bandwidth_up: TBD
    site_type: [x] Primary [ ] Branch [ ] Remote Office [ ] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [ ] Site-to-Site VPN [ ] SD-WAN [x] None [ ] Other: ___
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
    os: TBD
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Nebraska Office"

  - role: "File Server"
    os: TBD
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Nebraska Office"
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
Application Name              | Vendor      | Hosting         | Users | Cloud-Ready?
------------------------------|-------------|-----------------|-------|-------------
Legal Practice Management     | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Case/Document Management      | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Billing/Accounting Software   | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Client Portal                 | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Time Tracking                 | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
```

**Critical Dependencies:**
- Secure client data storage and transmission
- Compliance with legal privilege and attorney-client confidentiality

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
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [x] Other: Attorney-Client Privilege (ACP), Legal Ethics Rules, State Bar Requirements
- **Data Retention Requirements:** Legal holds and statute of limitations requirements (typically 7+ years for bankruptcy cases)
- **eDiscovery Needs:** [x] Yes [ ] No
- **Data Loss Prevention (DLP):** [x] Required [ ] Nice-to-have [ ] Not needed

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
- **Analog Lines (Fax/Alarm):** TBD

### Teams Voice
- **Teams Phone Deployment:** [ ] Yes [ ] No [ ] Planned
- **PSTN Connectivity:** [ ] Calling Plan [ ] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911):** [ ] Configured [ ] Not Configured [ ] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** TBD
- **Items Backed Up:** [x] Servers [x] Workstations [x] M365 [x] Databases
- **M365 Backup:** [ ] Native [ ] Third-Party: ___ [ ] None
- **Backup Testing Frequency:** TBD

### Disaster Recovery
- **DR Plan Documented:** [ ] Yes [ ] No
- **RTO (Recovery Time Objective):** 4 hours (critical case files)
- **RPO (Recovery Point Objective):** 1 hour
- **DR Site/Failover:** [ ] Yes [ ] No | Location: TBD
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
- Security assessment for client data handling
- Compliance review for legal/ethical requirements

**Short-Term Projects (1-6 months):**
- Implement enhanced backup and disaster recovery
- Strengthen email security and phishing protection

**Long-Term Goals (6-12+ months):**
- Evaluate modern legal practice management platforms
- Implement advanced eDiscovery capabilities

**Budget Approval Process:** TBD
**Decision Maker(s):** TBD

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name     | Service Provided           | Contract Term | Satisfaction
----------------|---------------------------|---------------|-------------
                |                           |               | [1-5]
                |                           |               | [1-5]
                |                           |               | [1-5]
```

### MSP Service Expectations
- **Desired Service Level:** [ ] Co-Managed IT [x] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [ ] Email [x] Phone [ ] Teams [ ] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [ ] Bi-Weekly [x] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:** Direct to managing partner for security/compliance issues

---

## Additional Notes

### Special Considerations
```
LEGAL COMPLIANCE CRITICAL:
- Attorney-client privilege must be maintained for all communications and data storage
- All client information subject to state bar rules and confidentiality requirements
- eDiscovery support needed for bankruptcy case management
- All staff require understanding of legal ethics and confidentiality obligations
- Documentation retention requirements tied to statute of limitations (7+ years for bankruptcy cases)
- Website: www.skrupalawoffice.com
- Tagline: "Providing Compassionate Guidance Through Bankruptcy Law"
- Key service: Free consultations for bankruptcy clients
```

### Customer Strengths
```
- Clear mission-focused organization aligned with client service
- Likely to prioritize data security given legal obligations
- Understanding of compliance requirements from legal practice
- Professional standards and ethics training already in place
```

### Opportunities for Improvement
```
- Implement comprehensive disaster recovery plan
- Deploy advanced email security to prevent privileged information disclosure
- Establish formal backup and data retention policies
- Consider practice management software consolidation
- Implement multi-factor authentication for all users
- Regular security awareness training specific to legal practice risks
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
