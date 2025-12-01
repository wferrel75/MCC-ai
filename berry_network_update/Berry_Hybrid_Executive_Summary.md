# Berry Law - Network Security Modernization
## Executive Summary: Hybrid Cloud Firewall Architecture

**Prepared For:** Berry Law Leadership Team
**Prepared By:** Midwest Cloud Computing
**Date:** November 20, 2025
**Project:** RapidScale/VMWare Migration to Palo Alto Azure + Meraki Local Architecture

---

## Executive Overview

Berry Law's current network infrastructure relies on third-party RapidScale cloud services and a fragmented mix of VMWare, Fortigate, and Meraki devices. This creates security gaps, compliance risks, and operational complexity that pose significant risks to your law firm's ability to protect attorney-client privileged information.

**We recommend a hybrid architecture** that combines best-in-class cloud security from Palo Alto Networks with cost-effective Cisco Meraki firewalls at each office. This approach delivers enterprise-grade protection for your attorneys and staff while significantly reducing costs compared to alternatives.

**Bottom Line:**
- **Total Investment:** $155K-238K (Year 1) with $25K-47K annual recurring costs
- **Cost Savings:** $55K-97K lower than pure Palo Alto in Year 1; $150K-250K savings over 3 years
- **Timeline:** 18 weeks from approval to full deployment
- **Risk Level:** Low to Medium (phased implementation minimizes disruption)

---

## Current State: Problems and Risks

### Security and Compliance Gaps

**Critical Issue: Unencrypted Branch Offices**
- Papillion, West Omaha, and Council Bluffs offices have direct internet access without VPN encryption
- Violates attorney-client privilege protection requirements under Nebraska and Iowa state bar rules
- Potential ethics violation and malpractice exposure
- No data loss prevention (DLP) for sensitive client information

**Vendor Fragmentation**
- VMWare Edge (Omaha, Lincoln) + Fortigate (Papillion) + Meraki Z3 (Council Bluffs) + Unknown (West Omaha)
- Multiple management platforms increase complexity and human error risk
- Inconsistent security policies across locations
- Difficulty troubleshooting cross-vendor issues

**Third-Party Dependency**
- RapidScale provides critical security hub - vendor lock-in
- Limited control over security policies and updates
- No visibility into cloud application usage (Office 365, legal software, etc.)
- Potential service discontinuation risk

### Operational Challenges

- **24/7 Operations Requirement:** Current architecture lacks redundancy at branch offices
- **Multi-Office Coordination:** No centralized visibility across 5 locations
- **Cloud Application Blind Spots:** Cannot identify shadow IT or unauthorized data uploads
- **Management Overhead:** Multiple vendor platforms require specialized expertise

---

## Recommended Solution: Hybrid Architecture

### Two-Tier Security Strategy

Our recommended hybrid approach separates **high-value user security** from **low-risk infrastructure protection**, applying appropriate security controls to each:

#### Tier 1: User Endpoint Security (Palo Alto in Azure)
**Who:** All attorneys, staff, and remote workers (workstations and laptops)
**How:** GlobalProtect always-on VPN to Azure-based Palo Alto firewall
**Security Features:**
- SSL/TLS inspection to detect data exfiltration in encrypted traffic
- App-ID technology identifies and controls 5,000+ cloud applications
- Data Loss Prevention (DLP) prevents unauthorized sharing of client information
- Advanced threat prevention (IPS, anti-malware, WildFire cloud analysis)
- URL filtering and DNS security

**Why:** Attorneys and staff handle sensitive client data and are primary targets for cyberattacks. They require enterprise-grade security with attorney-client privilege protection.

#### Tier 2: Infrastructure Device Security (Cisco Meraki at Each Office)
**What:** Printers, IP phones, security cameras, servers, IoT devices
**How:** Local Cisco Meraki MX firewalls at each office
**Security Features:**
- Basic threat protection (IDS/IPS, content filtering)
- Meraki Auto VPN for site-to-site connectivity (zero-touch configuration)
- Dual ISP failover for business continuity
- Cloud-managed dashboard (simple, no on-premises management)

