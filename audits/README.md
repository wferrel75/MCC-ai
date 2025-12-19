# MCC User Account & Access Level Audit System

## Overview

This directory contains research, planning, and implementation components for automated user account and access level auditing across the Midwest Cloud Computing (MCC) MSP technology stack.

## Purpose

Build a modular, automated auditing system that:
- Reports on user accounts across all MCC service platforms
- Tracks access levels and permissions
- Provides centralized visibility into user access across the technology stack
- Enables compliance reporting and security auditing
- Supports customer onboarding/offboarding validation

## Architecture

### Orchestration
- **Primary:** n8n workflow automation platform
- **Secondary:** Linux command-line tools and AI agent calls
- **Design:** Modular components per product with central aggregation

### Data Flow
1. Individual product audit modules collect user/access data via APIs
2. Data normalized to common schema
3. Aggregated in central reporting database/datastore
4. Reports generated on-demand or scheduled

## Technology Stack Coverage

This audit system covers the following platforms (16 total):

### Core MSP Tools
1. **Datto RMM** - Remote monitoring and management platform
2. **Zoho Desk** - Ticketing and service management
3. **Zoho Projects** - Project management
4. **ConnectSecure (CyberCNS)** - Vulnerability and compliance management

### Security Stack
5. **RocketCyber (Kaseya MDR)** - Managed detection and response
6. **Barracuda Email Security** - Email protection and filtering
7. **Microsoft Entra ID (Azure AD)** - Identity and access management
8. **Keeper Security** - Password and secrets management
9. **KnowBe4** - Security awareness training
10. **Acronis Cyber Protect** - Backup and disaster recovery

### Infrastructure
11. **Cisco Meraki** - Cloud-managed networking
12. **Ubiquiti UniFi** - Network management and security
13. **Fortinet FortiGate** - Network security appliances

### Cloud Platforms
14. **Microsoft 365** - Productivity and collaboration
15. **Microsoft Azure** - Cloud infrastructure
16. **Amazon Web Services (AWS)** - Cloud infrastructure

## Directory Structure

```
audits/
├── README.md                           # This file - master overview
├── API_MATRIX.md                       # API capability matrix across all platforms
├── IMPLEMENTATION_ROADMAP.md           # Phased implementation plan
├── datto_rmm/                          # Datto RMM audit component
├── zoho/                               # Zoho (Desk + Projects) audit component
├── rocketcyber/                        # RocketCyber audit component
├── barracuda/                          # Barracuda Email Security audit component
├── microsoft_entra_id/                 # Entra ID / Azure AD audit component
├── keeper_security/                    # Keeper Security audit component
├── knowbe4/                            # KnowBe4 audit component
├── connectsecure/                      # ConnectSecure audit component
├── acronis/                            # Acronis Cyber Protect audit component
├── cisco_meraki/                       # Cisco Meraki audit component
├── ubiquiti_unifi/                     # Ubiquiti UniFi audit component
├── fortinet/                           # Fortinet FortiGate audit component
├── microsoft_365/                      # Microsoft 365 audit component
├── azure/                              # Azure audit component
└── aws/                                # AWS audit component
```

## Component Structure

Each product directory contains:
- `API_RESEARCH.md` - Detailed API capability research
- `ENDPOINTS.md` - Specific API endpoints for user/access auditing
- `DATA_SCHEMA.md` - Expected data structure and normalization
- `MANUAL_STEPS.md` - Required manual steps (if API gaps exist)
- `n8n_workflow.json` - n8n workflow configuration (when implemented)
- `scripts/` - Supporting scripts (PowerShell, Python, Bash)

## Implementation Status

- **Phase:** Research & Planning
- **Status:** API Capability Assessment Complete
- **Next Steps:**
  1. Document API endpoints per platform
  2. Identify manual process requirements
  3. Design common data schema
  4. Build proof-of-concept for 2-3 platforms
  5. Develop n8n orchestration workflows

## Quick Reference Links

### 🚀 Getting Started (Phase 1 - Start Here!)
- **[QUICK_START_GUIDE.md](QUICK_START_GUIDE.md)** - Your starting point, project overview
- **[PROJECT_PLAN.md](PROJECT_PLAN.md)** - Detailed 4-week Phase 1 plan (Entra ID, Keeper, ConnectSecure)
- **[PHASE1_CHECKLIST.md](PHASE1_CHECKLIST.md)** - Daily checkbox tracker for Week 1-4

### 🔧 Implementation Resources
- **[UserAudit_Master_Template.csv](UserAudit_Master_Template.csv)** - Import this to create n8n data table
- **[N8N_DATA_TABLE_SETUP.md](N8N_DATA_TABLE_SETUP.md)** - Complete table setup guide
- **[N8N_WORKFLOW_TEMPLATES.md](N8N_WORKFLOW_TEMPLATES.md)** - Ready-to-use workflow architectures with code

### 📊 Planning Documentation
- [API Capability Matrix](API_MATRIX.md) - Comprehensive comparison of API support (all 16 platforms)
- [Implementation Roadmap](IMPLEMENTATION_ROADMAP.md) - Full 4-month phased development plan

### Related MCC Documentation
- [MCC Profile](/MCC_Profile/MCC_Profile.md) - Company technology stack
- [Customer Onboarding](/customer_onboarding/) - Onboarding process documentation
- [PowerShell Automation](/powershell/) - Existing automation scripts

## Key Findings Summary

### Full API Support (10 platforms)
Platforms with comprehensive user/access APIs:
- Microsoft Entra ID (Graph API)
- Microsoft 365 (Graph API + Management Activity API)
- Microsoft Azure (ARM + RBAC APIs)
- AWS (IAM APIs)
- ConnectSecure (REST API with /r/user/get_users)
- Keeper Security (Commander CLI/SDK + REST)
- KnowBe4 (Reporting API - Platinum/Diamond tier)
- RocketCyber (API with role-based access)
- Cisco Meraki (Dashboard API)
- Zoho (Desk + Projects APIs)

### Partial API Support (3 platforms)
Platforms with limited or undocumented APIs:
- Datto RMM (API v2 exists, user management endpoints unclear)
- Ubiquiti UniFi (Unofficial API, limited documentation)
- Fortinet FortiGate (API exists, administrator management available)

### Manual Steps Required (3 platforms)
Platforms requiring manual intervention or web scraping:
- Barracuda Email Security (Limited API documentation found)
- Acronis Cyber Protect (API research incomplete)
- KnowBe4 (Requires Platinum/Diamond subscription for Reporting API)

## Next Actions

1. **Complete API endpoint documentation** for each platform
2. **Design unified data schema** for normalized reporting
3. **Identify credential/authentication requirements** per platform
4. **Build proof-of-concept** for 2-3 high-priority platforms
5. **Develop n8n orchestration workflow** for data collection
6. **Create reporting dashboard** for aggregated data

## Notes

- Some APIs require specific licensing tiers (e.g., KnowBe4 requires Platinum/Diamond)
- Multi-tenant platforms (ConnectSecure, RocketCyber) require tenant-specific authentication
- Cloud platforms (Azure, AWS) may require cross-account/subscription access patterns
- Consider rate limiting and API quotas in implementation

---

*Last Updated: 2025-12-17*
*Status: Research Phase*
