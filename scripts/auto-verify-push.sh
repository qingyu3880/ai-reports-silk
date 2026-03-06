#!/bin/bash
# 推送内容自动验证脚本
# 推送后自动检查内容完整性

REPO_DIR="/root/.openclaw/workspace"

cd "$REPO_DIR"

# 获取推送的文件（从git状态）
files=$(git diff --name-only HEAD~1 HEAD 2>/dev/null | grep -E "\.(md|json)$" || echo "")

if [ -z "$files" ]; then
    echo "没有检测到推送的文件"
    exit 0
fi

echo "=========================================="
echo "推送内容自动验证"
echo "=========================================="
echo ""

for file in $files; do
    echo "验证: $file"
    
    if [ ! -f "$file" ]; then
        echo "  ❌ 文件不存在"
        continue
    fi
    
    # 统计源文件
    source_lines=$(wc -l < "$file")
    source_chars=$(wc -c < "$file")
    
    echo "  源文件: $source_lines 行, $source_chars 字符"
    
    # 如果是markdown文件，给出警告
    if [[ "$file" == *.md ]]; then
        if [ $source_lines -gt 100 ]; then
            echo "  ⚠️  文件较长($source_lines行)，确保完整推送到对话"
        fi
    fi
    
    echo ""
done

echo "=========================================="
echo "验证完成"
echo "=========================================="
echo ""
echo "下一步："
echo "  1. 将上述文件完整推送到对话框"
echo "  2. 询问用户是否收到完整内容"
echo "  3. 用户确认后任务才算完成"
echo ""
