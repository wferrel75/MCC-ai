# ZOHO DESK TICKET - Employee Off-boarding S G

## Ticket Details

**🔄 REPLACE THESE VALUES:**
- Employee Name: **S G** → [REPLACE WITH FULL NAME]
- Employee Email: **S@midcloudcomputing.com** → [REPLACE WITH ACTUAL EMAIL]
- Employee ID: [REPLACE WITH EMPLOYEE ID if available]

---

## CREATE NEW TICKET IN ZOHO DESK

### Basic Information
- **Ticket Subject:** `URGENT - Employee Off-boarding - S G - IMMEDIATE TERMINATION`
- **Category:** Internal - HR/Personnel
- **Sub-Category:** Employee Off-boarding
- **Priority:** **HIGH**
- **Status:** Open
- **Department:** IT
- **Assigned To:** IT Manager

### Custom Fields (if configured)
- **Employee Name:** S G
- **Employee Email:** S@midcloudcomputing.com
- **Employee ID:** [INSERT IF AVAILABLE]
- **Role:** Administrative/Back Office
- **Departure Type:** Immediate Termination
- **Last Working Day:** 2025-12-17
- **Off-boarding Initiated:** 2025-12-17 [INSERT TIME]

---

## Ticket Description

```
URGENT: Employee off-boarding process initiated for S G.

EMPLOYEE INFORMATION:
- Name: S G [REPLACE WITH FULL NAME]
- Email: S@midcloudcomputing.com [REPLACE WITH ACTUAL EMAIL]
- Employee ID: [INSERT IF AVAILABLE]
- Role: Administrative/Back Office
- Departure Type: IMMEDIATE TERMINATION
- Last Working Day: December 17, 2025 (TODAY)

CRITICAL ACTIONS REQUIRED:
This is an immediate termination. Access revocation must begin within 1 hour and be completed within 4 hours.

TIMELINE:
- Hour 0-1: Notify stakeholders, begin access revocation
- Hour 1-4: Complete Priority 1 access revocation
- Hour 4-24: Complete Priority 2 access revocation
- Day 1: Collect physical assets, audit access
- Day 2: Verify zero active sessions
- Day 7: Final verification and closure

STAKEHOLDERS NOTIFIED:
- IT Manager: [INSERT NAME/EMAIL]
- Direct Manager: [INSERT NAME/EMAIL]
- HR: [INSERT NAME/EMAIL]
- Finance: [INSERT NAME/EMAIL]
- Security Officer: [INSERT NAME/EMAIL]

DOCUMENTATION:
- Off-boarding Checklist: SG_OFFBOARDING_CHECKLIST.md
- Access Revocation Status: See checklist
- Physical Assets: See checklist
- Work Item Handoff: See checklist

NEXT ACTIONS:
1. IT Manager to begin immediate access revocation (Priority 1 systems)
2. Direct Manager to identify outstanding work items
3. HR to coordinate exit process
4. Security Officer to perform access audit within 24 hours

CUSTOMER IMPACT:
Administrative/Back Office role - minimal customer-facing responsibilities.
Manager to verify if any customer dependencies exist.

For questions or escalation, contact:
- IT Manager: [INSERT CONTACT]
- Security Officer: [INSERT CONTACT]
```

---

## Attachments to Add

1. **SG_OFFBOARDING_CHECKLIST.md** - Complete offboarding checklist
2. **Access Revocation Status** - Updated as work progresses
3. **Asset Return Receipt** - When assets are collected
4. **Access Audit Report** - After Day 1 audit
5. **Final Sign-off Document** - Upon completion

---

## Ticket Comments (Add as work progresses)

### Initial Comment (Hour 0)
```
Off-boarding process initiated. Notifying stakeholders now.

Timeline:
- Access revocation to begin: [INSERT TIME]
- Expected completion of Priority 1: [INSERT TIME + 2-4 hours]

Assigned IT technician: [INSERT NAME]
```

### Access Revocation Progress (Hour 1-4)
```
Access Revocation Progress Update:

PRIORITY 1 SYSTEMS:
☐ Microsoft Entra ID - In Progress / Complete
☐ Microsoft 365 (Exchange/Teams/SharePoint) - In Progress / Complete
☐ RocketCyber - In Progress / Complete
☐ Keeper Security - In Progress / Complete
☐ Datto RMM - In Progress / Complete
☐ Zoho Desk/Projects - In Progress / Complete
☐ VPN Access - In Progress / Complete

Next: Priority 2 systems to be completed by [TIME]
```

