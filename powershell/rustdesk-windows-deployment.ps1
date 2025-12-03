<#
.SYNOPSIS
    RustDesk Windows Agent Deployment Script for DattoRMM

.DESCRIPTION
    Downloads and installs the latest RustDesk Windows agent silently,
    configures it to connect to a self-hosted RustDesk server, and optionally
    sets a permanent password for unattended access.

.PARAMETER ServerHost
    The hostname or IP address of your self-hosted RustDesk ID/relay server (Required)
    Example: rustdesk.yourdomain.com or 192.168.1.100

.PARAMETER ServerKey
    The public key from your RustDesk server (id_ed25519.pub) (Required)
    This is NOT your Pro license key - it's the encryption key from your server

.PARAMETER RelayServer
    The relay server hostname or IP (Optional - defaults to ServerHost)
    Example: relay.yourdomain.com

.PARAMETER ApiServer
    The API server URL for RustDesk Pro (Optional)
    Example: https://rustdesk.yourdomain.com or http://rustdesk.yourdomain.com:21114

.PARAMETER PermanentPassword
    Set a permanent password for unattended access (Optional)
    If not provided, RustDesk will use temporary random passwords

.PARAMETER RustDeskVersion
    Specific RustDesk version to install (Optional - defaults to latest)
    Example: 1.4.4

.PARAMETER InstallerType
    Choose between 'exe' or 'msi' installer (Optional - defaults to 'exe')

.PARAMETER InstallPath
    Custom installation directory for MSI installer (Optional)
    Default: C:\Program Files\RustDesk

.PARAMETER CreateDesktopShortcut
    Create desktop shortcut (Optional - MSI only, defaults to $false)

.PARAMETER CreateStartMenuShortcut
    Create start menu shortcut (Optional - MSI only, defaults to $true)

.EXAMPLE
    .\rustdesk-windows-deployment.ps1 -ServerHost "rustdesk.example.com" -ServerKey "ABC123XYZ..."

.EXAMPLE
    .\rustdesk-windows-deployment.ps1 -ServerHost "192.168.1.100" -ServerKey "ABC123..." -PermanentPassword "SecurePass123!"

.NOTES
    Author: DattoRMM Deployment Script
    Requires: PowerShell 5.1 or higher, Administrator privileges
    Compatible with: Windows Server 2016+, Windows 10+
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$ServerHost,

    [Parameter(Mandatory=$true)]
    [string]$ServerKey,

    [Parameter(Mandatory=$false)]
    [string]$RelayServer,

    [Parameter(Mandatory=$false)]
    [string]$ApiServer,

    [Parameter(Mandatory=$false)]
    [string]$PermanentPassword,

    [Parameter(Mandatory=$false)]
    [string]$RustDeskVersion,

    [Parameter(Mandatory=$false)]
    [ValidateSet('exe', 'msi')]
    [string]$InstallerType = 'exe',

    [Parameter(Mandatory=$false)]
    [string]$InstallPath = "C:\Program Files\RustDesk",

    [Parameter(Mandatory=$false)]
    [bool]$CreateDesktopShortcut = $false,

    [Parameter(Mandatory=$false)]
    [bool]$CreateStartMenuShortcut = $true
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Define paths and URLs
$TempDir = "$env:TEMP\RustDeskInstall"
$LogFile = "$env:ProgramData\RustDesk\deployment.log"
$ConfigPath = "$env:APPDATA\RustDesk\config\RustDesk2.toml"
$RustDeskExe = "$InstallPath\rustdesk.exe"

# Function to write log messages
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Output $LogMessage

    # Ensure log directory exists
    $LogDir = Split-Path $LogFile -Parent
    if (!(Test-Path $LogDir)) {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }

    Add-Content -Path $LogFile -Value $LogMessage -ErrorAction SilentlyContinue
}

# Function to get the latest RustDesk version
function Get-LatestRustDeskVersion {
    try {
        Write-Log "Fetching latest RustDesk version from GitHub..."
        $ReleaseInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/rustdesk/rustdesk/releases/latest" -UseBasicParsing
        $LatestVersion = $ReleaseInfo.tag_name -replace '^v', ''
        Write-Log "Latest version: $LatestVersion"
        return $LatestVersion
    }
    catch {
        Write-Log "Failed to fetch latest version: $_" -Level "ERROR"
        throw "Unable to determine latest RustDesk version. Please specify version manually."
    }
}

