#!/bin/bash
#
# Git Repository Sync Script
# Automates staging, committing, and pushing changes to GitHub
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables
COMMIT_MESSAGE=""
SKIP_PUSH=false
SHOW_STATUS=false
DRY_RUN=false

# Functions
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    print_color "$CYAN" "\n========================================"
    print_color "$CYAN" "$1"
    print_color "$CYAN" "========================================\n"
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS] [commit-message]

Automate git staging, committing, and pushing to GitHub.

OPTIONS:
    -s, --skip-push     Commit locally but don't push to remote
    -v, --status        Show git status before and after
    -d, --dry-run       Preview what would be done without executing
    -h, --help          Show this help message

EXAMPLES:
    $0                                  # Auto-generate commit message
    $0 "Added new features"             # Use custom message
    $0 -d                               # Dry run
    $0 -v "Updated docs"                # Show status with custom message
    $0 -s                               # Commit only, don't push

EOF
}

generate_commit_message() {
    # Get change statistics (redirect print to stderr to keep function output clean)
    print_color "$CYAN" "Analyzing changes to generate commit message..." >&2

    local added=$(git status --porcelain | grep -c "^??" || true)
    local modified=$(git status --porcelain | grep -c "^ M\|^M " || true)
    local deleted=$(git status --porcelain | grep -c "^ D\|^D " || true)
    local renamed=$(git status --porcelain | grep -c "^R " || true)

    local changes=()
    [[ $added -gt 0 ]] && changes+=("$added added")
    [[ $modified -gt 0 ]] && changes+=("$modified modified")
    [[ $deleted -gt 0 ]] && changes+=("$deleted deleted")
    [[ $renamed -gt 0 ]] && changes+=("$renamed renamed")

    if [[ ${#changes[@]} -eq 0 ]]; then
        echo "Update repository"
        return
    fi

    local changes_summary=$(IFS=", "; echo "${changes[*]}")
    local timestamp=$(date "+%Y-%m-%d %H:%M")

    echo "Updates: $changes_summary - $timestamp"
}

show_git_status() {
    print_header "Git Repository Status"
    git status
    print_color "$CYAN" "\n========================================"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--skip-push)
            SKIP_PUSH=true
            shift
            ;;
        -v|--status)
            SHOW_STATUS=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
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
            COMMIT_MESSAGE="$*"
            break
            ;;
    esac
done

# Main execution
print_header "Git Repository Sync"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_color "$RED" "ERROR: Not in a git repository!"
    exit 1
fi

GIT_ROOT=$(git rev-parse --show-toplevel)
CURRENT_BRANCH=$(git branch --show-current)

print_color "$GREEN" "Repository: $GIT_ROOT"
print_color "$GREEN" "Branch: $CURRENT_BRANCH"

# Show initial status if requested
if [[ "$SHOW_STATUS" == true ]]; then
    show_git_status
fi

# Check for changes
print_color "$CYAN" "\nChecking for changes..."
if [[ -z $(git status --porcelain) ]]; then
    print_color "$YELLOW" "No changes to commit. Repository is clean."
    exit 0
fi

# Count changes
CHANGE_COUNT=$(git status --porcelain | wc -l)
print_color "$GREEN" "Found $CHANGE_COUNT changes"

# Generate or use provided commit message
if [[ -z "$COMMIT_MESSAGE" ]]; then
    COMMIT_MESSAGE=$(generate_commit_message)
    print_color "$YELLOW" "Generated commit message: '$COMMIT_MESSAGE'"
else
    print_color "$YELLOW" "Using provided commit message: '$COMMIT_MESSAGE'"
fi

# Dry run mode
if [[ "$DRY_RUN" == true ]]; then
    print_color "$YELLOW" "\n[DRY RUN MODE - No changes will be made]"
    print_color "$YELLOW" "\nWould execute:"
    echo "  1. git add -A"
    echo "  2. git commit -m \"$COMMIT_MESSAGE\""
    if [[ "$SKIP_PUSH" == false ]]; then
        echo "  3. git push origin $CURRENT_BRANCH"
    fi

    print_color "$CYAN" "\nChanges that would be committed:"
    git status --short
    exit 0
fi

# Stage all changes
print_color "$CYAN" "\nStaging all changes..."
if git add -A; then
    print_color "$GREEN" "Successfully staged all changes"
else
    print_color "$RED" "ERROR: Failed to stage changes"
    exit 1
fi

# Commit changes
print_color "$CYAN" "\nCommitting changes..."
if git commit -m "$COMMIT_MESSAGE"; then
    print_color "$GREEN" "Successfully committed changes"
else
    print_color "$RED" "ERROR: Failed to commit changes"
    exit 1
fi

# Push to remote (unless skipped)
if [[ "$SKIP_PUSH" == false ]]; then
    print_color "$CYAN" "\nPushing to remote repository..."
    if git push origin "$CURRENT_BRANCH"; then
        print_color "$GREEN" "Successfully pushed to origin/$CURRENT_BRANCH"
    else
        print_color "$RED" "ERROR: Failed to push to remote"
        print_color "$YELLOW" "Changes are committed locally but not pushed."
        print_color "$YELLOW" "You can manually push with: git push origin $CURRENT_BRANCH"
        exit 1
    fi
else
    print_color "$YELLOW" "\nSkipping push to remote (--skip-push specified)"
fi

# Show final status if requested
if [[ "$SHOW_STATUS" == true ]]; then
    show_git_status
fi

# Success message
print_header "Sync Complete!"

if [[ "$SKIP_PUSH" == false ]]; then
    print_color "$GREEN" "Your changes have been committed and pushed to GitHub."
else
    print_color "$GREEN" "Your changes have been committed locally."
    print_color "$YELLOW" "Run without --skip-push to push to GitHub."
fi
