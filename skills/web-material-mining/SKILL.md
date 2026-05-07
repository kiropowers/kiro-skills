---
name: web-material-mining
description: >
  Use when the user needs to find topics, mine material, or discover trending content for WeChat articles.
  Handles scanning tech news sources, filtering noise, deduplicating against published articles, and outputting structured material cards.
  触发词：找选题、搜素材、有什么可以写的、搜索网络、找话题、挖素材、看看最近有什么热点。
  不用于写文章本身（用解意/落地 skill），不用于深度研究（用 hv-research skill）。
---

# 网络素材挖掘

## 第一步：扫描热点源

### 必扫源

| 源 | URL | 关注什么 |
|---|-----|---------|
| Hacker News 首页 | `https://news.ycombinator.com/front` | AI/Agent/LLM/coding 相关条目，看 points 数 |
| Anthropic Engineering Blog | `https://www.anthropic.com/engineering` | 新发布的技术博客 |
| Simon Willison's Weblog | `https://simonwillison.net/` | AI 工具观察、agentic engineering |

### 选扫源（根据用户关注方向）

| 源 | URL | 适用场景 |
|---|-----|---------|
| Product Hunt | `https://www.producthunt.com` | AI 产品发布 |
| The Unwind AI | `https://www.theunwindai.com` | Agent 工具评测 |
| Latent Space Podcast | `https://www.latent.space` | AI 深度话题 |

如果必扫源已产出 5+ 候选话题，可跳过选扫源。

### 抓取方式

用 curl 提取页面可读文本（去除 HTML 标签和空行），过滤 AI/Agent/LLM/claude/openai/cursor/coding 相关内容。

```bash
# 示例：HN 首页
curl -s -L --max-time 15 "https://news.ycombinator.com/front" | sed 's/<[^>]*>//g' | grep -i -E "agent|AI|LLM|claude|openai|cursor|coding"
```

### 失败处理

- curl 返回空内容或超时：跳过该源，继续下一个
- 超过一半的源不可用：告知用户，询问是否有其他 URL 可手动提供
- 过滤后没有话题通过：放宽 HN points 阈值到 >50，或扩展到选扫源

## 第二步：过滤噪音

### 保留条件（全部满足）

1. 与 AI Agent / 开发者工具 / AI 落地应用相关
2. 有具体的产品、工具或方法论
3. HN points > 100 或来自权威一手源
4. 有可操作的落地角度（读者看完能做点什么）

### 丢弃条件（命中任一）

- 纯融资新闻、纯模型跑分、纯政策讨论
- 没有落地价值的学术论文

## 第三步：去重已写话题

检查用户的文章目录（通常在 workspace 下的 weixin/ 或 docs/ 目录），避免重复推荐已写话题。

如果某话题已写过但有新角度（新功能、新竞品对比），标记为「可追更」而非丢弃。

如果目录不存在，跳过去重步骤并告知用户。

## 第四步：提炼角度

对每个通过筛选的话题，提炼一个写作角度，标准：

- **有核**：能用一句话说清楚核心洞察
- **有画面**：能找到一个具体的场景切入
- **有落地**：读者看完能跟着做一件事
- **有情绪**：能引发「我也需要这个」或「原来如此」的反应

## 第五步：输出素材卡片

每次输出 3-6 张，按爆文潜力从高到低排序。话题越具体、落地越强，输出越多。

```
### [话题标题]

**来源：** [URL]（HN X points / 发布日期）
**核（一句话）：**
**解意角度：**
**落地角度：**
**关键事实：**
- 事实1
- 事实2
**参考链接：**
- [链接1](URL)
**爆文潜力：** ⭐⭐⭐⭐⭐（1-5星）
**理由：**
```

最后附总结表格：

```
| # | 话题 | 核 | 爆文潜力 | 状态 |
|---|------|-----|---------|------|
| 1 | ... | ... | ⭐⭐⭐⭐⭐ | 可写 |
```
