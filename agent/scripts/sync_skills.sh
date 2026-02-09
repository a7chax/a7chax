#!/usr/bin/env bash

# sync_skills.sh - Automates the synchronization of agent skills
# Links skills from multiple repositories to Opencode, Gemini, and Cursor.

set -e

# Configuration
BASE_DIR="/mnt/personaldata"

# Define repositories to sync: "DIR_NAME|REPO_URL|SOURCE_SUBDIR"
REPOS=(
    "antrophics-skills|git@github.com:anthropics/skills.git|skills"
    "vercel-agent-skills|git@github.com:vercel-labs/agent-skills.git|."
    "openai-skills|org-14957082@github.com:openai/skills.git|."
)

TARGETS=(
    "$HOME/.config/opencode/skills"
    "$HOME/.gemini/antigravity/skills"
    "$HOME/.cursor/skills"
)

echo "--- Starting Agent Skills Sync ---"

# 1. Ensure Repositories are up to date
for repo_info in "${REPOS[@]}"; do
    IFS="|" read -r dir_name repo_url subdir <<< "$repo_info"
    repo_path="$BASE_DIR/$dir_name"
    
    if [ ! -d "$repo_path" ]; then
        echo "Cloning $dir_name..."
        git clone "$repo_url" "$repo_path"
    else
        echo "Updating $dir_name..."
        # Try main then master
        git -C "$repo_path" pull origin main 2>/dev/null || git -C "$repo_path" pull origin master 2>/dev/null || echo "Warning: Could not pull updates for $dir_name"
    fi
done

# 2. Process Targets
for target in "${TARGETS[@]}"; do
    echo "Processing target: $target..."
    mkdir -p "$(dirname "$target")"
    
    # Clean up existing directory/link to ensure a fresh sync
    if [ -L "$target" ] || [ -d "$target" ]; then
        rm -rf "$target"
    fi
    mkdir -p "$target"
    
    # 3. Link skills from each repository
    for repo_info in "${REPOS[@]}"; do
        IFS="|" read -r dir_name repo_url subdir <<< "$repo_info"
        source_dir="$BASE_DIR/$dir_name/$subdir"
        
        if [ -d "$source_dir" ]; then
            echo "  Linking skills from $dir_name..."
            # Use find to avoid issues with empty directories or hidden files
            # Linking directories/files within the source_dir
            for item in "$source_dir"/*; do
                [ -e "$item" ] || continue # Handle empty glob
                item_name=$(basename "$item")
                # Avoid linking .git or other hidden system files if at root
                [[ "$item_name" == .git* ]] && continue
                
                ln -sf "$item" "$target/$item_name"
            done
        else
            echo "  Warning: Source directory $source_dir not found, skipping."
        fi
    done
    
    echo "Successfully linked skills to $target (Total: $(ls -1 "$target" | wc -l))"
done

echo "--- Sync Complete ---"
