# New-DomainAdminAccount Component - Complete Package Overview

## Package Contents

This complete package contains everything needed to deploy, test, and maintain the New-DomainAdminAccount Datto RMM component in a secure enterprise environment.

### Files Included

| File | Purpose | Location |
|------|---------|----------|
| `New-DomainAdminAccount.ps1` | Main component script | `/home/wferrel/ai/powershell/` |
| `New-DomainAdminAccount-README.md` | Comprehensive documentation | `/home/wferrel/ai/powershell/` |
| `New-DomainAdminAccount-DattoSetup.md` | Step-by-step Datto RMM setup guide | `/home/wferrel/ai/powershell/` |
| `Test-NewDomainAdminComponent.ps1` | Complete test harness | `/home/wferrel/ai/powershell/` |
| `New-DomainAdminAccount-SecurityChecklist.md` | Security audit checklist | `/home/wferrel/ai/powershell/` |
| `New-DomainAdminAccount-OVERVIEW.md` | This overview document | `/home/wferrel/ai/powershell/` |

---

## Component Overview

**Purpose:** Automate the secure creation of Active Directory user accounts with Domain Admin privileges through Datto RMM.

**Key Features:**
- Automated user account creation in Active Directory
- Automatic Domain Admins group membership
- Password complexity validation
- Comprehensive error handling
- Detailed audit logging
- Security warnings and best practices
- Customizable OU placement
- Support for user metadata (First Name, Last Name, Description)

**Security Level:** CRITICAL - Creates highly privileged accounts with full domain access

---

## Quick Start Guide

### For Administrators (First-Time Deployment)

1. **Read Documentation**
   - Start with `New-DomainAdminAccount-README.md`
   - Review security considerations
   - Understand exit codes and error handling

2. **Test in Lab**
   - Set up test Active Directory environment
   - Run `Test-NewDomainAdminComponent.ps1 -TestScenario All -CleanupAfterTest`
   - Verify all tests pass
   - Understand component behavior

3. **Complete Security Review**
   - Use `New-DomainAdminAccount-SecurityChecklist.md`
   - Complete pre-deployment checklist
   - Obtain required approvals

4. **Deploy to Datto RMM**
   - Follow `New-DomainAdminAccount-DattoSetup.md`
   - Configure component variables
   - Set up monitoring and alerts
   - Configure approval workflow

5. **Validate Production**
   - Test with low-risk account creation
   - Verify logging and monitoring
   - Confirm approval workflow works
   - Document any customizations

### For Operators (Using the Component)

1. **Verify Prerequisites**
   - Approval obtained from IT management
   - Business justification documented
   - Change ticket created
   - Username follows naming convention

2. **Execute Component**
   - Log into Datto RMM
   - Navigate to target Domain Controller
   - Select New-DomainAdminAccount component
   - Fill in required variables
   - Submit for approval (if workflow enabled)
   - Monitor execution

3. **Verify Success**
   - Check exit code (0 = success)
   - Review execution logs
   - Verify account in Active Directory
   - Confirm Domain Admins membership
   - Document in CMDB

4. **Post-Execution**
   - Update change ticket
   - Notify account owner
   - Schedule access review
   - Document password securely

---

## Component Specifications

### Requirements

**System Requirements:**
- Windows Server 2012 R2 or higher
- PowerShell 5.1 or higher
- Active Directory PowerShell module
- Domain Controller or RSAT-enabled system

**Permissions Required:**
- Domain Admin or delegated account creation rights
- Permission to modify Domain Admins group
- Execute as SYSTEM in Datto RMM

**Network Requirements:**
- Domain Controller accessibility
- DNS resolution working
- Active Directory ports open (389, 636, 3268, 3269, 88, 464)

### Parameters

**Required:**
- `Username` - SAM Account Name (max 20 chars, no special chars)
- `Password` - Must meet complexity requirements (min 8 chars, 3 categories)

