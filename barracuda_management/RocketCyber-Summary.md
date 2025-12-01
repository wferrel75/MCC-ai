# RocketCyber Log Shipping Summary

**Date**: 2025-11-13

## Overview

RocketCyber is primarily an **EDR/MDR solution with SOC backing**, not a comprehensive log aggregation platform. Its log shipping capabilities are focused on security event collection and threat detection rather than general-purpose log management.

---

## Key Capabilities

### What RocketCyber Does Well

✅ **Endpoint Security Logging**
- Collects comprehensive security events via lightweight agents
- Supports Windows, macOS, and Linux endpoints
- Monitors:
  - Windows Event Logs (Security, System, Application)
  - Process execution and creation
  - File system modifications and access
  - Registry changes
  - Network connections
  - PowerShell and script execution
  - DNS queries
  - Authentication events

✅ **Cloud Service Integration**
- Office 365 audit logs (email, authentication, file access)
- Azure AD sign-in logs and conditional access events
- Basic AWS CloudTrail support

✅ **SOC-Backed Threat Detection**
- 24/7 SOC analysis and alert validation
- ML-based threat detection
- Threat intelligence enrichment
- Reduced false positives

### What RocketCyber Does NOT Do Well

❌ **General-Purpose Log Aggregation**
- Not designed to replace Splunk, ELK, or traditional SIEM
- Cannot handle high-volume syslog ingestion
- Limited support for custom log parsing

❌ **Comprehensive Log Forwarding**
- Cannot forward raw endpoint logs to external platforms
- Exports are alert/detection-focused, not raw log streams
- Cannot use RocketCyber as a log forwarding proxy

❌ **Long-Term Retention**
- Standard 90-day retention insufficient for many compliance requirements
- No on-premise storage option
- Requires external archival for extended retention

❌ **Cloud Infrastructure Logging**
- Limited AWS/Azure/GCP infrastructure support
- No native support for most SaaS applications beyond Office 365
- No network traffic analysis (NTA) capabilities

---

## Log Flow Architecture

### Inbound (Collection)

**1. Agent-Based Collection (Primary Method)**
- Lightweight agents installed on endpoints
- Near real-time log streaming via encrypted HTTPS
- Minimal resource usage (<2% CPU, <200MB RAM)
- Outbound port 443 required to RocketCyber cloud

**2. Syslog Reception (Limited)**
- Basic syslog support for network devices
- Firewalls, VPN appliances, IDS/IPS systems
- Standard syslog formats (RFC 3164/5424)
- UDP/TCP transport
- **Limitation**: Not designed for high-volume syslog

**3. API/Cloud Integrations**
- OAuth-based connections to cloud services
- Periodic polling or webhook-based retrieval
- Pre-built integrations for O365, Azure AD
- Limited AWS/GCP support

### Outbound (Export)

**RocketCyber Alerts to External SIEM:**
- RESTful API with JSON responses
- Export security alerts and detections
- Integration with Splunk, Microsoft Sentinel
- Custom API integrations possible

**What Gets Exported:**
- Security alerts and detections
- Incident summaries
- Threat intelligence indicators
- Investigation findings

**What Does NOT Get Exported:**
- Complete raw endpoint logs
- Full Windows event logs
- Comprehensive syslog data

---

## Retention & Storage

### Retention Periods

| Log Type | Standard Retention |
|----------|-------------------|
| Endpoint Event Data | 90 days |
| Incident/Alert Data | 1 year+ |
| Syslog Data | 30-90 days |

### Storage Model

- **Cloud-based only**: AWS-hosted infrastructure
- **US data centers**: Verify for GDPR/data residency compliance
- **Multi-tenant**: Customer data isolation
- **No on-premise option**: Cannot store data locally

### Extending Retention

**Options:**
1. Export to external SIEM via API
2. Upgrade licensing (verify availability)
3. Export incident reports for permanent archival

**Best Practice**: Plan for external log archival if retention >90 days required

---

## Integration Methods

