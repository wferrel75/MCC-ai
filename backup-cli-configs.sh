#!/bin/bash

#####################################################
# CLI Configuration Backup Script
# Backs up Claude and Gemini CLI configurations
#####################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# Default values
BACKUP_NAME="cli-configs-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
BACKUP_DIR="$HOME"
INCLUDE_HISTORY=true
INCLUDE_CACHE=false

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Backup Claude and Gemini CLI configurations.

OPTIONS:
    -o, --output PATH       Output file path (default: ~/$BACKUP_NAME)
    -n, --no-history       Exclude chat history (reduces size significantly)
    -c, --include-cache    Include cache/debug files (makes backup larger)
    -h, --help             Show this help message

EXAMPLES:
    # Basic backup with default settings
    $0

    # Backup without history to save space
    $0 --no-history

    # Custom output location
    $0 -o /path/to/backup.tar.gz

    # Minimal backup (no history, no cache)
    $0 --no-history
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            BACKUP_NAME="$2"
            BACKUP_DIR=$(dirname "$2")
            BACKUP_NAME=$(basename "$2")
            shift 2
            ;;
        -n|--no-history)
            INCLUDE_HISTORY=false
            shift
            ;;
        -c|--include-cache)
            INCLUDE_CACHE=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_color "$RED" "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if configs exist
print_color "$BLUE" "========================================"
print_color "$BLUE" "CLI Configuration Backup Tool"
print_color "$BLUE" "========================================"
echo

DIRS_TO_BACKUP=()
EXCLUDE_PATTERNS=()

# Check for Claude
if [ -d "$HOME/.claude" ]; then
    print_color "$GREEN" "✓ Found Claude CLI config at ~/.claude"
    DIRS_TO_BACKUP+=(".claude")
else
    print_color "$YELLOW" "⚠ Claude CLI config not found at ~/.claude"
fi

if [ -d "$HOME/.config/claude" ]; then
    print_color "$GREEN" "✓ Found Claude config at ~/.config/claude"
    DIRS_TO_BACKUP+=(".config/claude")
else
    print_color "$YELLOW" "⚠ Claude config not found at ~/.config/claude"
fi

# Check for Gemini
if [ -d "$HOME/.gemini" ]; then
    print_color "$GREEN" "✓ Found Gemini CLI config at ~/.gemini"
    DIRS_TO_BACKUP+=(".gemini")
else
    print_color "$YELLOW" "⚠ Gemini CLI config not found at ~/.gemini"
fi

# Exit if nothing to backup
if [ ${#DIRS_TO_BACKUP[@]} -eq 0 ]; then
    print_color "$RED" "✗ No CLI configurations found to backup!"
    exit 1
fi

echo

# Build exclude patterns
if [ "$INCLUDE_HISTORY" = false ]; then
    print_color "$YELLOW" "Excluding chat history..."
    EXCLUDE_PATTERNS+=(
        --exclude='.claude/history.jsonl'
        --exclude='.claude/file-history'
        --exclude='.claude/debug'
    )
fi

if [ "$INCLUDE_CACHE" = false ]; then
    print_color "$YELLOW" "Excluding cache and temporary files..."
    EXCLUDE_PATTERNS+=(
        --exclude='.claude/telemetry'
        --exclude='.claude/shell-snapshots'
        --exclude='.claude/statsig'
        --exclude='.gemini/tmp'
    )
fi

# Create backup
FULL_BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

print_color "$BLUE" "Creating backup..."
print_color "$BLUE" "Output: $FULL_BACKUP_PATH"
echo

cd "$HOME"

# Create tar archive
tar -czf "$FULL_BACKUP_PATH" \
    --warning=no-file-changed \
    "${EXCLUDE_PATTERNS[@]}" \
    "${DIRS_TO_BACKUP[@]}" \
    2>&1 | grep -v "file changed as we read it" || true

# Verify backup was created
if [ ! -f "$FULL_BACKUP_PATH" ]; then
    print_color "$RED" "✗ Backup failed! File was not created."
    exit 1
fi

# Get backup size
BACKUP_SIZE=$(du -h "$FULL_BACKUP_PATH" | cut -f1)

print_color "$GREEN" "✓ Backup created successfully!"
echo
print_color "$BLUE" "========================================"
print_color "$BLUE" "Backup Summary"
print_color "$BLUE" "========================================"
echo
print_color "$GREEN" "Location: $FULL_BACKUP_PATH"
print_color "$GREEN" "Size: $BACKUP_SIZE"
echo
print_color "$BLUE" "Backed up directories:"
for dir in "${DIRS_TO_BACKUP[@]}"; do
    echo "  • ~/$dir"
done
echo

if [ "$INCLUDE_HISTORY" = false ]; then
    print_color "$YELLOW" "Note: Chat history was excluded to reduce size"
fi

echo
print_color "$BLUE" "========================================"
print_color "$BLUE" "Next Steps"
print_color "$BLUE" "========================================"
echo
print_color "$GREEN" "Transfer to new system:"
echo "  • USB: Copy to USB drive"
echo "  • SCP: scp $FULL_BACKUP_PATH user@new-system:~/"
echo "  • Cloud: Upload to Dropbox/OneDrive/Google Drive"
echo
print_color "$GREEN" "Then run the restore script on the new system:"
echo "  ./restore-cli-configs.sh $BACKUP_NAME"
echo
