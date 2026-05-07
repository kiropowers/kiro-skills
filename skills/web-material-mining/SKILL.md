---
name: web-material-mining
description: |
  网络素材挖掘 Skill。当用户需要为公众号文章寻找新话题、搜索网络热点、提炼写作素材时使用。
  核心流程：扫描热点源（HN/X/博客/产品站）→ 去重已写话题 → 提炼可写角度 → 输出素材卡片。
  触发词包括但不限于：找选题、搜素材、有什么可以写的、搜索网络、找话题、挖素材、看看最近有什么热点。
  不用于写文章本身（写文章用解意/落地 skill），不用于深度研究（用 hv-research skill）。
---

# 网络素材挖掘

> 从噪音里捞信号，从信号里提选题。

你正在帮用户从网络上挖掘可写的公众号素材。目标是输出一组「素材卡片」，每张卡片包含话题、角度、关键事实和参考链接。

## 工作流程

```
扫描热点源 → 过滤噪音 → 去重已写 → 提炼角度 → 输出素材卡片
```

## 第一步：扫描热点源

按优先级依次扫描以下信息源。用 curl + 文本提取获取内容。

### 必扫源

| 源 | URL | 提取方式 | 关注什么 |
|---|-----|---------|---------|
| Hacker News 首页 | `https://news.ycombinator.com/front` | curl + sed 去标签 | AI/Agent/LLM/coding 相关条目，看 points 数 |
| Anthropic Engineering Blog | `https://www.anthropic.com/engineering` | curl 提取文章列表 | 新发布的技术博客 |
| Simon Willison's Weblog | `https://simonwillison.net/` | curl 提取最新条目 | AI 工具观察、agentic engineering |
| Hermes Agent 官网 | `https://hermes-agent.nousresearch.com/` | curl 提取特性列表 | 新功能、新版本 |

### 选扫源（根据用户关注方向）

| 源 | URL | 适用场景 |
|---|-----|---------|
| Product Hunt | `https://www.producthunt.com` | AI 产品发布 |
| The Unwind AI | `https://www.theunwindai.com` | Agent 工具评测 |
| Latent Space Podcast | `https://www.latent.space` | AI 深度话题 |
| AI News (Jack Clark) | `https://jack-clark.net` | AI 政策和行业趋势 |

### 搜索技巧

```bash
# HN 首页，提取标题和分数
curl -s "https://news.ycombinator.com/front" | sed 's/<[^>]*>//g' | grep -i -E "agent|AI|LLM|claude|openai|cursor|copilot|vibe|coding|hermes"

# 某个具体页面的正文
curl -s -L "URL" | sed 's/<[^>]*>//g' | sed '/^$/d' | grep -v "^[[:space:]]*$" | head -200

# Anthropic 博客文章内容（JSON-LD 里有 articleBody）
curl -s -L "URL" | grep -o '"articleBody":"[^"]*"' | head -1
```

如果某个源被 Cloudflare 拦截（返回 challenge 页面），跳过它，用其他源补充。

## 第二步：过滤噪音

从扫描结果中筛选，只保留符合以下条件的内容：

1. **与 AI Agent / 开发者工具 / AI 落地应用相关**
2. **有具体的产品、工具或方法论**（不是纯观点/纯新闻）
3. **HN points > 100 或来自权威一手源**
4. **有可操作的落地角度**（读者看完能做点什么）

丢弃：纯融资新闻、纯模型跑分、纯政策讨论、没有落地价值的学术论文。

## 第三步：去重已写话题

检查用户已有的文章目录，避免重复。

```bash
# 扫描已写文章的文件名和关键词
ls /home/administrator/workspace/weixin/baowen/
ls /home/administrator/workspace/docs/
```

如果某个话题已经写过（文件名或内容高度相关），标记为「已覆盖」，不再推荐。

但如果有新角度（比如同一产品的新功能、新的竞品对比），可以标记为「可追更」。

## 第四步：提炼角度

对每个通过筛选的话题，提炼一个「解意+落地」的写作角度。

角度提炼的标准：
- **有核**：能用一句话说清楚核心洞察
- **有画面**：能找到一个具体的场景切入
- **有落地**：读者看完能跟着做一件事
- **有情绪**：能引发「我也需要这个」或「原来如此」的反应

## 第五步：输出素材卡片

每个话题输出一张素材卡片，格式如下：

```
### [话题标题]

**来源：** [URL]（HN Xpoints / 发布日期）
**核（一句话）：** 
**解意角度：** 
**落地角度：** 
**关键事实：**
- 事实1
- 事实2
- 事实3
**参考链接：**
- [链接1](URL)
- [链接2](URL)
**爆文潜力：** ⭐⭐⭐⭐⭐（1-5星）
**理由：** 为什么这个话题能火
```

## 输出要求

- 每次输出 3-6 张素材卡片
- 按爆文潜力从高到低排序
- 卡片之间用分割线隔开
- 最后附一个总结表格，方便用户快速选择

```
| # | 话题 | 核 | 爆文潜力 | 状态 |
|---|------|-----|---------|------|
| 1 | ... | ... | ⭐⭐⭐⭐⭐ | 可写 |
| 2 | ... | ... | ⭐⭐⭐⭐ | 可写 |
| 3 | ... | ... | ⭐⭐⭐ | 可追更 |
```

## 与其他 Skill 的关系

- 素材卡片产出后，用户选定话题 → 触发「解意」skill 写解读文
- 解意完成后 → 触发「落地」skill 写教程
- 如果需要深入研究某个产品 → 触发「hv-research」skill

本 skill 只负责「找到值得写的东西」。不负责写。
