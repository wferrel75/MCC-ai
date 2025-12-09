# MSP-to-MSP Transition Checklist

**Client Name:** _______________________
**Transition Date:** _______________________
**Outgoing MSP:** _______________________
**Project Manager:** _______________________

---

## 1. NETWORK INFRASTRUCTURE DOCUMENTATION

### Network Diagrams and Topology
- [ ] Current network topology diagram (logical)
- [ ] Physical network layout diagram
- [ ] VLAN configuration and segmentation details
- [ ] IP addressing scheme and subnet documentation
- [ ] DNS configuration and zone files
- [ ] DHCP scope configuration and reservations
- [ ] WAN/ISP connection details and circuit IDs
- [ ] VPN configurations and tunnel documentation
- [ ] Firewall rule sets and ACL documentation
- [ ] Wireless network topology and coverage maps

### Network Device Details
- [ ] Complete list of switches (models, locations, firmware versions)
- [ ] Complete list of routers (models, locations, firmware versions)
- [ ] Firewall make/model and current firmware version
- [ ] Wireless access point inventory and placement
- [ ] Load balancers and configuration details
- [ ] Network attached storage (NAS) devices

---

## 2. CREDENTIALS AND ACCESS INFORMATION

### Administrative Credentials
- [ ] Domain administrator credentials
- [ ] Local administrator passwords for all servers
- [ ] Workstation local admin passwords (if standardized)
- [ ] Network device admin credentials (switches, routers, APs)
- [ ] Firewall admin credentials
- [ ] Hypervisor/virtualization platform credentials

### Cloud Services and SaaS Platforms
- [ ] Microsoft 365 Global Admin credentials
- [ ] Azure tenant admin credentials
- [ ] AWS root and IAM admin credentials
- [ ] Google Workspace super admin credentials
- [ ] Cloud backup service admin access
- [ ] Cloud storage admin credentials (Dropbox, Box, etc.)
- [ ] Security platform credentials (EDR, email security, etc.)

### Application and Database Credentials
- [ ] Line of business (LOB) application admin credentials
- [ ] Database admin credentials (SQL Server, MySQL, etc.)
- [ ] CRM/ERP system admin access
- [ ] Financial software admin credentials
- [ ] Email server admin credentials (if on-premise)
- [ ] Application service account credentials

### Remote Access and Monitoring
- [ ] RMM agent access and removal instructions
- [ ] Remote desktop gateway credentials
- [ ] VPN user credentials and certificate files
- [ ] Jump box/bastion host credentials
- [ ] Out-of-band management credentials (iLO, iDRAC, IPMI)

### Vendor and Service Provider Access
- [ ] ISP account credentials and support contacts
- [ ] Telecom/VoIP provider credentials
- [ ] Software licensing portal credentials
- [ ] Hardware vendor support portal credentials
- [ ] Domain registrar credentials
- [ ] SSL certificate provider credentials
- [ ] Cloud service provider billing portals

### Password Management
- [ ] Password manager export (LastPass, 1Password, etc.)
- [ ] Password complexity and rotation policies
- [ ] Service account documentation
- [ ] Emergency access procedures documentation

---

## 3. SERVER AND WORKSTATION INVENTORY

### Server Details
- [ ] Complete server inventory with specifications
- [ ] Server roles and functions (DC, file, app, database, etc.)
- [ ] Operating system versions and patch levels
- [ ] Virtualization platform details (VMware, Hyper-V, etc.)
- [ ] Server warranty and support contract information
- [ ] Server backup schedules and retention policies
- [ ] Disaster recovery priority/tier classification
- [ ] Performance baseline documentation
- [ ] Installed applications per server
- [ ] Licensing information for server OS and applications

### Workstation and Endpoint Details
- [ ] Complete workstation inventory
- [ ] Computer names, users, and locations
- [ ] Hardware specifications (make, model, serial numbers)
- [ ] Operating system versions
- [ ] Installed software inventory
- [ ] Warranty and lease information
- [ ] Mobile device inventory (laptops, tablets)
- [ ] Peripheral device inventory (printers, scanners, etc.)

### Virtual Environment Details
- [ ] Host server specifications and configurations
- [ ] Virtual machine inventory and specifications
- [ ] VM templates and gold images
- [ ] Storage allocation and datastore layout
- [ ] Snapshot policies and current snapshots
- [ ] Replication and high availability configuration
- [ ] Licensing details (per-socket, per-VM, etc.)

