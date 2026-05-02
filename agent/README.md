# Agent Skill Sync

This repository contains `sync-skills.sh`, a small script for reinstalling the same agent skills on another machine.

The skills are sourced from the open agent skills directory at:

- https://skills.sh

Use the skills.sh search URL to find source repositories and skill names. For example, the RTK skills in this script come from:

- https://skills.sh/?q=rtk-ai

Each entry in `sync-skills.sh` is stored as:

```text
<github-repository-url>|<skill-name>
```

The script creates `~/.agents/skills` when needed, then installs each entry globally into that shared agent skills location. It uses the skills CLI target whose global path is `~/.agents/skills`:

```bash
npx skills add <github-repository-url> --skill <skill-name> --global --agent cline --yes
```

To sync skills:

```bash
./sync-skills.sh
```
