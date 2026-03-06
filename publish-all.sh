#!/bin/bash
# 全自动日报周报发布系统
# 每天自动发布所有报告到网站和对话

set -e

GITHUB_USER="qingyu3880"
REPO_NAME="ai-reports"
WORKSPACE="/root/.openclaw/workspace"
DEPLOY_DIR="$WORKSPACE/deploy"
LOG_FILE="$WORKSPACE/auto-publish.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 发布到GitHub
publish_to_github() {
    log "推送到GitHub..."
    cd "$DEPLOY_DIR"
    
    if [ ! -d ".git" ]; then
        git init
        git config user.name "OpenClaw Bot"
        git config user.email "bot@openclaw.ai"
    fi
    
    git add .
    git commit -m "自动更新 - $(date '+%Y-%m-%d %H:%M:%S')" || log "无新更改"
    
    # 使用token推送
    if [ -f "$WORKSPACE/.github_token" ]; then
        TOKEN=$(cat "$WORKSPACE/.github_token")
        git remote remove origin 2>/dev/null || true
        git remote add origin "https://${TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
        git branch -m main 2>/dev/null || true
        git push -f origin main || log "推送失败"
    fi
}

# 同步所有报告
sync_all_reports() {
    log "同步所有报告数据..."
    cd "$WORKSPACE"
    python3 sync_reports.py
}

# 主流程
main() {
    log "========================================"
    log "全自动日报周报发布系统"
    log "========================================"
    
    sync_all_reports
    
    # 准备部署文件
    mkdir -p "$DEPLOY_DIR"
    cp "$WORKSPACE/dashboard/index.html" "$DEPLOY_DIR/"
    cp "$WORKSPACE/dashboard/reports.json" "$DEPLOY_DIR/"
    
    publish_to_github
    
    log "✅ 发布完成"
    log "网站: https://${REPO_NAME}.vercel.app"
    log "========================================"
}

main