**Optional:**
- `FirstName` - User's first name
- `LastName` - User's last name
- `Description` - Account description (auto-generated if not provided)
- `OUPath` - Target OU Distinguished Name (defaults to CN=Users)

### Exit Codes

| Code | Meaning | Action Required |
|------|---------|-----------------|
| 0 | Success | None - account created successfully |
| 1 | General Failure | Review logs, investigate error |
| 10 | Missing Parameters | Provide required Username and Password |
| 11 | Invalid Parameters | Fix parameter format/length |
| 20 | Module Not Available | Install RSAT tools |
| 21 | Not Domain Joined | Run on DC or domain-joined system |
| 30 | User Already Exists | Choose different username |
| 31 | Password Complexity | Use stronger password |
| 32 | User Creation Failed | Check permissions and AD health |
| 33 | Group Membership Failed | Verify Domain Admins group access |
| 34 | Invalid OU Path | Verify OU exists and is accessible |

---

## Security Considerations

### Critical Warnings

1. **Domain Admin accounts have unrestricted access to all domain resources**
2. **Only create Domain Admin accounts when absolutely necessary**
3. **Implement approval workflow for all executions**
4. **Enable comprehensive audit logging**
5. **Regular review and removal of unused accounts required**

### Security Best Practices

**Access Control:**
- Restrict component execution to authorized personnel
- Implement approval workflow
- Use role-based access control (RBAC)
- Regular access reviews

**Credential Management:**
- Store passwords in secure vault
- Use Datto secure credential storage
- Never share Domain Admin credentials
- Implement password rotation

**Monitoring:**
- Real-time alerts for component execution
- Daily log reviews
- Weekly account audits
- Monthly compliance reports

**Compliance:**
- Document all account creations
- Maintain audit trail
- Regular security assessments
- Follow regulatory requirements

---

## Testing Strategy

### Test Environments

**Lab Environment (Required):**
- Isolated Active Directory domain
- Test Domain Controller
- Datto RMM test instance
- No production data

**Staging Environment (Recommended):**
- Production-like configuration
- Limited scope testing
- Approval workflow testing
- Integration validation

**Production Environment:**
- Controlled rollout
- Enhanced monitoring
- Strict approval requirements
- Incident response ready

### Test Scenarios Covered

The test harness (`Test-NewDomainAdminComponent.ps1`) validates:

1. **Basic Creation** - Standard user creation with minimal parameters
2. **Custom OU** - Account creation in specified organizational unit
3. **Duplicate User** - Prevents creating accounts that already exist
4. **Weak Password** - Rejects common/simple passwords
5. **Invalid OU** - Detects non-existent OU paths
6. **Password Complexity** - Validates all complexity requirements
7. **Invalid Username** - Catches forbidden characters and length violations
8. **Missing Parameters** - Ensures required parameters are provided

### Running Tests

```powershell
# Run all tests with cleanup
.\Test-NewDomainAdminComponent.ps1 -TestScenario All -CleanupAfterTest

# Run specific test
.\Test-NewDomainAdminComponent.ps1 -TestScenario BasicCreation

# Run all tests without cleanup (for manual verification)
.\Test-NewDomainAdminComponent.ps1 -TestScenario All
```

**Expected Results:**
- All tests should pass in properly configured environment
- Test creates CSV report with detailed results
- Exit codes should match documented behavior
- Active Directory events should be logged

---

## Deployment Checklist

### Pre-Deployment

- [ ] Read all documentation thoroughly
- [ ] Complete security checklist
- [ ] Test in lab environment - all tests pass
- [ ] Security team approval obtained
- [ ] IT management sign-off received
- [ ] Approval workflow designed and documented
- [ ] Monitoring and alerting configured
- [ ] Incident response plan updated
- [ ] Training provided to authorized users

### Deployment

