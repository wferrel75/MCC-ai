# User Account Audit System - Quick Start Guide

## What Is This?

An automated system to audit user accounts and access levels across all 16 platforms in MCC's technology stack, providing centralized visibility for security, compliance, and user lifecycle management.

## Quick Reference

### Platform API Status at a Glance

| Status | Count | Platforms |
|--------|-------|-----------|
| ✅ Full API | 10 | Entra ID, M365, Azure, AWS, ConnectSecure, Keeper, KnowBe4*, RocketCyber, Meraki, Zoho |
| ⚠️ Partial API | 3 | Datto RMM, UniFi, FortiGate |
| ❌ Manual Steps | 3 | Barracuda, Acronis, KnowBe4* |

*KnowBe4 API requires Platinum/Diamond subscription

### Implementation Timeline

| Phase | Duration | Platforms | Status |
|-------|----------|-----------|--------|
| Phase 1: Foundation | 4 weeks | 3 (Entra ID, ConnectSecure, Meraki) | Not Started |
| Phase 2: Core | 4 weeks | 7 (M365, RocketCyber, Keeper, etc.) | Not Started |
| Phase 3: Partial | 4 weeks | 4 (Datto, UniFi, FortiGate, Azure) | Not Started |
| Phase 4: Manual | 2 weeks | 3 (Barracuda, Acronis, KnowBe4) | Not Started |
| Phase 5: Enhancement | 2 weeks | All | Not Started |

**Total Timeline:** ~4 months

## What You'll Get

### Automated Data Collection
- Daily/weekly scheduled audits
- User accounts from all platforms
- Access levels and roles
- Last login information
- MFA status (where available)
- License assignments

### Unified Reporting
- Single dashboard for all platforms
- Cross-platform user comparison
- Anomaly detection
- Compliance reporting
- Export capabilities

### Alerting
- New user account notifications
- Privilege escalation detection
- Stale account identification
- Failed audit alerts

## Getting Started

### ✅ Project Status: APPROVED AND ASSIGNED

**Project Owner:** wferrel (all roles - Project Lead, Developer, Admin, Tester)
**Phase 1 Platforms:** Microsoft Entra ID, Keeper Security, ConnectSecure
**Start Date:** December 18, 2024
**Target Completion:** January 14, 2025 (4 weeks)

### Your Next Steps

#### This Week (Week 1: Dec 18-24)
1. **Read the detailed plan:** [PROJECT_PLAN.md](PROJECT_PLAN.md)
2. **Set up infrastructure:**
   - [ ] Access n8n at https://n8n.midcloudcomputing.com/
   - [ ] Create workflow folder: "User Audit System"
   - [ ] **Create n8n Data Table: "UserAudit_Master"**
     - 📥 **Import this CSV:** [UserAudit_Master_Template.csv](UserAudit_Master_Template.csv)
     - 📖 **Setup Guide:** [N8N_DATA_TABLE_SETUP.md](N8N_DATA_TABLE_SETUP.md)
   - [ ] **Review workflow templates:** [N8N_WORKFLOW_TEMPLATES.md](N8N_WORKFLOW_TEMPLATES.md)
   - [ ] Document credential storage approach
3. **Gather credentials:**
   - [ ] Azure AD tenant access (create app registration)
   - [ ] Keeper Security API credentials
   - [ ] ConnectSecure credentials (check existing workflows)

#### Week 2 (Dec 25-31): Microsoft Entra ID
- [ ] Create app registration in Azure Portal
- [ ] Build n8n workflow for authentication
- [ ] Implement user collection with Graph API
- [ ] Test data transformation and storage

#### Week 3 (Jan 1-7): Keeper Security
- [ ] Review Keeper API documentation
- [ ] Build n8n workflow for Keeper
- [ ] Implement user and role collection
- [ ] Test and schedule

#### Week 4 (Jan 8-14): ConnectSecure + Reports
- [ ] Use existing ConnectSecure workflow patterns
- [ ] Build user audit workflow
- [ ] Create basic reports (user counts, MFA status)
- [ ] Test all 3 platforms end-to-end

### Quick Access to Your Plan
- **Detailed Week-by-Week Plan:** [PROJECT_PLAN.md](PROJECT_PLAN.md)
- **API Research for Your 3 Platforms:**
  - [Entra ID](microsoft_entra_id/API_RESEARCH.md)
  - [Keeper Security](keeper_security/API_RESEARCH.md)
  - [ConnectSecure](connectsecure/API_RESEARCH.md)

## Key Documents by Role

### For Management
- **Executive Summary:** [README.md](README.md) - Overview and business value
- **Timeline and Cost:** [IMPLEMENTATION_ROADMAP.md](IMPLEMENTATION_ROADMAP.md) - Phased approach
- **ROI Analysis:** See "Business Value" section in roadmap

### For Technical Lead
- **API Capabilities:** [API_MATRIX.md](API_MATRIX.md) - Complete API analysis
- **Implementation Plan:** [IMPLEMENTATION_ROADMAP.md](IMPLEMENTATION_ROADMAP.md) - Detailed phases
- **Platform Research:** Individual directories (e.g., `connectsecure/API_RESEARCH.md`)

### For Developers
- **API Research:** Platform-specific `API_RESEARCH.md` files
- **Data Schema:** [API_MATRIX.md](API_MATRIX.md) - Normalization section
- **n8n Examples:** Existing ConnectSecure workflows in `/n8n-workflows/`

### For Admins (Manual Processes)
- **Barracuda:** `barracuda/API_RESEARCH.md` - Manual process section
- **Manual Steps:** `barracuda/MANUAL_STEPS.md` (to be created in Phase 4)
- **Templates:** Manual audit templates (to be created)

## Priority Actions

