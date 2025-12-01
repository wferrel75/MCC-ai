# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Helget Home Care (Capital Medical)
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Healthcare - Durable Medical Equipment (DME)

---

## Business Overview

### Company Information
- **Number of Employees:** 50+ (estimated)
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [ ] B2B [X] B2C [X] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** 24/7 (24-hour delivery service)
- **Time Zone(s):** Central Time (Nebraska/Iowa)

### Business Objectives
**Primary Business Goals:**
- Maintain 24/7 delivery service capability for medical equipment
- Expand service area and carrier partnerships
- Improve operational efficiency while maintaining JCAHO accreditation
- Support integration with 300+ insurance carrier systems

**Technology Initiatives (Next 12 Months):**
- Improve fleet management and dispatch systems
- Enhance customer portal for equipment ordering and tracking
- Integrate insurance carrier billing systems
- Improve mobile access for delivery personnel

**Pain Points/Challenges:**
- Managing complex insurance carrier integrations (300+ providers)
- Fleet management with geographic distribution across Nebraska and Western Iowa
- 24/7 operations requiring always-available IT support
- Ensuring HIPAA compliance across all systems and communications
- Integration of multiple service lines (respiratory, rehabilitation, DME)

---

## User Profile

### User Count by Category
```
Total Users: 50+
├─ Executive/Leadership: 5
├─ Knowledge Workers (Office/Hybrid): 15
├─ Remote Workers: 3
├─ Field/Mobile Workers: 25
├─ Factory/Warehouse Workers: 5
├─ Contractors/Temporary: 2
└─ Service Accounts/Shared Mailboxes: 5
```

### User Distribution
- **Users requiring full M365 licenses:** 25 (office/management)
- **Users requiring basic email only:** 20 (field workers)
- **Users requiring specialized apps:** 25 (fleet/dispatch systems)
- **External collaborators/partners:** 300+ insurance carriers, medical facilities

### Work Patterns
- **Percentage Remote Workers:** 10%
- **Percentage Hybrid Workers:** 30%
- **Percentage On-Site Only:** 60%
- **BYOD Policy:** [ ] Allowed [X] Restricted [ ] Prohibited
- **Mobile Device Types:** [X] iOS [X] Android [X] Windows [ ] Other: Mobile fleet management devices

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Headquarters/Operations"
    address: "4211 S 102nd, Omaha, NE 68127"
    user_count: 30
    internet_provider: "TBD"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [X] Primary [ ] Branch [ ] Remote Office [ ] Data Center

  - name: "Service Delivery (Mobile)"
    address: "Multiple locations across Nebraska and Western Iowa"
    user_count: 25
    internet_provider: "TBD (Mobile Cellular)"
    bandwidth_down: "Mobile LTE/4G"
    bandwidth_up: "Mobile LTE/4G"
    site_type: [ ] Primary [X] Branch [ ] Remote Office [ ] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [X] Site-to-Site VPN [ ] SD-WAN [ ] None [ ] Other: Cloud-based coordination
- **Primary WAN Provider:** TBD
- **Backup/Redundant Connections:** [X] Yes [ ] No
  - Details: Mobile connectivity for field operations, cloud backup coordination

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:** TBD
- **Firmware Version:** TBD
- **Management:** [ ] Cloud-Managed [X] On-Prem [ ] Hybrid
- **Features in Use:** [X] VPN [X] Content Filtering [X] IPS/IDS [ ] Application Control

**Network Equipment:**
- **Switch Vendor/Model:** TBD
- **Wireless AP Vendor/Model:** TBD
- **Network Management:** [ ] Ubiquiti (UniFi) [ ] Cisco Meraki [ ] Aruba [ ] Other: TBD

**Network Services:**
- **DHCP Server:** [ ] Firewall [X] Windows Server [ ] Router [ ] Other: TBD
- **DNS Services:** [X] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** 10.0.0.0/8 private range (estimated)
- **VLANs Configured:** [X] Yes [ ] No
  - VLAN Details: Patient data VLAN, administrative VLAN, guest network, field access VLAN

### Internet & WAN
- **Primary Internet Speed:** TBD
- **Backup Internet:** [X] Yes [ ] No
- **Public IP Addresses:** [X] Static [ ] Dynamic [ ] Number of IPs: TBD

### Remote Access
- **VPN Solution:** TBD (likely HIPAA-compliant)
- **VPN Concurrent Users:** 25+
- **Remote Desktop Solution:** [X] RDP [ ] VPN [ ] Third-party: Mobile apps
- **Cloud Access Method:** [ ] Direct Internet [X] VPN [X] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** TBD
- **Additional Domains:** TBD
- **Tenant Type:** [X] Commercial [ ] GCC [ ] GCC High [ ] DoD

