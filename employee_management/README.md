# MCC Employee Off-boarding System

A comprehensive employee off-boarding solution for Midwest Cloud Computing, designed to ensure secure, smooth, and customer-focused transitions when employees depart.

## Overview

This system provides:

- **Comprehensive Process Documentation** - Detailed procedures for all employee off-boarding scenarios
- **Semi-Automated Tools** - Python scripts to generate reports, checklists, and documentation
- **Integration Templates** - Ready-to-use templates for Zoho Desk and Zoho Projects
- **Role-Specific Workflows** - Specialized processes for helpdesk engineers with customer responsibilities

## System Components

### 📋 Documentation

1. **[OFFBOARDING_PROCESS.md](OFFBOARDING_PROCESS.md)** - Complete off-boarding procedures including:
   - Core process for all employees
   - Access revocation across MCC's entire technology stack
   - Role-specific procedures for helpdesk engineers
   - Customer transition process for primary contacts/SMEs
   - Quality assurance and audit procedures

2. **[zoho_desk_ticket_template.md](zoho_desk_ticket_template.md)** - Zoho Desk integration:
   - Ticket template with custom fields
   - Workflow automation rules
   - Email notification templates
   - Reporting configuration

3. **[zoho_projects_template.md](zoho_projects_template.md)** - Zoho Projects integration:
   - Project template with milestones and tasks
   - Task dependencies and timelines
   - Collaboration features
   - Progress tracking and reporting

### 🔧 Automation Tools

4. **[offboarding_automation.py](offboarding_automation.py)** - Python automation script:
   - Generate access revocation checklists
   - Query Zoho Desk for assigned tickets
   - Query Zoho Projects for active tasks
   - Identify customer primary contact assignments
   - Suggest reassignments based on workload
   - Generate customer transition documentation
   - Create comprehensive off-boarding reports

### ⚙️ Configuration

5. **[config.json.template](config.json.template)** - Configuration template for API integrations
6. **[requirements.txt](requirements.txt)** - Python dependencies

## Quick Start

### 1. Initial Setup

#### Install Python Dependencies
```bash
# Install required Python packages
pip install -r requirements.txt
```

#### Configure API Access
```bash
# Copy configuration template
cp config.json.template config.json

# Edit config.json with your API credentials
nano config.json
```

Required API credentials:
- **Zoho Desk API** - For ticket management
- **Zoho Projects API** - For project task management
- **Microsoft Graph API** - For M365/Azure AD management (optional)
- **Datto RMM API** - For RMM user management (optional)

#### Set Up Zoho Desk Template
1. Import ticket template from `zoho_desk_ticket_template.md`
2. Create custom fields as specified
3. Configure workflow rules
4. Set up email notifications

#### Set Up Zoho Projects Template
1. Import project template from `zoho_projects_template.md`
2. Configure custom fields
3. Set up automation rules
4. Configure reports

### 2. Running an Off-boarding

#### When Employee Departure is Announced

**Step 1: Generate Off-boarding Report**
```bash
python offboarding_automation.py \
  --employee E12345 \
  --name "John Doe" \
  --email john.doe@midcloudcomputing.com \
  --role helpdesk
```

This generates:
- Complete off-boarding report
- Access revocation checklist
- Ticket analysis and reassignment plan
- Project assignment report
- Customer primary contact list (for helpdesk role)

**Step 2: Create Tracking Ticket/Project**

In Zoho Desk:
- Create new ticket using "Employee Off-boarding" template
- Attach generated reports
- Update custom fields
- Assign to IT Manager

In Zoho Projects:
- Create new project from "Employee Off-boarding" template
- Update employee details
- Attach reports
- Create customer-specific transition tasks

**Step 3: Execute Off-boarding Process**

Follow procedures in [OFFBOARDING_PROCESS.md](OFFBOARDING_PROCESS.md):

- **Phase 1:** Initiation & Planning
- **Phase 2:** Knowledge Transfer (if notice period)
- **Phase 3:** Access Management
- **Phase 4:** Reassignment & Transition
- **Phase 5:** Monitoring & Validation

### 3. Special Handling: Helpdesk Engineers

For helpdesk engineers with customer primary contact responsibilities:

#### Generate Customer Transition Documents
```bash
# For each customer, generate transition documentation
python offboarding_automation.py \
  --customer-transition "Acme Corporation" "John Doe" "Jane Smith"
```

#### Complete Customer Transition Checklist

For each customer:
1. ✅ Create customer transition document
2. ✅ Review with departing engineer (if available)
3. ✅ Review with receiving engineer
4. ✅ Send customer introduction email
5. ✅ Update CRM/documentation systems
6. ✅ Monitor first 2-3 customer interactions
7. ✅ Conduct transition review at 30 days

