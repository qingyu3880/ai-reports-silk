#!/bin/bash
# 20:00电影推荐双重保障脚本

echo "=== 电影推荐双重保障系统 ==="
echo "当前时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 检查当前时间
HOUR=$(date +%H)
MINUTE=$(date +%M)

if [ "$HOUR" -eq "19" ] && [ "$MINUTE" -ge "50" ]; then
    echo "[19:50] 预热阶段 - 准备生成电影推荐"
    echo "检查去重数据库..."
    ls /root/.openclaw/workspace/recommendations/movies/ | tail -5
    echo "准备就绪，等待20:00执行"
fi

if [ "$HOUR" -eq "20" ] && [ "$MINUTE" -ge "00" ] && [ "$MINUTE" -lt "05" ]; then
    echo "[20:00] 执行阶段 - 立即生成电影推荐"
    echo "任务: 生成今日电影推荐"
    echo "要求: 法国/日本/北欧经典电影"
    echo "格式: 严格按照电影推荐模板"
    echo "保存: /root/.openclaw/workspace/recommendations/movies/YYYY-MM-DD-片名.md"
    echo "推送: 立即推送到对话"
    echo "同步: 运行sync_reports.py"
fi

if [ "$HOUR" -eq "20" ] && [ "$MINUTE" -ge "15" ]; then
    echo "[20:15] 验证阶段 - 检查任务完成"
    TODAY=$(date +%Y-%m-%d)
    COUNT=$(ls /root/.openclaw/workspace/recommendations/movies/ | grep "$TODAY" | wc -l)
    if [ $COUNT -gt 0 ]; then
        echo "✅ 电影推荐已完成 ($COUNT 个文件)"
    else
        echo "❌ 电影推荐未完成，立即补做"
    fi
fi