- [ ] Component uploaded to Datto RMM
- [ ] Component variables configured correctly
- [ ] Device filters applied (Domain Controllers only)
- [ ] Execution settings verified (System, 120s timeout)
- [ ] Monitoring alerts configured
- [ ] Approval workflow enabled
- [ ] Access restrictions applied
- [ ] Documentation updated with production details

### Post-Deployment

- [ ] Test execution in production (low-risk account)
- [ ] Verify monitoring alerts triggered
- [ ] Confirm approval workflow functional
- [ ] Validate audit logging working
- [ ] Review execution logs
- [ ] Verify Active Directory integration
- [ ] Schedule first quarterly review
- [ ] Communicate availability to authorized users

---

## Maintenance Schedule

### Daily
- Review execution logs
- Verify approvals present
- Check for failures

### Weekly
- Audit new accounts created
- Review account activity
- Check for inactive accounts

### Monthly
- Full Domain Admin account audit
- Reconcile logs (Datto + AD)
- Update documentation
- Access permission review

### Quarterly
- Complete security assessment
- Remove unnecessary accounts
- Policy review and update
- Test incident response
- Access recertification
- Component update review

### Annually
- Full security audit
- Disaster recovery testing
- Penetration testing consideration
- Compliance assessment
- Risk assessment
- Security training
- Technology refresh evaluation

---

## Troubleshooting Quick Reference

### Component Won't Execute
**Check:** Agent status, device online, permissions, approval workflow

### Exit Code 20
**Fix:** Install RSAT tools
```powershell
Install-WindowsFeature -Name RSAT-AD-PowerShell
```

### Exit Code 21
**Fix:** Verify domain membership and connectivity
```powershell
Get-WmiObject Win32_ComputerSystem | Select PartOfDomain, Domain
```

### Exit Code 30
**Fix:** User exists - choose different username or delete existing account

### Exit Code 31
**Fix:** Password doesn't meet requirements - use complex password (8+ chars, 3 categories)

### Exit Code 32
**Fix:** Review permissions, check AD health, verify OU path

### Exit Code 33
**Fix:** Verify permissions to modify Domain Admins group

### Exit Code 34
**Fix:** Verify OU exists
```powershell
Get-ADOrganizationalUnit -Filter * | Select Name, DistinguishedName
```

---

## Support and Resources

### Documentation Files
- Main README: `New-DomainAdminAccount-README.md`
- Setup Guide: `New-DomainAdminAccount-DattoSetup.md`
- Security Checklist: `New-DomainAdminAccount-SecurityChecklist.md`

### PowerShell Help
```powershell
# View component help
Get-Help .\New-DomainAdminAccount.ps1 -Full

# View test harness help
Get-Help .\Test-NewDomainAdminComponent.ps1 -Full
```

### Active Directory Resources
```powershell
# AD user cmdlet help
Get-Help New-ADUser -Full

# AD group cmdlet help
Get-Help Add-ADGroupMember -Full

# Password policy
Get-ADDefaultDomainPasswordPolicy
```

### Audit Queries

**List Domain Admins:**
```powershell
Get-ADGroupMember -Identity "Domain Admins" | Select Name, SamAccountName
```

**Find Component-Created Accounts:**
```powershell
Get-ADUser -Filter {Description -like "*Datto RMM*"} -Properties Created, Description
```

**Check Security Events:**
```powershell
Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id = 4720, 4728  # Account created, added to group
    StartTime = (Get-Date).AddDays(-7)
}
```

---

## Version History

### Version 1.0.0 (2025-12-08)
- Initial release
- Complete component functionality
- Comprehensive documentation
- Full test suite
- Security checklist
- Datto RMM setup guide

### Planned Enhancements
Consider for future versions:
- Account expiration date parameter
- Email notification on creation
- Integration with password manager APIs
- Additional validation checks
- Enhanced logging options
- Multiple group membership support
- Bulk account creation support

---

## Compliance and Legal

### Regulatory Considerations
- **HIPAA**: Audit trail, access controls, logging
- **PCI DSS**: Least privilege, logging, access reviews
- **SOX**: Change management, approval workflow, audit trail
- **GDPR**: Data protection, access controls, audit logs

