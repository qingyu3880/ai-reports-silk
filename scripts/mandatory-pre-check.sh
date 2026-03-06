#!/bin/bash
# 任务前置强制检查脚本
# 每次执行任务前必须运行，不通过不能继续

REPO_DIR="/root/.openclaw/workspace"

cd "$REPO_DIR"

echo "=========================================="
echo "任务前置强制检查"
echo "=========================================="
echo ""

# 1. 读取标准流程
echo "【1/4】读取标准任务流程..."
if [ -f "skills/standard-task-workflow/SKILL.md" ]; then
    echo "✅ 标准流程文件存在"
    echo ""
    echo "核心原则："
    grep "^### 1. 开始前" -A 10 skills/standard-task-workflow/SKILL.md | head -15
else
    echo "❌ 标准流程文件不存在"
    exit 1
fi
echo ""

# 2. 检查今日错误
echo "【2/4】检查今日错误记录..."
today=$(date +%Y-%m-%d)
error_count=$(grep -l "$today" skills/error-documentation/ERROR_*.md 2>/dev/null | wc -l)
if [ $error_count -gt 0 ]; then
    echo "⚠️ 今天有 $error_count 个错误记录"
    grep -l "$today" skills/error-documentation/ERROR_*.md
    echo ""
    echo "请阅读这些错误，避免重复："
    for f in $(grep -l "$today" skills/error-documentation/ERROR_*.md); do
        echo "  - $f"
    done
else
    echo "✅ 今天没有新错误"
fi
echo ""

# 3. 确认理解
echo "【3/4】确认理解核心原则..."
echo ""
echo "你必须确认："
echo "  1. 不靠记忆，靠文件"
echo "  2. 不假设，只验证"
echo "  3. 完成意味着用户收到"
echo ""

# 4. 任务类型检查
echo "【4/4】任务类型特定检查..."
echo ""
echo "常见任务类型："
echo "  1. 内容生成（日报/推荐）"
echo "  2. 技能安装"
echo "  3. 同步推送"
echo ""
read -p "请输入任务类型 (1/2/3): " task_type

case $task_type in
    1)
        echo ""
        echo "内容生成任务强制要求："
        echo "  ✅ 文件保存"
        echo "  ✅ 推送到对话框（完整内容）"
        echo "  ✅ 用户确认收到"
        echo "  ✅ Git提交"
        echo "  ✅ Git推送"
        echo ""
        echo "推送前必须："
        echo "  1. 统计源文件行数: wc -l < 文件"
        echo "  2. 推送完整内容到对话"
        echo "  3. 询问用户是否收到"
        echo ""
        ;;
    2)
        echo "技能安装任务强制要求："
        echo "  ✅ 验证技能真实存在"
        echo "  ✅ 验证工具可调用"
        echo "  ✅ 不依赖虚假报告"
        ;;
    3)
        echo "同步推送任务强制要求："
        echo "  ✅ 验证未推送提交"
        echo "  ✅ 推送后验证远程"
        echo "  ✅ 确认同步成功"
        ;;
    *)
        echo "未知任务类型"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "前置检查完成"
echo "=========================================="
echo ""
echo "记住："
echo "  - 严格按照流程执行"
echo "  - 每一步都要验证"
echo "  - 用户确认才算完成"
echo ""
