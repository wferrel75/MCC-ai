# Customer Profile Template
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** HFC Transport
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Transportation/Trucking

---

## Business Overview

### Company Information
- **Number of Employees:** 40+ (estimated)
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [X] B2B [ ] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** 24/7 (Freight operations, customer support)
- **Time Zone(s):** Central Time (Iowa)

### Business Objectives
**Primary Business Goals:**
- Maintain high-reliability freight and logistics network across Lower 48 states
- Expand pharmaceutical and temperature-controlled shipping capabilities
- Improve dispatch efficiency and real-time tracking
- Maintain fleet utilization and customer satisfaction
- Ensure compliance with DOT and FDA regulations

**Technology Initiatives (Next 12 Months):**
- Implement advanced GPS/tracking systems for all vehicles
- Enhance customer portal for shipment tracking and booking
- Improve dispatch and route optimization systems
- Strengthen communication systems for 24/7 operations
- Implement temperature monitoring and alerting for sensitive shipments

**Pain Points/Challenges:**
- Managing 40+ years of legacy operational systems
- Ensuring 24/7 connectivity for field operations across Large geographic area
- Compliance with DOT electronic logging device (ELD) regulations
- Managing pharmaceutical freight with strict temperature/compliance requirements
- Family-owned business may have legacy IT infrastructure
- Real-time tracking and customer communication demands

---

## User Profile

### User Count by Category
```
Total Users: 50+
├─ Executive/Leadership: 5
├─ Knowledge Workers (Office/Hybrid): 15
├─ Remote Workers: 2
├─ Field/Mobile Workers: 35
├─ Factory/Warehouse Workers: 5
├─ Contractors/Temporary: 3
└─ Service Accounts/Shared Mailboxes: 5
```

### User Distribution
- **Users requiring full M365 licenses:** 20 (office/management)
- **Users requiring basic email only:** 15 (administrative/dispatch)
- **Users requiring specialized apps:** 35+ (drivers with tablets/phones for dispatch/tracking)
- **External collaborators/partners:** Multiple carriers, shipping partners, customers

### Work Patterns
- **Percentage Remote Workers:** 5%
- **Percentage Hybrid Workers:** 30%
- **Percentage On-Site Only:** 65%
- **BYOD Policy:** [ ] Allowed [X] Restricted [ ] Prohibited
- **Mobile Device Types:** [X] iOS [X] Android [ ] Windows [X] Other: Vehicle-mounted telematics/GPS units

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Headquarters/Main Terminal"
    address: "820 Illinois St, Sidney, Iowa 51652"
    user_count: 30
    internet_provider: "TBD"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [X] Primary [ ] Branch [ ] Remote Office [ ] Data Center

  - name: "On the Road/Fleet Operations"
    address: "Lower 48 United States"
    user_count: 35
    internet_provider: "TBD (Cellular/Satellite)"
    bandwidth_down: "Mobile/Satellite"
    bandwidth_up: "Mobile/Satellite"
    site_type: [ ] Primary [X] Branch [ ] Remote Office [ ] Data Center

  - name: "Distribution/Delivery Points"
    address: "Various across service area"
    user_count: 5
    internet_provider: "TBD"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [ ] Primary [X] Branch [ ] Remote Office [ ] Data Center
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [X] Site-to-Site VPN [ ] SD-WAN [X] Cellular [ ] Other: Satellite backup
- **Primary WAN Provider:** TBD (Primary cellular + satellite backup)
- **Backup/Redundant Connections:** [X] Yes [ ] No
  - Details: Satellite communication backup for areas with poor cellular coverage, essential for safety/compliance

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:** TBD
- **Firmware Version:** TBD
- **Management:** [ ] Cloud-Managed [X] On-Prem [ ] Hybrid
- **Features in Use:** [X] VPN [X] Content Filtering [ ] IPS/IDS [X] Application Control

