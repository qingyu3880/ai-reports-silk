#!/bin/bash
# 技能批量安装脚本
# 由于ClawHub速率限制，需要分批安装

echo "=========================================="
echo "技能批量安装脚本"
echo "=========================================="
echo ""

# 技能列表（按优先级排序）
SKILLS=(
    "skill-vetter"           # 安全扫描
    "find-skills"            # 技能发现
    "github"                 # GitHub集成
    "summarize"              # 文本总结
    "task-status"            # 任务状态
    "weather"                # 天气查询
    "capability-evolver"     # 能力进化
    "cognitive-memory"       # 认知记忆
    "essence-distiller"      # 核心提取
    "hour-meter"             # 时间追踪
    "voice-reply"            # 语音回复
)

INSTALL_DELAY=30  # 每次安装间隔30秒

echo "计划安装 ${#SKILLS[@]} 个技能:"
for i in "${!SKILLS[@]}"; do
    echo "  $((i+1)). ${SKILLS[$i]}"
done
echo ""

# 安装函数
install_skill() {
    local skill=$1
    local num=$2
    local total=$3
    
    echo "[$num/$total] 安装 $skill..."
    
    if npx clawhub@latest install "$skill" 2>&1; then
        echo "  ✅ $skill 安装成功"
        return 0
    else
        echo "  ❌ $skill 安装失败"
        return 1
    fi
}

# 批量安装
SUCCESS=0
FAILED=0

for i in "${!SKILLS[@]}"; do
    skill="${SKILLS[$i]}"
    num=$((i+1))
    
    if install_skill "$skill" "$num" "${#SKILLS[@]}"; then
        ((SUCCESS++))
    else
        ((FAILED++))
    fi
    
    # 如果不是最后一个，等待一段时间
    if [ $num -lt ${#SKILLS[@]} ]; then
        echo "  等待 ${INSTALL_DELAY} 秒..."
        sleep $INSTALL_DELAY
    fi
done

echo ""
echo "=========================================="
echo "安装完成"
echo "=========================================="
echo "成功: $SUCCESS 个"
echo "失败: $FAILED 个"
echo ""

if [ $FAILED -gt 0 ]; then
    echo "失败的技能可以稍后重试:"
    echo "  bash scripts/install-skills.sh"
fi
