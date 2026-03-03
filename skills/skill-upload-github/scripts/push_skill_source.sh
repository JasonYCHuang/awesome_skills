#!/usr/bin/env bash
set -euo pipefail

# Upload a skill folder (SKILL.md + scripts/references/assets) to a GitHub repo
# Usage:
#   REPO_URL=... LOCAL_DIR=... SKILL_DIR=... DEST_ROOT=skills \
#   push_skill_source.sh

REPO_URL=${REPO_URL:?"REPO_URL is required"}
LOCAL_DIR=${LOCAL_DIR:?"LOCAL_DIR is required"}
SKILL_DIR=${SKILL_DIR:?"SKILL_DIR is required"}
DEST_ROOT=${DEST_ROOT:-skills}

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
repo_dir=$(REPO_URL="$REPO_URL" LOCAL_DIR="$LOCAL_DIR" "$SCRIPT_DIR/skill_repo_prepare.sh" 2>/dev/null | tail -n1)

skill_name=$(basename "$SKILL_DIR")

dest="$repo_dir/$DEST_ROOT/$skill_name"

# Clean existing destination
rm -rf "$dest"
mkdir -p "$dest"

# Copy skill contents
cp "$SKILL_DIR/SKILL.md" "$dest/SKILL.md"

for sub in scripts references assets; do
  if [ -d "$SKILL_DIR/$sub" ]; then
    mkdir -p "$dest/$sub"
    cp -R "$SKILL_DIR/$sub/"* "$dest/$sub/" 2>/dev/null || true
  fi
done

(
  cd "$repo_dir"
  git add -A
  if git diff --cached --quiet; then
    echo "No changes to commit."
    exit 0
  fi
  git commit -m "Update skill: $skill_name"
  if [ -n "${GITHUB_TOKEN:-}" ]; then token="$GITHUB_TOKEN"; else token="$github_token"; fi
  GIT_TERMINAL_PROMPT=0 git -c url."https://x-access-token:${token}@github.com/".insteadOf="https://github.com/" push origin HEAD
)

echo "Pushed $skill_name to $REPO_URL at $DEST_ROOT/$skill_name"
