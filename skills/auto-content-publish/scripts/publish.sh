#!/bin/bash
#
# 全自动内容发布脚本
# 强制流程：检查 → 生成 → 保存 → 推送 → 同步
# 任何一步失败立即退出

set -euo pipefail  # 严格模式：任何错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 获取当前时间
HOUR=$(date +%H)
WEEKDAY=$(date +%u)  # 1=周一, 7=周日
DATE_STR=$(date +%Y-%m-%d)

# 工作目录
WORKSPACE="/root/.openclaw/workspace"

detect_content_type() {
    case $HOUR in
        08)
            echo "music"
            ;;
        09)
            if [ "$WEEKDAY" -eq 1 ]; then
                echo "airline-weekly"
            else
                echo "ai-daily"
            fi
            ;;
        17)
            echo "book"
            ;;
        20)
            echo "movie"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# 检查今天是否已有文件
check_existing() {
    local content_type=$1
    local search_path=""
    
    case $content_type in
        music)
            search_path="$WORKSPACE/recommendations/music/*$DATE_STR*"
            ;;
        ai-daily)
            search_path="$WORKSPACE/reports/ai-daily-$DATE_STR*"
            ;;
        book)
            search_path="$WORKSPACE/recommendations/books/*$DATE_STR*"
            ;;
        movie)
            search_path="$WORKSPACE/recommendations/movies/*$DATE_STR*"
            ;;
        airline-weekly)
            search_path="$WORKSPACE/reports/airline-ai/weekly-$DATE_STR*"
            ;;
    esac
    
    if [ -n "$search_path" ]; then
        local existing=$(ls $search_path 2>/dev/null | head -1)
        if [ -n "$existing" ]; then
            echo "$existing"
            return 0
        fi
    fi
    return 1
}

# 主流程
main() {
    log_info "开始内容发布流程 - $(date)"
    
    # 检测内容类型
    CONTENT_TYPE=$(detect_content_type)
    if [ "$CONTENT_TYPE" = "unknown" ]; then
        log_warn "当前时间($HOUR:00)无对应内容类型，跳过"
        exit 0
    fi
    
    log_info "检测到的内容类型: $CONTENT_TYPE"
    
    # 检查是否已存在
    EXISTING_FILE=$(check_existing "$CONTENT_TYPE" || true)
    if [ -n "$EXISTING_FILE" ]; then
        log_info "今天已有内容: $EXISTING_FILE"
        log_info "读取并推送现有内容..."
        # 这里应该调用推送逻辑
        exit 0
    fi
    
    log_info "今天尚无内容，需要生成"
    
    # 步骤1-4由主代理通过子任务完成
    # 此脚本仅做检查和触发
    log_info "触发内容生成任务..."
    
    # 返回内容类型，供主代理决策
    echo "NEED_GENERATE:$CONTENT_TYPE"
}

main "$@"
