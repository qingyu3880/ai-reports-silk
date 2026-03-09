---
name: web-extract
description: Extract and clean web content from URLs.
metadata:
  {
    "openclaw":
      {
        "emoji": "🌐",
        "requires": { "bins": ["python3"] }
      }
  }
---

# Web Extract Skill

Extract clean text content from web pages.

## Usage

Extract content:
```python
python3 scripts/extract.py --url https://example.com
```

## Features

- HTML to text conversion
- Script/style removal
- Content cleaning
- Title extraction
