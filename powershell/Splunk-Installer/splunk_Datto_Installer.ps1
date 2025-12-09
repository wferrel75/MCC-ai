<#
.SYNOPSIS
    Downloads and installs Splunk Universal Forwarder with enterprise deployment server configuration for Datto RMM.

.DESCRIPTION
    This script automates the deployment of Splunk Universal Forwarder in enterprise environments.
    Designed for Datto RMM component execution but also supports standalone execution.

    Features:
    - Downloads Splunk Universal Forwarder MSI installer
    - Performs silent installation with enterprise configuration
    - Configures deployment server or receiving indexer
    - Validates installation and service status
    - Comprehensive logging and error handling
    - Datto RMM exit code integration

.PARAMETER DeploymentServer
    Deployment server address in format "hostname:port" (e.g., "splunk-ds.domain.com:8089")
    Can be set via Datto RMM environment variable: $ENV:deploymentServer

.PARAMETER ReceivingIndexer
    Receiving indexer address in format "hostname:port" (e.g., "splunk-indexer.domain.com:9997")
    Optional if using deployment server. Set via $ENV:receivingIndexer

.PARAMETER SplunkUsername
    Splunk admin username. Default: "admin"
    Set via $ENV:splunkUsername

.PARAMETER SplunkPassword
    Splunk admin password. Required for installation.
    Set via $ENV:splunkPassword

.PARAMETER InstallPath
    Custom installation path. Default: "C:\Program Files\SplunkUniversalForwarder"
    Set via $ENV:installPath

.EXAMPLE
    # Standalone execution
    .\splunk_Datto_Installer.ps1

.EXAMPLE
    # With parameters
    $ENV:deploymentServer = "splunk-ds.company.com:8089"
    $ENV:splunkPassword = "SecurePassword123!"
    .\splunk_Datto_Installer.ps1

