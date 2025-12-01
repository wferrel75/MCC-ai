# Employee Off-boarding Process - MCC

## Overview

This document outlines the off-boarding process for Midwest Cloud Computing employees. The process is designed to handle both planned departures (resignation with notice) and immediate departures (termination), ensuring continuity of service, security, and customer satisfaction.

## Process Types

### Immediate Off-boarding (Termination)
- Timeline: Same day
- Priority: Security and access revocation
- Customer notification: Within 24 hours

### Planned Off-boarding (Resignation)
- Timeline: 1-4 weeks based on notice given
- Priority: Knowledge transfer and smooth transition
- Customer notification: Coordinated with transition plan

---

## Core Off-boarding Process (All Employees)

### Phase 1: Initiation (Day 0)

**Triggered by:** HR notification of departure

**Actions:**
1. **Create Off-boarding Ticket** in Zoho Desk
   - Priority: High (termination) or Medium (resignation)
   - Assign to: IT Manager
   - Include: Employee name, role, departure date, departure type, last day

2. **Notify Stakeholders**
   - IT Manager
   - Direct Manager
   - HR
   - Finance (for final pay coordination)

3. **Generate Access Revocation Checklist**
   - Run `offboarding_automation.py --generate-checklist <employee_id>`
   - Review all systems employee has access to

### Phase 2: Access Management

**Timeline:**
- Immediate departure: Within 2 hours
- Planned departure: On last day at EOD

**MCC Technology Stack - Access Points:**

#### Identity & Authentication
- [ ] **Microsoft Entra ID (Azure AD)**
  - Disable user account
  - Revoke all app registrations
  - Remove from all security groups
  - Revoke MFA methods
  - Remove from conditional access policies
  - Archive mailbox (convert to shared if needed)

#### Microsoft 365 Services
- [ ] **Exchange Online**
  - Set auto-reply with transition contact
  - Forward email to manager (if approved)
  - Convert to shared mailbox (retention: 90 days minimum)
- [ ] **SharePoint/OneDrive**
  - Transfer ownership of files to manager
  - Backup critical documents
  - Grant manager access for 30 days
- [ ] **Microsoft Teams**
  - Transfer team ownership
  - Archive private chat history (if required)
  - Remove from all teams

#### Security Tools
- [ ] **RocketCyber (Kaseya MDR)**
  - Remove user account
  - Revoke SOC portal access
- [ ] **ConnectSecure**
  - Remove user access
  - Revoke API keys if generated
- [ ] **Keeper Security**
  - Transfer shared vault ownership
  - Revoke user account
  - Document transferred credentials
- [ ] **KnowBe4**
  - Remove from training campaigns
  - Archive user data

#### RMM & PSA Tools
- [ ] **Datto RMM**
  - Revoke account access
  - Remove from technician groups
  - Transfer device monitoring ownership
  - Revoke remote access capabilities
- [ ] **Zoho Desk**
  - Reassign active tickets (see role-specific process)
  - Disable user account
  - Archive user history
- [ ] **Zoho Projects**
  - Reassign active tasks
  - Transfer project ownership
  - Update project contact lists

#### Network & Infrastructure Access
- [ ] **Cisco Meraki Dashboard**
  - Remove user account
  - Revoke network access
- [ ] **Ubiquiti UniFi Controller**
  - Remove admin credentials
- [ ] **Fortinet FortiGate**
  - Remove VPN access
  - Revoke admin credentials
- [ ] **Azure Portal**
  - Remove from subscriptions
  - Revoke RBAC roles
  - Delete custom roles if employee-specific
- [ ] **AWS Console** (if applicable)
  - Remove IAM user
  - Revoke access keys
  - Remove from groups

#### Backup & DR
- [ ] **Acronis Cyber Protect**
  - Remove user account
  - Transfer backup job ownership

#### Documentation
- [ ] **Microsoft OneNote**
  - Transfer notebook ownership
  - Ensure knowledge transfer completion

#### Client Environment Access
- [ ] **Customer VPNs** - Audit and revoke
- [ ] **Customer Admin Portals** - Document and transfer
- [ ] **Customer Domain Admin** - Reset shared credentials
- [ ] **Customer Cloud Tenants** - Remove guest access

### Phase 3: Physical Assets

**Timeline:** Before or on last day

- [ ] Laptop/workstation
- [ ] Mobile device(s)
- [ ] Hardware tokens/security keys
- [ ] Building access cards/keys
- [ ] Company credit cards
- [ ] Any client-loaned equipment

**Asset Recovery Process:**
1. Schedule return meeting
2. Perform factory reset (IT supervised)
3. Update asset management system
4. Document asset condition

### Phase 4: Knowledge Transfer

**Timeline:** Throughout notice period (or document post-departure)

