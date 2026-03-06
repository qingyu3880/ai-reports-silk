# Daily AI Brief Skill

A skill for automatically collecting and summarizing high-value AI news from Chinese and English sources.

## Overview

This skill helps you stay updated with the most important AI developments by:
1. Searching multiple high-quality sources
2. Applying a 5-dimensional value scoring system
3. Selecting top 10 high-value items
4. Extracting 3 deep insights
5. Generating a structured daily report

## Value Assessment Criteria (5D Model)

| Dimension | Weight | Description |
|-----------|--------|-------------|
| Timeliness | 20% | Within 24-48 hours |
| Exclusivity | 20% | First-hand/unique analysis |
| Depth | 20% | Data-backed, case studies |
| Actionability | 20% | Directly applicable |
| Impact | 20% | Industry/tech/business influence |

**Threshold: Score ≥ 3.5/5**

## Sources Covered

### Chinese
- 量子位 (QbitAI)
- 机器之心 (Synced)
- 36氪
- 新浪财经 Tech
- 钛媒体
- 中国工业互联网研究院

### English
- The Information
- TechCrunch
- X/Twitter (key accounts)
- Lex Fridman Podcast
- Company blogs (OpenAI, Anthropic, etc.)

## Usage

```bash
# Run manually
openclaw run daily-ai-brief

# Schedule daily at 9 AM
cron add "0 9 * * *" daily-ai-brief
```

## Output

- Markdown report saved to `reports/ai-daily-YYYY-MM-DD.md`
- Includes: Top 10 items + 3 insights + source list + tomorrow's tracking list
