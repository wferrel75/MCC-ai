# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Context

This is an employee management system for Midwest Cloud Computing (MCC), an MSP serving SMBs with a focus on transparency, empowerment, and customer-centric service delivery. The company profile is available in `MCC_Profile.md`.

## Company Technology Standards

MCC's existing technology stack should inform design decisions:
- **Cloud Platform:** Microsoft 365 and Azure for primary infrastructure
- **Identity:** Microsoft Entra ID (Azure AD) for authentication/authorization
- **Security:** Multi-layered approach with EDR (RocketCyber), email security (Barracuda), and identity protection
- **Documentation:** Microsoft OneNote for knowledge management
- **RMM Platform:** Datto RMM for endpoint management
- **PSA Tools:** Zoho Desk and Zoho Projects for ticketing and project management

## Architecture Principles

When building features for this employee management system:

1. **Integration-First Design:** Plan for integration with existing MCC tools (Zoho, Microsoft 365, Datto RMM)
2. **Security by Default:** Apply MCC's multi-layered security approach (MFA, least privilege, audit logging)
3. **Lean Operations:** Follow MCC's lean operational model - avoid over-engineering
4. **Transparent Communication:** Build features that enhance transparency in operations and reporting

## Company Values to Maintain in Code

- **Customer-Centric:** Features should support empowering clients and transparency
- **Partnership Mindset:** Design for long-term maintainability and knowledge sharing
- **Lean Operations:** Minimize complexity, maximize value
- **24/7 Mindset:** Consider availability, monitoring, and alerting in design

## Current System: Employee Off-boarding

This repository contains a comprehensive employee off-boarding system with these components:

### Key Files

- **OFFBOARDING_PROCESS.md** - Complete off-boarding procedures covering core process, access revocation across all MCC systems, and role-specific workflows (especially helpdesk engineers with customer primary contact responsibilities)
- **offboarding_automation.py** - Python automation script for semi-automated off-boarding tasks including report generation, ticket/project analysis, and customer transition documentation
- **QUICK_START_GUIDE.md** - Print-ready quick reference guide for when off-boarding needs to happen
- **README.md** - Comprehensive system documentation and usage guide

### Integration Templates

- **zoho_desk_ticket_template.md** - Zoho Desk ticket template with custom fields, workflow rules, and notifications
- **zoho_projects_template.md** - Zoho Projects project template with milestones, tasks, and automation

### Configuration

- **config.json.template** - API configuration template for Zoho Desk, Zoho Projects, Microsoft Graph, and Datto RMM
- **requirements.txt** - Python dependencies for automation script

### n8n Workflow Automation

- **n8n_workflows/** - Directory containing 5 n8n workflow JSON files for full automation
  - `01_offboarding_initiation_workflow.json` - Main orchestrator
  - `02_access_revocation_workflow.json` - Microsoft 365/Entra ID automation
  - `03_ticket_reassignment_workflow.json` - Zoho Desk ticket distribution
  - `04_customer_transition_workflow.json` - Customer contact transitions
  - `05_monitoring_audit_workflow.json` - Daily compliance monitoring
- See `n8n_workflows/README.md` for setup and configuration details
- See `n8n_workflows/WORKFLOW_DIAGRAM.md` for visual workflow maps

### Running Off-boarding

```bash
# Generate full off-boarding report
python offboarding_automation.py \
  --employee [ID] --name "[NAME]" --email [EMAIL] --role helpdesk

# Generate customer transition document
python offboarding_automation.py \
  --customer-transition "[CUSTOMER]" "[DEPARTING]" "[NEW_ENGINEER]"
```

### Key Considerations

**For Helpdesk Engineers:**
- Must handle customer primary contact/SME transitions
- Requires detailed customer transition documentation
- Monitor transitions for 30 days post-departure

**Security Priority:**
- Access revocation must happen on last working day (or immediately for termination)
- Audit all access within 24 hours
- Cover all MCC technology stack (see OFFBOARDING_PROCESS.md for complete list)

**Customer Impact:**
- Minimize service disruption during transitions
- Provide personal introductions for high-touch customers
- Document customer preferences and relationship context
