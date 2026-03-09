---
name: deep-research
description: Multi-engine deep research with source aggregation and analysis.
metadata:
  {
    "openclaw":
      {
        "emoji": "🔬",
        "requires": { "bins": ["python3"] }
      }
  }
---

# Deep Research Skill

Multi-engine deep research with Tavily, Brave, and custom sources.

## Usage

Deep research query:
```python
python3 scripts/deep_research.py --query "AI industry trends 2026" --depth advanced
```

Compare sources:
```python
python3 scripts/compare_sources.py --query "quantum computing"
```

## Features

- Multi-engine search
- Source credibility scoring
- Content extraction
- Summary generation
- Citation tracking
