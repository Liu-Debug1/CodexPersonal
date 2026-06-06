#!/usr/bin/env bash
# 快速创建新 skill: bash scripts/create-skill.sh <分类> <skill-name>
# 分类: 开发工具 | 文档处理 | 媒体设计 | 工作流效率 | 专业领域

set -e

if [ $# -lt 2 ]; then
    echo "用法: bash scripts/create-skill.sh <分类> <skill-name>"
    echo "分类: 开发工具 | 文档处理 | 媒体设计 | 工作流效率 | 专业领域"
    exit 1
fi

CATEGORY="$1"
SKILL_NAME="$2"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

case "$CATEGORY" in
    开发工具|文档处理|媒体设计|工作流效率|专业领域) ;;
    *) echo "错误: 无效分类"; exit 1 ;;
esac

TARGET="$REPO_ROOT/$CATEGORY/$SKILL_NAME"
if [ -d "$TARGET" ]; then
    echo "错误: 已存在"; exit 1
fi

cp -r "$REPO_ROOT/_template" "$TARGET"
sed -i "s/skill-name/$SKILL_NAME/g" "$TARGET/SKILL.md" "$TARGET/evals/evals.json"
echo "✅ 已创建: $CATEGORY/$SKILL_NAME"
