#!/usr/bin/env bash

# This script holds the list of your currently installed AI agent skills.
# You can run this on a new PC to sync your skills.

# List of all skill names found in the skills folder
SKILLS=(
  "algorithmic-art"
  "android-cli"
  "caveman"
  "caveman-commit"
  "caveman-review"
  "claude-api"
  "compress"
  "find-skills"
  "frontend-design"
  "internal-comms"
  "karpathy-guidelines"
  "lightpanda"
  "skill-creator"
  "web-artifacts-builder"
  "webapp-testing"
)

echo "Syncing Agent Skills..."
echo "-----------------------"

for skill in "${SKILLS[@]}"; do
  echo "Installing skill: $skill"
  # Attempt to install the skill via npx skills
  npx skills install "$skill"
done

echo ""
echo "Done syncing all skills!"
