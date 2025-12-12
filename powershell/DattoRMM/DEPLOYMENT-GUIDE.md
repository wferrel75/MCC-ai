# BGInfo Deployment Guide for Datto RMM

Quick start guide for deploying BGInfo to managed devices using Datto RMM.

## Prerequisites Checklist

- [ ] Datto RMM account with component creation privileges
- [ ] BGInfo configuration file (.bgi) ready
- [ ] (Optional) BGInfo executables for offline deployment
- [ ] Target devices running Windows 7+ / Server 2008 R2+

## Deployment Methods

### Method 1: Quick Job (One-Time Deployment)

**Best for:** Testing or deploying to specific devices

1. **Prepare Files:**
   - Download `Deploy-BGInfo.ps1`
   - Prepare your `.bgi` configuration file
   - (Optional) Download BGInfo executables

2. **Create Quick Job:**
   - Navigate to: **Devices** → Select target device(s)
   - Click: **Quick Job** → **PowerShell Script**
   - Upload: `Deploy-BGInfo.ps1`
   - Upload: Your `.bgi` file
   - Upload (optional): `Bginfo64.exe` and/or `Bginfo.exe`

3. **Execute:**
   - Click: **Run**
   - Monitor: Job status in real-time

4. **Verify:**
   - Check: Exit code = 0 (success)
   - Review: Detailed logs in job output

---

### Method 2: Component (Reusable Deployment)

**Best for:** Organization-wide deployment or repeated use

#### Step 1: Create Component

1. Navigate to: **Setup** → **Components**
2. Click: **New Component**
3. Configure:
   - **Name:** `Deploy BGInfo`
   - **Type:** `PowerShell Script`
   - **Category:** `Desktop Management` (or your preference)

#### Step 2: Upload Files

1. **Main Script:**
   - Click: **Upload File**
   - Select: `Deploy-BGInfo.ps1`

2. **Configuration File:**
   - Click: **Upload File**
   - Select: Your `.bgi` file (e.g., `corporate.bgi`)

3. **Offline Executables (Optional):**
   - Click: **Upload File**
   - Select: `Bginfo64.exe`
   - Click: **Upload File**
   - Select: `Bginfo.exe`

#### Step 3: Configure Component Script

**Script Content:**
```powershell
# Basic deployment with defaults
.\Deploy-BGInfo.ps1
```

**Or with custom parameters:**
```powershell
# Custom installation path
.\Deploy-BGInfo.ps1 -DestinationPath "C:\Tools\BGInfo"
```

**Or extended timeout:**
```powershell
# For slow connections
.\Deploy-BGInfo.ps1 -DownloadTimeout 60
```

#### Step 4: Set Monitoring

**Success Conditions:**
- Exit Code: `0`
- Output Contains: `Deployment Completed Successfully`

**Warning Conditions:**
- Exit Code: `5` (No logged-in users - BGInfo will run at next logon)

**Failure Conditions:**
- Exit Code: `1`, `2`, `3`, `4`, `99`

#### Step 5: Deploy Component

**Option A: Manual Deployment**
1. Navigate to: **Devices** → Select device(s)
2. Click: **Run Component**
3. Select: `Deploy BGInfo`
4. Click: **Run**

**Option B: Policy Assignment**
1. Navigate to: **Setup** → **Policies**
2. Select or create policy
3. Add component: `Deploy BGInfo`
4. Set execution: **On Policy Apply** or **Scheduled**

**Option C: Quick Job from Component**
1. Navigate to: **Quick Jobs**
2. Create: **New Quick Job**
3. Select: **Component**
4. Choose: `Deploy BGInfo`
5. Select devices and run

---

### Method 3: Automated Deployment (Advanced)

**Best for:** New device onboarding automation

#### Create Onboarding Policy

1. Navigate to: **Setup** → **Policies**
2. Create: **New Policy**
   - Name: `Workstation Onboarding`
