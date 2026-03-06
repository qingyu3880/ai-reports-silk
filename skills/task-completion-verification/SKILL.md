# Skill: 任务完成验证系统

## 目的
确保每个任务都真正完成，包括推送到对话框和同步到网站，防止虚假完成报告。

## 核心原则
1. **双重验证**: 每个任务必须验证两个渠道
   - 推送到对话框（用户可见）
   - 同步到网站/GitHub（公开可访问）

2. **真实检查**: 不依赖日志，直接检查文件系统
   - 文件是否存在
   - 文件大小是否合理
   - Git状态是否正确

3. **自动修复**: 发现问题自动尝试修复
   - 推送失败自动重试
   - 同步失败自动修复
   - 错误记录并报告

## 验证清单（每个任务必须）

### 生成内容后
- [ ] 文件已保存到正确路径
- [ ] 文件大小 > 1KB
- [ ] 内容格式正确

### 推送到对话框
- [ ] 内容已显示在对话中
- [ ] 用户可以看到完整内容
- [ ] 格式渲染正确

### 同步到网站
- [ ] Git提交成功
- [ ] Git推送成功（验证远程）
- [ ] Vercel部署触发（如配置）

## 修复流程

### 推送失败
```bash
# 1. 检查未推送提交
git log origin/main..master --oneline

# 2. 尝试推送（带重试）
for i in 1 2 3; do
    git push origin master:main && break
    sleep 30
done

# 3. 验证推送成功
git fetch origin main
git log origin/main..master --oneline | wc -l  # 应为0
```

### 同步失败
```bash
# 1. 运行sync脚本
python3 sync_reports.py

# 2. 检查reports.json
ls -lh dashboard/reports.json

# 3. 提交并推送
git add dashboard/reports.json
git commit -m "同步: 更新reports.json"
git push origin master:main
```

## 错误记录

当验证失败时，记录：
- 任务名称
- 失败步骤
- 错误信息
- 修复尝试
- 最终状态

## 自检机制

每小时自检：
1. 检查是否有未推送提交
2. 检查reports.json是否最新
3. 检查网站是否可访问
4. 发现问题立即修复并报告

## 禁止事项

- ❌ 不验证就报告"完成"
- ❌ 只检查日志不检查文件
- ❌ 发现错误不尝试修复
- ❌ 不报告真实状态

## 成功案例标准

只有以下全部满足，才算成功：
1. 用户能在对话中看到内容
2. GitHub上有对应提交
3. 网站显示最新内容（如配置）
4. 没有未处理的错误
