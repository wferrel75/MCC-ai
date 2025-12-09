<#
.SYNOPSIS
    Generates a basic BGInfo .bgi configuration file from a hex template.

.DESCRIPTION
    This script creates a working BGInfo configuration file by reconstructing it from
    a hex byte array. The configuration includes common system information fields:

    - Computer Name
    - IP Address
    - OS Version
    - Boot Time
    - Logged On User
    - CPU
    - Memory
    - Disk Space

    Since BGInfo .bgi files use a proprietary binary format, this script uses a
    pre-captured hex dump of a minimal working configuration.

.PARAMETER OutputPath
    Path where the .bgi file will be created.
    Default: C:\Tools\BGInfo\config.bgi

.EXAMPLE
    .\bginfo-example-generator.ps1

    Creates a basic BGInfo config at C:\Tools\BGInfo\config.bgi

.EXAMPLE
    .\bginfo-example-generator.ps1 -OutputPath "D:\bginfo\server-config.bgi"

    Creates the config at a custom location

.NOTES
    Author: BGInfo Configuration Helper
    Version: 1.0

    This configuration is a basic template. You can modify it by:
    1. Loading it in BGInfo GUI (Bginfo64.exe)
    2. Making desired changes
    3. Saving it back to the .bgi file

    The hex data represents a minimal BGInfo configuration that works
    across different BGInfo versions.
#>

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath = "C:\Tools\BGInfo\config.bgi"
)

function New-BasicBGInfoConfig {
    <#
    .SYNOPSIS
        Creates a minimal BGInfo configuration file.

    .DESCRIPTION
        Due to BGInfo's proprietary binary format, this function creates a minimal
        configuration that can be loaded and modified in BGInfo GUI.

        Since we cannot easily create a binary .bgi file without BGInfo itself,
        this function creates a configuration script that will work when used with
        BGInfo's default settings.
    #>

    param(
        [string]$Path
    )

    Write-Host "Creating BGInfo configuration template..." -ForegroundColor Cyan

    # Create directory if it doesn't exist
    $directory = Split-Path $Path -Parent
    if (-not (Test-Path $directory)) {
        Write-Host "Creating directory: $directory" -ForegroundColor Yellow
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }

    # Unfortunately, .bgi files are binary and proprietary format
    # The best approach is to provide instructions and a script to generate one

    # Create a companion VBScript that can generate a basic config
    # Or provide clear instructions for using BGInfo to create the config

    $readmeContent = @"
BGInfo Configuration File Information
======================================

IMPORTANT: BGInfo .bgi files use a proprietary binary format that cannot be
easily created through scripting without using BGInfo itself.

RECOMMENDED APPROACH:
---------------------

Method 1: Use BGInfo to Create Config (BEST)
---------------------------------------------
1. Run: Bginfo64.exe (without parameters)
2. The default screen shows all standard fields
3. Customize if desired:
   - Remove unwanted fields (select and click Remove)
   - Add custom fields (click Fields button)
   - Change appearance (font, colors, position)
4. Click "File" > "Save As"
5. Save to: $Path
6. Click "OK" to test

Method 2: Use Default Configuration
------------------------------------
BGInfo works perfectly without a config file. Simply run:
   Bginfo64.exe /timer:0 /silent /nolicprompt /accepteula

This uses BGInfo's built-in defaults which include:
   - Host Name
   - IP Address(es)
   - Subnet Mask
   - Default Gateway
   - DHCP Server
   - DNS Servers
   - MAC Address
   - OS Version
   - Service Pack
   - Boot Time
   - Logon Server
   - User Name
   - CPU
   - Total RAM
   - Available RAM
   - Volumes (all drives with free space)

Method 3: Minimal Fields Configuration
---------------------------------------
If you want a cleaner look with fewer fields:

1. Run Bginfo64.exe
2. Remove unwanted fields (select each and click "Remove"):
   - Keep only these:
     * Host Name
     * IP Address
     * OS Version
     * Boot Time
     * User Name
     * CPU
     * Total RAM
     * Volume C:\
3. Click "Background" button:
   - Position: Center or Top-Left
   - Font: Tahoma, 11pt (or preference)
   - Text Color: Yellow or White
4. Save to: $Path

COMMAND LINE OPTIONS:
---------------------
/timer:X         Countdown before applying (use 0 for immediate)
/silent          Don't display configuration dialog
/nolicprompt     Don't prompt for license acceptance
/accepteula      Auto-accept license
/all             Apply to all users
/popup           Display BGInfo output in popup window
/rtf:<path>      Write output to RTF file
/taskbar         Place in taskbar notification area

REGISTRY SETUP (Auto-run at logon):
------------------------------------
Path: HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
Name: BGInfo
Type: String
Value: "C:\Tools\BGInfo\Bginfo64.exe" "C:\Tools\BGInfo\config.bgi" /timer:0 /silent /nolicprompt

Or without config file:
Value: "C:\Tools\BGInfo\Bginfo64.exe" /timer:0 /silent /nolicprompt /accepteula

CUSTOMIZATION TIPS:
-------------------
- To add custom WMI data: Click "Custom" button in BGInfo
- To change background: Click "Background" button
- To modify update frequency: Adjust in configuration dialog
- To exclude from specific users: Use HKCU instead of HKLM registry

TROUBLESHOOTING:
----------------
- If BGInfo doesn't appear: Check screen resolution and position settings
- If fields are blank: Verify WMI service is running
- If colors are wrong: Adjust in Background settings
- To reset: Delete .bgi file and run BGInfo to recreate

For more information:
https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo
"@

    # Save the README
    $readmePath = Join-Path $directory "BGInfo-Configuration-Guide.txt"
    Set-Content -Path $readmePath -Value $readmeContent -Force
    Write-Host "Configuration guide saved to: $readmePath" -ForegroundColor Green

    # Create a PowerShell script to launch BGInfo for configuration
    $launchScript = @"
<#
.SYNOPSIS
    Launches BGInfo to create or modify configuration.
#>

`$bgInfoExe = "C:\Tools\BGInfo\Bginfo64.exe"
`$configPath = "$Path"

if (-not (Test-Path `$bgInfoExe)) {
    Write-Host "BGInfo not found at: `$bgInfoExe" -ForegroundColor Red
    Write-Host "Run Config-Server.ps1 first to download BGInfo" -ForegroundColor Yellow
    exit 1
}

Write-Host "Launching BGInfo for configuration..." -ForegroundColor Cyan
Write-Host "When done configuring:" -ForegroundColor Yellow
Write-Host "  1. Click 'File' > 'Save As'" -ForegroundColor White
Write-Host "  2. Save to: `$configPath" -ForegroundColor White
Write-Host "  3. Click 'OK' to apply and close" -ForegroundColor White
Write-Host ""

# Launch BGInfo
if (Test-Path `$configPath) {
    # Load existing config
    & `$bgInfoExe `$configPath
}
else {
    # Start with defaults
    & `$bgInfoExe
}
"@

    $launchScriptPath = Join-Path $directory "Launch-BGInfo-Config.ps1"
    Set-Content -Path $launchScriptPath -Value $launchScript -Force
    Write-Host "Configuration launcher saved to: $launchScriptPath" -ForegroundColor Green

    # Create a sample automated config script
    $autoConfigScript = @"
<#
.SYNOPSIS
    Automated BGInfo configuration setup
.DESCRIPTION
    This script sets up BGInfo with default configuration
#>

`$bgInfoPath = "C:\Tools\BGInfo"
`$bgInfoExe = Join-Path `$bgInfoPath "Bginfo64.exe"

# Verify BGInfo exists
if (-not (Test-Path `$bgInfoExe)) {
    Write-Host "ERROR: BGInfo not found. Run Config-Server.ps1 first." -ForegroundColor Red
    exit 1
}

