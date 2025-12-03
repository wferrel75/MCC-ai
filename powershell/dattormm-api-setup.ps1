<#
.SYNOPSIS
    DattoRMM API Setup and Component Helper Script

.DESCRIPTION
    This script helps you set up DattoRMM API access and provides guidance for
    creating components. Due to API limitations, components must be created via
    the web interface, but this script prepares all necessary data and provides
    API integration for component operations.

.PARAMETER ApiUrl
    Your DattoRMM API URL (e.g., https://merlot-api.centrastage.net)

.PARAMETER ApiKey
    Your DattoRMM API Key

.PARAMETER ApiSecretKey
    Your DattoRMM API Secret Key

.PARAMETER Action
    Action to perform: Setup, TestConnection, InstallModule, ShowComponentData

.EXAMPLE
    .\dattormm-api-setup.ps1 -Action InstallModule

.EXAMPLE
    .\dattormm-api-setup.ps1 -Action Setup -ApiUrl "https://merlot-api.centrastage.net" -ApiKey "YOUR_KEY" -ApiSecretKey "YOUR_SECRET"

.EXAMPLE
    .\dattormm-api-setup.ps1 -Action TestConnection

.EXAMPLE
    .\dattormm-api-setup.ps1 -Action ShowComponentData

.NOTES
    Author: DattoRMM API Helper
    Requires: PowerShell 5.1 or higher
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]$ApiUrl,

    [Parameter(Mandatory=$false)]
    [string]$ApiKey,

    [Parameter(Mandatory=$false)]
    [string]$ApiSecretKey,

    [Parameter(Mandatory=$true)]
    [ValidateSet('Setup', 'TestConnection', 'InstallModule', 'ShowComponentData', 'ExportComponentScripts')]
    [string]$Action
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Component definitions
$NetBirdComponent = @{
    Name = "NetBird Agent Deployment"
    Category = "Networking / VPN"
    Description = "Deploys and configures NetBird VPN agent for self-hosted instance"
    ScriptFile = "netbird-windows-deployment.ps1"
    Variables = @(
        @{
            Name = "NETBIRD_SETUP_KEY"
            Type = "Secure Text"
            Description = "Setup key from NetBird dashboard"
            Required = $true
            Example = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
        },
        @{
            Name = "NETBIRD_MANAGEMENT_URL"
            Type = "Text"
            Description = "Your NetBird management server URL"
            Required = $true
            Example = "https://netbird.yourdomain.com:33073"
        },
        @{
            Name = "NETBIRD_ADMIN_URL"
            Type = "Text"
            Description = "Your NetBird admin panel URL (optional)"
            Required = $false
            Example = "https://netbird.yourdomain.com"
        },
        @{
            Name = "NETBIRD_VERSION"
            Type = "Text"
            Description = "Specific version to install (leave empty for latest)"
            Required = $false
            Example = "0.60.2"
        }
    )
}

$RustDeskComponent = @{
    Name = "RustDesk Agent Deployment"
    Category = "Remote Access"
    Description = "Deploys and configures RustDesk remote desktop agent for self-hosted server"
    ScriptFile = "rustdesk-windows-deployment.ps1"
    Variables = @(
        @{
            Name = "RUSTDESK_SERVER_HOST"
            Type = "Text"
            Description = "Your RustDesk server hostname or IP"
            Required = $true
            Example = "rustdesk.yourdomain.com"
        },
        @{
            Name = "RUSTDESK_SERVER_KEY"
            Type = "Secure Text"
            Description = "Public key from id_ed25519.pub file"
            Required = $true
            Example = "AbCdEfGh1234567890..."
        },
        @{
            Name = "RUSTDESK_RELAY_SERVER"
            Type = "Text"
            Description = "Relay server (if different from main server)"
            Required = $false
            Example = "relay.yourdomain.com"
        },
        @{
            Name = "RUSTDESK_API_SERVER"
            Type = "Text"
            Description = "API server URL (for Pro users)"
            Required = $false
            Example = "https://rustdesk.yourdomain.com:21114"
        },
        @{
            Name = "RUSTDESK_PASSWORD"
            Type = "Secure Text"
            Description = "Permanent password for unattended access (optional)"
            Required = $false
            Example = "Leave empty for temporary passwords"
        },
        @{
            Name = "RUSTDESK_VERSION"
            Type = "Text"
            Description = "Specific version to install (leave empty for latest)"
            Required = $false
            Example = "1.4.4"
        },
        @{
            Name = "RUSTDESK_INSTALLER_TYPE"
            Type = "Text"
            Description = "Installer type: 'exe' or 'msi'"
            Required = $false
            Example = "exe"
        }
    )
}

