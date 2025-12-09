# Datto RMM Setup Guide: New-DomainAdminAccount Component

## Quick Setup Checklist

- [ ] Create component in Datto RMM
- [ ] Configure component variables
- [ ] Set execution context and timeout
- [ ] Configure device filters (Domain Controllers only)
- [ ] Set up monitoring and alerts
- [ ] Test in lab environment
- [ ] Document security procedures
- [ ] Configure approval workflow

## Step-by-Step Setup

### Step 1: Create the Component

1. Log into Datto RMM portal
2. Navigate to **Setup → Components**
3. Click **New Component**
4. Fill in basic information:
   - **Name**: `New-DomainAdminAccount`
   - **Category**: `Active Directory Management`
   - **Component Type**: `PowerShell`
   - **Description**: `Creates a new AD user and adds to Domain Admins group`

### Step 2: Add the PowerShell Script

1. In the component editor, paste the entire contents of `New-DomainAdminAccount.ps1`
2. Click **Save & Continue**

### Step 3: Configure Component Variables

Add the following component variables:

#### Required Variables

**Variable 1: Username**
```
Variable Name: Username
Environment Variable: Username
Type: Text
Required: Yes
Description: SAM Account Name for the new user (max 20 characters)
Validation: ^[^"/\\\[\]:;|=,+*?<>@]{1,20}$
```

**Variable 2: Password**
```
Variable Name: Password
Environment Variable: Password
Type: Secure Credential
Required: Yes
Description: Password for the new account (min 8 chars, complexity required)
Validation: None (handled by script)
```

#### Optional Variables

**Variable 3: FirstName**
```
Variable Name: FirstName
Environment Variable: FirstName
Type: Text
Required: No
Description: User's first name
Default Value: (leave blank)
```

**Variable 4: LastName**
```
Variable Name: LastName
Environment Variable: LastName
Type: Text
Required: No
Description: User's last name
Default Value: (leave blank)
```

**Variable 5: Description**
```
Variable Name: Description
Environment Variable: Description
Type: Text
Required: No
Description: Account description (auto-generated if not provided)
Default Value: (leave blank)
```

**Variable 6: OUPath**
```
Variable Name: OUPath
Environment Variable: OUPath
Type: Text
Required: No
Description: Distinguished Name of target OU (e.g., OU=Admins,DC=domain,DC=com)
Default Value: (leave blank - uses CN=Users)
Example: OU=AdminUsers,DC=contoso,DC=com
```

### Step 4: Configure Execution Settings

**Execution Context:**
```
Run As: System
Timeout: 120 seconds
Continue on Error: No
```

**Platform Compatibility:**
```
Operating System: Windows Server
Minimum Version: Windows Server 2012 R2
Architecture: x64
```

**Prerequisites:**
- Active Directory PowerShell Module
- Domain Controller or RSAT tools installed
- Domain-joined computer
- Domain Admin or delegated permissions

### Step 5: Configure Device Filters

Recommended device filter to target only Domain Controllers:

```
Device Type: Server
Operating System: Windows Server
Custom Filter:
  Registry Value Exists:
    HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Parameters
```

**Alternative Filter** (for RSAT-enabled systems):
```
WMI Query:
SELECT * FROM Win32_OptionalFeature
WHERE Name = 'RemoteServerAdministrationTools'
AND InstallState = 1
```

### Step 6: Configure Monitoring and Alerts

#### Success Monitor
```
Monitor Name: Domain Admin Account Creation - Success
Type: Component Exit Code
Condition: Exit Code equals 0
Severity: Informational
Action: Create ticket with details
Notification: Send email to AD team
```

#### Failure Alert
```
Alert Name: Domain Admin Account Creation - Failed
Type: Component Exit Code
Condition: Exit Code does not equal 0
Severity: Critical
Action: Create high-priority ticket
Notification: Immediate email + SMS to AD team
```

#### Specific Exit Code Alerts

**Password Complexity Failure**
```
Condition: Exit Code equals 31
Severity: Warning
Message: "Password does not meet complexity requirements"
Action: Notify requestor to update password
```

