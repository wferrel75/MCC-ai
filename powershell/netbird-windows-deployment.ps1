<#
.SYNOPSIS
    NetBird Windows Agent Deployment Script for DattoRMM

.DESCRIPTION
    Downloads and installs the latest NetBird Windows agent silently,
    then connects it to a self-hosted NetBird management server without user interaction.

.PARAMETER SetupKey
    The NetBird setup key for automatic registration (Required)

.PARAMETER ManagementURL
    The URL of your self-hosted NetBird management server (Required)
    Example: https://netbird.yourdomain.com:33073

.PARAMETER AdminURL
    The URL of your self-hosted NetBird admin panel (Optional)
    Example: https://netbird.yourdomain.com

.PARAMETER NetBirdVersion
    Specific NetBird version to install (Optional - defaults to latest)
    Example: 0.60.2

.EXAMPLE
    .\netbird-windows-deployment.ps1 -SetupKey "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" -ManagementURL "https://netbird.yourdomain.com:33073"

.NOTES
    Author: DattoRMM Deployment Script
    Requires: PowerShell 5.1 or higher, Administrator privileges
    Compatible with: Windows Server 2016+, Windows 10+
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$SetupKey,

    [Parameter(Mandatory=$true)]
    [string]$ManagementURL,

    [Parameter(Mandatory=$false)]
    [string]$AdminURL,

    [Parameter(Mandatory=$false)]
    [string]$NetBirdVersion
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Define paths and URLs
$TempDir = "$env:TEMP\NetBirdInstall"
$LogFile = "$env:ProgramData\NetBird\deployment.log"
$ConfigPath = "$env:ProgramData\NetBird\config.json"
$NetBirdExe = "C:\Program Files\NetBird\netbird.exe"

# Function to write log messages
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Output $LogMessage
    if (Test-Path (Split-Path $LogFile -Parent)) {
        Add-Content -Path $LogFile -Value $LogMessage -ErrorAction SilentlyContinue
    }
}

# Function to get the latest NetBird version
function Get-LatestNetBirdVersion {
    try {
        Write-Log "Fetching latest NetBird version from GitHub..."
        $ReleaseInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/netbirdio/netbird/releases/latest" -UseBasicParsing
        $LatestVersion = $ReleaseInfo.tag_name -replace '^v', ''
        Write-Log "Latest version: $LatestVersion"
        return $LatestVersion
    }
    catch {
        Write-Log "Failed to fetch latest version: $_" -Level "ERROR"
        throw "Unable to determine latest NetBird version. Please specify version manually."
    }
}

# Function to download NetBird MSI
function Download-NetBirdMSI {
    param([string]$Version)

    $DownloadURL = "https://github.com/netbirdio/netbird/releases/download/v$Version/netbird_installer_${Version}_windows_amd64.msi"
    $MSIPath = Join-Path $TempDir "netbird_installer_${Version}_windows_amd64.msi"

    try {
        Write-Log "Downloading NetBird v$Version from $DownloadURL..."

        # Use TLS 1.2
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        # Download with progress
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $DownloadURL -OutFile $MSIPath -UseBasicParsing
        $ProgressPreference = 'Continue'

        if (Test-Path $MSIPath) {
            $FileSize = (Get-Item $MSIPath).Length / 1MB
            Write-Log "Download completed. File size: $([math]::Round($FileSize, 2)) MB"
            return $MSIPath
        }
        else {
            throw "MSI file not found after download"
        }
    }
    catch {
        Write-Log "Download failed: $_" -Level "ERROR"
        throw
    }
}