**Why:** Infrastructure devices don't browse risky websites or handle client data directly. Basic security is appropriate and cost-effective.

---

## Business Benefits

### 1. Attorney-Client Privilege Protection (Compliance)

**Problem Solved:** All branch offices currently have unencrypted direct internet access

**Solution:**
- All user traffic encrypted via GlobalProtect VPN (meets NE and IA bar requirements)
- DLP policies prevent unauthorized uploads of client information to personal cloud storage
- Complete audit trail for all data access and transfers
- Demonstrates due diligence for client data protection

**Business Impact:** Eliminates ethics violation risk and potential malpractice exposure

### 2. Operational Control and Visibility

**Problem Solved:** RapidScale third-party dependency and limited visibility

**Solution:**
- Direct control over all security policies and configurations
- Centralized visibility into cloud application usage across all users
- Identify shadow IT (unauthorized apps) and enforce approved-app policies
- Real-time threat intelligence and automated blocking

**Business Impact:** Better security posture with immediate response to threats, no vendor dependency

### 3. Simplified Management

**Problem Solved:** Four different firewall vendors creating complexity

**Solution:**
- Cisco Meraki cloud dashboard manages all office firewalls (no on-premises management)
- Meraki Auto VPN establishes site-to-site connectivity automatically (zero-touch)
- Palo Alto centrally managed in Azure (no firewall hardware at offices for user security)
- Reduced troubleshooting time and human error

**Business Impact:** Lower IT management costs, faster problem resolution, easier to scale

### 4. Cost Optimization

**Problem Solved:** Enterprise security is expensive, especially for small offices

**Solution:**
- Right-sized security for each device class (advanced for users, basic for printers)
- Meraki hardware costs 85% less than equivalent Palo Alto office firewalls
- Meraki licensing costs 88% less than Palo Alto over 3 years
- Eliminate small-office firewall hardware at West Omaha and Council Bluffs (future option)

**Business Impact:** $150K-250K savings over 3 years vs. pure Palo Alto, with same user security

### 5. Business Continuity

**Solution:**
- High availability (HA) firewalls at critical Omaha office (automatic failover)
- Dual ISP redundancy at Omaha (Cox + UPN), triple ISP at Lincoln (Cox + UPN + Allo)
- Azure HA for cloud firewall (Active/Passive across availability zones)
- Dual-path architecture: If GlobalProtect has issues, infrastructure stays operational via Meraki

**Business Impact:** Supports 24/7 operations requirement with minimal downtime risk

---

## Cost Analysis

### Three-Year Total Cost of Ownership

| Solution | Year 1 | Year 2-3 (Annual) | 3-Year Total |
|----------|--------|-------------------|--------------|
| **Hybrid (PA + Meraki)** | **$155K-238K** | **$25K-47K** | **$205K-332K** |
| Pure Palo Alto | $210K-335K | $36K-68K | $282K-471K |
| **Savings (Hybrid)** | **$55K-97K** | **$11K-21K** | **$77K-139K** |

### Year 1 Investment Breakdown (Hybrid Approach)

**Hardware (One-Time):**
- Cisco Meraki MX firewalls (all 5 offices): $11,400
- Palo Alto Azure VM-Series (BYOL): $60,000-90,000
- **Subtotal Hardware:** $71,400-101,400

**Software Licensing (Annual):**
- Meraki Advanced Security (3-year prepaid): $10,800 ($3,600/year equivalent)
- Palo Alto subscriptions and support: $15,000-25,000
- Azure infrastructure (compute, storage, bandwidth): $6,000-18,000
- **Subtotal Licensing (Year 1):** $31,800-53,800

**Professional Services (One-Time):**
- Design, planning, implementation, training: $52,000-83,000

**Year 1 Total:** $155,200-238,200

### Ongoing Costs (Years 2+)
- Meraki licensing (if not prepaid): $4,250/year
- Palo Alto subscriptions: $15,000-25,000/year
- Azure infrastructure: $6,000-18,000/year
- **Annual Total:** $25,250-47,250/year

