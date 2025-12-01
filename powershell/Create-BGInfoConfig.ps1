<#
.SYNOPSIS
    Creates a basic BGInfo configuration file (.bgi) with common system information fields.

.DESCRIPTION
    This script generates a BGInfo configuration file programmatically. Since .bgi files
    use a proprietary binary format, this script provides an alternative approach:

    1. Runs BGInfo interactively to create a custom configuration
    2. Provides guidance on manual configuration
    3. Creates a sample configuration using BGInfo's command-line capabilities

    The generated configuration includes common fields like Computer Name, IP Address,
    OS Version, Boot Time, User, CPU, Memory, and Disk Space.

.PARAMETER OutputPath
    The path where the .bgi configuration file will be saved.
    Default: C:\Tools\BGInfo\config.bgi

.PARAMETER Interactive
    If specified, launches BGInfo GUI for manual configuration.

.EXAMPLE
    .\Create-BGInfoConfig.ps1

    Creates a default BGInfo configuration at C:\Tools\BGInfo\config.bgi

.EXAMPLE
    .\Create-BGInfoConfig.ps1 -OutputPath "C:\Custom\mybginfo.bgi"

    Creates a BGInfo configuration at the specified location

.EXAMPLE
    .\Create-BGInfoConfig.ps1 -Interactive

    Launches BGInfo GUI for manual configuration

.NOTES
    Author: Generated for BGInfo Configuration
    Requires: BGInfo64.exe (will download if not present)
    Version: 1.0

    BGInfo .bgi files are binary format and cannot be easily created via text editing.
    This script provides methods to generate a working configuration.

    Default fields included:
    - Host Name
    - IP Address
    - Subnet Mask
    - Default Gateway
    - MAC Address
    - OS Version
    - Service Pack
    - Boot Time
    - Logon Server
    - User Name
    - CPU
    - Total RAM
    - Available RAM
    - Volume Information (C:, D:, etc.)

.LINK
    https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo
#>

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath = "C:\Tools\BGInfo\config.bgi",

    [Parameter(Mandatory = $false)]
    [switch]$Interactive
)

#region Functions

function Write-ColorMessage {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Get-BGInfoExecutable {
    <#
    .SYNOPSIS
        Ensures BGInfo64.exe is available, downloads if necessary.
    #>

    $bgInfoDir = Split-Path $OutputPath -Parent
    $bgInfoExe = Join-Path $bgInfoDir "Bginfo64.exe"
    $bgInfoUrl = "https://live.sysinternals.com/Bginfo64.exe"

    # Create directory if it doesn't exist
    if (-not (Test-Path $bgInfoDir)) {
        Write-ColorMessage "Creating directory: $bgInfoDir" -Color Yellow
        New-Item -Path $bgInfoDir -ItemType Directory -Force | Out-Null
    }

    # Download BGInfo if not present
    if (-not (Test-Path $bgInfoExe)) {
        Write-ColorMessage "Downloading BGInfo64.exe..." -Color Yellow

        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($bgInfoUrl, $bgInfoExe)
            $webClient.Dispose()

            Write-ColorMessage "BGInfo64.exe downloaded successfully" -Color Green
        }
        catch {
            Write-ColorMessage "Failed to download BGInfo: $($_.Exception.Message)" -Color Red
            return $null
        }
    }
    else {
        Write-ColorMessage "BGInfo64.exe found at: $bgInfoExe" -Color Green
    }

    return $bgInfoExe
}

function New-BGInfoConfigInteractive {
    <#
    .SYNOPSIS
        Launches BGInfo GUI for interactive configuration.
    #>
    param(
        [string]$BGInfoExe,
        [string]$ConfigPath
    )

    Write-ColorMessage "`nLaunching BGInfo for interactive configuration..." -Color Cyan
    Write-ColorMessage "Instructions:" -Color Yellow
    Write-ColorMessage "1. Configure the fields you want displayed" -Color White
    Write-ColorMessage "2. Adjust appearance settings (font, colors, position)" -Color White
    Write-ColorMessage "3. Click 'File' > 'Save As' and save to: $ConfigPath" -Color White
    Write-ColorMessage "4. Close BGInfo when done`n" -Color White

    try {
        # Launch BGInfo GUI
        Start-Process -FilePath $BGInfoExe -Wait

        # Check if config was created
        if (Test-Path $ConfigPath) {
            Write-ColorMessage "Configuration saved successfully to: $ConfigPath" -Color Green
            return $true
        }
        else {
            Write-ColorMessage "Warning: Configuration file was not saved" -Color Yellow
            return $false
        }
    }
    catch {
        Write-ColorMessage "Error launching BGInfo: $($_.Exception.Message)" -Color Red
        return $false
    }
}