# Function to install DattoRMM PowerShell module
function Install-DattoRMMModule {
    Write-Host "`n=== Installing DattoRMM PowerShell Module ===" -ForegroundColor Cyan

    try {
        # Check if module is already installed
        $Module = Get-Module -ListAvailable -Name DattoRMM

        if ($Module) {
            Write-Host "DattoRMM module is already installed (Version: $($Module.Version))" -ForegroundColor Green

            # Check for updates
            Write-Host "Checking for updates..." -ForegroundColor Yellow
            Update-Module -Name DattoRMM -ErrorAction SilentlyContinue
            Write-Host "Module updated successfully" -ForegroundColor Green
        }
        else {
            Write-Host "Installing DattoRMM module from PowerShell Gallery..." -ForegroundColor Yellow

            # Check if running as administrator
            $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

            if ($IsAdmin) {
                Install-Module -Name DattoRMM -Scope AllUsers -Force
            }
            else {
                Install-Module -Name DattoRMM -Scope CurrentUser -Force
            }

            Write-Host "DattoRMM module installed successfully" -ForegroundColor Green
        }

        # Import module
        Import-Module DattoRMM -Force
        Write-Host "DattoRMM module imported successfully" -ForegroundColor Green

        # Show available commands
        Write-Host "`nAvailable DattoRMM Commands:" -ForegroundColor Cyan
        Get-Command -Module DattoRMM | Select-Object Name | Format-Wide -Column 3

        return $true
    }
    catch {
        Write-Host "Failed to install/import DattoRMM module: $_" -ForegroundColor Red
        return $false
    }
}

# Function to setup API credentials
function Setup-ApiCredentials {
    param(
        [string]$Url,
        [string]$Key,
        [string]$Secret
    )

    Write-Host "`n=== Setting Up DattoRMM API Credentials ===" -ForegroundColor Cyan

    try {
        # Import module if not already loaded
        if (!(Get-Module -Name DattoRMM)) {
            Import-Module DattoRMM -Force
        }

        # Set API parameters
        $params = @{
            Url       = $Url
            Key       = $Key
            SecretKey = $Secret
        }

        Set-DrmmApiParameters @params

        Write-Host "API credentials configured successfully" -ForegroundColor Green
        Write-Host "`nAPI URL: $Url" -ForegroundColor Yellow

        # Save credentials to file for future use (encrypted)
        $CredPath = "$PSScriptRoot\dattormm-credentials.xml"
        $CredObject = [PSCustomObject]@{
            ApiUrl = $Url
            ApiKey = $Key | ConvertTo-SecureString -AsPlainText -Force
            ApiSecretKey = $Secret | ConvertTo-SecureString -AsPlainText -Force
        }

        $CredObject | Export-Clixml -Path $CredPath

        Write-Host "Credentials saved to: $CredPath" -ForegroundColor Green
        Write-Host "IMPORTANT: Keep this file secure and do not commit it to version control!" -ForegroundColor Red

        return $true
    }
    catch {
        Write-Host "Failed to setup API credentials: $_" -ForegroundColor Red
        return $false
    }
}

# Function to load saved credentials
function Load-SavedCredentials {
    $CredPath = "$PSScriptRoot\dattormm-credentials.xml"

    if (Test-Path $CredPath) {
        try {
            $CredObject = Import-Clixml -Path $CredPath

            $DecryptedKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($CredObject.ApiKey)
            )
            $DecryptedSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($CredObject.ApiSecretKey)
            )

            return @{
                ApiUrl = $CredObject.ApiUrl
                ApiKey = $DecryptedKey
                ApiSecretKey = $DecryptedSecret
            }
        }
        catch {
            Write-Host "Failed to load saved credentials: $_" -ForegroundColor Red
            return $null
        }
    }
    else {
        return $null
    }
}

