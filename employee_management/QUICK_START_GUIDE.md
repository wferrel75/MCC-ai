# Off-boarding Quick Start Guide

**Print this page and keep it handy for when off-boarding is needed**

---

## When Employee Departure is Announced

### ⚡ IMMEDIATE ACTIONS (Within 1 hour)

**1. Gather Information**
- [ ] Employee Name: ___________________
- [ ] Employee ID: ___________________
- [ ] Email: ___________________
- [ ] Role: ___________________
- [ ] Departure Type: ☐ Resignation  ☐ Termination  ☐ Retirement
- [ ] Last Working Day: ___________________
- [ ] Notice Period: ___________________

**2. Generate Reports**
```bash
cd /home/wferrel/employee_management

python offboarding_automation.py \
  --employee [EMPLOYEE_ID] \
  --name "[EMPLOYEE_NAME]" \
  --email [EMAIL] \
  --role [ROLE]
```

**3. Create Tracking**
- [ ] Create Zoho Desk ticket (use "Employee Off-boarding" template)
- [ ] Create Zoho Projects project (use "Employee Off-boarding" template)
- [ ] Attach generated reports to both

**4. Notify**
- [ ] IT Manager
- [ ] Direct Manager
- [ ] HR
- [ ] Security Officer (if immediate termination)

---

## Critical Timelines

### TERMINATION (Immediate Departure)
| Timeline | Action |
|----------|--------|
| **Hour 0** | Create ticket, generate reports |
| **Hour 1** | Notify stakeholders, approve plan |
| **Hour 2** | Begin access revocation |
| **Hour 4** | Complete access revocation |
| **Day 1** | Audit access, reassign critical tickets |
| **Week 1** | Complete customer transitions |

### RESIGNATION (Notice Period)
| Timeline | Action |
|----------|--------|
| **Day 0** | Create ticket, generate reports |
| **Day 1** | Begin knowledge transfer |
| **Week 1-N** | Document and transfer knowledge |
| **Last Day** | Access revocation at EOD |
| **Last Day +1** | Complete reassignments |
| **Week 1-4** | Monitor customer transitions |

---

## Access Revocation Checklist

**PRIORITY 1 - Execute Immediately (Termination) or on Last Day EOD (Resignation)**

- [ ] **Microsoft Entra ID** - Disable account
- [ ] **Microsoft 365** - Revoke licenses, convert mailbox
- [ ] **RocketCyber** - Remove user
- [ ] **Datto RMM** - Revoke access
- [ ] **Zoho Desk/Projects** - Disable account
- [ ] **VPN Access** - Revoke all VPN accounts
- [ ] **Customer Environments** - Revoke all customer access

**PRIORITY 2 - Complete within 24 hours**
- [ ] All other systems (see full checklist in generated report)
- [ ] Physical assets collected
- [ ] Access audit completed

---

## Helpdesk Engineer - Customer Transition Checklist

**For each customer where employee is primary contact:**

1. [ ] Generate transition document:
   ```bash
   python offboarding_automation.py \
     --customer-transition "[CUSTOMER]" "[DEPARTING]" "[NEW_ENGINEER]"
   ```

2. [ ] Review transition doc with departing engineer (if available)

3. [ ] Review transition doc with receiving engineer

4. [ ] Send customer introduction email (use template below)

5. [ ] Update systems:
   - [ ] Zoho Desk - Update primary contact
   - [ ] Datto RMM - Update device assignments
   - [ ] Customer OneNote - Update ownership
   - [ ] Internal contact lists

6. [ ] Monitor first 2-3 customer interactions

7. [ ] Review transition at 30 days

---

## Customer Introduction Email Template

**Subject:** Your MCC Support Team - Introduction to [New Engineer Name]

Dear [Customer Name],

I wanted to personally introduce you to [New Engineer Name], who will be your primary technical contact at Midwest Cloud Computing going forward.

[New Engineer Name] brings [X years] of experience in [relevant expertise] and has been fully briefed on your environment and ongoing projects.

[IF PLANNED: I'll be working closely with [New Engineer] over the next [timeframe] to ensure a seamless transition.]

[New Engineer] can be reached at:
- Email: [email]
- Phone: [phone]
- Teams: [teams handle]

As always, our entire team remains available for support 24/7 at support@midcloudcomputing.com or +1-402-702-5000.

Thank you for your continued partnership with MCC.

[Departing Engineer Name] / [New Engineer Name]

---

## Emergency Contacts

| Role | Contact |
|------|---------|
| IT Manager | [Phone/Email] |
| HR | [Phone/Email] |
| Security Officer | [Phone/Email] |
| Support Line | +1-402-702-5000 |

---

## Common Commands Reference

```bash
# Full off-boarding report
python offboarding_automation.py --employee [ID] --name "[NAME]" --email [EMAIL] --role helpdesk

# Access checklist only
python offboarding_automation.py --generate-checklist [ID] --name "[NAME]"

# Tickets only
python offboarding_automation.py --tickets [EMAIL]

# Projects only
python offboarding_automation.py --projects [EMAIL]

# Customer assignments only
python offboarding_automation.py --customers [EMAIL]

# Customer transition doc
python offboarding_automation.py --customer-transition "[CUSTOMER]" "[DEPARTING]" "[NEW]"
```

---

## Red Flags - Escalate Immediately

🚨 **Escalate to IT Manager if:**
- Employee had admin access to critical systems
- Employee had access to sensitive customer data
- Employee managed critical infrastructure
- More than 10 customers will be affected
- Active security incidents involving employee
- Employee departure is contentious/hostile

🚨 **Escalate to Security Officer if:**
- Suspicion of data theft
- Suspicious activity before departure
- Termination for security violations
- Employee had security tool admin access

---

## Verification Steps

**Before closing off-boarding ticket:**

- [ ] Access audit shows zero active sessions
- [ ] All tickets reassigned (verify in Zoho Desk)
- [ ] All projects transferred (verify in Zoho Projects)
- [ ] All customers transitioned (verify contact lists updated)
- [ ] All assets returned (verify asset inventory)
- [ ] Exit interview completed (verify with HR)
- [ ] Documentation archived (verify in OneNote/SharePoint)
- [ ] No outstanding issues or blockers

---

## Documentation Location

- **Full Process:** `/home/wferrel/employee_management/OFFBOARDING_PROCESS.md`
- **README:** `/home/wferrel/employee_management/README.md`
- **Automation Script:** `/home/wferrel/employee_management/offboarding_automation.py`

---

**Keep this guide accessible for quick reference during off-boarding events**

*Last Updated: 2025-11-25*
