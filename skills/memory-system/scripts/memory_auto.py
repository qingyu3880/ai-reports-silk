#!/usr/bin/env python3
"""
Memory Auto-Save - 自动记忆保存
在对话结束后自动提取并保存重要信息
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from memory_store import MemoryStore

class AutoMemory:
    def __init__(self):
        self.store = MemoryStore()
    
    def extract_and_save(self, conversation_text):
        """
        从对话中提取重要信息并保存
        
        提取规则：
        1. 用户明确说"记住"
        2. 重要决策或配置
        3. 错误和解决方案
        4. 用户偏好
        """
        # 这里可以集成AI来智能提取
        # 简单实现：检查关键词
        
        if "记住" in conversation_text or "记得" in conversation_text:
            # 提取记住的内容
            self.store.store(
                content=conversation_text,
                category="preference",
                tags=["用户要求记忆"]
            )
            return True
        
        if "错误" in conversation_text or "失败" in conversation_text:
            if "解决" in conversation_text or "修复" in conversation_text:
                self.store.store(
                    content=conversation_text,
                    category="error",
                    tags=["错误修复"]
                )
                return True
        
        if "决定" in conversation_text or "配置" in conversation_text:
            self.store.store(
                content=conversation_text,
                category="decision",
                tags=["配置决策"]
            )
            return True
        
        return False
    
    def save_daily_summary(self, date_str, summary):
        """保存每日总结"""
        self.store.store(
            content=f"**日期:** {date_str}\n\n**总结:** {summary}",
            category="daily_summary",
            tags=["每日总结"]
        )

if __name__ == "__main__":
    # 测试
    am = AutoMemory()
    test_conv = "用户: 请记住我喜欢法国电影"
    saved = am.extract_and_save(test_conv)
    print(f"自动保存: {saved}")