.NOTES
    Author: Datto RMM Automation
    Version: 1.0
    Requires: PowerShell 5.1+, Administrator privileges

    DATTO RMM COMPONENT CONFIGURATION
    =================================
    Component Name: Install Splunk Universal Forwarder
    Component Type: PowerShell Component
    Category: Software Deployment
    Timeout: 30 minutes

    Environment Variables (Configure in Datto RMM):
    ------------------------------------------------
    Variable Name         | Required | Example Value
    ---------------------|----------|----------------------------------
    deploymentServer     | Yes*     | splunk-ds.domain.com:8089
    receivingIndexer     | Yes*     | splunk-indexer.domain.com:9997
    splunkUsername       | No       | admin (default)
    splunkPassword       | Yes      | YourSecurePassword123!
    installPath          | No       | C:\Program Files\SplunkUniversalForwarder
    splunkVersion        | No       | 9.1.2 (uses default if not set)
    splunkBuild          | No       | d8ae995bf219 (uses default if not set)

    * Either deploymentServer OR receivingIndexer must be provided

    Exit Codes:
    -----------
    0 = Success - Splunk installed and running
    1 = Download failed
    2 = Installation failed
    3 = Service startup failed
    4 = Missing required parameters
    5 = Insufficient privileges
    6 = Already installed (not an error, informational)
    7 = Insufficient disk space
    8 = Pre-installation check failed

    Installation Notes:
    ------------------
    - Script requires Administrator privileges
    - Minimum 500MB free disk space required
    - Firewall rules may need configuration for Splunk communication
    - Installation log saved to: C:\Temp\Splunk_Install_Log.txt
    - MSI installation log saved to: C:\Temp\Splunk_MSI_Install.log

    Uninstall Instructions:
    ----------------------
    Method 1 - MSI Uninstall:
    msiexec /x {GUID} /quiet /norestart
    (Find GUID: Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Splunk*"})

    Method 2 - Control Panel:
    Programs and Features > Splunk Universal Forwarder > Uninstall

    Method 3 - PowerShell:
    Get-Package "Splunk*" | Uninstall-Package -Force

    Troubleshooting:
    ---------------
    - Check logs: C:\Temp\Splunk_Install_Log.txt and C:\Temp\Splunk_MSI_Install.log
    - Verify service: Get-Service -Name SplunkForwarder
    - Check connectivity: Test-NetConnection -ComputerName splunk-ds.domain.com -Port 8089
    - Manual start: Start-Service SplunkForwarder
    - Splunk CLI: C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe status

    Version Update Instructions:
    ---------------------------
    To update to a newer Splunk version:
    1. Visit: https://www.splunk.com/en_us/download/universal-forwarder.html
    2. Find the latest Windows 64-bit MSI version
    3. Update $script:DefaultSplunkVersion and $script:DefaultSplunkBuild below
    4. Or set via Datto environment variables: splunkVersion and splunkBuild
#>

#Requires -RunAsAdministrator

[CmdletBinding()]
param()

#region CONFIGURATION

# Default Splunk Version Configuration
# Update these values when new versions are released
# Check latest version at: https://www.splunk.com/en_us/download/universal-forwarder.html
$script:DefaultSplunkVersion = "9.1.2"  # Format: Major.Minor.Patch
$script:DefaultSplunkBuild = "d8ae995bf219"  # Build hash from Splunk download page

# Allow override via Datto RMM environment variables
$script:SplunkVersion = if ($ENV:splunkVersion) { $ENV:splunkVersion } else { $script:DefaultSplunkVersion }
$script:SplunkBuild = if ($ENV:splunkBuild) { $ENV:splunkBuild } else { $script:DefaultSplunkBuild }

# Construct download URL
$script:DownloadUrl = "https://download.splunk.com/products/universalforwarder/releases/$script:SplunkVersion/windows/splunkforwarder-$script:SplunkVersion-$script:SplunkBuild-x64-release.msi"

# Alternative: Use direct download URL if provided
if ($ENV:splunkDownloadUrl) {
    $script:DownloadUrl = $ENV:splunkDownloadUrl
}

# Paths
$script:TempDirectory = "C:\Temp"
$script:LogFile = Join-Path $script:TempDirectory "Splunk_Install_Log.txt"
$script:MsiLogFile = Join-Path $script:TempDirectory "Splunk_MSI_Install.log"
$script:InstallerPath = Join-Path $script:TempDirectory "splunkforwarder-$script:SplunkVersion-$script:SplunkBuild-x64-release.msi"

# Splunk Service Name
$script:SplunkServiceName = "SplunkForwarder"

# Minimum required disk space (in MB)
$script:MinimumDiskSpaceMB = 500

#endregion CONFIGURATION

#region LOGGING FUNCTION

<#
.SYNOPSIS
    Writes log messages to file and console.
#>
function Write-LogMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Warning', 'Error', 'Success', 'Verbose')]
        [string]$Level = 'Info'
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    # Write to log file
    try {
        Add-Content -Path $script:LogFile -Value $logMessage -ErrorAction Stop
    }
    catch {
        Write-Warning "Failed to write to log file: $_"
    }

    # Write to console based on level
    switch ($Level) {
        'Info'    { Write-Output $Message }
        'Warning' { Write-Warning $Message }
        'Error'   { Write-Error $Message }
        'Success' { Write-Output "[SUCCESS] $Message" }
        'Verbose' { Write-Verbose $Message -Verbose }
    }
}

#endregion LOGGING FUNCTION

#region PRE-INSTALLATION CHECKS

<#
.SYNOPSIS
    Verifies the script is running with Administrator privileges.
#>
function Test-AdministratorPrivileges {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    Write-LogMessage "Checking for Administrator privileges..." -Level Verbose

    try {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        if ($isAdmin) {
            Write-LogMessage "Administrator privileges confirmed." -Level Success
            return $true
        }
        else {
            Write-LogMessage "Script must be run with Administrator privileges." -Level Error
            return $false
        }
    }
    catch {
        Write-LogMessage "Error checking Administrator privileges: $_" -Level Error
        return $false
    }
}

<#
.SYNOPSIS
    Checks if Splunk Universal Forwarder is already installed.