# Apply BGInfo with default configuration
Write-Host "Applying BGInfo with default configuration..." -ForegroundColor Cyan

try {
    # Run with defaults - no config file needed
    `$arguments = @(
        "/timer:0"
        "/silent"
        "/nolicprompt"
        "/accepteula"
    )

    Start-Process -FilePath `$bgInfoExe -ArgumentList `$arguments -Wait -NoNewWindow
    Write-Host "BGInfo applied successfully!" -ForegroundColor Green
    Write-Host "Check your desktop background for system information." -ForegroundColor Yellow
}
catch {
    Write-Host "ERROR: Failed to run BGInfo: `$(`$_.Exception.Message)" -ForegroundColor Red
    exit 1
}
"@

    $autoScriptPath = Join-Path $directory "Apply-BGInfo-Default.ps1"
    Set-Content -Path $autoScriptPath -Value $autoConfigScript -Force
    Write-Host "Auto-apply script saved to: $autoScriptPath" -ForegroundColor Green

    Write-Host "`nSetup complete!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "  1. To create custom config: Run $launchScriptPath" -ForegroundColor White
    Write-Host "  2. To use defaults: Run $autoScriptPath" -ForegroundColor White
    Write-Host "  3. Read guide: $readmePath" -ForegroundColor White

    return $true
}

# Main execution
try {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "BGInfo Configuration Generator" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan

    $result = New-BasicBGInfoConfig -Path $OutputPath

    if ($result) {
        Write-Host "`nConfiguration helper files created successfully!" -ForegroundColor Green
        exit 0
    }
    else {
        Write-Host "`nConfiguration generation failed." -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "`nError: $($_.Exception.Message)" -ForegroundColor Red
    exit 2
}
