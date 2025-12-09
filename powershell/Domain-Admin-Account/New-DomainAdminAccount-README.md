# Datto RMM Component: New-DomainAdminAccount

## Overview

This Datto RMM component creates a new Active Directory user account and automatically adds it to the Domain Admins security group. The script includes comprehensive validation, error handling, and security checks to ensure safe and auditable creation of highly privileged accounts.

## Component Information

- **Name**: New-DomainAdminAccount
- **Category**: Active Directory Management
- **Execution Context**: System (SYSTEM account)
- **Recommended Timeout**: 120 seconds
- **Platform**: Windows Server (Domain Controller or RSAT-enabled system)
- **PowerShell Version**: 5.1 or higher
- **Required Modules**: ActiveDirectory

## Features

### Core Functionality
- Creates new Active Directory user accounts
- Automatically adds users to Domain Admins group
- Supports custom OU placement
- Validates password complexity requirements
- Verifies successful creation and group membership

### Security Features
- Password complexity validation (8+ characters, 3 character categories)
- Checks for common weak passwords
- Prevents duplicate account creation
- Security warnings and audit recommendations
- Detailed logging for compliance and troubleshooting

### Error Handling
- Comprehensive exit codes for all failure scenarios
- Validates AD environment and module availability
- Checks domain membership and connectivity
- Verifies OU paths before creation
- Confirms group membership after addition

## Datto RMM Configuration

### Component Variables

Configure these as **Component Variables** in Datto RMM:

| Variable Name | Type | Required | Description | Example |
|---------------|------|----------|-------------|---------|
| `Username` | String | Yes | SAM Account Name (max 20 chars, no special chars) | `adm.jdoe` |
| `Password` | Secure String | Yes | Account password (min 8 chars, complexity required) | Use Datto secure credential |
| `FirstName` | String | No | User's first name | `John` |
| `LastName` | String | No | User's last name | `Doe` |
| `Description` | String | No | Account description | `Admin account for John Doe` |
| `OUPath` | String | No | Target OU Distinguished Name | `OU=AdminUsers,DC=contoso,DC=com` |

### Component Setup in Datto RMM

1. **Create New Component**
   - Navigate to Components → Add Component
   - Select "PowerShell Script"
   - Name: "New-DomainAdminAccount"
   - Category: Active Directory Management

2. **Upload Script**
   - Copy the contents of `New-DomainAdminAccount.ps1`
   - Paste into the script editor

3. **Configure Component Variables**
   - Add each variable listed above
   - Mark `Username` and `Password` as required
   - Set `Password` as a secure/credential type

4. **Set Execution Settings**
   - Execution Context: System
   - Timeout: 120 seconds
   - Platform: Windows Server

5. **Configure Monitoring**
   - Monitor exit code 0 for success
   - Alert on any non-zero exit codes
   - Optional: Create alerts for specific exit codes

## Exit Codes

The component uses specific exit codes for precise error reporting:

| Exit Code | Meaning | Description |
|-----------|---------|-------------|
| 0 | Success | User created and added to Domain Admins successfully |
| 1 | General Failure | Unhandled exception or general error |
| 10 | Missing Parameters | Required parameter (Username or Password) not provided |
| 11 | Invalid Parameters | Parameter value validation failed |
| 20 | Module Not Available | Active Directory PowerShell module not found |
| 21 | Not Domain Joined | Computer not joined to domain or cannot connect to AD |
| 30 | User Already Exists | Username already exists in Active Directory |
| 31 | Password Complexity | Password does not meet complexity requirements |
| 32 | User Creation Failed | Failed to create the user account |
| 33 | Group Membership Failed | Failed to add user to Domain Admins group |
| 34 | Invalid OU Path | Specified OU path does not exist |

## Password Requirements

The component enforces Windows default password complexity requirements:

