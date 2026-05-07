---
name: skill-creator
description: Guide for creating effective skills. Use when users want to create a new skill (or update an existing skill) that extends Kiro's capabilities with specialized knowledge, workflows, or tool integrations.
---

# Skill Creator

This skill provides guidance for creating effective skills.

## About Skills

Skills are modular, self-contained folders that extend Kiro's capabilities by providing
specialized knowledge, workflows, and tools. Think of them as "onboarding guides" for specific
domains or tasks—they transform Kiro from a general-purpose agent into a specialized agent
equipped with procedural knowledge that no model can fully possess.

### What Skills Provide

1. Specialized workflows - Multi-step procedures for specific domains
2. Tool integrations - Instructions for working with specific file formats or APIs
3. Domain expertise - Company-specific knowledge, schemas, business logic
4. Bundled resources - Scripts, references, and assets for complex and repetitive tasks

## Core Principles

### Concise is Key

The context window is a public good. Skills share the context window with everything else Kiro needs: system prompt, conversation history, other Skills' metadata, and the actual user request.

**Default assumption: Kiro is already very smart.** Only add context Kiro doesn't already have. Challenge each piece of information: "Does Kiro really need this explanation?" and "Does this paragraph justify its token cost?"

Prefer concise examples over verbose explanations.

### Set Appropriate Degrees of Freedom

Match the level of specificity to the task's fragility and variability:

**High freedom (text-based instructions)**: Use when multiple approaches are valid, decisions depend on context, or heuristics guide the approach.

**Medium freedom (pseudocode or scripts with parameters)**: Use when a preferred pattern exists, some variation is acceptable, or configuration affects behavior.

**Low freedom (specific scripts, few parameters)**: Use when operations are fragile and error-prone, consistency is critical, or a specific sequence must be followed.

### Protect Validation Integrity

You may use subagents during iteration to validate whether a skill works on realistic tasks or whether a suspected problem is real. Only do this when it is possible to start new subagents.

When using subagents for validation, treat that as an evaluation surface. The goal is to learn whether the skill generalizes, not whether another agent can reconstruct the answer from leaked context.

### Anatomy of a Skill

Every skill consists of a required SKILL.md file and optional bundled resources:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation intended to be loaded into context as needed
    └── assets/           - Files used in output (templates, icons, fonts, etc.)
