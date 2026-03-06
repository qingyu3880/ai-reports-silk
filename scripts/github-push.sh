#!/bin/bash
# GitHub 自动推送脚本
# 用于日报/周报生成后自动推送到 GitHub，触发 Vercel 自动部署

set -e

REPO_DIR="/root/.openclaw/workspace"
GITHUB_USER="qingyu3880"
GITHUB_REPO_NAME="ai-reports-silk"
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
    exit 1
fi

TOKEN=$(cat "$TOKEN_FILE" | tr -d '[:space:]')
if [ -z "$TOKEN" ]; then
    echo "❌ 错误: Token 文件为空"
    exit 1
fi

# 配置远程仓库
REMOTE_URL="https://x-access-token:${TOKEN}@${GITHUB_REPO}"
echo "🔗 配置远程仓库..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE_URL"

# 获取远程分支
echo "📥 获取远程分支信息..."
git fetch origin main 2>/dev/null || echo "  远程分支为空或不存在"

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
if git push -u origin master:main 2>&1; then
    echo ""
    echo "✅ 推送成功！"
    echo "🌐 Vercel 将自动部署更新"
    echo "网站地址: https://ai-reports-silk.vercel.app"
    echo "仓库地址: https://github.com/${GITHUB_USER}/${GITHUB_REPO_NAME}"
else
    echo ""
    echo "❌ 推送失败"
    exit 1
fi

echo "=========================================="
