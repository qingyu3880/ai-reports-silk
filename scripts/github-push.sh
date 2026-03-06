#!/bin/bash
# GitHub 自动推送脚本
# 用于日报/周报生成后自动推送到 GitHub，触发 Vercel 自动部署
#
# 使用方法:
# 1. 在 GitHub 创建仓库 (如: yourusername/ai-reports)
# 2. 更新下面的 GITHUB_REPO 变量
# 3. 确保 .github_token 文件包含有效的 GitHub Personal Access Token
# 4. 运行 chmod +x scripts/github-push.sh

set -e

REPO_DIR="/root/.openclaw/workspace"
# ==========================================
# ⚠️ 重要: 请修改下面的仓库地址为你的实际仓库
# ==========================================
GITHUB_USER="ai-reports"  # 替换为你的 GitHub 用户名
GITHUB_REPO_NAME="ai-reports-silk"  # 替换为你的仓库名
GITHUB_REPO="github.com/${GITHUB_USER}/${GITHUB_REPO_NAME}.git"
BRANCH="main"
TOKEN_FILE="${REPO_DIR}/.github_token"

echo "=========================================="
echo "GitHub 自动推送脚本"
echo "=========================================="
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "目标仓库: ${GITHUB_REPO}"
echo ""

cd "$REPO_DIR"

# 检查 token 文件
if [ ! -f "$TOKEN_FILE" ]; then
    echo "❌ 错误: 未找到 GitHub Token 文件: $TOKEN_FILE"
    echo "请创建该文件并添加你的 GitHub Personal Access Token"
    exit 1
fi

TOKEN=$(cat "$TOKEN_FILE" | tr -d '[:space:]')
if [ -z "$TOKEN" ]; then
    echo "❌ 错误: Token 文件为空"
    exit 1
fi

# 配置远程仓库（如果不存在）
REMOTE_URL="https://x-access-token:${TOKEN}@${GITHUB_REPO}"
if ! git remote get-url origin &>/dev/null; then
    echo "🔗 配置远程仓库..."
    git remote add origin "$REMOTE_URL"
else
    echo "🔗 更新远程仓库 URL..."
    git remote set-url origin "$REMOTE_URL"
fi

# 检查是否有变更
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ 没有需要提交的变更"
    exit 0
fi

# 添加所有变更
echo "📦 添加文件到暂存区..."
git add -A

# 提交变更
COMMIT_MSG="Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
echo "📝 提交变更: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

# 推送到 GitHub
echo "🚀 推送到 GitHub..."
if git push origin "$BRANCH" 2>&1; then
    echo ""
    echo "✅ 推送成功！"
    echo "🌐 Vercel 将自动部署更新"
    echo "网站地址: https://ai-reports-silk.vercel.app"
else
    echo ""
    echo "❌ 推送失败"
    echo "可能的原因:"
    echo "  1. 仓库不存在，需要在 GitHub 创建"
    echo "  2. Token 权限不足"
    echo "  3. 网络连接问题"
    exit 1
fi

echo "=========================================="