3. Add Components:
   - `Deploy BGInfo` (your component)
   - Other onboarding tasks
4. Configure Trigger: **On Device Registration**
5. Apply to: **Site(s)** or **Device Type**

#### Scheduled Updates

**Update BGInfo config monthly:**
1. Create: **Scheduled Task**
2. Component: `Deploy BGInfo`
3. Schedule: `Monthly - First Sunday - 2:00 AM`
4. Target: `All Workstations`

---

## Configuration Options

### Basic Configuration (Recommended)

```powershell
.\Deploy-BGInfo.ps1
```

**Installs to:** `C:\MCC\BGInfo`
**Timeout:** 30 seconds
**Behavior:** Auto-download or use local files

### Custom Installation Path

```powershell
.\Deploy-BGInfo.ps1 -DestinationPath "C:\ProgramData\BGInfo"
```

Use when:
- Company standard dictates different path
- C:\MCC not accessible
- Consistent with other tools

### Extended Timeout

```powershell
.\Deploy-BGInfo.ps1 -DownloadTimeout 60
```

Use when:
- Remote/branch offices with slow internet
- Sites with bandwidth limitations
- Download timeouts occurring

### Combined Parameters

```powershell
.\Deploy-BGInfo.ps1 -DestinationPath "C:\Tools\BGInfo" -DownloadTimeout 90
```

---

## File Preparation

### Creating .bgi Configuration Files

#### Option 1: Using BGInfo GUI

1. **Download BGInfo:**
   - Visit: [Sysinternals BGInfo](https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo)
   - Download: BGInfo.zip
   - Extract: `Bginfo64.exe`

2. **Configure BGInfo:**
   - Run: `Bginfo64.exe`
   - Click: **Fields** button
   - Add/remove: Desired information fields
   - Arrange: Field positions
   - Configure: Font, colors, background

3. **Common Field Recommendations:**
   - Computer Name
   - IP Address
   - Logged On User
   - CPU
   - Memory
   - OS Version
   - Last Boot Time
   - Network Card (MAC Address)

4. **Save Configuration:**
   - Click: **File** → **Save As**
   - Name: `corporate.bgi` (avoid `default.bgi`)
   - Save location: With deployment script

#### Option 2: Using Existing Configuration

If you have an existing BGInfo deployment:
1. Locate: `C:\MCC\BGInfo\BGInfo.bgi` (or your current path)
2. Copy: Configuration file
3. Rename: To something descriptive (e.g., `helpdesk.bgi`, `server.bgi`)

#### Option 3: Department-Specific Configurations

Create multiple configurations for different use cases:

```
corporate.bgi       - Standard corporate workstations
server.bgi          - Server-specific fields (services, uptime)
helpdesk.bgi        - Extra detail for support staff
executive.bgi       - Minimal information display
kiosk.bgi          - Public/kiosk displays
```

**Deploy different configs:**
- Create separate components for each .bgi
- Name: `Deploy BGInfo - Corporate`, `Deploy BGInfo - Server`, etc.
- Apply via policies to appropriate device groups

---

## Offline Deployment Package

### When to Use Offline Deployment

- Air-gapped networks
- High-security environments
- Unreliable internet connectivity
- Proxy/firewall restrictions

### Preparing Offline Package

