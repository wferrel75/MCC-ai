# IMMEDIATE OFFBOARDING CHECKLIST - S G
## Employee Information

**🔄 REPLACE THESE VALUES:**
- **Employee Name:** S G → **[REPLACE WITH FULL NAME]**
- **Employee Email:** S@midcloudcomputing.com → **[REPLACE WITH ACTUAL EMAIL]**
- **Employee ID:** [REPLACE WITH EMPLOYEE ID if available]
- **Role:** Administrative/Back Office
- **Departure Type:** IMMEDIATE TERMINATION
- **Last Working Day:** 2025-12-17 (TODAY)
- **Time Initiated:** [CURRENT TIME]

---

## ⚡ CRITICAL TIMELINE - IMMEDIATE TERMINATION

| Timeline | Action | Status |
|----------|--------|--------|
| **Hour 0** | Create tracking ticket, notify stakeholders | ☐ |
| **Hour 1** | Begin access revocation | ☐ |
| **Hour 2-4** | Complete Priority 1 access revocation | ☐ |
| **Hour 4-8** | Complete Priority 2 access revocation | ☐ |
| **Day 1** | Audit access, collect physical assets | ☐ |
| **Day 2** | Verify zero active sessions | ☐ |

---

## Phase 1: IMMEDIATE NOTIFICATIONS (Hour 0)

### Stakeholder Notification
**Send notifications to:**
- ☐ IT Manager - [INSERT EMAIL]
- ☐ Direct Manager - [INSERT EMAIL]
- ☐ HR - [INSERT EMAIL]
- ☐ Finance - [INSERT EMAIL]
- ☐ Security Officer - [INSERT EMAIL]

**Notification Template:**
```
Subject: URGENT - Employee Off-boarding Initiated - S G

Employee off-boarding has been initiated for S G (S@midcloudcomputing.com).

Departure Type: IMMEDIATE TERMINATION
Last Working Day: December 17, 2025 (TODAY)
Role: Administrative/Back Office

IMMEDIATE ACTIONS REQUIRED:
- IT: Access revocation must begin within 1 hour
- Manager: Identify any outstanding work items
- HR: Exit interview coordination
- Finance: Final payroll processing
- Security: Access audit within 24 hours

Zoho Desk Ticket: [INSERT TICKET NUMBER]

Time is critical. Please acknowledge receipt.
```

### Create Tracking Ticket
- ☐ Create Zoho Desk ticket using "Employee Off-boarding" template
- ☐ Priority: **HIGH** (Immediate Termination)
- ☐ Subject: `Employee Off-boarding - S G - IMMEDIATE`
- ☐ Assign to: IT Manager
- ☐ Attach this checklist

---

## Phase 2: ACCESS REVOCATION (Hours 1-4)

### PRIORITY 1 - Execute Immediately (Within 2 Hours)

#### Microsoft Identity & Authentication
- ☐ **Microsoft Entra ID (Azure AD)**
  - ☐ Disable user account (S@midcloudcomputing.com)
  - ☐ Revoke all active sessions
  - ☐ Remove from all security groups
  - ☐ Revoke all MFA methods
  - ☐ Remove from conditional access policies
  - ☐ Revoke app registrations (if any)
  - **Portal:** https://entra.microsoft.com
  - **Time Completed:** ___________

#### Microsoft 365 Services
- ☐ **Exchange Online**
  - ☐ Set auto-reply: "This employee is no longer with MCC. Please contact support@midcloudcomputing.com or +1-402-702-5000"
  - ☐ Hide from Global Address List
  - ☐ Remove from all distribution lists
  - ☐ Convert to shared mailbox (for retention)
  - ☐ Grant manager access (if approved by HR)
  - **Portal:** https://admin.microsoft.com
  - **Time Completed:** ___________

- ☐ **SharePoint/OneDrive**
  - ☐ Backup critical documents to [SPECIFY LOCATION]
  - ☐ Transfer ownership to manager: [INSERT MANAGER EMAIL]
  - ☐ Grant manager access for 30 days
  - **Time Completed:** ___________

- ☐ **Microsoft Teams**
  - ☐ Remove from all teams
  - ☐ Transfer team ownership (if owner of any teams)
  - ☐ Archive private chat history (if required by policy)
  - **Time Completed:** ___________

#### Security Tools - Priority Access
- ☐ **RocketCyber (Kaseya MDR)**
  - ☐ Remove user account
  - ☐ Revoke SOC portal access
  - **Portal:** [INSERT ROCKETCYBER PORTAL URL]
  - **Time Completed:** ___________

- ☐ **Keeper Security**
  - ☐ Transfer shared vault ownership to: [INSERT MANAGER EMAIL]
  - ☐ Document transferred credentials
  - ☐ Revoke user account
  - **Portal:** https://keepersecurity.com
  - **Time Completed:** ___________

#### RMM & PSA Tools
- ☐ **Datto RMM**
  - ☐ Revoke account access
  - ☐ Remove from technician groups
  - ☐ Revoke remote access capabilities
  - **Portal:** [INSERT DATTO RMM URL]
  - **Time Completed:** ___________

