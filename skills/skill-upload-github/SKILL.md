---
name: skill-upload-github
description: Package and upload skill source folders (SKILL.md + scripts/references/assets) to a GitHub repo under skills/<skill-name>. Use when Jason wants new or updated skills pushed to GitHub in the standardized folder layout.
---

# Skill Upload → GitHub

## Overview
Upload a local skill folder to a GitHub repo under `skills/<skill-name>/` and keep scripts/references/assets alongside SKILL.md.

## Workflow
1) Confirm target repo URL and destination root (default `skills`).
2) Ensure `GITHUB_TOKEN` (or `github_token`) is present with write access.
3) Run `scripts/push_skill_source.sh` with:
   - `REPO_URL`
   - `LOCAL_DIR` (local clone path)
   - `SKILL_DIR` (source skill folder)
   - `DEST_ROOT` (optional, default `skills`)

## Scripts
- `scripts/skill_repo_prepare.sh`: clone/refresh the repo using token auth.
- `scripts/push_skill_source.sh`: copy skill source into `skills/<name>/` and push.

## Notes
- The script deletes the existing `skills/<skill-name>` folder before copying.
- If the repo is empty, the first commit will create it.
