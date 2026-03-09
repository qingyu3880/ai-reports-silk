---
name: hot-trends
description: Fetch trending topics from Weibo, Zhihu, Baidu and other platforms.
metadata:
  {
    "openclaw":
      {
        "emoji": "🔥",
        "requires": { "bins": ["python3"] }
      }
  }
---

# Hot Trends Skill

Get trending topics from Chinese social platforms.

## Usage

Fetch all trends:
```python
python3 scripts/fetch_trends.py --platform all
```

Fetch specific platform:
```python
python3 scripts/fetch_trends.py --platform weibo
```

## Features

- Weibo hot search
- Zhihu hot list
- Baidu realtime
- JSON output