---

## 4. ACTIVE DIRECTORY AND IDENTITY MANAGEMENT

### Domain Configuration
- [ ] Domain name and forest structure
- [ ] Domain controller inventory and roles (PDC, DNS, DHCP, etc.)
- [ ] Functional levels (forest and domain)
- [ ] Site topology and replication configuration
- [ ] Trust relationships with other domains
- [ ] DNS zone configuration and records

### Organizational Units and Group Policy
- [ ] OU structure documentation
- [ ] Group Policy Object (GPO) inventory and settings
- [ ] GPO export backup
- [ ] Security group listing and membership
- [ ] Distribution group listing
- [ ] Service account documentation

### User and Computer Management
- [ ] User account listing with roles and permissions
- [ ] Computer account listing
- [ ] Disabled account policy and cleanup procedures
- [ ] Password policies and fine-grained password policies
- [ ] Account lockout policies
- [ ] User provisioning/de-provisioning procedures

---

## 5. EMAIL AND COLLABORATION SYSTEMS

### Email Infrastructure
- [ ] Email platform details (Exchange, 365, Google, etc.)
- [ ] Mail server configuration (if on-premise)
- [ ] Mailbox database details and sizes
- [ ] Email routing and connector configuration
- [ ] Spam filtering and email security solution details
- [ ] Email archiving solution and retention policies
- [ ] Distribution list inventory
- [ ] Shared mailbox inventory and permissions
- [ ] Email signature management solution

### Microsoft 365 / Google Workspace
- [ ] Tenant configuration details
- [ ] Licensed users and license types
- [ ] SharePoint/OneDrive configuration
- [ ] Teams configuration and policies
- [ ] Conditional access policies
- [ ] Mobile device management (MDM) policies
- [ ] Data loss prevention (DLP) policies
- [ ] External sharing policies

---

## 6. SECURITY INFRASTRUCTURE

### Endpoint Security
- [ ] Antivirus/EDR platform and version
- [ ] Endpoint security agent deployment details
- [ ] Security policy configuration
- [ ] Threat detection and response procedures
- [ ] Quarantine and remediation procedures
- [ ] Endpoint encryption solution (BitLocker, etc.)
- [ ] Application whitelisting configuration

### Network Security
- [ ] Firewall configuration backup
- [ ] Firewall rule documentation
- [ ] Intrusion detection/prevention system details
- [ ] Web content filtering solution
- [ ] Email security gateway configuration
- [ ] DDoS protection configuration
- [ ] Network segmentation strategy

### Identity and Access Management
- [ ] Multi-factor authentication (MFA) solution and config
- [ ] Single sign-on (SSO) configuration
- [ ] Privileged access management solution
- [ ] Certificate authority configuration
- [ ] Certificate inventory and expiration dates
- [ ] Remote access security policies
- [ ] Conditional access policies

### Security Monitoring and Compliance
- [ ] SIEM solution details and configuration
- [ ] Security event log retention policies
- [ ] Security monitoring procedures and alerting
- [ ] Vulnerability scanning solution and results
- [ ] Penetration testing reports (last 12 months)
- [ ] Security incident response procedures
- [ ] Compliance framework documentation (HIPAA, PCI-DSS, etc.)
- [ ] Security awareness training records

---

## 7. BACKUP AND DISASTER RECOVERY

### Backup Infrastructure
- [ ] Backup solution details (vendor, version)
- [ ] Backup server/appliance specifications
- [ ] Backup schedule documentation (full, incremental, differential)
- [ ] Retention policies for all backup jobs
- [ ] List of all systems being backed up
- [ ] Backup job success/failure reports (last 30 days)
- [ ] Backup storage capacity and growth trends
- [ ] Offsite/cloud backup configuration
- [ ] Backup encryption details

### Disaster Recovery Planning
- [ ] Disaster recovery plan document
- [ ] Recovery time objectives (RTO) for each system
- [ ] Recovery point objectives (RPO) for each system
- [ ] Disaster recovery testing results (last test)
- [ ] Failover procedures and runbooks
- [ ] Business continuity plan
- [ ] Emergency contact list
- [ ] Alternate site information

### Backup Verification
- [ ] Recent restore test results
- [ ] Backup validation procedures
- [ ] Known backup failures or gaps
- [ ] Bare metal restore procedures
- [ ] Application-specific backup procedures (SQL, Exchange, etc.)

---

## 8. APPLICATIONS AND LICENSING

