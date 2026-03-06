#!/bin/bash
# 修复后的报告推送脚本
# 解决Error #005: 推送失败问题

set -e

REPO_DIR="/root/.openclaw/workspace"
LOG_FILE="$REPO_DIR/push-repair.log"

cd "$REPO_DIR"

echo "[$(date)] 开始推送修复..." | tee -a "$LOG_FILE"

# 检查未推送的提交
unpushed=$(git log origin/main..master --oneline | wc -l)
if [ "$unpushed" -eq 0 ]; then
    echo "[$(date)] ✅ 没有未推送的提交" | tee -a "$LOG_FILE"
    exit 0
fi

echo "[$(date)] 发现 $unpushed 个未推送提交" | tee -a "$LOG_FILE"
git log origin/main..master --oneline | tee -a "$LOG_FILE"

# 推送带重试
for i in 1 2 3; do
    echo "[$(date)] 推送尝试 $i/3..." | tee -a "$LOG_FILE"
    
    if timeout 120 git push origin master:main 2>&1 | tee -a "$LOG_FILE"; then
        echo "[$(date)] ✅ 推送成功" | tee -a "$LOG_FILE"
        
        # 验证推送
        sleep 2
        if git fetch origin main 2>/dev/null; then
            remaining=$(git log origin/main..master --oneline | wc -l)
            if [ "$remaining" -eq 0 ]; then
                echo "[$(date)] ✅ 验证成功，所有提交已推送" | tee -a "$LOG_FILE"
                exit 0
            else
                echo "[$(date)] ⚠️ 仍有 $remaining 个提交未推送" | tee -a "$LOG_FILE"
            fi
        fi
    else
        echo "[$(date)] ❌ 推送失败，等待30秒后重试..." | tee -a "$LOG_FILE"
        sleep 30
    fi
done

echo "[$(date)] ❌ 推送失败，已达最大重试次数" | tee -a "$LOG_FILE"
exit 1
