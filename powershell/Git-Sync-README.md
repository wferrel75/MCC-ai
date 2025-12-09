# Git Repository Sync Tool

Automated git workflow tool for staging, committing, and pushing changes to GitHub.

## Quick Start

### Option 1: Bash Script (Linux/WSL - Recommended for this system)

```bash
# From the repository root
cd /home/wferrel/ai
./git-sync.sh

# With custom commit message
./git-sync.sh "Added new features"

# Show status before and after
./git-sync.sh -v "Updated documentation"

# Test without making changes (dry run)
./git-sync.sh -d

# Commit locally but don't push
./git-sync.sh -s
```

### Option 2: PowerShell Script (Windows Servers)

```powershell
# From anywhere in the repository
cd /home/wferrel/ai
./powershell/Sync-GitRepository.ps1

# With custom commit message
./powershell/Sync-GitRepository.ps1 -CommitMessage "Added new features"

# Show status before and after
./powershell/Sync-GitRepository.ps1 -ShowStatus

# Test without making changes
./powershell/Sync-GitRepository.ps1 -DryRun
```

### Option 3: Claude Code Slash Command

When using Claude Code in the `/home/wferrel/ai` directory:

```
/git-sync
```

Or with a custom message:

```
/git-sync Added customer profiles and reorganized scripts
```

Claude will run the sync script and show you the results.

### Option 4: Manual Git Commands

```bash
# Traditional git workflow
cd /home/wferrel/ai
git add -A
git commit -m "Your commit message"
git push origin main
```

## Bash Script Features (Linux/WSL)

The bash script (`git-sync.sh`) provides the same functionality as the PowerShell version but is optimized for Linux/WSL environments.

### Quick Examples

```bash
# Auto-generate commit message
./git-sync.sh

# Custom message
./git-sync.sh "Fixed authentication bug"

# Dry run (preview only)
./git-sync.sh -d

# Show status
./git-sync.sh -v

# Commit but don't push
./git-sync.sh -s "WIP: New feature"

# Custom message with status
./git-sync.sh -v "Reorganized PowerShell directory structure"
```

### Bash Script Options

| Option | Description | Example |
|--------|-------------|---------|
| (none) | Auto-generate commit message and push | `./git-sync.sh` |
| `"message"` | Use custom commit message | `./git-sync.sh "Fixed bug"` |
| `-d, --dry-run` | Preview without executing | `./git-sync.sh -d` |
| `-s, --skip-push` | Commit locally only | `./git-sync.sh -s` |
| `-v, --status` | Show git status before/after | `./git-sync.sh -v` |
| `-h, --help` | Display help message | `./git-sync.sh -h` |

## PowerShell Script Features (Windows)

### Auto-Generated Commit Messages

If you don't provide a commit message, the script analyzes your changes and creates a descriptive message:

**Example generated messages:**
- `"Updates: 15 added, 3 modified, 8 deleted - 2024-12-09 10:45"`
- `"Updates: 2 modified - 2024-12-09 14:30"`

### Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `-CommitMessage` | Custom commit message | `-CommitMessage "Fixed bugs"` |
| `-SkipPush` | Only commit locally, don't push | `-SkipPush` |
| `-ShowStatus` | Display git status before/after | `-ShowStatus` |
| `-DryRun` | Preview what would be done | `-DryRun` |

### Examples

#### Basic Usage (Auto-generated message)
```powershell
./powershell/Sync-GitRepository.ps1
```
Output:
```
========================================
Git Repository Sync
========================================

Repository: /home/wferrel/ai
Branch: main
Checking for changes...
Found 47 changes
Generated commit message: 'Updates: 23 added, 1 modified, 23 deleted - 2024-12-09 10:51'

Staging all changes...
Successfully staged all changes

Committing changes...
Successfully committed changes

Pushing to remote repository...
Successfully pushed to origin/main

========================================
Sync Complete!
========================================

Your changes have been committed and pushed to GitHub.
```

#### Custom Message
```powershell
./powershell/Sync-GitRepository.ps1 -CommitMessage "Reorganized PowerShell scripts into categories"
```

#### Preview Changes (Dry Run)
```powershell
./powershell/Sync-GitRepository.ps1 -DryRun
```
Shows what would be done without making any changes.

#### Commit Without Pushing
```powershell
./powershell/Sync-GitRepository.ps1 -SkipPush
```
Useful for batching multiple commits before pushing.

#### Verbose Output
```powershell
./powershell/Sync-GitRepository.ps1 -ShowStatus
```
Shows full git status before and after operations.

## Use Cases

### Daily Development Workflow
```powershell
# End of day - sync all changes
./powershell/Sync-GitRepository.ps1 -CommitMessage "Daily updates"
```

### After Major Changes
```powershell
# Preview first
./powershell/Sync-GitRepository.ps1 -DryRun

# Then sync with descriptive message
./powershell/Sync-GitRepository.ps1 -CommitMessage "Reorganized directory structure and updated documentation"
```

