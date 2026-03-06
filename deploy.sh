#!/bin/bash
# 自动同步并部署到Vercel

echo "========================================"
echo "AI日报中心 - 自动同步部署"
echo "========================================"

# 1. 运行同步脚本
echo ""
echo "📥 正在同步报告数据..."
cd /root/.openclaw/workspace
python3 sync_reports.py

# 2. 复制文件到GitHub仓库目录
echo ""
echo "📦 准备部署文件..."
REPO_DIR="/root/.openclaw/workspace/ai-reports-silk"

# 如果目录不存在，克隆仓库
if [ ! -d "$REPO_DIR" ]; then
    echo "克隆GitHub仓库..."
    git clone https://github.com/你的用户名/ai-reports-silk.git "$REPO_DIR" 2>/dev/null || echo "请手动克隆仓库"
fi

# 复制文件
cp /root/.openclaw/workspace/dashboard/index.html "$REPO_DIR/"
cp /root/.openclaw/workspace/dashboard/reports.json "$REPO_DIR/" 2>/dev/null || echo "reports.json 不存在"

echo ""
echo "✅ 文件准备完成！"
echo ""
echo "下一步："
echo "1. 进入目录: cd $REPO_DIR"
echo "2. 提交更改: git add . && git commit -m '更新报告数据'"
echo "3. 推送到GitHub: git push origin main"
echo ""
echo "Vercel会自动部署更新后的网站"
echo "========================================"