#!/bin/bash
# 一键恢复脚本
# 恢复所有日报配置和防错机制

echo "=========================================="
echo "AI日报系统一键恢复"
echo "=========================================="
echo ""

REPO_DIR="/root/.openclaw/workspace"
cd "$REPO_DIR"

# 1. 检查必要文件
echo "【1/5】检查必要文件..."
required_files=(
    "DAILY_REPORT_COMPLETE_PACKAGE.md"
    "SIMPLE_CHECKLIST.md"
    "scripts/mandatory-pre-check.sh"
    "scripts/auto-verify-push.sh"
    "scripts/daily-self-check.sh"
    "skills/anti-error-mechanism/SKILL.md"
)

missing=0
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "  ❌ 缺失: $file"
        ((missing++))
    else
        echo "  ✅ 存在: $file"
    fi
done

if [ $missing -gt 0 ]; then
    echo ""
    echo "⚠️  有 $missing 个必要文件缺失"
    echo "请从GitHub重新克隆仓库"
    exit 1
fi

echo ""
echo "✅ 所有必要文件存在"
echo ""

# 2. 设置权限
echo "【2/5】设置脚本权限..."
chmod +x scripts/*.sh
echo "✅ 脚本权限已设置"
echo ""

# 3. 运行自检
echo "【3/5】运行系统自检..."
bash scripts/daily-self-check.sh
echo ""

# 4. 显示核心原则
echo "【4/5】核心原则提醒..."
echo ""
echo "═══════════════════════════════════════════════════"
echo "  核心原则（必须遵守）"
echo "═══════════════════════════════════════════════════"
echo ""
echo "  1. 不靠记忆，靠文件"
echo "  2. 不假设，只验证"
echo "  3. 完成意味着用户收到"
echo "  4. 强制执行力"
echo ""
echo "═══════════════════════════════════════════════════"
echo ""

# 5. 显示使用说明
echo "【5/5】使用说明..."
echo ""
echo "生成日报的标准流程："
echo ""
echo "  1. 运行前置检查:"
echo "     bash scripts/mandatory-pre-check.sh"
echo ""
echo "  2. 选择任务类型: 1 (内容生成)"
echo ""
echo "  3. 按照SIMPLE_CHECKLIST.md执行"
echo ""
echo "  4. 推送到对话框（完整内容）"
echo ""
echo "  5. 运行自动验证:"
echo "     bash scripts/auto-verify-push.sh"
echo ""
echo "  6. 等待用户确认"
echo ""
echo "  7. Git提交推送"
echo ""
echo "详细说明请查看:"
echo "  - DAILY_REPORT_COMPLETE_PACKAGE.md (完整打包)"
echo "  - SIMPLE_CHECKLIST.md (简化清单)"
echo ""

echo "=========================================="
echo "恢复完成！"
echo "=========================================="
