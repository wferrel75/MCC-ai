# Customer Profile Template
## Paramount Commercial Real Estate Services - MSP Customer Profile

---

## Customer Identification

**Customer Name:** Paramount Commercial Real Estate Services
**Profile Created Date:** 2025-11-20
**Last Updated:** 2025-11-20
**Account Manager:** TBD
**Primary Technical Contact:** TBD
**Industry/Vertical:** Commercial Real Estate Services

---

## Business Overview

### Company Information
- **Number of Employees:** TBD
- **Number of IT Staff:** TBD
- **Annual Revenue Range:** TBD
- **Business Type:** [X] B2B [ ] B2C [ ] B2B2C [ ] Non-Profit [ ] Government
- **Critical Business Hours:** 8:00 AM - 5:00 PM Central Time (Standard commercial real estate hours)
- **Time Zone(s):** Central Time (US)

### Business Objectives
**Primary Business Goals:**
- Provide comprehensive commercial real estate services to clients
- Build strong market presence and client relationships
- Expand service offerings and market reach
- Maintain professional standards and service excellence

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
├─ Knowledge Workers (Office/Hybrid): TBD (Real estate agents, brokers, administrative)
├─ Remote Workers: TBD (Agents showing properties, remote meetings)
├─ Field/Mobile Workers: TBD
├─ Factory/Warehouse Workers: TBD
├─ Contractors/Temporary: TBD
└─ Service Accounts/Shared Mailboxes: TBD
```

### User Distribution
- **Users requiring full M365 licenses:** TBD (Brokers, agents, management)
- **Users requiring basic email only:** TBD (Administrative support)
- **Users requiring specialized apps:** TBD (CRM, MLS access, transaction management)
- **External collaborators/partners:** TBD (Clients, other agents, title companies, lenders)

### Work Patterns
- **Percentage Remote Workers:** TBD
- **Percentage Hybrid Workers:** TBD (Office plus property showings)
- **Percentage On-Site Only:** TBD
- **BYOD Policy:** [ ] Allowed [ ] Restricted [ ] Prohibited
- **Mobile Device Types:** [ ] iOS [ ] Android [ ] Windows [ ] Other: ___

---

## Office & Site Information

### Site Details
```yaml
sites:
  - name: "Headquarters & Main Office"
    address: "11330 Q Street, Omaha, NE 68137"
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
- **VPN Concurrent Users:** TBD (Agents working remotely, off-site)
- **Remote Desktop Solution:** [ ] RDP [ ] VPN [ ] Third-party: ___
- **Cloud Access Method:** [ ] Direct Internet [ ] VPN [ ] Conditional Access Only

---

## Current Technology Stack

### Microsoft 365 / Office 365
- **M365 Tenant Domain(s):** TBD
- **Primary Domain:** www.paramountcres.com
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
- **Current Usage:** TBD (Property listings, marketing materials, transaction documents, client files)
- **Backup Solution:** TBD

**Database Servers:**
- **SQL Server:** [ ] Yes [ ] No | Version: ___ | Databases: ___
- **Other Databases:** TBD (CRM database, transaction management database)

### Line of Business Applications
```
Application Name              | Vendor      | Hosting         | Users | Cloud-Ready?
------------------------------|-------------|-----------------|-------|-------------
Real Estate CRM/Agent Portal  | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
MLS (Multiple Listing Service)| TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Transaction Management        | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Document Management           | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Client Relationship Management| TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
Marketing/Property Showcase   | TBD         | [On-Prem/Cloud] | TBD   | [Y/N]
```

**Critical Dependencies:**
- MLS access critical for agents to list and search properties
- CRM system essential for managing client relationships and sales pipeline
- Transaction management system handles critical closing documents and timelines
- Document management for contracts, disclosures, and compliance documentation
- Website and property showcase platform for marketing and lead generation
- Mobile access for agents to access listings, client information, and documents while showing properties

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
- **Industry Regulations:** [ ] HIPAA [ ] PCI-DSS [ ] SOX [ ] GDPR [X] Other: Real Estate industry regulations, Fair Housing Act, State real estate licensing requirements
- **Data Retention Requirements:** Transaction documents (typically 7 years per state requirements), Client disclosures and contracts, Proof of funds/financing documentation, inspection and appraisal reports
- **eDiscovery Needs:** [X] Yes [ ] No (Commercial real estate transactions may require document discovery)
- **Data Loss Prevention (DLP):** [X] Required [ ] Nice-to-have [ ] Not needed (Transaction documents, client personal information, financial documents, proprietary property information)

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
- **Analog Lines (Fax/Alarm):** TBD (Fax may be used for contract transmission)

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
Paramount Commercial Real Estate Services operates in the commercial real estate
industry. Key considerations for MSP engagement:

