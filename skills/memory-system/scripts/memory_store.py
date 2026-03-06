#!/usr/bin/env python3
"""
Memory Store - 长期记忆存储系统
自动保存重要信息到每日记忆文件
"""

import os
import json
import hashlib
from datetime import datetime
from pathlib import Path

WORKSPACE = "/root/.openclaw/workspace"
MEMORY_DIR = os.path.join(WORKSPACE, "memory")

class MemoryStore:
    def __init__(self):
        self.memory_dir = MEMORY_DIR
        os.makedirs(self.memory_dir, exist_ok=True)
        
    def _get_today_file(self):
        """获取今日记忆文件路径"""
        today = datetime.now().strftime("%Y-%m-%d")
        return os.path.join(self.memory_dir, f"{today}.md")
    
    def _generate_id(self, content):
        """生成记忆ID"""
        return hashlib.md5(content.encode()).hexdigest()[:8]
    
    def store(self, content, category="general", tags=None, source=None):
        """
        存储记忆
        
        Args:
            content: 记忆内容
            category: 分类 (preference, decision, task, fact, error, general)
            tags: 标签列表
            source: 来源（可选）
        """
        memory_file = self._get_today_file()
        memory_id = self._generate_id(content)
        timestamp = datetime.now().strftime("%H:%M:%S")
        
        # 构建记忆条目
        entry = f"""
## [{memory_id}] {category.upper()} | {timestamp}

{content}

"""
        if tags:
            entry += f"**标签:** {', '.join(tags)}\n"
        if source:
            entry += f"**来源:** {source}\n"
        
        entry += "---\n"
        
        # 追加到文件
        with open(memory_file, "a", encoding="utf-8") as f:
            f.write(entry)
        
        return memory_id
    
    def store_interaction(self, user_msg, assistant_msg, key_takeaway=None):
        """存储对话交互"""
        content = f"**用户:** {user_msg}\n\n**助手:** {assistant_msg}"
        if key_takeaway:
            content += f"\n\n**要点:** {key_takeaway}"
        
        return self.store(content, category="interaction", tags=["对话"])
    
    def store_decision(self, decision, context, reasoning):
        """存储重要决策"""
        content = f"**决策:** {decision}\n\n**背景:** {context}\n\n**理由:** {reasoning}"
        return self.store(content, category="decision", tags=["决策"])
    
    def store_preference(self, preference, topic):
        """存储用户偏好"""
        content = f"**偏好:** {preference}\n\n**主题:** {topic}"
        return self.store(content, category="preference", tags=["偏好", topic])
    
    def store_error(self, error, solution, lesson):
        """存储错误教训"""
        content = f"**错误:** {error}\n\n**解决:** {solution}\n\n**教训:** {lesson}"
        return self.store(content, category="error", tags=["错误", "教训"])

# 便捷函数
def store(content, category="general", tags=None):
    """快速存储记忆"""
    ms = MemoryStore()
    return ms.store(content, category, tags)

def store_decision(decision, context, reasoning):
    """快速存储决策"""
    ms = MemoryStore()
    return ms.store_decision(decision, context, reasoning)

def store_preference(preference, topic):
    """快速存储偏好"""
    ms = MemoryStore()
    return ms.store_preference(preference, topic)

def store_error(error, solution, lesson):
    """快速存储错误"""
    ms = MemoryStore()
    return ms.store_error(error, solution, lesson)

if __name__ == "__main__":
    # 测试
    ms = MemoryStore()
    mid = ms.store("测试记忆内容", category="test", tags=["测试"])
    print(f"记忆已存储: {mid}")