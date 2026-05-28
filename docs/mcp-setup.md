# MCP 搜索工具配置指南

本文档教你如何为 Kiro CLI 配置 Tavily 和 Exa 搜索 MCP，让 `web-material-mining` 等 skill 能够使用网络搜索能力。

## 前提条件

- Kiro CLI 已安装
- Node.js 18+（用于 npx 运行 MCP server）
- Tavily API Key（免费注册）
- Exa API Key（免费注册）

## 第一步：获取 API Key

### Tavily

1. 访问 [tavily.com](https://tavily.com)
2. 注册账号（免费额度：1000 次搜索/月）
3. 在 Dashboard 复制 API Key

### Exa

1. 访问 [exa.ai](https://exa.ai)
2. 注册账号（免费额度：1000 次搜索/月）
3. 在 Settings → API Keys 复制 Key

## 第二步：配置 MCP

编辑 `~/.kiro/mcp.json`（如果不存在就创建）：

```json
{
  "mcpServers": {
    "tavily": {
      "command": "npx",
      "args": ["-y", "tavily-mcp"],
      "env": {
        "TAVILY_API_KEY": "你的-tavily-api-key"
      }
    },
    "exa": {
      "command": "npx",
      "args": ["-y", "exa-mcp-server"],
      "env": {
        "EXA_API_KEY": "你的-exa-api-key"
      }
    }
  }
}
```

把 `你的-tavily-api-key` 和 `你的-exa-api-key` 替换成你自己的 key。

## 第三步：验证配置

重启 Kiro CLI，然后测试：

```
> 搜索一下最近的 AI agent 热点
```

如果配置正确，Kiro 会调用 Tavily 和 Exa 进行搜索并返回结果。

## 配置说明

| 字段 | 说明 |
|------|------|
| `command` | MCP server 的启动命令。`npx` 会自动下载并运行 |
| `args` | 命令参数。`-y` 跳过确认，后面是包名 |
| `env` | 环境变量，传入 API Key |

## Tavily vs Exa 的区别

| 维度 | Tavily | Exa |
|------|--------|-----|
| 擅长 | 新闻、时效性内容、实时搜索 | 深度文章、技术博客、语义匹配 |
| 查询方式 | 关键词（像 Google） | 描述理想页面（语义搜索） |
| 时间过滤 | ✅ 支持 time_range | ❌ 不支持 |
| 免费额度 | 1000 次/月 | 1000 次/月 |
| 最佳用途 | 「最近一周有什么新闻」 | 「找一篇对比 X 和 Y 的深度文章」 |

两者互补，建议都配置。`web-material-mining` skill 会同时使用两者并合并结果。

## 常见问题

### npx 报错 "command not found"

确保 Node.js 已安装：

```bash
node --version  # 需要 v18+
npm --version
```

如果没有，安装 Node.js：

```bash
# macOS
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### MCP server 启动超时

首次运行时 npx 需要下载包，可能较慢。第二次会使用缓存，速度正常。

如果持续超时，可以预先全局安装：

```bash
npm install -g tavily-mcp exa-mcp-server
```

然后把 `mcp.json` 中的 command 改为直接路径：

```json
{
  "command": "tavily-mcp",
  "args": []
}
```

### 如何确认 MCP 已连接

在 Kiro CLI 中运行：

```
> /context show
```

应该能看到 tavily 和 exa 列在可用的 MCP tools 中。

## 安全提示

- API Key 存在本地 `~/.kiro/mcp.json` 中，不要提交到 git
- 确保 `.gitignore` 包含 `mcp.json`
- 免费额度用完后会返回错误，不会自动扣费（除非你开启了付费计划）
