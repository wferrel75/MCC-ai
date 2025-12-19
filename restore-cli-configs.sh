#!/bin/bash

#####################################################
# CLI Configuration Restore Script
# Restores Claude and Gemini CLI configurations
#####################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS] BACKUP_FILE

Restore Claude and Gemini CLI configurations from backup.

ARGUMENTS:
    BACKUP_FILE            Path to the backup tar.gz file

OPTIONS:
    -b, --backup-existing  Backup existing configs before restoring
    -f, --force           Overwrite existing configs without prompting
    -h, --help            Show this help message

EXAMPLES:
    # Basic restore with confirmation
    $0 cli-configs-backup-20241211.tar.gz

    # Backup existing configs before restoring
    $0 --backup-existing backup.tar.gz

    # Force restore without prompts
    $0 --force backup.tar.gz
EOF
}

# Default values
BACKUP_EXISTING=false
FORCE=false
BACKUP_FILE=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--backup-existing)
            BACKUP_EXISTING=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        -*)
            print_color "$RED" "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            BACKUP_FILE="$1"
            shift
            ;;
    esac
done

# Validate backup file
if [ -z "$BACKUP_FILE" ]; then
    print_color "$RED" "✗ Error: Backup file not specified"
    echo
    show_usage
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    print_color "$RED" "✗ Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

print_color "$BLUE" "========================================"
print_color "$BLUE" "CLI Configuration Restore Tool"
print_color "$BLUE" "========================================"
echo

# Check what's in the backup
print_color "$BLUE" "Analyzing backup file..."
BACKUP_CONTENTS=$(tar -tzf "$BACKUP_FILE" 2>/dev/null | grep -E "^\.claude/|^\.gemini/|^\.config/claude/" | head -10)

if [ -z "$BACKUP_CONTENTS" ]; then
    print_color "$RED" "✗ Error: Backup file does not contain expected directories"
    exit 1
fi

print_color "$GREEN" "✓ Backup file validated"
echo

# Check for existing configurations
EXISTING_CONFIGS=()
if [ -d "$HOME/.claude" ]; then
    EXISTING_CONFIGS+=("~/.claude")
fi
if [ -d "$HOME/.config/claude" ]; then
    EXISTING_CONFIGS+=("~/.config/claude")
fi
if [ -d "$HOME/.gemini" ]; then
    EXISTING_CONFIGS+=("~/.gemini")
fi

# Handle existing configs
if [ ${#EXISTING_CONFIGS[@]} -gt 0 ]; then
    print_color "$YELLOW" "⚠ Warning: Found existing configurations:"
    for config in "${EXISTING_CONFIGS[@]}"; do
        echo "  • $config"
    done
    echo

    if [ "$BACKUP_EXISTING" = true ]; then
        EXISTING_BACKUP="cli-configs-existing-$(date +%Y%m%d-%H%M%S).tar.gz"
        print_color "$BLUE" "Backing up existing configs to $EXISTING_BACKUP..."

        cd "$HOME"
        DIRS_TO_BACKUP=()
        [ -d ".claude" ] && DIRS_TO_BACKUP+=(".claude")
        [ -d ".config/claude" ] && DIRS_TO_BACKUP+=(".config/claude")
        [ -d ".gemini" ] && DIRS_TO_BACKUP+=(".gemini")

        tar -czf "$HOME/$EXISTING_BACKUP" "${DIRS_TO_BACKUP[@]}" 2>/dev/null
        print_color "$GREEN" "✓ Existing configs backed up to ~/$EXISTING_BACKUP"
        echo
    fi

    if [ "$FORCE" = false ]; then
        print_color "$YELLOW" "This will overwrite your existing configurations."
        read -p "Continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_color "$YELLOW" "Restore cancelled."
            exit 0
        fi
    fi
fi

# Extract backup
print_color "$BLUE" "Restoring configurations..."
echo

cd "$HOME"
tar -xzf "$BACKUP_FILE" 2>/dev/null || {
    print_color "$RED" "✗ Restore failed!"
    exit 1
}

print_color "$GREEN" "✓ Files extracted successfully"
echo

# Fix permissions
print_color "$BLUE" "Setting correct permissions..."

if [ -d "$HOME/.claude" ]; then
    chmod 700 "$HOME/.claude"
    [ -f "$HOME/.claude/.credentials.json" ] && chmod 600 "$HOME/.claude/.credentials.json"
    [ -f "$HOME/.claude/settings.json" ] && chmod 644 "$HOME/.claude/settings.json"
    [ -f "$HOME/.claude/settings.local.json" ] && chmod 600 "$HOME/.claude/settings.local.json"
    print_color "$GREEN" "✓ Fixed permissions for ~/.claude"
fi

if [ -d "$HOME/.gemini" ]; then
    chmod 700 "$HOME/.gemini"
    [ -f "$HOME/.gemini/oauth_creds.json" ] && chmod 600 "$HOME/.gemini/oauth_creds.json"
    [ -f "$HOME/.gemini/settings.json" ] && chmod 644 "$HOME/.gemini/settings.json"
    print_color "$GREEN" "✓ Fixed permissions for ~/.gemini"
fi

if [ -d "$HOME/.config/claude" ]; then
    chmod 755 "$HOME/.config/claude"
    [ -f "$HOME/.config/claude/config.json" ] && chmod 600 "$HOME/.config/claude/config.json"
    print_color "$GREEN" "✓ Fixed permissions for ~/.config/claude"
fi

echo
print_color "$BLUE" "========================================"
print_color "$BLUE" "Restore Complete!"
print_color "$BLUE" "========================================"
echo

print_color "$GREEN" "Restored configurations:"
[ -d "$HOME/.claude" ] && echo "  ✓ Claude CLI (~/.claude)"
[ -d "$HOME/.config/claude" ] && echo "  ✓ Claude config (~/.config/claude)"
[ -d "$HOME/.gemini" ] && echo "  ✓ Gemini CLI (~/.gemini)"

echo
print_color "$BLUE" "========================================"
print_color "$BLUE" "Next Steps"
print_color "$BLUE" "========================================"
echo

print_color "$GREEN" "Test your configurations:"
echo "  • Claude: Run 'claude' or 'claude --version'"
echo "  • Gemini: Run 'gemini' or 'gemini --version'"
echo

if [ "$BACKUP_EXISTING" = true ]; then
    print_color "$YELLOW" "Your previous configs were backed up to:"
    echo "  ~/$EXISTING_BACKUP"
    echo
fi

print_color "$GREEN" "All done! Your CLI configurations have been restored."
echo