**Current Licenses (by SKU and count):**
```
SKU Name                                    | Count | Notes
-------------------------------------------|-------|-------
Microsoft 365 Business Premium             | 25    | Office/management staff
Office 365 E1                              | 20    | Field workers (email)
Teams Phone Standard                       | 10    | Office locations
Audio Conferencing                         | 5     | Management
Power BI Pro                               | 3     | Analytics/reporting
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
- [X] Other: HIPAA-compliant email encryption

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller"
    os: "Windows Server 2019+"
    virtualization: [X] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha, NE Headquarters"

  - role: "File Server"
    os: "Windows Server 2019+"
    virtualization: [X] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha, NE Headquarters"

  - role: "Application Server (Dispatch/Fleet)"
    os: "Windows Server 2019+"
    virtualization: [ ] Physical [X] Hyper-V [ ] VMware [ ] Azure
    location: "Omaha, NE Headquarters"
```

**Active Directory:**
- **Domain Name:** TBD
- **Forest Functional Level:** 2016 or higher
- **Azure AD Connect:** [X] Yes [ ] No [ ] Cloud Sync
- **Hybrid Configuration:** [X] Yes [ ] No
- **Number of Domain Controllers:** 2+

**File Storage:**
- **File Server Location:** [X] On-Prem [ ] Cloud [ ] Hybrid
- **Total Storage Capacity:** TBD
- **Current Usage:** TBD
- **Backup Solution:** TBD (must be HIPAA-compliant)

**Database Servers:**
- **SQL Server:** [X] Yes [ ] No | Version: 2019+ | Databases: Insurance integration, patient records, fleet management
- **Other Databases:** TBD

### Line of Business Applications
```
Application Name                           | Vendor      | Hosting         | Users | Cloud-Ready?
-------------------------------------------|-------------|-----------------|-------|-------------
Fleet Management/Dispatch System           | TBD         | On-Prem         | 30    | N
Insurance Carrier Integration Platform     | TBD         | Cloud           | 25    | Y
Patient/Customer Portal                    | TBD         | Cloud/On-Prem   | TBD   | Y
Respiratory Equipment Monitoring           | TBD         | Cloud           | 25    | Y
Billing and Invoicing System               | TBD         | On-Prem         | 10    | N
Electronic Health Records (EHR) System     | TBD         | On-Prem/Cloud   | 20    | N
Inventory Management System                | TBD         | On-Prem         | 10    | N
Compliance/Audit Tracking                  | TBD         | Cloud           | 5     | Y
```

**Critical Dependencies:**
- Dispatch system (critical for 24/7 operations)
- Insurance carrier billing integration
- Patient data security systems
- Compliance tracking systems

---

## Security & Compliance

### Security Posture
**Current Security Solutions:**
- **Antivirus/Endpoint Protection:** HIPAA-compliant solution (TBD)
- **EDR/MDR Solution:** TBD
- **Email Security:** HIPAA-compliant encryption and DLP
- **Web/Content Filtering:** TBD
- **SIEM/Log Management:** TBD
- **Backup Solution:** HIPAA-compliant backup (TBD)
  - **Backup Frequency:** Daily minimum
  - **Retention Period:** 7 years (HIPAA requirement)
  - **Offsite/Cloud Backup:** [X] Yes [ ] No

**Multi-Factor Authentication:**
- **MFA Enabled:** [X] Yes [ ] No [ ] Partial
- **MFA Method:** [X] Microsoft Authenticator [ ] SMS [X] Hardware Token [ ] Other: TBD
- **MFA Coverage:** 100% of users

**Conditional Access:**
- **Policies Configured:** [X] Yes [ ] No
- **Number of Policies:** 5+
- **Key Policies:** Healthcare data access restrictions, geographic restrictions, device compliance

