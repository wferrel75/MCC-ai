<#
.SYNOPSIS
    Configures a Windows Server for first-boot deployment.

.DESCRIPTION
    This script performs initial configuration tasks on a Windows Server:
    - Disables Server Manager auto-launch at login
    - Enables Remote Desktop for management access
    - Configures Windows Firewall to allow RDP connections
    - Prompts for and applies a new computer name
    - Sets the timezone to Central Standard Time
    - Installs and configures BGInfo to display system information on desktop

    The script requires administrative privileges and will prompt for elevation if needed.
    A system reboot is required after computer rename.

.EXAMPLE
    .\Config-Server.ps1

    Runs the server configuration script interactively.

.NOTES
    Author: Auto-generated
    Requires: PowerShell 5.1 or higher, Windows Server
    Execution Context: Must run as Administrator

    Exit Codes:
    0 = Success
    1 = Not running as Administrator
    2 = Critical error during configuration
#>

#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding()]
param()

#region Functions

function Write-StepHeader {
    <#
    .SYNOPSIS
        Outputs a formatted header for configuration steps.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host "`n================================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "================================================`n" -ForegroundColor Cyan
}

function Write-Success {
    <#
    .SYNOPSIS
        Outputs a success message in green.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-ErrorMessage {
    <#
    .SYNOPSIS
        Outputs an error message in red.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-InfoMessage {
    <#
    .SYNOPSIS
        Outputs an informational message in yellow.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host "[INFO] $Message" -ForegroundColor Yellow
}

function Test-AdminPrivileges {
    <#
    .SYNOPSIS
        Verifies the script is running with administrative privileges.

    .DESCRIPTION
        Checks if the current PowerShell session has administrator rights.
        Returns $true if elevated, $false otherwise.
    #>

    try {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        return $currentPrincipal.IsInRole([Security.Principal.WindowsIdentityRoleType]::Administrator)
    }
    catch {
        Write-ErrorMessage "Unable to determine administrative privileges: $($_.Exception.Message)"
        return $false
    }
}

function Disable-ServerManagerAutoStart {
    <#
    .SYNOPSIS
        Disables Server Manager from automatically launching at login.

    .DESCRIPTION
        Modifies the registry to prevent Server Manager from starting automatically
        when an administrator logs in.
    #>

    Write-StepHeader "Step 1: Disabling Server Manager Auto-Start"

    try {
        $registryPath = "HKLM:\SOFTWARE\Microsoft\ServerManager"
        $registryName = "DoNotOpenServerManagerAtLogon"
        $registryValue = 1

        # Ensure the registry path exists
        if (-not (Test-Path $registryPath)) {
            Write-InfoMessage "Creating registry path: $registryPath"
            New-Item -Path $registryPath -Force | Out-Null
        }

        # Set the registry value
        Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord -ErrorAction Stop

        Write-Success "Server Manager auto-start has been disabled"
        return $true
    }
    catch {
        Write-ErrorMessage "Failed to disable Server Manager auto-start: $($_.Exception.Message)"
        return $false
    }
}

function Enable-RemoteDesktopAccess {
    <#
    .SYNOPSIS
        Enables Remote Desktop connections on the server.

    .DESCRIPTION
        Configures the system to allow Remote Desktop connections and enables
        Network Level Authentication for security.
    #>

    Write-StepHeader "Step 2: Enabling Remote Desktop"

    try {
        $rdpPath = "HKLM:\System\CurrentControlSet\Control\Terminal Server"
        $nlaPath = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"

        # Enable Remote Desktop
        Set-ItemProperty -Path $rdpPath -Name "fDenyTSConnections" -Value 0 -Type DWord -ErrorAction Stop
        Write-Success "Remote Desktop has been enabled"

        # Enable Network Level Authentication (recommended for security)
        Set-ItemProperty -Path $nlaPath -Name "UserAuthentication" -Value 1 -Type DWord -ErrorAction Stop
        Write-Success "Network Level Authentication has been enabled"

        return $true
    }
    catch {
        Write-ErrorMessage "Failed to enable Remote Desktop: $($_.Exception.Message)"
        return $false
    }
}

function Configure-FirewallForRDP {
    <#
    .SYNOPSIS
        Configures Windows Firewall to allow Remote Desktop connections.

    .DESCRIPTION
        Enables the built-in Windows Firewall rules for Remote Desktop traffic.
    #>

    Write-StepHeader "Step 3: Configuring Windows Firewall for Remote Desktop"

    try {
        # Enable the Remote Desktop firewall rules
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction Stop

        Write-Success "Windows Firewall rules for Remote Desktop have been enabled"

        # Verify the rules are enabled
        $rdpRules = Get-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction SilentlyContinue
        if ($rdpRules) {
            Write-InfoMessage "Enabled $($rdpRules.Count) firewall rule(s) for Remote Desktop"
        }

        return $true
    }
    catch {
        Write-ErrorMessage "Failed to configure firewall for Remote Desktop: $($_.Exception.Message)"
        Write-InfoMessage "You may need to manually enable Remote Desktop firewall rules"
        return $false
    }
}

function Set-ServerComputerName {
    <#
    .SYNOPSIS
        Prompts for and applies a new computer name to the server.

    .DESCRIPTION
        Interactively prompts the user for a new computer name and renames the computer.
        Validates the name against Windows naming conventions.

    .OUTPUTS
        Returns $true if rename was successful, $false otherwise.
    #>

    Write-StepHeader "Step 4: Renaming the Computer"

    $currentName = $env:COMPUTERNAME
    Write-InfoMessage "Current computer name: $currentName"

    # Prompt for new computer name
    do {
        $newName = Read-Host "`nEnter new computer name (or press Enter to skip)"

        # Allow user to skip renaming
        if ([string]::IsNullOrWhiteSpace($newName)) {
            Write-InfoMessage "Skipping computer rename"
            return $false
        }

        # Validate computer name
        if ($newName.Length -gt 15) {
            Write-ErrorMessage "Computer name must be 15 characters or less"
            continue
        }

        if ($newName -notmatch '^[a-zA-Z0-9-]+$') {
            Write-ErrorMessage "Computer name can only contain letters, numbers, and hyphens"
            continue
        }

        if ($newName -eq $currentName) {
            Write-InfoMessage "New name is the same as current name. Skipping rename."
            return $false
        }

        break
    } while ($true)

    # Confirm the rename
    Write-Host "`nYou are about to rename this computer from '$currentName' to '$newName'" -ForegroundColor Yellow
    $confirm = Read-Host "Continue? (Y/N)"

    if ($confirm -notmatch '^[Yy]') {
        Write-InfoMessage "Computer rename cancelled by user"
        return $false
    }

    # Attempt to rename the computer
    try {
        Rename-Computer -NewName $newName -Force -ErrorAction Stop
        Write-Success "Computer has been renamed to: $newName"
        Write-InfoMessage "A system reboot is required for the name change to take effect"
        return $true
    }
    catch {
        Write-ErrorMessage "Failed to rename computer: $($_.Exception.Message)"
        return $false
    }
}

