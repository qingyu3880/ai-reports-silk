---
name: browser-control
description: Advanced browser automation with anti-detection and session management.
metadata:
  {
    "openclaw":
      {
        "emoji": "🌐",
        "requires": { "bins": ["python3", "playwright"] }
      }
  }
---

# Browser Control Skill

Advanced browser automation with anti-detection.

## Setup

Install Playwright:
```bash
pip install playwright
playwright install chromium
```

## Usage

Navigate and extract:
```python
python3 scripts/browser_navigate.py --url https://example.com --action screenshot
```

Anti-crawl browsing:
```python
python3 scripts/anti_crawl.py --url https://example.com
```

## Features

- Headless browser control
- Anti-detection measures
- Session persistence
- Screenshot capture
- JavaScript execution
