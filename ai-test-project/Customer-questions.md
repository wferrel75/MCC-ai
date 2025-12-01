# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:**
**Profile Created Date:**
**Last Updated:**
**Account Manager:**
**Primary Technical Contact:**
**Industry/Vertical:**

---

## Business Overview

### Company Information
- **Number of Employees:**
- **Number of IT Staff:**
- **Annual Revenue Range:**
- **Business Type:** [ ] B2B [ ] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:**
- **Time Zone(s):**

### Business Objectives
**Primary Business Goals:**
-
-
-

**Technology Initiatives (Next 12 Months):**
-
-
-

**Pain Points/Challenges:**
-
-
-

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
  - name: "Headquarters"
    address: ""
    user_count:
    internet_provider: ""
    bandwidth_down: ""
    bandwidth_up: ""
    site_type: [ ] Primary [ ] Branch [ ] Remote Office [ ] Data Center

  - name: ""
    address: ""
    user_count:
    internet_provider: ""
    bandwidth_down: ""
    bandwidth_up: ""
    site_type: [ ] Primary [ ] Branch [ ] Remote Office [ ] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [ ] Site-to-Site VPN [ ] SD-WAN [ ] None [ ] Other: ___
- **Primary WAN Provider:**
- **Backup/Redundant Connections:** [ ] Yes [ ] No
  - Details:

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:**
- **Firmware Version:**
- **Management:** [ ] Cloud-Managed [ ] On-Prem [ ] Hybrid
- **Features in Use:** [ ] VPN [ ] Content Filtering [ ] IPS/IDS [ ] Application Control

**Network Equipment:**
- **Switch Vendor/Model:**
- **Wireless AP Vendor/Model:**
- **Network Management:** [ ] Ubiquiti (UniFi) [ ] Cisco Meraki [ ] Aruba [ ] Other: ___

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
Application Name    | Vendor      | Hosting         | Users | Cloud-Ready?
--------------------|-------------|-----------------|-------|-------------
                    |             | [On-Prem/Cloud] |       | [Y/N]
                    |             | [On-Prem/Cloud] |       | [Y/N]
                    |             | [On-Prem/Cloud] |       | [Y/N]
```

**Critical Dependencies:**
-
-

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
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [ ] CMMC [ ] None [ ] Other: ___
- **Data Retention Requirements:**
- **eDiscovery Needs:** [ ] Yes [ ] No
- **Data Loss Prevention (DLP):** [ ] Required [ ] Nice-to-have [ ] Not needed

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
                |                           |               | [1-5]
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
[Free-form section for any unique requirements, constraints, or context]





```

### Customer Strengths
```
[What is this customer doing well from an IT perspective?]




```

### Opportunities for Improvement
```
[Key areas where customer could benefit from improvement]




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
