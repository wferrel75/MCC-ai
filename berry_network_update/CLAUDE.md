# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a documentation repository for the Berry Law network update project. It contains customer profile information for Berry Law, an MSP (Managed Service Provider) customer of Midwest Cloud Computing.

## Repository Structure

- `Berry_Law_questions.md` - Symlink to `../Customer_Profiles/Berry_Law_questions.md`
  - Comprehensive customer profile template for MSP assessment
  - Includes network architecture, site details, security posture, and compliance requirements

## Customer Context

**Customer:** Berry Law (John S. Berry Law, PC)
**Industry:** Legal Services / Law Firm
**Practice Areas:** Personal Injury Law, Veterans Law/Appeals, Mass Torts
**Locations:** 5 offices across Nebraska and Iowa (Omaha, Lincoln, Papillion, West Omaha, Council Bluffs)

### Key Business Requirements
- **24/7 Operations** - Emergency consultations require high availability
- **Attorney-Client Privilege** - Strict confidentiality and data protection requirements
- **Multi-State Compliance** - Subject to Nebraska and Iowa state bar regulations
- **Multi-Office Coordination** - Distributed operations across 5 locations

### Network Architecture Overview

**Hub-and-Spoke Topology:**
- **Central Hub:** RapidScale Cloud (Fortigate Virtual Firewall)
- **SD-WAN Sites:** Omaha (dual ISP), Lincoln (triple ISP) - Connected via SD-WAN VPN
- **Direct Internet Sites:** Papillion, Council Bluffs, West Omaha - No VPN tunnel

**Internet Connectivity Tiers:**
- **Lincoln:** 3x 1Gbps fiber (Cox + UPN + Allo) with SD-WAN - Highest redundancy
- **Omaha:** 2x 1Gbps fiber (Cox + UPN) with SD-WAN - High redundancy
- **Papillion:** 1x 1Gbps fiber (Cox) without VPN - Adequate but no redundancy
- **West Omaha, Council Bluffs:** Cox cable modem (speed TBD) without VPN - Limited tier

**Network Equipment:**
- **Omaha/Lincoln:** VMWare Edge Pairs, multiple switches, access points
- **Papillion:** Fortigate 40F, switches, access points
- **Council Bluffs:** Meraki Z3 (integrated wireless, no switches)
- **West Omaha:** Configuration details needed

### Critical Security Considerations

1. **Branch offices without VPN** (Papillion, Council Bluffs, West Omaha) represent potential security/compliance risk for attorney-client communications
2. **Attorney-client privilege** requires encrypted communications and DLP policies
3. **Multi-state practice** may have different regulatory requirements (NE and IA)
4. **24/7 operations** demand reliable connectivity and system availability
5. **High-stakes cases** require secure document handling and access controls

### Key Opportunities for Improvement

**Network Security:**
- Extend SD-WAN VPN connectivity to all branch offices
- Document and assess West Omaha office configuration
- Standardize switch naming conventions
- Implement consistent security policies across all locations

**Connectivity:**
- Upgrade cable modem sites (West Omaha, Council Bluffs) to fiber
- Add backup ISPs to branch offices for redundancy
- Document actual speeds for cable modem connections

**Compliance:**
- Ensure encrypted communications between all offices
- Implement DLP policies for client data protection
- Evaluate backup/DR strategy for legal documents
- Address security risk of direct internet access at branches

## Working with this Repository

When updating or analyzing this customer profile:
- Maintain the structured YAML format for site details
- Keep checklist format for tracking completion status
- Preserve attorney-client privilege and confidentiality context
- Document all network equipment with specific models and naming conventions
- Note any security or compliance implications of proposed changes