#>
function Test-SplunkInstalled {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    Write-LogMessage "Checking if Splunk Universal Forwarder is already installed..." -Level Verbose

    try {
        # Method 1: Check service
        $service = Get-Service -Name $script:SplunkServiceName -ErrorAction SilentlyContinue
        if ($service) {
            Write-LogMessage "Splunk service found: $($service.DisplayName) - Status: $($service.Status)" -Level Warning
            return $true
        }

        # Method 2: Check registry
        $registryPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
        )

        foreach ($path in $registryPaths) {
            $installed = Get-ItemProperty $path -ErrorAction SilentlyContinue |
                         Where-Object { $_.DisplayName -like "*Splunk*Forwarder*" }

            if ($installed) {
                Write-LogMessage "Splunk installation found in registry: $($installed.DisplayName)" -Level Warning
                return $true
            }
        }

        # Method 3: Check default installation directory
        $defaultPath = "C:\Program Files\SplunkUniversalForwarder"
        if (Test-Path $defaultPath) {
            Write-LogMessage "Splunk installation directory found at: $defaultPath" -Level Warning
            return $true
        }

        Write-LogMessage "Splunk Universal Forwarder is not installed." -Level Success
        return $false
    }
    catch {
        Write-LogMessage "Error checking Splunk installation status: $_" -Level Error
        return $false
    }
}

<#
.SYNOPSIS
    Verifies sufficient disk space is available.
#>
function Test-DiskSpace {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $false)]
        [string]$DriveLetter = "C"
    )

    Write-LogMessage "Checking available disk space on drive $DriveLetter..." -Level Verbose

    try {
        $drive = Get-PSDrive -Name $DriveLetter -ErrorAction Stop
        $freeSpaceMB = [math]::Round($drive.Free / 1MB, 2)

        Write-LogMessage "Available space on drive ${DriveLetter}: $freeSpaceMB MB" -Level Verbose

        if ($freeSpaceMB -ge $script:MinimumDiskSpaceMB) {
            Write-LogMessage "Sufficient disk space available." -Level Success
            return $true
        }
        else {
            Write-LogMessage "Insufficient disk space. Required: $script:MinimumDiskSpaceMB MB, Available: $freeSpaceMB MB" -Level Error
            return $false
        }
    }
    catch {
        Write-LogMessage "Error checking disk space: $_" -Level Error
        return $false
    }
}

<#
.SYNOPSIS
    Tests network connectivity to deployment server or indexer.
#>
function Test-SplunkConnectivity {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerAddress
    )

    Write-LogMessage "Testing connectivity to: $ServerAddress" -Level Verbose

    try {
        # Parse hostname and port
        if ($ServerAddress -match '^(.+):(\d+)$') {
            $hostname = $Matches[1]
            $port = [int]$Matches[2]

            Write-LogMessage "Parsed - Hostname: $hostname, Port: $port" -Level Verbose

            # Test DNS resolution
            try {
                $resolvedIP = [System.Net.Dns]::GetHostAddresses($hostname) | Select-Object -First 1
                Write-LogMessage "DNS resolution successful: $hostname -> $($resolvedIP.IPAddressToString)" -Level Verbose
            }
            catch {
                Write-LogMessage "DNS resolution failed for $hostname : $_" -Level Warning
                return $false
            }

            # Test port connectivity
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $asyncResult = $tcpClient.BeginConnect($hostname, $port, $null, $null)
            $waitHandle = $asyncResult.AsyncWaitHandle

            try {
                if ($waitHandle.WaitOne(5000, $false)) {
                    $tcpClient.EndConnect($asyncResult)
                    Write-LogMessage "Successfully connected to ${hostname}:${port}" -Level Success
                    return $true
                }
                else {
                    Write-LogMessage "Connection timeout to ${hostname}:${port}" -Level Warning
                    return $false
                }
            }
            catch {
                Write-LogMessage "Connection failed to ${hostname}:${port} - $_" -Level Warning
                return $false
            }
            finally {
                $tcpClient.Close()
            }
        }
        else {
            Write-LogMessage "Invalid server address format: $ServerAddress (expected hostname:port)" -Level Warning
            return $false
        }
    }
    catch {
        Write-LogMessage "Error testing connectivity: $_" -Level Error
        return $false
    }
}