- [ ] Document all active projects
- [ ] Document recurring tasks and responsibilities
- [ ] Transfer tribal knowledge via OneNote
- [ ] Complete knowledge transfer checklist
- [ ] Identify process gaps exposed by departure

### Phase 5: Exit Process

- [ ] Conduct exit interview (HR)
- [ ] Collect feedback on processes and tools
- [ ] Final payroll coordination (Finance)
- [ ] Benefits termination coordination (HR)
- [ ] Return of confidentiality agreements review

### Phase 6: Post-Departure

**Timeline:** Within 7 days of departure

- [ ] Verify all access revoked (run audit script)
- [ ] Confirm all assets returned
- [ ] Close off-boarding ticket in Zoho Desk
- [ ] Archive employee documentation
- [ ] Update organizational charts
- [ ] Review and improve off-boarding process

---

## Role-Specific: Helpdesk Engineer Off-boarding

### Additional Responsibilities to Transfer

Helpdesk Engineers have three primary areas requiring special attention:
1. Active ticket ownership
2. Project task assignments
3. Customer primary contact/SME relationships

### Ticket Reassignment Process

**Timeline:**
- Immediate departure: Reassign within 4 hours
- Planned departure: Reassign 1 week before last day

**Steps:**

1. **Generate Ticket Report**
   ```bash
   python offboarding_automation.py --role helpdesk --tickets <employee_id>
   ```
   This generates:
   - All open tickets assigned to employee
   - Ticket priority and age
   - Customer impact assessment
   - Suggested reassignment based on expertise

2. **Ticket Triage**
   - **Critical/High Priority:** Reassign immediately
   - **Medium Priority:** Reassign with knowledge transfer notes
   - **Low Priority:** Batch reassign to team lead for distribution

3. **Reassignment Execution**
   - Use Zoho Desk bulk reassignment
   - Add note to each ticket: "Reassigned due to staff transition. Your new contact is [Name]."
   - Update customer-facing ticket comments

4. **Customer Notification**
   - For customers with 3+ tickets: Personal email from manager
   - For all others: Ticket comment notification

### Project Task Handoff

**Timeline:** Throughout notice period

**Steps:**

1. **Generate Project Report**
   ```bash
   python offboarding_automation.py --role helpdesk --projects <employee_id>
   ```

2. **Project Task Review Meeting**
   - Schedule with manager and receiving engineer(s)
   - Review all active projects
   - Identify knowledge gaps
   - Document tribal knowledge

3. **Task Reassignment in Zoho Projects**
   - Update task assignments
   - Add transition notes to each task
   - Update project timelines if needed
   - Notify project stakeholders

4. **Documentation Update**
   - Update project OneNote with status
   - Document any blockers or dependencies
   - Record customer preferences/context

### Customer Primary Contact/SME Transition

**This is the most critical component for helpdesk engineers**

**Timeline:**
- Immediate departure: Begin transition within 24 hours
- Planned departure: Begin transition 2 weeks before last day

**Steps:**

1. **Identify Customer Assignments**
   ```bash
   python offboarding_automation.py --role helpdesk --customers <employee_id>
   ```

   Output includes:
   - List of customers where employee is primary contact
   - Customer tier/priority level
   - Last interaction date
   - Active tickets/projects for each customer
   - Relationship duration

2. **Assess Reassignment**

   Consider:
   - Current technician workloads
   - Customer preferences
   - Technical expertise match
   - Geographic considerations (if applicable)
   - Existing relationships

3. **Create Transition Plan**

   For each customer:
   - [ ] Assign new primary contact
   - [ ] Schedule knowledge transfer meeting
   - [ ] Prepare customer context document
   - [ ] Plan customer introduction

4. **Knowledge Transfer Documentation**

   Create customer transition document including:
   - **Customer Profile**
     - Business overview
     - Key contacts and roles
     - Escalation preferences
     - Communication preferences
     - SLA requirements

   - **Technical Environment**
     - Network topology overview
     - Critical systems and applications
     - Recent changes/projects
     - Known issues and workarounds
     - Monitoring and alerting setup

   - **Relationship Context**
     - Customer temperament/communication style
     - Historical issues and resolutions
     - Special considerations
     - Ongoing initiatives

   - **Access Information**
     - VPN credentials location (Keeper)
     - Admin portal URLs
     - Emergency contacts
     - Vendor relationships

5. **Customer Introduction Process**

   **Option A: Planned Departure (Preferred)**
   - Departing engineer introduces new contact via email
   - Include transition timeline
   - Offer transition call if customer desires
   - New engineer shadows on next customer interaction

   **Option B: Immediate Departure**
   - Manager sends introduction email within 24 hours
   - New engineer proactively reaches out
   - Expedited knowledge transfer from documentation
   - Manager available for escalation during transition

