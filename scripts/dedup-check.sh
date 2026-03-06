#!/bin/bash
# AI日报去重检查脚本
# 用法: ./dedup-check.sh "新闻标题"

REPORTS_DIR="/root/.openclaw/workspace/reports"
DAYS_TO_CHECK=7

if [ -z "$1" ]; then
    echo "用法: $0 \"新闻标题\""
    exit 1
fi

TITLE="$1"
FOUND=0

# 检查最近7天的日报
for i in $(seq 0 $DAYS_TO_CHECK); do
    DATE=$(date -d "$i days ago" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d)
    FILE="$REPORTS_DIR/ai-daily-$DATE.md"
    
    if [ -f "$FILE" ]; then
        if grep -i "$TITLE" "$FILE" > /dev/null 2>&1; then
            echo "[重复] 在 $DATE 日报中找到: $TITLE"
            FOUND=1
            break
        fi
    fi
done

if [ $FOUND -eq 0 ]; then
    echo "[新内容] $TITLE"
fi

exit $FOUND