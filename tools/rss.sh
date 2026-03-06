#!/bin/bash
# Simple RSS Fetcher - 简易 RSS 抓取脚本
# 无需安装额外软件，使用 curl + grep/sed 解析

RSS_DIR="$HOME/.rss-feeds"
mkdir -p "$RSS_DIR"

# RSS 源配置
fetch_rss() {
    local name=$1
    local url=$2
    local output="$RSS_DIR/${name}.xml"
    
    echo "📡 Fetching: $name"
    curl -sL "$url" -o "$output" 2>/dev/null && echo "  ✅ Saved to $output" || echo "  ❌ Failed"
}

# 显示最近的条目
show_recent() {
    local name=$1
    local file="$RSS_DIR/${name}.xml"
    
    if [ -f "$file" ]; then
        echo ""
        echo "📰 $name - Recent Items:"
        grep -oP '(?=<title>).*?(?=</title>)' "$file" 2>/dev/null | head -5 | sed 's/<title>//;s/<\/title>//' | sed 's/^/  - /'
    fi
}

# 主菜单
case "${1:-menu}" in
    fetch)
        echo "🔄 Fetching all RSS feeds..."
        fetch_rss "lexfridman" "https://lexfridman.com/feed/podcast/"
        fetch_rss "openai" "https://openai.com/blog/rss.xml"
        fetch_rss "techcrunch-ai" "https://techcrunch.com/category/artificial-intelligence/feed/"
        echo "✅ Done!"
        ;;
    list)
        for f in "$RSS_DIR"/*.xml; do
            [ -f "$f" ] && show_recent "$(basename "$f" .xml)"
        done
        ;;
    *)
        echo "📡 Simple RSS Fetcher"
        echo ""
        echo "Usage:"
        echo "  ./rss.sh fetch    - 抓取所有 RSS 源"
        echo "  ./rss.sh list     - 显示最近条目"
        echo ""
        echo "Feeds configured:"
        echo "  - Lex Fridman Podcast"
        echo "  - OpenAI Blog"
        echo "  - TechCrunch AI"
        ;;
esac
