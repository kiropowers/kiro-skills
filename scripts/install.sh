#!/bin/bash
# 安装 kiro-skills 到 ~/.kiro/skills/
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_DIR/skills"
TARGET_DIR="${KIRO_SKILLS_DIR:-$HOME/.kiro/skills}"

mkdir -p "$TARGET_DIR"

echo "Installing kiro-skills to $TARGET_DIR ..."

for skill in "$SKILLS_DIR"/*/; do
    skill_name="$(basename "$skill")"
    echo "  → $skill_name"
    cp -r "$skill" "$TARGET_DIR/"
done

echo "Done. Installed $(ls -d "$SKILLS_DIR"/*/ | wc -l) skill(s)."
