---
name: stock-monitor
description: Real-time stock market monitoring and price tracking for Chinese and US stocks.
metadata:
  {
    "openclaw":
      {
        "emoji": "📈",
        "requires": { "bins": ["python3"] }
      }
  }
---

# Stock Monitor Skill

Monitor stock prices and market data.

## Usage

Query stock price:
```python
python3 scripts/stock_query.py --code 000001.SZ
```

Monitor multiple stocks:
```python
python3 scripts/stock_monitor.py --stocks 000001.SZ,600519.SH,AAPL
```

## Data Sources

- A-share: Sina Finance API
- US stocks: Yahoo Finance
- HK stocks: HKEX

## Features

- Real-time price queries
- Price change alerts
- Historical data
- Portfolio tracking