# Function to download RustDesk installer
function Download-RustDeskInstaller {
    param(
        [string]$Version,
        [string]$Type
    )

    $Extension = if ($Type -eq 'msi') { '.msi' } else { '.exe' }
    $FileName = "rustdesk-$Version-x86_64$Extension"
    $DownloadURL = "https://github.com/rustdesk/rustdesk/releases/download/$Version/$FileName"
    $InstallerPath = Join-Path $TempDir $FileName

    try {
        Write-Log "Downloading RustDesk v$Version ($Type) from $DownloadURL..."

        # Use TLS 1.2
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        # Download with progress
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $DownloadURL -OutFile $InstallerPath -UseBasicParsing
        $ProgressPreference = 'Continue'

        if (Test-Path $InstallerPath) {
            $FileSize = (Get-Item $InstallerPath).Length / 1MB
            Write-Log "Download completed. File size: $([math]::Round($FileSize, 2)) MB"
            return $InstallerPath
        }
        else {
            throw "Installer file not found after download"
        }
    }
    catch {
        Write-Log "Download failed: $_" -Level "ERROR"
        throw
    }
}

# Function to install RustDesk EXE
function Install-RustDeskEXE {
    param([string]$ExePath)

    try {
        Write-Log "Installing RustDesk from $ExePath..."

        # Start silent installation
        $Process = Start-Process -FilePath $ExePath -ArgumentList "--silent-install" -Wait -PassThru -NoNewWindow

        if ($Process.ExitCode -eq 0) {
            Write-Log "RustDesk installed successfully"
        }
        else {
            throw "Installation failed with exit code: $($Process.ExitCode)"
        }

        # Wait for installation to complete
        Start-Sleep -Seconds 5
    }
    catch {
        Write-Log "Installation failed: $_" -Level "ERROR"
        throw
    }
}

# Function to install RustDesk MSI
function Install-RustDeskMSI {
    param(
        [string]$MSIPath,
        [string]$InstallFolder,
        [bool]$DesktopShortcut,
        [bool]$StartMenuShortcut
    )

    try {
        Write-Log "Installing RustDesk from $MSIPath..."

        # Build msiexec arguments
        $MSIArguments = @(
            "/i"
            "`"$MSIPath`""
            "/qn"
            "/norestart"
            "INSTALLFOLDER=`"$InstallFolder`""
            "CREATEDESKTOPSHORTCUTS=$(if ($DesktopShortcut) { '1' } else { '0' })"
            "CREATESTARTMENUSHORTCUTS=$(if ($StartMenuShortcut) { '1' } else { '0' })"
            "INSTALLPRINTER=0"
            "/L*v"
            "`"$env:TEMP\rustdesk_install.log`""
        )

        # Start installation process
        $Process = Start-Process -FilePath "msiexec.exe" -ArgumentList $MSIArguments -Wait -PassThru -NoNewWindow

        if ($Process.ExitCode -eq 0) {
            Write-Log "RustDesk installed successfully"
        }
        elseif ($Process.ExitCode -eq 3010) {
            Write-Log "RustDesk installed successfully (reboot required)" -Level "WARNING"
        }
        else {
            throw "Installation failed with exit code: $($Process.ExitCode)"
        }

        # Wait for service to be registered
        Start-Sleep -Seconds 5
    }
    catch {
        Write-Log "Installation failed: $_" -Level "ERROR"
        throw
    }
}

# Function to stop RustDesk service
function Stop-RustDeskService {
    try {
        $Service = Get-Service -Name "RustDesk" -ErrorAction SilentlyContinue
        if ($Service -and $Service.Status -eq "Running") {
            Write-Log "Stopping RustDesk service..."
            Stop-Service -Name "RustDesk" -Force
            Start-Sleep -Seconds 2
        }
    }
    catch {
        Write-Log "Failed to stop service: $_" -Level "WARNING"
    }
}

# Function to start RustDesk service
function Start-RustDeskService {
    try {
        Write-Log "Starting RustDesk service..."
        $Service = Get-Service -Name "RustDesk" -ErrorAction SilentlyContinue

        if ($Service) {
            if ($Service.Status -ne "Running") {
                Start-Service -Name "RustDesk"
                Start-Sleep -Seconds 3
            }
            Write-Log "RustDesk service is running"
            return $true
        }
        else {
            Write-Log "RustDesk service not found" -Level "WARNING"
            return $false
        }
    }
    catch {
        Write-Log "Failed to start service: $_" -Level "ERROR"
        return $false
    }
}

# Function to configure RustDesk server settings
function Configure-RustDeskServer {
    param(
        [string]$Host,
        [string]$Key,
        [string]$Relay,
        [string]$Api
    )

    try {
        Write-Log "Configuring RustDesk server settings..."

        # Stop service before configuration
        Stop-RustDeskService

        # Build config string
        $ConfigString = "host=$Host,key=$Key"

        # Add relay if specified and different from host
        if (![string]::IsNullOrEmpty($Relay) -and $Relay -ne $Host) {
            $ConfigString += ",relay=$Relay"
        }

        # Add API server if specified
        if (![string]::IsNullOrEmpty($Api)) {
            $ConfigString += ",api=$Api"
        }

        Write-Log "Applying configuration: host=$Host"

        # Apply configuration using command line
        if (Test-Path $RustDeskExe) {
            $Process = Start-Process -FilePath $RustDeskExe -ArgumentList "--config `"$ConfigString`"" -Wait -PassThru -NoNewWindow

            if ($Process.ExitCode -eq 0) {
                Write-Log "Configuration applied successfully"
            }
            else {
                Write-Log "Configuration may have failed with exit code: $($Process.ExitCode)" -Level "WARNING"
            }
        }
        else {
            throw "RustDesk executable not found at $RustDeskExe"
        }

        # Verify config file was created/updated
        Start-Sleep -Seconds 2

        # Start service after configuration
        Start-RustDeskService
    }
    catch {
        Write-Log "Configuration failed: $_" -Level "ERROR"
        throw
    }
}

