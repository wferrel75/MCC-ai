# IMMEDIATE ACTION GUIDE - S G Off-boarding
## ⚡ START HERE - HOUR 0

**Employee:** S G [REPLACE WITH FULL NAME]
**Email:** S@midcloudcomputing.com [REPLACE WITH ACTUAL EMAIL]
**Type:** IMMEDIATE TERMINATION
**Date:** December 17, 2025 (TODAY)
**Time Started:** ___________

---

## 🚨 CRITICAL: Complete Within 1 Hour

### Step 1: Send Stakeholder Notification (5 minutes)
**Copy and send this email NOW:**

**To:**
- IT Manager: [INSERT EMAIL]
- Direct Manager: [INSERT EMAIL]
- HR: [INSERT EMAIL]
- Finance: [INSERT EMAIL]
- Security Officer: [INSERT EMAIL]

**Subject:** URGENT - Employee Off-boarding Initiated - S G

**Body:**
```
Employee off-boarding has been initiated for S G (S@midcloudcomputing.com).

Departure Type: IMMEDIATE TERMINATION
Last Working Day: December 17, 2025 (TODAY)
Role: Administrative/Back Office
Time Initiated: [INSERT CURRENT TIME]

IMMEDIATE ACTIONS REQUIRED:
- IT: Access revocation begins now - must complete Priority 1 within 2-4 hours
- Manager: Identify any outstanding work items within 1 hour
- HR: Begin exit process coordination
- Finance: Prepare final payroll processing
- Security: Access audit required within 24 hours

Documentation: See attached SG_OFFBOARDING_CHECKLIST.md

Time is critical. Reply to acknowledge receipt.

IT Contact: [INSERT YOUR CONTACT INFO]
```

**☐ Email sent - Time:** ___________

---

### Step 2: Create Zoho Desk Ticket (5 minutes)

1. Go to https://desk.zoho.com
2. Click "New Ticket"
3. Fill in:
   - **Subject:** `URGENT - Employee Off-boarding - S G - IMMEDIATE TERMINATION`
   - **Priority:** HIGH
   - **Department:** IT
   - **Assign to:** IT Manager
   - **Category:** Employee Off-boarding
4. Copy the description from `SG_ZOHO_TICKET_TEMPLATE.md`
5. Attach `SG_OFFBOARDING_CHECKLIST.md`
6. Click "Submit"

**☐ Ticket created - Number:** ___________ Time: ___________

---

### Step 3: Begin Access Revocation - Microsoft Systems (30 minutes)

#### A. Disable Microsoft Entra ID (Azure AD) Account
1. Go to https://entra.microsoft.com
2. Navigate to Users → All Users
3. Search for: S@midcloudcomputing.com
4. Click on the user
5. Click "..." → "Block sign-in"
6. Confirm: "Yes"
7. Click "Revoke sessions"
8. Confirm: "Yes"

**☐ Account disabled - Time:** ___________
**☐ Sessions revoked - Time:** ___________

#### B. Microsoft 365 - Exchange Online
1. Go to https://admin.microsoft.com
2. Navigate to Users → Active Users
3. Click on S@midcloudcomputing.com
4. Go to "Mail" tab
5. Click "Manage automatic replies"
6. Set message: "This employee is no longer with MCC. Please contact support@midcloudcomputing.com or +1-402-702-5000"
7. Save

**☐ Auto-reply set - Time:** ___________

