# Skill: GitHub Integration

## Description
GitHub集成，通过gh CLI操作GitHub，支持PR管理、Issue批量处理、CI状态查询、代码搜索。

## When to Use
- 管理GitHub仓库
- 查看PR和Issue状态
- 自动化GitHub工作流
- 代码审查辅助

## Key Features
- PR管理：创建、查看、合并
- Issue处理：批量操作、标签管理
- CI状态查询：检查构建状态
- 代码搜索：在仓库中搜索代码

## Setup
1. 安装GitHub CLI: `apt install gh` 或 `brew install gh`
2. 登录: `gh auth login`
3. 配置Token（可选）

## Usage Examples
- "查看PR #55的CI检查状态"
- "关闭所有标签为duplicate的Issue"
- "搜索仓库中包含'TODO'的代码"
- "创建一个新的PR"

## Installation
```bash
npx clawhub@latest install github
```

## Configuration
```bash
openclaw config set skills.github.token "你的GitHub Token"
```
