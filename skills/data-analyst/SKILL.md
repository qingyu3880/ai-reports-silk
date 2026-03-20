---
name: data-analyst
description: Query databases, analyze spreadsheets, create visualizations, and generate insights that drive decisions. Process CSV, Excel data and create charts.
metadata:
  { "openclaw": { "emoji": "📊" } }
---

# Data Analyst Skill

Turn your AI agent into a data analysis powerhouse.

## Capabilities

✅ SQL Queries — Write and execute queries against databases  
✅ Spreadsheet Analysis — Process CSV, Excel, Google Sheets data  
✅ Data Visualization — Create charts, graphs, and dashboards  
✅ Report Generation — Automated reports with insights  
✅ Data Cleaning — Handle missing data, outliers, formatting  
✅ Statistical Analysis — Descriptive stats, trends, correlations  

## Quick Start

Configure your data sources in TOOLS.md:

```markdown
### Data Sources
- Primary DB: [Connection string or description]
- Spreadsheets: [Google Sheets URL / local path]
- Data warehouse: [BigQuery/Snowflake/etc.]
```

## Analysis Workflow

1. Define the Question — What are we trying to answer?
2. Understand the Data — What's available? What's the quality?
3. Clean and Prepare — Handle missing values, fix types, remove duplicates
4. Explore — Descriptive statistics, initial visualizations
5. Analyze — Deep dive into findings
6. Communicate — Clear visualizations, actionable insights

## Common Operations

### SQL Queries
```sql
-- Row count
SELECT COUNT(*) FROM table_name;

-- Daily aggregation
SELECT DATE(created_at) as date, COUNT(*) as daily_count
FROM transactions
GROUP BY DATE(created_at)
ORDER BY date DESC;
```

### Pandas (Python)
```python
import pandas as pd

# Load data
df = pd.read_csv('data.csv')

# Basic exploration
print(df.describe())

# Aggregation
summary = df.groupby('category').agg({'amount': ['sum', 'mean']})
```

## Best Practices

- Start with the question
- Validate your data
- Document everything
- Visualize appropriately
- Lead with insights
- Make it actionable
