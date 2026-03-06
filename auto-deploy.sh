#!/bin/bash
# 完整自动同步部署脚本
# 用法: ./auto-deploy.sh <你的GitHub用户名>

set -e

GITHUB_USER=${1:-""}
REPO_NAME="ai-reports-silk"
WORKSPACE="/root/.openclaw/workspace"
REPO_DIR="$WORKSPACE/$REPO_NAME"

if [ -z "$GITHUB_USER" ]; then
    echo "❌ 请提供GitHub用户名"
    echo "用法: ./auto-deploy.sh your-github-username"
    exit 1
fi

echo "========================================"
echo "AI日报中心 - 自动同步部署"
echo "========================================"
echo "GitHub用户: $GITHUB_USER"
echo "仓库: $REPO_NAME"
echo ""

# 1. 同步报告数据
echo "📥 步骤1: 同步报告数据..."
cd $WORKSPACE
python3 sync_reports.py

# 2. 准备仓库
echo ""
echo "📦 步骤2: 准备GitHub仓库..."
if [ ! -d "$REPO_DIR" ]; then
    echo "克隆仓库..."
    git clone "https://github.com/$GITHUB_USER/$REPO_NAME.git" "$REPO_DIR" || {
        echo "❌ 克隆失败，请确认:"
        echo "   1. GitHub用户名正确: $GITHUB_USER"
        echo "   2. 仓库已创建: https://github.com/$GITHUB_USER/$REPO_NAME"
        exit 1
    }
fi

cd "$REPO_DIR"

# 3. 更新网站文件
echo ""
echo "📝 步骤3: 更新网站文件..."

