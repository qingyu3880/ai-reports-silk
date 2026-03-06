# Skill: Find Skills

## Description
让Agent自己去ClawHub搜索并安装需要的技能。解决"不知道用哪个工具"的痛点。

## When to Use
- 不知道某个任务该用什么技能
- 需要发现新的可用技能
- 想自动扩展Agent能力

## Usage
在对话中直接说：
- "帮我找一个能处理Excel的技能"
- "搜索PDF相关的技能"
- "发现新的有用技能"

## How It Works
1. 接收用户的自然语言需求
2. 在ClawHub搜索匹配的技能
3. 返回技能列表和安装命令
4. 可选：自动安装推荐的技能

## Installation
```bash
npx clawhub@latest install find-skills
```

## Note
这是一个"元技能"，专门帮助发现其他技能。建议优先安装。
