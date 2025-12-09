# Crowell Memorial Home - Customer Profile
## Midwest Cloud Computing - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Crowell Memorial Home
**Website:** http://www.crowellhome.com/
**Main Phone:** (402) 426-2177
**Profile Created Date:**
**Last Updated:** 2025-12-05 (Added CEO and Primary Technical Contact information)
**Account Manager:**
**Primary Technical Contact:** Kylea Punke - Business Office Manager (kpunke@crowellhome.com)
**CEO:** Jaclyn Svendgard (jmsvendgard4@gmail.com)
**Industry/Vertical:** Healthcare - Continuing Care Retirement Community (CCRC) / Skilled Nursing Facility

---

## Business Overview

### Company Information
- **Number of Employees:** TBD (estimated 50-100 based on facility size)
- **Number of IT Staff:** TBD (likely 0-1, may outsource)
- **Annual Revenue Range:** TBD
- **Business Type:** [ ] B2B [X] B2C [ ] B2B2C [X] Non-Profit [ ] Government
- **Critical Business Hours:** 24/7/365 (residential healthcare facility)
- **Time Zone(s):** Central Time (CT)
- **Corporate Headquarters:** Blair, Nebraska
- **Years in Business:** Founded 1905 (119+ years)

### Company Information - Detailed
**Facility Details:**
- Primary Address: 245 South 22nd Street, Blair, NE 68008
- Phone: (402) 426-2177
- Founded: 1905 (nonprofit organization)
- Legal Status: Nonprofit continuing care retirement community

