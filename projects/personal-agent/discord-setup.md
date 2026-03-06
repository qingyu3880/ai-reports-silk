# Discord 服务器配置指南

## 服务器结构

```
📌 GENERAL（日常）
├── #常规 - 快速问答、不确定去哪时的入口
└── #运维 - 系统配置、Token周报、Git同步

🎯 GOAL MANAGEMENT（目标管理）
├── #年度目标 - 🔭愿景激励师·1Y
├── #季度目标 - 🧭战略领航员·3M
└── #月周度目标 - ⚡理想执行者·1M

📖 KNOWLEDGE & CONTENT（知识与内容）
├── #未来日记 - 📓日记管理器
├── #内容创作 - 📝内容引擎
├── #知识管理 - 📚知识管理器
└── #记忆训练 - 🧠间隔重复训练师

🧪 LAB（实验室）
└── #sandbox - 测试新功能
```

## 频道配置

### 1. 创建服务器
1. 打开 Discord，点击左侧「+」
2. 选择「创建服务器」
3. 名称建议：「MyAgent」或「个人操作系统」

### 2. 创建频道组（Category）
右键服务器名称 → 创建类别：
- GENERAL
- GOAL MANAGEMENT
- KNOWLEDGE & CONTENT
- LAB

### 3. 创建频道
在每个类别下创建文本频道：
- 常规、运维
- 年度目标、季度目标、月周度目标
- 未来日记、内容创作、知识管理、记忆训练
- sandbox

### 4. 创建 Discord Bot
1. 访问 https://discord.com/developers/applications
2. 点击「New Application」，命名（如「MyAgent」）
3. 进入「Bot」标签页，点击「Add Bot」
4. 复制 Token（保存好，后面要用）
5. 开启权限：
   - MESSAGE CONTENT INTENT
   - SERVER MEMBERS INTENT

### 5. 邀请 Bot 到服务器
1. 进入「OAuth2」→「URL Generator」
2. Scopes 选择：bot
3. Bot Permissions 选择：
   - Send Messages
   - Read Message History
   - View Channels
4. 复制生成的 URL，在浏览器打开
5. 选择你的服务器，授权

## OpenClaw 配置

### 环境变量
```bash
export DISCORD_TOKEN="你的Bot Token"
export DISCORD_GUILD_ID="你的服务器ID"
```

### 频道映射（config.yaml）
```yaml
channels:
  discord:
    general: "常规频道ID"
    ops: "运维频道ID"
    vision_1y: "年度目标频道ID"
    strategy_3m: "季度目标频道ID"
    execute_1m: "月周度目标频道ID"
    diary: "未来日记频道ID"
    content: "内容创作频道ID"
    knowledge: "知识管理频道ID"
    memory: "记忆训练频道ID"
    sandbox: "sandbox频道ID"

# 技能映射
skills_mapping:
  vision_1y: "vision-coach-1y"
  strategy_3m: "strategy-navigator-3m"
  execute_1m: "executer-1m"
  knowledge: "knowledge-zettelkasten"
  memory: "spaced-repetition-sm2"
```

## 获取频道 ID

1. Discord 设置 → 高级 → 开启「开发者模式」
2. 右键频道名称 →「复制频道 ID」

## 测试连接

```bash
# 启动 OpenClaw
openclaw gateway start

# 在 Discord 任意频道发送：
@MyAgent 你好

# 应该收到回复
```
