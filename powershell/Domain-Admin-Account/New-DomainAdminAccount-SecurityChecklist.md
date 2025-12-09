# Security Audit Checklist: New-DomainAdminAccount Component

## Purpose
This checklist ensures proper security controls are in place when using the New-DomainAdminAccount Datto RMM component. Use this for initial deployment, quarterly reviews, and security audits.

---

## Pre-Deployment Security Review

### Access Control
- [ ] Component execution restricted to authorized personnel only
- [ ] Datto RMM role-based access control (RBAC) configured
- [ ] Approval workflow enabled for component execution
- [ ] Approver roles and individuals documented
- [ ] Multi-person approval required for production use
- [ ] Access review process established (frequency: _______)

### Authentication & Authorization
- [ ] Component runs with appropriate permissions (System/Domain Admin)
- [ ] Datto RMM service account follows least privilege principle
- [ ] Service account credentials securely stored
- [ ] Service account password rotation policy in place
- [ ] MFA enabled for Datto RMM portal access
- [ ] Session timeout configured for Datto RMM

### Credential Management
- [ ] Passwords stored using Datto secure credential storage
- [ ] No plain text passwords in component variables
- [ ] Password generation policy documented (minimum 20 characters recommended)
- [ ] Password vault/manager used for credential storage
- [ ] Credentials not shared across multiple accounts
- [ ] Credential expiration/rotation policy defined

### Logging & Monitoring
- [ ] Component execution logging enabled
- [ ] Logs retained for minimum 1 year (or per compliance requirement)
- [ ] Real-time alerts configured for component execution
- [ ] Failed execution alerts configured
- [ ] Security team notified of all Domain Admin account creations
- [ ] Logs forwarded to SIEM (if available)
- [ ] Log integrity controls in place (tamper prevention)

### Network Security
- [ ] Component execution limited to specific sites/devices
- [ ] Domain Controllers properly segmented on network
- [ ] Firewall rules reviewed and documented
- [ ] Remote access to DCs restricted and monitored
- [ ] Datto RMM agent communication encrypted

---

## Configuration Security Review

### Component Settings
- [ ] Timeout value appropriate (recommended: 120 seconds)
- [ ] Retry on failure disabled (manual intervention required)
- [ ] Component version documented and tracked
- [ ] Change control process for component updates
- [ ] Component code review completed
- [ ] Script signing implemented (if organizational policy requires)

### Variable Validation
- [ ] All required variables marked as mandatory
- [ ] Password variable configured as secure type
- [ ] Username validation regex configured
- [ ] Optional variables have appropriate defaults
- [ ] No sensitive data in variable descriptions
- [ ] Environment variables properly mapped

### Device Targeting
- [ ] Component limited to Domain Controllers only
- [ ] Device filter validated and tested
- [ ] Staging/production environments separated
- [ ] Test domain available for validation
- [ ] Production deployment requires approval

---

## Active Directory Security Review

### Account Creation Policy
- [ ] Domain Admin account creation policy documented
- [ ] Business justification required for new accounts
- [ ] Naming convention established and enforced
- [ ] Account expiration policy defined
- [ ] Temporary vs. permanent account process documented
- [ ] Maximum number of Domain Admins defined

### Password Policy
- [ ] Domain password policy reviewed (Get-ADDefaultDomainPasswordPolicy)
- [ ] Minimum password length: _____ characters
- [ ] Password complexity enabled
- [ ] Password history: _____ passwords remembered
- [ ] Maximum password age: _____ days
- [ ] Account lockout policy configured
- [ ] Fine-grained password policy for admins (if applicable)

### Organizational Unit Structure
- [ ] Dedicated OU for administrative accounts created
- [ ] OU permissions reviewed and documented
- [ ] OU path used in component validated
- [ ] GPO inheritance reviewed for admin accounts OU
- [ ] Separate OUs for different admin types (if applicable)

### Group Membership
- [ ] Domain Admins group membership regularly audited
- [ ] Protected Users group membership considered
- [ ] Nested group memberships reviewed
- [ ] Group Policy applied to administrative accounts
- [ ] Administrative tier model implemented (if applicable)

---

## Operational Security Review

### Approval Workflow
- [ ] Approval workflow documented
- [ ] Approvers identified by role and name
- [ ] Approval timeout configured
- [ ] Escalation process for urgent requests
- [ ] Approval rejection process documented
- [ ] Approval audit trail maintained

### Change Management
- [ ] Component execution requires change ticket
- [ ] Business justification documented in ticket
- [ ] Implementation plan reviewed
- [ ] Rollback procedure documented
- [ ] Post-implementation validation required
- [ ] Change advisory board (CAB) approval for production

### Documentation Requirements
- [ ] Standard Operating Procedure (SOP) created
- [ ] Runbook for component execution
- [ ] Troubleshooting guide available
- [ ] Contact information for escalation
- [ ] Knowledge base articles created
- [ ] Training materials for authorized users

