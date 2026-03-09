#!/usr/bin/env python3
"""Extract and clean web content"""
import requests
import re
import argparse
from urllib.parse import urlparse

def extract_content(url):
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
        r = requests.get(url, headers=headers, timeout=30)
        r.encoding = r.apparent_encoding
        
        html = r.text
        
        # Remove scripts and styles
        html = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.DOTALL)
        html = re.sub(r'<style[^>]*>.*?</style>', '', html, flags=re.DOTALL)
        
        # Extract title
        title_match = re.search(r'<title[^>]*>(.*?)</title>', html, re.IGNORECASE)
        title = title_match.group(1) if title_match else 'No title'
        
        # Extract text content
        text = re.sub(r'<[^>]+>', ' ', html)
        text = re.sub(r'\s+', ' ', text).strip()
        
        # Clean up
        text = text.replace('&nbsp;', ' ')
        text = text.replace('&amp;', '&')
        
        return {
            'url': url,
            'title': title,
            'content': text[:3000],
            'domain': urlparse(url).netloc
        }
    except Exception as e:
        return {'error': str(e), 'url': url}

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--url', required=True)
    args = parser.parse_args()
    
    result = extract_content(args.url)
    print(f"Title: {result.get('title', 'N/A')}")
    print(f"Domain: {result.get('domain', 'N/A')}")
    print(f"Content:\n{result.get('content', result.get('error', 'Unknown error'))[:1000]}")
