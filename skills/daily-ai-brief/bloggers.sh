#!/bin/bash
# AI Daily Brief - Batch Search Script
# 批量搜索各个博主的最新内容

set -e

DATE=$(date +%Y-%m-%d)

echo "🔍 Batch searching AI bloggers for $DATE..."

# 定义博主列表
PROMPT_BLOGGERS=("宝玉AI" "李继刚" "云中江树" "向阳乔木" "一泽" "财猫" "云舒" "甲木" "归藏的AI工具箱")
DESIGN_BLOGGERS=("汗青AI" "海辛和阿文" "闲人一坤" "阿真Irene" "TATALAB" "老秦AI")
TECH_BLOGGERS=("艾逗笔" "苍何" "袋鼠帝" "刘聪NLP" "花叔" "梦飞" "刘小排" "饼干哥哥" "浮之静" "孔某人")
PRODUCT_BLOGGERS=("AI产品阿颖" "洛小山" "AI产品银海" "AI产品黄叔" "hanniman" "南瓜博士" "少卿" "小水" "王树义" "快刀青衣" "Max")
TUTORIAL_BLOGGERS=("摸鱼小李" "Rico有三猫" "栗噔噔" "瓦叔" "AIGC新知" "Loki")

# 合并所有博主
ALL_BLOGGERS=("${PROMPT_BLOGGERS[@]}" "${DESIGN_BLOGGERS[@]}" "${TECH_BLOGGERS[@]}" "${PRODUCT_BLOGGERS[@]}" "${TUTORIAL_BLOGGERS[@]}")

echo "📊 Total bloggers to search: ${#ALL_BLOGGERS[@]}"
echo ""
echo "Categories:"
echo "  - Prompt & Agent: ${#PROMPT_BLOGGERS[@]}"
echo "  - Design: ${#DESIGN_BLOGGERS[@]}"
echo "  - Tech: ${#TECH_BLOGGERS[@]}"
echo "  - Product: ${#PRODUCT_BLOGGERS[@]}"
echo "  - Tutorial: ${#TUTORIAL_BLOGGERS[@]}"
echo ""

# 注意：实际搜索由 agent 使用 kimi_search 工具执行
# 这个脚本用于记录和分类

echo "✅ Blogger list ready for agent search"
