# GitHub + Vercel 自动部署配置指南

## 概述
本指南说明如何配置日报/周报系统自动推送到 GitHub，并通过 Vercel 自动部署到网站。

## 当前状态
- ✅ `sync_reports.py` - 本地同步脚本已配置
- ✅ `scripts/github-push.sh` - GitHub 推送脚本已创建
- ⚠️ GitHub 仓库 - **需要创建**
- ⚠️ Vercel 项目 - **需要连接**

## 配置步骤

### 第一步：创建 GitHub 仓库

1. 登录 https://github.com
2. 点击右上角 "+" → "New repository"
3. 填写信息：
   - Repository name: `ai-reports-silk`（或你喜欢的名字）
   - Description: AI日报中心 - 自动同步的报告和推荐
   - Public（Vercel 免费版需要 Public 仓库）
   - 勾选 "Add a README file"
4. 点击 "Create repository"

### 第二步：获取 GitHub Token

1. 登录 https://github.com
2. 点击右上角头像 → Settings
3. 左侧菜单最下方 → Developer settings
4. Personal access tokens → Tokens (classic)
5. 点击 "Generate new token (classic)"
6. 填写信息：
   - Note: `AI Reports Deploy`
   - Expiration: 选择过期时间（建议 90 天或更久）
   - Scopes: 勾选 `repo`（完整仓库访问权限）
7. 点击 "Generate token"
8. **重要**：立即复制生成的 Token（只显示一次）
9. 将 Token 保存到文件：
   ```bash
   echo "ghp_xxxxxxxxxxxxxxxxxxxx" > /root/.openclaw/workspace/.github_token
   ```

### 第三步：更新推送脚本

编辑 `scripts/github-push.sh`，修改以下变量：

```bash
GITHUB_USER="你的GitHub用户名"      # 例如: zhangsan
GITHUB_REPO_NAME="你的仓库名"        # 例如: ai-reports-silk
```

### 第四步：测试推送

```bash
cd /root/.openclaw/workspace
bash scripts/github-push.sh
```

### 第五步：连接 Vercel

1. 登录 https://vercel.com（可用 GitHub 账号直接登录）
2. 点击 "Add New..." → "Project"
3. 在 "Import Git Repository" 中找到你的 `ai-reports-silk` 仓库
4. 点击 "Import"
5. 配置项目：
   - Project Name: `ai-reports-silk`（或默认）
   - Framework Preset: `Other`
   - Root Directory: `./`
   - Build Command: 留空（静态网站）
   - Output Directory: `dashboard`
6. 点击 "Deploy"

### 第六步：验证部署

1. 等待 Vercel 部署完成（约 1-2 分钟）
2. 访问 Vercel 提供的域名（如 `https://ai-reports-silk.vercel.app`）
3. 确认网站显示正常

## 日常使用

### 手动执行完整同步
```bash
cd /root/.openclaw/workspace
bash scripts/test-sync.sh
```

### 定时任务自动执行
系统已配置定时任务，在以下时间自动执行：
- 8:00 - 音乐推荐
- 9:00 - AI日报
- 17:00 - 图书推荐
- 20:00 - 电影推荐
- 周一 9:00 - 航空AI周报

每次执行后会自动：
1. 生成内容
2. 保存到本地
3. 推送到对话
4. 运行 `sync_reports.py`
5. 推送到 GitHub（触发 Vercel 自动部署）

## 故障排查

### GitHub 推送失败
- 检查 `.github_token` 文件是否存在且有效
- 检查 Token 是否有过期
- 检查 Token 是否有 `repo` 权限
- 检查 GitHub 仓库是否存在且为 Public

### Vercel 部署失败
- 检查 Vercel 项目设置中的 Output Directory 是否为 `dashboard`
- 检查 `dashboard/reports.json` 是否存在
- 检查 Vercel 部署日志

### 网站内容未更新
- 确认 GitHub 推送成功
- 检查 Vercel 部署状态
- 清除浏览器缓存后刷新

## 文件说明

| 文件 | 用途 |
|------|------|
| `sync_reports.py` | 生成本地 reports.json |
| `scripts/github-push.sh` | 推送到 GitHub |
| `scripts/test-sync.sh` | 完整同步测试 |
| `dashboard/reports.json` | 网站数据源 |
| `CHECKLIST.md` | 执行复核清单 |

## 联系方式

如有问题，请检查：
1. GitHub 仓库设置
2. Vercel 项目设置
3. 本地 Token 配置
