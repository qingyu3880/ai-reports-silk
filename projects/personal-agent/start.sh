#!/bin/bash
# Personal Agent 一键启动脚本

set -e

echo "🚀 Personal Agent 启动脚本"
echo ""

# 检查环境
check_env() {
    echo "📋 检查环境..."
    
    # 检查 OpenClaw
    if ! command -v openclaw &> /dev/null; then
        echo "❌ OpenClaw 未安装"
        echo "   安装: npm install -g openclaw"
        exit 1
    fi
    echo "✅ OpenClaw 已安装"
    
    # 检查环境变量
    if [ -z "$DISCORD_TOKEN" ]; then
        echo "⚠️  DISCORD_TOKEN 未设置"
        echo "   设置: export DISCORD_TOKEN='你的Token'"
    else
        echo "✅ DISCORD_TOKEN 已设置"
    fi
    
    if [ -z "$KIMI_API_KEY" ]; then
        echo "⚠️  KIMI_API_KEY 未设置"
        echo "   获取: https://build.nvidia.com"
    else
        echo "✅ KIMI_API_KEY 已设置"
    fi
    
    echo ""
}

# 安装技能
install_skills() {
    echo "🔧 安装技能..."
    
    SKILLS_DIR="$HOME/.openclaw/workspace/skills"
    PROJECT_DIR="$(dirname "$0")"
    
    # 复制技能文件
    for skill in vision-coach-1y strategy-navigator-3m executer-1m knowledge-zettelkasten spaced-repetition-sm2; do
        if [ -d "$PROJECT_DIR/skills/$skill" ]; then
            cp -r "$PROJECT_DIR/skills/$skill" "$SKILLS_DIR/"
            echo "  ✅ 安装: $skill"
        fi
    done
    
    echo ""
}

# 创建目录结构
setup_dirs() {
    echo "📁 创建目录结构..."
    
    mkdir -p "$HOME/.openclaw/workspace/projects/personal-agent"
    mkdir -p "$HOME/.openclaw/workspace/knowledge/cards"
    mkdir -p "$HOME/.openclaw/workspace/knowledge/tags"
    mkdir -p "$HOME/.openclaw/workspace/diary"
    mkdir -p "$HOME/.openclaw/workspace/memory"
    
    echo "  ✅ 目录创建完成"
    echo ""
}

# 启动服务
start_agent() {
    echo "🚀 启动 Personal Agent..."
    
    # 检查是否已在运行
    if pgrep -f "openclaw gateway" > /dev/null; then
        echo "⚠️  OpenClaw 已在运行"
        echo "   重启: openclaw gateway restart"
    else
        openclaw gateway start
        echo "✅ OpenClaw 已启动"
    fi
    
    echo ""
    echo "📱 在 Discord 中测试:"
    echo "   @你的Bot名 你好"
    echo ""
}

# 主菜单
main() {
    case "${1:-setup}" in
        setup)
            check_env
            setup_dirs
            install_skills
            echo "✅ 设置完成！"
            echo ""
            echo "下一步:"
            echo "1. 设置环境变量 (DISCORD_TOKEN, KIMI_API_KEY)"
            echo "2. 运行: $0 start"
            ;;
        start)
            start_agent
            ;;
        status)
            openclaw status
            ;;
        stop)
            openclaw gateway stop
            echo "✅ 已停止"
            ;;
        *)
            echo "Usage: $0 {setup|start|status|stop}"
            ;;
    esac
}

main "$@"
