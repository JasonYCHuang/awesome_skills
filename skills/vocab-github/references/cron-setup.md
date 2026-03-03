# Cron setup (vocab + GitHub)

Use these templates to create/adjust cron jobs.

## Daily vocab push (chat + log)

```bash
openclaw cron add \
  --name "Daily EN+DE vocab (B2)" \
  --cron "0 22 * * *" \
  --tz "Asia/Taipei" \
  --session isolated \
  --message "Daily task: Generate 5 English (B2) + 5 German (B2) words with short easy-to-memorize sentences. Output as markdown tables. English table columns: 1 | Word | Sentence | 中文. German table columns: 1 | Wort | Satz | 中文. Keep sentences short. Also archive to local logs: use exec to get date variables: date=TZ=Asia/Taipei date +%F, year=TZ=Asia/Taipei date +%G, weeknum=TZ=Asia/Taipei date +%V. Write full markdown tables to /home/node/.openclaw/workspace/vocab_log/en/$year/w$weeknum/$date.md and /home/node/.openclaw/workspace/vocab_log/de/$year/w$weeknum/$date.md. Ensure directories exist. Then output the formatted tables as the final message for delivery." \
  --announce \
  --channel telegram \
  --to "<CHAT_ID>"
```

## Daily GitHub merge (03:10)

```bash
openclaw cron add \
  --name "Daily vocab push to GitHub" \
  --cron "10 3 * * *" \
  --tz "Asia/Taipei" \
  --session isolated \
  --message "Run daily GitHub push: use exec to run <SKILL_DIR>/scripts/weekly_vocab_push.sh (requires GITHUB_TOKEN env). This merges daily logs into the current week file (vocab_en/<year>/w<week>.md, vocab_de/<year>/w<week>.md). After it completes, send a brief confirmation with the week id and repo paths. If it fails due to missing logs, inform Jason哥." \
  --announce \
  --channel telegram \
  --to "<CHAT_ID>"
```

Replace `<CHAT_ID>` and `<SKILL_DIR>`.