### Alternative: Pure Meraki (Not Recommended)

**Cost:** ~$25K-40K total investment
**Why Not Recommended:** Meraki cannot provide SSL inspection or DLP required for attorney-client privilege protection. Does not meet legal industry security standards.

---

## Implementation Timeline

**Total Duration:** 18 weeks (4.5 months) from approval to completion

### Phase Overview

**Weeks 1-3: Planning and Preparation**
- Finalize design and user/device counts
- Order hardware and licenses
- Lab testing and configuration preparation

**Weeks 4-5: Azure Cloud Firewall Deployment**
- Deploy Palo Alto VM-Series in Azure
- Configure GlobalProtect VPN gateway
- Pilot testing with select users

**Weeks 6-12: Office Deployments (Sequential)**
- Week 6-7: Omaha (MX95 HA + GlobalProtect rollout)
- Week 8-9: Lincoln (MX95/85 + GlobalProtect rollout)
- Week 10: Papillion (MX75 + GlobalProtect rollout)
- Week 11: West Omaha (MX68 + GlobalProtect rollout)
- Week 12: Council Bluffs (MX68 replaces Z3 + GlobalProtect rollout)

**Week 13: Remote Users**
- GlobalProtect deployment to all remote workers

**Weeks 14-15: Security Policy Refinement**
- Cloud application control policies
- SSL inspection and DLP configuration
- Testing and tuning

**Week 16: RapidScale Decommissioning**
- Final cutover and RapidScale contract cancellation

**Weeks 17-18: Monitoring, Training, and Handoff**
- Set up monitoring and alerting
- Train staff and help desk
- Project handoff to managed services

**Maintenance Windows:** Evening/weekend deployments to minimize business disruption

---

## Risk Assessment

### Implementation Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| User VPN connectivity issues | Medium | High | Extensive pilot testing; help desk training; temporary fallback options |
| Downtime during office migrations | Medium | Medium | Evening/weekend maintenance; phased rollout; rollback plans |
| Dual-vendor complexity | Low-Medium | Low | Meraki is simple cloud-managed; clear separation of responsibilities |
| Cost overruns | Low-Medium | Medium | Fixed Meraki pricing; Azure cost monitoring; 15-20% contingency |

### Post-Implementation Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Azure PA outage | Low | High | HA configuration (99.99% SLA); temporary Meraki fallback for critical users |
| Meraki cloud dashboard outage | Very Low | Low | Firewalls continue operating; outages typically <1 hour |
| Security policy misconfiguration | Low | Medium | Change management process; configuration backups; testing procedures |

**Overall Risk Level:** Low to Medium - Phased implementation and proven technologies minimize risk

---

## Decision Factors: Hybrid vs. Pure Palo Alto

### Choose Hybrid (PA + Meraki) If:
✓ **Budget is a significant consideration** ($150K-250K savings over 3 years)
✓ **You want simplified office infrastructure management** (Meraki cloud dashboard)
✓ **You want zero-touch site-to-site VPN** (Meraki Auto VPN)
✓ **Infrastructure devices are appropriately treated as low-risk** (printers, phones)
✓ **You want to minimize on-premises firewall hardware**

### Choose Pure Palo Alto If:
- You require 100% consistent security platform across all devices
- You want unified single-vendor management
- Infrastructure devices require advanced threat protection (rare for printers/phones)
- Budget allows for higher upfront investment (~$55K-97K more in Year 1)

### Our Recommendation: Hybrid Architecture

**Why:**
1. **Meets Legal Industry Requirements:** Full Palo Alto security for users (SSL inspect, DLP)
2. **Attorney-Client Privilege Compliance:** Encrypted communications and DLP meet NE/IA bar rules
3. **Cost-Effective:** $150K-250K savings over 3 years without compromising user security
4. **Operational Simplicity:** Meraki Auto VPN and cloud management reduce complexity
5. **Appropriate Security:** Advanced protection for users, basic protection for infrastructure
6. **Proven Technology:** Both Palo Alto and Meraki are industry leaders with excellent reliability

