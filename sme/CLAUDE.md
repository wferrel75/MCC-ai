# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a documentation repository for **Midwest Cloud Computing (MCC)**, a Managed Service Provider (MSP) focused on small to medium-sized businesses. The repository contains customer profiles, team assignments, and organizational information.

## Repository Structure

```
/home/wferrel/ai/sme/
├── customer_smes.md              # SME (Subject Matter Expert) assignments for each customer
├── Customer_Profiles/            # Symlink to ../Customer_Profiles
│   ├── Customer-questions.md     # Customer profile template
│   └── [Customer]_questions.md   # Individual customer profiles
├── MCC_Profile/                  # Symlink to ../MCC_Profile
│   └── MCC_Profile.md           # Company profile and technology stack
└── team/                         # Symlink to ../team
    └── [team_member].yaml       # Individual team member files
```

## Key Concepts

### Customer Profile System

Customer profiles use a standardized template (`Customer-questions.md`) covering:
- Business overview and objectives
- User profiles and distribution
- Office and site information
- Network infrastructure
- Microsoft 365 licensing and services
- Security and compliance requirements
- Telephony and communication systems
- Backup and disaster recovery
- Budget and timeline information

### SME Assignment Model

The `customer_smes.md` file maps customers to technical team members:
- **Primary SME**: Main point of contact and technical lead
- **Backup SME**: Secondary contact for coverage and continuity

Current team structure:
- Dave Lange (Primary SME for 8 customers)
- Kody Irwin (Backup SME for Dave's customers)
- Reagan Kroh (Primary SME for 8 customers)
- Mike Hale (Backup SME for Reagan's customers)
- Mike Hurlburt (Primary SME for 8 customers)
- Wes Ferrel (Backup SME for Mike Hurlburt's customers)

### Technology Stack

MCC uses a multi-vendor approach documented in `MCC_Profile/MCC_Profile.md`:

**Core Platforms:**
- RMM: Datto RMM
- PSA: Zoho Desk and Zoho Projects
- EDR/MDR: RocketCyber (Kaseya)
- Email Security: Barracuda
- Backup: Acronis Cyber Protect
- Security Training: KnowBe4
- Vulnerability Management: ConnectSecure
- Password Management: Keeper Security

**Network Infrastructure:**
- Cisco Meraki (cloud-managed)
- Ubiquiti UniFi (cost-effective)
- Fortinet FortiGate

**Cloud Platforms:**
- Microsoft 365 / Azure
- AWS

**Virtualization:**
- VMware vSphere
- Microsoft Hyper-V

## File Naming Conventions

- Customer profiles: `[Customer_Name]_questions.md`
- Team members: `[firstname]_[lastname].yaml`
- Use underscores for spaces in names
- Preserve consistent capitalization

## Working with Customer Profiles

When creating or updating customer profiles:

1. **Start from the template**: Use `Customer_Profiles/Customer-questions.md` as the base
2. **Follow the structure**: Maintain all sections even if incomplete (mark as TBD)
3. **Industry context matters**: Healthcare customers (e.g., Crowell) require HIPAA considerations
4. **Update timestamps**: Always update "Last Updated" field with date and changes made
5. **Document dependencies**: Note relationships between services (e.g., AD Connect status affects hybrid configuration)
6. **Include technical details**: Firmware versions, IP schemes, VLAN configurations are important for troubleshooting

### Critical Sections

Priority information for troubleshooting and project planning:
- Microsoft 365 licensing (SKU and count)
- Active Directory configuration (hybrid status, AD Connect)
- Security posture (MFA coverage, Conditional Access policies)
- Backup strategy (frequency, retention, testing)
- Network infrastructure (firewall vendor/model, VPN solution)

## Common Workflows

### Adding a New Customer

1. Create `Customer_Profiles/[Customer_Name]_questions.md` from template
2. Add SME assignment to `customer_smes.md`
3. Document initial profile completion date
4. Schedule 30-day review

### Updating SME Assignments

When modifying `customer_smes.md`:
- Maintain YAML-like structure with dashes and indentation
- Include both primary_sme and backup_sme for each customer
- Verify team member exists in `team/` directory

### Documenting Major Changes

For significant customer environment changes, update:
- Customer profile with technical details
- "Last Updated" field with date and summary
- Relevant sections (e.g., M365 licenses, server inventory)

## MCC Company Values

When making recommendations or documentation decisions, align with MCC's core principles:
1. **Customer-Centric Approach**: Focus on what benefits the customer
2. **Empowerment Over Dependency**: Document to enable customer understanding
3. **Transparent Communication**: Be clear about limitations and unknowns (use TBD)
4. **Partnership Mindset**: Long-term relationship focus
5. **Lean Operations**: Efficient, internet-dependent service delivery

## Special Considerations

### Healthcare Customers

Customers like Crowell Memorial Home require:
- HIPAA compliance considerations
- 24/7 availability due to critical care operations
- Enhanced security documentation
- Backup and DR planning for patient care systems
- Special attention to PHI (Protected Health Information) handling

### Multi-Site Deployments

For customers with multiple locations:
- Document inter-site connectivity (MPLS, VPN, SD-WAN)
- Track site-specific bandwidth and ISP details
- Note geographic distribution in YAML format
- Consider disaster recovery implications

### Legacy System Migrations

When documenting systems:
- Note end-of-life status (e.g., Server 2008 R2)
- Track hybrid configurations during cloud migrations
- Document Azure AD Connect deployment status
- Plan for gradual migrations vs. big-bang approaches

## Repository Notes

- This repository uses symlinks to organize related content from parent directories
- Git tracks changes to customer profiles for audit purposes
- File permissions vary (some customer files are read-protected)
- The repository is part of a larger `/home/wferrel/ai/` workspace structure