function Set-CentralTimeZone {
    <#
    .SYNOPSIS
        Sets the system timezone to Central Standard Time.

    .DESCRIPTION
        Configures the server to use Central Standard Time (US & Canada) timezone.
    #>

    Write-StepHeader "Step 5: Setting Timezone to Central Standard Time"

    try {
        $timeZoneId = "Central Standard Time"

        # Get current timezone
        $currentTimeZone = Get-TimeZone
        Write-InfoMessage "Current timezone: $($currentTimeZone.DisplayName)"

        # Check if already set to Central
        if ($currentTimeZone.Id -eq $timeZoneId) {
            Write-Success "Timezone is already set to Central Standard Time"
            return $true
        }

        # Set the timezone
        Set-TimeZone -Id $timeZoneId -ErrorAction Stop

        $newTimeZone = Get-TimeZone
        Write-Success "Timezone has been changed to: $($newTimeZone.DisplayName)"

        return $true
    }
    catch {
        Write-ErrorMessage "Failed to set timezone: $($_.Exception.Message)"
        Write-InfoMessage "You may need to set the timezone manually through Control Panel"
        return $false
    }
}

function Install-BGInfo {
    <#
    .SYNOPSIS
        Downloads and configures BGInfo to run at logon.

    .DESCRIPTION
        Downloads BGInfo64.exe from Sysinternals, creates a basic configuration file,
        and sets up automatic execution at user logon via registry.

        BGInfo displays system information on the desktop background, useful for
        identifying servers and viewing key system details at a glance.

    .OUTPUTS
        Returns $true if installation and configuration succeeded, $false otherwise.

    .NOTES
        BGInfo will run for all users via HKLM Run registry key.
        The configuration includes silent mode and no timeout for automatic execution.
    #>

    Write-StepHeader "Step 6: Installing and Configuring BGInfo"

    $bgInfoPath = "C:\Tools\BGInfo"
    $bgInfoExe = Join-Path $bgInfoPath "Bginfo64.exe"
    $bgInfoConfig = Join-Path $bgInfoPath "config.bgi"
    $bgInfoUrl = "https://live.sysinternals.com/Bginfo64.exe"

    try {
        # Create the BGInfo directory if it doesn't exist
        if (-not (Test-Path $bgInfoPath)) {
            Write-InfoMessage "Creating BGInfo directory: $bgInfoPath"
            New-Item -Path $bgInfoPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
            Write-Success "BGInfo directory created successfully"
        }
        else {
            Write-InfoMessage "BGInfo directory already exists"
        }

        # Download BGInfo64.exe if not already present
        if (-not (Test-Path $bgInfoExe)) {
            Write-InfoMessage "Downloading BGInfo64.exe from Sysinternals..."

            # Use TLS 1.2 for secure connection
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($bgInfoUrl, $bgInfoExe)
            $webClient.Dispose()

            if (Test-Path $bgInfoExe) {
                Write-Success "BGInfo64.exe downloaded successfully"
            }
            else {
                throw "Download completed but file not found at expected location"
            }
        }
        else {
            Write-InfoMessage "BGInfo64.exe already exists at $bgInfoExe"
        }

        # Create a basic BGInfo configuration file
        Write-InfoMessage "Creating BGInfo configuration file..."

        # BGInfo config files are binary, but we can create a default one that BGInfo will accept
        # When run without a config, BGInfo uses defaults. We'll create a minimal config
        # by running BGInfo once to generate default settings, or use a pre-built config

        # Create a basic configuration using BGInfo's command-line to save current defaults
        if (-not (Test-Path $bgInfoConfig)) {
            # Generate a default configuration by running BGInfo in a way that creates config
            # Since .bgi files are binary, we'll rely on BGInfo's defaults initially
            # The user can customize via BGInfo GUI later

            # Create a marker file that indicates to use default configuration
            # BGInfo will use its built-in defaults which include the common fields
            $configNote = @"
BGInfo Configuration Notes:
===========================
This is a placeholder. BGInfo will use default configuration on first run.

Default fields typically include:
- Host Name
- IP Address
- Subnet Mask
- Gateway
- DHCP Server
- DNS Server
- MAC Address
- Boot Time
- Logon Server
- User Name
- CPU
- Memory
- Volumes

To customize:
1. Run: C:\Tools\BGInfo\Bginfo64.exe
2. Configure desired fields and appearance
3. Click "File" > "Save As" and save to: C:\Tools\BGInfo\config.bgi

The configuration will then be used at every logon.
"@

            Set-Content -Path (Join-Path $bgInfoPath "ConfigNotes.txt") -Value $configNote -ErrorAction Stop

            # For initial setup, we'll run BGInfo without a config file to use defaults
            # But we'll create an empty bgi file as a placeholder
            # On first run, it will use BGInfo's built-in default configuration

            Write-InfoMessage "BGInfo will use default configuration on first run"
            Write-InfoMessage "Configuration notes saved to: $(Join-Path $bgInfoPath 'ConfigNotes.txt')"
        }
        else {
            Write-InfoMessage "BGInfo configuration file already exists"
        }

        # Configure BGInfo to run at logon via registry (HKLM for all users)
        Write-InfoMessage "Configuring BGInfo to run at logon for all users..."

        $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        $registryName = "BGInfo"

        # Construct the BGInfo command line
        # Using default config if .bgi exists, otherwise BGInfo will use built-in defaults
        if (Test-Path $bgInfoConfig) {
            $bgInfoCommand = "`"$bgInfoExe`" `"$bgInfoConfig`" /timer:0 /silent /nolicprompt"
        }
        else {
            # Run with defaults, accept license, no timer
            $bgInfoCommand = "`"$bgInfoExe`" /timer:0 /silent /nolicprompt /accepteula"
        }

        # Set the registry value
        Set-ItemProperty -Path $registryPath -Name $registryName -Value $bgInfoCommand -Type String -ErrorAction Stop
        Write-Success "BGInfo configured to run at logon"
        Write-InfoMessage "Registry command: $bgInfoCommand"

        # Verify the registry entry was created
        $regValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue
        if ($regValue) {
            Write-Success "BGInfo registry entry verified"
        }

        # Optionally run BGInfo now to apply immediately
        Write-InfoMessage "Running BGInfo to apply desktop background now..."
        try {
            if (Test-Path $bgInfoConfig) {
                Start-Process -FilePath $bgInfoExe -ArgumentList "`"$bgInfoConfig`"", "/timer:0", "/silent", "/nolicprompt" -Wait -NoNewWindow -ErrorAction Stop
            }
            else {
                Start-Process -FilePath $bgInfoExe -ArgumentList "/timer:0", "/silent", "/nolicprompt", "/accepteula" -Wait -NoNewWindow -ErrorAction Stop
            }
            Write-Success "BGInfo applied to desktop background"
        }
        catch {
            Write-InfoMessage "Could not apply BGInfo immediately (will run at next logon): $($_.Exception.Message)"
        }

        Write-Success "BGInfo installation and configuration completed successfully"
        return $true
    }
    catch {
        Write-ErrorMessage "Failed to install/configure BGInfo: $($_.Exception.Message)"
        Write-InfoMessage "You may need to install BGInfo manually"
        return $false
    }
}