**Facility Capacity:**
- 88 Skilled Nursing Beds
- 80 Private Rooms
- 18 Assisted Living Apartments
- 8 Independent Living Apartments
- Memory Care Unit (Alzheimer's and dementia care)

**Services Offered:**
- Skilled nursing care
- Assisted living
- Independent living
- Memory care / Alzheimer's care
- Dementia care
- Respite care
- Long-term care
- Rehabilitation services (likely)

**Certifications:**
- Medicare certified
- Medicaid certified
- CCRC (Continuing Care Retirement Community)

**Pricing:**
- Range: $2,190 - $5,969 per month (varies by service level and accommodation)

### Business Objectives
**Primary Business Goals:**
- Provide quality long-term care for elderly residents
- Maintain Medicare/Medicaid certification and compliance
- Deliver compassionate memory care and Alzheimer's services
- Ensure 24/7 resident safety and care
- Support aging in place through continuum of care (independent → assisted → skilled nursing)
- Maintain facility occupancy and financial sustainability

**Technology Initiatives (Next 12 Months):**
- 
-
-

**Pain Points/Challenges:**
- 24/7 operations require reliable systems
- Electronic Health Records (EHR) management and compliance
- Medication administration tracking and error prevention
- Staff scheduling and shift management (24/7 coverage)
- Family communication and resident monitoring
- Medicare/Medicaid billing and documentation
- State survey readiness and regulatory compliance
- Resident data privacy (HIPAA)
- Emergency call systems and resident safety monitoring
- Coordination between nursing, dietary, activities, and housekeeping

---

## User Profile

### User Count by Category
```
Total Users: TBD (estimated 50-100 staff)
├─ Executive/Leadership: ___ (Administrator, Director of Nursing, etc.)
├─ Knowledge Workers (Office/Hybrid): ___ (billing, admissions, social services)
├─ Remote Workers: ___ (possibly billing or administrative)
├─ Field/Mobile Workers: N/A
├─ Factory/Warehouse Workers: N/A
├─ Healthcare Staff: ___ (RNs, LPNs, CNAs, activities, dietary)
├─ Contractors/Temporary: ___ (contract nurses, per diem staff)
└─ Service Accounts/Shared Mailboxes: ___ (nursing stations, admissions, billing)
```

### User Distribution
- **Users requiring full M365 licenses:** TBD (administrative staff, management)
- **Users requiring basic email only:** TBD (direct care staff may only need basic communication)
- **Users requiring specialized apps:** TBD (EHR access, medication management, dietary, activities)
- **External collaborators/partners:** TBD (physicians, hospice partners, therapy providers, medical suppliers)

### Work Patterns
- **Percentage Remote Workers:** Low (majority on-site for direct care)
- **Percentage Hybrid Workers:** TBD (possibly administrative/billing staff)
- **Percentage On-Site Only:** High (nursing staff, CNAs, activities, dietary, housekeeping)
- **BYOD Policy:** [ ] Allowed [ ] Restricted [X] Prohibited (HIPAA concerns)
- **Mobile Device Types:** [ ] iOS [ ] Android [ ] Windows [ ] Other: ___
- **Shift Structure:** 24/7 operations (typically 7am-3pm, 3pm-11pm, 11pm-7am shifts)

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Crowell Memorial Home - Main Facility"
    address: "245 South 22nd Street, Blair, NE 68008"
    phone: "(402) 426-2177"
    user_count: TBD (estimated 50-100 staff)
    resident_count: TBD (up to 194 capacity: 88 skilled + 18 assisted + 8 independent + memory care)
    internet_provider: "Great Plains"
    bandwidth_down: "TBD"
    bandwidth_up: "TBD"
    site_type: [X] Primary [ ] Branch [ ] Remote Office [ ] Data Center
    building_layout:
      - "First Level: Resident rooms (101-161), main dining, kitchen, offices, lounges"
      - "Second Level: Resident rooms (200-260), chapel, assisted living, IT room (current location)"
      - "Lower Level: Activities, therapy, laundry, mechanical, storage"
    it_infrastructure_location: "Second Level - current IT/server room location"
    notes: "Single-site long-term care facility, 24/7 operations, founded 1905"
    documentation: "Floor plans available: Crowell/Crowell_Building_Floor_Plan.pdf"
```

### Inter-Site Connectivity
- **Sites Connected via:** [ ] MPLS [ ] Site-to-Site VPN [ ] SD-WAN [X] None [ ] Other: ___
- **Primary WAN Provider:** N/A (single site)
- **Backup/Redundant Connections:** TBD (critical for 24/7 healthcare operations)
  - Details: Backup internet highly recommended for EHR access, emergency systems

---

## Network Infrastructure

### On-Premises Network
**Firewall/Security:**
- **Vendor/Model:** Fortinet FortiGate 80F
- **Firmware Version:** TBD
- **Management:** [ ] Cloud-Managed [X] On-Prem [ ] Hybrid
- **Features in Use:** [ ] VPN [ ] Content Filtering [ ] IPS/IDS [ ] Application Control (TBD - needs assessment)
- **Location:** Second level IT room (wall-mounted rack)
- **HIPAA Considerations:** FortiGate supports HIPAA security requirements; configuration audit recommended

**Network Equipment:**
- **Switch Vendor/Model:**
  - FortiSwitch 124E (24-port managed switch with uplinks)
  - HP 1910-24-POE (24-port PoE switch, IP: 172.163.0.249)
  - Ubiquiti USW Pro 24 port (managed by Great Plains - coordination required)
- **Patch Panels:**
  - Diode Technologies patch panel (labeled with AP 1-8 ports, WAN ports)
  - Additional patch panel (managed by Great Plains with Ubiquiti switch)
  - Great Plains Communications branded equipment
  - ICC branded equipment
- **Rack Configuration:**
  - Current: 2 wall-mounted racks/shelves on second level IT room
  - Opportunity to consolidate to 1 rack during relocation
  - Current setup uses wall-mounted shelving with equipment stacked
- **IP Addressing Observed:** 172.163.0.x subnet
- **Wireless AP Vendor/Model:** TBD (likely connected to patch panel AP ports)
- **Network Management:** [X] Ubiquiti (UniFi) - Partial [ ] Cisco Meraki [ ] Aruba [X] Other: Fortinet
- **Network Coverage:** Entire facility (nursing units, common areas, offices, memory care unit)
- **Cable Management:** Extensive blue Cat5e/Cat6 cabling, minimal cable management currently
- **Equipment Photos:** Available in Crowell/ directory (signal-2025-12-03-102320*.jpeg)

**Network Services:**
- **DHCP Server:** [ ] Firewall [ ] Windows Server [ ] Router [ ] Other: ___
- **DNS Services:** [ ] Internal DNS Server [ ] Cloud DNS [ ] ISP DNS
- **IP Addressing Scheme:** 172.163.0.0/24 (observed subnet)
  - HP Switch: 172.163.0.249
  - Additional devices in 172.163.0.x range
- **VLANs Configured:** [ ] Yes [ ] No (needs assessment)
  - VLAN Recommendations: Separate VLANs for clinical (EHR), administrative, guest WiFi, IoT/monitoring devices, security cameras
  - Current Configuration: TBD (audit needed during infrastructure assessment)

**Critical Network Devices:**
- Nurse call systems
- Emergency call buttons
- Overhead paging system (Extension 820)
- Security cameras (common areas, entrances, parking)
- Door access control systems
- Medication carts (if wireless/networked)
- Vital signs monitoring equipment
- Fire alarm and safety systems

### Internet & WAN
- **Primary ISP:** Great Plains
- **Primary Internet Speed:** TBD (recommend minimum 100 Mbps for EHR and operations)
- **Backup Internet:** [ ] Yes [ ] No (highly recommended for 24/7 healthcare)
- **Public IP Addresses:** [ ] Static [ ] Dynamic [ ] Number of IPs: ___
- **Reliability Requirements:** 99.9%+ uptime (healthcare facility requires constant connectivity)

### Remote Access
- **VPN Solution:** TBD (for administrative staff, billing, remote support)
- **VPN Concurrent Users:** TBD
- **Remote Desktop Solution:** [ ] RDP [ ] VPN [ ] Third-party: ___
- **Cloud Access Method:** [ ] Direct Internet [ ] VPN [ ] Conditional Access Only
- **HIPAA-Compliant Access:** Required for all systems accessing PHI

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** TBD (likely crowellhome.com or related)
- **Additional Domains:** TBD
- **Tenant Type:** [X] Commercial [ ] GCC [ ] GCC High [ ] DoD

**Current Licenses (by SKU and count):**
```
SKU Name                                    | Count | Notes
-------------------------------------------|-------|-------
Microsoft 365 Business Basic               |       | Administrative staff
Microsoft 365 Business Standard            |       | Office workers
Microsoft 365 Business Premium             |       | Management
Office 365 E1                              |       | Staff with email only needs
Teams Phone Standard                       |       | Main number, departments
[Other]                                    |       |
```

**M365 Services in Use:**
- [ ] Exchange Online (Email)
- [ ] SharePoint Online (policies, procedures, training materials)
- [ ] OneDrive for Business
- [ ] Teams (Chat/Meetings) - staff communication
- [ ] Teams Phone System
- [ ] Intune (MDM/MAM) - mobile device management for HIPAA compliance
- [ ] Azure AD Premium (which tier: ___)
- [ ] Defender for Office 365 (P1/P2) - recommended for healthcare
- [ ] Microsoft Defender for Endpoint
- [ ] Microsoft Purview (Compliance) - HIPAA compliance features
- [ ] Power Platform (Power Apps, Power Automate) - workflows
- [ ] Other: ___

### On-Premises Infrastructure

**Servers:**
```yaml
servers:
  - role: "Domain Controller (CRITICAL - END OF LIFE)"
    os: "Windows Server 2008 R2"
    form_factor: "Tower"
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "On-site server room (scheduled for relocation)"
    status: "END OF SUPPORT - Azure AD migration required"
    migration_priority: "HIGH - Security risk due to unsupported OS"

  - role: "TBD - File Server or EHR Server"
    os: "TBD"
    form_factor: "Tower"
    virtualization: [ ] Physical [ ] Hyper-V [ ] VMware [ ] Azure
    location: "On-site server room (scheduled for relocation)"

  - note: "Multiple tower servers present - exact count and roles TBD during infrastructure assessment"
  - note: "Server 2008 R2 is out of mainstream and extended support (EOL: January 14, 2020)"
```

**Active Directory:**
- **Domain Name:** TBD
- **Server OS:** Windows Server 2008 R2 (END OF LIFE - migration required)
- **Forest Functional Level:** TBD (likely Server 2008 R2)
- **Azure AD Connect:** [ ] Yes [X] No [ ] Cloud Sync
- **Hybrid Configuration:** [ ] Yes [X] No
- **Number of Domain Controllers:** TBD (recommend at least 1 for single-site)
- **Migration Status:** On-premises only, Azure AD migration planned

**File Storage:**
- **File Server Location:** [ ] On-Prem [ ] Cloud [ ] Hybrid
- **Total Storage Capacity:** TBD
- **Current Usage:** TBD
- **Backup Solution:** TBD (critical for HIPAA - resident records, clinical data)
- **HIPAA Compliance:** Encryption at rest and in transit required

**Database Servers:**
- **SQL Server:** [ ] Yes [ ] No | Version: ___ | Databases: ___ (possibly for EHR backend)
- **Other Databases:** TBD

### Line of Business Applications
```
Application Name                        | Vendor      | Hosting         | Users | Cloud-Ready?
----------------------------------------|-------------|-----------------|-------|-------------
Electronic Health Records (EHR)         | TBD         | [On-Prem/Cloud] | All   | [Y/N]
e-Prescribing System                    | TBD         | [Cloud]         | RNs   | [Y]
Medication Administration (eMAR)        | TBD         | [On-Prem/Cloud] | Nurses| [Y/N]
Point of Care Documentation             | TBD         | [On-Prem/Cloud] | CNAs  | [Y/N]
Billing/Accounts Receivable             | TBD         | [On-Prem/Cloud] | Billing| [Y/N]
Medicare/Medicaid Claims                | TBD         | [Cloud]         | Billing| [Y]
Payroll/HR System                       | TBD         | [Cloud]         | Admin | [Y]
Scheduling/Staff Management             | TBD         | [On-Prem/Cloud] | Mgmt  | [Y/N]
Dietary/Nutrition Management            | TBD         | [On-Prem/Cloud] | Dietary| [Y/N]
Activities Tracking                     | TBD         | [On-Prem/Cloud] | Activities| [Y/N]
Resident/Family Portal                  | TBD         | [Cloud]         | Families| [Y]
Pharmacy Management                     | TBD         | [Cloud]         | Nurses| [Y]
Quality Assurance/QAPI                  | TBD         | [Cloud]         | QA    | [Y]
Nurse Call System                       | TBD         | [On-Prem]       | All   | [N]
```

**Typical Long-Term Care Software:**
- Electronic Health Records (EHR) systems (PointClickCare, MatrixCare, American HealthTech)
- Electronic Medication Administration Record (eMAR)
- Minimum Data Set (MDS) assessment software
- Care planning software
- Medicare/Medicaid billing systems
- Payroll and time tracking
- Dietary management
- Activities calendar and tracking
- Infection control tracking
- Incident reporting systems
- Family communication portals

**Critical Dependencies:**
- EHR system availability (24/7 requirement for resident care)
- Medication administration system (critical for safety)
- Nurse call system (emergency response)
- Pharmacy system integration
- Medicare/Medicaid billing system (reimbursement)

---

## Security & Compliance

### Security Posture
**Current Security Solutions:**
- **Antivirus/Endpoint Protection:** TBD (required for HIPAA)
- **EDR/MDR Solution:** TBD (recommended for healthcare)
- **Email Security:** TBD (phishing protection critical in healthcare)
- **Web/Content Filtering:** TBD
- **SIEM/Log Management:** TBD (HIPAA audit trail requirements)
- **Backup Solution:** TBD (HIPAA requires backup and disaster recovery)
  - **Backup Frequency:** TBD (recommend daily for clinical data)
  - **Retention Period:** TBD (recommend 7+ years for medical records)
  - **Offsite/Cloud Backup:** [ ] Yes [ ] No (required for HIPAA)

**Multi-Factor Authentication:**
- **MFA Enabled:** [ ] Yes [ ] No [ ] Partial (required for HIPAA compliance)
- **MFA Method:** [ ] Microsoft Authenticator [ ] SMS [ ] Hardware Token [ ] Other: ___
- **MFA Coverage:** ___% of users (target: 100% for systems with PHI access)

**Conditional Access:**
- **Policies Configured:** [ ] Yes [ ] No
- **Number of Policies:** TBD
- **Key Policies:** TBD (require MFA for all users, block legacy authentication, require compliant devices)

### Compliance Requirements
- **Industry Regulations:** [X] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [ ] CMMC [ ] None [X] Other: State Healthcare Licensing
  - **Specific Requirements:**
    - HIPAA Privacy Rule (Protected Health Information - PHI)
    - HIPAA Security Rule (administrative, physical, technical safeguards)
    - HIPAA Breach Notification Rule
    - Medicare Conditions of Participation (CoP)
    - Medicaid certification requirements
    - State long-term care licensing regulations
    - CMS (Centers for Medicare & Medicaid Services) requirements
    - State Department of Health and Human Services surveys
    - Minimum Data Set (MDS) 3.0 requirements
    - Quality Assurance and Performance Improvement (QAPI)
    - Resident Rights (42 CFR Part 483)
    - Life Safety Code compliance
    - Omnibus Rule (HITECH Act)
- **Data Retention Requirements:** Minimum 7 years for medical records (may vary by state)
- **eDiscovery Needs:** [ ] Yes [ ] No (potential for legal holds in litigation)
- **Data Loss Prevention (DLP):** [X] Required [ ] Nice-to-have [ ] Not needed (PHI protection)
- **Business Associate Agreements (BAA):** Required for all vendors handling PHI
- **HIPAA Risk Assessment:** Required annually

### Security Incidents
**Recent Security Events:**
- **Ransomware/Malware:** [ ] Yes [ ] No | Date: ___ | Resolution: ___
- **Phishing Incidents:** [ ] Frequent [ ] Occasional [ ] Rare
- **Security Training:** [ ] Regular [ ] Annual [ ] None
- **HIPAA Training:** Required annually for all staff with PHI access
- **Breach Notification:** Any PHI breach must be reported to HHS within 60 days

**HIPAA Security Requirements:**
- Access controls and unique user identification
- Automatic logoff
- Encryption and decryption
- Audit controls and logging
- Transmission security
- Physical safeguards for equipment and facilities
- Workstation security
- Device and media controls
- Contingency planning and disaster recovery

---

## Telephony & Communication

### Current Phone System
- **Phone System Type:** [ ] On-Prem PBX [ ] Cloud PBX [ ] Teams Phone [X] Other: Great Plains Hosted
- **Vendor/Model:** Great Plains (provider) / Yealink Phones (hardware)
- **Number of Lines/Extensions:** TBD (main line, nursing stations, administration, memory care unit)
- **Auto Attendant/Call Queue:** [X] Yes [ ] No (likely for main number)
- **Conference Room Phones:** TBD
- **Analog Lines (Fax/Alarm):** TBD (possibly for fax, fire alarm, elevator phone)
- **24/7 Requirements:** Main line must be answered 24/7 (admissions, family calls, emergencies)
- **Overhead Paging System:** Extension 820 (facility-wide PA system)

**Key Phone Numbers/Extensions:**
- Main Reception: (402) 426-2177
- Extension 820: Overhead Paging System (facility-wide PA)
- Nursing stations (multiple units)
- Admissions office
- Administrator
- Director of Nursing
- Social Services
- Dietary/Kitchen
- Maintenance/Engineering
- Activities

### Teams Voice
- **Teams Phone Deployment:** [ ] Yes [ ] No [ ] Planned
- **PSTN Connectivity:** [ ] Calling Plan [ ] Direct Routing [ ] Operator Connect [ ] N/A
- **Emergency Calling (E911):** [ ] Configured [ ] Not Configured [ ] N/A (critical for healthcare facility)
- **After-Hours Call Handling:** TBD (on-call nurse, answering service)

---

## Backup & Disaster Recovery

### Backup Strategy
- **Backup Solution:** TBD (HIPAA compliance required)
- **Items Backed Up:** [ ] Servers [ ] Workstations [ ] M365 [ ] Databases
- **M365 Backup:** [ ] Native [ ] Third-Party: ___ [ ] None (recommended for healthcare)
- **Backup Testing Frequency:** TBD (recommend quarterly restore testing)
- **Backup Retention:** Minimum 7 years for medical records
- **Backup Encryption:** Required for HIPAA compliance

### Disaster Recovery
- **DR Plan Documented:** [ ] Yes [ ] No (required for HIPAA)
- **RTO (Recovery Time Objective):** TBD (recommend <4 hours for critical EHR systems)
- **RPO (Recovery Point Objective):** TBD (recommend <1 hour for clinical data)
- **DR Site/Failover:** [ ] Yes [ ] No | Location: ___
- **Cloud DR Strategy:** TBD (recommended for healthcare continuity)
- **Emergency Mode Operation:** Paper charting procedures for internet/system outages
- **HIPAA Contingency Plan:** Required (data backup, disaster recovery, emergency mode operations)

**Critical Systems for DR Priority:**
1. EHR/Clinical documentation (highest priority)
2. Medication administration system
3. Nurse call system
4. Phone system
5. Billing system
6. Email/communication

---

## Monitoring & Management

### Current RMM/Monitoring
- **RMM Platform:** [ ] Datto [ ] ConnectWise Automate [ ] N-able [ ] Other: ___ [ ] None
- **Monitoring Coverage:** [ ] All devices [ ] Servers only [ ] None
- **Alert Response Time SLA:** TBD (24/7 monitoring recommended for healthcare)
- **After-Hours Support:** TBD (critical for 24/7 healthcare operations)

### Help Desk/Ticketing
- **PSA/Ticketing System:** TBD
- **User Self-Service Portal:** [ ] Yes [ ] No
- **Current Response Time:** TBD
- **24/7 Support Availability:** TBD (nursing staff may need support during all shifts)
- **Priority Response for Clinical Systems:** Required (EHR, eMAR, nurse call)

---

## Budget & Timeline

### Budget Information
- **IT Budget (Annual):** TBD
- **Spending Breakdown:**
  - Hardware: ___%
  - Software/Licenses: ___%
  - Services/Support: ___%
  - Projects: ___%
  - Compliance/Security: ___%

- **Capital Available for Projects:** TBD
- **OpEx vs CapEx Preference:** [X] Prefer OpEx [ ] Prefer CapEx [ ] No preference (nonprofit typically prefers OpEx)
- **Medicare/Medicaid Reimbursement:** IT costs may be partially reimbursable

### Timeline & Priorities
**Immediate Needs (0-30 days):**
- Infrastructure room relocation - review and quote requested
  - **Current Location:** Second level IT room (see floor plan page 2)
  - **Destination:** Opposite side of same wall (adjacent room)
  - **Rack Configuration:** 2 wall-mounted shelves/racks (opportunity to consolidate to 1 proper rack)
  - **Network Equipment to Relocate:**
    - Fortinet FortiGate 80F firewall
    - Fortinet FortiSwitch 124E (24-port managed switch)
    - HP 1910-24-POE switch (IP: 172.163.0.249)
    - Ubiquiti USW Pro 24 port (Great Plains managed - coordination required)
  - **Patch Panels to Relocate:**
    - Diode Technologies patch panel (AP 1-8, WAN ports)
    - Great Plains patch panel (with Ubiquiti switch - coordination required)
    - ICC branded equipment
  - **Additional Equipment:**
    - Tower servers (quantity and models TBD)
    - Work desk and monitor currently in IT room
  - **Cabling Assessment Needed:**
    - Extensive blue Cat5e/Cat6 cabling throughout facility
    - Cable length requirements for new location
    - Opportunity for improved cable management
    - Verification of AP and endpoint connectivity after move
  - **Coordination Required:**
    - Great Plains Communications (Ubiquiti switch, patch panel, phone system)
    - Diode Technologies (if applicable for patch panel)
  - **Documentation:** Current state photos available in Crowell/ directory

- **User Workstation Tasks:**
  - Remove Dropbox from Nancy's computer (logs in as Kara)
  - **PC Replacements:**
    - Prudy - PC replacement needed
    - Nancy - PC replacement | Computer name: Shaurice, Username: Kara
    - Sydney - PC replacement | Computer name: PC02, Username: Curtis
  - **Network Connectivity Issues:**
    - 2nd floor nursing station computers (including computer named Erica) - no internet connectivity overnight, connectivity restored by 8:00 AM
    - **ACTION REQUIRED:** Follow up to confirm nursing station PCs are working properly and investigate cause of overnight outage

**Short-Term Projects (1-6 months):**
- **Active Directory Migration to Azure AD (CRITICAL - End of Life System):**
  - Current Environment: Windows Server 2008 R2 Active Directory (END OF SUPPORT)
  - Migration Path: On-premises AD to Azure AD (Entra ID)
  - **Pre-Migration Assessment:**
    - Document current AD structure, OUs, GPOs, and user/computer objects
    - Identify all applications and services dependent on on-prem AD
    - Assess compatibility of current workstations and applications with Azure AD
    - Review current authentication methods and security policies
  - **Migration Planning:**
    - Design Azure AD tenant structure and naming conventions
    - Plan for Microsoft 365 license requirements (Azure AD Premium P1/P2)
    - Determine hybrid vs. cloud-only approach based on remaining on-prem dependencies
    - Plan for Intune device management integration
    - Design conditional access policies for HIPAA compliance
  - **Implementation Steps:**
    - Establish Azure AD tenant and configure security baseline
    - Set up Azure AD Connect (if hybrid approach) or direct migration
    - Migrate user accounts and groups
    - Configure MFA for all users (HIPAA requirement)
    - Migrate workstations to Azure AD join
    - Implement Intune for device management
    - Decommission Server 2008 R2 domain controller(s)
  - **Post-Migration:**
    - Validate user access and authentication
    - Update documentation and IT procedures
    - Train staff on new authentication experience
    - Monitor for any access or compatibility issues

- **Policy Files Migration to SharePoint:**
  - Consolidate Jaclyn's Policy files to SharePoint
  - Assess current file structure and organization
  - Identify who needs access to policy documentation
  - Configure appropriate SharePoint permissions and access controls
  - Ensure HIPAA compliance for any PHI-related policies
  - Train staff on accessing policies from SharePoint
  - Establish version control and approval workflow for policy updates

**Long-Term Goals (6-12+ months):**
- TBD
-

**Budget Approval Process:** TBD (likely board approval for significant expenditures)
**Decision Maker(s):** TBD (Administrator, Board of Directors)

---

## Vendor Relationships

### Current IT Vendors
```
Vendor Name           | Service Provided           | Contract Term | Satisfaction | BAA Signed?
---------------------|---------------------------|---------------|--------------|-------------
Great Plains         | Internet Service Provider  |               | [1-5]        | [ ]
Communications       | Phone System (Yealink)     |               | [1-5]        | [ ]
                     | Network Management         |               | [1-5]        | [ ]
                     | (Ubiquiti switch & patch)  |               |              |
Diode Technologies   | Structured Cabling/Patch   |               | [1-5]        | [ ]
(402.793.5124)       | Panel Infrastructure       |               |              |
                     | EHR System                |               | [1-5]        | [ ]
                     | Backup/DR                 |               | [1-5]        | [ ]
                     | IT Support/MSP            |               | [1-5]        | [ ]
```

**Note:** All vendors handling PHI must have signed Business Associate Agreements (BAA)

### MSP Service Expectations
- **Desired Service Level:** [ ] Co-Managed IT [X] Fully Managed [ ] Project-Based [ ] Advisory Only
- **Preferred Communication Method:** [ ] Email [ ] Phone [ ] Teams [ ] Portal
- **Preferred Meeting Cadence:** [ ] Weekly [ ] Bi-Weekly [X] Monthly [ ] Quarterly [ ] As-Needed
- **Escalation Preferences:** TBD (24/7 support critical for clinical systems)
- **BAA Requirement:** MSP must sign Business Associate Agreement for HIPAA compliance

---

## Additional Notes

### Special Considerations
```
Business Model:
- Nonprofit continuing care retirement community (CCRC)
- Founded 1905 (119+ years serving Blair, NE community)
- 24/7/365 operations (residential healthcare facility)
- Multi-level care: independent living, assisted living, skilled nursing, memory care
- Medicare and Medicaid certified
- Total capacity: 194 residents (88 skilled nursing + 18 assisted + 8 independent + memory care)

Operational Requirements:
- 24/7 nursing coverage (three shifts: 7am-3pm, 3pm-11pm, 11pm-7am)
- HIPAA compliance mandatory (Protected Health Information)
- Electronic Health Records (EHR) must be available 24/7
- Medication administration tracking critical for resident safety
- Nurse call system must be operational at all times
- Emergency response procedures and systems
- State health department surveys and compliance

Industry Vertical:
- Long-term care / skilled nursing facility
- Continuing Care Retirement Community (CCRC)
- Memory care / Alzheimer's care specialization
- Medicare/Medicaid provider
- Nonprofit healthcare organization

Technology Needs:
- HIPAA-compliant infrastructure (all systems)
- Electronic Health Records (EHR) system
- Electronic Medication Administration Record (eMAR)
- Nurse call and emergency response systems
- Staff scheduling and time tracking
- Medicare/Medicaid billing and claims
- Dietary management system
- Activities tracking and calendar
- Resident and family communication portal
- Security cameras and access control
- Backup and disaster recovery (HIPAA required)
- Mobile devices for point-of-care documentation
- Infection control tracking
- Quality assurance and reporting (QAPI)

Compliance Considerations:
- HIPAA Security Rule compliance (administrative, physical, technical safeguards)
- Business Associate Agreements with all vendors handling PHI
- Annual HIPAA risk assessments
- Audit trails and logging (6+ years retention)
- Annual HIPAA training for all staff
- Breach notification procedures
- Medicare Conditions of Participation
- State healthcare licensing requirements
- CMS quality reporting requirements
```

### Customer Strengths
```
To be documented after initial assessment:
- Long history (119+ years) demonstrates stability and community trust
- Nonprofit mission-focused organization
- Medicare/Medicaid certified (demonstrates quality standards)
- Multi-level care continuum (independent → assisted → skilled → memory care)
- Established community presence in Blair, NE
- Diverse service offerings (skilled nursing, assisted living, memory care)
```

### Opportunities for Improvement
```
Potential Areas (to be confirmed with customer):
- **CRITICAL: Windows Server 2008 R2 Domain Controller migration to Azure AD**
  - Server 2008 R2 is END OF LIFE (since January 2020)
  - No security patches or support available
  - Significant HIPAA compliance and security risk
  - Azure AD migration eliminates on-prem DC dependency
- HIPAA compliance assessment and remediation
- MFA implementation for all users accessing PHI (part of Azure AD migration)
- Modern EHR system migration (if using legacy system)
- Cloud-based backup and disaster recovery
- Microsoft 365 implementation for staff communication
- Mobile point-of-care documentation for CNAs
- Family communication portal / resident portal
- Network infrastructure upgrade (separate VLANs for clinical/administrative)
- Security awareness training (phishing, ransomware)
- Medication administration system (eMAR) optimization
- Staff scheduling and communication improvements
- Integration between EHR, billing, and pharmacy systems
- Telehealth capabilities for physician consultations
- Remote monitoring and IoT for resident safety
- Document management system for policies/procedures (Jaclyn's policy files to SharePoint)
- Quality assurance and reporting automation
- Infection control tracking and reporting
- Proper rack infrastructure and cable management (during relocation project)
- Network documentation and IP address management (IPAM)
- FortiGate firewall configuration audit and optimization
- Intune device management implementation (part of Azure AD migration)
```

### Documentation & Resources
**Available Documentation:**
- Floor Plans (PDF): `Crowell/Crowell_Building_Floor_Plan.pdf`
  - Page 1: First Level Floorplan (resident rooms 101-161, main dining, offices)
  - Page 2: Second Level Floorplan (resident rooms 200-260, current IT room location marked)
  - Page 3: Lower Level Floorplan (activities, therapy, mechanical, storage)
- Floor Plans (Draw.io):
  - **Basic Structure:** `Crowell/Crowell_Floor_Plans.drawio`
    - Simple overview with main areas
    - IT infrastructure location highlighted on Second Level
    - Color-coded areas by function
  - **Detailed Room-by-Room:** `Crowell/Crowell_Floor_Plans_Detailed.drawio` (RECOMMENDED)
    - All individual room numbers included
    - IT infrastructure location prominently highlighted with equipment list
    - Relocation project visualization with directional arrow
    - Three pages (one per level)
    - Comprehensive legends on each page

**Current Infrastructure Photos:**
- `Crowell/signal-2025-12-03-102320.jpeg` - Wall-mounted rack with Diode Technologies patch panel
- `Crowell/signal-2025-12-03-102320_002.jpeg` - Full equipment stack (HP switch, FortiGate, FortiSwitch)
- `Crowell/signal-2025-12-03-102320_003.jpeg` - Close-up of FortiGate 80F and FortiSwitch 124E
- `Crowell/signal-2025-12-03-102320_004.jpeg` - Equipment front panel detail with port status
- `Crowell/signal-2025-12-03-102320_005.jpeg` - Overall workspace view with cabling

**Infrastructure Assessment Notes:**
- Current rack setup uses wall-mounted shelving (not a proper enclosed rack)
- Cable management needs improvement (extensive unmanaged blue cables)
- Equipment is operational but could benefit from proper rack organization
- IP addressing uses 172.163.0.x subnet
- Multiple vendors involved requiring coordination for move project
```

---

## Profile Completion Checklist
- [X] Basic customer information completed (from web sources)
- [ ] User counts and distribution documented
- [X] Office/facility details documented with network details
- [X] Current network infrastructure documented (firewall, switches, patch panels)
- [X] Floor plans and building layout documented
- [X] Infrastructure photos captured and cataloged
- [X] IP addressing scheme documented (172.163.0.x)
- [X] Vendor relationships identified (Great Plains, Diode Technologies)
- [X] Infrastructure relocation project scoped
- [X] On-premises Active Directory documented (Server 2008 R2 - EOL)
- [X] Azure AD migration project planned (CRITICAL PRIORITY)
- [ ] Current Microsoft 365 licensing documented
- [ ] Security posture assessed (MFA needs assessment)
- [ ] Backup strategy documented
- [X] Pain points and objectives identified (Server EOL, policy files)
- [ ] Budget and timeline discussed
- [X] HIPAA compliance requirements documented
- [ ] EHR and clinical systems identified
- [ ] Profile reviewed with customer
- [ ] Profile reviewed with technical team
- [ ] Business Associate Agreement (BAA) signed

**Profile Completed By:** ___________________
**Date:** ___________________
**Next Review Date:** ___________________

**Important Note:** This is a healthcare facility subject to HIPAA regulations. All IT systems, vendors, and MSP services must comply with HIPAA Security Rule requirements. A Business Associate Agreement (BAA) must be in place before any work involving Protected Health Information (PHI) can begin.
