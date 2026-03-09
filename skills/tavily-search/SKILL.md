---
name: tavily-search
description: Tavily AI search for deep research and web content extraction. Provides high-quality search results with source citations.
metadata:
  {
    "openclaw":
      {
        "emoji": "🔍",
        "requires": { "env": ["TAVILY_API_KEY"] }
      }
  }
---

# Tavily Search Skill

Deep research and web search using Tavily AI.

## Setup

Get API key from https://tavily.com and set:
```bash
export TAVILY_API_KEY="your-key"
```

## Usage

Search with depth control:
```python
python3 scripts/tavily_search.py "query" --depth basic|advanced
```

Extract content from URLs:
```python
python3 scripts/tavily_extract.py "https://example.com"
```

## Features

- High-quality AI search results
- Source citations included
- Content extraction from URLs
- Configurable search depth
