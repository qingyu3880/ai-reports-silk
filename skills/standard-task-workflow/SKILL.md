# Skill: 标准任务执行流程

## 版本: 1.0
## 创建日期: 2026-03-06
## 适用范围: 所有任务

---

## 核心原则

### 1. 不靠记忆，靠文件
- ❌ "我记得..."
- ✅ "让我检查文件..."

### 2. 不假设，只验证
- ❌ "这应该可以..."
- ✅ "让我验证一下..."

### 3. 完成意味着验证通过
- ❌ "我做完了"
- ✅ "已验证完成，结果如下..."

---

## 标准流程（每个任务必须执行）

### Phase 1: 准备（开始前）

#### 1.1 搜索记忆
```
memory_search(query="相关关键词")
```
- 查找类似任务历史
- 查找相关错误
- 查找最佳实践

#### 1.2 检查错误文档
```
ls skills/error-documentation/
grep -r "相关关键词" skills/error-documentation/
```
- 是否有类似错误
- 是否有预防措施
- 是否有修复方法

#### 1.3 明确完成标准
- 任务完成的具体标准是什么？
- 需要验证哪些内容？
- 用户期望看到什么结果？

#### 1.4 验证前置条件
- 需要的文件/资源是否存在？
- 需要的工具是否可用？
- 网络连接是否正常？

---

### Phase 2: 执行（进行中）

#### 2.1 小步快跑
- 每个小步骤后立即验证
- 不积累大量未验证的工作
- 发现问题立即处理

#### 2.2 持续记录
- 关键操作记录到日志
- 错误立即记录
- 决策记录原因

#### 2.3 遇到不确定
- 不确定时停止
- 搜索文档或记忆
- 必要时询问用户

---

### Phase 3: 验证（完成后）

#### 3.1 文件系统验证
```bash
# 检查文件是否存在
ls -la 文件路径

# 检查文件大小（防止空文件）
[ $(stat -f%z 文件) -gt 1000 ]

# 检查文件内容
head -20 文件
```

#### 3.2 Git状态验证
```bash
# 检查是否有未提交更改
git status

# 检查是否有未推送提交
git log origin/main..master --oneline

# 验证推送成功
git fetch origin main
git log origin/main..master --oneline | wc -l  # 应为0
```

#### 3.3 用户可见验证
- 内容是否已推送到对话框？
- 用户能否看到完整内容？
- 格式是否正确？

#### 3.4 远程服务验证（如适用）
- Vercel网站是否更新？
- API是否可访问？
- 外部服务是否正常？

---

### Phase 4: 收尾（验证后）

#### 4.1 记录完成
- 更新相关文档
- 记录完成时间
- 记录任何异常

#### 4.2 错误处理（如有）
- 记录错误到ERROR_LOG.md
- 创建新的ERROR_xxx.md（如需要）
- 更新SKILL.md（如需要）

#### 4.3 报告用户
```
✅ 任务完成报告
- 完成内容: xxx
- 验证结果: xxx
- 相关链接: xxx
- 注意事项: xxx
```

---

## 完成标准检查清单

### 内容生成任务
- [ ] 文件已保存到正确路径
- [ ] 文件大小合理（>1KB）
- [ ] 内容格式正确
- [ ] 已推送到对话框
- [ ] Git已提交
- [ ] Git已推送
- [ ] 用户确认收到

### 技能安装任务
- [ ] 技能目录存在
- [ ] SKILL.md存在
- [ ] 有实际代码/脚本（非纯文档）
- [ ] 工具可调用
- [ ] 已验证功能正常

### 同步任务
- [ ] 本地数据已更新
- [ ] reports.json已生成
- [ ] Git已提交
- [ ] Git已推送
- [ ] Vercel部署触发（如配置）

---

## 常见错误快速修复

### 错误: write工具缺少path
**症状**: "Missing required parameter: path"
**修复**: 
```python
write({
    "path": "/完整/路径/文件名.md",
    "content": "内容"
})
```

### 错误: GitHub推送失败
**症状**: push被拒绝或超时
**修复**:
```bash
# 检查未推送提交
git log origin/main..master --oneline

# 重试推送
for i in 1 2 3; do
    git push origin master:main && break
    sleep 30
done
```

### 错误: 虚假完成报告
**症状**: 报告完成但实际未完成
**修复**:
```bash
# 验证文件系统
find . -name "相关文件" | wc -l

# 验证Git状态
git status
git log origin/main..master --oneline
```

---

## 自检脚本（每小时执行）

```bash
#!/bin/bash
# 每小时自检

echo "=== 自检 $(date) ==="

# 检查未推送提交
unpushed=$(git log origin/main..master --oneline | wc -l)
if [ $unpushed -gt 0 ]; then
    echo "⚠️ 有 $unpushed 个未推送提交"
    git push origin master:main
fi

# 检查错误日志
if [ -f skills/error-documentation/ERROR_LOG.md ]; then
    new_errors=$(grep "$(date +%Y-%m-%d)" skills/error-documentation/ERROR_LOG.md | wc -l)
    if [ $new_errors -gt 0 ]; then
        echo "⚠️ 今天有 $new_errors 个新错误"
    fi
fi

echo "=== 自检完成 ==="
```

---

## 更新记录

- **v1.0** (2026-03-06): 初始版本，汇总6个错误后创建

---

## 相关文档

- WEEKLY_ISSUES_SUMMARY.md - 一周问题汇总
- ERROR_001.md ~ ERROR_006.md - 具体错误记录
- task-completion-verification/SKILL.md - 任务完成验证
