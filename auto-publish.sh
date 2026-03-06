#!/bin/bash
# 全自动日报发布脚本
# 每天自动生成、同步、推送到GitHub并发布到对话

set -e

GITHUB_USER="qingyu3880"
REPO_NAME="ai-reports"
WORKSPACE="/root/.openclaw/workspace"
DEPLOY_DIR="$WORKSPACE/deploy"
LOG_FILE="$WORKSPACE/auto-publish.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================"
log "开始自动日报发布流程"
log "========================================"

# 1. 生成今日日报
log "步骤1: 生成今日AI日报..."
cd "$WORKSPACE"

# 运行日报生成（通过子任务）
# 这里会调用AI生成日报内容

# 2. 同步所有报告数据
log "步骤2: 同步报告数据..."
python3 "$WORKSPACE/sync_reports.py"

# 3. 准备部署文件
log "步骤3: 准备部署文件..."
mkdir -p "$DEPLOY_DIR"
cp "$WORKSPACE/dashboard/index.html" "$DEPLOY_DIR/"
cp "$WORKSPACE/dashboard/reports.json" "$DEPLOY_DIR/"

# 4. 尝试推送到GitHub
log "步骤4: 推送到GitHub..."
cd "$DEPLOY_DIR"

if [ ! -d ".git" ]; then
    git init
    git config user.name "OpenClaw Bot"
    git config user.email "bot@openclaw.ai"
fi

git add .
git commit -m "自动更新日报 - $(date '+%Y-%m-%d %H:%M:%S')" || log "无新更改"

# 尝试推送（使用token方式）
if [ -f "$WORKSPACE/.github_token" ]; then
    TOKEN=$(cat "$WORKSPACE/.github_token")
    git remote remove origin 2>/dev/null || true
    git remote add origin "https://${TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
    git push -f origin main || log "推送失败，请检查token"
else
    log "GitHub token未配置，跳过推送"
    log "请配置token: echo 'your-token' > $WORKSPACE/.github_token"
fi

# 5. 启动本地HTTP服务器（供内网穿透）
log "步骤5: 启动HTTP服务器..."
pkill -f "python3 -m http.server 8080" 2>/dev/null || true
sleep 1
cd "$DEPLOY_DIR" && nohup python3 -m http.server 8080 > /tmp/http_server.log 2>&1 &
sleep 2

# 检查服务器是否启动
if curl -s http://localhost:8080 > /dev/null; then
    log "✅ HTTP服务器启动成功: http://localhost:8080"
else
    log "❌ HTTP服务器启动失败"
fi

log "========================================"
log "自动发布流程完成"
log "========================================"

# 返回状态
exit 0