# 创建增强版index.html，支持从JSON加载数据
cat > index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI 日报中心</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans SC', sans-serif; }
        .fade-in { animation: fadeIn 0.3s ease-in; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .markdown-body { line-height: 1.8; }
        .markdown-body h1 { font-size: 2rem; font-weight: 700; margin: 1.5rem 0 1rem; }
        .markdown-body h2 { font-size: 1.5rem; font-weight: 600; margin: 1.25rem 0 0.75rem; }
        .markdown-body h3 { font-size: 1.25rem; font-weight: 600; margin: 1rem 0 0.5rem; }
        .markdown-body p { margin: 0.75rem 0; }
        .markdown-body ul { list-style-type: disc; margin: 0.75rem 0; padding-left: 1.5rem; }
        .markdown-body blockquote { border-left: 4px solid #e5e7eb; padding-left: 1rem; margin: 1rem 0; color: #6b7280; }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
    <div id="app"></div>
    
    <script>
        let reportsData = { daily: [], weekly: [], books: [] };
        let currentView = 'home';
        let selectedType = 'all';
        let selectedReport = null;

        // 加载数据
        async function loadData() {
            try {
                const response = await fetch('reports.json');
                reportsData = await response.json();
                render();
            } catch (e) {
                console.error('加载数据失败:', e);
                document.getElementById('app').innerHTML = '<div class="p-10 text-center text-red-600">加载失败，请刷新重试</div>';
            }
        }

        function render() {
            const app = document.getElementById('app');
            if (currentView === 'home') {
                app.innerHTML = renderHome();
            } else if (currentView === 'list') {
                app.innerHTML = renderList();
            } else if (currentView === 'detail') {
                app.innerHTML = renderDetail();
            }
        }

        function renderHome() {
            const total = (reportsData.daily?.length || 0) + 
                         (reportsData.weekly?.length || 0) + 
                         (reportsData.books?.length || 0);
            
            return `
                <header class="bg-gradient-to-r from-blue-600 to-indigo-700 text-white shadow-lg">
                    <div class="max-w-7xl mx-auto px-4 py-12">
                        <h1 class="text-5xl font-bold mb-4">📊 AI 日报中心</h1>
                        <p class="text-blue-100 text-xl">汇聚全球AI动态，洞察技术趋势</p>
                        <div class="mt-6 text-sm text-blue-200">
                            最后更新: ${reportsData.lastUpdated ? new Date(reportsData.lastUpdated).toLocaleString('zh-CN') : '未知'}
                        </div>
                    </div>
                </header>

                <main class="max-w-7xl mx-auto px-4 py-10">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
                        <div onclick="showList('all')" class="bg-white rounded-2xl shadow-md p-6 border-l-4 border-blue-500 hover:shadow-lg transition cursor-pointer">
                            <div class="text-4xl font-bold text-gray-800">${total}</div>
                            <div class="text-gray-500 mt-1">总报告数</div>
                        </div>
                        <div onclick="showList('daily')" class="bg-white rounded-2xl shadow-md p-6 border-l-4 border-green-500 hover:shadow-lg transition cursor-pointer">
                            <div class="text-4xl font-bold text-gray-800">${reportsData.daily?.length || 0}</div>
                            <div class="text-gray-500 mt-1">AI日报</div>
                        </div>
                        <div onclick="showList('weekly')" class="bg-white rounded-2xl shadow-md p-6 border-l-4 border-purple-500 hover:shadow-lg transition cursor-pointer">
                            <div class="text-4xl font-bold text-gray-800">${reportsData.weekly?.length || 0}</div>
                            <div class="text-gray-500 mt-1">行业周报</div>
                        </div>
                        <div onclick="showList('books')" class="bg-white rounded-2xl shadow-md p-6 border-l-4 border-orange-500 hover:shadow-lg transition cursor-pointer">
                            <div class="text-4xl font-bold text-gray-800">${reportsData.books?.length || 0}</div>
                            <div class="text-gray-500 mt-1">图书推荐</div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div onclick="showList('daily')" class="bg-white rounded-2xl shadow-md p-8 cursor-pointer hover:shadow-xl hover:scale-105 transition transform">
                            <div class="text-5xl mb-4">📰</div>
                            <h3 class="text-2xl font-bold text-gray-800 mb-2">AI日报</h3>
                            <p class="text-gray-500">每日AI行业最新动态与深度分析</p>
                            <div class="mt-4 text-blue-600 font-medium">查看全部 →</div>
                        </div>
                        <div onclick="showList('weekly')" class="bg-white rounded-2xl shadow-md p-8 cursor-pointer hover:shadow-xl hover:scale-105 transition transform">
                            <div class="text-5xl mb-4">📊</div>
                            <h3 class="text-2xl font-bold text-gray-800 mb-2">行业周报</h3>
                            <p class="text-gray-500">航空公司AI转型深度研究报告</p>
                            <div class="mt-4 text-purple-600 font-medium">查看全部 →</div>
                        </div>
                        <div onclick="showList('books')" class="bg-white rounded-2xl shadow-md p-8 cursor-pointer hover:shadow-xl hover:scale-105 transition transform">
                            <div class="text-5xl mb-4">📚</div>
                            <h3 class="text-2xl font-bold text-gray-800 mb-2">图书推荐</h3>
                            <p class="text-gray-500">来自小众国家的经典文学作品</p>
                            <div class="mt-4 text-orange-600 font-medium">查看全部 →</div>
                        </div>
                    </div>
                </main>

                <footer class="bg-gray-800 text-gray-400 py-8 mt-12">
                    <div class="max-w-7xl mx-auto px-4 text-center">
                        <p>© 2026 AI日报中心 | 由 OpenClaw 自动生成</p>
                    </div>
                </footer>
            `;
        }

        function renderList() {
            let items = [];
            let title = '';
            
            if (selectedType === 'daily') {
                items = reportsData.daily || [];
                title = '📰 AI日报';
            } else if (selectedType === 'weekly') {
                items = reportsData.weekly || [];
                title = '📊 行业周报';
            } else if (selectedType === 'books') {
                items = reportsData.books || [];
                title = '📚 图书推荐';
            } else {
                items = [...(reportsData.daily || []), ...(reportsData.weekly || []), ...(reportsData.books || [])];
                title = '📋 全部报告';
            }

            return `
                <header class="bg-gradient-to-r from-blue-600 to-indigo-700 text-white shadow-lg">
                    <div class="max-w-7xl mx-auto px-4 py-8">
                        <div class="flex items-center justify-between">
                            <h1 class="text-3xl font-bold">${title}</h1>
                            <button onclick="showHome()" class="bg-white/20 hover:bg-white/30 px-4 py-2 rounded-lg transition">← 返回首页</button>
                        </div>
                    </div>
                </header>

                <main class="max-w-7xl mx-auto px-4 py-8">
                    <div class="space-y-4">
                        ${items.length === 0 ? '<div class="text-center text-gray-500 py-10">暂无数据</div>' : 
                          items.map(r => `
                            <div class="bg-white rounded-xl shadow-md p-6 hover:shadow-lg transition cursor-pointer" onclick="showDetail('${r.id}')">
                                <div class="flex items-center justify-between mb-2">
                                    <h3 class="text-xl font-semibold text-gray-800">${r.title}</h3>
                                    <span class="text-sm text-gray-400">${r.date}</span>
                                </div>
                                <p class="text-gray-600 mb-3">${r.summary}</p>
                                <span class="inline-block bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">${r.category}</span>
                            </div>
                          `).join('')}
                    </div>
                </main>
            `;
        }

        function renderDetail() {
            // 查找报告详情
            let report = null;
            [...(reportsData.daily || []), ...(reportsData.weekly || []), ...(reportsData.books || [])].forEach(r => {
                if (r.id === selectedReport) report = r;
            });

            if (!report) {
                return `
                    <header class="bg-gradient-to-r from-blue-600 to-indigo-700 text-white shadow-lg">
                        <div class="max-w-7xl mx-auto px-4 py-8">
                            <button onclick="showList(selectedType)" class="bg-white/20 hover:bg-white/30 px-4 py-2 rounded-lg transition mb-4">← 返回列表</button>
                            <h1 class="text-3xl font-bold">报告详情</h1>
                        </div>
                    </header>
                    <main class="max-w-4xl mx-auto px-4 py-8">
                        <div class="bg-white rounded-xl shadow-md p-8">
                            <p class="text-gray-600">报告内容加载中... 完整内容请查看原始文件。</p>
                        </div>
                    </main>
                `;
            }

            return `
                <header class="bg-gradient-to-r from-blue-600 to-indigo-700 text-white shadow-lg">
                    <div class="max-w-7xl mx-auto px-4 py-8">
                        <button onclick="showList(selectedType)" class="bg-white/20 hover:bg-white/30 px-4 py-2 rounded-lg transition mb-4">← 返回列表</button>
                        <h1 class="text-3xl font-bold">${report.title}</h1>
                        <div class="mt-2 text-blue-200">${report.date} | ${report.category}</div>
                    </div>
                </header>
                <main class="max-w-4xl mx-auto px-4 py-8">
                    <div class="bg-white rounded-xl shadow-md p-8 markdown-body">
                        <p class="text-gray-600">${report.summary}</p>
                        <hr class="my-6">
                        <p class="text-gray-500 italic">完整报告内容正在开发中，敬请期待... 完整内容请查看原始文件。</p>
                    </div>
                </main>
            `;
        }

        function showHome() { currentView = 'home'; render(); }
        function showList(type) { currentView = 'list'; selectedType = type; render(); }
        function showDetail(id) { currentView = 'detail'; selectedReport = id; render(); }

        // 初始化
        loadData();
    </script>
</body>
</html>
HTMLEOF

# 复制reports.json
cp "$WORKSPACE/dashboard/reports.json" .

# 4. 提交到GitHub
echo ""
echo "🚀 步骤4: 提交到GitHub..."
git add .
git commit -m "自动同步报告数据 - $(date '+%Y-%m-%d %H:%M:%S')" || echo "无更改需要提交"

# 5. 推送到GitHub
echo ""
echo "📤 步骤5: 推送到GitHub..."
git push origin main || {
    echo "❌ 推送失败，可能需要配置GitHub Token"
    echo "请运行: git push origin main"
    exit 1
}

# 6. 完成
echo ""
echo "========================================"
echo "✅ 部署完成！"
echo "========================================"
echo ""
echo "网站地址:"
echo "🔗 https://$REPO_NAME.vercel.app"
echo ""
echo "数据已同步:"
echo "   - AI日报: $(jq '.daily | length' reports.json) 篇"
echo "   - 周报: $(jq '.weekly | length' reports.json) 篇"
echo "   - 图书: $(jq '.books | length' reports.json) 篇"
echo ""
echo "Vercel将在几分钟内自动部署更新"
echo "========================================"