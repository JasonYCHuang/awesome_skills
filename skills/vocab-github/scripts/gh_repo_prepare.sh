#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   REPO_URL=... LOCAL_DIR=... GITHUB_TOKEN=... gh_repo_prepare.sh

repo_url=${REPO_URL:?"REPO_URL is required"}
local_dir=${LOCAL_DIR:?"LOCAL_DIR is required"}

# Use GITHUB_TOKEN (preferred) or github_token (fallback)
if [ -n "${GITHUB_TOKEN:-}" ]; then
  token="$GITHUB_TOKEN"
elif [ -n "${github_token:-}" ]; then
  token="$github_token"
else
  echo "Missing GITHUB_TOKEN (or github_token) env" >&2
  exit 1
fi

auth_url="https://x-access-token:${token}@github.com/${repo_url#https://github.com/}"

mkdir -p "$(dirname "$local_dir")"

if [ ! -d "$local_dir/.git" ]; then
  GIT_TERMINAL_PROMPT=0 git clone "$auth_url" "$local_dir"
  (
    cd "$local_dir"
    git remote set-url origin "$repo_url"
  )
else
  (
    cd "$local_dir"
    GIT_TERMINAL_PROMPT=0 git -c url."https://x-access-token:${token}@github.com/".insteadOf="https://github.com/" fetch --all --prune
    if git show-ref --verify --quiet refs/remotes/origin/main; then
      git reset --hard origin/main
    elif git show-ref --verify --quiet refs/remotes/origin/master; then
      git reset --hard origin/master
    else
      git reset --hard
    fi
  )
fi

echo "$local_dir"