- **Minimum Length**: 8 characters (recommended minimum)
- **Complexity**: Must contain characters from at least 3 of these 4 categories:
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Digits (0-9)
  - Special characters (!@#$%^&*()_+-=[]{}|;:,.<>?)
- **Weak Password Check**: Blocks common weak passwords (Password1, Admin123, etc.)

### Example Valid Passwords
- `MyP@ssw0rd123`
- `Adm!n2025Secure`
- `C0mpl3x&Strong`

### Example Invalid Passwords
- `password` (no complexity)
- `Pass123` (too short)
- `PASSWORD123` (missing lowercase and special chars)
- `Password1` (common weak password)

## Username Requirements

SAM Account Name restrictions enforced:

- **Maximum Length**: 20 characters
- **Invalid Characters**: Cannot contain: `/ \ [ ] : ; | = , + * ? < > @`
- **Best Practices**:
  - Use naming convention (e.g., `adm.firstname` or `a-firstname`)
  - Avoid spaces
  - Use descriptive names that identify privilege level

## OU Path Configuration

### Default Behavior
If no OU path is specified, the user is created in the default Users container:
```
CN=Users,DC=yourdomain,DC=com
```

### Custom OU Examples
```
OU=AdminUsers,DC=contoso,DC=com
OU=IT,OU=Admins,DC=contoso,DC=com
OU=ServiceAccounts,DC=contoso,DC=local
```

### How to Find OU Distinguished Name
```powershell
# List all OUs in domain
Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName

# Find specific OU
Get-ADOrganizationalUnit -Filter "Name -eq 'AdminUsers'" | Select-Object DistinguishedName
```

## Usage Examples

### Example 1: Basic Domain Admin Creation
**Datto RMM Component Variables:**
```
Username: adm.jsmith
Password: [Secure credential from Datto vault]
FirstName: John
LastName: Smith
Description: Domain Administrator - John Smith
```

### Example 2: Service Account in Custom OU
**Datto RMM Component Variables:**
```
Username: svc.backup
Password: [Secure credential]
Description: Backup Service Account
OUPath: OU=ServiceAccounts,DC=contoso,DC=com
```

### Example 3: Minimal Configuration
**Datto RMM Component Variables:**
```
Username: admin.temp
Password: [Secure credential]
```
(Uses defaults for all optional parameters)

## Security Considerations

### Critical Warnings

1. **Privileged Access**: Domain Admin accounts have unrestricted access to all domain resources
2. **Audit Requirements**: Log all Domain Admin account creations in change management system
3. **MFA Enforcement**: Enable multi-factor authentication for all admin accounts if available
4. **Regular Audits**: Review and remove unnecessary Domain Admin accounts regularly
5. **Principle of Least Privilege**: Only create Domain Admin accounts when absolutely necessary

### Best Practices

1. **Naming Conventions**
   - Use consistent prefixes (e.g., `adm.`, `admin-`, `a-`)
   - Include user identification in username
   - Document naming standard in organizational policy

2. **Password Management**
   - Store passwords in secure vault (use Datto's secure credential storage)
   - Implement password rotation policy
   - Never share Domain Admin credentials
   - Use separate admin accounts per administrator

3. **Access Control**
   - Limit who can run this component in Datto RMM
   - Enable approval workflows for Domain Admin creation
   - Configure alerts for component execution
   - Review execution logs regularly

4. **Documentation**
   - Document reason for account creation
   - Record account owner/purpose in Description field
   - Maintain inventory of all Domain Admin accounts
   - Schedule regular access reviews

5. **Account Lifecycle**
   - Set expiration dates for temporary admin accounts
   - Disable accounts when no longer needed
   - Remove accounts after appropriate retention period
   - Monitor account usage for suspicious activity

## Troubleshooting

### Common Issues

#### Exit Code 20: Active Directory Module Not Available
**Cause**: RSAT tools not installed or AD module not loaded

**Resolution**:
```powershell
# Install RSAT on Windows Server
Install-WindowsFeature -Name RSAT-AD-PowerShell

# Install RSAT on Windows 10/11
Get-WindowsCapability -Name RSAT.ActiveDirectory* -Online | Add-WindowsCapability -Online
```

#### Exit Code 21: Not Domain Joined
**Cause**: Computer not joined to domain or cannot connect to domain controller

**Resolution**:
- Verify computer is domain-joined
- Check network connectivity to domain controller
- Verify DNS is properly configured
- Ensure domain controller is accessible

#### Exit Code 30: User Already Exists
**Cause**: Username already exists in Active Directory

**Resolution**:
- Choose a different username
- If account should be reused, delete existing account first
- Check for accounts in deleted items container

#### Exit Code 31: Password Complexity
**Cause**: Password does not meet complexity requirements

**Resolution**:
- Ensure password is at least 8 characters
- Include uppercase, lowercase, numbers, and special characters
- Avoid common weak passwords
- Review domain password policy: `Get-ADDefaultDomainPasswordPolicy`

#### Exit Code 32: User Creation Failed
**Cause**: Various reasons - permissions, quota, OU issues

**Resolution**:
- Verify script runs with appropriate permissions (Domain Admin or delegated)
- Check OU path is correct and accessible
- Review domain user quota limits
- Examine detailed error message in Datto RMM output

#### Exit Code 33: Group Membership Failed
**Cause**: Cannot add user to Domain Admins group

**Resolution**:
- Verify permissions to modify Domain Admins group
- Check if group is protected from deletion/modification
- Ensure user account was created successfully
- Manually add user to group if needed

#### Exit Code 34: Invalid OU Path
**Cause**: Specified OU does not exist

**Resolution**:
- Verify OU Distinguished Name is correct
- Use `Get-ADOrganizationalUnit` to find correct path
- Ensure OU exists before running component
- Check for typos in OU path

### Viewing Detailed Logs

In Datto RMM, view the component output to see detailed timestamped logs:
```
[2025-12-08 10:30:15] [INFO] Starting Domain Admin Account Creation
[2025-12-08 10:30:16] [SUCCESS] Active Directory module loaded successfully
[2025-12-08 10:30:16] [SUCCESS] Password complexity validation passed
[2025-12-08 10:30:17] [SUCCESS] User account 'adm.jdoe' created successfully
[2025-12-08 10:30:18] [SUCCESS] User successfully added to Domain Admins group
```

## Testing Recommendations

### Pre-Deployment Testing

1. **Test in Lab Environment**
   - Create test domain environment
   - Run component with various parameter combinations
   - Verify all exit codes work as expected
   - Test error conditions (invalid passwords, duplicate users, etc.)

2. **Validation Checklist**
   - [ ] User created in correct OU
   - [ ] User added to Domain Admins group
   - [ ] Password complexity validation works
   - [ ] Duplicate user prevention works
   - [ ] Invalid OU path detection works
   - [ ] Logging output appears in Datto RMM
   - [ ] Exit codes match documented behavior

3. **Security Testing**
   - [ ] Passwords are never logged in plain text
   - [ ] Weak passwords are rejected
   - [ ] Component requires appropriate permissions
   - [ ] Audit trail is created
   - [ ] Security warnings are displayed

### Post-Deployment Verification

After running the component in production:

```powershell
# Verify user was created
Get-ADUser -Identity "adm.username" -Properties *

# Verify group membership
Get-ADPrincipalGroupMembership -Identity "adm.username"

# Verify account is enabled
Get-ADUser -Identity "adm.username" | Select-Object Enabled

# Check last logon (should be never for new account)
Get-ADUser -Identity "adm.username" -Properties LastLogonDate
```

## Compliance and Auditing

### Audit Events to Monitor

This component creates the following Windows Security events:
- **4720**: A user account was created
- **4728**: A member was added to a security-enabled global group (Domain Admins)
- **4732**: A member was added to a security-enabled local group

### Compliance Requirements

Organizations should:
1. Maintain change log of all Domain Admin account creations
2. Document business justification for each account
3. Implement approval workflow before execution
4. Review Domain Admin membership quarterly
5. Audit component execution logs monthly

### Sample Audit Query

```powershell
# Query recent Domain Admin additions
$startDate = (Get-Date).AddDays(-30)
Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id = 4728
    StartTime = $startDate
} | Where-Object { $_.Message -like '*Domain Admins*' }
```

## Maintenance

### Regular Reviews

- **Monthly**: Review component execution logs in Datto RMM
- **Quarterly**: Audit all Domain Admin accounts created by component
- **Annually**: Review and update component parameters and security controls

### Updates and Versioning

Track component versions and maintain changelog:

**Version 1.0.0** (2025-12-08)
- Initial release
- Password complexity validation
- Support for custom OU placement
- Comprehensive error handling and exit codes
- Security warnings and audit logging

## Support and Contact

For issues with this component:

1. Review Datto RMM execution logs for detailed error messages
2. Check exit code against documented codes above
3. Verify all prerequisites are met (AD module, domain membership, permissions)
4. Test in lab environment before production deployment

## License and Legal

This component is provided as-is for use with Datto RMM. Organizations are responsible for:
- Ensuring compliance with internal security policies
- Proper audit and change management procedures
- Securing credentials and restricting component access
- Regular security reviews of privileged accounts

**DISCLAIMER**: Creating Domain Admin accounts carries significant security risk. Use this component only when necessary and with appropriate controls in place.

---

**Last Updated**: 2025-12-08
**Component Version**: 1.0.0
**Minimum PowerShell Version**: 5.1
**Tested On**: Windows Server 2019, 2022
