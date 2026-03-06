# Memory Index: Semantic Search Guide

## How to Search Your Memory

### 1. For Long-Term Memory (Decisions, Preferences, Facts)
```python
memory_search(query="user's preference about X", maxResults=5)
```

### 2. For Recent Events (What happened today/yesterday)
```bash
# Read today's memory
cat memory/$(date +%Y-%m-%d).md

# Read yesterday's memory
cat memory/$(date -d "yesterday" +%Y-%m-%d).md 2>/dev/null || echo "No entry"
```

### 3. For Errors and Lessons Learned
```bash
# Search error documentation
grep -r "error-pattern" skills/error-documentation/

# Read full error log
cat skills/error-documentation/ERROR_LOG.md
```

### 4. For Tool-Specific Knowledge
```bash
# Find skill documentation
ls skills/*/SKILL.md

# Read specific skill
cat skills/TOOL_NAME/SKILL.md
```

### 5. For Project Context
```bash
# Check git history
git log --oneline -10

# Check recent files
find . -name "*.md" -mtime -1 -type f
```

## Key Memory Locations

| What You Need | Where to Look |
|--------------|---------------|
| Who am I | SOUL.md |
| Who is the user | USER.md |
| What happened today | memory/YYYY-MM-DD.md |
| Important decisions | MEMORY.md |
| Tool usage patterns | skills/*/SKILL.md |
| Past mistakes | skills/error-documentation/ERROR_LOG.md |
| Current project state | git status, recent commits |
| User preferences | USER.md, MEMORY.md |

## Search Keywords by Category

### Tool Errors
- `write-tool`, `missing-parameter`, `path-validation`
- `exec-timeout`, `process-killed`, `network-error`
- `git-push`, `repository-not-found`, `authentication`

### User Preferences
- `communication-style`, `response-format`, `tone`
- `schedule`, `reminders`, `deadlines`
- `interests`, `hobbies`, `work-domain`

### Project Context
- `vercel`, `github`, `deployment`
- `daily-report`, `music-recommendation`, `cron`
- `checklist`, `automation`, `sync`

## Anti-Patterns (Don't Do This)

❌ "I remember the user likes..."  
✅ Search MEMORY.md for "preference"

❌ "I think I did this before..."  
✅ Check memory/ files for similar tasks

❌ "This should work..."  
✅ Read the SKILL.md first

❌ "I know how to use this tool..."  
✅ Check ERROR_LOG.md for past mistakes with this tool

## Maintenance

Update this index when:
- New skill directories are created
- New error patterns emerge
- Memory structure changes
- Search keywords prove ineffective