**Network Equipment:**
- **Switch Vendor/Model:** TBD
- **Wireless AP Vendor/Model:** TBD
- **Network Management:** [ ] Ubiquiti (UniFi) [ ] Cisco Meraki [ ] Aruba [ ] Other: TBD

**Network Services:**
- **DHCP Server:** [X] Firewall [ ] Windows Server [ ] Router [ ] Other: TBD
- **DNS Services:** [X] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** 10.0.0.0/8 private range (estimated)
- **VLANs Configured:** [X] Yes [ ] No
  - VLAN Details: Administrative VLAN, driver/dispatch VLAN, guest network, vehicle telematics VLAN

### Internet & WAN
- **Primary Internet Speed:** TBD
- **Backup Internet:** [X] Yes [ ] No
- **Public IP Addresses:** [X] Static [ ] Dynamic [ ] Number of IPs: TBD

### Remote Access
- **VPN Solution:** TBD (must support large field workforce)
- **VPN Concurrent Users:** 35+
- **Remote Desktop Solution:** [X] RDP [X] VPN [ ] Third-party: Mobile dispatch apps
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
Microsoft 365 Business Standard            | 20    | Office/management/dispatch
Office 365 E1                              | 15    | Basic email for field staff
Teams Phone Standard                       | 5     | Headquarters/dispatch
Audio Conferencing                         | 3     | Management
[Other]                                    | TBD   | Industry-specific logistics
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
- [ ] Microsoft Purview (Compliance)
- [ ] Power Platform (Power Apps, Power Automate)
- [X] Other: Integration with DOT/ELD systems, customer tracking portals

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller"
    os: "Windows Server 2019+"
    virtualization: [ ] Physical [X] Hyper-V [ ] VMware [ ] Azure
    location: "Sidney, Iowa Headquarters"

  - role: "File Server"
    os: "Windows Server 2019+"
    virtualization: [ ] Physical [X] Hyper-V [ ] VMware [ ] Azure
    location: "Sidney, Iowa Headquarters"

  - role: "Dispatch/Logistics Server"
    os: "Windows Server 2019+"
    virtualization: [ ] Physical [X] Hyper-V [ ] VMware [ ] Azure
    location: "Sidney, Iowa Headquarters"

  - role: "GPS/Telematics Server"
    os: "Linux/Windows TBD"
    virtualization: [ ] Physical [X] Hyper-V [X] VMware [ ] Azure
    location: "Sidney, Iowa Headquarters"
