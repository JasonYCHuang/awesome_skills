---
name: vocab-github
description: Automate daily English/German vocabulary logging and merge to weekly GitHub files. Use when setting up, fixing, or changing vocab schedules, table formats, log paths, or GitHub push workflows for EN/DE word lists.
---

# Vocab → GitHub Automation

## Overview
Set up daily vocab generation, local logging, and daily GitHub merge into weekly files (wNN.md). Includes helper scripts to clone/pull the repo and push weekly files.

## Quick start (preferred workflow)
1) Ensure `GITHUB_TOKEN` (or `github_token`) env is available and has repo write access.
2) Set these variables for scripts:
   - `REPO_URL` (e.g., `https://github.com/<user>/<repo>.git`)
   - `LOCAL_DIR` (e.g., `/home/node/.openclaw/workspace/github/<repo>`)
   - `LOG_ROOT` (e.g., `/home/node/.openclaw/workspace/vocab_log`)
3) Create cron jobs for:
   - Daily vocab push to chat + local logs
   - Daily GitHub merge (03:10 Asia/Taipei)

See `references/cron-setup.md` for templates.

## Scripts
- `scripts/gh_repo_prepare.sh`: clones/updates repo using token auth.
- `scripts/weekly_vocab_push.sh`: merges daily logs into weekly files and pushes to GitHub.

### Script env
- Required: `REPO_URL`, `LOCAL_DIR`, `LOG_ROOT`
- Optional: `TZ_NAME` (default `Asia/Taipei`)
- Auth: `GITHUB_TOKEN` (preferred) or `github_token`

## Format requirements (current)
- Daily vocab is stored as **markdown tables** with columns:
  - English: `1 | Word | Sentence | 中文`
  - German: `1 | Wort | Satz | 中文`
- Constraints:
  - Avoid repeating any past words in the log history.
  - Use **present tense only** in example sentences.
- Weekly merge writes to:
  - `vocab_en/<year>/w<week>.md`
  - `vocab_de/<year>/w<week>.md`

## Notes
- If weekly push fails with “no logs”, generate/relocate daily logs under:
  - `LOG_ROOT/en/<year>/w<weeknum>/<date>.md`
  - `LOG_ROOT/de/<year>/w<weeknum>/<date>.md`