- ☐ **Zoho Desk**
  - ☐ Reassign any active tickets (see below)
  - ☐ Disable user account
  - ☐ Archive user history
  - **Portal:** https://desk.zoho.com
  - **Time Completed:** ___________

- ☐ **Zoho Projects**
  - ☐ Reassign any active tasks (see below)
  - ☐ Transfer project ownership (if any)
  - ☐ Disable user account
  - **Portal:** https://projects.zoho.com
  - **Time Completed:** ___________

#### VPN & Remote Access
- ☐ **All VPN Access**
  - ☐ Company VPN
  - ☐ Customer VPNs (audit list below)
  - **Time Completed:** ___________

---

### PRIORITY 2 - Complete Within 24 Hours

#### Additional Security Tools
- ☐ **ConnectSecure**
  - ☐ Remove user access
  - ☐ Revoke API keys (if generated)
  - **Portal:** [INSERT CONNECTSECURE URL]

- ☐ **KnowBe4**
  - ☐ Remove from training campaigns
  - ☐ Archive user data
  - **Portal:** https://training.knowbe4.com

#### Network & Infrastructure Access
- ☐ **Cisco Meraki Dashboard**
  - ☐ Remove user account
  - ☐ Revoke network access
  - **Portal:** https://dashboard.meraki.com

- ☐ **Azure Portal** (if applicable)
  - ☐ Remove from subscriptions
  - ☐ Revoke RBAC roles
  - ☐ Delete custom roles if employee-specific
  - **Portal:** https://portal.azure.com

- ☐ **AWS Console** (if applicable)
  - ☐ Remove IAM user
  - ☐ Revoke access keys
  - ☐ Remove from groups
  - **Portal:** https://console.aws.amazon.com

#### Backup & Documentation
- ☐ **Acronis Cyber Protect** (if applicable)
  - ☐ Remove user account
  - ☐ Transfer backup job ownership (if any)

- ☐ **Microsoft OneNote**
  - ☐ Transfer notebook ownership to: [INSERT MANAGER EMAIL]
  - ☐ Ensure knowledge transfer completion

---

## Phase 3: WORK ITEM HANDOFF

### Active Tickets (Zoho Desk)
**Action Required:**
1. Query Zoho Desk for all tickets assigned to S@midcloudcomputing.com
2. Categorize by priority
3. Reassign with notes

**Run this query:**
```bash
cd /home/wferrel/ai/employee_management
python offboarding_automation.py --tickets S@midcloudcomputing.com
```

**Ticket Reassignment:**
- ☐ Critical/High Priority tickets → Reassign to: [INSERT NAME]
- ☐ Medium Priority tickets → Reassign to: [INSERT NAME]
- ☐ Low Priority tickets → Reassign to: [INSERT NAME]

**Add this note to each ticket:**
```
This ticket has been reassigned due to staff transition. Your new contact is [NAME] at [EMAIL]. We apologize for any inconvenience.
```

### Active Projects (Zoho Projects)
**Action Required:**
1. Query Zoho Projects for all tasks assigned to S@midcloudcomputing.com
2. Identify critical tasks
3. Reassign with context

**Run this query:**
```bash
cd /home/wferrel/ai/employee_management
python offboarding_automation.py --projects S@midcloudcomputing.com
```

**Task Reassignment:**
- ☐ Critical tasks → Reassign to: [INSERT NAME]
- ☐ Standard tasks → Reassign to: [INSERT NAME]

### Outstanding Work Items
**Manager to complete:**
- ☐ List any ongoing projects: ___________________________
- ☐ List recurring responsibilities: ___________________________
- ☐ Document any critical knowledge: ___________________________
- ☐ Identify handoff person: ___________________________

---

## Phase 4: PHYSICAL ASSETS (Day 1)

### Company-Issued Equipment
- ☐ Laptop/Workstation
  - Model: _______________
  - Serial: _______________
  - Location: _______________
  - Condition: _______________

- ☐ Mobile Device(s)
  - Device: _______________
  - Phone Number: _______________
  - Location: _______________

- ☐ Hardware Tokens/Security Keys
  - Type: _______________
  - Serial: _______________

- ☐ Building Access Cards/Keys
  - Card/Key ID: _______________
  - Access Level: _______________

- ☐ Company Credit Cards
  - Last 4 digits: _______________
  - Status: ☐ Cancelled ☐ Returned

- ☐ Other Equipment: _______________

### Asset Recovery Process
- ☐ Schedule return meeting (if applicable)
- ☐ Perform factory reset on devices (IT supervised)
- ☐ Update asset management system
- ☐ Document asset condition

---

## Phase 5: VERIFICATION & AUDIT (Day 1-2)

### Access Audit
**Within 24 hours of access revocation:**

- ☐ **Microsoft 365 Audit**
  - ☐ Verify account disabled
  - ☐ Verify zero active sessions
  - ☐ Verify licenses revoked
  - ☐ Check login audit logs