## Usage Examples

### Immediate Termination

```bash
# Generate full report
python offboarding_automation.py \
  --employee E99999 \
  --name "Jane Smith" \
  --email jane.smith@midcloudcomputing.com \
  --role helpdesk

# Access revocation should happen within 2 hours
# Follow IMMEDIATE DEPARTURE procedures in OFFBOARDING_PROCESS.md
```

### Resignation with Notice

```bash
# Generate planning report
python offboarding_automation.py \
  --employee E88888 \
  --name "Bob Johnson" \
  --email bob.johnson@midcloudcomputing.com \
  --role helpdesk

# Use notice period for knowledge transfer
# Follow PLANNED DEPARTURE procedures in OFFBOARDING_PROCESS.md
```

### Generate Checklist Only

```bash
# Quick checklist generation
python offboarding_automation.py \
  --generate-checklist E77777 \
  --name "Alice Williams"
```

### Query Specific Data

```bash
# Get ticket report only
python offboarding_automation.py --tickets john.doe@midcloudcomputing.com

# Get project report only
python offboarding_automation.py --projects john.doe@midcloudcomputing.com

# Get customer assignments only
python offboarding_automation.py --customers john.doe@midcloudcomputing.com
```

## n8n Workflow Automation

For full automation of the off-boarding process, n8n workflows are available in the `n8n_workflows/` directory.

### Available Workflows

1. **Offboarding Initiation** - Orchestrates the entire process
2. **Access Revocation** - Automates Microsoft 365/Entra ID and system access revocation
3. **Ticket Reassignment** - Handles Zoho Desk ticket redistribution with intelligent routing
4. **Customer Transition** - Manages customer primary contact transitions for helpdesk engineers
5. **Monitoring & Audit** - Daily compliance checks and 30-day monitoring

### Quick Start

1. **Import workflows** into your n8n instance
2. **Configure credentials** (Microsoft Graph, Zoho, PostgreSQL, SMTP)
3. **Set environment variables** for organization IDs and email addresses
4. **Activate workflows**

**Trigger via webhook:**
```bash
curl -X POST https://your-n8n-instance/webhook/offboarding-initiate \
  -H "Content-Type: application/json" \
  -d '{
    "employee_id": "E12345",
    "employee_name": "John Doe",
    "employee_email": "john.doe@midcloudcomputing.com",
    "role": "helpdesk",
    "departure_type": "Resignation",
    "last_working_day": "2025-12-15",
    "manager_name": "Jane Smith",
    "manager_email": "jane.smith@midcloudcomputing.com"
  }'
```

### What Gets Automated

**Fully Automated:**
- ✅ Entra ID account disable
- ✅ Active session revocation
- ✅ Security group removal
- ✅ License revocation
- ✅ Out-of-office auto-reply configuration
- ✅ Zoho Desk ticket creation and updates
- ✅ Zoho Projects project creation
- ✅ Ticket reassignment with intelligent routing
- ✅ Customer transition emails
- ✅ Database updates for customer assignments
- ✅ Daily audit checks
- ✅ Email notifications to stakeholders

**Semi-Automated (generates checklists):**
- RocketCyber, ConnectSecure, Keeper access
- Network infrastructure (Meraki, UniFi, Fortinet)
- Cloud platforms (Azure, AWS)
- Customer environment access

**Documentation:** Full details in `n8n_workflows/README.md`

## Technology Stack Coverage

The off-boarding process covers access revocation for all MCC systems:

### Identity & Security
- Microsoft Entra ID (Azure AD)
- Microsoft 365 (Exchange, SharePoint, Teams, OneDrive)
- RocketCyber (Kaseya MDR)
- ConnectSecure (Vulnerability Management)
- Keeper Security (Password Management)
- KnowBe4 (Security Awareness Training)

### Operations & Management
- Datto RMM
- Zoho Desk
- Zoho Projects
- Microsoft OneNote

### Infrastructure
- Cisco Meraki (Firewalls, Switches, APs)
- Ubiquiti UniFi
- Fortinet FortiGate
- Microsoft Azure
- AWS (if applicable)

### Backup & Recovery
- Acronis Cyber Protect

### Customer Environments
- Customer VPNs
- Customer admin portals
- Customer cloud tenants

## Process Workflows

### Core Off-boarding Phases

