# Zoho Projects Off-boarding Project Template

## Template Overview

This template creates a standardized project in Zoho Projects for managing employee off-boarding tasks, timelines, and collaboration.

**Template Name:** Employee Off-boarding Process
**Template Type:** Internal Operations
**Duration:** 1-4 weeks (variable based on departure type)

## Project Setup

### Project Details
- **Project Name:** Off-boarding: [Employee Name] - [Role]
- **Description:** Manage the off-boarding process for [Employee Name], ensuring smooth transition of responsibilities, access revocation, and customer continuity.
- **Owner:** IT Manager
- **Start Date:** [Notification Date]
- **End Date:** [Last Working Day + 7 days]

### Project Members
- IT Manager (Admin)
- Direct Manager (Normal)
- HR Representative (Normal)
- Receiving Engineers (Normal) - Added as identified
- Departing Employee (Read-only) - If resignation with notice period

## Task List Structure

### Milestone 1: Initiation & Planning (Day 0-1)

**Tasks:**

1. **Create Off-boarding Documentation**
   - Assignee: IT Manager
   - Duration: 1 day
   - Priority: High
   - Subtasks:
     - [ ] Run automation script to generate reports
     - [ ] Create Zoho Desk ticket
     - [ ] Notify all stakeholders
     - [ ] Review impact assessment

2. **Approve Reassignment Plan**
   - Assignee: IT Manager + Direct Manager
   - Duration: 1 day
   - Priority: High
   - Dependency: Task 1
   - Subtasks:
     - [ ] Review ticket distribution
     - [ ] Review project assignments
     - [ ] Review customer assignments
     - [ ] Identify receiving engineers
     - [ ] Approve timeline

### Milestone 2: Knowledge Transfer (Day 1 - Notice Period)

**Tasks:**

3. **Document Active Tickets**
   - Assignee: Departing Employee
   - Duration: 2 days
   - Priority: High
   - Subtasks:
     - [ ] Add context to all open tickets
     - [ ] Document customer-specific issues
     - [ ] Identify dependencies
     - [ ] Flag critical items

4. **Document Project Status**
   - Assignee: Departing Employee
   - Duration: 2 days
   - Priority: High
   - Subtasks:
     - [ ] Update all project task statuses
     - [ ] Document project context
     - [ ] Identify blockers
     - [ ] Create project handoff notes

5. **Create Customer Transition Documents**
   - Assignee: Departing Employee
   - Duration: 3-5 days
   - Priority: High
   - Subtasks:
     - [ ] Complete transition doc for Customer 1
     - [ ] Complete transition doc for Customer 2
     - [ ] Complete transition doc for Customer N
     - [ ] Review docs with receiving engineers

6. **Knowledge Transfer Meetings**
   - Assignee: Departing Employee + Receiving Engineers
   - Duration: Ongoing
   - Priority: High
   - Subtasks:
     - [ ] Schedule KT sessions
     - [ ] Ticket walkthrough
     - [ ] Project walkthrough
     - [ ] Customer environment tours
     - [ ] Q&A sessions

### Milestone 3: Access Management (Last Working Day)

**Tasks:**

7. **Execute Access Revocation Checklist**
   - Assignee: IT Manager
   - Duration: 4 hours
   - Priority: Critical
   - Scheduled: Last working day at 5 PM
   - Subtasks:
     - [ ] Microsoft Entra ID / M365
     - [ ] Security tools (RocketCyber, ConnectSecure, Keeper)
     - [ ] RMM/PSA (Datto, Zoho)
     - [ ] Network infrastructure
     - [ ] Cloud platforms
     - [ ] Client environment access
     - [ ] Document access revocation completion

8. **Collect Physical Assets**
   - Assignee: IT Manager / Office Manager
   - Duration: 1 hour
   - Priority: High
   - Scheduled: Last working day
   - Subtasks:
     - [ ] Laptop/workstation
     - [ ] Mobile devices
     - [ ] Security keys
     - [ ] Access cards
     - [ ] Update asset inventory

### Milestone 4: Reassignment & Transition (Last Day + 1-7 days)

**Tasks:**

9. **Reassign All Tickets**
   - Assignee: IT Manager
   - Duration: 2 hours
   - Priority: High
   - Subtasks:
     - [ ] Execute Zoho Desk bulk reassignment
     - [ ] Add transition notes to tickets
     - [ ] Update customer-facing comments
     - [ ] Notify receiving engineers

10. **Transfer Project Tasks**
    - Assignee: Direct Manager
    - Duration: 2 hours
    - Priority: High
    - Subtasks:
      - [ ] Reassign all active tasks
      - [ ] Update project ownership
      - [ ] Add transition notes
      - [ ] Notify project stakeholders

11. **Execute Customer Transitions**
    - Assignee: Departing Employee (if available) or IT Manager
    - Duration: 3-5 days
    - Priority: Critical
    - Subtasks:
      - [ ] Send customer introduction emails
      - [ ] Schedule transition calls (if needed)
      - [ ] Update CRM/documentation
      - [ ] Update RMM contact assignments
      - [ ] Monitor first interactions

12. **Verify OneNote/Documentation Transfer**
    - Assignee: IT Manager
    - Duration: 1 hour
    - Priority: Medium
    - Subtasks:
      - [ ] Transfer notebook ownership
      - [ ] Verify documentation completeness
      - [ ] Grant manager access
      - [ ] Archive employee-specific notes

### Milestone 5: Monitoring & Validation (Days 1-30 post-departure)

**Tasks:**

