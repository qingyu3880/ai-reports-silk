#!/usr/bin/env python3
"""
自动同步脚本 - 将本地报告同步到Vercel网站
"""

import os
import json
import re
from datetime import datetime
import subprocess

# 配置
REPORTS_DIR = "/root/.openclaw/workspace/reports"
BOOKS_DIR = "/root/.openclaw/workspace/recommendations/books"
MUSIC_DIR = "/root/.openclaw/workspace/recommendations/music"
MOVIES_DIR = "/root/.openclaw/workspace/recommendations/movies"
DASHBOARD_DIR = "/root/.openclaw/workspace/dashboard"
VERCEL_URL = "https://ai-reports-silk.vercel.app"

def parse_markdown_file(filepath):
    """解析Markdown文件，提取标题、日期、摘要"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 提取标题
        title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
        title = title_match.group(1) if title_match else os.path.basename(filepath)
        
        # 提取日期
        date_match = re.search(r'(\d{4}-\d{2}-\d{2})', os.path.basename(filepath))
        date = date_match.group(1) if date_match else datetime.now().strftime('%Y-%m-%d')
        
        # 提取摘要（前200个字符）
        summary = re.sub(r'#.*?\n', '', content)  # 移除标题
        summary = re.sub(r'\[.*?\]', '', summary)  # 移除链接
        summary = re.sub(r'\*\*', '', summary)  # 移除加粗
        summary = summary.replace('\n', ' ').strip()[:200] + '...'
        
        return {
            'id': os.path.basename(filepath).replace('.md', ''),
            'title': title,
            'date': date,
            'summary': summary,
            'content': content,
            'filepath': filepath
        }
    except Exception as e:
        print(f"Error parsing {filepath}: {e}")
        return None

def collect_reports():
    """收集所有报告"""
    reports = {
        'daily': [],
        'weekly': [],
        'books': [],
        'music': [],
        'movies': []
    }
    
    # 收集AI日报
    ai_dir = os.path.join(REPORTS_DIR)
    if os.path.exists(ai_dir):
        for f in sorted(os.listdir(ai_dir), reverse=True):
            if f.startswith('ai-daily-') and f.endswith('.md'):
                filepath = os.path.join(ai_dir, f)
                report = parse_markdown_file(filepath)
                if report:
                    report['category'] = 'AI'
                    reports['daily'].append(report)
    
    # 收集航空周报
    airline_dir = os.path.join(REPORTS_DIR, 'airline-ai')
    if os.path.exists(airline_dir):
        for f in sorted(os.listdir(airline_dir), reverse=True):
            if f.startswith('weekly-') and f.endswith('.md'):
                filepath = os.path.join(airline_dir, f)
                report = parse_markdown_file(filepath)
                if report:
                    report['category'] = '航空'
                    reports['weekly'].append(report)
    
    # 收集图书推荐
    if os.path.exists(BOOKS_DIR):
        for f in sorted(os.listdir(BOOKS_DIR), reverse=True):
            if f.endswith('.md'):
                filepath = os.path.join(BOOKS_DIR, f)
                report = parse_markdown_file(filepath)
                if report:
                    report['category'] = '图书'
                    reports['books'].append(report)
    
    # 收集音乐推荐
    if os.path.exists(MUSIC_DIR):
        for f in sorted(os.listdir(MUSIC_DIR), reverse=True):
            if f.endswith('.md'):
                filepath = os.path.join(MUSIC_DIR, f)
                report = parse_markdown_file(filepath)
                if report:
                    report['category'] = '音乐'
                    reports['music'].append(report)
    
    # 收集电影推荐
    if os.path.exists(MOVIES_DIR):
        for f in sorted(os.listdir(MOVIES_DIR), reverse=True):
            if f.endswith('.md'):
                filepath = os.path.join(MOVIES_DIR, f)
                report = parse_markdown_file(filepath)
                if report:
                    report['category'] = '电影'
                    reports['movies'].append(report)
    
    return reports

def generate_reports_json(reports):
    """生成reports.json文件"""
    json_data = {
        'daily': [{'id': r['id'], 'title': r['title'], 'date': r['date'], 'category': r['category'], 'summary': r['summary'], 'content': r['content']} for r in reports['daily']],
        'weekly': [{'id': r['id'], 'title': r['title'], 'date': r['date'], 'category': r['category'], 'summary': r['summary'], 'content': r['content']} for r in reports['weekly']],
        'books': [{'id': r['id'], 'title': r['title'], 'date': r['date'], 'category': r['category'], 'summary': r['summary'], 'content': r['content']} for r in reports['books']],
        'music': [{'id': r['id'], 'title': r['title'], 'date': r['date'], 'category': r['category'], 'summary': r['summary'], 'content': r['content']} for r in reports['music']],
        'movies': [{'id': r['id'], 'title': r['title'], 'date': r['date'], 'category': r['category'], 'summary': r['summary'], 'content': r['content']} for r in reports['movies']],
        'lastUpdated': datetime.now().isoformat()
    }
    return json_data

def sync_to_vercel():
    """同步到Vercel"""
    try:
        # 收集报告
        reports = collect_reports()
        
        # 生成JSON数据
        json_data = generate_reports_json(reports)
        
        # 保存到dashboard目录
        json_path = os.path.join(DASHBOARD_DIR, 'reports.json')
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(json_data, f, ensure_ascii=False, indent=2)
        
        print(f"✅ 已生成 reports.json")
        print(f"   - AI日报: {len(reports['daily'])} 篇")
        print(f"   - 周报: {len(reports['weekly'])} 篇")
        print(f"   - 图书: {len(reports['books'])} 篇")
        print(f"   - 音乐: {len(reports['music'])} 篇")
        print(f"   - 电影: {len(reports['movies'])} 篇")
        
        # 这里可以添加Git提交和推送命令
        # 如果需要自动部署到Vercel
        
        return True
    except Exception as e:
        print(f"❌ 同步失败: {e}")
        return False

if __name__ == "__main__":
    print("=" * 60)
    print("AI日报中心 - 自动同步工具")
    print("=" * 60)
    sync_to_vercel()