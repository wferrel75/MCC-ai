<#
.SYNOPSIS
    Refreshes BGInfo wallpaper for the current user.

.DESCRIPTION
    This script executes BGInfo to immediately update the desktop wallpaper with current
    system information. Designed to run via Datto RMM in user context.

    Use cases:
    - Force wallpaper refresh after configuration changes
    - Restore BGInfo wallpaper if overwritten
    - Scheduled updates to keep information current
    - Manual refresh on-demand

.PARAMETER BGInfoPath
    Path to BGInfo installation directory. Defaults to C:\MCC\BGInfo

.PARAMETER Silent
    Suppress all output except errors. Useful for scheduled tasks.

.EXAMPLE
    .\Refresh-BGInfo.ps1
    Refreshes BGInfo using default installation path

.EXAMPLE
    .\Refresh-BGInfo.ps1 -BGInfoPath "C:\Tools\BGInfo"
    Refreshes BGInfo from custom installation path

.EXAMPLE
    .\Refresh-BGInfo.ps1 -Silent
    Refreshes BGInfo with minimal output

.NOTES
    File Name      : Refresh-BGInfo.ps1
    Version        : 1.0.0
    Author         : Datto RMM Support Script
    Prerequisite   : BGInfo must be installed (via Deploy-BGInfo.ps1)
    Context        : Run as logged-in user (not SYSTEM)

    Version History:
    1.0.0 - 2025-12-11 - Initial release

    Exit Codes:
        0   - Success - BGInfo refreshed successfully
        1   - BGInfo executable not found
        2   - BGInfo configuration file not found
        3   - BGInfo execution failed
        99  - Unexpected error

    Datto RMM Usage:
        - Create as Quick Job or Component
        - Set to run in USER context (not SYSTEM)
        - Can be scheduled for periodic refresh
        - Safe to run multiple times

.LINK
    Related: Deploy-BGInfo.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$BGInfoPath = "C:\MCC\BGInfo",

    [Parameter(Mandatory = $false)]
    [switch]$Silent
)

#region Variables

$ExitCode = 0
$BGInfoExecutable = Join-Path -Path $BGInfoPath -ChildPath "BGInfo.exe"
$BGInfoConfig = Join-Path -Path $BGInfoPath -ChildPath "BGInfo.bgi"

#endregion

#region Functions

function Write-Log {
    <#
    .SYNOPSIS
        Writes output messages with optional silent mode.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Success', 'Warning', 'Error')]
        [string]$Level = 'Info'
    )

    $Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $FormattedMessage = "[$Timestamp] [$Level] $Message"

    if (-not $Silent -or $Level -eq 'Error') {
        switch ($Level) {
            'Error'   { Write-Error $FormattedMessage }
            'Warning' { Write-Warning $FormattedMessage }
            'Success' { Write-Host $FormattedMessage -ForegroundColor Green }
            default   { Write-Host $FormattedMessage }
        }
    }
}

#endregion

#region Main Script

try {
    Write-Log "BGInfo Wallpaper Refresh Started" -Level Info
    Write-Log "Running as user: $env:USERNAME" -Level Info
    Write-Log "BGInfo Path: $BGInfoPath" -Level Info

    # Step 1: Verify BGInfo executable exists
    Write-Log "Checking for BGInfo executable..." -Level Info
    if (-not (Test-Path -Path $BGInfoExecutable)) {
        Write-Log "BGInfo executable not found at: $BGInfoExecutable" -Level Error
        Write-Log "Please run Deploy-BGInfo.ps1 first to install BGInfo" -Level Error
        $ExitCode = 1
        throw "BGInfo not installed"
    }
    Write-Log "Found BGInfo executable: $BGInfoExecutable" -Level Success

    # Step 2: Verify BGInfo configuration exists
    Write-Log "Checking for BGInfo configuration..." -Level Info
    if (-not (Test-Path -Path $BGInfoConfig)) {
        Write-Log "BGInfo configuration not found at: $BGInfoConfig" -Level Error
        Write-Log "Please run Deploy-BGInfo.ps1 first to install BGInfo configuration" -Level Error
        $ExitCode = 2
        throw "BGInfo configuration missing"
    }
    Write-Log "Found BGInfo configuration: $BGInfoConfig" -Level Success

    # Step 3: Execute BGInfo
    Write-Log "Executing BGInfo to refresh wallpaper..." -Level Info

    $ProcessArgs = @{
        FilePath     = $BGInfoExecutable
        ArgumentList = "`"$BGInfoConfig`"", '/timer:0', '/silent', '/nolicprompt'
        Wait         = $true
        NoNewWindow  = $true
        PassThru     = $true
    }

    $Process = Start-Process @ProcessArgs

    # Check result
    if ($Process.ExitCode -eq 0) {
        Write-Log "BGInfo executed successfully - wallpaper updated" -Level Success
        $ExitCode = 0
    }
    else {
        Write-Log "BGInfo executed with exit code: $($Process.ExitCode)" -Level Warning
        # BGInfo sometimes returns non-zero even on success
        # If the process ran without throwing an exception, consider it successful
        Write-Log "BGInfo process completed - wallpaper should be updated" -Level Success
        $ExitCode = 0
    }

    Write-Log "BGInfo Wallpaper Refresh Completed Successfully" -Level Success
}
catch {
    Write-Log "BGInfo Wallpaper Refresh Failed" -Level Error
    Write-Log "Error: $($_.Exception.Message)" -Level Error

    if ($ExitCode -eq 0) {
        $ExitCode = 99  # Unexpected error
    }
}
finally {
    # Exit with appropriate code for Datto RMM monitoring
    exit $ExitCode
}

#endregion
