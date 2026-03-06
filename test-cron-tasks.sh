#!/bin/bash
# 定时任务完整测试脚本

echo "=========================================="
echo "定时任务完整测试 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 测试1: 环境检查
echo ""
echo "【测试1】环境检查"
echo "----------------------------------------"
WORKSPACE="/root/.openclaw/workspace"
if [ -d "$WORKSPACE" ]; then
    echo "✅ 工作目录存在: $WORKSPACE"
else
    echo "❌ 工作目录不存在: $WORKSPACE"
    exit 1
fi

# 测试2: 目录结构检查
echo ""
echo "【测试2】目录结构检查"
echo "----------------------------------------"
for dir in "recommendations/music" "recommendations/books" "recommendations/movies" "reports" "reports/airline-ai"; do
    if [ -d "$WORKSPACE/$dir" ]; then
        echo "✅ $dir 目录存在"
    else
        echo "❌ $dir 目录不存在，创建中..."
        mkdir -p "$WORKSPACE/$dir"
        echo "✅ $dir 目录已创建"
    fi
done

# 测试3: 去重逻辑测试
echo ""
echo "【测试3】去重逻辑测试"
echo "----------------------------------------"
TODAY=$(date +%Y-%m-%d)

# 检查音乐
MUSIC_COUNT=$(ls "$WORKSPACE/recommendations/music/" | grep "$TODAY" | wc -l)
if [ $MUSIC_COUNT -gt 0 ]; then
    echo "✅ 今日音乐推荐已存在 ($MUSIC_COUNT 个文件)"
    ls "$WORKSPACE/recommendations/music/" | grep "$TODAY" | sed 's/^/   - /'
else
    echo "⚠️ 今日音乐推荐不存在"
fi

# 检查日报
DAILY_COUNT=$(ls "$WORKSPACE/reports/" | grep "ai-daily-$TODAY" | wc -l)
if [ $DAILY_COUNT -gt 0 ]; then
    echo "✅ 今日AI日报已存在 ($DAILY_COUNT 个文件)"
    ls "$WORKSPACE/reports/" | grep "ai-daily-$TODAY" | sed 's/^/   - /'
else
    echo "⚠️ 今日AI日报不存在"
fi

# 测试4: sync_reports.py 测试
echo ""
echo "【测试4】sync_reports.py 测试"
echo "----------------------------------------"
cd "$WORKSPACE"
if [ -f "sync_reports.py" ]; then
    python3 sync_reports.py 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ sync_reports.py 执行成功"
    else
        echo "❌ sync_reports.py 执行失败"
    fi
else
    echo "❌ sync_reports.py 不存在"
fi

# 测试5: reports.json 检查
echo ""
echo "【测试5】reports.json 检查"
echo "----------------------------------------"
if [ -f "dashboard/reports.json" ]; then
    echo "✅ reports.json 存在"
    # 检查文件大小
    SIZE=$(stat -c%s "dashboard/reports.json" 2>/dev/null || stat -f%z "dashboard/reports.json" 2>/dev/null)
    if [ $SIZE -gt 1000 ]; then
        echo "✅ 文件大小正常 ($SIZE bytes)"
    else
        echo "⚠️ 文件大小异常 ($SIZE bytes)"
    fi
else
    echo "❌ reports.json 不存在"
fi

# 测试6: cron任务配置检查
echo ""
echo "【测试6】cron任务配置检查"
echo "----------------------------------------"
if [ -f "/root/.openclaw/cron/jobs.json" ]; then
    echo "✅ cron jobs.json 存在"
    # 检查sessionTarget配置
    MAIN_COUNT=$(grep -c '"sessionTarget": "main"' /root/.openclaw/cron/jobs.json)
    if [ $MAIN_COUNT -ge 3 ]; then
        echo "✅ 所有任务sessionTarget配置正确 (main)"
    else
        echo "⚠️ 部分任务sessionTarget配置可能不正确"
    fi
else
    echo "❌ cron jobs.json 不存在"
fi

echo ""
echo "=========================================="
echo "测试完成"
echo "=========================================="