13. **Audit Access Revocation**
    - Assignee: IT Manager
    - Duration: 2 hours
    - Priority: High
    - Scheduled: Day 1 post-departure
    - Subtasks:
      - [ ] Run access audit script
      - [ ] Verify zero active sessions
      - [ ] Check for orphaned resources
      - [ ] Document audit results

14. **Monitor Customer Transitions**
    - Assignee: IT Manager
    - Duration: Ongoing (30 days)
    - Priority: Medium
    - Subtasks:
      - [ ] Week 1: Review all customer interactions
      - [ ] Week 2: Check-in with receiving engineers
      - [ ] Week 3: Assess customer satisfaction
      - [ ] Week 4: Identify any issues
      - [ ] Document lessons learned

15. **Complete Exit Interview**
    - Assignee: HR
    - Duration: 1 hour
    - Priority: Medium
    - Subtasks:
      - [ ] Schedule exit interview
      - [ ] Conduct interview
      - [ ] Document feedback
      - [ ] Share relevant feedback with IT

16. **Finalize Off-boarding**
    - Assignee: IT Manager
    - Duration: 1 hour
    - Priority: High
    - Subtasks:
      - [ ] Verify all tasks completed
      - [ ] Close Zoho Desk ticket
      - [ ] Archive project documentation
      - [ ] Update off-boarding metrics
      - [ ] Process improvement recommendations

## Custom Fields

Create these custom fields in Zoho Projects:

- **Employee ID:** [Text]
- **Employee Email:** [Text]
- **Departure Type:** [Picklist: Resignation, Termination, Retirement]
- **Last Working Day:** [Date]
- **Ticket Count:** [Number]
- **Project Count:** [Number]
- **Customer Count:** [Number]
- **Transition Status:** [Picklist: Planning, In Progress, Monitoring, Complete]

## Project Milestones

1. **Initiation Complete** - Day 1
2. **Knowledge Transfer Complete** - Day [Notice Period - 1]
3. **Access Revoked** - Last Working Day
4. **Reassignment Complete** - Last Day + 3
5. **Transition Validated** - Last Day + 30

## Gantt Chart View

Configure Gantt chart to show:
- Task dependencies
- Critical path (access revocation and customer transitions)
- Resource allocation
- Milestone markers

## Reports to Enable

1. **Task Progress Report**
   - Shows completion percentage by milestone
   - Identifies overdue tasks
   - Daily/weekly summary

2. **Time Tracking Report**
   - Tracks actual time spent on off-boarding
   - Useful for process improvement

3. **Resource Utilization**
   - Shows workload of receiving engineers
   - Helps balance reassignments

## Notifications & Alerts

### Email Notifications

**On Project Creation:**
- Notify IT Manager, Direct Manager, HR

**On Task Assignment:**
- Notify assigned engineer with task details

**Task Due Date Approaching:**
- Notify assignee 1 day before due date

**Critical Task Overdue:**
- Notify assignee and IT Manager immediately

**Milestone Completion:**
- Notify all project members

### Automation Rules

**Rule 1: Access Revocation Reminder**
- Trigger: Last Working Day at 2 PM
- Action: Send reminder to IT Manager

**Rule 2: Customer Transition Status**
- Trigger: Customer introduction email sent
- Action: Update transition status field

**Rule 3: Project Closure**
- Trigger: All tasks marked complete
- Action: Notify stakeholders, archive project

## Integration with Automation Script

When creating off-boarding project:

1. Create project from this template
2. Update custom fields with employee details
3. Attach automation reports:
   ```bash
   python offboarding_automation.py \
     --employee [ID] --name "[NAME]" \
     --email [EMAIL] --role [ROLE]
   ```
4. Attach generated reports to project
5. Create customer-specific tasks from report
6. Update task assignments based on reassignment plan

## Task Templates for Different Roles

### Helpdesk Engineer (Full Template Above)
Includes all ticket, project, and customer transition tasks

### Administrative Staff
Focus on:
- Access revocation
- Asset collection
- Documentation transfer
- No customer transition needed

### Management
Additional tasks:
- Strategic initiative handoff
- Vendor relationship transfer
- Budget responsibility transfer
- Team leadership transition

## Collaboration Features

### Forums
- Create project forum for:
  - Knowledge transfer questions
  - Transition updates
  - Issue tracking
  - Best practice sharing

### Document Management
- Create folders:
  - `/Reports` - Automation-generated reports
  - `/Customer_Transitions` - Customer-specific docs
  - `/Access_Checklists` - Security documentation
  - `/Knowledge_Transfer` - Technical documentation

### Status Updates
- Weekly status updates required from IT Manager
- Include progress on:
  - Access revocation
  - Ticket reassignment
  - Customer transitions
  - Any blockers

## Success Metrics

Track these metrics in project:
- **Time to Complete:** Target < 30 days from last working day
- **Customer Complaints:** Target = 0
- **Missed SLAs:** Target = 0
- **Access Revocation Time:** Target < 24 hours of last day
- **Knowledge Transfer Score:** Survey receiving engineers (1-10)

## Implementation Steps

1. **Create Project Template** in Zoho Projects
   - Navigate to Templates > Create Template
   - Use structure above

2. **Configure Custom Fields**
   - Project Settings > Custom Fields
   - Add fields listed above

3. **Set Up Automation Rules**
   - Settings > Automation > Workflow Rules
   - Create rules listed above

4. **Create Email Templates**
   - Settings > Email Templates
   - Create notification templates

5. **Test Template**
   - Create test project
   - Verify all tasks, dependencies, notifications
   - Refine as needed

---

*Last Updated: 2025-11-25*
*Owner: IT Management*
*Review: After each off-boarding for continuous improvement*
