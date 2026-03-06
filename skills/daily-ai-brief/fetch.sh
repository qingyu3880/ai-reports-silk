#!/bin/bash
# AI Daily Brief - Source Fetcher
# 抓取各类 RSS 和搜索源

set -e

WORKSPACE="/root/.openclaw/workspace"
DATA_DIR="$WORKSPACE/data/daily-ai-brief"
DATE=$(date +%Y-%m-%d)

echo "📡 Fetching AI sources for $DATE..."
mkdir -p "$DATA_DIR/$DATE"

# 1. 抓取 RSS 源（如果有 curl）
fetch_rss() {
    local name=$1
    local url=$2
    local output="$DATA_DIR/$DATE/rss_${name}.xml"
    
    echo "  📰 Fetching RSS: $name"
    curl -sL "$url" -o "$output" 2>/dev/null || echo "    ⚠️ Failed: $name"
}

# 2. 抓取网页（通用）
fetch_web() {
    local name=$1
    local url=$2
    local output="$DATA_DIR/$DATE/web_${name}.html"
    
    echo "  🌐 Fetching Web: $name"
    curl -sL "$url" -o "$output" 2>/dev/null || echo "    ⚠️ Failed: $name"
}

# 3. 搜索抓取（通过 kimi_search，由 agent 调用）
# 这部分在 agent 层实现

echo "✅ Source fetch preparation complete"
echo "📁 Data directory: $DATA_DIR/$DATE"