- ☐ **Security Tools Audit**
  - ☐ RocketCyber - No active access
  - ☐ ConnectSecure - No active access
  - ☐ Keeper - Account removed

- ☐ **RMM/PSA Audit**
  - ☐ Datto RMM - No active sessions
  - ☐ Zoho Desk - Account disabled
  - ☐ Zoho Projects - Account disabled

- ☐ **VPN Audit**
  - ☐ Company VPN - No active sessions
  - ☐ Customer VPNs - All revoked

- ☐ **Network Audit**
  - ☐ No active WiFi connections
  - ☐ No active VPN connections
  - ☐ No remote desktop sessions

### Verification Checklist
**Before proceeding to closure:**
- ☐ All Priority 1 access revoked and verified
- ☐ All Priority 2 access revoked and verified
- ☐ All active sessions terminated
- ☐ All tickets reassigned
- ☐ All projects transferred
- ☐ All physical assets returned
- ☐ Asset inventory updated
- ☐ No outstanding security concerns

---

## Phase 6: HR & EXIT PROCESS

### HR Coordination
- ☐ Exit interview scheduled (if applicable)
- ☐ Final paycheck coordination with Finance
- ☐ Benefits termination notification
- ☐ Return of confidentiality agreements reviewed
- ☐ Return of company property receipt signed

### Documentation
- ☐ Archive employee documentation to: [SPECIFY LOCATION]
- ☐ Update organizational charts
- ☐ Remove from internal contact lists
- ☐ Update email signatures/contact pages (if listed)

---

## Phase 7: CLOSURE (Day 7)

### Final Verification
- ☐ Run comprehensive access audit (Day 7)
- ☐ Confirm all assets returned
- ☐ Verify no outstanding work items
- ☐ Manager sign-off on completion
- ☐ HR sign-off on exit process

### Close Tracking Ticket
- ☐ Update Zoho Desk ticket with completion summary
- ☐ Attach all documentation
- ☐ Change status to "Resolved"
- ☐ Add final notes

### Lessons Learned
**Document for process improvement:**
- What went well: ___________________________
- What could be improved: ___________________________
- Security gaps identified: ___________________________
- Knowledge gaps exposed: ___________________________

---

## CUSTOMER IMPACT ASSESSMENT

### Customer-Facing Responsibilities
**Manager to complete:**

Since this is an **Administrative/Back Office** role, customer impact should be minimal. However, verify:

- ☐ Did S G have any direct customer contact? YES / NO
- ☐ Did S G manage any customer accounts? YES / NO
- ☐ Did S G have access to customer environments? YES / NO
- ☐ Were any customers dependent on S G's work? YES / NO

**If YES to any above, list customers and transition plan:**
1. Customer: _______________ → New Contact: _______________
2. Customer: _______________ → New Contact: _______________
3. Customer: _______________ → New Contact: _______________

---

## EMERGENCY CONTACTS

| Role | Contact |
|------|---------|
| IT Manager | [INSERT PHONE/EMAIL] |
| HR | [INSERT PHONE/EMAIL] |
| Security Officer | [INSERT PHONE/EMAIL] |
| Direct Manager | [INSERT PHONE/EMAIL] |
| Support Line | +1-402-702-5000 |
| Support Email | support@midcloudcomputing.com |

---

## AUTOMATION COMMANDS

### Generate Reports
```bash
cd /home/wferrel/ai/employee_management

# Full off-boarding report
python offboarding_automation.py \
  --employee [EMPLOYEE_ID] \
  --name "S G" \
  --email S@midcloudcomputing.com \
  --role admin

# Access checklist only
python offboarding_automation.py \
  --generate-checklist [EMPLOYEE_ID] \
  --name "S G"

# Tickets only
python offboarding_automation.py --tickets S@midcloudcomputing.com

# Projects only
python offboarding_automation.py --projects S@midcloudcomputing.com
```

**🔄 REMEMBER TO REPLACE:**
- `S G` with actual full name
- `S@midcloudcomputing.com` with actual email
- `[EMPLOYEE_ID]` with actual employee ID

---

## SIGN-OFF

### Completion Signatures

**IT Manager:**
- Name: _______________
- Signature: _______________
- Date: _______________
- Access revocation verified: YES / NO

**Direct Manager:**
- Name: _______________
- Signature: _______________
- Date: _______________
- Work items transferred: YES / NO

**HR:**
- Name: _______________
- Signature: _______________
- Date: _______________
- Exit process completed: YES / NO

**Security Officer:**
- Name: _______________
- Signature: _______________
- Date: _______________
- Access audit completed: YES / NO

---

## NOTES & ADDITIONAL INFORMATION

[Space for additional notes, special circumstances, or important information]

---

*Generated: 2025-12-17*
*Employee: S G (S@midcloudcomputing.com)*
*Process: IMMEDIATE TERMINATION - Administrative/Back Office*
*Timeline: 0-4 hours for critical access revocation*