### This Week
1. **Review and approve** this documentation
2. **Schedule kickoff meeting** with stakeholders
3. **Identify team members** (developer, admin)

### Next Week
1. **Allocate resources** for Phase 1
2. **Set up project tracking** (Zoho Projects?)
3. **Begin Phase 1 development**

### This Month
1. **Complete Phase 1** (3 platforms integrated)
2. **Validate approach** and adjust as needed
3. **Plan Phase 2** execution

## Frequently Asked Questions

### Q: How long will this take?
**A:** ~4 months for full implementation across all 16 platforms. Phase 1 (proof of concept) takes ~1 month.

### Q: What resources are needed?
**A:** 1 developer part-time (50%), 1 admin minimal time (5-10%) for manual processes.

### Q: What if a platform doesn't have an API?
**A:** We've identified manual processes for platforms without APIs (Barracuda, Acronis). These are acceptable given low change frequency.

### Q: Can we start with fewer platforms?
**A:** Yes! Phase 1 starts with just 3 platforms to prove the concept. Expand from there.

### Q: What technology will we use?
**A:** n8n for orchestration (already in use at MCC), database for storage (n8n Tables or Postgres).

### Q: How much will this cost?
**A:** Primary cost is developer time (~140-220 hours). Infrastructure costs minimal (existing n8n instance).

### Q: What about data privacy?
**A:** User data is sensitive. We'll implement encryption, access controls, retention policies, and comply with privacy regulations.

### Q: Can this integrate with our ticketing system?
**A:** Yes! Phase 5 includes Zoho Desk integration for alerts and anomaly tickets.

### Q: What if APIs change?
**A:** We'll implement robust error handling, monitoring, and version management. Regular testing will catch changes.

### Q: Is this compliant with regulations?
**A:** System supports compliance reporting. Actual compliance depends on data handling procedures (to be documented).

## Common Data Schema

All platforms normalize to this structure:

```json
{
  "source_platform": "Platform Name",
  "user_id": "unique-id",
  "username": "username",
  "email": "email@example.com",
  "display_name": "First Last",
  "first_name": "First",
  "last_name": "Last",
  "account_enabled": true,
  "account_created": "2023-01-01T00:00:00Z",
  "last_login": "2023-12-15T10:30:00Z",
  "mfa_enabled": true,
  "roles": ["Role1", "Role2"],
  "permissions": ["permission1", "permission2"],
  "licenses": ["License1"],
  "tenant_id": "customer-id",
  "last_audit_date": "2023-12-17T00:00:00Z"
}
```

## Success Criteria

### Phase 1 Success
- [ ] 3 platforms collecting data automatically
- [ ] Data normalized and stored
- [ ] Basic reports available
- [ ] Scheduled execution working
- [ ] Error handling functional

### Overall Success
- [ ] 13+ platforms automated (10 full API + 3 partial)
- [ ] 3 manual processes documented
- [ ] Daily/weekly audit execution
- [ ] Unified dashboard operational
- [ ] Alerting system functional
- [ ] Documentation complete
- [ ] Team trained

## Risk Mitigation

### Top Risks
1. **API Rate Limiting** → Implement backoff, stagger calls
2. **Token Expiry** → Auto-refresh logic
3. **Schema Changes** → Version management, monitoring
4. **Data Privacy** → Encryption, access control, retention policies
5. **Manual Process Gaps** → Automated reminders, escalation

## Support and Contact

### Internal Resources
- **Project Lead:** [To be assigned]
- **Developer:** [To be assigned]
- **Admin (Manual Processes):** [To be assigned]

### Documentation Location
- **Primary:** `/home/wferrel/ai/audits/`
- **Related:** `/home/wferrel/ai/MCC_Profile/`
- **n8n Workflows:** `/home/wferrel/ai/n8n-workflows/`

### External Support
- **Vendor Support:** Contact individual platform vendors for API issues
- **Community:** n8n community forums for workflow questions

## Next Steps

1. ✅ **Research Complete** - API capabilities documented
2. ⏭️ **Management Review** - Approve scope and timeline
3. ⏭️ **Resource Allocation** - Assign team members
4. ⏭️ **Phase 1 Kickoff** - Begin development
5. ⏭️ **Iterative Development** - Build, test, refine, repeat

---

## Platform-Specific Quick Links

### Full API Support (Ready to Implement)
- [Microsoft Entra ID](microsoft_entra_id/API_RESEARCH.md) - Identity foundation
- [ConnectSecure](connectsecure/API_RESEARCH.md) - Security compliance
- [Cisco Meraki](cisco_meraki/) - Network infrastructure
- [Microsoft 365](microsoft_365/) - Productivity suite
- [RocketCyber](rocketcyber/) - Security monitoring
- [Keeper Security](keeper_security/) - Password management
- [KnowBe4](knowbe4/) - Security training
- [Zoho](zoho/) - PSA/ticketing
- [AWS](aws/) - Cloud infrastructure
- [Azure](azure/) - Cloud infrastructure

### Partial API Support (Research Required)
- [Datto RMM](datto_rmm/API_RESEARCH.md) - RMM platform (investigate Swagger UI)
- [Ubiquiti UniFi](ubiquiti_unifi/) - Network management (unofficial API)
- [Fortinet FortiGate](fortinet/) - Network security (version-dependent)

### Manual Process Required
- [Barracuda](barracuda/API_RESEARCH.md) - Email security (manual audit)
- [Acronis](acronis/) - Backup/DR (research needed)

---

**Ready to Start?** Begin with [IMPLEMENTATION_ROADMAP.md](IMPLEMENTATION_ROADMAP.md) Phase 1.

*Last Updated: 2025-12-17*
*Status: Research Complete - Ready for Implementation*