# Function to test API connection
function Test-ApiConnection {
    Write-Host "`n=== Testing DattoRMM API Connection ===" -ForegroundColor Cyan

    try {
        # Load saved credentials if available
        $Creds = Load-SavedCredentials

        if ($Creds) {
            Write-Host "Using saved credentials..." -ForegroundColor Yellow
            Setup-ApiCredentials -Url $Creds.ApiUrl -Key $Creds.ApiKey -Secret $Creds.ApiSecretKey | Out-Null
        }
        else {
            Write-Host "No saved credentials found. Please run with -Action Setup first." -ForegroundColor Red
            return $false
        }

        # Test connection by getting account info
        Write-Host "Retrieving account information..." -ForegroundColor Yellow
        $Account = Get-DrmmAccount

        if ($Account) {
            Write-Host "`nConnection successful!" -ForegroundColor Green
            Write-Host "Account Name: $($Account.name)" -ForegroundColor Cyan
            Write-Host "Account UID: $($Account.uid)" -ForegroundColor Cyan

            # Get sites count
            Write-Host "`nRetrieving sites..." -ForegroundColor Yellow
            $Sites = Get-DrmmAccountSites
            Write-Host "Total Sites: $($Sites.Count)" -ForegroundColor Cyan

            return $true
        }
        else {
            Write-Host "Failed to retrieve account information" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "API connection test failed: $_" -ForegroundColor Red
        Write-Host "Error Details: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to display component data
function Show-ComponentData {
    Write-Host "`n=== Component Configuration Data ===" -ForegroundColor Cyan
    Write-Host "The following components need to be created via the DattoRMM web interface." -ForegroundColor Yellow
    Write-Host "The API does not support creating components programmatically." -ForegroundColor Yellow

    # NetBird Component
    Write-Host "`n--- NetBird Component ---" -ForegroundColor Green
    Write-Host "Name: $($NetBirdComponent.Name)"
    Write-Host "Category: $($NetBirdComponent.Category)"
    Write-Host "Description: $($NetBirdComponent.Description)"
    Write-Host "Script File: $($NetBirdComponent.ScriptFile)"
    Write-Host "`nRequired Variables:"
    foreach ($var in $NetBirdComponent.Variables) {
        $reqText = if ($var.Required) { "[REQUIRED]" } else { "[OPTIONAL]" }
        Write-Host "  $reqText $($var.Name) ($($var.Type))" -ForegroundColor $(if ($var.Required) { "Yellow" } else { "Gray" })
        Write-Host "    Description: $($var.Description)"
        Write-Host "    Example: $($var.Example)"
    }

    # RustDesk Component
    Write-Host "`n--- RustDesk Component ---" -ForegroundColor Green
    Write-Host "Name: $($RustDeskComponent.Name)"
    Write-Host "Category: $($RustDeskComponent.Category)"
    Write-Host "Description: $($RustDeskComponent.Description)"
    Write-Host "Script File: $($RustDeskComponent.ScriptFile)"
    Write-Host "`nRequired Variables:"
    foreach ($var in $RustDeskComponent.Variables) {
        $reqText = if ($var.Required) { "[REQUIRED]" } else { "[OPTIONAL]" }
        Write-Host "  $reqText $($var.Name) ($($var.Type))" -ForegroundColor $(if ($var.Required) { "Yellow" } else { "Gray" })
        Write-Host "    Description: $($var.Description)"
        Write-Host "    Example: $($var.Example)"
    }

    Write-Host "`n=== Next Steps ===" -ForegroundColor Cyan
    Write-Host "1. Log into your DattoRMM web portal"
    Write-Host "2. Navigate to Comodo > Components > New Component"
    Write-Host "3. Create each component using the data above"
    Write-Host "4. Copy the script content from the respective .ps1 files"
    Write-Host "5. Configure the component variables as listed above"
    Write-Host "6. Set 'Run As: System' and 'Execution Policy: Bypass'"
    Write-Host "7. Once created, you can use the API to deploy these components to devices"
}

# Function to export component scripts for easy copying
function Export-ComponentScripts {
    Write-Host "`n=== Exporting Component Scripts ===" -ForegroundColor Cyan

    $ExportDir = "$PSScriptRoot\component-exports"
    if (!(Test-Path $ExportDir)) {
        New-Item -ItemType Directory -Path $ExportDir -Force | Out-Null
    }

    # Create component instruction files
    $NetBirdInstructions = @"
=============================================================================
                    NETBIRD COMPONENT CONFIGURATION
=============================================================================

Component Name: $($NetBirdComponent.Name)
Category: $($NetBirdComponent.Category)
Description: $($NetBirdComponent.Description)

CONFIGURATION STEPS:
1. Navigate to: Comodo > Components > New Component
2. Component Type: PowerShell
3. Set Name: $($NetBirdComponent.Name)
4. Set Category: $($NetBirdComponent.Category)
5. Set Description: $($NetBirdComponent.Description)
6. Copy script from: $($NetBirdComponent.ScriptFile)
7. Set Execution Policy: Bypass
8. Set Run As: System

COMPONENT VARIABLES TO CREATE:
$($NetBirdComponent.Variables | ForEach-Object {
    $req = if ($_.Required) { "[REQUIRED]" } else { "[OPTIONAL]" }
    "$req Variable: $($_.Name)`n  Type: $($_.Type)`n  Description: $($_.Description)`n  Example: $($_.Example)`n"
} | Out-String)

SCRIPT CONTENT:
Copy the entire contents of $($NetBirdComponent.ScriptFile)

At the top of the script, modify the param block to use environment variables:

[CmdletBinding()]
param (
    [Parameter(Mandatory=`$true)]
    [string]`$SetupKey = `$env:NETBIRD_SETUP_KEY,

    [Parameter(Mandatory=`$true)]
    [string]`$ManagementURL = `$env:NETBIRD_MANAGEMENT_URL,

    [Parameter(Mandatory=`$false)]
    [string]`$AdminURL = `$env:NETBIRD_ADMIN_URL,

    [Parameter(Mandatory=`$false)]
    [string]`$NetBirdVersion = `$env:NETBIRD_VERSION
)

=============================================================================
"@

    $RustDeskInstructions = @"
=============================================================================
                    RUSTDESK COMPONENT CONFIGURATION
=============================================================================

Component Name: $($RustDeskComponent.Name)
Category: $($RustDeskComponent.Category)
Description: $($RustDeskComponent.Description)

CONFIGURATION STEPS:
1. Navigate to: Comodo > Components > New Component
2. Component Type: PowerShell
3. Set Name: $($RustDeskComponent.Name)
4. Set Category: $($RustDeskComponent.Category)
5. Set Description: $($RustDeskComponent.Description)
6. Copy script from: $($RustDeskComponent.ScriptFile)
7. Set Execution Policy: Bypass
8. Set Run As: System

COMPONENT VARIABLES TO CREATE:
$($RustDeskComponent.Variables | ForEach-Object {
    $req = if ($_.Required) { "[REQUIRED]" } else { "[OPTIONAL]" }
    "$req Variable: $($_.Name)`n  Type: $($_.Type)`n  Description: $($_.Description)`n  Example: $($_.Example)`n"
} | Out-String)

SCRIPT CONTENT:
Copy the entire contents of $($RustDeskComponent.ScriptFile)

At the top of the script, modify the param block to use environment variables:

[CmdletBinding()]
param (
    [Parameter(Mandatory=`$true)]
    [string]`$ServerHost = `$env:RUSTDESK_SERVER_HOST,

    [Parameter(Mandatory=`$true)]
    [string]`$ServerKey = `$env:RUSTDESK_SERVER_KEY,

    [Parameter(Mandatory=`$false)]
    [string]`$RelayServer = `$env:RUSTDESK_RELAY_SERVER,

    [Parameter(Mandatory=`$false)]
    [string]`$ApiServer = `$env:RUSTDESK_API_SERVER,

    [Parameter(Mandatory=`$false)]
    [string]`$PermanentPassword = `$env:RUSTDESK_PASSWORD,

    [Parameter(Mandatory=`$false)]
    [string]`$RustDeskVersion = `$env:RUSTDESK_VERSION,

    [Parameter(Mandatory=`$false)]
    [ValidateSet('exe', 'msi')]
    [string]`$InstallerType = `$(if (`$env:RUSTDESK_INSTALLER_TYPE) { `$env:RUSTDESK_INSTALLER_TYPE } else { 'exe' })
)

=============================================================================
"@

    # Save instruction files
    $NetBirdInstructions | Out-File -FilePath "$ExportDir\NetBird-Component-Instructions.txt" -Encoding UTF8
    $RustDeskInstructions | Out-File -FilePath "$ExportDir\RustDesk-Component-Instructions.txt" -Encoding UTF8

    Write-Host "Component configuration instructions exported to:" -ForegroundColor Green
    Write-Host "  - $ExportDir\NetBird-Component-Instructions.txt"
    Write-Host "  - $ExportDir\RustDesk-Component-Instructions.txt"

    Write-Host "`nOpening export directory..." -ForegroundColor Yellow
    Start-Process $ExportDir
}

# Main execution
try {
    switch ($Action) {
        'InstallModule' {
            Install-DattoRMMModule
        }

        'Setup' {
            if ([string]::IsNullOrEmpty($ApiUrl) -or [string]::IsNullOrEmpty($ApiKey) -or [string]::IsNullOrEmpty($ApiSecretKey)) {
                Write-Host "ERROR: For Setup action, you must provide -ApiUrl, -ApiKey, and -ApiSecretKey parameters" -ForegroundColor Red
                exit 1
            }

            # Install module if needed
            Install-DattoRMMModule | Out-Null

            # Setup credentials
            Setup-ApiCredentials -Url $ApiUrl -Key $ApiKey -Secret $ApiSecretKey
        }

        'TestConnection' {
            # Install module if needed
            if (!(Get-Module -ListAvailable -Name DattoRMM)) {
                Install-DattoRMMModule | Out-Null
            }

            Test-ApiConnection
        }

        'ShowComponentData' {
            Show-ComponentData
        }

        'ExportComponentScripts' {
            Export-ComponentScripts
        }
    }

    Write-Host "`n=== Operation Completed ===" -ForegroundColor Green
}
catch {
    Write-Host "`n=== Operation Failed ===" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