```
1. INITIATION
   ├── Create tracking ticket/project
   ├── Generate reports
   ├── Notify stakeholders
   └── Approve reassignment plan

2. KNOWLEDGE TRANSFER (if notice period)
   ├── Document tickets
   ├── Document projects
   ├── Create customer transition docs
   └── Conduct KT meetings

3. ACCESS MANAGEMENT (last working day)
   ├── Execute access revocation checklist
   ├── Collect physical assets
   └── Verify revocation

4. REASSIGNMENT & TRANSITION
   ├── Reassign tickets
   ├── Transfer projects
   ├── Transition customers
   └── Update documentation

5. MONITORING & VALIDATION (30 days)
   ├── Audit access revocation
   ├── Monitor customer transitions
   ├── Complete exit interview
   └── Document lessons learned
```

### Helpdesk Engineer Customer Transition

```
1. IDENTIFY CUSTOMERS
   └── Run automation to list primary contacts

2. ASSESS & PLAN
   ├── Assign new primary contacts
   ├── Consider workload balance
   └── Match technical expertise

3. DOCUMENT
   ├── Create transition docs for each customer
   ├── Include technical environment
   ├── Include relationship context
   └── Include access information

4. INTRODUCE
   ├── Send introduction emails
   ├── Offer transition calls
   └── Shadow first interaction

5. MONITOR
   ├── Week 1: Close monitoring
   ├── Week 2-4: Active monitoring
   └── Week 4: Transition review
```

## Best Practices

### Security
- ✅ Execute access revocation on last working day (or immediately for termination)
- ✅ Audit all access within 24 hours of revocation
- ✅ Document all revocation actions
- ✅ Verify zero active sessions
- ✅ Reset shared credentials employee had access to

### Customer Service
- ✅ Notify customers promptly (within 24 hours)
- ✅ Provide personal introduction for premium/high-touch customers
- ✅ Ensure no service interruption during transition
- ✅ Monitor customer satisfaction during transition period
- ✅ Document customer preferences for receiving engineer

### Knowledge Transfer
- ✅ Begin documentation early in notice period
- ✅ Focus on tribal knowledge and customer context
- ✅ Use OneNote for centralized documentation
- ✅ Conduct hands-on shadowing where possible
- ✅ Record transition meetings (with permission)

### Process Improvement
- ✅ Conduct post-off-boarding review
- ✅ Document what went well and what didn't
- ✅ Identify knowledge gaps exposed
- ✅ Update documentation and processes
- ✅ Review quarterly for continuous improvement

## Troubleshooting

### Common Issues

**Issue: API credentials not working**
- Verify credentials in `config.json`
- Check API token expiration
- Verify permissions granted to API application
- Test API access manually

**Issue: Cannot find employee's assignments**
- Verify employee email is correct
- Check if employee used different email in systems
- Manually query systems if API fails
- Use sample data mode for testing

**Issue: Customer transition receiving complaints**
- Review introduction email timing
- Ensure receiving engineer was properly briefed
- Check if knowledge transfer was adequate
- Schedule manager check-in with customer

**Issue: Access still active after revocation**
- Run audit script to identify remaining access
- Check for service accounts using employee name
- Verify licenses fully revoked in M365
- Check for API tokens/keys not in standard list

## File Structure

```
employee_management/
├── README.md                          # This file
├── CLAUDE.md                          # Guidance for future Claude Code instances
├── MCC_Profile.md                     # Company profile (symlink)
├── OFFBOARDING_PROCESS.md            # Complete process documentation
├── offboarding_automation.py         # Python automation script
├── requirements.txt                   # Python dependencies
├── config.json.template              # API configuration template
├── zoho_desk_ticket_template.md      # Zoho Desk integration guide
└── zoho_projects_template.md         # Zoho Projects integration guide
```

## Support & Contacts

### For Off-boarding Questions
- **IT Manager:** [Contact Info]
- **HR:** [Contact Info]
- **Security Officer:** [Contact Info]

### For Technical Issues
- **Email:** support@midcloudcomputing.com
- **Phone:** +1-402-702-5000
- **Hours:** 24/7

## Continuous Improvement

This off-boarding system should be reviewed and updated:

- **After each off-boarding** - Document lessons learned
- **Quarterly** - Review process effectiveness
- **Annually** - Comprehensive process audit
- **When technology changes** - Update access revocation procedures

To suggest improvements:
1. Document the issue or opportunity
2. Propose the solution
3. Test in a mock off-boarding scenario
4. Update documentation
5. Train team on changes

## Version History

- **v1.0** (2025-11-25)
  - Initial release
  - Core off-boarding process
  - Helpdesk engineer specialization
  - Customer transition process
  - Semi-automated tooling
  - Zoho integration templates

## License & Confidentiality

**Internal Use Only**

This off-boarding system and all associated documentation are confidential and proprietary to Midwest Cloud Computing. Not for distribution outside the organization.

---

*Last Updated: 2025-11-25*
*System Owner: IT Management*
*For questions or feedback: it@midcloudcomputing.com*
