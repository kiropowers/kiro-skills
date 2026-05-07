# Mermaid 绘图规范

本文件是「本来无尘」所有 skill 共享的 mermaid 绘图规则。各 skill 中涉及 mermaid 图的地方，统一遵守本规范。

## 主题配置（必须加在每张图的第一行）

按栏目使用对应主题。每张 mermaid 图的第一行必须加 init 配置。

**「观机小记」/ 「解意」/ 「落地」— 淡紫优雅**

```
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#f3e8ff', 'primaryBorderColor': '#9b72cf', 'primaryTextColor': '#2d1b4e', 'secondaryColor': '#e8e0f0', 'secondaryBorderColor': '#7e5eb0', 'tertiaryColor': '#faf5ff', 'tertiaryBorderColor': '#b39ddb', 'lineColor': '#7e5eb0', 'fontSize': '14px'}}}%%
```

**「一念清简」/ 「予卿慢书」— 水墨灰白**

```
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#f7f7f7', 'primaryBorderColor': '#999', 'primaryTextColor': '#333', 'secondaryColor': '#efefef', 'secondaryBorderColor': '#bbb', 'tertiaryColor': '#fafafa', 'tertiaryBorderColor': '#ccc', 'lineColor': '#999', 'fontSize': '14px'}}}%%
```

使用 init 主题配置时，不再需要手动写 classDef 和 style。主题会自动控制节点、边框、连线的颜色。如果某个节点需要特殊强调（如错误/成功），可以额外加单个 style 覆盖。

## 基本原则

- 必须使用现代语法 `flowchart TD/LR`。禁止使用已废弃的 `graph TD/LR`
- 每张图第一行必须加对应栏目的 init 主题配置
- 优先横排（LR）节约纵向空间。节点数 >2 时禁止用 TD，除非是真正的层级架构（模式四）或带分支的决策树
- flowchart LR 从左到右，flowchart TD 从上到下。确认方向符合阅读习惯，不要出现逆向箭头
- 节点文字控制在15个字以内。超过的用 \n 换行
- subgraph 标题加 emoji 前缀增强辨识度（如 `🎯 决策阶段`）
- 节点形状：普通步骤用方框 `[""]`，判断分支用菱形 `{""}`，起止点用圆角 `("")`

## 特殊强调样式（仅在需要时使用）

主题已经控制了默认颜色。以下 style 仅用于个别节点需要特殊强调时，直接写在节点后面。

```
style 节点ID fill:#f0fff4,stroke:#50c878,stroke-width:2px,color:#1a1a1a
```

| 语义 | fill | stroke | 用途 |
|------|------|--------|------|
| 成功/完成 | #f0fff4 | #50c878 | 通过、完成、输出 |
| 错误/阻断 | #fff0f0 | #e06c75 | 失败、错误、禁止 |
| 关键/注意 | #fff3e0 | #f0a500 | 需要注意的步骤 |

一张图里特殊强调的节点不超过2个。多了就失去了强调的意义。

## 按场景选择布局模式

### 模式一：线性流程（4步以内）

用 flowchart LR，节点直接连接，不用 subgraph。

```
flowchart LR
    A["步骤一"] --> B["步骤二"] --> C["步骤三"] --> D["步骤四"]
    classDef primary fill:#e8f4fd,stroke:#4a9eda,stroke-width:2px,color:#1a1a1a
    classDef success fill:#f0fff4,stroke:#50c878,stroke-width:2px,color:#1a1a1a
    class A primary
    class D success
```

### 模式二：线性流程（5步以上）

用 flowchart LR + subgraph 分阶段。每个 subgraph 2-3个节点，阶段之间用 --> 连接。

**「完整流程一览」图必须用这个模式。** 教程结尾的总结性流程图，本质是多阶段顺序流程，不是层级架构。用 LR 横排，不用 TD。

```
flowchart LR
    subgraph S1["🎯 阶段一"]
        A["步骤一"] --> B["步骤二"]
    end
    subgraph S2["⚙️ 阶段二"]
        C["步骤三"] --> D["步骤四"]
    end
    S1 --> S2
```

### 模式三：并列对比（2-3个并列项）

用 flowchart LR + subgraph 并排。每个 subgraph 内部2个节点纵向排列。subgraph 之间用 --- （无箭头连线）连接。如果 --- 渲染异常，改用不可见节点中转。

```
flowchart LR
    subgraph S1["🔍 标题一"]
        A1 --> A2
    end
    subgraph S2["🛠️ 标题二"]
        B1 --> B2
    end
    S1 --- S2
```

### 模式四：层级架构（3层以内，每层 ≥2个节点）

仅当内容具有真正的层级从属关系、且每层有2个以上并列节点时，才用 flowchart TD。如果每层只有1个节点，改用 LR 直连。

```
flowchart TD
    subgraph 顶层["⚙️ 规则层"]
        A1["规则一"]
        A2["规则二"]
    end
    subgraph 中层["📚 知识层"]
        B1["页面一"]
        B2["页面二"]
    end
    顶层 --> 中层
```

### 模式五：带分支/回环的流程

用 flowchart LR + subgraph 分阶段。判断节点用菱形。回环箭头指向目标阶段的 subgraph 标签（不指向内部节点）。

```
flowchart LR
    subgraph P1["Phase 1"]
        A --> B
    end
    subgraph P2["Phase 2"]
        C --> D{"通过？"}
    end
    P1 --> P2
    D -->|通过| E["下一步"]
    D -->|不通过| P1
```

## 禁止事项

- 禁止使用 `graph` 语法。必须用 `flowchart`
- 禁止不加 init 主题配置。每张图第一行必须有 `%%{init:...}%%`
- 禁止用 subgraph 包裹单个节点。subgraph 至少包含2个节点
- 禁止超过10个节点的单张图。超过就拆成两张图
- 禁止纵向超过6层的 TD 图。超过就改成 LR 分组横排
- 禁止节点数 >2 时使用 TD，除非是层级架构（模式四）或决策树（模式五）
- 禁止 subgraph 内部节点链超过3个。超过就压缩成一个节点用 → 符号连接步骤
- 禁止一张图里特殊强调超过2个节点

## 画完后自检（逐项过）

1. 第一行有 init 主题配置吗？栏目对应的主题用对了吗
2. 语法是 flowchart 不是 graph
3. 方向对不对？没有逆向箭头
4. 节点文字超15字了吗？超了就换行或缩写
5. 有没有单节点 subgraph？有就去掉或合并
6. 纵向超6层了吗？超了就改横向分组
7. 特殊强调的节点超过2个了吗？超了就减少
8. 能用 LR 横排吗？TD 只留给真正的层级架构和决策树
9. 想象截图：是一个合理的矩形吗？不能太窄太长，也不能太宽太扁