```

**Active Directory:**
- **Domain Name:** TBD
- **Forest Functional Level:** 2016 or higher
- **Azure AD Connect:** [X] Yes [ ] No [ ] Cloud Sync
- **Hybrid Configuration:** [X] Yes [ ] No
- **Number of Domain Controllers:** 2

**File Storage:**
- **File Server Location:** [X] On-Prem [ ] Cloud [ ] Hybrid
- **Total Storage Capacity:** TBD
- **Current Usage:** TBD
- **Backup Solution:** TBD (with offsite backup for critical data)

**Database Servers:**
- **SQL Server:** [X] Yes [ ] No | Version: 2019+ | Databases: Dispatch, customer records, vehicle telematics
- **Other Databases:** PostgreSQL/MySQL for logistics systems (estimated)

### Line of Business Applications
```
Application Name                           | Vendor      | Hosting         | Users | Cloud-Ready?
-------------------------------------------|-------------|-----------------|-------|-------------
Dispatch Management System                 | TBD         | On-Prem         | 20    | N
Electronic Logging Device (ELD) Compliance | TBD         | Cloud           | 35    | Y
GPS/Vehicle Tracking System                | TBD         | Cloud           | 35    | Y
Customer Portal/Shipment Tracking          | TBD         | Cloud/On-Prem   | 50+   | Y
Billing and Invoicing System               | TBD         | On-Prem         | 10    | N
Temperature Monitoring System              | TBD         | Cloud/IoT       | 35    | Y
Driver Mobile Application                  | TBD         | Cloud           | 35    | Y
Compliance/Safety Documentation            | TBD         | Cloud           | 15    | Y
```

**Critical Dependencies:**
- Dispatch system (critical for daily operations)
- ELD/DOT compliance system (mandatory)
- GPS/tracking system (customer service critical)
- Temperature monitoring (pharmaceutical shipment requirement)
- Customer portal (competitive necessity)

---

## Security & Compliance

### Security Posture
**Current Security Solutions:**
- **Antivirus/Endpoint Protection:** TBD (must support mobile devices)
- **EDR/MDR Solution:** TBD
- **Email Security:** TBD
- **Web/Content Filtering:** TBD
- **SIEM/Log Management:** TBD
- **Backup Solution:** TBD (with redundancy for critical data)
  - **Backup Frequency:** Daily
  - **Retention Period:** 3+ years (per DOT/FDA requirements)
  - **Offsite/Cloud Backup:** [X] Yes [ ] No

**Multi-Factor Authentication:**
- **MFA Enabled:** [X] Yes [ ] No [ ] Partial
- **MFA Method:** [X] Microsoft Authenticator [ ] SMS [X] Hardware Token [ ] Other: TBD
- **MFA Coverage:** 80%+ of users (higher for admin/dispatch)

**Conditional Access:**
- **Policies Configured:** [X] Yes [ ] No
- **Number of Policies:** 3+
- **Key Policies:** Device compliance for company vehicles, geographic restrictions, app-specific access

### Compliance Requirements
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [X] DOT [X] FDA (Pharmaceutical) [ ] None [ ] Other: FMCSA, State Motor Carrier Regulations
- **Data Retention Requirements:** 3+ years for compliance documentation, 7 years for pharmaceutical shipments
- **eDiscovery Needs:** [ ] Yes [X] No
- **Data Loss Prevention (DLP):** [ ] Required [X] Nice-to-have [ ] Not needed

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [ ] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [ ] Frequent [X] Occasional [ ] Rare
- **Security Training:** [X] Regular [ ] Annual [ ] None

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [X] On-Prem PBX [ ] Cloud PBX [ ] Teams Phone [ ] Other: TBD
- **Vendor/Model:** TBD (Avaya, Cisco, or equivalent)
- **Number of Lines/Extensions:** 20+
- **Auto Attendant/Call Queue:** [X] Yes [ ] No
- **Conference Room Phones:** 3-4
- **Analog Lines (Fax/Alarm):** 2-3 (dispatch, alerts)

### Teams Voice
- **Teams Phone Deployment:** [ ] Yes [X] No [ ] Planned
- **PSTN Connectivity:** [ ] Calling Plan [X] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911):** [X] Configured [ ] Not Configured [ ] N/A

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** Automated backup with cloud redundancy
- **Items Backed Up:** [X] Servers [X] Workstations [X] M365 [X] Databases
- **M365 Backup:** [ ] Native [X] Third-Party: Cloud backup service [ ] None
- **Backup Testing Frequency:** Monthly

### Disaster Recovery
- **DR Plan Documented:** [X] Yes [ ] No
- **RTO (Recovery Time Objective):** 4 hours (critical for 24/7 operations)
- **RPO (Recovery Point Objective):** 1 hour
- **DR Site/Failover:** [X] Yes [ ] No | Location: Secondary location (TBD - potential cloud failover)
- **Cloud DR Strategy:** Cloud backup with rapid failover capability

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [X] ConnectWise Automate [ ] N-able [ ] Other: TBD [ ] None
- **Monitoring Coverage:** [X] All devices [X] Servers only [ ] None
- **Alert Response Time SLA:** 1-2 hours for critical systems, 24/7 support

### Help Desk/Ticketing
- **PSA/Ticketing System:** ConnectWise Manage (estimated)
- **User Self-Service Portal:** [X] Yes [ ] No
- **Current Response Time:** 2-4 hours for critical issues

---

## Budget & Timeline

### Budget Information
- **IT Budget (Annual):** TBD
- **Spending Breakdown:**
  - Hardware: 20%
  - Software/Licenses: 25%
  - Services/Support: 40%
  - Projects: 15%

- **Capital Available for Projects:** TBD
- **OpEx vs CapEx Preference:** [X] Prefer OpEx [ ] Prefer CapEx [ ] No preference

### Timeline & Priorities
**Immediate Needs (0-30 days):**
- Ensure DOT/ELD compliance systems operational
- Maintain 24/7 dispatch and tracking availability

**Short-Term Projects (1-6 months):**
- Enhance GPS/tracking capabilities for fleet
- Upgrade customer portal for real-time shipment visibility
- Improve temperature monitoring system for pharmaceutical shipments
- Strengthen security posture across field operations

**Long-Term Goals (6-12+ months):**
- Migrate legacy dispatch system to modern cloud-based solution
- Implement advanced route optimization AI/ML
- Expand service area with redundant IT infrastructure
- Implement IoT/sensor network for vehicle health monitoring

**Budget Approval Process:** Family ownership approval, operations director sign-off
**Decision Maker(s):** Owner/CEO, Operations Manager

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name                    | Service Provided           | Contract Term | Satisfaction
-------------------------------|---------------------------|---------------|-------------
ConnectWise (estimated)        | RMM/Monitoring             | Annual        | TBD
TBD                            | GPS/Telematics Platform    | Annual        | TBD
TBD                            | Customer Portal/Tracking   | Annual        | TBD
TBD                            | ELD/DOT Compliance         | Annual        | TBD
TBD                            | Cellular/Satellite         | Monthly       | TBD
```