**Bottom Line:** Hybrid delivers the same user security as pure Palo Alto at significantly lower cost.

---

## Next Steps

### Immediate Actions Required

1. **Executive Decision** (This Week)
   - Review this executive summary
   - Approve hybrid architecture approach
   - Authorize budget ($155K-238K Year 1)

2. **Technical Validation** (Week 1)
   - Validate user counts and device counts per office
   - Confirm ISP details and bandwidth at all locations
   - Review VLAN design with internal IT (if applicable)

3. **Vendor Engagement** (Week 1-2)
   - Obtain formal quotes from Palo Alto partner
   - Obtain formal quotes from Cisco Meraki partner
   - Finalize licensing strategy (BYOL vs. PAYG for PA; 3-year vs. annual for Meraki)

4. **Project Kickoff** (Week 3)
   - Assign project stakeholders from Berry Law
   - Establish communication cadence (weekly status meetings)
   - Begin Phase 1: Planning and Preparation

### Questions for Discussion

1. **Budget Approval:** Is the $155K-238K Year 1 investment within approved budget?
2. **Timeline:** Is the 18-week implementation timeline acceptable? Are there blackout dates?
3. **Risk Tolerance:** Are you comfortable with phased rollout and evening/weekend maintenance windows?
4. **Alternative Consideration:** Do you want to review pure Palo Alto option despite higher cost?
5. **Stakeholder Involvement:** Who should be involved in weekly project status meetings?

---

## Supporting Documentation

Detailed technical documentation is available for review:

1. **Berry_Law_Cloud_Firewall.md** (Pure Palo Alto Architecture)
   - Full technical specifications for all-Palo Alto design
   - Detailed firewall sizing and configurations
   - Site-to-site VPN architecture
   - 17-week implementation plan
   - Cost: $210K-335K Year 1

2. **Berry_Law_Cloud_LocalMeraki.md** (Hybrid Architecture - Recommended)
   - Full technical specifications for hybrid design
   - Meraki MX sizing and Auto VPN architecture
   - VLAN design and routing strategy
   - GlobalProtect always-on VPN configuration
   - 18-week implementation plan
   - Cost: $155K-238K Year 1

3. **Berry_Law_questions.md** (Customer Profile)
   - Current network architecture documentation
   - Office locations and ISP details
   - Security and compliance requirements

---

## Contact Information

**Project Sponsor:** Midwest Cloud Computing
**Technical Lead:** [To Be Assigned]
**Account Manager:** [To Be Assigned]

**For Questions or to Schedule Review Meeting:**
- Email: [contact email]
- Phone: [contact phone]

---

## Appendix: Key Terms and Concepts

**GlobalProtect VPN:** Palo Alto's always-on VPN client that automatically connects user devices to Azure firewall for security inspection. Users experience transparent internet access while all traffic is protected.

**Meraki Auto VPN:** Cisco's zero-touch VPN technology that automatically establishes site-to-site tunnels between offices without manual configuration. Simplifies multi-office connectivity.

**App-ID:** Palo Alto technology that identifies applications regardless of port or protocol. Enables control of cloud apps (Dropbox, Zoom, etc.) even if they use HTTPS on port 443.

**SSL Inspection:** Decryption and inspection of encrypted HTTPS traffic to detect malware and data exfiltration. Required for visibility into modern internet traffic (90%+ is encrypted).

**Data Loss Prevention (DLP):** Technology that inspects file uploads and web traffic for sensitive information (client names, case numbers, etc.) and blocks unauthorized sharing. Critical for attorney-client privilege protection.

**High Availability (HA):** Redundant firewall configuration where two devices operate as a pair. If primary fails, secondary takes over automatically with no user impact.

**Warm Spare:** Meraki's HA technology where backup firewall is ready but not actively passing traffic. Takeover occurs in ~1-2 minutes if primary fails.

---

**Document Version:** 1.0
**Date:** November 20, 2025
**Status:** For Executive Review and Decision