#endregion PRE-INSTALLATION CHECKS

#region DOWNLOAD FUNCTION

<#
.SYNOPSIS
    Downloads the Splunk Universal Forwarder installer.
#>
function Get-SplunkInstaller {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    Write-LogMessage "Starting Splunk Universal Forwarder download..." -Level Info
    Write-LogMessage "Download URL: $script:DownloadUrl" -Level Verbose
    Write-LogMessage "Destination: $script:InstallerPath" -Level Verbose

    try {
        # Ensure temp directory exists
        if (-not (Test-Path $script:TempDirectory)) {
            Write-LogMessage "Creating temp directory: $script:TempDirectory" -Level Verbose
            New-Item -Path $script:TempDirectory -ItemType Directory -Force | Out-Null
        }

        # Check if installer already exists
        if (Test-Path $script:InstallerPath) {
            Write-LogMessage "Installer already exists at: $script:InstallerPath" -Level Warning
            Write-LogMessage "Removing existing installer..." -Level Verbose
            Remove-Item -Path $script:InstallerPath -Force
        }

        # Configure TLS settings for secure download
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        # Download with progress
        Write-LogMessage "Downloading Splunk Universal Forwarder (this may take several minutes)..." -Level Info

        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($script:DownloadUrl, $script:InstallerPath)
        $webClient.Dispose()

        # Verify download
        if (Test-Path $script:InstallerPath) {
            $fileSize = (Get-Item $script:InstallerPath).Length
            $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
            Write-LogMessage "Download completed successfully. File size: $fileSizeMB MB" -Level Success

            # Basic validation - MSI files should be at least 10MB
            if ($fileSize -lt 10MB) {
                Write-LogMessage "Downloaded file is suspiciously small ($fileSizeMB MB). Download may have failed." -Level Error
                return $false
            }

            return $true
        }
        else {
            Write-LogMessage "Download failed. Installer file not found at: $script:InstallerPath" -Level Error
            return $false
        }
    }
    catch {
        Write-LogMessage "Error downloading Splunk installer: $_" -Level Error
        Write-LogMessage "Error details: $($_.Exception.Message)" -Level Error
        return $false
    }
}

#endregion DOWNLOAD FUNCTION

#region INSTALLATION FUNCTION

<#
.SYNOPSIS
    Installs Splunk Universal Forwarder with enterprise configuration.
