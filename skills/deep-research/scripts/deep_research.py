#!/usr/bin/env python3
"""Deep research using multiple search engines"""
import argparse
import json
import requests
import os

def brave_search(query, api_key=None):
    """Search using Brave API"""
    if not api_key:
        api_key = os.getenv('BRAVE_API_KEY')
    
    if not api_key:
        return {'error': 'BRAVE_API_KEY not set'}
    
    url = "https://api.search.brave.com/res/v1/web/search"
    headers = {
        'X-Subscription-Token': api_key,
        'Accept': 'application/json'
    }
    params = {'q': query, 'count': 10}
    
    try:
        r = requests.get(url, headers=headers, params=params, timeout=30)
        data = r.json()
        results = []
        for item in data.get('web', {}).get('results', []):
            results.append({
                'title': item.get('title'),
                'url': item.get('url'),
                'description': item.get('description')
            })
        return {'source': 'brave', 'results': results}
    except Exception as e:
        return {'error': str(e)}

def tavily_search(query, api_key=None):
    """Search using Tavily API"""
    if not api_key:
        api_key = os.getenv('TAVILY_API_KEY')
    
    if not api_key:
        return {'error': 'TAVILY_API_KEY not set'}
    
    url = "https://api.tavily.com/search"
    headers = {'Content-Type': 'application/json'}
    data = {
        'api_key': api_key,
        'query': query,
        'search_depth': 'advanced',
        'include_answer': True
    }
    
    try:
        r = requests.post(url, headers=headers, json=data, timeout=30)
        return r.json()
    except Exception as e:
        return {'error': str(e)}

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--query', required=True)
    parser.add_argument('--engine', choices=['brave', 'tavily', 'both'], default='both')
    parser.add_argument('--depth', choices=['basic', 'advanced'], default='basic')
    args = parser.parse_args()
    
    results = {}
    
    if args.engine in ['brave', 'both']:
        results['brave'] = brave_search(args.query)
    
    if args.engine in ['tavily', 'both']:
        results['tavily'] = tavily_search(args.query)
    
    print(json.dumps(results, ensure_ascii=False, indent=2))
