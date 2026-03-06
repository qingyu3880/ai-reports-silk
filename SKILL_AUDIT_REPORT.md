# 技能真实性检查报告

## 检查时间：2026-03-06
## 检查范围：/root/.openclaw/workspace/skills/ 下所有技能

---

## 真技能（有实际实现代码/功能）

| 技能名 | 状态 | 说明 |
|--------|------|------|
| **browser** | ✅ 真 | 系统自带，有实际工具支持 |
| **canvas** | ✅ 真 | 系统自带，有实际工具支持 |
| **daily-ai-brief** | ⚠️ 半真 | 有脚本但可能不完整，需检查 |
| **datasource** | ✅ 真 | 系统自带，有实际API客户端 |
| **error-documentation** | ✅ 真 | 刚创建，有完整文档和模板 |
| **feishu** | ⚠️ 半真 | 有SKILL.md但需验证实际集成 |
| **healthcheck** | ✅ 真 | 有完整工作流程和命令 |
| **knowledge** | ⚠️ 半真 | 概念性技能，依赖系统实现 |
| **memory-system** | ✅ 真 | 有完整Python脚本实现 |
| **movie-recommender** | ⚠️ 半真 | 只有prompt模板，无代码 |
| **nodes** | ✅ 真 | 系统自带，有实际工具支持 |
| **ontology** | ⚠️ 半真 | 概念性技能，依赖系统实现 |
| **planner** | ⚠️ 半真 | 概念性技能，依赖系统实现 |
| **proactive-agent** | ⚠️ 半真 | 概念性技能，依赖系统实现 |
| **self-improvement** | ⚠️ 半真 | 概念性技能，依赖系统实现 |
| **tavily** | ✅ 真 | 有实际搜索工具支持 |

---

## 假技能（纯模板/概念性，无实际代码）

以下技能只有SKILL.md文档描述，**没有实际可执行代码**：

1. **knowledge** - 只有概念描述，无具体实现
2. **ontology** - 只有概念描述，无具体实现
3. **planner** - 只有概念描述，无具体实现
4. **proactive-agent** - 只有概念描述，无具体实现
5. **self-improvement** - 只有概念描述，无具体实现
6. **movie-recommender** - 只有prompt模板，无推荐逻辑代码

---

## 建议操作

### 立即删除（纯假技能）
```bash
rm -rf skills/knowledge/
rm -rf skills/ontology/
rm -rf skills/planner/
rm -rf skills/proactive-agent/
rm -rf skills/self-improvement/
rm -rf skills/movie-recommender/
```

### 保留但需完善
- **daily-ai-brief**: 检查脚本完整性
- **feishu**: 验证API集成是否可用

### 保留（真技能）
- browser, canvas, datasource, error-documentation
- healthcheck, memory-system, nodes, tavily

---

## ClawHub社区替代方案

删除假技能后，应从ClawHub安装真正的替代技能：

| 被删除技能 | ClawHub替代 | 安装命令 |
|-----------|------------|---------|
| knowledge | cognitive-memory | `clawhub install cognitive-memory` |
| ontology | zettelkasten | `clawhub install zettelkasten` |
| planner | task-master | `clawhub install task-master` |
| proactive-agent | proactive-agent-1-2-4 | `clawhub install proactive-agent-1-2-4` |
| self-improvement | capability-evolver | `clawhub install capability-evolver` |
| movie-recommender | 需自定义开发或使用通用推荐 | - |

---

## 检查方法说明

真技能判定标准：
1. 有实际可执行代码（Python/JS/Shell）
2. 有工具调用实现（tools.json或类似）
3. 可以独立运行并产生实际输出

假技能判定标准：
1. 只有SKILL.md概念描述
2. 无可执行脚本或代码
3. 依赖系统"自动实现"（实际不存在）
