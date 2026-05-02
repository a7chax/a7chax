#!/usr/bin/env bash

# This script holds the list of your currently installed AI agent skills.
# You can run this on a new PC to sync your skills.

# List of skills to install. The skills.sh CLI installs a specific skill from a
# repository with:
#   npx skills add <repo> --skill <skill-name>
SKILLS=(
  "https://github.com/anthropics/skills|algorithmic-art"
  "https://github.com/juliusbrussee/caveman|caveman"
  "https://github.com/juliusbrussee/caveman|caveman-commit"
  "https://github.com/juliusbrussee/caveman|caveman-review"
  "https://github.com/anthropics/skills|claude-api"
  "https://github.com/juliusbrussee/caveman|compress"
  "https://github.com/rtk-ai/rtk|rtk-tdd"
  "https://github.com/vercel-labs/skills|find-skills"
  "https://github.com/anthropics/skills|frontend-design"
  "https://github.com/anthropics/skills|internal-comms"
  "https://github.com/forrestchang/andrej-karpathy-skills|karpathy-guidelines"
  "https://github.com/lightpanda-io/agent-skill|lightpanda"
  "https://github.com/anthropics/skills|skill-creator"
  "https://github.com/anthropics/skills|web-artifacts-builder"
  "https://github.com/anthropics/skills|webapp-testing"
)

echo "Syncing Agent Skills..."
echo "-----------------------"

failures=0

for entry in "${SKILLS[@]}"; do
  repo="${entry%%|*}"
  skill="${entry##*|}"
  echo "Installing skill: $skill ($repo)"

  if ! npx skills add "$repo" --skill "$skill" --global --agent codex --yes; then
    echo "Failed to install skill: $skill" >&2
    failures=$((failures + 1))
  fi
done

echo ""
if (( failures > 0 )); then
  echo "Done syncing skills with $failures failure(s)." >&2
  exit 1
fi

echo "Done syncing all skills!"
