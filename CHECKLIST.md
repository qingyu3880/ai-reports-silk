# 定时任务执行复核清单

## 执行前检查（必须完成）

### 1. 去重检查
- [ ] 读取对应目录下的所有历史文件
- [ ] 检查今天是否已生成过内容
- [ ] 如果已存在，跳过生成，直接推送已有内容

### 2. 目录映射
| 任务类型 | 检查目录 |
|---------|----------|
| 音乐推荐 | `/root/.openclaw/workspace/recommendations/music/` |
| 图书推荐 | `/root/.openclaw/workspace/recommendations/books/` |
| 电影推荐 | `/root/.openclaw/workspace/recommendations/movies/` |
| AI日报 | `/root/.openclaw/workspace/reports/` |
| 航空AI周报 | `/root/.openclaw/workspace/reports/airline-ai/` |

## 执行中要求

### 3. 内容生成
- [ ] 严格按照格式模板生成
- [ ] 包含所有必需章节
- [ ] 字数符合要求

### 4. 文件保存（强制）
- [ ] 生成文件路径：`{目录}/YYYY-MM-DD-{内容标识}.md`
- [ ] 确认文件写入成功
- [ ] 文件大小 > 1KB（防止空文件）

## 执行后复核

### 5. 推送前检查
- [ ] 读取刚保存的文件确认内容完整
- [ ] 检查是否包含所有必需章节
- [ ] 检查格式是否正确

### 6. 三渠道推送（强制）
- [ ] **推送到对话**（完整Markdown内容）
- [ ] **同步到 Vercel 网站**（运行 `python3 sync_reports.py`）
- [ ] **提交到 GitHub**（运行 `bash scripts/github-push.sh`）

### 7. Vercel 同步验证（强制）
- [ ] 运行 `sync_reports.py` 成功，无报错
- [ ] 检查 `dashboard/reports.json` 文件已更新
- [ ] **验证网站可访问**：打开 `https://ai-reports-silk.vercel.app` 确认内容已同步
- [ ] 检查新内容在网站首页显示正常
- [ ] 如验证失败，立即停止并排查问题

## 自动化配置说明

### GitHub 自动推送配置
1. **编辑脚本配置文件**：
   ```bash
   # 修改 scripts/github-push.sh 中的变量
   GITHUB_USER="yourusername"      # 你的 GitHub 用户名
   GITHUB_REPO_NAME="ai-reports"   # 你的仓库名
   ```

2. **确保 GitHub Token 有效**：
   - 文件位置：`/root/.openclaw/workspace/.github_token`
   - Token 需要 `repo` 权限

3. **在 GitHub 创建仓库**：
   - 仓库名：`ai-reports`（或你配置的名称）
   - 设置为 Public（Vercel 免费版需要）

4. **连接 Vercel**：
   - 登录 https://vercel.com
   - Import GitHub Repository
   - 选择 `ai-reports` 仓库
   - 部署设置使用默认即可

### 一键推送命令
```bash
# 手动执行完整同步流程
cd /root/.openclaw/workspace
python3 sync_reports.py           # 生成 reports.json
bash scripts/github-push.sh       # 推送到 GitHub（自动触发 Vercel 部署）
```

## 错误处理

### 如果 Vercel 同步失败
1. 检查 `sync_reports.py` 输出错误信息
2. 验证 `dashboard/reports.json` 是否生成成功
3. 手动访问网站确认状态
4. 如网站无法访问，检查 Vercel 部署状态
5. **禁止跳过此步骤** — 必须解决后才能标记任务完成

### 如果 GitHub 推送失败
1. 检查 `.github_token` 文件是否存在且有效
2. 检查 GitHub 仓库是否存在
3. 检查 Token 是否有 `repo` 权限
4. 检查网络连接
5. **禁止跳过此步骤** — 必须解决后才能标记任务完成

### 如果生成失败
1. 记录错误原因
2. 不推送不完整内容
3. 等待下次定时任务重试

### 如果保存失败
1. 不推送到对话
2. 报错并记录
3. 手动检查磁盘空间/权限

### 如果今天已存在
1. 读取已有文件
2. 推送到对话
3. 运行同步脚本更新网站
4. 跳过生成步骤
