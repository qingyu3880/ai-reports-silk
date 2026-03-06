# Datasource Module Skill

## Description
Structured access to authoritative data sources via APIs. Reduces dependency on web searches by providing direct data access.

## When to Use
- Need authoritative data (weather, finance, etc.)
- Want to avoid web scraping
- Need reliable, structured data
- Working with specific APIs

## Key Features
- Access to data APIs via Python
- Pre-installed API client libraries
- No authentication needed (system-covered)
- Results saved to files

## Usage Example
```python
import sys
sys.path.append('/opt/.manus/.sandbox-runtime')
from data_api import ApiClient
client = ApiClient()
weather = client.call_api('WeatherBank/get_weather', query={'location': 'Beijing'})
print(weather)
```

## Best Practices
1. Check available APIs in event stream first
2. Use APIs over web search when available
3. Save results to files, don't output directly
4. Use complete query parameter format
