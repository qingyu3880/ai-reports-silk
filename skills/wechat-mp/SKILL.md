---
name: wechat-mp
description: WeChat Official Account content management and publishing.
metadata:
  {
    "openclaw":
      {
        "emoji": "📱",
        "requires": { "env": ["WECHAT_APPID", "WECHAT_SECRET"] }
      }
  }
---

# WeChat MP Skill

Manage WeChat Official Account content.

## Setup

Configure WeChat credentials:
```bash
export WECHAT_APPID="your-appid"
export WECHAT_SECRET="your-secret"
```

## Usage

Draft article:
```python
python3 scripts/draft_article.py --title "Title" --content "Content"
```

Publish article:
```python
python3 scripts/publish_article.py --media-id MEDIA_ID
```

## Features

- Draft management
- Article publishing
- Media upload
- User analytics