### Deploying Agents

**Via RMM Platforms:**
- ConnectWise Automate: Script or software deployment
- Datto RMM: Component package
- NinjaOne: Software management
- Syncro: Manual or scripted installation

**Manual Installation:**
```powershell
# Windows
msiexec /i RocketCyberAgent.msi /quiet ACCOUNT_TOKEN="your_token_here"
```

**Requirements:**
- Administrative/root privileges
- Outbound HTTPS connectivity (port 443)
- Firewall rules configured

### Configuring Syslog

**Network Device Configuration:**
```
# Example: FortiGate
config log syslogd setting
    set status enable
    set server "rocketcyber-syslog-endpoint.domain.com"
    set port 514
end
```

**RocketCyber Configuration:**
1. Navigate to Settings → Integrations → Syslog
2. Note assigned syslog endpoint and port
3. Configure source device
4. Verify log ingestion in RocketCyber UI

### Cloud Service Integration

**Office 365:**
1. Navigate to Integrations → Office 365
2. Authenticate with Global Admin credentials
3. Grant API permissions
4. Select monitored users/groups
5. Configure alert policies

**Azure AD:**
1. Register RocketCyber as enterprise application
2. Grant Graph API permissions
3. Configure conditional access monitoring

### Exporting to SIEM

**API-Based Export Example:**
```python
import requests

API_KEY = "your_api_key"
ACCOUNT_ID = "your_account_id"

# Fetch RocketCyber incidents
response = requests.get(
    f"https://api.rocketcyber.com/v3/account/{ACCOUNT_ID}/incidents",
    headers={"Authorization": f"Bearer {API_KEY}"}
)

incidents = response.json()

# Forward to your SIEM
# (custom logic based on your SIEM's ingestion method)
```

**Available API Endpoints:**
```
GET /api/v3/account/{account_id}/incidents
GET /api/v3/account/{account_id}/events
GET /api/v3/account/{account_id}/detections
```

**Native SIEM Integrations:**
- **Splunk**: Add-on available
- **Microsoft Sentinel**: Via Logic Apps or custom connectors
- **Others**: Custom API integrations required

---

## Critical Limitations

### Log Collection Limitations

1. **Not a General-Purpose Log Aggregator**
   - Purpose-built for security monitoring only
   - Cannot replace SIEM for compliance/operational logging
   - No support for application-specific logs

2. **Limited Syslog Maturity**
   - Less robust than dedicated SIEM platforms
   - Custom log parsing may require vendor support
   - Volume throttling under high load

3. **Cloud Service Coverage Gaps**
   - Limited AWS/Azure/GCP infrastructure logs
   - No native support for most SaaS apps
   - Requires separate CASB or SIEM for comprehensive coverage

4. **No Network Traffic Analysis**
   - No packet capture capabilities
   - No NetFlow/IPFIX support
   - No visibility into network-layer attacks

### Retention & Export Limitations

5. **Short Retention Windows**
   - 90-day standard insufficient for many compliance frameworks
   - No option for unlimited retention
   - Must export to external systems for long-term storage

6. **No Raw Log Forwarding**
   - Cannot forward complete Windows event logs
   - Cannot act as log collection proxy
   - Exports are alert-focused, not comprehensive log streams

### Infrastructure Limitations

7. **Cloud-Only Architecture**
   - No air-gapped or on-premise deployment
   - Requires internet connectivity from all endpoints
   - May conflict with highly restrictive network policies

8. **Data Sovereignty Concerns**
   - US-based storage may conflict with GDPR
   - No region-specific hosting options (verify current status)
   - Consider for regulated industries

### Performance Limitations

9. **Agent Impact**
   - May impact under-resourced endpoints
   - Requires ongoing bandwidth (~10-50 MB/day per endpoint)
   - Monitor agent health and performance

10. **API Rate Limiting**
    - Frequent polling can hit rate limits
    - Implement exponential backoff
    - Use webhooks where possible

---

## Use Cases

### Recommended Use Cases

