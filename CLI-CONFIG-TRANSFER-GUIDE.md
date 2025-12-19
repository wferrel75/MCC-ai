# CLI Configuration Transfer Guide

Quick guide for backing up and restoring Claude and Gemini CLI configurations between systems.

## Quick Start

### On Your Current System (Source)

```bash
# Basic backup (includes history)
./backup-cli-configs.sh

# Recommended: Backup without history (much smaller)
./backup-cli-configs.sh --no-history

# Custom output location
./backup-cli-configs.sh -o ~/Documents/my-backup.tar.gz
```

### Transfer the Backup File

Choose one method:

**USB Drive:**
```bash
cp ~/cli-configs-backup-*.tar.gz /media/usb/
```

**SCP (over network):**
```bash
scp ~/cli-configs-backup-*.tar.gz user@new-computer:~/
```

**Cloud Storage:**
- Upload to Dropbox, Google Drive, or OneDrive
- Download on new system

### On Your New System (Destination)

```bash
# Copy both scripts to the new system
# Then run restore:

# Basic restore (will prompt for confirmation)
./restore-cli-configs.sh cli-configs-backup-20241211-220800.tar.gz

# Backup existing configs first, then restore
./restore-cli-configs.sh --backup-existing backup.tar.gz

# Force restore without prompts
./restore-cli-configs.sh --force backup.tar.gz
```

## What Gets Backed Up

### Claude CLI (`~/.claude/`)
- ✅ API credentials
- ✅ Settings (global and local)
- ✅ Custom agents
- ✅ Plugins
- ✅ Projects
- ✅ Chat history (optional)
- ❌ Cache/debug files (excluded by default)

### Claude Config (`~/.config/claude/`)
- ✅ Configuration files

### Gemini CLI (`~/.gemini/`)
- ✅ OAuth credentials
- ✅ Settings
- ✅ Google account info
- ❌ Temp files (excluded by default)

## Backup Options

### `backup-cli-configs.sh` Options

| Option | Description |
|--------|-------------|
| `-o, --output PATH` | Custom output path |
| `-n, --no-history` | Exclude chat history (recommended for smaller backups) |
| `-c, --include-cache` | Include cache/debug files (makes backup larger) |
| `-h, --help` | Show help |

### Examples

```bash
# Minimal backup (no history, no cache) - smallest file
./backup-cli-configs.sh --no-history

# Full backup with everything
./backup-cli-configs.sh --include-cache

# Backup to specific location
./backup-cli-configs.sh -o /path/to/backup.tar.gz --no-history
```

## Restore Options

### `restore-cli-configs.sh` Options

| Option | Description |
|--------|-------------|
| `-b, --backup-existing` | Backup current configs before overwriting |
| `-f, --force` | Skip confirmation prompts |
| `-h, --help` | Show help |

### Examples

```bash
# Safe restore (backs up existing first)
./restore-cli-configs.sh --backup-existing backup.tar.gz

# Quick restore with no prompts
./restore-cli-configs.sh --force backup.tar.gz

# Normal restore (will ask for confirmation if configs exist)
./restore-cli-configs.sh backup.tar.gz
```

## File Sizes

**With History:**
- Typical size: 50-200 MB (depends on usage)

**Without History (`--no-history`):**
- Typical size: 1-10 MB
- **Recommended for transfers**

## Security Notes

1. **Backup files contain sensitive credentials!**
   - Claude API keys
   - Gemini OAuth tokens
   - Keep backup files secure
   - Delete after successful transfer

2. **Permissions are automatically fixed:**
   - Credential files: `600` (owner read/write only)
   - Config directories: `700` or `755`

3. **Recommended workflow:**
   ```bash
   # Create backup
   ./backup-cli-configs.sh --no-history

   # Transfer securely (use SCP or encrypted USB)
   scp backup.tar.gz user@new-system:~/

   # Restore on new system
   ./restore-cli-configs.sh backup.tar.gz

   # Delete backup file when done
   rm backup.tar.gz
   ```

## Troubleshooting

### "No CLI configurations found to backup"
- Neither Claude nor Gemini configs exist
- Check if they're installed: `which claude` or `which gemini`

### "Backup file does not contain expected directories"
- Corrupted backup file
- Try creating a new backup

### Permission Denied
- Run: `chmod +x backup-cli-configs.sh restore-cli-configs.sh`
- Or use: `bash backup-cli-configs.sh`

### Configs not working after restore
1. Verify permissions were set correctly
2. Try re-authenticating:
   - Claude: May need to run `claude` and re-authenticate
   - Gemini: May need to run `gemini auth login`

## Transfer to WSL

If moving from/to Windows Subsystem for Linux:

```bash
# From Windows to WSL
cp /mnt/c/Users/YourName/backup.tar.gz ~/
./restore-cli-configs.sh backup.tar.gz

# From WSL to Windows
./backup-cli-configs.sh -o /mnt/c/Users/YourName/backup.tar.gz
```

## Multiple Systems Setup

To sync configs across multiple machines:

1. Create backup on primary system
2. Keep backup in cloud storage (Dropbox, Google Drive)
3. Restore on each additional system
4. Update backup periodically to sync new settings

---

**Location of scripts:** `/home/wferrel/ai/`

**Created:** 2024-12-11