### Organizational Policies
- Follow internal security policies
- Obtain required approvals
- Document business justification
- Maintain change management records
- Conduct regular access reviews
- Implement appropriate retention policies

### Disclaimer
This component creates highly privileged accounts with full domain access. Organizations are responsible for:
- Implementing appropriate security controls
- Following internal policies and procedures
- Maintaining compliance with regulations
- Regular auditing and monitoring
- Proper training of authorized users
- Incident response preparedness

---

## Contact and Escalation

### Primary Contacts
- **Component Owner**: ______________________
- **Security Team**: ______________________
- **IT Management**: ______________________

### Escalation Path
1. **Level 1**: Help Desk / Operations Team
2. **Level 2**: Systems Administrators
3. **Level 3**: Active Directory Team Lead
4. **Level 4**: IT Security Team
5. **Level 5**: IT Director / CISO

### Emergency Contacts
- **Security Incident**: ______________________
- **After Hours**: ______________________
- **Compliance Officer**: ______________________

---

## Getting Started Workflow

```
┌─────────────────────────────────────────────────────────┐
│                    GETTING STARTED                      │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  1. Read New-DomainAdminAccount-README.md               │
│     Understand functionality and requirements           │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  2. Complete Security Checklist                         │
│     Review security controls and obtain approvals       │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  3. Set Up Test Environment                             │
│     Create isolated AD test domain                      │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  4. Run Test Suite                                      │
│     Execute Test-NewDomainAdminComponent.ps1            │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
                   All Tests Pass?
                    │            │
                   Yes           No
                    │            │
                    │            ▼
                    │   ┌─────────────────┐
                    │   │ Troubleshoot    │
                    │   │ and Fix Issues  │
                    │   └─────────────────┘
                    │            │
                    └────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  5. Configure Datto RMM                                 │
│     Follow New-DomainAdminAccount-DattoSetup.md         │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  6. Production Validation                               │
│     Test with controlled execution                      │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  7. Go Live                                             │
│     Release to authorized users                         │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  8. Ongoing Monitoring                                  │
│     Daily/Weekly/Monthly/Quarterly Reviews              │
└─────────────────────────────────────────────────────────┘
```

---

## Success Metrics

### Key Performance Indicators (KPIs)

**Operational Metrics:**
- Component execution success rate: Target >95%
- Average execution time: Target <30 seconds
- Failed executions requiring intervention: Target <5%

**Security Metrics:**
- Unauthorized execution attempts: Target 0
- Accounts created without approval: Target 0
- Audit finding remediation time: Target <7 days
- Security incident rate: Target 0

**Compliance Metrics:**
- Audit log retention compliance: Target 100%
- Quarterly access review completion: Target 100%
- Documentation updates on time: Target 100%
- Training completion for authorized users: Target 100%

### Reporting Dashboard

Monitor these metrics monthly:
- Total accounts created
- Success vs. failure rate
- Exit code distribution
- Average response time
- Security alerts triggered
- Approval workflow timing
- Audit compliance status

---

## Conclusion

This complete package provides everything needed to securely deploy and maintain the New-DomainAdminAccount Datto RMM component.

**Key Takeaways:**
1. Always test thoroughly in lab environment
2. Complete security review before production
3. Implement approval workflow
4. Enable comprehensive monitoring
5. Conduct regular audits
6. Follow principle of least privilege
7. Maintain detailed documentation

**Remember:**
- Domain Admin accounts are highly privileged - use sparingly
- Security controls are critical - don't skip steps
- Regular audits prevent security drift
- Documentation enables effective incident response

For questions, issues, or improvements, contact the component owner or IT security team.

---

**Document Version:** 1.0.0
**Last Updated:** 2025-12-08
**Classification:** Internal Use Only
**Next Review Date:** 2026-03-08 (Quarterly)
