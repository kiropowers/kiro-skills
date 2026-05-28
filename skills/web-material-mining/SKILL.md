---
name: web-material-mining
description: >
  Use when the user needs to find topics, mine material, or discover trending content for WeChat articles.
  Handles scanning tech news sources via multiple search tools (Tavily, Exa, web_fetch), filtering noise, deduplicating against published articles, and outputting structured material cards.
  触发词：找选题、搜素材、有什么可以写的、搜索网络、找话题、挖素材、看看最近有什么热点。
  不用于写文章本身（用解意/落地 skill），不用于深度研究（用 hv-research skill）。
---

# 网络素材挖掘

## 第一步：多源搜索

同时使用三种搜索工具，覆盖不同类型的内容。三者返回结果重叠率通常不到 30%，合并后覆盖面最广。

### 工具一：Tavily（时效性 + 新闻）

用 `tavily_search` 搜索最近 7 天的热点。Tavily 擅长新闻、公告、趋势类内容。

```
tavily_search:
  query: 用户关注的关键词（如 "AI agent open source trending"）
  time_range: week
  search_depth: advanced
  max_results: 10
```

**搜索策略：**
- 第一轮：宽泛搜索（如 "AI agent news this week"）
- 第二轮：针对性搜索（如 "Hermes Agent update" 或用户指定的方向）
- 如果用户没指定方向，用以下默认关键词组合：
  - `AI agent open source trending 2026`
  - `Claude Code Hermes OpenClaw latest`
  - `LLM coding agent new release`

### 工具二：Exa（语义 + 深度内容）

用 `web_search_exa` 搜索深度技术文章、教程、分析。Exa 擅长找到 Tavily 漏掉的长文和技术博客。

```
web_search_exa:
  query: 描述理想页面（如 "blog post comparing AI coding agents in 2026 with benchmarks"）
  numResults: 10
```

**Exa 的 query 写法：** 描述你想找的理想页面，不是关键词。
- ✅ "technical deep dive into Hermes Agent skill system and self-improvement loop"
- ❌ "Hermes Agent skill"

### 工具三：web_fetch（固定源兜底）

用 `web_fetch` 抓取固定的高质量源，确保核心信息不漏。

| 源 | URL | 关注什么 |
|---|-----|---------|
| Hacker News 首页 | `https://news.ycombinator.com/front` | AI/Agent 相关，看 points 数 |
| Anthropic Blog | `https://www.anthropic.com/news` | 新发布的产品/研究 |
| Simon Willison | `https://simonwillison.net/` | AI 工具观察 |

```
web_fetch:
  url: https://news.ycombinator.com/front
  mode: selective
  search_terms: "agent AI LLM claude hermes"
```

### 搜索顺序和并行

三个工具**并行调用**（它们之间没有依赖关系）。如果某个工具失败或超时，不影响其他两个。

### 失败处理

- 单个工具失败：跳过，用其他两个的结果
- 两个以上失败：告知用户网络状况不佳，展示已获取的结果
- 全部失败：建议用户稍后重试或手动提供 URL

## 第二步：合并去重

将三个来源的结果合并：

1. **按话题聚类** — 同一个事件/产品/发布，不同来源可能用不同标题报道
2. **去重规则** — URL 相同直接去重；标题相似度 >70% 视为同一话题，保留信息最丰富的那条
3. **标记交叉验证** — 如果一个话题同时出现在 Tavily 和 Exa 中，标记为「多源验证 ✓」，爆文潜力加分

## 第三步：过滤噪音

### 保留条件（全部满足）

1. 与 AI Agent / 开发者工具 / AI 落地应用相关
2. 有具体的产品、工具或方法论（不是空泛讨论）
3. 有可操作的落地角度（读者看完能做点什么）
4. 时效性：7 天内优先，14 天内可接受，超过 14 天除非是持续热点否则丢弃

### 丢弃条件（命中任一）

- 纯融资新闻（除非金额 >$1B 或涉及核心玩家）
- 纯模型跑分（除非有实际使用体验对比）
- 纯政策讨论（除非直接影响开发者）
- 没有落地价值的学术论文
- 只有中文公众号在写、找不到英文一手源的话题（洗稿风险高）

## 第四步：去重已写话题

检查用户的文章目录（通常在 workspace 下的文章目录），避免重复推荐已写话题。

- 如果某话题已写过但有新角度（新版本、新数据、新竞品），标记为「可追更」
- 如果目录不存在或用户未指定，跳过去重并告知

## 第五步：提炼角度

对每个通过筛选的话题，提炼写作角度：

- **有核**：能用一句话说清楚核心洞察
- **有画面**：能找到一个具体的场景切入
- **有落地**：读者看完能跟着做一件事
- **有情绪**：能引发「我也需要这个」或「原来如此」的反应

## 第六步：输出素材卡片

每次输出 3-6 张，按爆文潜力从高到低排序。

```
### [话题标题]

**来源：** [URL]（Tavily/Exa/HN · 发布日期）
**多源验证：** ✓ 出现在 Tavily + Exa / ✗ 仅单源
**核（一句话）：**
**解意角度：**
**落地角度：**
**关键事实：**
- 事实1
- 事实2
**参考链接：**
- [链接1](URL)
- [链接2](URL)
**爆文潜力：** ⭐⭐⭐⭐⭐（1-5星）
**理由：**
```

最后附总结表格：

```
| # | 话题 | 核 | 多源验证 | 爆文潜力 | 状态 |
|---|------|-----|---------|---------|------|
| 1 | ... | ... | ✓ | ⭐⭐⭐⭐⭐ | 可写 |
```

## 爆文潜力评估标准

| 维度 | 高分 | 低分 |
|------|------|------|
| 数据冲击力 | 有具体数字 | 只有模糊描述 |
| 争议性 | 有正反两面 | 纯正面报道 |
| 实用性 | 读者能立刻动手 | 只能看看 |
| 时效性 | 这周刚发生 | 超过两周 |
| 情绪共鸣 | 戳中痛点 | 跟读者无关 |
| 多源验证 | Tavily + Exa 都有 | 仅单源 |

5 个维度 + 多源验证加分。3 星以上值得写。
