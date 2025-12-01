# MCC Off-boarding Workflow Diagram

## High-Level Process Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    OFF-BOARDING INITIATED                       │
│              (HR Notification / Manager Request)                │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│          WORKFLOW #1: INITIATION & ORCHESTRATION                │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  1. Collect employee data                                │   │
│  │  2. Run Python automation script                         │   │
│  │  3. Create Zoho Desk ticket                             │   │
│  │  4. Create Zoho Projects project                        │   │
│  │  5. Notify stakeholders                                  │   │
│  │  6. Trigger sub-workflows                               │   │
│  └──────────────────────────────────────────────────────────┘   │
└──┬─────────────┬─────────────────┬─────────────────────────────┘
   │             │                 │
   │             │                 │
   ▼             ▼                 ▼
┌──────────┐ ┌──────────┐    ┌──────────┐
│WORKFLOW 2│ │WORKFLOW 3│    │WORKFLOW 4│
│  Access  │ │ Tickets  │    │Customers │
│Revocation│ │Assignment│    │Transition│
│          │ │          │    │ (Helpdesk│
│          │ │          │    │   Only)  │
└────┬─────┘ └────┬─────┘    └────┬─────┘
     │            │               │
     │            │               │
     └────────────┴───────────────┘
                  │
                  ▼
     ┌────────────────────────┐
     │ ALL WORKFLOWS COMPLETE │
     │  Zoho Desk Updated     │
     │  IT Manager Notified   │
     └────────────┬───────────┘
                  │
                  ▼
     ┌────────────────────────┐
     │   WORKFLOW #5:         │
     │ MONITORING & AUDIT     │
     │  (Runs Daily)          │
     │                        │
     │  Days 1-30: Monitor    │
     │  Day 30: Complete      │
     └────────────────────────┘