#>
function Install-SplunkUniversalForwarder {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $false)]
        [string]$DeploymentServer,

        [Parameter(Mandatory = $false)]
        [string]$ReceivingIndexer,

        [Parameter(Mandatory = $true)]
        [string]$Username,

        [Parameter(Mandatory = $true)]
        [string]$Password,

        [Parameter(Mandatory = $false)]
        [string]$InstallPath = "C:\Program Files\SplunkUniversalForwarder"
    )

    Write-LogMessage "Starting Splunk Universal Forwarder installation..." -Level Info

    try {
        # Build MSI installation arguments
        $msiArguments = @(
            "/i `"$script:InstallerPath`""
            "/qn"  # Quiet mode, no UI
            "/norestart"  # Do not restart
            "/L*v `"$script:MsiLogFile`""  # Verbose logging
            "AGREETOLICENSE=Yes"
            "SPLUNKUSERNAME=`"$Username`""
            "SPLUNKPASSWORD=`"$Password`""
            "LAUNCHSPLUNK=0"  # Don't start during installation
            "INSTALLDIR=`"$InstallPath`""
        )

        # Add deployment server if provided
        if ($DeploymentServer) {
            Write-LogMessage "Configuring deployment server: $DeploymentServer" -Level Verbose
            $msiArguments += "DEPLOYMENT_SERVER=`"$DeploymentServer`""
        }

        # Add receiving indexer if provided (and no deployment server)
        if ($ReceivingIndexer -and -not $DeploymentServer) {
            Write-LogMessage "Configuring receiving indexer: $ReceivingIndexer" -Level Verbose
            $msiArguments += "RECEIVING_INDEXER=`"$ReceivingIndexer`""
        }

        # Join arguments
        $argumentString = $msiArguments -join " "

        Write-LogMessage "MSI installation command: msiexec.exe $argumentString" -Level Verbose
        Write-LogMessage "Installation may take 5-10 minutes. Please wait..." -Level Info

        # Execute installation
        $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $argumentString -Wait -PassThru -NoNewWindow

        # Check exit code
        $exitCode = $process.ExitCode
        Write-LogMessage "MSI installation exit code: $exitCode" -Level Verbose

        # MSI exit codes: 0 = Success, 3010 = Success but restart required
        if ($exitCode -eq 0 -or $exitCode -eq 3010) {
            Write-LogMessage "Splunk Universal Forwarder installation completed successfully." -Level Success

            if ($exitCode -eq 3010) {
                Write-LogMessage "Installation requires a system restart to complete." -Level Warning
            }

            return $true
        }
        else {
            Write-LogMessage "Installation failed with exit code: $exitCode" -Level Error
            Write-LogMessage "Check MSI log for details: $script:MsiLogFile" -Level Error
            return $false
        }
    }
    catch {
        Write-LogMessage "Error during installation: $_" -Level Error
        Write-LogMessage "Error details: $($_.Exception.Message)" -Level Error
        return $false
    }
}

#endregion INSTALLATION FUNCTION

#region POST-INSTALLATION VALIDATION

<#
.SYNOPSIS
    Validates Splunk service status and configuration.
#>
function Test-SplunkService {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $false)]
        [int]$MaxRetries = 3,

        [Parameter(Mandatory = $false)]
        [int]$RetryDelaySeconds = 10
    )

    Write-LogMessage "Validating Splunk service..." -Level Info

    try {
        $retryCount = 0
        $serviceRunning = $false

        while ($retryCount -lt $MaxRetries -and -not $serviceRunning) {
            $retryCount++

            Write-LogMessage "Service check attempt $retryCount of $MaxRetries..." -Level Verbose

            # Get service
            $service = Get-Service -Name $script:SplunkServiceName -ErrorAction SilentlyContinue

            if (-not $service) {
                Write-LogMessage "Splunk service not found." -Level Warning

                if ($retryCount -lt $MaxRetries) {
                    Write-LogMessage "Waiting $RetryDelaySeconds seconds before retry..." -Level Verbose
                    Start-Sleep -Seconds $RetryDelaySeconds
                    continue
                }
                else {
                    Write-LogMessage "Service not found after $MaxRetries attempts." -Level Error
                    return $false
                }
            }

            Write-LogMessage "Service found: $($service.DisplayName)" -Level Verbose
            Write-LogMessage "Service status: $($service.Status)" -Level Verbose
            Write-LogMessage "Service startup type: $($service.StartType)" -Level Verbose

            # Check if service is running
            if ($service.Status -eq 'Running') {
                Write-LogMessage "Splunk service is running." -Level Success
                $serviceRunning = $true
            }
            else {
                Write-LogMessage "Splunk service is not running. Attempting to start..." -Level Warning

                try {
                    Start-Service -Name $script:SplunkServiceName -ErrorAction Stop
                    Start-Sleep -Seconds 5

                    $service.Refresh()

                    if ($service.Status -eq 'Running') {
                        Write-LogMessage "Splunk service started successfully." -Level Success
                        $serviceRunning = $true
                    }
                    else {
                        Write-LogMessage "Service status after start attempt: $($service.Status)" -Level Warning

                        if ($retryCount -lt $MaxRetries) {
                            Write-LogMessage "Waiting $RetryDelaySeconds seconds before retry..." -Level Verbose
                            Start-Sleep -Seconds $RetryDelaySeconds
                        }
                    }
                }
                catch {
                    Write-LogMessage "Failed to start service: $_" -Level Error

                    if ($retryCount -lt $MaxRetries) {
                        Write-LogMessage "Waiting $RetryDelaySeconds seconds before retry..." -Level Verbose
                        Start-Sleep -Seconds $RetryDelaySeconds
                    }
                }
            }
        }

        # Verify startup type is set to Automatic
        if ($serviceRunning) {
            $service = Get-Service -Name $script:SplunkServiceName

            if ($service.StartType -ne 'Automatic') {
                Write-LogMessage "Setting service startup type to Automatic..." -Level Verbose
                try {
                    Set-Service -Name $script:SplunkServiceName -StartupType Automatic -ErrorAction Stop
                    Write-LogMessage "Service startup type set to Automatic." -Level Success
                }
                catch {
                    Write-LogMessage "Warning: Failed to set startup type to Automatic: $_" -Level Warning
                }
            }
        }

        return $serviceRunning
    }
    catch {
        Write-LogMessage "Error validating Splunk service: $_" -Level Error
        return $false
    }
}

<#
.SYNOPSIS
    Validates installation directory and files.
#>
function Test-SplunkInstallation {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$InstallPath
    )

    Write-LogMessage "Validating Splunk installation directory..." -Level Verbose

    try {
        # Check if installation directory exists
        if (-not (Test-Path $InstallPath)) {
            Write-LogMessage "Installation directory not found: $InstallPath" -Level Error
            return $false
        }

        Write-LogMessage "Installation directory exists: $InstallPath" -Level Success

        # Check for critical files
        $criticalFiles = @(
            "bin\splunk.exe",
            "etc\splunk-launch.conf",
            "etc\system\default\inputs.conf"
        )

        $allFilesExist = $true
        foreach ($file in $criticalFiles) {
            $fullPath = Join-Path $InstallPath $file

            if (Test-Path $fullPath) {
                Write-LogMessage "Found: $file" -Level Verbose
            }
            else {
                Write-LogMessage "Missing critical file: $file" -Level Warning
                $allFilesExist = $false
            }
        }

        if ($allFilesExist) {
            Write-LogMessage "All critical files validated." -Level Success
            return $true
        }
        else {
            Write-LogMessage "Some critical files are missing." -Level Warning
            return $true  # Don't fail entirely, service check is more important
        }
    }
    catch {
        Write-LogMessage "Error validating installation: $_" -Level Error
        return $false
    }
}

#endregion POST-INSTALLATION VALIDATION

#region CLEANUP FUNCTION

<#
.SYNOPSIS
    Cleans up temporary installation files.
#>
function Remove-InstallerFiles {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [switch]$KeepLogs
    )

    Write-LogMessage "Cleaning up temporary files..." -Level Verbose

    try {
        # Remove installer MSI
        if (Test-Path $script:InstallerPath) {
            Write-LogMessage "Removing installer: $script:InstallerPath" -Level Verbose
            Remove-Item -Path $script:InstallerPath -Force -ErrorAction SilentlyContinue
        }

        # Keep logs by default for troubleshooting
        if (-not $KeepLogs) {
            if (Test-Path $script:MsiLogFile) {
                Write-LogMessage "Removing MSI log: $script:MsiLogFile" -Level Verbose
                Remove-Item -Path $script:MsiLogFile -Force -ErrorAction SilentlyContinue
            }
        }
        else {
            Write-LogMessage "Keeping installation logs for troubleshooting." -Level Info
        }

        Write-LogMessage "Cleanup completed." -Level Success
    }
    catch {
        Write-LogMessage "Warning: Error during cleanup: $_" -Level Warning
    }
}

#endregion CLEANUP FUNCTION

#region MAIN EXECUTION

<#
.SYNOPSIS
    Main execution block for Splunk Universal Forwarder installation.
#>
function Start-SplunkInstallation {
    [CmdletBinding()]
    param()

    Write-LogMessage "========================================" -Level Info
    Write-LogMessage "Splunk Universal Forwarder Installation" -Level Info
    Write-LogMessage "Version: $script:SplunkVersion" -Level Info
    Write-LogMessage "Build: $script:SplunkBuild" -Level Info
    Write-LogMessage "========================================" -Level Info

    # Initialize log file
    try {
        if (-not (Test-Path $script:TempDirectory)) {
            New-Item -Path $script:TempDirectory -ItemType Directory -Force | Out-Null
        }

        # Clear old log if exists
        if (Test-Path $script:LogFile) {
            Remove-Item -Path $script:LogFile -Force -ErrorAction SilentlyContinue
        }

        Write-LogMessage "Installation started at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -Level Info
    }
    catch {
        Write-Error "Failed to initialize logging: $_"
        exit 8
    }

    # Retrieve configuration from Datto RMM environment variables or use defaults
    $deploymentServer = $ENV:deploymentServer
    $receivingIndexer = $ENV:receivingIndexer
    $splunkUsername = if ($ENV:splunkUsername) { $ENV:splunkUsername } else { "admin" }
    $splunkPassword = $ENV:splunkPassword
    $installPath = if ($ENV:installPath) { $ENV:installPath } else { "C:\Program Files\SplunkUniversalForwarder" }

    Write-LogMessage "Configuration:" -Level Info
    Write-LogMessage "  Deployment Server: $(if($deploymentServer){$deploymentServer}else{'Not configured'})" -Level Info
    Write-LogMessage "  Receiving Indexer: $(if($receivingIndexer){$receivingIndexer}else{'Not configured'})" -Level Info
    Write-LogMessage "  Username: $splunkUsername" -Level Info
    Write-LogMessage "  Install Path: $installPath" -Level Info

    # STEP 1: Validate required parameters
    Write-LogMessage "Step 1: Validating required parameters..." -Level Info

    if (-not $splunkPassword) {
        Write-LogMessage "ERROR: Splunk password is required. Set ENV:splunkPassword" -Level Error
        Write-LogMessage "Installation failed: Missing required parameters" -Level Error
        exit 4
    }

    if (-not $deploymentServer -and -not $receivingIndexer) {
        Write-LogMessage "ERROR: Either deployment server or receiving indexer must be configured." -Level Error
        Write-LogMessage "Set ENV:deploymentServer or ENV:receivingIndexer" -Level Error
        Write-LogMessage "Installation failed: Missing required parameters" -Level Error
        exit 4
    }

    Write-LogMessage "Required parameters validated." -Level Success

    # STEP 2: Check Administrator privileges
    Write-LogMessage "Step 2: Checking Administrator privileges..." -Level Info

    if (-not (Test-AdministratorPrivileges)) {
        Write-LogMessage "Installation failed: Insufficient privileges" -Level Error
        exit 5
    }

    # STEP 3: Check if already installed
    Write-LogMessage "Step 3: Checking for existing installation..." -Level Info

    if (Test-SplunkInstalled) {
        Write-LogMessage "Splunk Universal Forwarder is already installed." -Level Warning
        Write-LogMessage "Installation skipped. Exit code: 6 (Already installed)" -Level Info
        exit 6
    }

    # STEP 4: Check disk space
    Write-LogMessage "Step 4: Checking disk space..." -Level Info

    $driveLetter = $installPath.Substring(0, 1)
    if (-not (Test-DiskSpace -DriveLetter $driveLetter)) {
        Write-LogMessage "Installation failed: Insufficient disk space" -Level Error
        exit 7
    }

    # STEP 5: Test connectivity to deployment server or indexer
    Write-LogMessage "Step 5: Testing network connectivity..." -Level Info

    $connectivityOk = $true

    if ($deploymentServer) {
        if (-not (Test-SplunkConnectivity -ServerAddress $deploymentServer)) {
            Write-LogMessage "Warning: Cannot connect to deployment server: $deploymentServer" -Level Warning
            Write-LogMessage "Installation will continue, but connectivity should be verified." -Level Warning
            $connectivityOk = $false
        }
    }

    if ($receivingIndexer -and -not $deploymentServer) {
        if (-not (Test-SplunkConnectivity -ServerAddress $receivingIndexer)) {
            Write-LogMessage "Warning: Cannot connect to receiving indexer: $receivingIndexer" -Level Warning
            Write-LogMessage "Installation will continue, but connectivity should be verified." -Level Warning
            $connectivityOk = $false
        }
    }

    if ($connectivityOk) {
        Write-LogMessage "Network connectivity validated." -Level Success
    }

    # STEP 6: Download Splunk installer
    Write-LogMessage "Step 6: Downloading Splunk Universal Forwarder..." -Level Info

    if (-not (Get-SplunkInstaller)) {
        Write-LogMessage "Installation failed: Download failed" -Level Error
        exit 1
    }

    # STEP 7: Install Splunk
    Write-LogMessage "Step 7: Installing Splunk Universal Forwarder..." -Level Info

    $installParams = @{
        Username = $splunkUsername
        Password = $splunkPassword
        InstallPath = $installPath
    }

    if ($deploymentServer) {
        $installParams['DeploymentServer'] = $deploymentServer
    }

    if ($receivingIndexer) {
        $installParams['ReceivingIndexer'] = $receivingIndexer
    }

    if (-not (Install-SplunkUniversalForwarder @installParams)) {
        Write-LogMessage "Installation failed: Installation process failed" -Level Error
        Write-LogMessage "Check MSI log for details: $script:MsiLogFile" -Level Error
        exit 2
    }

    # STEP 8: Validate installation
    Write-LogMessage "Step 8: Validating installation..." -Level Info

    if (-not (Test-SplunkInstallation -InstallPath $installPath)) {
        Write-LogMessage "Warning: Installation validation failed" -Level Warning
    }

    # STEP 9: Validate and start service
    Write-LogMessage "Step 9: Validating Splunk service..." -Level Info

    if (-not (Test-SplunkService)) {
        Write-LogMessage "Installation failed: Service startup failed" -Level Error
        Write-LogMessage "Service may need manual start or configuration." -Level Error
        exit 3
    }

    # STEP 10: Cleanup
    Write-LogMessage "Step 10: Cleaning up temporary files..." -Level Info
    Remove-InstallerFiles -KeepLogs

    # STEP 11: Final summary
    Write-LogMessage "========================================" -Level Info
    Write-LogMessage "Installation completed successfully!" -Level Success
    Write-LogMessage "========================================" -Level Info
    Write-LogMessage "Installation Details:" -Level Info
    Write-LogMessage "  Version: $script:SplunkVersion" -Level Info
    Write-LogMessage "  Install Path: $installPath" -Level Info
    Write-LogMessage "  Service Name: $script:SplunkServiceName" -Level Info
    Write-LogMessage "  Service Status: Running" -Level Info

    if ($deploymentServer) {
        Write-LogMessage "  Deployment Server: $deploymentServer" -Level Info
    }

    if ($receivingIndexer) {
        Write-LogMessage "  Receiving Indexer: $receivingIndexer" -Level Info
    }

    Write-LogMessage "" -Level Info
    Write-LogMessage "Next Steps:" -Level Info
    Write-LogMessage "  1. Verify forwarder is checking in with deployment server" -Level Info
    Write-LogMessage "  2. Configure apps and inputs via deployment server" -Level Info
    Write-LogMessage "  3. Monitor forwarder status in Splunk UI" -Level Info
    Write-LogMessage "" -Level Info
    Write-LogMessage "Troubleshooting:" -Level Info
    Write-LogMessage "  Installation Log: $script:LogFile" -Level Info
    Write-LogMessage "  MSI Log: $script:MsiLogFile" -Level Info
    Write-LogMessage "  Splunk Home: $installPath" -Level Info
    Write-LogMessage "  Service Status: Get-Service -Name $script:SplunkServiceName" -Level Info
    Write-LogMessage "" -Level Info
    Write-LogMessage "Installation completed at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -Level Info

    exit 0
}

#endregion MAIN EXECUTION

# Execute main installation
try {
    Start-SplunkInstallation
}
catch {
    Write-LogMessage "Critical error during installation: $_" -Level Error
    Write-LogMessage "Stack trace: $($_.ScriptStackTrace)" -Level Error
    exit 8
}
