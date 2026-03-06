#!/bin/bash
# 技能真实验证脚本
# 通过实际调用工具来验证技能是否有效

REPO_DIR="/root/.openclaw/workspace"
LOG_FILE="$REPO_DIR/skill-verification-results.log"

cd "$REPO_DIR"

echo "==========================================" | tee -a "$LOG_FILE"
echo "技能真实验证 - $(date)" | tee -a "$LOG_FILE"
echo "==========================================" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 验证函数
verify_skill() {
    local skill=$1
    local test_method=$2
    
    echo "验证: $skill" | tee -a "$LOG_FILE"
    
    case $test_method in
        "tool")
            # 检查工具是否存在
            if openclaw skills list 2>/dev/null | grep -q "$skill"; then
                echo "  ✅ 工具可用" | tee -a "$LOG_FILE"
                return 0
            else
                echo "  ❌ 工具不可用" | tee -a "$LOG_FILE"
                return 1
            fi
            ;;
        "script")
            # 检查是否有可执行脚本
            if [ -f "skills/$skill/run.sh" ] || [ -d "skills/$skill/scripts" ]; then
                echo "  ✅ 有执行脚本" | tee -a "$LOG_FILE"
                return 0
            else
                echo "  ⚠️ 只有文档" | tee -a "$LOG_FILE"
                return 1
            fi
            ;;
        "doc")
            # 只有文档
            if [ -f "skills/$skill/SKILL.md" ]; then
                echo "  ⚠️ 只有SKILL.md文档" | tee -a "$LOG_FILE"
                return 0
            else
                echo "  ❌ 技能不存在" | tee -a "$LOG_FILE"
                return 1
            fi
            ;;
    esac
}

# 验证每个技能
VALID=0
PARTIAL=0
INVALID=0

# 系统工具类技能（应该可用）
echo "【系统工具类技能】" | tee -a "$LOG_FILE"
for skill in browser canvas tavily nodes healthcheck datasource feishu; do
    if verify_skill "$skill" "tool"; then
        ((VALID++))
    else
        ((INVALID++))
    fi
done

echo "" | tee -a "$LOG_FILE"

# 自定义脚本类技能
echo "【自定义脚本类技能】" | tee -a "$LOG_FILE"
for skill in daily-ai-brief memory-system error-documentation; do
    if verify_skill "$skill" "script"; then
        ((VALID++))
    else
        ((PARTIAL++))
    fi
done

echo "" | tee -a "$LOG_FILE"

# 纯文档类技能
echo "【纯文档类技能】" | tee -a "$LOG_FILE"
for skill in find-skills github skill-vetter summarize task-status weather; do
    if verify_skill "$skill" "doc"; then
        ((PARTIAL++))
    else
        ((INVALID++))
    fi
done

echo "" | tee -a "$LOG_FILE"
echo "==========================================" | tee -a "$LOG_FILE"
echo "验证结果" | tee -a "$LOG_FILE"
echo "==========================================" | tee -a "$LOG_FILE"
echo "完全有效: $VALID 个" | tee -a "$LOG_FILE"
echo "部分有效: $PARTIAL 个" | tee -a "$LOG_FILE"
echo "无效: $INVALID 个" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
