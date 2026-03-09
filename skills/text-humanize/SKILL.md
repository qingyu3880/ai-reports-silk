---
name: text-humanize
description: Make AI-generated text sound more natural and human-like.
metadata:
  {
    "openclaw":
      {
        "emoji": "✍️",
        "requires": { "bins": ["python3"] }
      }
  }
---

# Text Humanize Skill

Transform AI text to sound more natural.

## Usage

Humanize text:
```python
python3 scripts/humanize.py --text "Furthermore, it is important to note that..."
```

Or from file:
```python
python3 scripts/humanize.py --file input.txt
```

## Features

- Remove formal transitions
- Add contractions
- Vary sentence length
- Natural flow