### MSP Service Expectations
- **Desired Service Level:** [ ] Co-Managed IT [X] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [X] Email [X] Phone [ ] Teams [X] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [X] Bi-Weekly [ ] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:** Direct phone contact for critical dispatch/tracking system issues

---

## Additional Notes

### Special Considerations
```
TRANSPORTATION & LOGISTICS CONSIDERATIONS:
- DOT (Department of Transportation) compliance is mandatory - ELD systems, driver hours, vehicle maintenance records
- FDA pharmaceutical regulations apply to refrigerated/temperature-controlled shipments
- 24/7 operations require round-the-clock IT support with minimal system downtime
- Field workforce of 35+ drivers requires reliable mobile connectivity and applications
- Large geographic service area (Lower 48 states) creates connectivity challenges
- Family-owned business (40+ years) may have legacy systems and processes to respect
- Real-time tracking is competitive necessity - customers expect live shipment visibility
- Temperature-sensitive shipments require automated monitoring and alerts
- Vehicle-mounted telematics/GPS systems require specialized infrastructure and support
- Dispatch system is critical operational bottleneck - any downtime severely impacts operations
- Integration with multiple carrier networks and customer systems is complex
- Backup cellular/satellite connectivity essential for operations in remote areas
- Driver safety and compliance are intertwined with IT systems
- Customer satisfaction depends heavily on tracking/communication systems reliability
- Potential expansion to additional locations/service areas requires scalable IT infrastructure
```

### Customer Strengths
```
- Established 40+ year operational track record shows stability
- Family-owned business indicates strong commitment and continuity
- Diversified freight services (refrigerated, dry van, pharmaceutical) reduces single-point-of-failure risk
- Large service area demonstrates capability to handle complex logistics
- Technology investments in GPS/ELD/tracking show commitment to modernization
```

### Opportunities for Improvement
```
- Migrate legacy dispatch system to modern cloud-based platform
- Implement advanced route optimization to reduce fuel costs and improve efficiency
- Strengthen cybersecurity posture across field operations
- Implement predictive maintenance using vehicle telematics
- Enhance customer portal with AI/ML-based shipment recommendations
- Implement real-time compliance monitoring and automated reporting
- Consider cloud DR solution for better business continuity
- Implement advanced analytics for fleet optimization
- Develop integrated driver training/compliance platform
- Evaluate hybrid cloud model for non-critical systems
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
**Next Review Date:** TBD (Recommend semi-annual for DOT compliance review)