# Function to set permanent password
function Set-RustDeskPassword {
    param([string]$Password)

    try {
        Write-Log "Setting permanent password..."

        if (!(Test-Path $RustDeskExe)) {
            throw "RustDesk executable not found at $RustDeskExe"
        }

        # Stop service
        Stop-RustDeskService

        # Set password
        $Process = Start-Process -FilePath $RustDeskExe -ArgumentList "--password `"$Password`"" -Wait -PassThru -NoNewWindow

        if ($Process.ExitCode -eq 0) {
            Write-Log "Permanent password set successfully"
        }
        else {
            Write-Log "Password setting may have failed with exit code: $($Process.ExitCode)" -Level "WARNING"
        }

        # Start service
        Start-RustDeskService
    }
    catch {
        Write-Log "Failed to set password: $_" -Level "ERROR"
        throw
    }
}

# Function to get RustDesk ID
function Get-RustDeskID {
    try {
        Write-Log "Retrieving RustDesk ID..."

        if (!(Test-Path $RustDeskExe)) {
            Write-Log "RustDesk executable not found" -Level "WARNING"
            return $null
        }

        # Ensure service is running
        Start-RustDeskService

        # Wait a moment for ID to be generated
        Start-Sleep -Seconds 3

        # Get ID
        $Result = & $RustDeskExe --get-id 2>&1

        if ($Result -match '\d{9,}') {
            $ID = $matches[0]
            Write-Log "RustDesk ID: $ID"
            return $ID
        }
        else {
            Write-Log "Unable to retrieve ID: $Result" -Level "WARNING"
            return $null
        }
    }
    catch {
        Write-Log "Failed to get ID: $_" -Level "WARNING"
        return $null
    }
}

# Function to verify RustDesk service
function Verify-RustDeskService {
    try {
        Write-Log "Verifying RustDesk service..."

        $Service = Get-Service -Name "RustDesk" -ErrorAction SilentlyContinue

        if ($Service) {
            Write-Log "RustDesk service status: $($Service.Status)"

            if ($Service.Status -ne "Running") {
                Write-Log "Starting RustDesk service..."
                Start-Service -Name "RustDesk"
                Start-Sleep -Seconds 3

                $Service = Get-Service -Name "RustDesk"
                Write-Log "RustDesk service status after start: $($Service.Status)"
            }

            return $true
        }
        else {
            Write-Log "RustDesk service not found" -Level "WARNING"
            return $false
        }
    }
    catch {
        Write-Log "Service verification failed: $_" -Level "ERROR"
        return $false
    }
}

# Function to display deployment summary
function Show-DeploymentSummary {
    param(
        [string]$Version,
        [string]$ID,
        [string]$Server,
        [bool]$PasswordSet
    )

    $Summary = @"

=============================================================================
                    RUSTDESK DEPLOYMENT SUMMARY
=============================================================================
Version:        $Version
RustDesk ID:    $(if ($ID) { $ID } else { "Unable to retrieve" })
Server:         $Server
Password:       $(if ($PasswordSet) { "Permanent password configured" } else { "Using temporary passwords" })
Service Status: $(try { (Get-Service -Name "RustDesk" -ErrorAction Stop).Status } catch { "Unknown" })
=============================================================================

IMPORTANT: Save the RustDesk ID above for remote access to this device.

"@

    Write-Output $Summary
    Write-Log $Summary
}

# Main execution
try {
    Write-Log "=== RustDesk Windows Deployment Started ==="

    # Check if running as administrator
    $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (!$IsAdmin) {
        throw "This script must be run as Administrator"
    }

    # Set default relay server to main server if not specified
    if ([string]::IsNullOrEmpty($RelayServer)) {
        $RelayServer = $ServerHost
    }

    # Create temp directory
    if (!(Test-Path $TempDir)) {
        New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
    }

    # Determine version to install
    if ([string]::IsNullOrEmpty($RustDeskVersion)) {
        $RustDeskVersion = Get-LatestRustDeskVersion
    }

    # Check if RustDesk is already installed
    $ExistingInstall = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
                      Where-Object { $_.DisplayName -like "*RustDesk*" }

    if ($ExistingInstall) {
        Write-Log "RustDesk is already installed (Version: $($ExistingInstall.DisplayVersion))"
        Write-Log "Proceeding with configuration..."

        # Update RustDeskExe path if already installed
        $ProgramFiles = ${env:ProgramFiles}
        if (Test-Path "$ProgramFiles\RustDesk\rustdesk.exe") {
            $RustDeskExe = "$ProgramFiles\RustDesk\rustdesk.exe"
        }
    }
    else {
        # Download installer
        $InstallerPath = Download-RustDeskInstaller -Version $RustDeskVersion -Type $InstallerType

        # Install RustDesk
        if ($InstallerType -eq 'msi') {
            Install-RustDeskMSI -MSIPath $InstallerPath -InstallFolder $InstallPath -DesktopShortcut $CreateDesktopShortcut -StartMenuShortcut $CreateStartMenuShortcut
        }
        else {
            Install-RustDeskEXE -ExePath $InstallerPath

            # Update path for EXE installation (uses default location)
            $RustDeskExe = "${env:ProgramFiles}\RustDesk\rustdesk.exe"
        }

        Write-Log "Waiting for installation to complete..."
        Start-Sleep -Seconds 5
    }

    # Verify service
    $ServiceOK = Verify-RustDeskService

    if (!$ServiceOK) {
        Write-Log "Service verification failed, but continuing..." -Level "WARNING"
    }

    # Configure server settings
    Configure-RustDeskServer -Host $ServerHost -Key $ServerKey -Relay $RelayServer -Api $ApiServer

    # Set permanent password if provided
    $PasswordConfigured = $false
    if (![string]::IsNullOrEmpty($PermanentPassword)) {
        Set-RustDeskPassword -Password $PermanentPassword
        $PasswordConfigured = $true
    }

    # Get RustDesk ID
    $RustDeskID = Get-RustDeskID

    # Show deployment summary
    Show-DeploymentSummary -Version $RustDeskVersion -ID $RustDeskID -Server $ServerHost -PasswordSet $PasswordConfigured

    # Cleanup
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Log "=== RustDesk Windows Deployment Completed Successfully ==="
    Write-Output "SUCCESS: RustDesk agent installed and configured"

    # Exit with ID as additional info
    if ($RustDeskID) {
        Write-Output "RUSTDESK_ID=$RustDeskID"
    }

    exit 0
}
catch {
    Write-Log "=== RustDesk Windows Deployment Failed ===" -Level "ERROR"
    Write-Log "Error: $_" -Level "ERROR"
    Write-Output "FAILED: $_"
    exit 1
}