**User Already Exists**
```
Condition: Exit Code equals 30
Severity: Warning
Message: "Username already exists in Active Directory"
Action: Notify requestor to choose different username
```

**Module Not Available**
```
Condition: Exit Code equals 20
Severity: Critical
Message: "AD PowerShell module not available"
Action: Install RSAT on target device
```

### Step 7: Set Up Execution Approval Workflow

Due to the sensitive nature of creating Domain Admin accounts, configure approval workflow:

1. Navigate to **Setup → Policies → Component Execution**
2. Create new policy: `Domain Admin Component Approval`
3. Configure approval requirements:
   ```
   Component: New-DomainAdminAccount
   Requires Approval: Yes
   Approver Role: Domain Administrator
   Approval Method: Email + Portal
   Timeout: 4 hours
   Notification: Email to approver immediately
   ```

### Step 8: Configure Job Settings (Optional)

If creating as a scheduled job template:

```
Job Name Template: Create Domain Admin - [Username]
Schedule Type: On-demand only (not scheduled)
Retry on Failure: No (manual intervention required)
Save Results: 90 days minimum
```

### Step 9: Documentation and Procedures

Create internal documentation:

**Procedure Document** should include:
1. When Domain Admin accounts should be created
2. Naming convention standards
3. Approval requirements
4. Password policy for admin accounts
5. Regular audit schedule
6. Account removal procedures

**Example Standard Operating Procedure:**
```markdown
## Creating Domain Admin Accounts via Datto RMM

### Prerequisites
1. Business justification documented in ticket
2. Approval from IT Director
3. Naming convention verified (adm.firstname format)
4. Secure password generated (20+ characters)

### Execution Steps
1. Open Datto RMM portal
2. Navigate to target Domain Controller
3. Select "New-DomainAdminAccount" component
4. Fill in required variables:
   - Username: adm.[firstname].[lastname]
   - Password: [from password manager]
   - FirstName: [user first name]
   - LastName: [user last name]
   - Description: Domain Admin - [Full Name] - [Ticket Number]
5. Submit for approval
6. Wait for approval notification
7. Verify execution success in Datto RMM
8. Verify account in Active Directory
9. Document in CMDB/asset management
10. Schedule quarterly access review
```

### Step 10: Security Configurations

#### Restrict Component Access

1. Navigate to **Admin → Roles & Permissions**
2. Create role: `Domain Admin Component Operator`
3. Permissions:
   ```
   Components:
     - View: New-DomainAdminAccount
     - Execute: New-DomainAdminAccount
     - Edit: No
     - Delete: No

   Devices:
     - Filter: Domain Controllers only
     - Scope: Specific sites (as needed)
   ```
4. Assign role only to authorized personnel

#### Enable Audit Logging

Configure comprehensive audit logging:

```
Audit Settings:
  - Log all component executions: Yes
  - Log parameter values: Yes (except passwords)
  - Log execution results: Yes
  - Retention period: 1 year minimum
  - Export to SIEM: Yes (if available)
```

#### Secure Credential Storage

For the Password parameter:

1. **Never use plain text passwords**
2. Use Datto's secure credential storage:
   ```
   Setup → Credentials → Add Credential
   Type: Generic Credential
   Name: [Descriptive name - e.g., "NewAdmin-Dec2025"]
   Username: (not used)
   Password: [Strong password]
   Expiration: Set appropriate expiration
   ```
3. Reference credential in component variable

## Testing Procedure

### Pre-Production Testing

1. **Create Test Environment**
   - Isolated test domain
   - Test Domain Controller
   - Datto RMM agent installed

