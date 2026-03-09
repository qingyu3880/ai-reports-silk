#!/usr/bin/env python3
"""Fetch hot trends from various platforms"""
import requests
import json
import argparse

def get_weibo_hot():
    """Fetch Weibo hot search"""
    try:
        url = "https://weibo.com/ajax/side/hotSearch"
        headers = {'User-Agent': 'Mozilla/5.0'}
        r = requests.get(url, headers=headers, timeout=10)
        data = r.json()
        trends = []
        for item in data.get('data', {}).get('realtime', [])[:10]:
            trends.append({
                'title': item.get('word', ''),
                'hot': item.get('raw_hot', 0)
            })
        return trends
    except Exception as e:
        return [{'error': str(e)}]

def get_zhihu_hot():
    """Fetch Zhihu hot"""
    try:
        url = "https://www.zhihu.com/api/v3/feed/topstory/hot-lists/total"
        headers = {'User-Agent': 'Mozilla/5.0'}
        r = requests.get(url, headers=headers, timeout=10)
        data = r.json()
        trends = []
        for item in data.get('data', [])[:10]:
            trends.append({
                'title': item.get('target', {}).get('title', ''),
                'hot': item.get('detail_text', '')
            })
        return trends
    except Exception as e:
        return [{'error': str(e)}]

def get_baidu_hot():
    """Fetch Baidu hot"""
    try:
        url = "https://top.baidu.com/board?tab=realtime"
        headers = {'User-Agent': 'Mozilla/5.0'}
        r = requests.get(url, headers=headers, timeout=10)
        # Simple extraction
        import re
        titles = re.findall(r'class="c-single-text-ellipsis">(.+?)<', r.text)
        return [{'title': t} for t in titles[:10]]
    except Exception as e:
        return [{'error': str(e)}]

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--platform', choices=['weibo', 'zhihu', 'baidu', 'all'], default='all')
    args = parser.parse_args()
    
    results = {}
    
    if args.platform in ['weibo', 'all']:
        results['weibo'] = get_weibo_hot()
    
    if args.platform in ['zhihu', 'all']:
        results['zhihu'] = get_zhihu_hot()
    
    if args.platform in ['baidu', 'all']:
        results['baidu'] = get_baidu_hot()
    
    print(json.dumps(results, ensure_ascii=False, indent=2))