8. Go to Exchange Admin Center (https://admin.exchange.microsoft.com)
9. Recipients → Mailboxes
10. Click on S@midcloudcomputing.com
11. Under "General" → Hide from address lists: Enable

**☐ Hidden from GAL - Time:** ___________

---

## 🔥 HOUR 1-2: Priority 1 Access Revocation

### Microsoft 365 Licenses
1. Go to https://admin.microsoft.com
2. Users → Active Users → S@midcloudcomputing.com
3. Click "Licenses and apps" tab
4. Uncheck all licenses
5. Save changes

**☐ Licenses revoked - Time:** ___________

---

### Remove from Security Groups
1. Go to https://entra.microsoft.com
2. Users → S@midcloudcomputing.com
3. Click "Groups"
4. For each group, click "..." → "Remove from group"
5. Remove from ALL groups

**Groups removed:**
- ☐ Group 1: ___________ Time: ___________
- ☐ Group 2: ___________ Time: ___________
- ☐ Group 3: ___________ Time: ___________
- ☐ [Add more as needed]

---

### Microsoft Teams
1. Check if user owns any teams
2. For each owned team:
   - Open Teams admin center
   - Transfer ownership to: [INSERT MANAGER EMAIL]
3. Remove from all teams

**☐ Teams ownership transferred - Time:** ___________
**☐ Removed from all teams - Time:** ___________

---

### SharePoint/OneDrive
1. Go to SharePoint Admin Center
2. More features → User profiles → Manage user profiles
3. Search: S@midcloudcomputing.com
4. Click "Manage site collection administrators"
5. Grant access to manager: [INSERT MANAGER EMAIL]

**☐ OneDrive access granted to manager - Time:** ___________

---

## 🔥 HOUR 2-3: Security & RMM Tools

### RocketCyber
1. Go to RocketCyber portal: [INSERT URL]
2. Navigate to Users/Admin section
3. Search for: S@midcloudcomputing.com or S G
4. Remove user account or disable

**☐ RocketCyber access revoked - Time:** ___________

---

### Keeper Security
1. Go to https://keepersecurity.com
2. Navigate to Admin Console
3. Search for: S@midcloudcomputing.com
4. Identify any shared vaults owned by user
5. Transfer ownership to: [INSERT MANAGER EMAIL]
6. Remove user account

**☐ Keeper vaults transferred - Time:** ___________
**☐ Keeper account removed - Time:** ___________

---

### Datto RMM
1. Go to Datto RMM portal: [INSERT URL]
2. Navigate to Users section
3. Search for: S@midcloudcomputing.com
4. Revoke account access
5. Remove from all technician groups

**☐ Datto RMM access revoked - Time:** ___________

---

### Zoho Desk
1. Go to https://desk.zoho.com
2. Setup → Users → All Users
3. Search for: S@midcloudcomputing.com
4. Check for any active tickets assigned
5. Reassign tickets to: [INSERT NAME/EMAIL]
6. Disable user account (toggle to Inactive)

**Active tickets found:** ___________ (count)
**☐ Tickets reassigned - Time:** ___________
**☐ Zoho Desk account disabled - Time:** ___________

---

### Zoho Projects
1. Go to https://projects.zoho.com
2. Search for user tasks
3. Reassign any active tasks to: [INSERT NAME/EMAIL]
4. Disable user account

**Active tasks found:** ___________ (count)
**☐ Tasks reassigned - Time:** ___________
**☐ Zoho Projects account disabled - Time:** ___________

---

### VPN Access
**Company VPN:**
1. Access VPN management console: [INSERT URL/SYSTEM]
2. Search for: S@midcloudcomputing.com or S G
3. Revoke/delete VPN account
4. Terminate any active sessions

**☐ Company VPN revoked - Time:** ___________

**Customer VPNs (if applicable):**
- ☐ Customer 1: ___________ - Revoked - Time: ___________
- ☐ Customer 2: ___________ - Revoked - Time: ___________
- ☐ [Add as needed]

---

## ✅ HOUR 3-4: Priority 1 Verification

### Quick Audit Checklist
Run through this verification:

**Microsoft Systems:**
- ☐ Cannot log in to https://portal.office.com with S@midcloudcomputing.com
- ☐ No active sessions in Entra ID
- ☐ Auto-reply is active
- ☐ User hidden from Global Address List

**Security Tools:**
- ☐ RocketCyber: No active access
- ☐ Keeper: Account removed

**RMM/PSA:**
- ☐ Datto RMM: No active access
- ☐ Zoho Desk: Account inactive, tickets reassigned
- ☐ Zoho Projects: Account inactive, tasks reassigned

**VPN:**
- ☐ Company VPN: No active sessions
- ☐ Customer VPNs: All revoked

**☐ Priority 1 Verification Complete - Time:** ___________

---

## 📋 HOUR 4-8: Priority 2 Systems

### ConnectSecure
1. Go to ConnectSecure portal: [INSERT URL]
2. Remove user: S@midcloudcomputing.com
3. Revoke any API keys

**☐ ConnectSecure revoked - Time:** ___________

---

### KnowBe4
1. Go to https://training.knowbe4.com
2. Remove from training campaigns
3. Archive user

**☐ KnowBe4 archived - Time:** ___________

---

### Cisco Meraki
1. Go to https://dashboard.meraki.com
2. Organization → Administrators
3. Remove: S@midcloudcomputing.com

**☐ Meraki access revoked - Time:** ___________

---

### Azure Portal (if applicable)
1. Go to https://portal.azure.com
2. Subscriptions → Access Control (IAM)
3. Search for: S@midcloudcomputing.com
4. Remove all role assignments

**☐ Azure RBAC removed - Time:** ___________

---

### AWS Console (if applicable)
1. Go to https://console.aws.amazon.com
2. IAM → Users
3. Delete user: S@midcloudcomputing.com
4. Remove from all groups

**☐ AWS IAM removed - Time:** ___________

---

## 📦 DAY 1: Physical Assets

### Schedule Asset Return
**Contact:** [INSERT MANAGER NAME/EMAIL]
**Meeting Time:** ___________

### Assets to Collect:
- ☐ Laptop/Workstation - Model: ___________ Serial: ___________
- ☐ Mobile Device - Phone #: ___________
- ☐ Access Cards/Keys - ID: ___________
- ☐ Hardware Tokens - Serial: ___________
- ☐ Company Credit Card - Last 4: ___________
- ☐ Other: ___________

**☐ All assets collected - Time:** ___________ Date: ___________

---

## 🔍 DAY 1-2: Security Audit

### Run Access Audit
**Audit Performed By:** ___________
**Audit Date/Time:** ___________

**Check each system:**
- ☐ Microsoft Entra ID - Zero active sessions
- ☐ Microsoft 365 - No active logins
- ☐ RocketCyber - No access
- ☐ ConnectSecure - No access
- ☐ Keeper - Account removed
- ☐ Datto RMM - No access
- ☐ Zoho Desk/Projects - Inactive
- ☐ VPN - All sessions terminated
- ☐ Meraki - No access
- ☐ Azure/AWS - No access

**Issues Found:** ___________
**Remediation Completed:** ___________

**☐ Security Audit Complete - No Issues Found**
**Audit Sign-off:** ___________ Date: ___________

---

## 📝 DAY 7: Final Closure

### Final Verification
- ☐ All access revoked and verified (Day 2)
- ☐ All physical assets returned (Day 1)
- ☐ All work items reassigned
- ☐ Exit interview completed (HR)
- ☐ Final payroll processed (Finance)
- ☐ Documentation archived

### Update Zoho Desk Ticket
1. Add final comment with completion summary
2. Attach access audit report
3. Change status to "Resolved"
4. Add completion date

**☐ Ticket closed - Date:** ___________

---

## 🎯 SUCCESS CRITERIA

**This off-boarding is complete when:**
✓ Zero active access to any MCC systems
✓ All physical assets returned
✓ All work items reassigned with no service disruption
✓ Security audit shows no vulnerabilities
✓ All stakeholders have signed off
✓ Documentation archived
✓ Zoho Desk ticket closed

---

## 🆘 ESCALATION

**Immediate escalation required if:**
- Unable to disable critical system access within 2 hours
- Active security concerns or suspicious activity
- Missing physical assets containing sensitive data
- Customer service disruption
- Any access audit failures

**Escalate To:**
- IT Manager: [INSERT CONTACT]
- Security Officer: [INSERT CONTACT]
- CEO/Leadership: [INSERT CONTACT if severe issue]

---

## 📞 QUICK CONTACTS

| Role | Name | Contact |
|------|------|---------|
| IT Manager | [INSERT] | [INSERT] |
| Direct Manager | [INSERT] | [INSERT] |
| HR | [INSERT] | [INSERT] |
| Security Officer | [INSERT] | [INSERT] |
| Finance | [INSERT] | [INSERT] |

---

**🔄 PLACEHOLDERS TO REPLACE:**
- **S G** → Full employee name
- **S@midcloudcomputing.com** → Actual email address
- **[INSERT...]** → All bracketed fields need actual values
- **___________** → Fill in as you complete each step

---

*This is a living document - update timestamps as you complete each action*
*Keep this guide open and work through it step by step*
*The first 4 hours are CRITICAL for security*

**Generated:** 2025-12-17
**Employee:** S G (S@midcloudcomputing.com)
**Status:** IMMEDIATE TERMINATION - Administrative/Back Office
