#!/usr/bin/env bash

# This script holds the list of your currently installed AI agent skills.
# You can run this on a new PC to sync your skills.

SKILLS_DIR="$HOME/.agents/skills"

# List of skills to install. The skills.sh CLI installs a specific skill from a
# repository with:
#   npx skills add <repo> --skill <skill-name>
SKILLS=(
  "https://github.com/anthropics/skills|algorithmic-art"
  "https://github.com/juliusbrussee/caveman|caveman"
  "https://github.com/juliusbrussee/caveman|caveman-commit"
  "https://github.com/juliusbrussee/caveman|caveman-review"
  "https://github.com/anthropics/skills|claude-api"
  "https://github.com/rtk-ai/rtk|code-simplifier"
  "https://github.com/juliusbrussee/caveman|compress"
  "https://github.com/rtk-ai/rtk|design-patterns"
  "https://github.com/rtk-ai/rtk|issue-triage"
  "https://github.com/rtk-ai/rtk|pr-triage"
  "https://github.com/rtk-ai/rtk|rtk-tdd"
  "https://github.com/rtk-ai/rtk|rtk-triage"
  "https://github.com/rtk-ai/rtk|tdd-rust"
  "https://github.com/vercel-labs/skills|find-skills"
  "https://github.com/anthropics/skills|frontend-design"
  "https://github.com/anthropics/skills|internal-comms"
  "https://github.com/forrestchang/andrej-karpathy-skills|karpathy-guidelines"
  "https://github.com/lightpanda-io/agent-skill|lightpanda"
  "https://github.com/anthropics/skills|skill-creator"
  "https://github.com/anthropics/skills|web-artifacts-builder"
  "https://github.com/anthropics/skills|webapp-testing"
)

# Repositories that are not available through skills.sh. These are cloned into
# a temporary directory under ~/.agents/skills, cleaned, then moved up into the
# shared skills directory.
MANUAL_REPOS=(
  "https://github.com/android/skills|android-skills-XXXXXX"
)

echo "Syncing Agent Skills..."
echo "-----------------------"
echo "Skills directory: $SKILLS_DIR"
echo ""

mkdir -p "$SKILLS_DIR"

failures=0

for entry in "${MANUAL_REPOS[@]}"; do
  repo="${entry%%|*}"
  prefix="${entry##*|}"
  checkout="$(mktemp -d "$SKILLS_DIR/$prefix")"
  echo "Syncing manual skill repo: $repo"

  if ! git clone "$repo" "$checkout"; then
    echo "Failed to clone manual skill repo: $repo" >&2
    failures=$((failures + 1))
    rm -rf "$checkout"
    continue
  fi

  rm -rf "$checkout/LICENSE.txt" "$checkout/README.md"
  for path in "$checkout"/*; do
    target="$SKILLS_DIR/${path##*/}"
    rm -rf "$target"
    mv "$path" "$SKILLS_DIR"/
  done
  rm -rf "$checkout"
done

for entry in "${SKILLS[@]}"; do
  repo="${entry%%|*}"
  skill="${entry##*|}"
  echo "Installing skill: $skill ($repo)"

  if ! npx skills add "$repo" --skill "$skill" --global --agent cline --yes; then
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