#### ✅ Security Alert Aggregation (MSP)
- Deploy RocketCyber across all customer endpoints
- Forward RocketCyber alerts to central SIEM
- Correlate with firewall logs and network traffic
- Create unified security dashboard

#### ✅ Endpoint Security Monitoring
- Comprehensive endpoint event visibility
- SOC-backed threat detection and response
- Reduced alert fatigue with ML filtering
- 24/7 security coverage without internal SOC

#### ✅ Office 365 Security
- Monitor email threats and suspicious logins
- Detect data exfiltration attempts
- Alert on compromised accounts
- Automated incident response

#### ✅ Compliance Evidence Collection (Partial)
- 90-day security event retention
- Export critical events to long-term archive
- Generate audit reports from RocketCyber UI
- **Note**: Supplement with additional tools for full compliance

#### ✅ MSP Multi-Tenant Security Operations
- White-labeled security monitoring per customer
- Centralized alert management
- Auto-create PSA tickets for high-priority alerts
- Leverage RocketCyber SOC without internal staff

### NOT Recommended Use Cases

#### ❌ General Application Logging
**Use instead**: Splunk, Elastic, CloudWatch

#### ❌ Network Traffic Analysis
**Use instead**: Darktrace, ExtraHop, Zeek

#### ❌ Full Compliance Log Archival
**Use instead**: Dedicated archive solution with unlimited retention

#### ❌ High-Volume Syslog Aggregation
**Use instead**: Graylog, Splunk, LogRhythm

#### ❌ Custom Application Monitoring
**Use instead**: Datadog, New Relic, APM tools

---

## Best Practices

### Deployment Strategy

1. **Pilot Before Full Rollout**
   - Test on 10-20 representative endpoints
   - Monitor agent performance and network impact
   - Validate RMM/PSA/SIEM integrations
   - Train staff on alert handling

2. **Prioritize High-Value Assets**
   - Servers, domain controllers, privileged workstations first
   - Systems with sensitive data access
   - All internet-facing systems

3. **Staged Rollout Plan**
   - Phase 1: Critical infrastructure (servers, DCs)
   - Phase 2: Privileged user endpoints
   - Phase 3: General workforce
   - Phase 4: Optional devices

### Alert Management

1. **Establish Triage Workflow**
   ```
   RocketCyber Alert → SOC Review (RocketCyber Team) →
   High Priority → PSA Ticket →
   Investigation → Resolution
   ```

2. **Tune Alert Policies**
   - Work with RocketCyber SOC to reduce false positives
   - Whitelist known-good applications
   - Customize severity thresholds per environment

3. **Define Escalation Procedures**
   - Critical: 15 minutes response time
   - High: 1 hour response time
   - Medium: 4 hour response time
   - Document incident response playbooks

### Integration with Existing Tools

**RMM Integration:**
- Deploy agents via RMM automation
- Monitor agent health through RMM
- Create remediation policies (e.g., isolate endpoint on ransomware detection)

**PSA Integration:**
- Auto-create tickets for High/Critical alerts
- Include alert details and recommended actions
- Link to RocketCyber investigation console

**SIEM Integration:**
- Forward RocketCyber alerts to SIEM for correlation
- Enrich SIEM data with RocketCyber threat intelligence
- Create unified security dashboards

### Data Retention & Archival

1. **Understand Retention Limits**
   - 90-day retention may be insufficient for compliance
   - Plan external archival strategy

2. **Automated Export**
   - Schedule daily/weekly API pulls
   - Store in long-term SIEM or archive (S3, Azure Blob)
   - Maintain chain of custody for forensics

3. **Incident Documentation**
   - Export incident reports immediately
   - Store permanently outside RocketCyber
   - Document investigation steps

### Performance Optimization

1. **Monitor Agent Health**
   - Track agent connectivity via RocketCyber dashboard
   - Alert on agents offline >24 hours
   - Investigate performance issues