```

## Detailed Workflow Connections

### Workflow #1: Initiation (Orchestrator)

```
┌──────────────────────────────────────────────────────────────────┐
│ WEBHOOK TRIGGER: /webhook/offboarding-initiate                  │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                ┌────────────┴──────────────┐
                │   Set Employee Data       │
                └────────────┬──────────────┘
                             │
                ┌────────────┴──────────────┐
                │  Is Helpdesk Engineer?    │
                └─────┬──────────────┬──────┘
                      │              │
               ┌──────┴──┐    ┌─────┴──────┐
               │Helpdesk │    │  Standard  │
               │ Script  │    │   Script   │
               └──────┬──┘    └─────┬──────┘
                      └──────┬──────┘
                             │
                ┌────────────┴──────────────┐
                │ Create Zoho Desk Ticket   │
                └────────────┬──────────────┘
                             │
                ┌────────────┴──────────────┐
                │Create Zoho Projects Project│
                └────────────┬──────────────┘
                             │
                ┌────────────┴──────────────┐
                │   Notify Stakeholders     │
                │  (IT Manager, HR, etc.)   │
                └────────────┬──────────────┘
                             │
                ┌────────────┴──────────────┐
                │ Is Immediate Termination? │
                └─────┬──────────────┬──────┘
                      │              │
                 ┌────┴───┐         No
                Yes      │          │
                 │       │          │
                 ▼       ▼          │
            ┌─────────────────┐    │
            │Trigger Access   │    │
            │Revocation NOW   │    │
            │(Workflow #2)    │    │
            └────────┬────────┘    │
                     └──────────────┘
                             │
                ┌────────────┴──────────────┐
                │   Trigger Ticket          │
                │   Reassignment            │
                │   (Workflow #3)           │
                └────────────┬──────────────┘
                             │
                ┌────────────┴──────────────┐
                │  If Helpdesk Role:        │
                │  Trigger Customer         │
                │  Transition               │
                │  (Workflow #4)            │
                └────────────┬──────────────┘
                             │
                             ▼
                    ┌────────────────┐
                    │ Return Success │
                    │   Response     │
                    └────────────────┘
```

### Workflow #2: Access Revocation

```
┌──────────────────────────────────────────────────────────────────┐
│ WEBHOOK TRIGGER: /webhook/access-revocation                     │
│ Called by: Workflow #1 or Manual                                │
└────────────────────────────┬─────────────────────────────────────┘
                             │
        ┌────────────────────┴────────────────────┐
        │                                         │
        ▼                                         ▼
┌───────────────┐                        ┌───────────────┐
│Get User from  │                        │Check Datto RMM│
│  Entra ID     │                        │  User Access  │
└───────┬───────┘                        └───────┬───────┘
        │                                        │
        ├─────────┬──────────┬──────────┐       │
        ▼         ▼          ▼          ▼       ▼
┌─────────┐ ┌──────────┐ ┌──────┐ ┌──────┐ ┌──────┐
│ Disable │ │  Remove  │ │Revoke│ │Revoke│ │Revoke│
│ Account │ │from Groups│ │ MFA │ │License│ │Datto│
└────┬────┘ └────┬─────┘ └───┬──┘ └───┬──┘ └───┬──┘
     └───────────┴───────────┴────────┴────────┘
                             │
                ┌────────────┴──────────────┐
                │ Revoke All Active Sessions│
                └────────────┬──────────────┘
                             │
                ┌────────────┴──────────────┐
                │  Set Out-of-Office Reply  │
                └────────────┬──────────────┘
                             │
                ┌────────────┴──────────────┐
                │Compile Automated + Manual │
                │   Revocation Results      │
                └────────────┬──────────────┘
                             │
                ┌────────────┴──────────────┐
                │Update Zoho Desk Ticket    │
                │   with Results            │
                └────────────┬──────────────┘
                             │
                ┌────────────┴──────────────┐
                │  Notify IT Manager        │
                └────────────┬──────────────┘
                             │
                             ▼
                    ┌────────────────┐
                    │ Return Results │
                    └────────────────┘
```

### Workflow #3: Ticket Reassignment

```
┌──────────────────────────────────────────────────────────────────┐
│ WEBHOOK TRIGGER: /webhook/ticket-reassignment                   │
│ Called by: Workflow #1 or Manual                                │
└────────────────────────────┬─────────────────────────────────────┘
                             │
        ┌────────────────────┴────────────────────┐
        │                                         │
        ▼                                         ▼
┌───────────────────┐                   ┌──────────────────┐
│ Get All Open      │                   │  Get Team        │
│ Tickets Assigned  │                   │  Workload Data   │
│ to Employee       │                   │                  │
└─────────┬─────────┘                   └────────┬─────────┘
          │                                      │
          └──────────────┬───────────────────────┘
                         │
            ┌────────────┴──────────────┐
            │  Analyze Tickets:         │
            │  - By priority            │
            │  - By customer            │
            │  - Identify patterns      │
            └────────────┬──────────────┘
                         │
            ┌────────────┴──────────────┐
            │  Is Urgent?               │
            └─────┬──────────────┬──────┘
                  │              │
         ┌────────┴──┐    ┌─────┴────────┐
         │  Urgent   │    │   Planned    │
         │ Algorithm │    │  Algorithm   │
         │ (Speed)   │    │ (Optimize)   │
         └────────┬──┘    └─────┬────────┘
                  └──────┬──────┘
                         │
            ┌────────────┴──────────────┐
            │  For Each Ticket:         │
            │  ┌─────────────────────┐  │
            │  │ Reassign in Zoho    │  │
            │  │ Add transition note │  │
            │  │ Notify if needed    │  │
            │  └─────────────────────┘  │
            └────────────┬──────────────┘
                         │
            ┌────────────┴──────────────┐
            │   Compile Summary         │
            └────────────┬──────────────┘
                         │
        ┌────────────────┴────────────────┐
        │                                 │
        ▼                                 ▼
┌──────────────────┐           ┌──────────────────┐
│Update Off-boarding│          │ Notify IT Manager│
│Zoho Desk Ticket  │           │  and Team        │
└─────────┬────────┘           └────────┬─────────┘
          └──────────────┬───────────────┘
                         │
                         ▼
                ┌────────────────┐
                │ Return Summary │
                └────────────────┘
```

### Workflow #4: Customer Transition

```
┌──────────────────────────────────────────────────────────────────┐
│ WEBHOOK TRIGGER: /webhook/customer-transition                   │
│ Called by: Workflow #1 (Helpdesk only) or Manual               │
└────────────────────────────┬─────────────────────────────────────┘
                             │
        ┌────────────────────┴────────────────────┐
        │                                         │
        ▼                                         ▼
┌───────────────────┐                   ┌──────────────────┐
│ Get Customers     │                   │  Get Available   │
│ Where Employee is │                   │  Helpdesk        │
│ Primary Contact   │                   │  Engineers       │
└─────────┬─────────┘                   └────────┬─────────┘
          │                                      │
          └──────────────┬───────────────────────┘
                         │
            ┌────────────┴──────────────┐
            │ Intelligent Assignment:   │
            │ - Premium customers first │
            │ - Balance workload        │
            │ - Match specialties       │
            └────────────┬──────────────┘
                         │
            ┌────────────┴──────────────┐
            │  For Each Customer:       │
            │  ┌─────────────────────┐  │
            │  │Generate Transition  │  │
            │  │   Document          │  │
            │  └──────────┬──────────┘  │
            │             │              │
            │  ┌──────────┴──────────┐  │
            │  │ Send Introduction   │  │
            │  │ Email (Premium vs   │  │
            │  │ Standard)           │  │
            │  └──────────┬──────────┘  │
            │             │              │
            │  ┌──────────┴──────────┐  │
            │  │ Update Customer DB  │  │
            │  │ Update Datto RMM    │  │
            │  └──────────┬──────────┘  │
            │             │              │
            │  ┌──────────┴──────────┐  │
            │  │   Log Transition    │  │
            │  └─────────────────────┘  │
            └────────────┬──────────────┘
                         │
            ┌────────────┴──────────────┐
            │   Compile Summary         │
            └────────────┬──────────────┘
                         │
        ┌────────────────┴────────────────┐
        │                                 │
        ▼                                 ▼
┌──────────────────┐           ┌──────────────────┐
│Update Off-boarding│          │ Notify IT Manager│
│Zoho Desk Ticket  │           │ and Receiving    │
│                  │           │ Engineers        │
└─────────┬────────┘           └────────┬─────────┘
          └──────────────┬───────────────┘
                         │
                         ▼
                ┌────────────────┐
                │ Return Summary │
                └────────────────┘
```

### Workflow #5: Monitoring & Audit

```
┌──────────────────────────────────────────────────────────────────┐
│ SCHEDULE TRIGGER: Daily at Midnight                             │
└────────────────────────────┬─────────────────────────────────────┘
                             │
            ┌────────────────┴──────────────┐
            │  Get All Active Off-boardings │
            │  (In Progress or Monitoring)  │
            │  (Within 30 days of departure)│
            └────────────────┬──────────────┘
                             │
            ┌────────────────┴──────────────┐
            │  For Each Off-boarding:       │
            │  ┌─────────────────────────┐  │
            │  │Run Audit Checks:        │  │
            │  │                         │  │
            │  │✓ Entra Account Status  │  │
            │  │✓ Mailbox Auto-Reply    │  │
            │  │✓ Remaining Tickets     │  │
            │  │✓ Remaining Customers   │  │
            │  └──────────┬──────────────┘  │
            │             │                  │
            │  ┌──────────┴──────────────┐  │
            │  │ Compile Audit Results   │  │
            │  │ - Issues                │  │
            │  │ - Warnings              │  │
            │  │ - Status                │  │
            │  └──────────┬──────────────┘  │
            │             │                  │
            │  ┌──────────┴──────────────┐  │
            │  │  Has Critical Issues?   │  │
            │  └─────┬────────────┬──────┘  │
            │        │            │          │
            │  ┌─────┴─┐       ┌──┴──────┐  │
            │  │ Alert │       │Check for│  │
            │  │Critical│      │Warnings │  │
            │  └───┬───┘       └──┬──────┘  │
            │      │              │          │
            │  ┌───┴──────────────┴──────┐  │
            │  │  Log Audit to Database  │  │
            │  └──────────┬──────────────┘  │
            │             │                  │
            │  ┌──────────┴──────────────┐  │
            │  │Is 30-Day Complete       │  │
            │  │AND Passed All Checks?   │  │
            │  └─────┬────────────┬──────┘  │
            │        │            │          │
            │  ┌─────┴─┐       ┌──┴──────┐  │
            │  │ Mark  │       │Continue │  │
            │  │Complete│      │Monitor  │  │
            │  │Close  │       └─────────┘  │
            │  │Ticket │                    │
            │  │Notify │                    │
            │  └───────┘                    │
            └────────────┬──────────────────┘
                         │
            ┌────────────┴──────────────┐
            │ Generate Daily Summary    │
            │ Send to IT Manager        │
            └───────────────────────────┘
```

## Data Flow Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│                         DATA SOURCES                             │
├──────────────┬────────────────┬────────────────┬────────────────┤
│ Microsoft    │ Zoho Desk/     │ PostgreSQL     │ Python Script  │
│ Graph API    │ Projects API   │ Database       │ Output         │
│              │                │                │                │
│- User Data   │- Tickets       │- Workload Data │- Reports       │
│- Groups      │- Projects      │- Customers     │- Checklists    │
│- Licenses    │- Comments      │- Audit Logs    │- Transition    │
│- Mailbox     │                │                │  Docs          │
└──────┬───────┴────────┬───────┴────────┬───────┴────────┬───────┘
       │                │                │                │
       │    ┌───────────┴────────────────┴────────────┐  │
       │    │                                          │  │
       ▼    ▼                                          ▼  ▼
┌─────────────────────────────────────────────────────────────────┐
│                       n8n WORKFLOWS                              │
│                                                                  │
│  [Workflow #1] ──► [Workflow #2] ──► [Access Revoked]          │
│       │            [Workflow #3] ──► [Tickets Reassigned]       │
│       └───────────► [Workflow #4] ──► [Customers Transitioned]  │
│                                                                  │
│  [Workflow #5] ──► Daily Monitoring ──► Audit Reports           │
└──────┬────────────────┬──────────────┬──────────────┬───────────┘
       │                │              │              │
       ▼                ▼              ▼              ▼
┌──────────────────────────────────────────────────────────────────┐
│                          OUTPUTS                                 │
├──────────────┬────────────────┬────────────────┬────────────────┤
│ Zoho Desk    │ Email          │ Database       │ System         │
│              │ Notifications  │ Updates        │ Changes        │
│- Tickets     │                │                │                │
│- Comments    │- IT Manager    │- Audit Logs    │- Disabled      │
│- Status      │- HR            │- Tracking      │  Accounts      │
│  Updates     │- Team          │  Records       │- Revoked       │
│              │- Customers     │- Workload      │  Access        │
│              │                │  Stats         │                │
└──────────────┴────────────────┴────────────────┴────────────────┘
```

## Timeline View

```
Day -N (Notice Given)
═══════════════════════════════════════════════════════════════════
│
│ [WORKFLOW #1] Off-boarding Initiated
│     ├─► Zoho Desk Ticket Created
│     ├─► Zoho Projects Project Created
│     ├─► Stakeholders Notified
│     └─► Sub-workflows Triggered
│
│ [WORKFLOW #3] Ticket Reassignment Begins
│     ├─► High-priority tickets reassigned immediately
│     └─► Other tickets reassigned over notice period
│
│ [WORKFLOW #4] Customer Transitions Begin (if helpdesk)
│     ├─► Transition documents created
│     ├─► Introduction emails sent
│     └─► Knowledge transfer initiated
│

Day 0 (Last Working Day)
═══════════════════════════════════════════════════════════════════
│
│ [WORKFLOW #2] Access Revocation (EOD or Immediate if Termination)
│     ├─► Entra ID account disabled
│     ├─► Sessions revoked
│     ├─► Licenses removed
│     ├─► Groups cleared
│     ├─► Auto-reply configured
│     └─► Manual checklist generated
│

Day 1 (Post-Departure)
═══════════════════════════════════════════════════════════════════
│
│ [WORKFLOW #5] First Audit
│     ├─► Verify all access revoked
│     ├─► Check no tickets assigned
│     ├─► Check no customers assigned
│     └─► Alert if issues found
│

Days 2-29
═══════════════════════════════════════════════════════════════════
│
│ [WORKFLOW #5] Daily Monitoring
│     ├─► Daily audit checks
│     ├─► Monitor customer transitions
│     ├─► Track ticket resolutions
│     └─► Generate daily reports
│

Day 30 (Final Review)
═══════════════════════════════════════════════════════════════════
│
│ [WORKFLOW #5] Final Audit & Completion
│     ├─► Final audit checks
│     ├─► If passed: Mark complete
│     ├─► Close Zoho Desk ticket
│     ├─► Send completion notification
│     └─► Archive documentation
│
═══════════════════════════════════════════════════════════════════
```

## Integration Points

```
┌─────────────────────────────────────────────────────────────────┐
│                     EXTERNAL SYSTEMS                            │
└─────────────────────────────────────────────────────────────────┘

    Microsoft 365 / Entra ID          Zoho Ecosystem
    ┌─────────────────┐              ┌──────────────┐
    │ - User Accounts │◄────────────►│ - Desk       │
    │ - Mailboxes     │              │ - Projects   │
    │ - Groups        │              │ - CRM        │
    │ - Licenses      │              └──────────────┘
    └─────────────────┘                     │
            │                               │
            └───────────┬───────────────────┘
                        │
           ┌────────────▼────────────┐
           │    n8n WORKFLOWS        │
           │  (Central Orchestrator) │
           └────────────┬────────────┘
                        │
            ┌───────────┴───────────┐
            │                       │
    ┌───────▼────────┐      ┌──────▼──────┐
    │ Datto RMM      │      │ PostgreSQL  │
    │ - Technicians  │      │ - Tracking  │
    │ - Site Mgmt    │      │ - Audit     │
    └────────────────┘      └─────────────┘
            │
    ┌───────▼────────┐
    │ SMTP / Email   │
    │ - Notifications│
    └────────────────┘
```

---

*This diagram provides a visual overview of workflow connections and data flow. For implementation details, see individual workflow JSON files and README.md.*