```

#### SKILL.md (required)

Every SKILL.md consists of:

- **Frontmatter** (YAML): Contains `name` and `description` fields. These are the only fields that Kiro reads to determine when the skill gets used, thus it is very important to be clear and comprehensive in describing what the skill is, and when it should be used.
- **Body** (Markdown): Instructions and guidance for using the skill. Only loaded AFTER the skill triggers (if at all).

#### Bundled Resources (optional)

##### Scripts (`scripts/`)

Executable code (Python/Bash/etc.) for tasks that require deterministic reliability or are repeatedly rewritten.

- **When to include**: When the same code is being rewritten repeatedly or deterministic reliability is needed
- **Example**: `scripts/rotate_pdf.py` for PDF rotation tasks
- **Benefits**: Token efficient, deterministic, may be executed without loading into context
- **Note**: Scripts may still need to be read by Kiro for patching or environment-specific adjustments

##### References (`references/`)

Documentation and reference material intended to be loaded as needed into context to inform Kiro's process and thinking.

- **When to include**: For documentation that Kiro should reference while working
- **Examples**: `references/finance.md` for financial schemas, `references/api_docs.md` for API specifications
- **Best practice**: If files are large (>10k words), include grep search patterns in SKILL.md
- **Avoid duplication**: Information should live in either SKILL.md or references files, not both.

##### Assets (`assets/`)

Files not intended to be loaded into context, but rather used within the output Kiro produces.

- **When to include**: When the skill needs files that will be used in the final output
- **Examples**: `assets/logo.png` for brand assets, `assets/slides.pptx` for PowerPoint templates
- **Benefits**: Separates output resources from documentation

#### What to Not Include in a Skill

A skill should only contain essential files that directly support its functionality. Do NOT create extraneous documentation or auxiliary files (README.md, CHANGELOG.md, etc.).

### Progressive Disclosure Design Principle

Skills use a three-level loading system to manage context efficiently:

1. **Metadata (name + description)** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words)
3. **Bundled resources** - As needed (Unlimited because scripts can be executed without reading into context window)

Keep SKILL.md body to the essentials and under 500 lines. Split content into separate files when approaching this limit. Reference them from SKILL.md and describe clearly when to read them.

## Skill Creation Process

1. Understand the skill with concrete examples
2. Plan reusable skill contents (scripts, references, assets)
3. Initialize the skill (run init_skill.py)
4. Edit the skill (implement resources and write SKILL.md)
5. Validate the skill (run quick_validate.py)
6. Iterate based on real usage and forward-test complex skills.

### Skill Naming

- Use lowercase letters, digits, and hyphens only; normalize user-provided titles to hyphen-case.
- Keep under 64 characters.
- Prefer short, verb-led phrases that describe the action.
- Name the skill folder exactly after the skill name.

### Step 1: Understanding the Skill with Concrete Examples

Skip this step only when the skill's usage patterns are already clearly understood.

To create an effective skill, clearly understand concrete examples of how the skill will be used. Ask questions like:

- "What functionality should this skill support?"
- "Can you give some examples of how this skill would be used?"
- "What would a user say that should trigger this skill?"
- "Where should I create this skill? Default is `~/.kiro/skills`."

### Step 2: Planning the Reusable Skill Contents

Analyze each concrete example by:

1. Considering how to execute on the example from scratch
2. Identifying what scripts, references, and assets would be helpful when executing these workflows repeatedly

### Step 3: Initializing the Skill

Before running `init_skill.py`, ask where the user wants the skill created. Default to `~/.kiro/skills`.

Usage:

```bash
scripts/init_skill.py <skill-name> --path <output-directory> [--resources scripts,references,assets] [--examples]
```

Examples:

```bash
scripts/init_skill.py my-skill --path ~/.kiro/skills
scripts/init_skill.py my-skill --path ~/.kiro/skills --resources scripts,references
scripts/init_skill.py my-skill --path ~/work/skills --resources scripts --examples
```

The script:

- Creates the skill directory at the specified path
- Generates a SKILL.md template with proper frontmatter and TODO placeholders
- Optionally creates resource directories based on `--resources`
- Optionally adds example files when `--examples` is set

### Step 4: Edit the Skill

When editing the skill, remember it is being created for another instance of Kiro to use. Include information that would be beneficial and non-obvious.

#### Start with Reusable Skill Contents

Begin with the reusable resources identified above. Added scripts must be tested by actually running them.

#### Update SKILL.md

##### Frontmatter

Write the YAML frontmatter with `name` and `description`:

- `name`: The skill name
- `description`: Primary triggering mechanism. Include both what the Skill does and specific triggers/contexts for when to use it. Include all "when to use" information here - Not in the body.

Do not include any other fields in YAML frontmatter.

##### Body

Write instructions for using the skill and its bundled resources.

### Step 5: Validate the Skill

Once development is complete, validate the skill folder:

```bash
scripts/quick_validate.py <path/to/skill-folder>
```

The validation script checks YAML frontmatter format, required fields, and naming rules.

### Step 6: Iterate

After testing the skill, iterate based on real usage. Forward-test complex skills with subagents.

## Forward-testing

To forward-test, launch subagents to stress test the skill with minimal context.
Subagents should *not* know that they are being asked to test the skill. Prompts should look like:
  `Use $skill-x at /path/to/skill-x to solve problem y`
Not:
  `Review the skill at /path/to/skill-x; pretend a user asks you to...`

Decision rule for forward-testing:
  - Err on the side of forward-testing
  - Ask for approval if forward-testing would take a long time, require additional approvals, or modify live production systems
