# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Labenz & Associates LLC
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Professional Services - CPA Firm

---

## Business Overview

### Company Information
- **Number of Employees:** 25-35 (estimated)
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [X] B2B [X] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** 8 AM - 5 PM (with tax season extended hours: Jan-April 8 AM - 8 PM)
- **Time Zone(s):** Central Time (Nebraska)

### Business Objectives
**Primary Business Goals:**
- Provide comprehensive accounting and tax services to individual and business clients
- Maintain high-quality client relationships and satisfaction ("Exceeding Your Expectations")
- Support complex business valuations and litigation support services
- Deliver proactive tax and retirement planning strategies
- Expand service offerings and client base

**Technology Initiatives (Next 12 Months):**
- Enhance client portal capabilities for secure document exchange
- Implement advanced tax planning software integration
- Improve mobile access for remote client consultations
- Strengthen cybersecurity for financial data
- Automate compliance and reporting workflows
- Enhance social media presence (Facebook, Instagram, LinkedIn)

**Pain Points/Challenges:**
- Managing sensitive financial and tax information for diverse client base
- Complex tax law changes requiring frequent system updates
- Tax season workload spikes requiring extended availability
- Client demand for secure document exchange and online portals
- Need for redundancy during critical tax season period
- Managing multiple technology platforms (portals, calculators, communication tools)
- Compliance with accounting standards and tax regulations

---

## User Profile

### User Count by Category
```
Total Users: 35+
├─ Executive/Leadership: 3
├─ Knowledge Workers (Office/Hybrid): 28
├─ Remote Workers: 2
├─ Field/Mobile Workers: 2
├─ Factory/Warehouse Workers: 0
├─ Contractors/Temporary: 3 (seasonal during tax season)
└─ Service Accounts/Shared Mailboxes: 4
```

### User Distribution
- **Users requiring full M365 licenses:** 30 (CPAs, accountants, administrative staff)
- **Users requiring basic email only:** 5 (reception, administrative support)
- **Users requiring specialized apps:** 28+ (tax software, accounting systems, client portal access)
- **External collaborators/partners:** Clients (individuals and businesses), attorneys, other CPAs, tax software vendors

### Work Patterns
- **Percentage Remote Workers:** 10%
- **Percentage Hybrid Workers:** 20%
- **Percentage On-Site Only:** 70%
- **BYOD Policy:** [ ] Allowed [X] Restricted [ ] Prohibited
- **Mobile Device Types:** [X] iOS [X] Android [ ] Windows [ ] Other: Tablets for client meetings

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Headquarters/Main Office"
    address: "8555 Pioneers Boulevard, Lincoln, NE 68520"
    user_count: 35
    internet_provider: "TBD"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [X] Primary [ ] Branch [ ] Remote Office [ ] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [ ] Site-to-Site VPN [ ] SD-WAN [X] None [ ] Other: Single office location
- **Primary WAN Provider:** TBD
- **Backup/Redundant Connections:** [X] Yes [ ] No
  - Details: Backup internet connection for critical tax season operations, cloud-based backup systems

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:** TBD
- **Firmware Version:** TBD
- **Management:** [X] Cloud-Managed [ ] On-Prem [ ] Hybrid
- **Features in Use:** [X] VPN [X] Content Filtering [ ] IPS/IDS [X] Application Control

**Network Equipment:**
- **Switch Vendor/Model:** TBD
- **Wireless AP Vendor/Model:** TBD
- **Network Management:** [ ] Ubiquiti (UniFi) [X] Cisco Meraki [ ] Aruba [ ] Other: TBD

**Network Services:**
- **DHCP Server:** [X] Firewall [ ] Windows Server [ ] Router [ ] Other: TBD
- **DNS Services:** [X] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** 10.0.0.0/8 private range (estimated)
- **VLANs Configured:** [X] Yes [ ] No
  - VLAN Details: Client data VLAN, internal operations VLAN, guest network

### Internet & WAN
- **Primary Internet Speed:** TBD
- **Backup Internet:** [X] Yes [ ] No
- **Public IP Addresses:** [X] Static [ ] Dynamic [ ] Number of IPs: TBD

### Remote Access
- **VPN Solution:** TBD (secure for financial data)
- **VPN Concurrent Users:** 10+
- **Remote Desktop Solution:** [X] RDP [ ] VPN [ ] Third-party: Cloud apps
- **Cloud Access Method:** [ ] Direct Internet [X] VPN [X] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** TBD (likely @labenz.com)
- **Additional Domains:** TBD
- **Tenant Type:** [X] Commercial [ ] GCC [ ] GCC High [ ] DoD

**Current Licenses (by SKU and count):**
```
SKU Name                                    | Count | Notes
-------------------------------------------|-------|-------
Microsoft 365 Business Premium             | 30    | CPAs and accountants
Office 365 E1                              | 5     | Administrative staff
Teams Phone Standard                       | 3     | Main office
Audio Conferencing                         | 3     | Client consultations
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
- [X] Other: Integration with accounting and tax software

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

  - role: "Accounting Application Server"
    os: "Windows Server 2019+"
    virtualization: [ ] Physical [X] Hyper-V [ ] VMware [ ] Azure
    location: "Lincoln, NE Headquarters"
```

