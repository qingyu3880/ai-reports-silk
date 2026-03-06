# Memory System - 长期记忆配置

## 记忆文件结构

```
/root/.openclaw/workspace/
├── MEMORY.md                 # 核心长期记忆（主会话加载）
├── memory/                   # 每日记忆文件夹
│   ├── 2026-03-04.md        # 今日记忆
│   └── 2026-03-03.md        # 昨日记忆
└── skills/memory-system/     # 记忆系统 Skill
    ├── SKILL.md
    └── scripts/
        ├── memory_search.py   # 记忆搜索
        └── memory_store.py    # 记忆存储
```

## 使用方式

### 1. 存储记忆
```python
# 自动存储到今日记忆文件
memory_store.store(
    content="用户喜欢法国电影",
    category="preference",
    tags=["电影", "法国"]
)
```

### 2. 搜索记忆
```python
# 搜索相关记忆
results = memory_search.query("用户喜欢什么电影？")
```

### 3. 记忆分类
- `preference` - 用户偏好
- `decision` - 重要决策
- `task` - 任务相关
- `fact` - 事实信息
- `error` - 错误教训

## 自动规则

1. **每次对话前** - 自动加载 MEMORY.md 和今日记忆
2. **每次对话后** - 自动保存重要信息到今日记忆
3. **每周汇总** - 将本周记忆整理到 MEMORY.md
4. **搜索优先** - 回答前先搜索相关记忆

## 当前记忆状态

- MEMORY.md: 已创建
- 今日记忆: 2026-03-04.md
- 记忆条目: 待添加