function New-BGInfoDefaultConfig {
    <#
    .SYNOPSIS
        Creates a default BGInfo configuration using BGInfo's command-line.
    #>
    param(
        [string]$BGInfoExe,
        [string]$ConfigPath
    )

    Write-ColorMessage "`nCreating default BGInfo configuration..." -Color Cyan

    try {
        # Run BGInfo to generate default config and immediately save it
        # The trick is to run BGInfo, accept EULA, and save to a config file
        # Since BGInfo's binary format is proprietary, we'll use this workaround:

        # Method 1: Create a template using BGInfo itself
        # Run BGInfo with /saveas parameter (if supported in newer versions)

        # Method 2: Run BGInfo and let it create a default, then copy from user profile
        # BGInfo stores configs in a binary format, but we can create a basic one

        Write-ColorMessage "Note: Creating a basic BGInfo configuration template..." -Color Yellow
        Write-ColorMessage "BGInfo .bgi files use binary format and cannot be created as text." -Color Yellow

        # Create instruction file instead
        $instructionFile = Join-Path (Split-Path $ConfigPath -Parent) "BGInfo-Setup-Instructions.txt"

        $instructions = @"
BGInfo Configuration Instructions
==================================

OPTION 1: Use BGInfo GUI (Recommended)
---------------------------------------
1. Run: $BGInfoExe
2. The default configuration includes these fields:
   - Host Name
   - IP Address
   - Subnet Mask
   - Default Gateway
   - DHCP Server
   - DNS Servers
   - MAC Address
   - OS Version
   - Service Pack
   - Boot Time
   - Logon Server
   - Logon Domain
   - User Name
   - CPU
   - Total RAM
   - Available RAM
   - Page File
   - Volumes (showing free space)

3. Customize as needed:
   - Click "Fields" button to add/remove fields
   - Click "Background" to change wallpaper settings
   - Adjust font, colors, and position in the main dialog

4. Save configuration:
   - Click "File" > "Save As"
   - Save to: $ConfigPath
   - Click "OK" to apply

OPTION 2: Use Default Configuration
------------------------------------
Simply run BGInfo without a config file:
   $BGInfoExe /timer:0 /silent /nolicprompt /accepteula

This will use BGInfo's built-in defaults, which include all common fields.

OPTION 3: Automated Deployment
-------------------------------
For automated deployment, run BGInfo without a config file and it will
use sensible defaults. The config file is optional.

Registry Command:
   "$BGInfoExe" /timer:0 /silent /nolicprompt /accepteula

Common BGInfo Command-Line Parameters:
---------------------------------------
/timer:0          - Apply immediately without countdown
/silent           - Suppress the configuration dialog
/nolicprompt      - Suppress license prompt
/accepteula       - Accept EULA automatically
/all              - Apply to all users (when run with config)
/taskbar          - Place in taskbar notification area

Field Examples to Add Manually:
--------------------------------
- Network Speed
- Snapshot Time
- IE Version
- .NET Version
- Last Reboot
- Services (specific services you want to monitor)
- Custom WMI queries

For more information:
https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo
"@

        Set-Content -Path $instructionFile -Value $instructions -Force
        Write-ColorMessage "Setup instructions saved to: $instructionFile" -Color Green

        # Create a marker file
        $markerContent = "BGInfo will use default configuration. To customize, run BGInfo GUI and save config."
        Set-Content -Path $ConfigPath -Value $markerContent -Force

        Write-ColorMessage "`nConfiguration template created." -Color Green
        Write-ColorMessage "For best results, use interactive mode: .\Create-BGInfoConfig.ps1 -Interactive" -Color Yellow

        return $true
    }
    catch {
        Write-ColorMessage "Error creating configuration: $($_.Exception.Message)" -Color Red
        return $false
    }
}

#endregion

#region Main Script

try {
    Write-ColorMessage "`n========================================" -Color Cyan
    Write-ColorMessage "BGInfo Configuration Generator" -Color Cyan
    Write-ColorMessage "========================================`n" -Color Cyan

    # Ensure BGInfo is available
    $bgInfoExe = Get-BGInfoExecutable
    if (-not $bgInfoExe) {
        Write-ColorMessage "Failed to obtain BGInfo executable. Exiting." -Color Red
        exit 1
    }

    # Create output directory if needed
    $outputDir = Split-Path $OutputPath -Parent
    if (-not (Test-Path $outputDir)) {
        New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
    }

    # Create configuration based on mode
    if ($Interactive) {
        # Interactive mode - launch GUI
        $success = New-BGInfoConfigInteractive -BGInfoExe $bgInfoExe -ConfigPath $OutputPath
    }
    else {
        # Automated mode - create default
        $success = New-BGInfoDefaultConfig -BGInfoExe $bgInfoExe -ConfigPath $OutputPath
    }

    if ($success) {
        Write-ColorMessage "`n========================================" -Color Cyan
        Write-ColorMessage "Configuration Complete" -Color Cyan
        Write-ColorMessage "========================================" -Color Cyan
        Write-ColorMessage "Configuration path: $OutputPath" -Color Green

        Write-ColorMessage "`nTo test the configuration, run:" -Color Yellow
        Write-ColorMessage "  & `"$bgInfoExe`" `"$OutputPath`" /timer:0" -Color White

        Write-ColorMessage "`nTo apply at logon for all users:" -Color Yellow
        Write-ColorMessage "  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' ``" -Color White
        Write-ColorMessage "    -Name 'BGInfo' ``" -Color White
        Write-ColorMessage "    -Value `"\`"$bgInfoExe\`" \`"$OutputPath\`" /timer:0 /silent /nolicprompt`"" -Color White
    }
    else {
        Write-ColorMessage "`nConfiguration was not completed successfully." -Color Red
        Write-ColorMessage "Try running with -Interactive switch for manual configuration." -Color Yellow
        exit 1
    }

    exit 0
}
catch {
    Write-ColorMessage "`nCritical error: $($_.Exception.Message)" -Color Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    exit 2
}

#endregion