### Incremental Commits
```powershell
# Commit without pushing
./powershell/Sync-GitRepository.ps1 -SkipPush -CommitMessage "WIP: Working on new feature"

# Later, push all commits
git push origin main
```

### Quick Sync with Claude
When working with Claude Code:
```
/git-sync Quick updates to documentation
```

## Safety Features

1. **Repository Detection**: Verifies you're in a git repository before executing
2. **Clean Check**: Warns if there are no changes to commit
3. **Error Handling**: Provides clear error messages if operations fail
4. **Dry Run Mode**: Test commands without making changes
5. **Local Commit First**: Commits locally before pushing (can recover if push fails)

## Error Handling

### If Push Fails
The script commits locally first, so your changes are safe:
```
ERROR: Failed to push to remote
Changes are committed locally but not pushed.
You can manually push with: git push origin main
```

You can then:
1. Check your network connection
2. Verify GitHub credentials
3. Manually push when ready: `git push origin main`

### If Commit Fails
Check for:
- Merge conflicts
- Pre-commit hooks blocking the commit
- Invalid git configuration

### If Not in Git Repository
```
ERROR: Not in a git repository!
```
Make sure you're in `/home/wferrel/ai` or a subdirectory.

## Best Practices

### Good Commit Messages
- **Descriptive**: Explain what changed and why
- **Present tense**: "Add feature" not "Added feature"
- **Specific**: "Fix login bug" not "Fix stuff"

**Examples:**
```powershell
-CommitMessage "Add AD computer connectivity testing scripts with logging"
-CommitMessage "Reorganize PowerShell scripts into logical categories"
-CommitMessage "Update customer profiles with latest information"
-CommitMessage "Fix authentication issue in DattoRMM API script"
```

### When to Use Auto-Generated Messages
Auto-generated messages are fine for:
- Daily routine updates
- Multiple small changes
- Quick syncs

Use custom messages for:
- Significant features
- Bug fixes
- Major refactoring
- Team collaboration

### Workflow Recommendations

**End of Work Session:**
```powershell
./powershell/Sync-GitRepository.ps1 -ShowStatus
```

**Before Starting New Work:**
```bash
git pull origin main
```

**Regular Backups:**
```powershell
# Create a scheduled task or cron job
./powershell/Sync-GitRepository.ps1
```

## Integration with Claude Code

The `/git-sync` slash command makes it easy to sync from within Claude Code conversations:

1. **Quick sync**: `/git-sync`
2. **With message**: `/git-sync Updated customer documentation`
3. **Claude runs the script and confirms**: Shows output and confirms success

## Troubleshooting

### "Not in a git repository"
**Solution:** Navigate to `/home/wferrel/ai` first
```powershell
cd /home/wferrel/ai
./powershell/Sync-GitRepository.ps1
```

### "No changes to commit"
**Solution:** No action needed - repository is clean

### "Failed to push"
**Possible causes:**
1. No internet connection
2. GitHub authentication issues
3. Branch protection rules
4. Merge conflicts with remote

**Solution:**
```bash
# Check network
ping github.com

# Check remote
git remote -v

# Try manual push
git push origin main
```

### Script execution issues
**Solution:** Make sure script is executable:
```bash
chmod +x /home/wferrel/ai/powershell/Sync-GitRepository.ps1
```

## Advanced Usage

### Multiple Branches
```powershell
# Switch branch first
git checkout feature-branch

# Then sync
./powershell/Sync-GitRepository.ps1
```

### Amend Previous Commit
```bash
# Make your additional changes
git add -A
git commit --amend -m "Updated commit message"
git push --force origin main  # Use with caution!
```

### View Recent Commits
```bash
git log --oneline -10
```

### Undo Last Commit (Keep Changes)
```bash
git reset --soft HEAD~1
```

## Script Locations

**Bash Script (Linux/WSL):** `/home/wferrel/ai/git-sync.sh`

**PowerShell Script (Windows):** `/home/wferrel/ai/powershell/Sync-GitRepository.ps1`

**Claude Command:** `/home/wferrel/ai/.claude/commands/git-sync.md`

**Documentation:** `/home/wferrel/ai/powershell/Git-Sync-README.md`

## Requirements

### For Bash Script (Linux/WSL)
- Bash shell (4.0 or higher recommended)
- Git installed and configured
- GitHub repository with push access
- Valid git credentials configured

### For PowerShell Script (Windows)
- PowerShell 5.1 or higher (or PowerShell Core)
- Git installed and configured
- GitHub repository with push access
- Valid git credentials configured

## Version History

- **v1.0** (2024-12-09): Initial release
  - Auto-generated commit messages
  - Dry run mode
  - Status display
  - Error handling
  - Claude Code integration