### Testing & Validation
- [ ] Test plan created and executed
- [ ] All exit codes tested and validated
- [ ] Error handling verified
- [ ] Test domain environment available
- [ ] User acceptance testing (UAT) completed
- [ ] Security testing performed

---

## Compliance & Audit Review

### Regulatory Compliance
- [ ] HIPAA compliance verified (if applicable)
- [ ] PCI DSS requirements met (if applicable)
- [ ] SOX controls documented (if applicable)
- [ ] GDPR requirements addressed (if applicable)
- [ ] Industry-specific regulations reviewed
- [ ] Data residency requirements met

### Audit Trail
- [ ] Component execution events logged in AD
- [ ] Security Event IDs monitored (4720, 4728, 4732)
- [ ] Correlation between Datto RMM and AD logs verified
- [ ] Audit log retention policy enforced
- [ ] Audit logs protected from modification
- [ ] Regular audit log reviews scheduled

### Evidence Collection
- [ ] Screenshots of component configuration
- [ ] Policy documents version controlled
- [ ] Approval emails retained
- [ ] Change tickets archived
- [ ] Test results documented
- [ ] Security assessment reports filed

### Reporting Requirements
- [ ] Monthly execution reports generated
- [ ] Quarterly access reviews completed
- [ ] Annual security assessments scheduled
- [ ] Compliance reports submitted on time
- [ ] Metrics tracked (accounts created, success rate, etc.)
- [ ] Executive summary prepared for leadership

---

## Ongoing Security Monitoring

### Daily Tasks
- [ ] Review component execution logs
- [ ] Verify all executions have proper approval
- [ ] Check for failed executions and investigate
- [ ] Monitor security alerts
- [ ] Verify no unauthorized Domain Admin additions

### Weekly Tasks
- [ ] Review newly created Domain Admin accounts
- [ ] Confirm accounts align with approved requests
- [ ] Check for inactive Domain Admin accounts
- [ ] Review password age of admin accounts
- [ ] Audit group membership changes

### Monthly Tasks
- [ ] Full audit of Domain Admin accounts
- [ ] Reconcile Datto RMM logs with AD security logs
- [ ] Review and test approval workflow
- [ ] Update documentation if processes changed
- [ ] Security awareness training reminder
- [ ] Review component access permissions

### Quarterly Tasks
- [ ] Comprehensive security assessment
- [ ] Remove unnecessary Domain Admin accounts
- [ ] Review and update security policies
- [ ] Test incident response procedures
- [ ] Validate backup and recovery procedures
- [ ] Access recertification for authorized users
- [ ] Component version review and update assessment

### Annual Tasks
- [ ] Complete security audit
- [ ] Policy and procedure review and update
- [ ] Disaster recovery testing
- [ ] Penetration testing (if in scope)
- [ ] Compliance assessment
- [ ] Risk assessment update
- [ ] Security awareness training (full course)
- [ ] Technology refresh evaluation

---

## Incident Response Checklist

### Unauthorized Execution Detected
- [ ] Immediately disable component
- [ ] Identify user who executed component
- [ ] Review execution parameters and created accounts
- [ ] Disable unauthorized accounts created
- [ ] Escalate to security team
- [ ] Initiate incident response procedure
- [ ] Document incident timeline
- [ ] Conduct root cause analysis
- [ ] Implement corrective actions
- [ ] Update controls to prevent recurrence

### Compromised Credentials Suspected
- [ ] Immediately reset affected passwords
- [ ] Disable compromised accounts
- [ ] Review recent account activity
- [ ] Check for unauthorized account creations
- [ ] Audit all Domain Admin accounts
- [ ] Review security logs for anomalies
- [ ] Engage incident response team
- [ ] Notify affected parties per policy
- [ ] Conduct forensic investigation
- [ ] Update security controls

### Component Malfunction/Error
- [ ] Document error details and exit code
- [ ] Verify no partial account creation
- [ ] Review component logs
- [ ] Check Active Directory for errors
- [ ] Test in lab environment
- [ ] Engage technical support if needed
- [ ] Create incident ticket
- [ ] Communicate impact to stakeholders
- [ ] Implement workaround if available
- [ ] Schedule root cause analysis

---

## Security Best Practices Compliance

### Principle of Least Privilege
- [ ] Domain Admin accounts only when necessary
- [ ] Regular accounts used for non-admin tasks
- [ ] Separate accounts for different admin levels
- [ ] Just-in-time (JIT) access considered
- [ ] Temporary elevation instead of permanent when possible
- [ ] Delegation used instead of Domain Admin where possible

### Defense in Depth
- [ ] Multiple layers of security controls
- [ ] Network segmentation implemented
- [ ] Application allowlisting on critical systems
- [ ] Endpoint detection and response (EDR) deployed
- [ ] Privileged Access Workstations (PAW) for admin tasks
- [ ] Multi-factor authentication enforced