6. **Customer Introduction Email Template**
   ```
   Subject: Your MCC Support Team - Introduction to [New Engineer Name]

   Dear [Customer Name],

   I wanted to personally introduce you to [New Engineer Name], who will be
   your primary technical contact at Midwest Cloud Computing going forward.

   [New Engineer Name] brings [X years] of experience in [relevant expertise]
   and has been fully briefed on your environment and ongoing projects.

   [IF PLANNED: I'll be working closely with [New Engineer] over the next
   [timeframe] to ensure a seamless transition.]

   [New Engineer] can be reached at:
   - Email: [email]
   - Phone: [phone]
   - Teams: [teams handle]

   As always, our entire team remains available for support 24/7 at
   support@midcloudcomputing.com or +1-402-702-5000.

   Thank you for your continued partnership with MCC.

   [Departing Engineer Name] / [New Engineer Name]
   ```

7. **Monitor Transition Success**

   **Week 1-2 Post-Transition:**
   - [ ] New engineer shadows first customer interaction
   - [ ] Manager monitors all customer tickets
   - [ ] Quick check-in with customer

   **Week 3-4 Post-Transition:**
   - [ ] Review customer satisfaction
   - [ ] Address any transition issues
   - [ ] Document lessons learned

8. **Update CRM/Documentation**
   - [ ] Update customer records in Zoho
   - [ ] Update primary contact in RMM
   - [ ] Update customer OneNote
   - [ ] Update internal contact lists
   - [ ] Update on-call rotation (if applicable)

### Helpdesk Engineer Off-boarding Checklist Summary

**Pre-Departure (Immediate or Notice Period):**
- [ ] Generate complete impact report (tickets, projects, customers)
- [ ] Create reassignment plan
- [ ] Begin knowledge transfer documentation
- [ ] Schedule transition meetings

**Knowledge Transfer Phase:**
- [ ] Conduct ticket review and reassignment
- [ ] Complete project handoff meetings
- [ ] Create customer transition documents
- [ ] Train receiving engineers on customer specifics

**Customer Transition Phase:**
- [ ] Assign new primary contacts
- [ ] Send customer introduction emails
- [ ] Complete first shadowed interaction
- [ ] Update all systems with new assignments

**Completion Phase:**
- [ ] Verify all tickets reassigned
- [ ] Verify all projects transferred
- [ ] Verify all customers transitioned
- [ ] Monitor transition success (first 30 days)

---

## Automation and Tools

### Off-boarding Automation Script

Location: `offboarding_automation.py`

**Key Functions:**
- Generate comprehensive access revocation checklist
- Query Zoho Desk for assigned tickets
- Query Zoho Projects for active tasks
- Generate customer assignment report
- Suggest reassignments based on workload
- Generate customer transition documentation templates

**Usage Examples:**
```bash
# Generate full off-boarding report
python offboarding_automation.py --employee <employee_id> --role helpdesk

# Generate access revocation checklist
python offboarding_automation.py --generate-checklist <employee_id>

# Get ticket reassignment plan
python offboarding_automation.py --tickets <employee_id> --suggest-reassignment

# Get customer transition report
python offboarding_automation.py --customers <employee_id> --export-docs
```

### Integration Points

**Zoho Desk API:**
- Ticket reassignment
- Ticket reporting
- Customer contact updates

**Zoho Projects API:**
- Task reassignment
- Project ownership transfer
- Project reporting

**Microsoft Graph API:**
- User account management
- Mailbox conversion
- License revocation
- OneDrive transfer

**Datto RMM API:**
- User account management
- Device monitoring transfer

---

## Quality Assurance

### Off-boarding Audit Checklist

**Within 48 hours of departure:**
- [ ] Run access audit script
- [ ] Verify zero active sessions
- [ ] Confirm all tickets reassigned
- [ ] Confirm all projects transferred
- [ ] Confirm all customers notified
- [ ] Confirm all assets returned

### Success Metrics

- **Security:** No active access after last day
- **Customer Impact:** Zero customer complaints about transition
- **Business Continuity:** No dropped tickets or missed SLAs
- **Knowledge Retention:** All critical information documented

---

## Continuous Improvement

After each off-boarding, review:
- What went well?
- What could be improved?
- Were there any security gaps?
- Was customer impact minimized?
- What knowledge was lost?
- How can documentation be improved?

Update this process document quarterly or after significant learnings.

---

## Emergency Contacts

**For off-boarding questions:**
- IT Manager: [contact info]
- HR: [contact info]
- Security Officer: [contact info]

**For technical issues during off-boarding:**
- Support: support@midcloudcomputing.com
- Phone: +1-402-702-5000

---

*Last Updated: 2025-11-25*
*Process Owner: IT Management*
*Review Cycle: Quarterly*