### Business Applications
- [ ] Complete inventory of business applications
- [ ] Application architecture diagrams
- [ ] Application dependencies and integration points
- [ ] Application version and patch level
- [ ] Application configuration documentation
- [ ] Database backend details
- [ ] Application admin credentials
- [ ] Custom application source code (if applicable)

### Software Licensing
- [ ] Microsoft volume licensing agreement details
- [ ] Volume license service center (VLSC) credentials
- [ ] Software assurance coverage details
- [ ] Third-party application licenses and keys
- [ ] License compliance audit results
- [ ] SaaS subscription inventory
- [ ] Maintenance and support contract details
- [ ] License renewal dates

---

## 9. TELECOMMUNICATIONS AND VOIP

### Voice Infrastructure
- [ ] Phone system details (make, model, version)
- [ ] VoIP provider information
- [ ] SIP trunk configuration
- [ ] Extension mapping and dial plan
- [ ] Voicemail system configuration
- [ ] Call routing and auto-attendant setup
- [ ] Emergency (E911) configuration
- [ ] Conference bridge details
- [ ] Call recording system (if applicable)

### Network and Internet
- [ ] ISP account information and circuit IDs
- [ ] Bandwidth and service level agreements
- [ ] Redundant connection details
- [ ] SD-WAN configuration (if applicable)
- [ ] ISP support contact information
- [ ] QoS policies for voice traffic

---

## 10. MONITORING AND MANAGEMENT TOOLS

### RMM and Monitoring
- [ ] Current RMM platform details
- [ ] Agent deployment scope
- [ ] Custom scripts and automation
- [ ] Alert configuration and thresholds
- [ ] Monitoring templates and policies
- [ ] Performance baseline data
- [ ] Historical monitoring data export

### Ticketing and Documentation
- [ ] PSA/ticketing system access
- [ ] Ticket history export (last 12 months minimum)
- [ ] Client contact information
- [ ] Escalation procedures
- [ ] SLA definitions and performance metrics
- [ ] Documentation repository access (IT Glue, Hudu, etc.)
- [ ] Network documentation
- [ ] Procedure documents and runbooks

---

## 11. SERVICE DELIVERY DOCUMENTATION

### Service Agreements
- [ ] Current MSA (Master Service Agreement)
- [ ] Statement of Work (SOW) documents
- [ ] Service Level Agreements (SLAs)
- [ ] Addendums and amendments
- [ ] Pricing and billing details
- [ ] Contract termination terms and notice period

### Operational Procedures
- [ ] Standard operating procedures (SOPs)
- [ ] Change management procedures
- [ ] Incident response procedures
- [ ] Escalation matrix
- [ ] Maintenance window schedules
- [ ] Client communication preferences
- [ ] Emergency contact procedures

### Performance Reports
- [ ] Monthly service reports (last 6 months)
- [ ] Uptime reports
- [ ] SLA compliance reports
- [ ] Ticket metrics and resolution times
- [ ] System health reports
- [ ] Security incident reports
- [ ] Project status reports

---

## 12. VENDOR AND THIRD-PARTY RELATIONSHIPS

### Vendor Contacts
- [ ] Complete vendor contact list
- [ ] Support contract details
- [ ] Account manager contact information
- [ ] Support ticket system access
- [ ] Service provider SLAs
- [ ] Vendor portal credentials

### Third-Party Service Providers
- [ ] Co-managed service providers
- [ ] Specialized consultants (security, compliance, etc.)
- [ ] Managed security service providers (MSSPs)
- [ ] Data center or colocation providers
- [ ] Cloud service providers
- [ ] Software-as-a-Service (SaaS) vendors

---

## 13. COMPLIANCE AND AUDIT DOCUMENTATION

### Regulatory Compliance
- [ ] Compliance frameworks applicable (HIPAA, PCI-DSS, SOC 2, etc.)
- [ ] Most recent audit reports
- [ ] Compliance documentation and evidence
- [ ] Data handling and privacy policies
- [ ] Data classification scheme
- [ ] Compliance gaps and remediation plans
- [ ] Regulatory contact information

### Policies and Procedures
- [ ] Acceptable use policy (AUP)
- [ ] Information security policy
- [ ] Incident response policy
- [ ] Data retention and destruction policy
- [ ] Remote access policy
- [ ] Change management policy
- [ ] Asset management policy

---

## 14. CLOUD INFRASTRUCTURE

