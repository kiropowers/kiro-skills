# kiro-skills

我的 [Kiro CLI](https://kiro.dev) 自定义技能集。

## 安装

### 一键安装（推荐）

```bash
git clone https://github.com/YOUR_USERNAME/kiro-skills.git /tmp/kiro-skills
bash /tmp/kiro-skills/scripts/install.sh
rm -rf /tmp/kiro-skills
```

### 手动安装

```bash
git clone https://github.com/YOUR_USERNAME/kiro-skills.git
cp -r kiro-skills/skills/* ~/.kiro/skills/
```

### 安装单个技能

```bash
git clone https://github.com/YOUR_USERNAME/kiro-skills.git /tmp/kiro-skills
cp -r /tmp/kiro-skills/skills/skill-creator ~/.kiro/skills/
rm -rf /tmp/kiro-skills
```

## 技能

| 技能 | 说明 |
|------|------|
| **skill-creator** | 技能创建向导 — 引导创建新技能，包含初始化脚本和验证工具 |

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
