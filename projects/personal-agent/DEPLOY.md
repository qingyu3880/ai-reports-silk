# 部署指南

## 方案 A：ClawCloud（推荐，免费）

### 1. 注册 ClawCloud
- 访问 https://clawcloud.io
- 用 GitHub 账号登录
- 创建免费账户（每月 $5 额度）

### 2. 创建应用
```bash
# 在 ClawCloud 控制台
1. 创建 Application
2. 选择模板：OpenClaw
3. 配置环境变量：
   - DISCORD_TOKEN
   - KIMI_API_KEY（NVIDIA 免费 API）
   - 其他配置
4. 部署
```

### 3. 配置自动重启
```yaml
# clawcloud.yaml
restart_policy: always
resources:
  cpu: 0.5
  memory: 512Mi
```

## 方案 B：Docker 本地部署

### 1. 安装 Docker
```bash
curl -fsSL https://get.docker.com | sh
```

### 2. 创建 Dockerfile
```dockerfile
FROM openclaw/openclaw:latest

# 复制配置
COPY ./workspace /root/.openclaw/workspace
COPY ./config.yaml /root/.openclaw/config.yaml

# 设置环境变量
ENV DISCORD_TOKEN=${DISCORD_TOKEN}
ENV KIMI_API_KEY=${KIMI_API_KEY}

# 启动
CMD ["openclaw", "gateway", "start"]
```

### 3. 构建并运行
```bash
docker build -t my-agent .
docker run -d --name my-agent --restart always my-agent
```

## 方案 C：VPS 部署

### 1. 购买 VPS
推荐：
- Vultr（$5/月）
- DigitalOcean（$5/月）
- 阿里云/腾讯云（国内）

### 2. 安装依赖
```bash
# Ubuntu/Debian
apt update
apt install -y nodejs npm git

# 安装 OpenClaw
npm install -g openclaw

# 安装 Kimi CLI
npm install -g @kimi-ai/cli
```

### 3. 配置 Systemd 服务
```bash
# /etc/systemd/system/openclaw.service
[Unit]
Description=OpenClaw Agent
After=network.target

[Service]
Type=simple
User=root
Environment="DISCORD_TOKEN=xxx"
Environment="KIMI_API_KEY=xxx"
ExecStart=/usr/bin/openclaw gateway start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
systemctl enable openclaw
systemctl start openclaw
systemctl status openclaw
```

## 获取免费 Kimi API（NVIDIA）

### 1. 注册 NVIDIA NIM
- 访问 https://build.nvidia.com
- 用邮箱/Google 注册
- 验证手机号（+86 支持）

### 2. 获取 API Key
- 进入 Dashboard
- 点击「Get API Key」
- 复制 Key（格式：nvapi-xxx）

### 3. 测试
```bash
curl -X POST "https://integrate.api.nvidia.com/v1/chat/completions" \
  -H "Authorization: Bearer $NVIDIA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kimi-k2.5",
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

## 安全注意事项

### 1. 关闭不安全认证
```yaml
# config.yaml
security:
  auth_enabled: true
  allowed_channels:
    - "你的Discord服务器ID"
```

### 2. Token 管理
- 不要将 Token 提交到 Git
- 使用环境变量或密钥管理服务
- 定期轮换 Token

### 3. 权限最小化
- Bot 只申请必要权限
- 限制频道访问
- 定期检查日志

## 成本估算

| 方案 | 月成本 | 稳定性 | 适合人群 |
|------|--------|--------|----------|
| ClawCloud 免费版 | $0 | 中 | 实验阶段 |
| ClawCloud 付费版 | $5-10 | 高 | 长期使用 |
| VPS | $5 | 高 | 技术用户 |
| 本地 Docker | $0 | 低（需开机）| 开发测试 |

## 监控与维护

### 日志查看
```bash
# Docker
docker logs my-agent -f

# Systemd
journalctl -u openclaw -f

# ClawCloud
# 在控制台查看 Logs 标签页
```

### 健康检查
```bash
# 检查 OpenClaw 状态
openclaw status

# 检查 Discord 连接
openclaw channels discord status
```

### 备份
```bash
# 备份 workspace
tar -czf backup-$(date +%Y%m%d).tar.gz ~/.openclaw/workspace

# 自动备份到 GitHub
cd ~/.openclaw/workspace
git add .
git commit -m "backup: $(date)"
git push
```
