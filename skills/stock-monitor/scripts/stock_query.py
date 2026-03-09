#!/usr/bin/env python3
"""Query stock price"""
import requests
import argparse
import json

def query_a_stock(code):
    """Query A-share stock via Sina API"""
    if code.startswith('6'):
        sina_code = f"sh{code}"
    else:
        sina_code = f"sz{code}"
    
    url = f"https://hq.sinajs.cn/list={sina_code}"
    headers = {'Referer': 'https://finance.sina.com.cn'}
    
    try:
        r = requests.get(url, headers=headers, timeout=10)
        r.encoding = 'gb2312'
        data = r.text.split('"')[1].split(',')
        return {
            'name': data[0],
            'price': float(data[3]),
            'open': float(data[1]),
            'high': float(data[4]),
            'low': float(data[5]),
            'prev_close': float(data[2]),
            'change': round((float(data[3]) - float(data[2])) / float(data[2]) * 100, 2)
        }
    except Exception as e:
        return {'error': str(e)}

def query_us_stock(symbol):
    """Query US stock via Yahoo Finance"""
    url = f"https://query1.finance.yahoo.com/v8/finance/chart/{symbol}"
    try:
        r = requests.get(url, timeout=10)
        data = r.json()
        meta = data['chart']['result'][0]['meta']
        return {
            'symbol': symbol,
            'price': meta['regularMarketPrice'],
            'currency': meta['currency']
        }
    except Exception as e:
        return {'error': str(e)}

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--code', required=True, help='Stock code (e.g., 000001.SZ, AAPL)')
    args = parser.parse_args()
    
    if args.code.isdigit() or '.SZ' in args.code or '.SH' in args.code:
        code = args.code.replace('.SZ', '').replace('.SH', '')
        result = query_a_stock(code)
    else:
        result = query_us_stock(args.code)
    
    print(json.dumps(result, ensure_ascii=False, indent=2))