1. **Download BGInfo Executables:**
   - Visit: [Sysinternals Live](https://live.sysinternals.com/)
   - Download: `Bginfo64.exe`
   - Download: `Bginfo.exe` (for 32-bit systems)

2. **Package Structure:**
   ```
   [Component Files]/
   ├── Deploy-BGInfo.ps1
   ├── corporate.bgi
   ├── Bginfo64.exe
   └── Bginfo.exe
   ```

3. **Upload to Datto RMM:**
   - All four files uploaded to same component
   - Script automatically detects and uses local executables

---

## Monitoring and Verification

### Real-Time Monitoring (During Deployment)

**Watch Deployment Status:**
1. Navigate to: **Jobs** → **Activity**
2. Filter: Your deployment job
3. Monitor: Progress and exit codes
4. View: Real-time logs

**Expected Timeline:**
- Download: 2-5 seconds
- Installation: 1-2 seconds
- Configuration: < 1 second
- Execution: 1-2 seconds per user
- **Total:** 5-15 seconds per device

### Post-Deployment Verification

#### Automated Verification (Component Monitor)

Create a monitoring component:

```powershell
# BGInfo-Check.ps1
$BGInfoExe = "C:\MCC\BGInfo\BGInfo.exe"
$BGInfoConfig = "C:\MCC\BGInfo\BGInfo.bgi"
$RegEntry = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo" -ErrorAction SilentlyContinue

if ((Test-Path $BGInfoExe) -and (Test-Path $BGInfoConfig) -and ($null -ne $RegEntry)) {
    Write-Output "BGInfo installed and configured correctly"
    exit 0
} else {
    Write-Output "BGInfo installation incomplete"
    exit 1
}
```

**Add to monitoring policy:**
- Run: Daily
- Alert on: Exit code 1

#### Manual Verification

**Check Installation Files:**
```powershell
Test-Path "C:\MCC\BGInfo\BGInfo.exe"
Test-Path "C:\MCC\BGInfo\BGInfo.bgi"
```

**Check Registry Autorun:**
```powershell
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo"
```

**Expected Output:**
```
BGInfo : "C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt
```

**Verify Wallpaper:**
- Remote into device or request screenshot
- System information should be visible on desktop wallpaper

---

## Rollout Strategies

### Pilot Deployment (Recommended)

**Phase 1: IT Department (Week 1)**
- Deploy to: 5-10 IT staff workstations
- Monitor: User feedback and issues
- Validate: Configuration displays correctly

**Phase 2: Single Department (Week 2)**
- Deploy to: One small department (10-20 users)
- Monitor: Help desk tickets
- Adjust: Configuration if needed

**Phase 3: Organization-Wide (Week 3+)**
- Deploy to: All remaining devices
- Schedule: Off-hours or maintenance windows
- Communicate: Inform users of desktop change

### By Device Type

**Stage 1: Workstations**
- Deploy via policy: `Device Type = Workstation`
- Monitor for 48 hours

**Stage 2: Laptops**
- Deploy via policy: `Device Type = Laptop`
- Monitor for 48 hours

**Stage 3: Servers**
- Deploy via policy: `Device Type = Server`
- Use server-specific .bgi configuration

### By Location

**Headquarters First:**
- Best connectivity
- Easy to address issues in person
- IT staff available

**Branch Offices:**
- After HQ success
- One location at a time
- Schedule during business hours for support

**Remote Workers:**
- Last deployment group
- Include offline executables
- Extended timeout recommended

---

## Maintenance

### Updating BGInfo Configuration

**Scenario:** Need to change displayed fields or layout

1. **Modify .bgi file:**
   - Open BGInfo locally
   - Make changes
   - Save as new file (e.g., `corporate-v2.bgi`)

2. **Update component:**
   - Remove old .bgi file
   - Upload new .bgi file

3. **Re-deploy:**
   - Run component on all devices
   - Script will replace existing config
   - BGInfo will update at next user logon

**Force Immediate Update:**
```powershell
# Add to component script
.\Deploy-BGInfo.ps1
# Force refresh for current user
& "C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt
```

### Updating BGInfo Executable

**When to update:**
- Microsoft releases new BGInfo version
- Bug fixes available
- New features needed

**Process:**
1. Download latest BGInfo from Sysinternals
2. Upload new executables to component
3. Re-deploy component
4. Script automatically replaces old version

### Scheduled Refresh

**Ensure BGInfo stays current:**

Create scheduled component:
```powershell
# Refresh-BGInfo.ps1
& "C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt
exit 0
```

**Schedule:**
- Frequency: Weekly
- Time: Sunday 3:00 AM
- Target: All devices with BGInfo

---

## Uninstallation

### Remove BGInfo

Create uninstall component:

```powershell
# Uninstall-BGInfo.ps1

# Remove registry autorun
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo" -ErrorAction SilentlyContinue

# Remove files
Remove-Item -Path "C:\MCC\BGInfo" -Recurse -Force -ErrorAction SilentlyContinue

# Reset wallpaper to Windows default
Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -ErrorAction SilentlyContinue
rundll32.exe user32.dll, UpdatePerUserSystemParameters

Write-Output "BGInfo removed successfully"
exit 0
```

---

## Best Practices

### Do's

✅ **Test configuration** before organization-wide deployment
✅ **Include offline executables** for reliability
✅ **Monitor exit codes** in Datto RMM
✅ **Use descriptive .bgi filenames** (not `default.bgi`)
✅ **Document custom configurations** for your organization
✅ **Schedule off-hours** for initial deployment
✅ **Communicate with users** about desktop changes
✅ **Create department-specific configs** when appropriate

### Don'ts

❌ **Don't display sensitive information** (passwords, keys)
❌ **Don't deploy untested configurations**
❌ **Don't ignore exit code 2** (missing executables)
❌ **Don't clutter wallpaper** with too many fields
❌ **Don't forget to include .bgi file** in component
❌ **Don't use default.bgi** as your custom filename
❌ **Don't deploy during peak hours** (first time)

---

## Quick Reference

### Common Commands

| Task | Command |
|------|---------|
| Basic deployment | `.\Deploy-BGInfo.ps1` |
| Custom path | `.\Deploy-BGInfo.ps1 -DestinationPath "C:\Tools\BGInfo"` |
| Extended timeout | `.\Deploy-BGInfo.ps1 -DownloadTimeout 60` |
| Manual execution | `& "C:\MCC\BGInfo\BGInfo.exe" "C:\MCC\BGInfo\BGInfo.bgi" /timer:0 /silent /nolicprompt` |
| Check installation | `Test-Path "C:\MCC\BGInfo\BGInfo.exe"` |
| Check autorun | `Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo"` |

### Exit Codes Quick Reference

| Code | Meaning | Action |
|------|---------|--------|
| 0 | Success | None |
| 1 | Directory creation failed | Check permissions |
| 2 | Executable not found | Upload local files |
| 3 | Config file missing | Upload .bgi file |
| 4 | Registry failed | Check admin rights |
| 5 | User execution failed | Normal if no users logged in |

### File Locations

| File | Default Location |
|------|------------------|
| Executable | `C:\MCC\BGInfo\BGInfo.exe` |
| Configuration | `C:\MCC\BGInfo\BGInfo.bgi` |
| Registry Key | `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run` |
| Registry Value | `BGInfo` |

---

## Support Resources

- **Main Documentation:** [README.md](README.md)
- **Troubleshooting Guide:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **BGInfo Official Docs:** [Microsoft Sysinternals](https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo)
- **Datto RMM Help:** [RMM Documentation](https://rmm.datto.com/help)

---

## Appendix: Sample .bgi Configurations

### Minimal Configuration (Executive/Clean)
- Computer Name
- IP Address
- Logged On User

### Standard Configuration (Most Common)
- Computer Name
- IP Address
- Logged On User
- CPU
- Memory
- OS Version
- Last Boot Time

### Detailed Configuration (IT/Support)
- Computer Name
- IP Address
- Logged On User
- CPU (with speed)
- Memory (Total/Available)
- OS Version (with build)
- Last Boot Time
- Network Card (with MAC)
- Default Gateway
- DNS Servers
- Disk Space (all drives)

### Server Configuration
- Server Name
- IP Address(es)
- OS Version
- CPU Count
- Total Memory
- Uptime
- Domain/Workgroup
- Active Directory Site
- Running Services Count
- Logged On Users Count
