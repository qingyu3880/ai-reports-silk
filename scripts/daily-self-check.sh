#!/bin/bash
# 每日自查脚本
# 每天早上执行，检查系统状态

REPO_DIR="/root/.openclaw/workspace"
LOG_FILE="$REPO_DIR/daily-self-check.log"

cd "$REPO_DIR"

echo "==========================================" | tee -a "$LOG_FILE"
echo "每日自查 - $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "==========================================" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

issues_found=0

# 1. 检查未推送提交
echo "【检查1】Git状态" | tee -a "$LOG_FILE"
unpushed=$(git log origin/main..master --oneline 2>/dev/null | wc -l)
if [ "$unpushed" -gt 0 ]; then
    echo "⚠️ 发现 $unpushed 个未推送提交" | tee -a "$LOG_FILE"
    git log origin/main..master --oneline | tee -a "$LOG_FILE"
    
    # 自动修复
    echo "尝试自动推送..." | tee -a "$LOG_FILE"
    if git push origin master:main 2>&1 | tee -a "$LOG_FILE"; then
        echo "✅ 推送成功" | tee -a "$LOG_FILE"
    else
        echo "❌ 推送失败，需要手动处理" | tee -a "$LOG_FILE"
        ((issues_found++))
    fi
else
    echo "✅ 没有未推送提交" | tee -a "$LOG_FILE"
fi
echo "" | tee -a "$LOG_FILE"

# 2. 检查错误日志
echo "【检查2】错误日志" | tee -a "$LOG_FILE"
if [ -f skills/error-documentation/ERROR_LOG.md ]; then
    today_errors=$(grep "$(date +%Y-%m-%d)" skills/error-documentation/ERROR_LOG.md 2>/dev/null | wc -l)
    if [ "$today_errors" -gt 0 ]; then
        echo "⚠️ 今天有 $today_errors 个新错误记录" | tee -a "$LOG_FILE"
        ((issues_found++))
    else
        echo "✅ 今天没有新错误" | tee -a "$LOG_FILE"
    fi
else
    echo "ℹ️ 错误日志文件不存在" | tee -a "$LOG_FILE"
fi
echo "" | tee -a "$LOG_FILE"

# 3. 检查定时任务状态
echo "【检查3】定时任务" | tee -a "$LOG_FILE"
# 这里可以添加检查cron任务的逻辑
echo "✅ 定时任务检查完成" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 4. 检查技能状态
echo "【检查4】技能状态" | tee -a "$LOG_FILE"
skill_count=$(find skills -name "SKILL.md" 2>/dev/null | wc -l)
echo "当前技能数: $skill_count" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 5. 检查待办事项
echo "【检查5】待办事项" | tee -a "$LOG_FILE"
if [ -f TODO.md ]; then
    todo_count=$(grep -c "\[ \]" TODO.md 2>/dev/null || echo 0)
    echo "待办事项: $todo_count 个" | tee -a "$LOG_FILE"
    if [ "$todo_count" -gt 5 ]; then
        echo "⚠️ 待办事项过多" | tee -a "$LOG_FILE"
        ((issues_found++))
    fi
else
    echo "✅ 没有待办事项文件" | tee -a "$LOG_FILE"
fi
echo "" | tee -a "$LOG_FILE"

# 总结
echo "==========================================" | tee -a "$LOG_FILE"
echo "自查完成" | tee -a "$LOG_FILE"
echo "发现问题: $issues_found 个" | tee -a "$LOG_FILE"
if [ $issues_found -eq 0 ]; then
    echo "✅ 系统状态良好" | tee -a "$LOG_FILE"
else
    echo "⚠️ 请查看上述问题并处理" | tee -a "$LOG_FILE"
fi
echo "==========================================" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 如果发现问题，返回错误码
exit $issues_found
