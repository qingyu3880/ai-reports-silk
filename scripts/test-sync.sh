#!/bin/bash
# 完整自动化同步测试脚本
# 测试日报/周报生成后的完整同步流程

set -e

REPO_DIR="/root/.openclaw/workspace"

echo "=========================================="
echo "自动化同步测试脚本"
echo "=========================================="
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

cd "$REPO_DIR"

# Step 1: 运行 sync_reports.py
echo "📦 Step 1: 运行 sync_reports.py 生成 reports.json..."
if python3 sync_reports.py; then
    echo "✅ sync_reports.py 执行成功"
else
    echo "❌ sync_reports.py 执行失败"
    exit 1
fi
echo ""

# Step 2: 检查 reports.json 是否存在且非空
echo "🔍 Step 2: 检查 reports.json..."
if [ -f "dashboard/reports.json" ] && [ -s "dashboard/reports.json" ]; then
    FILE_SIZE=$(ls -lh dashboard/reports.json | awk '{print $5}')
    echo "✅ reports.json 存在，大小: $FILE_SIZE"
else
    echo "❌ reports.json 不存在或为空"
    exit 1
fi
echo ""

# Step 3: 检查文件内容结构
echo "🔍 Step 3: 验证 JSON 结构..."
if python3 -c "import json; data=json.load(open('dashboard/reports.json')); print(f'  - AI日报: {len(data.get(\"daily\", []))} 篇'); print(f'  - 周报: {len(data.get(\"weekly\", []))} 篇'); print(f'  - 图书: {len(data.get(\"books\", []))} 篇'); print(f'  - 音乐: {len(data.get(\"music\", []))} 篇'); print(f'  - 电影: {len(data.get(\"movies\", []))} 篇')"; then
    echo "✅ JSON 结构验证通过"
else
    echo "❌ JSON 结构验证失败"
    exit 1
fi
echo ""

# Step 4: GitHub 推送（如果配置了远程仓库）
echo "🚀 Step 4: 推送到 GitHub..."
if git remote get-url origin &>/dev/null; then
    echo "  检测到远程仓库，执行推送..."
    if bash scripts/github-push.sh; then
        echo "✅ GitHub 推送成功"
    else
        echo "⚠️ GitHub 推送失败（可能是配置问题）"
        echo "  请检查:"
        echo "    1. .github_token 文件是否存在且有效"
        echo "    2. scripts/github-push.sh 中的仓库地址是否正确"
        echo "    3. GitHub 仓库是否存在"
    fi
else
    echo "⚠️ 未配置远程仓库，跳过 GitHub 推送"
    echo "  如需配置，请编辑 scripts/github-push.sh 并设置正确的仓库地址"
fi
echo ""

# Step 5: 总结
echo "=========================================="
echo "测试完成！"
echo "=========================================="
echo ""
echo "✅ 本地同步: 成功"
echo "📁 reports.json 已更新"
echo ""
echo "下一步:"
echo "  1. 访问 https://ai-reports-silk.vercel.app 查看网站"
echo "  2. 确认新内容已显示在首页"
echo ""
