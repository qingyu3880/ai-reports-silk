# 所有推荐类型完整打包
# 创建日期: 2026-03-06
# 用途: 一键恢复所有推荐配置

---

## 一、AI日报

### 生成时间
- 每天 9:00 AM (Asia/Shanghai)

### 内容结构
1. 头条新闻 (5条)
2. 中文AI圈动态 (2-3条)
3. AI产品与应用 (2-3条)
4. 重要开源项目 (表格)
5. 核心洞察 (3条)

### 文件路径
`reports/ai-daily-YYYY-MM-DD.md`

---

## 二、音乐推荐

### 生成时间
- 每天 8:00 AM (Asia/Shanghai)

### 内容结构
1. 曲目与演奏者信息
2. 创作背景
3. 欣赏要点与聆听攻略
4. 如何提升音乐鉴赏力
5. 相关推荐

### 文件路径
`recommendations/music/YYYY-MM-DD-曲目名.md`

---

## 三、图书推荐

### 生成时间
- 每天 17:00 PM (Asia/Shanghai)

### 内容结构
1. 书籍基本信息
2. 作者与创作背景
3. 核心内容与亮点
4. 适合人群
5. 阅读建议

### 文件路径
`recommendations/books/YYYY-MM-DD-书名.md`

---

## 四、电影推荐

### 生成时间
- 每天 20:00 PM (Asia/Shanghai)

### 内容结构
1. 电影基本信息
2. 导演与创作背景
3. 核心洞察（重点）
4. 五句经典台词
5. 观看建议

### 文件路径
`recommendations/movies/YYYY-MM-DD-片名.md`

---

## 五、AI周报（航空AI）

### 生成时间
- 每周一 9:00 AM (Asia/Shanghai)

### 内容结构
1. 本周头条 (3-5条)
2. 航空业AI应用案例
3. 技术趋势分析
4. 下周展望

### 文件路径
`reports/airline-ai/weekly-YYYY-MM-DD.md`

---

## 六、通用执行流程（所有类型）

### 阶段1: 生成前
- 运行前置检查: `bash scripts/mandatory-pre-check.sh`
- 选择任务类型
- 确认理解要求

### 阶段2: 生成内容
- 使用对应提示词生成
- 保存到正确路径
- 验证文件存在且大小>1KB

### 阶段3: 用户交付（关键）
- 统计行数: `wc -l < 文件`
- 完整推送到对话框
- 询问用户确认

### 阶段4: 持久化
- Git add
- Git commit
- Git push
- 验证推送成功

### 阶段5: 完成确认
- 用户明确表示"收到"
- 任务才算完成

---

## 七、一键恢复命令

```bash
# 1. 克隆仓库
git clone https://github.com/qingyu3880/ai-reports-silk.git

# 2. 进入目录
cd ai-reports-silk

# 3. 运行恢复脚本
bash restore.sh

# 4. 验证安装
bash scripts/daily-self-check.sh
```

---

*打包时间: 2026-03-06*
*版本: v2.0*
*包含: 5种推荐类型 + 通用流程 + 一键恢复*