### Assume Breach Mentality
- [ ] Monitoring for lateral movement
- [ ] Anomaly detection configured
- [ ] Honeypot accounts created
- [ ] Deception technology considered
- [ ] Regular threat hunting exercises
- [ ] Incident response plan tested

### Zero Trust Principles
- [ ] Verify explicitly (never trust, always verify)
- [ ] Use least privilege access
- [ ] Assume breach
- [ ] Segment access
- [ ] Require verification at every stage
- [ ] Use analytics to detect threats

---

## Remediation Priority Matrix

| Finding Severity | Required Action | Timeline |
|-----------------|----------------|----------|
| Critical | Immediate remediation required | 24 hours |
| High | Urgent remediation needed | 7 days |
| Medium | Scheduled remediation | 30 days |
| Low | Addressed in next review cycle | 90 days |
| Informational | Document and monitor | As needed |

---

## Sign-Off

### Deployment Approval

**Security Team Review:**
- Reviewer Name: _______________________
- Date: _______________________
- Signature: _______________________
- Findings: [ ] Approved [ ] Conditional [ ] Rejected

**IT Management Approval:**
- Approver Name: _______________________
- Date: _______________________
- Signature: _______________________
- Authorization: [ ] Approved [ ] Denied

**Compliance Review:**
- Reviewer Name: _______________________
- Date: _______________________
- Signature: _______________________
- Status: [ ] Compliant [ ] Non-Compliant [ ] N/A

### Quarterly Review

**Review Period:** Q___ 20___

**Reviewer:** _______________________

**Review Date:** _______________________

**Findings Summary:**
_________________________________________________________
_________________________________________________________
_________________________________________________________

**Action Items:**
1. _____________________________________________________
2. _____________________________________________________
3. _____________________________________________________

**Next Review Date:** _______________________

**Status:** [ ] Pass [ ] Pass with Findings [ ] Fail

---

## Appendix: PowerShell Audit Commands

### Check Domain Admin Membership
```powershell
Get-ADGroupMember -Identity "Domain Admins" |
    Select-Object Name, SamAccountName, DistinguishedName |
    Sort-Object Name
```

### Find Accounts Created by Component
```powershell
Get-ADUser -Filter {Description -like "*Datto RMM*"} -Properties Created, Description |
    Select-Object Name, SamAccountName, Created, Description |
    Sort-Object Created -Descending
```

### Check Last Logon of Admin Accounts
```powershell
Get-ADGroupMember -Identity "Domain Admins" |
    Get-ADUser -Properties LastLogonDate, PasswordLastSet |
    Select-Object Name, LastLogonDate, PasswordLastSet, Enabled |
    Sort-Object LastLogonDate
```

### Audit Recent Security Events
```powershell
# Account creation events (Event ID 4720)
Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id = 4720
    StartTime = (Get-Date).AddDays(-7)
} | Select-Object TimeCreated, Message

# Domain Admins group changes (Event ID 4728)
Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id = 4728
    StartTime = (Get-Date).AddDays(-7)
} | Where-Object { $_.Message -like '*Domain Admins*' } |
    Select-Object TimeCreated, Message
```

### Identify Inactive Domain Admin Accounts
```powershell
$inactiveDays = 90
$threshold = (Get-Date).AddDays(-$inactiveDays)

Get-ADGroupMember -Identity "Domain Admins" |
    Get-ADUser -Properties LastLogonDate |
    Where-Object { $_.LastLogonDate -lt $threshold -or $null -eq $_.LastLogonDate } |
    Select-Object Name, LastLogonDate, Enabled |
    Sort-Object LastLogonDate
```

### Review Password Age for Admin Accounts
```powershell
Get-ADGroupMember -Identity "Domain Admins" |
    Get-ADUser -Properties PasswordLastSet, PasswordNeverExpires |
    Select-Object Name,
        PasswordLastSet,
        @{Name='PasswordAgeDays';Expression={(Get-Date) - $_.PasswordLastSet | Select-Object -ExpandProperty Days}},
        PasswordNeverExpires |
    Sort-Object PasswordAgeDays -Descending
```

### Export Complete Audit Report
```powershell
$reportPath = "C:\Audit\DomainAdminAudit_$(Get-Date -Format 'yyyyMMdd').csv"

Get-ADGroupMember -Identity "Domain Admins" |
    Get-ADUser -Properties * |
    Select-Object Name, SamAccountName, Created, LastLogonDate, PasswordLastSet,
        Enabled, Description, DistinguishedName |
    Export-Csv -Path $reportPath -NoTypeInformation

Write-Host "Audit report exported to: $reportPath"
```

---

**Checklist Version:** 1.0.0
**Last Updated:** 2025-12-08
**Next Review Date:** _______________________
**Document Owner:** _______________________
**Classification:** Internal Use Only - Security Documentation
