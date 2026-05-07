# kiro-skills

我的 [Kiro CLI](https://kiro.dev) 自定义技能集。

## 安装

### 使用 skills CLI（推荐）

```bash
# 安装全部技能
npx skills add kiropowers/kiro-skills -g --all

# 安装单个技能
npx skills add kiropowers/kiro-skills -g --skill skill-creator

# 查看可用技能
npx skills add kiropowers/kiro-skills --list
```

### 手动安装

```bash
git clone https://github.com/kiropowers/kiro-skills.git /tmp/kiro-skills
bash /tmp/kiro-skills/scripts/install.sh
rm -rf /tmp/kiro-skills
```

## 技能

| 技能 | 说明 |
|------|------|
| **skill-creator** | 技能创建向导 — 引导创建新技能，包含初始化脚本和验证工具 |
| **web-material-mining** | 网络素材挖掘 — 扫描热点源（HN/博客/产品站）→ 去重 → 提炼写作角度 → 输出素材卡片 |
| **hv-research** | 深度研究 — 对特定产品/技术进行深入调研，输出结构化研究报告 |

## 技能详情

### skill-creator

帮助创建和维护 Kiro skills 的元技能。提供：

- **SKILL.md** — 技能创建的完整指南（命名规范、目录结构、渐进式加载设计）
- **scripts/init_skill.py** — 脚手架脚本，一键生成新技能模板
- **scripts/quick_validate.py** — 验证技能格式是否正确

使用示例：

```bash
# 创建新技能
python3 ~/.kiro/skills/skill-creator/scripts/init_skill.py my-new-skill

# 指定资源目录
python3 ~/.kiro/skills/skill-creator/scripts/init_skill.py my-skill --resources scripts,references

# 验证技能
python3 ~/.kiro/skills/skill-creator/scripts/quick_validate.py ~/.kiro/skills/my-skill
```

## 目录结构

```
kiro-skills/
├── README.md
├── .gitignore
├── scripts/
│   └── install.sh          # 安装脚本
└── skills/
    └── skill-creator/      # 技能创建向导
        ├── SKILL.md
        └── scripts/
            ├── init_skill.py
            └── quick_validate.py
```

## 兼容性

这些技能为 Kiro CLI 设计，使用标准的 SKILL.md 格式（YAML frontmatter + Markdown body）。技能存放在 `~/.kiro/skills/` 目录下即可被 Kiro 自动发现。

## License

MIT
