# Git Sync Quick Reference

## TL;DR - Just Sync Everything

```bash
cd /home/wferrel/ai
./git-sync.sh
```

That's it! Auto-commits and pushes all changes to GitHub.

---

## Common Commands

### Basic Usage
```bash
./git-sync.sh                           # Auto-generate message & push
./git-sync.sh "Your message here"       # Custom message & push
```

### Preview/Test
```bash
./git-sync.sh -d                        # Dry run (show what would happen)
./git-sync.sh -v                        # Show full git status
```

### Advanced
```bash
./git-sync.sh -s                        # Commit locally, don't push yet
./git-sync.sh -v "Custom message"       # Custom message with status
```

---

## Using Claude Code

Just type:
```
/git-sync
```

Or with a message:
```
/git-sync Added new customer profiles
```

---

## What It Does

1. ✅ Stages ALL changes (added, modified, deleted)
2. ✅ Creates a commit with auto-generated or custom message
3. ✅ Pushes to GitHub
4. ✅ Shows colored summary

---

## Auto-Generated Messages Look Like

- `Updates: 23 added, 1 modified, 37 deleted - 2024-12-09 10:51`
- `Updates: 5 modified - 2024-12-09 14:30`
- `Updates: 12 added - 2024-12-09 09:15`

---

## Troubleshooting

**Not in git repository?**
```bash
cd /home/wferrel/ai
```

**Want to see what changed?**
```bash
git status
```

**Made a mistake?**
```bash
git reset --soft HEAD~1  # Undo last commit, keep changes
```

---

## Full Documentation

See: `/home/wferrel/ai/powershell/Git-Sync-README.md`
