#!/usr/bin/env bash
set -euo pipefail

# Required env:
#   REPO_URL, LOCAL_DIR, LOG_ROOT
# Optional:
#   TZ_NAME (default Asia/Taipei)
#   GITHUB_TOKEN or github_token

TZ_NAME=${TZ_NAME:-Asia/Taipei}
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

year=$(TZ="$TZ_NAME" date +%G)
weeknum=$(TZ="$TZ_NAME" date +%V)
week="${year}-W${weeknum}"

repo_dir=$(REPO_URL="$REPO_URL" LOCAL_DIR="$LOCAL_DIR" "$SCRIPT_DIR/gh_repo_prepare.sh" 2>/dev/null | tail -n1)

en_src="$LOG_ROOT/en/$year/w$weeknum"
de_src="$LOG_ROOT/de/$year/w$weeknum"

if [ ! -d "$en_src" ] || [ ! -d "$de_src" ]; then
  echo "No vocab logs for $week."
  exit 1
fi

mkdir -p "$repo_dir/vocab_en/$year" "$repo_dir/vocab_de/$year"

out_en="$repo_dir/vocab_en/$year/w$weeknum.md"
out_de="$repo_dir/vocab_de/$year/w$weeknum.md"

# Build English weekly file
: > "$out_en"
for f in $(ls "$en_src"/*.md 2>/dev/null | sort); do
  d=$(basename "$f" .md)
  echo "## $d" >> "$out_en"
  cat "$f" >> "$out_en"
  echo "" >> "$out_en"
done

# Build German weekly file
: > "$out_de"
for f in $(ls "$de_src"/*.md 2>/dev/null | sort); do
  d=$(basename "$f" .md)
  echo "## $d" >> "$out_de"
  cat "$f" >> "$out_de"
  echo "" >> "$out_de"
done

(
  cd "$repo_dir"
  git add "vocab_en/$year/w$weeknum.md" "vocab_de/$year/w$weeknum.md"
  if git diff --cached --quiet; then
    echo "No changes to commit for $week."
    exit 0
  fi
  git commit -m "Weekly vocab $week"
  # Use token for push
  if [ -n "${GITHUB_TOKEN:-}" ]; then token="$GITHUB_TOKEN"; else token="$github_token"; fi
  GIT_TERMINAL_PROMPT=0 git -c url."https://x-access-token:${token}@github.com/".insteadOf="https://github.com/" push origin HEAD
)

echo "Pushed weekly vocab for $week to GitHub."
