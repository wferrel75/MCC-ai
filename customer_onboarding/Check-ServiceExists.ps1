<#
.SYNOPSIS
    Checks for the existence of a Windows service and logs to file if not found.

.DESCRIPTION
    This script checks if a specified Windows service exists on the computer.
    If the service is not found, it logs the event to a file with timestamp and computer details.
    Designed to be deployed via Group Policy (Startup Script or Scheduled Task).

.PARAMETER ServiceName
    The name of the service to check for (not the display name).

.PARAMETER LogPath
    The full path to the log file. Default: C:\Logs\ServiceCheck.log

.PARAMETER CreateLogDirectory
    If specified, creates the log directory if it doesn't exist.

.EXAMPLE
    .\Check-ServiceExists.ps1 -ServiceName "Spooler" -LogPath "C:\Logs\PrintSpooler.log"
    Checks if the Print Spooler service exists and logs to specified file if not found.

.EXAMPLE
    .\Check-ServiceExists.ps1 -ServiceName "MyCustomService" -CreateLogDirectory
    Checks for custom service and creates log directory if needed.

.NOTES
    Author: Midwest Cloud Computing
    Date: 2025-12-08

    For Group Policy Deployment:
    - Computer Configuration > Policies > Windows Settings > Scripts > Startup
    - Or create a Scheduled Task via GPO to run at startup or on schedule

    Service Name vs Display Name:
    - Use the service name (e.g., "Spooler") not display name (e.g., "Print Spooler")
    - To find service name: Get-Service | Select-Object Name, DisplayName
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ServiceName,

    [Parameter(Mandatory=$false)]
    [string]$LogPath = "C:\Logs\ServiceCheck.log",

    [Parameter(Mandatory=$false)]
    [switch]$CreateLogDirectory
)

# Function to write log entry
function Write-LogEntry {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$true)]
        [string]$LogFile,

        [Parameter(Mandatory=$false)]
        [ValidateSet('INFO', 'WARNING', 'ERROR')]
        [string]$Level = 'INFO'
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $computerName = $env:COMPUTERNAME
    $logEntry = "$timestamp | $computerName | $Level | $Message"

    try {
        Add-Content -Path $LogFile -Value $logEntry -ErrorAction Stop
        return $true
    }
    catch {
        Write-Warning "Failed to write to log file: $_"
        return $false
    }
}

# Main script logic
try {
    # Create log directory if specified and doesn't exist
    $logDirectory = Split-Path -Path $LogPath -Parent
    if ($CreateLogDirectory -and -not (Test-Path -Path $logDirectory)) {
        try {
            New-Item -Path $logDirectory -ItemType Directory -Force | Out-Null
            Write-Verbose "Created log directory: $logDirectory"
        }
        catch {
            Write-Warning "Failed to create log directory: $_"
            exit 1
        }
    }

    # Check if log directory exists
    if (-not (Test-Path -Path $logDirectory)) {
        Write-Warning "Log directory does not exist: $logDirectory"
        Write-Warning "Use -CreateLogDirectory switch to create automatically"
        exit 1
    }

    # Check for service existence
    Write-Verbose "Checking for service: $ServiceName"
    $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if ($null -eq $service) {
        # Service not found - log it
        $message = "Service '$ServiceName' not found on computer"
        Write-LogEntry -Message $message -LogFile $LogPath -Level 'WARNING'
        Write-Warning $message
        exit 0
    }
    else {
        # Service exists - optionally log success
        Write-Verbose "Service '$ServiceName' found (Status: $($service.Status), DisplayName: $($service.DisplayName))"

        # Uncomment below to log when service IS found (creates verbose logs)
        # $message = "Service '$ServiceName' found (Status: $($service.Status))"
        # Write-LogEntry -Message $message -LogFile $LogPath -Level 'INFO'

        exit 0
    }
}
catch {
    $errorMessage = "Error checking service '$ServiceName': $($_.Exception.Message)"
    Write-LogEntry -Message $errorMessage -LogFile $LogPath -Level 'ERROR'
    Write-Error $errorMessage
    exit 1
}