# Function to install NetBird MSI
function Install-NetBirdMSI {
    param([string]$MSIPath)

    try {
        Write-Log "Installing NetBird from $MSIPath..."

        # Build msiexec arguments for silent installation
        $MSIArguments = @(
            "/i"
            "`"$MSIPath`""
            "/qn"
            "/norestart"
            "/L*v"
            "`"$env:TEMP\netbird_install.log`""
        )

        # Start installation process
        $Process = Start-Process -FilePath "msiexec.exe" -ArgumentList $MSIArguments -Wait -PassThru -NoNewWindow

        if ($Process.ExitCode -eq 0) {
            Write-Log "NetBird installed successfully"
        }
        elseif ($Process.ExitCode -eq 3010) {
            Write-Log "NetBird installed successfully (reboot required)" -Level "WARNING"
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

# Function to configure NetBird for self-hosted instance
function Configure-NetBird {
    param(
        [string]$ManagementURL,
        [string]$AdminURL
    )

    try {
        Write-Log "Configuring NetBird for self-hosted instance..."

        # Wait for config file to be created
        $Timeout = 30
        $Elapsed = 0
        while (!(Test-Path $ConfigPath) -and $Elapsed -lt $Timeout) {
            Start-Sleep -Seconds 2
            $Elapsed += 2
        }

        if (Test-Path $ConfigPath) {
            # Read existing config
            $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

            # Parse Management URL
            if ($ManagementURL -match '^(https?://)?([^:]+)(:(\d+))?') {
                $MgmtHost = $matches[2]
                $MgmtPort = if ($matches[4]) { $matches[4] } else { "33073" }
                $MgmtScheme = if ($matches[1]) { $matches[1] -replace '://', '' } else { "https" }

                $Config.ManagementURL.Scheme = $MgmtScheme
                $Config.ManagementURL.Host = "${MgmtHost}:${MgmtPort}"
            }

            # Parse Admin URL if provided
            if ($AdminURL) {
                if ($AdminURL -match '^(https?://)?([^:]+)(:(\d+))?') {
                    $AdminHost = $matches[2]
                    $AdminPort = if ($matches[4]) { $matches[4] } else { "443" }
                    $AdminScheme = if ($matches[1]) { $matches[1] -replace '://', '' } else { "https" }

                    $Config.AdminURL.Scheme = $AdminScheme
                    $Config.AdminURL.Host = "${AdminHost}:${AdminPort}"
                }
            }

            # Save updated config
            $Config | ConvertTo-Json -Depth 10 | Set-Content $ConfigPath -Force
            Write-Log "Configuration updated successfully"
        }
        else {
            Write-Log "Config file not found, will use command-line parameters" -Level "WARNING"
        }
    }
    catch {
        Write-Log "Configuration failed: $_" -Level "ERROR"
        throw
    }
}

# Function to connect NetBird using setup key
function Connect-NetBird {
    param([string]$SetupKey, [string]$ManagementURL)

    try {
        Write-Log "Connecting NetBird agent to management server..."

        if (!(Test-Path $NetBirdExe)) {
            throw "NetBird executable not found at $NetBirdExe"
        }

        # Build netbird up command
        $NetBirdArgs = @(
            "up"
            "--setup-key"
            $SetupKey
        )

        # Add management URL if config wasn't updated
        if (!(Test-Path $ConfigPath)) {
            $NetBirdArgs += "--management-url"
            $NetBirdArgs += $ManagementURL
        }

        # Execute netbird up
        Write-Log "Running: netbird up --setup-key [REDACTED]"
        $Process = Start-Process -FilePath $NetBirdExe -ArgumentList $NetBirdArgs -Wait -PassThru -NoNewWindow -RedirectStandardOutput "$env:TEMP\netbird_up_stdout.txt" -RedirectStandardError "$env:TEMP\netbird_up_stderr.txt"

        if ($Process.ExitCode -eq 0) {
            Write-Log "NetBird connected successfully"

            # Get status
            $Status = & $NetBirdExe status 2>&1
            Write-Log "NetBird Status: $Status"
        }
        else {
            $StdErr = Get-Content "$env:TEMP\netbird_up_stderr.txt" -Raw -ErrorAction SilentlyContinue
            throw "Connection failed with exit code $($Process.ExitCode): $StdErr"
        }
    }
    catch {
        Write-Log "Connection failed: $_" -Level "ERROR"
        throw
    }
}

# Function to verify NetBird service
function Verify-NetBirdService {
    try {
        Write-Log "Verifying NetBird service..."

        $Service = Get-Service -Name "netbird" -ErrorAction SilentlyContinue

        if ($Service) {
            Write-Log "NetBird service status: $($Service.Status)"

            if ($Service.Status -ne "Running") {
                Write-Log "Starting NetBird service..."
                Start-Service -Name "netbird"
                Start-Sleep -Seconds 3

                $Service = Get-Service -Name "netbird"
                Write-Log "NetBird service status after start: $($Service.Status)"
            }

            return $true
        }
        else {
            Write-Log "NetBird service not found" -Level "WARNING"
            return $false
        }
    }
    catch {
        Write-Log "Service verification failed: $_" -Level "ERROR"
        return $false
    }
}

# Main execution
try {
    Write-Log "=== NetBird Windows Deployment Started ==="

    # Check if running as administrator
    $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (!$IsAdmin) {
        throw "This script must be run as Administrator"
    }

    # Create temp directory
    if (!(Test-Path $TempDir)) {
        New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
    }

    # Ensure ProgramData\NetBird exists
    $NetBirdDataPath = "$env:ProgramData\NetBird"
    if (!(Test-Path $NetBirdDataPath)) {
        New-Item -ItemType Directory -Path $NetBirdDataPath -Force | Out-Null
    }

    # Determine version to install
    if ([string]::IsNullOrEmpty($NetBirdVersion)) {
        $NetBirdVersion = Get-LatestNetBirdVersion
    }

    # Check if NetBird is already installed
    $ExistingInstall = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
                      Where-Object { $_.DisplayName -like "*NetBird*" }

    if ($ExistingInstall) {
        Write-Log "NetBird is already installed (Version: $($ExistingInstall.DisplayVersion))"
        Write-Log "Proceeding with connection setup..."
    }
    else {
        # Download MSI
        $MSIPath = Download-NetBirdMSI -Version $NetBirdVersion

        # Install NetBird
        Install-NetBirdMSI -MSIPath $MSIPath
    }

    # Verify service
    Verify-NetBirdService

    # Configure for self-hosted instance
    Configure-NetBird -ManagementURL $ManagementURL -AdminURL $AdminURL

    # Connect to NetBird
    Connect-NetBird -SetupKey $SetupKey -ManagementURL $ManagementURL

    # Cleanup
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Log "=== NetBird Windows Deployment Completed Successfully ==="
    Write-Output "SUCCESS: NetBird agent installed and connected"
    exit 0
}
catch {
    Write-Log "=== NetBird Windows Deployment Failed ===" -Level "ERROR"
    Write-Log "Error: $_" -Level "ERROR"
    Write-Output "FAILED: $_"
    exit 1
}