2. **Network Bandwidth Planning**
   - Estimate 10-50 MB/day per endpoint
   - Account for bandwidth in remote offices
   - Consider caching for intermittent connectivity

3. **API Rate Limit Management**
   - Respect API rate limits
   - Use webhooks instead of polling
   - Implement exponential backoff

---

## When to Supplement RocketCyber

RocketCyber excels at endpoint security monitoring but may need complementary tools:

### Long-Term Compliance Logging
**Add**: Splunk, Elastic, cloud-native SIEM (Sentinel)
**Reason**: Extended retention, regulatory compliance

### Network Traffic Analysis
**Add**: Darktrace, ExtraHop, Zeek
**Reason**: Network-layer visibility, lateral movement detection

### Cloud Infrastructure Security
**Add**: Wiz, Orca, GuardDuty, Azure Defender
**Reason**: Comprehensive cloud workload protection

### Application Performance Monitoring
**Add**: Datadog, New Relic, Dynatrace
**Reason**: Application health and performance metrics

### Comprehensive SIEM
**Add**: Splunk, QRadar, LogRhythm
**Reason**: Centralized log aggregation across all sources

---

## Competitive Context

### Stronger Log Management Alternatives

**SentinelOne**: More robust log collection (Scalyr acquisition)
**CrowdStrike Falcon**: Better cloud integration, LogScale platform
**Splunk/Elastic**: Purpose-built log aggregation

### Similar EDR Focus (Limited Log Shipping)

**Huntress**: MSP-focused, similar log limitations
**Sophos Intercept X**: EDR-first, basic log export

### RocketCyber's Advantages

✅ Simplicity and ease of deployment for MSPs
✅ Strong SOC-backed threat detection
✅ Cost-effective for security-focused use cases
✅ Multi-tenant white-labeling
✅ Excellent RMM/PSA integrations

---

## Key Takeaways

### The Bottom Line

**RocketCyber is an EDR/MDR solution with SOC backing, NOT a log shipping platform.**

**Use RocketCyber for:**
- Endpoint security event detection and response
- SOC-validated threat hunting
- Office 365/Azure AD security monitoring
- MSP multi-tenant security operations

**Do NOT use RocketCyber as:**
- General-purpose log aggregator
- SIEM replacement
- High-volume syslog collector
- Long-term compliance log archive
- Network traffic analyzer

### Integration Strategy

**Ideal Architecture:**
```
Endpoints → RocketCyber Agents → RocketCyber Cloud (90-day retention)
                            ↓
                    RocketCyber API (Alerts/Detections)
                            ↓
                    Your SIEM (Long-term storage, correlation)
```

**Complementary Tools:**
- **SIEM** (Splunk, Sentinel): Long-term retention, correlation
- **Native Log Forwarders** (Splunk UF, Elastic Beats): Raw log collection
- **Cloud Security Tools**: Infrastructure monitoring
- **NTA Tools**: Network visibility

### Success Criteria

RocketCyber deployment is successful when:
- ✅ Agent coverage on all critical endpoints
- ✅ Alerts integrated with PSA ticketing
- ✅ False positive rate <10%
- ✅ Mean time to detect (MTTD) <1 hour
- ✅ SOC-validated threats actioned within SLA
- ✅ External SIEM receiving RocketCyber alerts for correlation

---

## Additional Resources

### Documentation & Support
- **RocketCyber API Documentation**: Available via account portal
- **Kaseya Support**: https://support.kaseya.com
- **Partner Portal**: Access to deployment guides and best practices

### Recommended Next Steps
1. Contact Kaseya/RocketCyber for latest feature updates
2. Review RocketCyber API documentation for integration details
3. Engage RocketCyber onboarding team for deployment planning
4. Verify current integration capabilities with your RMM/PSA/SIEM

### Training Resources
- RocketCyber partner training portal
- MSP-specific deployment webinars
- SOC alert handling best practices documentation

---

**Document Version**: 1.0
**Last Updated**: 2025-11-13
**Next Review**: Quarterly or when major RocketCyber features released