2. **Test Scenarios**

   **Test 1: Basic Creation**
   ```
   Username: test.admin1
   Password: [Complex password]
   Expected Result: Exit code 0, user created in CN=Users
   ```

   **Test 2: Custom OU**
   ```
   Username: test.admin2
   Password: [Complex password]
   OUPath: OU=TestAdmins,DC=test,DC=local
   Expected Result: Exit code 0, user in specified OU
   ```

   **Test 3: Duplicate User**
   ```
   Username: test.admin1 (already exists)
   Expected Result: Exit code 30, error message
   ```

   **Test 4: Weak Password**
   ```
   Username: test.admin3
   Password: password
   Expected Result: Exit code 31, complexity error
   ```

   **Test 5: Invalid OU**
   ```
   Username: test.admin4
   Password: [Complex password]
   OUPath: OU=DoesNotExist,DC=test,DC=local
   Expected Result: Exit code 34, invalid OU error
   ```

3. **Verification Steps**
   - [ ] Check exit codes match expected
   - [ ] Verify user created in AD
   - [ ] Confirm Domain Admins membership
   - [ ] Review Datto RMM logs
   - [ ] Test account login
   - [ ] Verify security event logs

### Production Validation

Before using in production:

- [ ] All test scenarios passed
- [ ] Security team review completed
- [ ] Approval workflow tested
- [ ] Monitoring alerts configured and tested
- [ ] Documentation completed
- [ ] Training provided to authorized users
- [ ] Incident response plan updated

## Monitoring and Maintenance

### Daily Monitoring

- Review component execution logs
- Verify all executions have proper approval
- Check for failed executions

### Weekly Tasks

- Review created accounts
- Verify accounts are actively used
- Check for unauthorized Domain Admin additions

### Monthly Audit

```powershell
# Generate monthly audit report
$startDate = (Get-Date).AddMonths(-1)

# Accounts created via Datto RMM
Get-ADUser -Filter {Description -like "*Datto RMM*"} -Properties Created, Description |
    Where-Object { $_.Created -ge $startDate } |
    Select-Object Name, Created, Description
```

### Quarterly Review

- Full audit of all Domain Admin accounts
- Remove unused/unnecessary accounts
- Update component if needed
- Review and update security controls
- Validate approval workflow

## Troubleshooting

### Component Won't Execute

**Check:**
- Device has Datto RMM agent running
- Device is online and responsive
- User has permission to execute component
- Approval workflow (if enabled) is not blocking

### Exit Code 20 - Module Not Available

**Resolution:**
```powershell
# Install on Windows Server
Install-WindowsFeature -Name RSAT-AD-PowerShell -IncludeManagementTools

# Verify installation
Get-Module -Name ActiveDirectory -ListAvailable
```

### Exit Code 21 - Cannot Connect to AD

**Check:**
- Device is domain-joined: `(Get-WmiObject Win32_ComputerSystem).PartOfDomain`
- DNS is configured correctly
- Domain Controller is reachable
- Firewall allows AD traffic

### Password Variables Not Working

**Common Issues:**
- Using Text instead of Secure Credential type
- Password contains characters that need escaping
- Datto RMM variable not mapped to environment variable

**Solution:**
- Recreate variable as Secure Credential type
- Ensure Environment Variable name matches script param

## Best Practices Summary

1. **Access Control**
   - Limit component access to authorized personnel only
   - Implement approval workflow for all executions
   - Regular access review

2. **Security**
   - Never store passwords in plain text
   - Use secure credential storage
   - Enable comprehensive audit logging
   - Monitor for unauthorized executions

3. **Documentation**
   - Document all Domain Admin account creations
   - Maintain change logs
   - Include business justification
   - Link to approval records

4. **Monitoring**
   - Alert on all component executions
   - Daily log review
   - Monthly reconciliation
   - Quarterly full audit

5. **Lifecycle Management**
   - Set expiration for temporary accounts
   - Regular usage review
   - Prompt removal of unused accounts
   - Annual policy review

## Support Resources

- **Datto RMM Documentation**: [Datto Documentation Portal]
- **PowerShell AD Module**: `Get-Help New-ADUser -Full`
- **Script Location**: `/home/wferrel/ai/powershell/New-DomainAdminAccount.ps1`
- **README**: `/home/wferrel/ai/powershell/New-DomainAdminAccount-README.md`

---

**Setup Version**: 1.0.0
**Last Updated**: 2025-12-08
**Reviewed By**: [Add reviewer name]
**Next Review Date**: [Add date]