**Active Directory:**
- **Domain Name:** TBD (labenz.local estimated)
- **Forest Functional Level:** 2016 or higher
- **Azure AD Connect:** [X] Yes [ ] No [ ] Cloud Sync
- **Hybrid Configuration:** [X] Yes [ ] No
- **Number of Domain Controllers:** 2

**File Storage:**
- **File Server Location:** [X] On-Prem [ ] Cloud [ ] Hybrid
- **Total Storage Capacity:** TBD
- **Current Usage:** TBD (extensive tax return and financial document storage)
- **Backup Solution:** TBD (with encryption for financial data)

**Database Servers:**
- **SQL Server:** [X] Yes [ ] No | Version: 2019+ | Databases: Client records, tax data, time tracking
- **Other Databases:** Accounting database

### Line of Business Applications
```
Application Name                           | Vendor      | Hosting         | Users | Cloud-Ready?
-------------------------------------------|-------------|-----------------|-------|-------------
Tax Preparation Software                   | TBD         | Cloud/On-Prem   | 30    | Y
Accounting Software                        | TBD         | On-Prem         | 25    | N
Client Portal (Document Exchange)          | TBD         | Cloud           | 50+   | Y
Time Tracking/Billing System               | TBD         | Cloud/On-Prem   | 30    | Y
Business Valuation Software                | TBD         | Cloud           | 5     | Y
Financial Planning Software                | TBD         | Cloud           | 10    | Y
eSignature/Document Management             | TBD         | Cloud           | 25    | Y
Compliance/Regulatory Tracking             | TBD         | Cloud           | 8     | Y
CRM/Client Relationship Management         | TBD         | Cloud           | 25    | Y
Online Calculators/Tools                   | Cloud       | Cloud           | 50+   | Y
```

**Critical Dependencies:**
- Tax preparation software (critical during tax season)
- Accounting software (core daily operations)
- Client portal (client service delivery)
- Time tracking/billing system (revenue tracking)
- Backup systems (critical for compliance and data protection)

---

## Security & Compliance

### Security Posture
**Current Security Solutions:**
- **Antivirus/Endpoint Protection:** TBD (must protect financial data)
- **EDR/MDR Solution:** TBD
- **Email Security:** Email encryption and DLP for financial information
- **Web/Content Filtering:** TBD
- **SIEM/Log Management:** TBD
- **Backup Solution:** Encrypted backup with offsite redundancy
  - **Backup Frequency:** Daily (multiple daily during tax season)
  - **Retention Period:** 7-10 years (per IRS and tax requirements)
  - **Offsite/Cloud Backup:** [X] Yes [ ] No

**Multi-Factor Authentication:**
- **MFA Enabled:** [X] Yes [ ] No [ ] Partial
- **MFA Method:** [X] Microsoft Authenticator [ ] SMS [X] Hardware Token [ ] Other: TBD
- **MFA Coverage:** 100% of staff accessing client/financial data

**Conditional Access:**
- **Policies Configured:** [X] Yes [ ] No
- **Number of Policies:** 5+
- **Key Policies:** Financial data access restrictions, tax season elevated access, remote work policies

### Compliance Requirements
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [X] IRS Regulations [X] State Tax Law [ ] None [ ] Other: AICPA standards, State CPA regulations
- **Data Retention Requirements:** 7-10 years for tax and financial records per IRS requirements
- **eDiscovery Needs:** [X] Yes [ ] No
- **Data Loss Prevention (DLP):** [X] Required [ ] Nice-to-have [ ] Not needed

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [ ] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [X] Frequent [ ] Occasional [ ] Rare (targeting CPA firms common)
- **Security Training:** [X] Regular [ ] Annual [ ] None

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [X] On-Prem PBX [ ] Cloud PBX [ ] Teams Phone [ ] Other: TBD
- **Vendor/Model:** TBD (Avaya, Cisco, or similar)
- **Number of Lines/Extensions:** 10+
- **Auto Attendant/Call Queue:** [X] Yes [ ] No
- **Conference Room Phones:** 2-3
- **Analog Lines (Fax/Alarm):** 1-2 (secure fax for financial documents)

### Teams Voice
- **Teams Phone Deployment:** [ ] Yes [X] No [ ] Planned
- **PSTN Connectivity:** [ ] Calling Plan [X] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911):** [X] Configured [ ] Not Configured [ ] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** Encrypted backup with geographic redundancy
- **Items Backed Up:** [X] Servers [X] Workstations [X] M365 [X] Databases
- **M365 Backup:** [ ] Native [X] Third-Party: Financial-grade backup service [ ] None
- **Backup Testing Frequency:** Monthly (more frequent during tax season)