### Day 1 Update
```
Access Revocation Status: Priority 1 and 2 complete

Physical Assets Status:
☐ Laptop/Workstation - Collected / Pending
☐ Mobile Device - Collected / Pending
☐ Access Cards/Keys - Collected / Pending
☐ Other Equipment - Collected / Pending

Access Audit: Scheduled for [TIME]
```

### Day 2 Update
```
Access Audit Complete:

Microsoft 365: Zero active sessions confirmed
Security Tools: All access revoked and verified
RMM/PSA: No active access confirmed
VPN: All connections terminated
Network: No active connections

Issues Identified: [NONE / LIST ANY ISSUES]
Remediation Required: [NONE / LIST ACTIONS]
```

### Day 7 Final Update
```
Off-boarding Process Complete:

✓ All access revoked and verified
✓ All physical assets returned
✓ All work items transferred
✓ Documentation archived
✓ Exit process completed

Sign-offs obtained from:
✓ IT Manager
✓ Direct Manager
✓ HR
✓ Security Officer

Lessons Learned: [INSERT ANY NOTES]

Closing ticket. Employee off-boarding complete.
```

---

## Email Notifications

### Stakeholder Initial Notification
**To:** IT Manager, Direct Manager, HR, Finance, Security Officer
**Subject:** URGENT - Employee Off-boarding Initiated - S G
**Body:**
```
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
Zoho Desk Link: [INSERT TICKET LINK]

Documentation: SG_OFFBOARDING_CHECKLIST.md

Time is critical. Please acknowledge receipt and begin your respective actions.

For questions, contact IT Manager at [INSERT CONTACT].
```

### Access Revocation Complete Notification
**To:** IT Manager, Security Officer, Direct Manager
**Subject:** Access Revocation Complete - S G
**Body:**
```
Priority 1 access revocation has been completed for S G.

Systems Revoked:
✓ Microsoft Entra ID / Microsoft 365
✓ RocketCyber
✓ Keeper Security
✓ Datto RMM
✓ Zoho Desk/Projects
✓ VPN Access

Next Steps:
1. Security Officer to perform access audit within 24 hours
2. Direct Manager to collect physical assets
3. IT to complete Priority 2 access revocation

Zoho Desk Ticket: [INSERT TICKET NUMBER]

Any issues or concerns should be escalated immediately.
```

---

## Workflow Automation Rules (if configured in Zoho Desk)

### Rule 1: High Priority Alert
**Trigger:** Ticket created with Priority = HIGH and Category = Employee Off-boarding
**Action:**
- Send immediate email to IT Manager
- Send immediate email to Security Officer
- Create task in Zoho Projects (if integration enabled)

### Rule 2: SLA Tracking
**Trigger:** Ticket created for Immediate Termination
**SLA Rules:**
- Priority 1 access revocation: 4 hours
- Physical asset collection: 24 hours
- Access audit: 48 hours
- Final closure: 7 days

### Rule 3: Completion Checklist
**Trigger:** Ticket status changed to "Resolved"
**Action:**
- Verify all checklist items completed
- Verify all stakeholder sign-offs obtained
- Archive all documentation
- Send completion notification to HR

---

## Related Tickets (if applicable)

- **HR Exit Process:** [INSERT TICKET NUMBER if separate]
- **Asset Management:** [INSERT TICKET NUMBER if separate]
- **Payroll/Finance:** [INSERT TICKET NUMBER if separate]

---

## Quick Access Links

- **Zoho Desk Ticket:** [INSERT LINK]
- **Zoho Projects Project:** [INSERT LINK if created]
- **Off-boarding Checklist:** /home/wferrel/ai/employee_management/SG_OFFBOARDING_CHECKLIST.md
- **Employee Profile:** [INSERT LINK if exists]
- **Asset Inventory:** [INSERT LINK]

---

*Created: 2025-12-17*
*Employee: S G (S@midcloudcomputing.com)*
*Type: IMMEDIATE TERMINATION*
*Priority: HIGH*
