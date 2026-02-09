# Agent Skills Management

This repository manages the synchronization of specialized agent skills (linked from `antrophics-skills`) into your various AI development environments.

## Overview

The setup links skill modules from multiple sources into three primary locations:
1. `~/.config/opencode/skills/`
2. `~/.gemini/antigravity/skills/`
3. `~/.cursor/skills/`

### Managed Repositories
- **Anthropic Skills**: `git@github.com:anthropics/skills.git`
- **Vercel Agent Skills**: `git@github.com:vercel-labs/agent-skills.git`
- **OpenAI Skills**: `org-14957082@github.com:openai/skills.git`

## Automated Sync

Use the provided script to ensure the skills repository is up to date and all symbolic links are correctly pointed to the `/mnt/personaldata` mount.

### How to Run

```bash
# From the root of your dotfiles
bash ./agent/scripts/sync_skills.sh
```

### What the script does:
- **Repository Management**: Checks if `antrophics-skills` exists in `/mnt/personaldata`. Clones it if missing, or pulls the latest changes if present.
- **Atomic Linking**: Cleans up existing directories or stale links in the target config folders and replaces them with fresh symbolic links to the source repository.
- **Environment Support**: Ensures directories for Opencode, Gemini, and Cursor are created if they don't exist.

## Manual Configuration

If you prefer to link a specific skill manually:

```bash
ln -sf /mnt/personaldata/antrophics-skills/skills/brand-guidelines ~/.cursor/skills/brand-guidelines
```

## Troubleshooting

- **Permission Denied**: Ensure the script is executable: `chmod +x scripts/sync_skills.sh`.
- **Path Mismatch**: The script assumes the root path is `/mnt/personaldata`. If you move your project storage, update the `BASE_DIR` variable in the script.