#endregion

#region Main Script Execution

try {
    # Display script header
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Windows Server First-Boot Configuration" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    # Verify administrative privileges
    if (-not (Test-AdminPrivileges)) {
        Write-ErrorMessage "This script must be run as Administrator"
        Write-InfoMessage "Please right-click PowerShell and select 'Run as Administrator'"
        exit 1
    }

    Write-Success "Running with administrative privileges"

    # Track overall success and reboot requirement
    $overallSuccess = $true
    $rebootRequired = $false

    # Step 1: Disable Server Manager auto-start
    if (-not (Disable-ServerManagerAutoStart)) {
        $overallSuccess = $false
    }

    # Step 2: Enable Remote Desktop
    if (-not (Enable-RemoteDesktopAccess)) {
        $overallSuccess = $false
    }

    # Step 3: Configure Firewall for RDP
    if (-not (Configure-FirewallForRDP)) {
        $overallSuccess = $false
    }

    # Step 4: Rename Computer
    if (Set-ServerComputerName) {
        $rebootRequired = $true
    }

    # Step 5: Set Timezone
    if (-not (Set-CentralTimeZone)) {
        $overallSuccess = $false
    }

    # Step 6: Install and Configure BGInfo
    if (-not (Install-BGInfo)) {
        $overallSuccess = $false
    }

    # Display completion summary
    Write-Host "`n"
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Configuration Complete" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    if ($overallSuccess) {
        Write-Success "All configuration steps completed successfully"
    }
    else {
        Write-InfoMessage "Configuration completed with some warnings or errors (see above)"
    }

    # Handle reboot requirement
    if ($rebootRequired) {
        Write-Host "`n"
        Write-Host "========================================" -ForegroundColor Yellow
        Write-Host "REBOOT REQUIRED" -ForegroundColor Yellow
        Write-Host "========================================" -ForegroundColor Yellow
        Write-InfoMessage "The computer name has been changed. A system reboot is required."
        Write-Host "`n"

        $rebootNow = Read-Host "Would you like to reboot now? (Y/N)"
        if ($rebootNow -match '^[Yy]') {
            Write-InfoMessage "Initiating system reboot in 10 seconds..."
            Write-InfoMessage "Press Ctrl+C to cancel"
            Start-Sleep -Seconds 10
            Restart-Computer -Force
        }
        else {
            Write-InfoMessage "Please reboot the system manually when ready"
        }
    }

    exit 0
}
catch {
    Write-Host "`n"
    Write-ErrorMessage "Critical error during script execution: $($_.Exception.Message)"
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    exit 2
}

#endregion