1. SENSITIVE FINANCIAL INFORMATION: Commercial real estate transactions involve
   highly sensitive financial and business information:
   - Proof of funds and financing documents
   - Purchase prices and negotiation information (confidential)
   - Business financial statements and valuations
   - Personal financial information for loan qualification
   - Tax identification and banking information
   Must implement strong data protection and access controls.

2. REGULATORY COMPLIANCE FRAMEWORK: Multiple regulatory requirements apply:
   - Fair Housing Act compliance
   - State real estate licensing requirements
   - Document retention requirements (typically 7 years)
   - eDiscovery capability for potential disputes
   - Confidentiality requirements for transaction information
   - Broker licensing and compliance rules

3. MISSION-CRITICAL SYSTEMS: Several systems critical to daily operations:
   - MLS access necessary for listing and searching properties
   - Transaction management system for closing timelines and documents
   - CRM for client and prospect management
   - Document management for contract storage and retrieval
   System downtime directly impacts agent productivity and transaction timelines.

4. MOBILE WORKFORCE: Agents work in field showing properties, often needing
   access to listings, client information, documents, and communication tools
   while away from office. Mobile security and remote access are important.

5. TIME-SENSITIVE OPERATIONS: Commercial real estate closings have strict timelines.
   System reliability and performance are critical to meeting closing deadlines
   and maintaining client satisfaction.

6. DOCUMENT-INTENSIVE BUSINESS: Large volumes of transaction documents, contracts,
   disclosures, inspection reports, appraisals, and related materials must be
   properly stored, organized, and retrievable. Document management is critical
   to compliance and operational efficiency.

7. WEBSITE AND ONLINE PRESENCE: Company maintains website (www.paramountcres.com)
   for marketing and lead generation. Website reliability and performance impact
   business development efforts.
```

### Customer Strengths
```
1. Established Location: Based at 11330 Q Street, Omaha, NE 68137 (professional
   office address) suggests established presence in Omaha market.

2. Professional Web Presence: Maintains professional website
   (www.paramountcres.com) indicating commitment to digital presence and
   marketing to potential clients.

3. Commercial Real Estate Specialization: Focus on commercial real estate services
   suggests deep expertise in this market segment and client relationships.

4. Comprehensive Service Offering: Implied ability to handle various aspects of
   commercial real estate transactions (brokerage, property management, consulting).

5. Contact Information: Published contact information (402-502-3300, website)
   shows professional business operations and client accessibility.
```

### Opportunities for Improvement
```
1. Cloud Migration of Line of Business Applications: Evaluate migration of real estate
   CRM, transaction management, and document management systems to cloud-based solutions
   for improved accessibility, scalability, and disaster recovery. SaaS solutions may
   also reduce IT overhead.

2. Enhanced Mobile Application: Develop or enhance mobile app for agents providing:
   - Real-time access to MLS listings
   - Client and prospect information
   - Document access and e-signature capability
   - Transaction status tracking
   - Communication and collaboration tools

3. Digital Transaction Management: Implement e-signature and digital transaction
   management platform to:
   - Streamline document signing (buyers, sellers, lenders)
   - Reduce paper-based processes
   - Improve transaction timeline management
   - Maintain audit trail for compliance

4. Client Portal Development: Create client-facing portal enabling:
   - Transaction status visibility
   - Document upload and download
   - Communication with agents
   - Property information and disclosures
   - Financial/closing information

5. Document Management and Compliance Automation: Implement document management system
   with:
   - Automatic document retention tracking
   - Compliance checklist automation
   - Document search and retrieval
   - Version control and audit trail

6. Business Intelligence and Analytics: Implement analytics to track:
   - Sales pipeline and conversion metrics
   - Agent productivity and performance
   - Transaction cycle time
   - Market trends and pricing analysis
   - Client satisfaction and retention

7. Cybersecurity Enhancement: Given sensitive financial information handled:
   - Implement encryption for financial documents
   - Multi-factor authentication for all users
   - DLP solution for financial document protection
   - Regular security awareness training on transaction security

8. Website Optimization: Enhance professional website for:
   - Lead generation improvement
   - Search engine optimization
   - Mobile responsiveness
   - Property showcase capabilities
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
**Next Review Date:** TBD (To be scheduled after initial customer consultation at 402-502-3300)
