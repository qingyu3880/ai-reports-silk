#!/bin/bash
# Sanwan.ai 技能安装脚本 - 每小时检查安装

REPO_DIR="/root/.openclaw/workspace"
LOG_FILE="$REPO_DIR/skill-install-progress.log"

cd "$REPO_DIR"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ==========================================" | tee -a "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Sanwan.ai 技能安装检查" | tee -a "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] ==========================================" | tee -a "$LOG_FILE"

# 技能列表（40个核心技能）
SKILLS=(
    "skill-vetter" "find-skills" "github" "tavily-search" "summarize"
    "feishu-doc" "email-manager" "task-status" "weather" "browser-control"
    "coding-agent" "deep-research" "image-gen" "tts" "voice-clone"
    "pdf-gen" "seo-writer" "report-gen" "train-ticket" "flight"
    "stock-monitor" "text-humanize" "anti-crawl" "feishu-card" "calendar"
    "wechat-mp" "blog-writer" "xiaohongshu" "video-summarize" "web-extract"
    "competitor-research" "hot-trends" "hacker-news" "twitter-x" "project-mgmt"
    "automation-workflow" "capability-evolver" "security-audit" "stock-analysis" "hk-stock-research"
)

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 目标技能数: ${#SKILLS[@]}" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 统计当前状态
installed=0
pending=()

for skill in "${SKILLS[@]}"; do
    if [ -d "skills/$skill" ]; then
        ((installed++))
    else
        pending+=("$skill")
    fi
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 当前状态: 已安装 $installed / ${#SKILLS[@]}" | tee -a "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 待安装: ${#pending[@]}" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 如果全部完成
if [ ${#pending[@]} -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ 所有技能已安装完成！" | tee -a "$LOG_FILE"
    echo "SANWAN_COMPLETE" > "$REPO_DIR/.sanwan_complete"
    exit 0
fi

# 尝试安装前3个待安装技能
to_install=(${pending[@]:0:3})
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 本次尝试安装: ${to_install[*]}" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

for skill in "${to_install[@]}"; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 安装: $skill ..." | tee -a "$LOG_FILE"
    
    if npx clawhub@latest install "$skill" 2>&1 | tee -a "$LOG_FILE"; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')]   ✅ $skill 成功" | tee -a "$LOG_FILE"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')]   ❌ $skill 失败" | tee -a "$LOG_FILE"
    fi
    
    sleep 15
done

echo "" | tee -a "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 本次检查完成" | tee -a "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 下次检查: 1小时后" | tee -a "$LOG_FILE"
