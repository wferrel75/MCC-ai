# n8n Workflows for MCC Employee Off-boarding

This directory contains n8n workflow automation files that integrate with the MCC employee off-boarding system.

## Overview

The n8n workflows automate key portions of the off-boarding process:

1. **Initiation Workflow** - Orchestrates the entire off-boarding process
2. **Access Revocation Workflow** - Automates Microsoft 365/Entra ID access revocation
3. **Ticket Reassignment Workflow** - Handles Zoho Desk ticket redistribution
4. **Customer Transition Workflow** - Manages customer primary contact transitions
5. **Monitoring & Audit Workflow** - Provides ongoing validation and compliance checks

## Workflow Files

| File | Purpose | Trigger Type |
|------|---------|--------------|
| `01_offboarding_initiation_workflow.json` | Main orchestration workflow | Webhook (Manual/API) |
| `02_access_revocation_workflow.json` | Microsoft 365 & system access revocation | Webhook (Called by #1) |
| `03_ticket_reassignment_workflow.json` | Zoho Desk ticket reassignment | Webhook (Called by #1) |
| `04_customer_transition_workflow.json` | Customer primary contact transitions | Webhook (Called by #1) |
| `05_monitoring_audit_workflow.json` | Daily monitoring and compliance audits | Schedule (Daily) |

## Prerequisites

### Required n8n Nodes/Integrations

1. **Microsoft Graph API**
   - For Entra ID (Azure AD) and Microsoft 365 operations
   - Requires OAuth2 credentials with admin consent
   - Required permissions:
     - `User.ReadWrite.All`
     - `Directory.ReadWrite.All`
     - `Mail.ReadWrite`
     - `Group.ReadWrite.All`

2. **Zoho Desk API**
   - For ticket management
   - Requires OAuth2 credentials
   - Needs organization ID and appropriate permissions

3. **Zoho Projects API**
   - For project/task management
   - Requires OAuth2 credentials
   - Needs portal ID

4. **PostgreSQL Database** (or compatible)
   - For tracking off-boarding status
   - Stores workload data, customer assignments, audit logs

5. **SMTP Email**
   - For sending notifications
   - MCC Office 365 SMTP recommended

6. **Execute Command Node**
   - For running Python automation scripts
   - Requires n8n to have access to filesystem

### Database Schema

Before importing workflows, create these database tables:

```sql
-- Off-boarding tracking table
CREATE TABLE offboarding_tracking (
    offboarding_id VARCHAR(50) PRIMARY KEY,
    employee_id VARCHAR(50) NOT NULL,
    employee_name VARCHAR(255) NOT NULL,
    employee_email VARCHAR(255) NOT NULL,
    role VARCHAR(100),
    departure_date DATE,
    departure_type VARCHAR(50),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    zoho_ticket_id VARCHAR(50),
    zoho_project_id VARCHAR(50)
);

-- Technician workload tracking
CREATE TABLE technician_workload (
    user_id VARCHAR(50) PRIMARY KEY,
    user_name VARCHAR(255),
    user_email VARCHAR(255),
    role VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    customer_count INT DEFAULT 0,
    ticket_count INT DEFAULT 0,
    specialties TEXT,
    avg_customer_satisfaction DECIMAL(3,2)
);

-- Customer database
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(255),
    customer_email VARCHAR(255),
    tier VARCHAR(50),
    primary_contact_id VARCHAR(50),
    primary_contact_name VARCHAR(255),
    primary_contact_email VARCHAR(255),
    technical_notes TEXT,
    communication_preferences TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transition_date TIMESTAMP
);

-- Audit log table
CREATE TABLE offboarding_audit_log (
    audit_id SERIAL PRIMARY KEY,
    offboarding_id VARCHAR(50),
    audit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    issues TEXT,
    warnings TEXT,
    checks_json TEXT,
    FOREIGN KEY (offboarding_id) REFERENCES offboarding_tracking(offboarding_id)
);

-- Ticket tracking (can also sync from Zoho Desk)
CREATE TABLE tickets (
    ticket_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    assignee_email VARCHAR(255),
    status VARCHAR(50),
    priority VARCHAR(50),
    created_at TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Project tracking (can also sync from Zoho Projects)
CREATE TABLE projects (
    project_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    project_name VARCHAR(255),
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

## Installation

### Step 1: Import Workflows

1. Open your n8n instance
2. Navigate to **Workflows**
3. Click **Import from File**
4. Import each JSON file in order (01 through 05)

### Step 2: Configure Credentials

For each workflow, configure the following credentials:

#### Microsoft Graph API OAuth2
1. Go to Azure Portal > App Registrations
2. Create new app registration: "n8n MCC Off-boarding"
3. Add redirect URI: `https://your-n8n-instance/rest/oauth2-credential/callback`
4. Grant admin consent for required permissions (listed above)
5. Create client secret
6. In n8n, add Microsoft Graph API OAuth2 credential:
   - Client ID: [from Azure]
   - Client Secret: [from Azure]
   - Tenant ID: [your Azure tenant ID]

#### Zoho Desk OAuth2
1. Go to Zoho Desk > Setup > API > OAuth
2. Register OAuth client
3. Get Organization ID from Setup > Developer Space
4. In n8n, add Zoho OAuth2 credential with Desk scope

#### Zoho Projects OAuth2
1. Go to Zoho Projects > Settings > API
2. Register OAuth client
3. Get Portal ID from URL or Settings
4. In n8n, add Zoho OAuth2 credential with Projects scope

#### PostgreSQL
1. Create database user for n8n with appropriate permissions
2. In n8n, add PostgreSQL credential:
   - Host: [your database host]
   - Database: [database name]
   - User: [database user]
   - Password: [database password]

#### SMTP (Office 365)
1. In n8n, add Email (SMTP) credential:
   - Host: `smtp.office365.com`
   - Port: `587`
   - User: [MCC IT email]
   - Password: [app password or OAuth]
   - From Email: [MCC IT email]

### Step 3: Configure Environment Variables

In n8n, set these environment variables (Settings > Environment Variables):

```bash
# Zoho Configuration
ZOHO_DESK_ORG_ID=your_org_id
ZOHO_DESK_IT_DEPT_ID=your_dept_id
ZOHO_DESK_IT_MANAGER_ID=your_manager_id
ZOHO_PROJECTS_PORTAL_ID=your_portal_id
ZOHO_PROJECTS_IT_MANAGER_ID=your_manager_id

# MCC Email Configuration
MCC_IT_EMAIL=it@midcloudcomputing.com
MCC_IT_MANAGER_EMAIL=manager@midcloudcomputing.com
MCC_HR_EMAIL=hr@midcloudcomputing.com

# Datto RMM Configuration
DATTO_RMM_API_URL=https://pinotage-api.centrastage.net
DATTO_RMM_API_KEY=your_api_key
DATTO_RMM_API_SECRET=your_api_secret

# Workflow IDs (get these after importing workflows)
ACCESS_REVOCATION_WORKFLOW_ID=get_from_n8n_after_import
TICKET_REASSIGNMENT_WORKFLOW_ID=get_from_n8n_after_import
CUSTOMER_TRANSITION_WORKFLOW_ID=get_from_n8n_after_import
ERROR_WORKFLOW_ID=get_from_n8n_if_you_create_error_handler
```

### Step 4: Update Workflow IDs

After importing workflows 2-4:
1. Open each workflow in n8n
2. Copy the workflow ID from the URL
3. Update the environment variables above
4. Re-import workflow #1 (Initiation) to use the updated IDs

### Step 5: Activate Workflows

1. Open each workflow
2. Click **Activate** toggle in top right
3. Verify webhook URLs are generated for workflows 1-4
4. Verify schedule is set correctly for workflow 5 (daily at midnight recommended)

## Usage

### Triggering an Off-boarding

#### Option 1: Via n8n Interface (Manual)

1. Open **01_offboarding_initiation_workflow**
2. Click **Test Workflow** or **Execute Workflow**
3. Provide test data in webhook body:

```json
{
  "employee_id": "E12345",
  "employee_name": "John Doe",
  "employee_email": "john.doe@midcloudcomputing.com",
  "role": "helpdesk",
  "departure_type": "Resignation",
  "last_working_day": "2025-12-15",
  "manager_name": "Jane Smith",
  "manager_email": "jane.smith@midcloudcomputing.com"
}
```

#### Option 2: Via Webhook/API

```bash
curl -X POST https://your-n8n-instance/webhook/offboarding-initiate \
  -H "Content-Type: application/json" \
  -d '{
    "employee_id": "E12345",
    "employee_name": "John Doe",
    "employee_email": "john.doe@midcloudcomputing.com",
    "role": "helpdesk",
    "departure_type": "Termination",
    "last_working_day": "2025-11-25",
    "manager_name": "Jane Smith",
    "manager_email": "jane.smith@midcloudcomputing.com"
  }'
```

#### Option 3: Via Python Script

```bash
python offboarding_automation.py \
  --employee E12345 \
  --name "John Doe" \
  --email john.doe@midcloudcomputing.com \
  --role helpdesk \
  --trigger-n8n
```

(Note: You'll need to modify the Python script to add n8n webhook triggering)

### Monitoring Progress

1. **n8n Dashboard**
   - View **Executions** to see workflow runs
   - Check for errors or failed nodes
   - Review execution data

2. **Email Notifications**
   - IT Manager receives notifications at each major step
   - Critical issues trigger immediate alerts
   - Daily summary reports from monitoring workflow

3. **Zoho Desk Ticket**
   - Comments added automatically as workflows progress
   - Tracks overall status
   - Provides audit trail

4. **Database**
   - Query `offboarding_tracking` table for current status
   - Review `offboarding_audit_log` for daily audit results

## Workflow Details

### 1. Offboarding Initiation Workflow

**Trigger:** Webhook (POST)

**Process Flow:**
1. Receives employee data via webhook
2. Determines if employee is helpdesk engineer
3. Runs Python automation script to generate reports
4. Creates Zoho Desk ticket for tracking
5. Creates Zoho Projects project for task management
6. Sends notifications to IT Manager and HR
7. If immediate termination, triggers access revocation immediately
8. Triggers ticket reassignment workflow
9. If helpdesk role, triggers customer transition workflow

**Expected Runtime:** 2-5 minutes

**Outputs:**
- Zoho Desk ticket ID
- Zoho Projects project ID
- List of triggered sub-workflows

### 2. Access Revocation Workflow

**Trigger:** Called by Workflow #1 or manual webhook

**Process Flow:**
1. Retrieves user from Entra ID
2. Disables user account
3. Revokes all active sessions
4. Removes from all security groups
5. Revokes all M365 licenses
6. Sets out-of-office auto-reply
7. Revokes Datto RMM access (if applicable)
8. Compiles automated and manual steps
9. Updates Zoho Desk ticket with results
10. Sends notification to IT Manager

**Expected Runtime:** 3-7 minutes

**Automated Actions:**
- ✅ Entra ID account disabled
- ✅ Active sessions revoked
- ✅ Security groups removed
- ✅ M365 licenses revoked
- ✅ Auto-reply configured
- ✅ Datto RMM access revoked

**Manual Actions Required:**
- Zoho Desk/Projects account disable
- RocketCyber, ConnectSecure, Keeper access
- Network infrastructure (Meraki, UniFi, Fortinet)
- Cloud platforms (Azure, AWS)
- Customer VPN/portal access

### 3. Ticket Reassignment Workflow

**Trigger:** Called by Workflow #1 or manual webhook

**Process Flow:**
1. Queries all open tickets assigned to departing employee
2. Analyzes ticket distribution (by priority, customer)
3. Retrieves current team workload
4. Determines reassignment strategy (urgent vs planned)
5. For each ticket:
   - Reassigns in Zoho Desk
   - Adds transition note
   - Notifies customer (if multiple tickets)
6. Updates off-boarding ticket with summary
7. Sends completion notification to IT Manager

**Expected Runtime:** 5-15 minutes (depends on ticket count)

**Reassignment Logic:**

**Urgent (Termination):**
- Fast distribution across available engineers
- High-priority tickets assigned first
- Round-robin allocation

**Planned (Resignation):**
- Groups tickets by customer
- Assigns all tickets from same customer to one engineer
- Maintains customer relationships
- Personal notifications for customers with 3+ tickets

### 4. Customer Transition Workflow

**Trigger:** Called by Workflow #1 (helpdesk role only) or manual webhook

**Process Flow:**
1. Queries all customers where employee is primary contact
2. Retrieves available helpdesk engineers and workload
3. Intelligently assigns customers to engineers:
   - Premium customers prioritized
   - Workload balanced
   - Specialties considered
4. For each customer:
   - Generates transition document (via Python script)
   - Sends introduction email (premium = personal, standard = automated)
   - Updates customer database
   - Updates Datto RMM primary technician
   - Logs transition
5. Compiles summary and updates off-boarding ticket
6. Notifies IT Manager and receiving engineers

**Expected Runtime:** 10-30 minutes (depends on customer count)

**Customer Prioritization:**
1. Premium tier customers first
2. Customers with active projects
3. Customers with multiple active tickets
4. Standard customers

**Introduction Methods:**
- **Premium/High-touch:** Personal email from departing engineer (if resignation) or IT Manager (if termination), includes transition document, may include follow-up call
- **Standard:** Automated email from MCC IT, brief introduction

### 5. Monitoring & Audit Workflow

**Trigger:** Schedule (runs daily)

**Process Flow:**
1. Queries all off-boarding processes in "in_progress" or "monitoring" status
2. For each off-boarding (up to 30 days post-departure):
   - Checks Entra ID account status (should be disabled/deleted)
   - Checks mailbox auto-reply (should be configured)
   - Checks for remaining ticket assignments (should be zero)
   - Checks for remaining customer assignments (should be zero)
   - Compiles audit results
   - Logs results to database
3. If critical issues found, sends immediate alert
4. If warnings found, sends warning notification
5. If 30-day monitoring complete with no issues:
   - Marks off-boarding as completed
   - Closes Zoho Desk ticket
   - Sends completion notification
6. Generates daily summary report for IT Manager

**Expected Runtime:** 5-10 minutes per day

**Audit Checks:**
- ✅ Entra ID account disabled or deleted
- ✅ M365 mailbox auto-reply configured
- ✅ Zero tickets assigned to user
- ✅ Zero customers assigned to user

**Alert Levels:**
- **Critical (🚨):** Access still active, tickets/customers still assigned
- **Warning (⚠️):** Minor issues like missing auto-reply
- **Passed (✅):** All checks successful

## Customization

### Adding Additional Access Points

To add more systems to access revocation workflow (#2):

1. Open workflow in n8n
2. Add new nodes after "Revoke Datto RMM Access"
3. Common patterns:
   - **API-based:** Use HTTP Request node
   - **Database-based:** Use PostgreSQL/MySQL node
   - **Email-based:** Send notification for manual action
4. Update "Compile Revocation Results" node to include new system
5. Test thoroughly before activating

### Modifying Reassignment Logic

To change ticket/customer assignment algorithms:

1. Open workflow #3 or #4
2. Find "Code" nodes with assignment logic
3. Modify JavaScript functions
4. Test with sample data
5. Deploy changes

### Customizing Notifications

To modify email templates:

1. Open any workflow
2. Find "Email Send" nodes
3. Edit subject and HTML message
4. Use n8n expressions for dynamic content: `{{ $json.field_name }}`
5. Preview emails before activating

### Adjusting Monitoring Schedule

To change audit frequency:

1. Open workflow #5
2. Edit "Schedule Trigger" node
3. Options:
   - Daily (recommended)
   - Every 12 hours
   - Twice weekly
   - Custom cron expression

## Troubleshooting

### Common Issues

**Issue: Workflow fails with "User not found in Entra ID"**

*Solution:*
- Verify employee email is correct
- Check if user was already deleted
- Verify Microsoft Graph API permissions
- Check OAuth2 credential is valid

**Issue: Zoho Desk API errors**

*Solution:*
- Verify organization ID is correct
- Check OAuth2 token hasn't expired
- Ensure API limits aren't exceeded
- Verify user has appropriate Zoho permissions

**Issue: Database connection errors**

*Solution:*
- Verify PostgreSQL credentials
- Check network connectivity from n8n to database
- Ensure database tables exist (run schema creation)
- Check firewall rules

**Issue: Emails not sending**

*Solution:*
- Verify SMTP credentials
- Check if Office 365 requires app password
- Verify from email is authorized to send
- Check spam/quarantine settings

**Issue: Python script fails to execute**

*Solution:*
- Verify n8n has file system access
- Check Python script path is correct
- Ensure Python dependencies are installed
- Check script has execute permissions

### Debugging Workflows

1. **Use Test Mode**
   - Click "Test Workflow" in n8n
   - Provides sample data
   - Shows node-by-node execution

2. **Check Execution Logs**
   - View past executions in n8n
   - Inspect input/output of each node
   - Identify which node failed

3. **Enable Error Workflows**
   - Create separate error handling workflow
   - Set in workflow settings
   - Captures failed executions for analysis

4. **Add Debug Nodes**
   - Insert "No Operation" nodes to inspect data
   - Use "Set" nodes to log intermediate values

## Security Considerations

1. **Credential Storage**
   - All credentials encrypted in n8n
   - Use OAuth2 where possible
   - Rotate API keys regularly

2. **Access Control**
   - Limit n8n access to IT staff only
   - Use role-based access in n8n Enterprise
   - Audit workflow changes

3. **Data Protection**
   - Sensitive data in workflow executions
   - Configure execution data retention policy
   - Consider encrypting database

4. **Webhook Security**
   - Use authentication headers for webhooks
   - Consider IP whitelisting
   - Monitor for unauthorized access attempts

5. **Audit Trail**
   - All actions logged to database
   - Email notifications create paper trail
   - Zoho Desk comments provide history

## Performance Optimization

1. **Batch Processing**
   - Workflows use "Split in Batches" for large datasets
   - Prevents timeout on high ticket counts

2. **Parallel Execution**
   - Multiple API calls run in parallel where possible
   - Reduces overall workflow time

3. **Error Handling**
   - "Continue on Fail" for non-critical steps
   - Graceful degradation

4. **Caching**
   - Consider caching workload data
   - Reduces database queries

## Maintenance

### Weekly Tasks
- Review execution logs for failures
- Check email delivery success
- Verify credentials haven't expired

### Monthly Tasks
- Review audit logs for patterns
- Optimize slow workflows
- Update documentation if processes change
- Review and improve reassignment algorithms

### Quarterly Tasks
- Update n8n to latest version
- Review security settings
- Audit database performance
- Update API credentials

---

## Support

For workflow issues:
- **n8n Documentation:** https://docs.n8n.io
- **MCC IT Manager:** [contact info]
- **Workflow Files:** `/home/wferrel/employee_management/n8n_workflows/`

---

*Last Updated: 2025-11-25*
*Maintained by: MCC IT Department*