### Cloud Platforms
- [ ] AWS account details and IAM configuration
- [ ] Azure subscription details and RBAC
- [ ] Google Cloud Platform project details
- [ ] Cloud resource inventory (VMs, storage, databases, etc.)
- [ ] Cloud architecture diagrams
- [ ] Cost management and budget alerts
- [ ] Cloud backup and DR configuration
- [ ] Auto-scaling and load balancing configuration

### Hybrid Infrastructure
- [ ] VPN/ExpressRoute/Direct Connect configuration
- [ ] Hybrid identity configuration (Azure AD Connect, etc.)
- [ ] Cloud migration plans or documentation
- [ ] Hybrid backup configuration

---

## 15. KNOWLEDGE TRANSFER AND HANDOFF

### Technical Handoff Sessions
- [ ] Infrastructure overview session scheduled
- [ ] Application walkthrough session scheduled
- [ ] Security posture review session scheduled
- [ ] Known issues and workarounds review
- [ ] Recent changes and projects overview
- [ ] Ongoing projects and roadmap discussion

### Documentation Review
- [ ] Network documentation review
- [ ] Procedure documentation review
- [ ] Custom scripts and automation review
- [ ] Client-specific requirements review
- [ ] Tribal knowledge capture

### Client Relationship Transfer
- [ ] Key client contact introductions
- [ ] Client communication preferences
- [ ] Client history and relationship notes
- [ ] Client expectations and hot buttons
- [ ] Upcoming client projects or initiatives

---

## 16. OPEN ISSUES AND PROJECTS

### Current Issues
- [ ] Open ticket inventory
- [ ] Known system issues or bugs
- [ ] Performance bottlenecks
- [ ] Pending hardware failures or EOL equipment
- [ ] Security vulnerabilities awaiting remediation

### In-Flight Projects
- [ ] Current project status and timeline
- [ ] Project documentation
- [ ] Vendor quotes and proposals
- [ ] Client expectations and commitments
- [ ] Project handoff or transition plan

### Deferred Maintenance
- [ ] Recommended improvements not implemented
- [ ] Technical debt inventory
- [ ] EOL/EOS equipment list
- [ ] Patch or update backlog
- [ ] Capacity planning recommendations

---

## 17. FINANCIAL AND BILLING INFORMATION

### Billing Details
- [ ] Current billing model and rates
- [ ] Invoicing history (last 12 months)
- [ ] Unbilled time or materials
- [ ] Prepaid services or credits
- [ ] Billing contact and payment terms

### Client Spend Analysis
- [ ] Hardware and software purchases (last 12 months)
- [ ] Project spending history
- [ ] Recurring service costs
- [ ] Vendor subscription costs

---

## 18. TRANSITION LOGISTICS

### Timeline and Coordination
- [ ] Transition timeline and milestones
- [ ] Cutover date and maintenance window
- [ ] Client communication plan
- [ ] RMM agent removal schedule
- [ ] New tooling deployment schedule

### Access Removal
- [ ] Outgoing MSP access removal checklist
- [ ] RMM agent uninstall verification
- [ ] VPN access revocation
- [ ] Admin account cleanup
- [ ] Service account password changes

### Post-Transition Support
- [ ] Outgoing MSP availability for questions
- [ ] Knowledge transfer completion criteria
- [ ] Documentation acceptance criteria
- [ ] Client sign-off on transition completion

---

## NOTES AND SPECIAL CONSIDERATIONS

**Known Issues:**
_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________

**Client-Specific Requirements:**
_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________

**Critical Systems or Dependencies:**
_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________

**Timeline Constraints:**
_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________

---

## SIGN-OFF

**Outgoing MSP Representative:**
Name: _______________________ Date: _________
Signature: _______________________

**Incoming MSP Representative:**
Name: _______________________ Date: _________
Signature: _______________________

**Client Representative:**
Name: _______________________ Date: _________
Signature: _______________________

---

## TRANSITION COMPLETION CHECKLIST

- [ ] All documentation received and reviewed
- [ ] All credentials tested and verified
- [ ] Knowledge transfer sessions completed
- [ ] Monitoring and management tools deployed
- [ ] Client communication plan executed
- [ ] Outgoing MSP access removed
- [ ] 30-day post-transition review scheduled
- [ ] Client satisfaction survey completed

---

**Document Version:** 1.0
**Last Updated:** 2025-12-04
**Document Owner:** MSP Operations Team
