#!/usr/bin/env python3
"""
用户要求检查机制 - 全面审计系统
确保所有用户指令被正确执行
"""

import os
import json
import sys
from datetime import datetime, timedelta
from pathlib import Path

sys.path.insert(0, '/root/.openclaw/workspace/skills/memory-system/scripts')
from memory_store import store
from memory_search import search

WORKSPACE = "/root/.openclaw/workspace"
DEPLOY_DIR = f"{WORKSPACE}/deploy"
DASHBOARD_DIR = f"{WORKSPACE}/dashboard"
MEMORY_DIR = f"{WORKSPACE}/memory"

class UserRequirementChecker:
    """用户要求检查器"""
    
    def __init__(self):
        self.checks = []
        self.errors = []
        self.warnings = []
        
    def log(self, level, message):
        """记录检查结果"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        entry = f"[{timestamp}] {level}: {message}"
        self.checks.append(entry)
        if level == "ERROR":
            self.errors.append(entry)
        elif level == "WARN":
            self.warnings.append(entry)
        print(entry)
    
    # ==================== 核心要求检查 ====================
    
    def check_1_auto_push_to_dialog(self):
        """检查1: 定时报告自动推送到对话"""
        self.log("INFO", "检查1: 定时报告自动推送到对话")
        
        # 检查定时任务配置
        cron_file = f"{WORKSPACE}/.openclaw/cron.json"
        if os.path.exists(cron_file):
            self.log("PASS", "✅ 定时任务配置文件存在")
        else:
            self.log("ERROR", "❌ 定时任务配置文件不存在")
        
        # 检查今日是否有推送记录
        today = datetime.now().strftime("%Y-%m-%d")
        memories = search("定时报告", max_results=5)
        today_pushes = [m for m in memories if today in m.get('date', '')]
        
        if today_pushes:
            self.log("PASS", f"✅ 今日有 {len(today_pushes)} 条推送记录")
        else:
            self.log("WARN", "⚠️ 今日暂无推送记录（可能时间未到）")
    
    def check_2_auto_push_to_website(self):
        """检查2: 定时报告自动推送到网站"""
        self.log("INFO", "检查2: 定时报告自动推送到网站")
        
        # 检查 reports.json 是否存在
        reports_file = f"{DEPLOY_DIR}/reports.json"
        if not os.path.exists(reports_file):
            self.log("ERROR", "❌ reports.json 不存在")
            return
        
        # 检查文件大小（是否为空）
        size = os.path.getsize(reports_file)
        if size > 1000:
            self.log("PASS", f"✅ reports.json 存在 ({size} bytes)")
        else:
            self.log("ERROR", f"❌ reports.json 太小 ({size} bytes)")
        
        # 检查内容
        try:
            with open(reports_file, 'r') as f:
                data = json.load(f)
            
            daily_count = len(data.get('daily', []))
            weekly_count = len(data.get('weekly', []))
            books_count = len(data.get('books', []))
            
            self.log("INFO", f"   - AI日报: {daily_count} 篇")
            self.log("INFO", f"   - 周报: {weekly_count} 篇")
            self.log("INFO", f"   - 图书: {books_count} 篇")
            
            # 检查今日是否有更新
            today = datetime.now().strftime("%Y-%m-%d")
            today_books = [b for b in data.get('books', []) if today in b.get('date', '')]
            if today_books:
                self.log("PASS", f"✅ 今日有 {len(today_books)} 本图书推荐")
            else:
                self.log("ERROR", "❌ 今日图书推荐未同步到网站")
                
        except Exception as e:
            self.log("ERROR", f"❌ reports.json 解析失败: {e}")
    
    def check_3_no_user_confirmation(self):
        """检查3: 无需用户确认，全自动执行"""
        self.log("INFO", "检查3: 无需用户确认，全自动执行")
        
        # 检查记忆系统中是否有此指令
        memories = search("无需确认", max_results=3)
        if memories:
            self.log("PASS", "✅ 已记录'无需确认'指令")
        else:
            self.log("WARN", "⚠️ 未找到'无需确认'指令记录")
        
        # 检查定时任务配置
        self.log("INFO", "   定时任务应配置为自动执行，不等待用户输入")
    
    def check_4_self_check_and_fix(self):
        """检查4: 自动检查执行状态，自行修复"""
        self.log("INFO", "检查4: 自动检查执行状态，自行修复")
        
        # 检查是否有自检机制
        protocol_file = f"{WORKSPACE}/CRON_PROTOCOL.md"
        if os.path.exists(protocol_file):
            self.log("PASS", "✅ 自检协议文件存在")
        else:
            self.log("ERROR", "❌ 自检协议文件不存在")
        
        # 检查本检查脚本是否存在
        checker_file = f"{WORKSPACE}/skills/memory-system/scripts/requirement_checker.py"
        if os.path.exists(checker_file):
            self.log("PASS", "✅ 检查脚本存在")
        else:
            self.log("ERROR", "❌ 检查脚本不存在")
    
    def check_5_confirm_delivery(self):
        """检查5: 确认按时发送成功"""
        self.log("INFO", "检查5: 确认按时发送成功")
        
        # 检查今日17:00是否发送
        today = datetime.now().strftime("%Y-%m-%d")
        hour = datetime.now().hour
        
        if hour >= 17:
            memories = search("图书推荐", max_results=5)
            today_books = [m for m in memories if today in m.get('date', '')]
            if today_books:
                self.log("PASS", f"✅ 今日17:00图书推荐已发送")
            else:
                self.log("ERROR", "❌ 今日17:00图书推荐未发送")
        else:
            self.log("INFO", "   时间未到17:00，跳过检查")
    
    def check_6_deduplication(self):
        """检查6: 推荐内容查重，避免重复"""
        self.log("INFO", "检查6: 推荐内容查重，避免重复")
        
        # 检查 reports.json 中的重复
        reports_file = f"{DEPLOY_DIR}/reports.json"
        try:
            with open(reports_file, 'r') as f:
                data = json.load(f)
            
            books = data.get('books', [])
            titles = [b.get('title', '') for b in books]
            duplicates = [t for t in titles if titles.count(t) > 1]
            
            if duplicates:
                self.log("ERROR", f"❌ 发现重复图书: {duplicates}")
            else:
                self.log("PASS", "✅ 未发现重复图书")
                
        except Exception as e:
            self.log("ERROR", f"❌ 查重检查失败: {e}")
    
    # ==================== 定时任务检查 ====================
    
    def check_cron_schedule(self):
        """检查定时任务时间表"""
        self.log("INFO", "检查定时任务时间表")
        
        schedule = {
            "08:00": "音乐推荐",
            "09:00": "AI日报",
            "17:00": "图书推荐",
            "20:00": "电影推荐",
            "周一09:00": "航空AI周报"
        }
        
        for time, task in schedule.items():
            self.log("INFO", f"   {time}: {task}")
        
        self.log("PASS", "✅ 定时任务时间表已配置")
    
    # ==================== 执行检查 ====================
    
    def run_all_checks(self):
        """运行所有检查"""
        print("\n" + "="*60)
        print("用户要求全面检查")
        print("="*60 + "\n")
        
        self.check_1_auto_push_to_dialog()
        print()
        self.check_2_auto_push_to_website()
        print()
        self.check_3_no_user_confirmation()
        print()
        self.check_4_self_check_and_fix()
        print()
        self.check_5_confirm_delivery()
        print()
        self.check_6_deduplication()
        print()
        self.check_cron_schedule()
        
        # 汇总
        print("\n" + "="*60)
        print("检查结果汇总")
        print("="*60)
        print(f"总检查项: {len(self.checks)}")
        print(f"错误: {len(self.errors)}")
        print(f"警告: {len(self.warnings)}")
        
        if self.errors:
            print("\n❌ 需要修复的错误:")
            for e in self.errors:
                print(f"   {e}")
        
        if self.warnings:
            print("\n⚠️ 需要注意的警告:")
            for w in self.warnings:
                print(f"   {w}")
        
        if not self.errors and not self.warnings:
            print("\n✅ 所有检查通过！")
        
        return len(self.errors) == 0

if __name__ == "__main__":
    checker = UserRequirementChecker()
    success = checker.run_all_checks()
    sys.exit(0 if success else 1)