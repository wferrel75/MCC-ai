# Customer Onboarding Notes

## Date: 2025-12-01

---

## Customer Information
- Customer Name:
- Contact:
- Start Date:

---

## Process Flow

### Step 1: Enter Customer Details into Source of Truth

**Common Customer Details to Collect:**

**Basic Company Information:**
- Company Legal Name
- DBA/Trade Name (if different)
- Primary Business Address
- Mailing Address (if different)
- Additional Office Locations
- Company Phone Number
- Company Website
- Industry/Vertical
- Company Size (number of employees)
- Tax ID/EIN

**Primary Contacts:**
- Primary Contact Name, Title, Email, Phone
- Executive Sponsor/Decision Maker
- IT Contact/Technical Lead
- Billing Contact
- After-Hours Emergency Contact(s)

**Business Operations:**
- Business Hours (per location if multiple)
- Time Zone(s)
- Holiday Schedule
- Critical Business Periods
- Maintenance Windows/Blackout Periods
- Systems that cannot restart during business hours

**Service Details:**
- Service Agreement Type/Tier
- Start Date
- Contract Term
- Billing Frequency
- Services Subscribed (managed services, backup, security, help desk, etc.)

**Technical Environment:**
- Number of Users/Endpoints
- Number of Servers (physical/virtual)
- Primary Line of Business Applications
- Cloud Services in Use (M365, Google Workspace, AWS, Azure, etc.)
- Internet Service Provider(s) and Account Details
- Domain Registrar and Account Info
- Existing Technology Vendors/Support Contracts
- Current RMM/Security Tools (if migrating)

**Network Infrastructure:**
- Network Diagram (if available)
- Firewall Make/Model
- Switch Inventory
- Wireless Access Points
- VPN Configuration
- Public IP Addresses

**Compliance & Security:**
- Industry Compliance Requirements (HIPAA, PCI-DSS, SOC 2, etc.)
- Data Retention Policies
- Security Incident Contact Procedures
- Cyber Insurance Information

**Documentation:**
- Existing IT Documentation
- Password Management System
- Asset Lists/Inventory
- Software Licenses and Keys

### Step 2: Datto RMM Setup

**Substeps:**
- Create Site
- Deploy Agent
- Move Site from Default RMM Org
  - Confirm Rules
  - Push Agent

### Step 3: Datto AV/EDR

**Substeps:**
- Setup Organization

### Step 4: Email Filtering (Barracuda)

**Substeps:**
- Create Tenant
- Import/Invite Users
- Configure DNS Records
- Configure Mail hosting configuration (M365)
- Schedule quarantine notification emails
- Enable any known whitelisting rules/blocks
- Test Mailflow
- **Add customer email domains to MX monitoring** *(Easily Automated)*

### Step 5: Credentials Transfer

**Substeps:**
- Create Customer in Keeper
- Leverage secure transfer method to populate credentials in Keeper

### Step 6: Connect Secure Agent Deployment

**Configure Customer in Portal:**
- Confirm agent deployment settings in Datto
- Deploy agent and perform initial scan/discovery

**Datto RMM Variable Creation:**

**Location:** Datto RMM site level

**Variables to create:**

1. **cybercnscompany_id**
   - Description: Customer-specific ID
   - Created at: Site creation in RMM
   - Value: Unique per customer

2. **cybercnstenantid**
   - Description: MCC's tenant ID
   - Value: Same for all customers
   - Note: This is a constant value across all deployments

3. **cybercnstoken**
   - Description: Unique deployment token
   - Value: Unique per customer's site and deployment
   - Note: Customer-specific authentication token

**Next Action:** Once variables are created, add the customer's RMM site to the "Connect Secure Agent" Site Group to start agent deployment.

### Step 7: M365 Permissions Setup

**Substeps:**
- Obtain Global Admin Credentials
- Configure Granular Permissions
  - MCC
  - D&H Cloud

### Step 8: Ticketing System (Zoho Desk)

**Substeps:**
- Import customer and verify account from CRM
- Confirm/Create contacts
- Create custom forms as needed
- Assign appropriate SLA for customer

### Step 9: Document Employee Onboarding/Offboarding Processes

**Substeps:**
- Define Customer Roles
  - Role Names
  - Licenses for Roles
  - Software for Roles
  - Current Users in Roles
- AD/Azure/M365
  - Username Format

### Step 10: RocketCyber

**Substeps:**
- Setup Tenant(s)
- Configure integrations
- Configure Backup Plans
- Deploy Agents

### Step 11: Printer Logic (Optional)

**Substeps:**
- Create Demo Tenant
- Source Drivers
- Setup Printer queues
  - Import from Print Server
  - Create New Printer Queues
- Configure Rules for Print Queues
- Deploy Agent
- Testing
- Convert Tenant to Production


---

## Key Actions


---

## Issues/Blockers


---

## Follow-ups Required


---

## Additional Notes

