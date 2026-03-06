#!/usr/bin/env python3
"""
Memory Search - 长期记忆搜索系统
搜索 MEMORY.md 和每日记忆文件
"""

import os
import re
from datetime import datetime, timedelta
from pathlib import Path

WORKSPACE = "/root/.openclaw/workspace"
MEMORY_FILE = os.path.join(WORKSPACE, "MEMORY.md")
MEMORY_DIR = os.path.join(WORKSPACE, "memory")

class MemorySearch:
    def __init__(self):
        self.memory_file = MEMORY_FILE
        self.memory_dir = MEMORY_DIR
        
    def _read_file(self, filepath):
        """读取文件内容"""
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                return f.read()
        except:
            return ""
    
    def _get_recent_files(self, days=7):
        """获取最近N天的记忆文件"""
        files = []
        for i in range(days):
            date = (datetime.now() - timedelta(days=i)).strftime("%Y-%m-%d")
            filepath = os.path.join(self.memory_dir, f"{date}.md")
            if os.path.exists(filepath):
                files.append(filepath)
        return files
    
    def search(self, query, max_results=5, search_recent_days=30):
        """
        搜索记忆
        
        Args:
            query: 搜索关键词
            max_results: 最大结果数
            search_recent_days: 搜索最近多少天的记忆
        
        Returns:
            搜索结果列表
        """
        results = []
        query_lower = query.lower()
        
        # 1. 搜索 MEMORY.md
        memory_content = self._read_file(self.memory_file)
        if memory_content:
            # 按段落分割
            paragraphs = memory_content.split("\n\n")
            for para in paragraphs:
                if query_lower in para.lower():
                    results.append({
                        "source": "MEMORY.md",
                        "content": para.strip(),
                        "date": "长期记忆"
                    })
        
        # 2. 搜索每日记忆文件
        recent_files = self._get_recent_files(search_recent_days)
        for filepath in recent_files:
            content = self._read_file(filepath)
            if not content:
                continue
                
            # 提取日期
            filename = os.path.basename(filepath)
            date = filename.replace(".md", "")
            
            # 按记忆条目分割（以 ## 开头）
            entries = re.split(r'\n## ', content)
            for entry in entries[1:]:  # 跳过第一个空条目
                if query_lower in entry.lower():
                    # 提取标题行
                    lines = entry.split("\n")
                    title = lines[0] if lines else ""
                    
                    results.append({
                        "source": filepath,
                        "title": title.strip(),
                        "content": entry.strip(),
                        "date": date
                    })
        
        # 按相关性排序（简单实现：关键词出现次数）
        def relevance_score(result):
            content = result.get("content", "")
            return content.lower().count(query_lower)
        
        results.sort(key=relevance_score, reverse=True)
        
        return results[:max_results]
    
    def get_recent_memories(self, days=7, category=None):
        """获取最近记忆"""
        memories = []
        recent_files = self._get_recent_files(days)
        
        for filepath in recent_files:
            content = self._read_file(filepath)
            if not content:
                continue
                
            filename = os.path.basename(filepath)
            date = filename.replace(".md", "")
            
            # 按记忆条目分割
            entries = re.split(r'\n## ', content)
            for entry in entries[1:]:
                # 如果指定了分类，过滤
                if category and category.upper() not in entry.upper():
                    continue
                    
                lines = entry.split("\n")
                title = lines[0] if lines else ""
                
                memories.append({
                    "title": title.strip(),
                    "content": entry.strip(),
                    "date": date
                })
        
        return memories
    
    def summarize_memory(self, days=7):
        """汇总最近记忆"""
        memories = self.get_recent_memories(days)
        if not memories:
            return "最近没有记忆记录。"
        
        summary = f"最近{days}天共有 {len(memories)} 条记忆记录。\n\n"
        
        # 按分类统计
        categories = {}
        for m in memories:
            title = m.get("title", "")
            if " | " in title:
                cat = title.split(" | ")[0].strip("[]")
                categories[cat] = categories.get(cat, 0) + 1
        
        if categories:
            summary += "**分类统计：**\n"
            for cat, count in sorted(categories.items(), key=lambda x: -x[1]):
                summary += f"- {cat}: {count} 条\n"
        
        return summary

# 便捷函数
def search(query, max_results=5):
    """快速搜索记忆"""
    ms = MemorySearch()
    return ms.search(query, max_results)

def recent(days=7):
    """获取最近记忆"""
    ms = MemorySearch()
    return ms.get_recent_memories(days)

def summarize(days=7):
    """汇总最近记忆"""
    ms = MemorySearch()
    return ms.summarize_memory(days)

if __name__ == "__main__":
    # 测试
    ms = MemorySearch()
    results = ms.search("测试", max_results=3)
    print(f"找到 {len(results)} 条记忆")
    for r in results:
        print(f"\n[{r['date']}] {r.get('title', '')}")
        print(r['content'][:200] + "...")