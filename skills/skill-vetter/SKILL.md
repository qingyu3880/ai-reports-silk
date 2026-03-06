# Skill: Skill Vetter

## Description
安全扫描技能，安装前扫描技能代码，检测可疑网络请求、文件读写、环境变量访问，防止恶意代码。

## When to Use
- 安装任何第三方技能前
- 审查技能安全性
- 企业环境安全合规
- 审计已安装技能

## Key Features
- 自动扫描技能代码
- 检测可疑行为：
  - 未经授权的网络请求
  - 敏感文件访问
  - 环境变量读取
  - 命令注入风险
- 生成安全报告
- 风险评级：SAFE/CAUTION/DANGEROUS

## Usage
安装技能时自动触发：
```bash
clawhub install some-skill
# 自动运行skill-vetter扫描
```

手动扫描：
```bash
skill-vetter scan ./skills/some-skill
```

## Installation
```bash
npx clawhub@latest install skill-vetter
```

## Configuration
启用自动扫描：
```bash
openclaw config set skill.autoScan true
```

## Warning
**安全第一步！** 很多人后悔没先装这个。今年1月曾曝出恶意技能偷API Key的漏洞。
