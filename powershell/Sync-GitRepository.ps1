<#
.SYNOPSIS
    Stages, commits, and pushes local git changes to GitHub.

.DESCRIPTION
    Automates the git workflow by staging all changes (including deletions),
    creating a commit with a meaningful message, and pushing to the remote repository.

.PARAMETER CommitMessage
    Custom commit message. If not provided, generates a descriptive message based on changes.

.PARAMETER SkipPush
    Only stage and commit changes without pushing to remote.

.PARAMETER ShowStatus
    Display git status before and after operations.

.PARAMETER DryRun
    Show what would be done without actually executing git commands.

.EXAMPLE
    .\Sync-GitRepository.ps1

.EXAMPLE
    .\Sync-GitRepository.ps1 -CommitMessage "Added new customer profiles"

.EXAMPLE
    .\Sync-GitRepository.ps1 -SkipPush -ShowStatus

.EXAMPLE
    .\Sync-GitRepository.ps1 -DryRun
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$CommitMessage,

    [Parameter(Mandatory=$false)]
    [switch]$SkipPush,

    [Parameter(Mandatory=$false)]
    [switch]$ShowStatus,

    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Get-GitRoot {
    try {
        $gitRoot = git rev-parse --show-toplevel 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $gitRoot
        }
    }
    catch {
        return $null
    }
    return $null
}

function Get-AutoCommitMessage {
    Write-ColorOutput "Analyzing changes to generate commit message..." -Color Cyan

    # Get statistics
    $status = git status --porcelain
    $lines = $status -split "`n" | Where-Object { $_ -ne "" }

    $added = ($lines | Where-Object { $_ -match "^\?\?" }).Count
    $modified = ($lines | Where-Object { $_ -match "^ M" -or $_ -match "^M " }).Count
    $deleted = ($lines | Where-Object { $_ -match "^ D" -or $_ -match "^D " }).Count
    $renamed = ($lines | Where-Object { $_ -match "^R " }).Count

    $changes = @()
    if ($added -gt 0) { $changes += "$added added" }
    if ($modified -gt 0) { $changes += "$modified modified" }
    if ($deleted -gt 0) { $changes += "$deleted deleted" }
    if ($renamed -gt 0) { $changes += "$renamed renamed" }

    if ($changes.Count -eq 0) {
        return "Update repository"
    }

    $changesSummary = $changes -join ", "
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

    return "Updates: $changesSummary - $timestamp"
}

function Show-GitStatus {
    Write-ColorOutput "`n========================================" -Color Cyan
    Write-ColorOutput "Git Repository Status" -Color Cyan
    Write-ColorOutput "========================================" -Color Cyan

    git status

    Write-ColorOutput "`n========================================" -Color Cyan
}

# Main execution
Write-ColorOutput "`n========================================" -Color Cyan
Write-ColorOutput "Git Repository Sync" -Color Cyan
Write-ColorOutput "========================================`n" -Color Cyan

# Check if we're in a git repository
$gitRoot = Get-GitRoot
if (-not $gitRoot) {
    Write-ColorOutput "ERROR: Not in a git repository!" -Color Red
    exit 1
}

Write-ColorOutput "Repository: $gitRoot" -Color Green
Write-ColorOutput "Branch: $(git branch --show-current)" -Color Green

# Show initial status if requested
if ($ShowStatus) {
    Show-GitStatus
}

# Check if there are changes to commit
Write-ColorOutput "`nChecking for changes..." -Color Cyan
$statusOutput = git status --porcelain

if ([string]::IsNullOrWhiteSpace($statusOutput)) {
    Write-ColorOutput "No changes to commit. Repository is clean." -Color Yellow
    exit 0
}

# Count changes
$changes = $statusOutput -split "`n" | Where-Object { $_ -ne "" }
Write-ColorOutput "Found $($changes.Count) changes" -Color Green

# Generate or use provided commit message
if ([string]::IsNullOrWhiteSpace($CommitMessage)) {
    $CommitMessage = Get-AutoCommitMessage
    Write-ColorOutput "Generated commit message: '$CommitMessage'" -Color Yellow
} else {
    Write-ColorOutput "Using provided commit message: '$CommitMessage'" -Color Yellow
}

if ($DryRun) {
    Write-ColorOutput "`n[DRY RUN MODE - No changes will be made]" -Color Magenta
    Write-ColorOutput "`nWould execute:" -Color Yellow
    Write-ColorOutput "  1. git add -A" -Color White
    Write-ColorOutput "  2. git commit -m `"$CommitMessage`"" -Color White
    if (-not $SkipPush) {
        Write-ColorOutput "  3. git push" -Color White
    }

    Write-ColorOutput "`nChanges that would be committed:" -Color Cyan
    git status --short
    exit 0
}

# Stage all changes
Write-ColorOutput "`nStaging all changes..." -Color Cyan
try {
    git add -A
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "ERROR: Failed to stage changes" -Color Red
        exit 1
    }
    Write-ColorOutput "Successfully staged all changes" -Color Green
}
catch {
    Write-ColorOutput "ERROR: Exception while staging changes: $_" -Color Red
    exit 1
}

# Commit changes
Write-ColorOutput "`nCommitting changes..." -Color Cyan
try {
    git commit -m $CommitMessage
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "ERROR: Failed to commit changes" -Color Red
        exit 1
    }
    Write-ColorOutput "Successfully committed changes" -Color Green
}
catch {
    Write-ColorOutput "ERROR: Exception while committing: $_" -Color Red
    exit 1
}

# Push to remote (unless skipped)
if (-not $SkipPush) {
    Write-ColorOutput "`nPushing to remote repository..." -Color Cyan
    try {
        $currentBranch = git branch --show-current
        git push origin $currentBranch
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "ERROR: Failed to push to remote" -Color Red
            Write-ColorOutput "Changes are committed locally but not pushed." -Color Yellow
            Write-ColorOutput "You can manually push with: git push origin $currentBranch" -Color Yellow
            exit 1
        }
        Write-ColorOutput "Successfully pushed to origin/$currentBranch" -Color Green
    }
    catch {
        Write-ColorOutput "ERROR: Exception while pushing: $_" -Color Red
        exit 1
    }
} else {
    Write-ColorOutput "`nSkipping push to remote (--SkipPush specified)" -Color Yellow
}

# Show final status if requested
if ($ShowStatus) {
    Show-GitStatus
}

Write-ColorOutput "`n========================================" -Color Cyan
Write-ColorOutput "Sync Complete!" -Color Green
Write-ColorOutput "========================================" -Color Cyan

if (-not $SkipPush) {
    Write-ColorOutput "`nYour changes have been committed and pushed to GitHub." -Color Green
} else {
    Write-ColorOutput "`nYour changes have been committed locally." -Color Green
    Write-ColorOutput "Run without -SkipPush to push to GitHub." -Color Yellow
}
