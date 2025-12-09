---
description: Commit and push all changes to GitHub with an auto-generated or custom message
argument-hint: "[commit message]"
---

Please run the git sync script to commit and push all changes:

1. Navigate to the ai repository root: `cd /home/wferrel/ai`
2. Run the git-sync.sh script with the appropriate arguments
3. If an argument was provided, pass it as the commit message: `./git-sync.sh "commit message here"`
4. If no argument was provided, run without arguments to auto-generate: `./git-sync.sh`
5. Show the complete output and confirm when the sync is complete

The script will:
- Stage all changes (added, modified, deleted files)
- Create a commit with a descriptive message
- Push to GitHub
- Show a colored summary of what was synced

Available options:
- `-d` or `--dry-run`: Preview changes without executing
- `-s` or `--skip-push`: Commit locally but don't push
- `-v` or `--status`: Show git status before and after
