# Usage

## Upload a skill to GitHub

```bash
REPO_URL="https://github.com/JasonYCHuang/awesome_skills.git" \
LOCAL_DIR="/home/node/.openclaw/workspace/github/awesome_skills" \
SKILL_DIR="/home/node/.openclaw/workspace/skills/vocab-github" \
DEST_ROOT="skills" \
/home/node/.openclaw/workspace/skills/skill-upload-github/scripts/push_skill_source.sh
```

Requires `GITHUB_TOKEN` (or `github_token`) env with write access.