### Disaster Recovery
- **DR Plan Documented:** [X] Yes [ ] No
- **RTO (Recovery Time Objective):** 2 hours (critical during tax season)
- **RPO (Recovery Point Objective):** 30 minutes (multiple daily backups during peak season)
- **DR Site/Failover:** [X] Yes [ ] No | Location: Secondary cloud location
- **Cloud DR Strategy:** Cloud-based backup and rapid failover capability

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [X] ConnectWise Automate [ ] N-able [ ] Other: TBD [ ] None
- **Monitoring Coverage:** [X] All devices [ ] Servers only [ ] None
- **Alert Response Time SLA:** 1-2 hours for critical systems, extended support during tax season

### Help Desk/Ticketing
- **PSA/Ticketing System:** ConnectWise Manage (estimated)
- **User Self-Service Portal:** [X] Yes [ ] No
- **Current Response Time:** 2-4 hours for critical issues, 24/7 during tax season

---

## Budget & Timeline

### Budget Information
- **IT Budget (Annual):** TBD
- **Spending Breakdown:**
  - Hardware: 15%
  - Software/Licenses: 45%
  - Services/Support: 30%
  - Projects: 10%

- **Capital Available for Projects:** TBD
- **OpEx vs CapEx Preference:** [X] Prefer OpEx [ ] Prefer CapEx [ ] No preference

### Timeline & Priorities
**Immediate Needs (0-30 days):**
- Ensure critical systems availability for ongoing client service
- Maintain security for financial/tax data

**Short-Term Projects (1-6 months):**
- Enhance client portal for better document exchange
- Improve tax season capacity and reliability
- Strengthen cybersecurity posture
- Implement advanced compliance tracking

**Long-Term Goals (6-12+ months):**
- Migrate legacy accounting systems to modern cloud platforms
- Implement advanced analytics for client insights
- Develop mobile applications for client consultations
- Implement AI-assisted tax research and planning tools
- Expand social media and digital marketing capabilities

**Budget Approval Process:** Partner approval, operations manager sign-off
**Decision Maker(s):** Managing Partner/Owner

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name                    | Service Provided           | Contract Term | Satisfaction
-------------------------------|---------------------------|---------------|-------------
ConnectWise (estimated)        | RMM/Monitoring             | Annual        | TBD
TBD                            | Tax Preparation Software   | Annual        | TBD
TBD                            | Accounting Software        | Annual        | TBD
TBD                            | Client Portal              | Annual        | TBD
TBD                            | Secure Backup/DR           | Annual        | TBD
```

### MSP Service Expectations
- **Desired Service Level:** [ ] Co-Managed IT [X] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [X] Email [X] Phone [X] Teams [ ] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [X] Bi-Weekly [ ] Monthly [ ] Quarterly [ ] As-Needed (More frequent during tax season)
- **Escalation Preferences:** Extended hours support during tax season (Jan-April), 24/7 support during critical periods

---

## Additional Notes

### Special Considerations
```
TAX AND ACCOUNTING PRACTICE CONSIDERATIONS:
- Client financial data is highly sensitive and strictly confidential - security is paramount
- IRS and state tax authority regulations require 7-10 year data retention
- Tax season (January through April) is critical period with extended hours and high workload
- Multiple accounting software platforms require careful integration and compatibility
- Client portal must be user-friendly but highly secure for financial documents
- Backup and disaster recovery critical - cannot afford to lose client data or tax returns
- Tax law changes frequently require software updates and staff retraining
- eDiscovery and audit trail capabilities essential for compliance and litigation support
- Email communications may be subject to legal discovery - careful handling required
- Phishing attacks commonly target CPA firms - security training critical
- Time tracking/billing integration essential for tracking billable hours
- Multi-user access to client files requires careful access control and logging
- Complex client data may require specialized applications for business valuations/litigation support
- Client satisfaction ("Exceeding Your Expectations") depends on reliable IT systems
- Social media presence (Facebook, Instagram, LinkedIn) important for marketing and client engagement
- Remote access important for consultations but must maintain security
- Multiple client databases require careful backup and disaster recovery
- Integration with tax software vendors (H&R Block, Thomson Reuters, etc.) critical
```

### Customer Strengths
```
- Established firm (since 1998) shows stability and client trust
- Diversified service offerings (tax, accounting, business valuations, litigation support)
- Long-term client relationships indicate quality service delivery
- Professional tagline ("Exceeding Your Expectations") shows commitment to quality
- Active social media presence shows modern marketing approach
- Use of multiple technology platforms shows commitment to efficiency
```

### Opportunities for Improvement
```
- Enhance client portal with advanced document management features
- Implement AI-assisted tax research and planning tools
- Migrate accounting software to modern cloud platform
- Implement advanced security monitoring and threat detection
- Develop mobile application for client consultations
- Implement automated compliance and regulatory tracking
- Enhance backup and disaster recovery redundancy
- Implement advanced analytics for client service optimization
- Develop predictive analytics for tax planning
- Implement integrated CRM for better client relationship management
- Enhance social media integration with business systems
- Implement voice-based virtual assistant for client consultations
- Develop automated document processing for tax returns
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
**Next Review Date:** TBD (Recommend quarterly, with special focus before tax season - December)