### Compliance Requirements
- **Industry Regulations:** [X] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [X] JCAHO [ ] None [ ] Other: State-specific healthcare regulations
- **Data Retention Requirements:** 7 years for medical records, ongoing for patient history
- **eDiscovery Needs:** [X] Yes [ ] No
- **Data Loss Prevention (DLP:** [X] Required [ ] Nice-to-have [ ] Not needed

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [ ] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [X] Frequent [ ] Occasional [ ] Rare
- **Security Training:** [X] Regular [ ] Annual [ ] None

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [ ] On-Prem PBX [X] Cloud PBX [ ] Teams Phone [ ] Other: TBD
- **Vendor/Model:** TBD (HIPAA-compliant)
- **Number of Lines/Extensions:** 15+
- **Auto Attendant/Call Queue:** [X] Yes [ ] No
- **Conference Room Phones:** 2-3
- **Analog Lines (Fax/Alarm):** Fax system for medical records

### Teams Voice
- **Teams Phone Deployment:** [X] Yes [ ] No [ ] Planned
- **PSTN Connectivity:** [X] Calling Plan [ ] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911:** [X] Configured [ ] Not Configured [ ] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** HIPAA-compliant backup system
- **Items Backed Up:** [X] Servers [X] Workstations [X] M365 [X] Databases
- **M365 Backup:** [ ] Native [X] Third-Party: HIPAA-compliant service [ ] None
- **Backup Testing Frequency:** Monthly

### Disaster Recovery
- **DR Plan Documented:** [X] Yes [ ] No
- **RTO (Recovery Time Objective):** 4 hours (critical for 24/7 operations)
- **RPO (Recovery Point Objective):** 1 hour
- **DR Site/Failover:** [X] Yes [ ] No | Location: Secondary location in Iowa
- **Cloud DR Strategy:** Cloud-based backup and failover capabilities

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [X] ConnectWise Automate [ ] N-able [ ] Other: TBD [ ] None
- **Monitoring Coverage:** [X] All devices [X] Servers only [ ] None
- **Alert Response Time SLA:** 2 hours for critical systems, 24/7 escalation support

### Help Desk/Ticketing
- **PSA/Ticketing System:** ConnectWise (estimated)
- **User Self-Service Portal:** [X] Yes [ ] No
- **Current Response Time:** 2-4 hours for critical issues

---

## Budget & Timeline

### Budget Information
- **IT Budget (Annual):** TBD
- **Spending Breakdown:**
  - Hardware: 25%
  - Software/Licenses: 35%
  - Services/Support: 30%
  - Projects: 10%

- **Capital Available for Projects:** TBD
- **OpEx vs CapEx Preference:** [X] Prefer OpEx [ ] Prefer CapEx [ ] No preference

### Timeline & Priorities
**Immediate Needs (0-30 days):**
- Maintain JCAHO accreditation compliance
- Ensure 24/7 system availability

**Short-Term Projects (1-6 months):**
- Enhance insurance carrier integration capabilities
- Improve mobile access for field personnel
- Strengthen security posture for HIPAA compliance

**Long-Term Goals (6-12+ months):**
- Migration to cloud-based EHR if beneficial
- Implement advanced analytics for operational efficiency
- Expand service area IT infrastructure

**Budget Approval Process:** Executive management/ownership approval
**Decision Maker(s):** Owner/CEO, Operations Director

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name                    | Service Provided           | Contract Term | Satisfaction
-------------------------------|---------------------------|---------------|-------------
ConnectWise Automate (est.)    | RMM/Monitoring             | Annual        | 4/5
TBD                            | HIPAA Backup/DR            | Annual        | TBD
TBD                            | Cloud Phone System         | Monthly       | TBD
TBD                            | Insurance Integration      | Varies        | TBD
```

### MSP Service Expectations
- **Desired Service Level:** [ ] Co-Managed IT [X] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [X] Email [X] Phone [X] Teams [ ] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [X] Bi-Weekly [ ] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:** Direct phone contact for critical issues affecting 24/7 operations

---

## Additional Notes

### Special Considerations
```
CRITICAL HEALTHCARE CONSIDERATIONS:
- HIPAA compliance is non-negotiable - all systems, backups, and communications must be HIPAA-compliant
- JCAHO accreditation requires documented compliance, auditing, and regular security assessments
- 24/7 operational requirement means IT support must be available around the clock
- Medical device data may require special handling and compliance protocols
- Insurance carrier integrations are complex and require careful testing/validation
- Patient privacy is paramount - all staff must have proper security clearances and training
- Field personnel need reliable mobile access but with proper security controls
- 96.7% satisfaction rating indicates high operational standards - IT must match those expectations
- Fleet of vehicles requires remote connectivity solutions with robust security
- Three service lines (respiratory, rehabilitation, DME) may have different compliance/operational needs
- Equipment monitoring systems may have critical alerts that require immediate IT attention
- Expansion to 300+ insurance provider integrations is significant technical and operational challenge
- State-specific healthcare regulations in Nebraska and Iowa must be considered
```

### Customer Strengths
```
- Strong operational track record (50+ years experience)
- High customer satisfaction (96.7% rating) indicates well-run organization
- JCAHO accreditation shows commitment to compliance and quality
- Established relationships with 300+ insurance carriers
- 24/7 operational model shows commitment to customer service
- Diversified service offerings (respiratory, rehabilitation, DME)
```

### Opportunities for Improvement
```
- Strengthen cloud adoption for non-critical systems
- Implement advanced analytics for fleet optimization
- Enhanced disaster recovery planning beyond secondary location
- Automated compliance reporting to support JCAHO audits
- Improved customer portal for self-service options
- Integration of IoT/monitoring devices for equipment tracking
- Advanced security threat detection and response capabilities
- Training and certification programs for staff on security/compliance
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
**Next Review Date:** TBD (Recommend quarterly for healthcare compliance)
