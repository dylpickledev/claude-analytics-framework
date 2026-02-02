#!/bin/bash

# finish.sh - Complete and archive projects
# Usage: ./scripts/finish.sh [project-name]
# Replaces: ./scripts/work-complete.sh and manual cleanup workflows

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Ensure we're in the repo root
cd "$REPO_ROOT"

# Input validation
if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/finish.sh [project-name]"
    echo ""
    echo "Active projects:"

    if [ -d "projects/active" ]; then
        for project_dir in projects/active/*/; do
            if [ -d "$project_dir" ]; then
                project_name=$(basename "$project_dir")
                echo "  - $project_name"
            fi
        done
    else
        echo "  No active projects found"
    fi

    exit 1
fi

PROJECT_NAME="$1"
PROJECT_DIR="projects/active/$PROJECT_NAME"

# Validate project exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Project '$PROJECT_NAME' not found in projects/active/"
    echo "💡 Available projects are listed above"
    exit 1
fi

echo "🎯 Finishing project: $PROJECT_NAME"

# Use existing work-complete.sh if available
if [ -f "$SCRIPT_DIR/work-complete.sh" ]; then
    echo "📦 Using work-complete.sh for comprehensive cleanup..."
    bash "$SCRIPT_DIR/work-complete.sh" "$PROJECT_NAME"
else
    echo "📦 Performing basic project completion..."

    # Basic completion workflow
    mkdir -p projects/completed

    # Move project to completed
    mv "$PROJECT_DIR" "projects/completed/"

    # Update project status
    if [ -f "projects/completed/$PROJECT_NAME/context.md" ]; then
        echo "" >> "projects/completed/$PROJECT_NAME/context.md"
        echo "## Completion" >> "projects/completed/$PROJECT_NAME/context.md"
        echo "- **Completed**: $(date)" >> "projects/completed/$PROJECT_NAME/context.md"
        echo "- **Status**: ✅ Finished" >> "projects/completed/$PROJECT_NAME/context.md"
    fi

    echo "✅ Project moved to projects/completed/"
fi

# Worktree cleanup
WORKTREE_DIR="../da-agent-hub-worktrees/$PROJECT_NAME"

if [ -d "$WORKTREE_DIR" ]; then
    echo ""
    echo "🌿 Cleaning up git worktree..."

    # Check if worktree is currently in use (VS Code or other processes)
    if lsof "$WORKTREE_DIR" > /dev/null 2>&1; then
        echo "⚠️  Warning: Worktree appears to be in use (VS Code may be open)"
        echo "   Location: $WORKTREE_DIR"
        echo ""
        read -p "Continue with worktree cleanup? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "   Skipping worktree cleanup"
            echo "   💡 Manually remove later with: git worktree remove $WORKTREE_DIR --force"
        else
            # Force remove worktree
            git worktree remove "$WORKTREE_DIR" --force 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "   ✅ Worktree removed: $WORKTREE_DIR"
            else
                echo "   ⚠️  Could not remove worktree automatically"
                echo "   💡 Close VS Code and run: git worktree remove $WORKTREE_DIR --force"
            fi
        fi
    else
        # No processes using worktree, safe to remove
        git worktree remove "$WORKTREE_DIR" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "   ✅ Worktree removed: $WORKTREE_DIR"
        else
            echo "   ⚠️  Worktree removal failed, may need manual cleanup"
            echo "   💡 Run: git worktree remove $WORKTREE_DIR --force"
        fi
    fi
fi

# Check if we're on a feature branch for this project
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" == *"$PROJECT_NAME"* ]] || [[ "$CURRENT_BRANCH" == "feature-"* ]]; then
    echo ""
    echo "🔀 Git workflow options:"
    echo "   1. Create PR: gh pr create --title \"Complete $PROJECT_NAME\" --body \"Project completion\""
    echo "   2. Merge to main: git checkout main && git merge $CURRENT_BRANCH"
    echo "   3. Stay on branch: Continue working"
    echo ""
    echo "💡 Recommended: Create PR for review before merging"
fi

# Extract patterns and learnings to official Claude Code locations
echo "📚 Extracting reusable patterns..."
RULES_DIR="$REPO_ROOT/.claude/rules"
REFERENCE_DIR="$REPO_ROOT/.claude/skills/reference-knowledge"
LEARNINGS_FILE="$RULES_DIR/recent-learnings-$(date +%Y-%m).md"
PROJECT_LEARNINGS_DIR="$REFERENCE_DIR/project-learnings-$(date +%Y-%m)"

# Ensure directories exist
mkdir -p "$RULES_DIR" "$REFERENCE_DIR"

# Extract patterns from task findings
if [ -d "$REPO_ROOT/.claude/tasks" ]; then
    PATTERN_COUNT=0
    SKILL_COUNT=0

    # Create or append to monthly learnings file
    if [ ! -f "$LEARNINGS_FILE" ]; then
        echo "# Recent Learnings - $(date +%B %Y)" > "$LEARNINGS_FILE"
        echo "" >> "$LEARNINGS_FILE"
        echo "Auto-extracted patterns from completed projects." >> "$LEARNINGS_FILE"
        echo "" >> "$LEARNINGS_FILE"
    fi

    echo "" >> "$LEARNINGS_FILE"
    echo "## Project: $PROJECT_NAME ($(date +%Y-%m-%d))" >> "$LEARNINGS_FILE"
    echo "" >> "$LEARNINGS_FILE"

    # Search for pattern markers in all task findings
    for findings_file in $(find "$REPO_ROOT/.claude/tasks" -name "*.md" -type f 2>/dev/null); do
        if grep -q "PATTERN:\|SOLUTION:\|ERROR-FIX:\|ARCHITECTURE:\|INTEGRATION:" "$findings_file" 2>/dev/null; then
            TASK_NAME=$(basename $(dirname "$findings_file"))
            FILE_NAME=$(basename "$findings_file")

            # Extract simple patterns to rules/recent-learnings
            echo "### $TASK_NAME/$FILE_NAME" >> "$LEARNINGS_FILE"
            echo "" >> "$LEARNINGS_FILE"
            grep "PATTERN:\|SOLUTION:\|ERROR-FIX:" "$findings_file" >> "$LEARNINGS_FILE" 2>/dev/null
            echo "" >> "$LEARNINGS_FILE"
            PATTERN_COUNT=$((PATTERN_COUNT + 1))

            # Extract complex patterns (ARCHITECTURE/INTEGRATION) to reference-knowledge
            if grep -q "ARCHITECTURE:\|INTEGRATION:" "$findings_file" 2>/dev/null; then
                mkdir -p "$PROJECT_LEARNINGS_DIR"
                SKILL_FILE="$PROJECT_LEARNINGS_DIR/${TASK_NAME}.md"

                echo "# $TASK_NAME - Complex Patterns" > "$SKILL_FILE"
                echo "" >> "$SKILL_FILE"
                echo "**Source**: $FILE_NAME" >> "$SKILL_FILE"
                echo "**Project**: $PROJECT_NAME" >> "$SKILL_FILE"
                echo "**Date**: $(date +%Y-%m-%d)" >> "$SKILL_FILE"
                echo "" >> "$SKILL_FILE"
                grep "ARCHITECTURE:\|INTEGRATION:" "$findings_file" >> "$SKILL_FILE" 2>/dev/null

                SKILL_COUNT=$((SKILL_COUNT + 1))
            fi
        fi
    done

    if [ $PATTERN_COUNT -gt 0 ]; then
        echo "   ✅ Extracted patterns from $PATTERN_COUNT files"
        echo "   📁 Simple patterns: .claude/rules/recent-learnings-$(date +%Y-%m).md"

        if [ $SKILL_COUNT -gt 0 ]; then
            echo "   📁 Complex patterns: .claude/skills/reference-knowledge/project-learnings-$(date +%Y-%m)/"
        fi

        # Clean up task findings after extraction
        echo "   🧹 Cleaning up extracted task findings..."
        find "$REPO_ROOT/.claude/tasks" -name "*.md" -type f -delete 2>/dev/null
    else
        echo "   ℹ️  No patterns found to extract"
    fi
else
    echo "   ℹ️  No task findings directory found"
fi

# Close related GitHub issue if it exists
echo "🔗 Checking for linked GitHub issue..."
SPEC_FILE="projects/completed/$PROJECT_NAME/spec.md"
if [ -f "$SPEC_FILE" ]; then
    # Extract issue number from spec file (looks for #[number] pattern)
    ISSUE_NUMBER=$(grep -oE "#[0-9]+" "$SPEC_FILE" | head -1 | tr -d '#')

    if [ -n "$ISSUE_NUMBER" ]; then
        echo "   Found linked issue #$ISSUE_NUMBER"

        # Close the issue with a completion comment
        gh issue close "$ISSUE_NUMBER" --comment "✅ **Project Completed**

This idea has been successfully implemented and the project is now complete.

**Project**: \`$PROJECT_NAME\`
**Completion Date**: $(date)
**Status**: ✅ Finished

The project has been moved to \`projects/completed/$PROJECT_NAME/\` and all implementation work is complete." 2>/dev/null

        if [ $? -eq 0 ]; then
            echo "   ✅ Closed GitHub issue #$ISSUE_NUMBER"
        else
            echo "   ⚠️  Could not close issue #$ISSUE_NUMBER (may already be closed)"
        fi
    else
        echo "   ℹ️  No linked GitHub issue found"
    fi
else
    echo "   ℹ️  No spec file found"
fi

# Update any related archived ideas (legacy support)
echo "🔗 Updating related archived ideas (if any)..."
if [ -d "ideas/archive" ]; then
    for archived_idea in ideas/archive/*.md; do
        if [ -f "$archived_idea" ] && grep -q "$PROJECT_NAME" "$archived_idea"; then
            # Update status in archived idea
            sed -i.bak "s/Status**: In Development/Status**: ✅ Completed $(date)/" "$archived_idea"
            rm -f "${archived_idea}.bak"
            echo "   Updated: $(basename "$archived_idea")"
        fi
    done
fi

echo ""
echo "✅ Project '$PROJECT_NAME' completed successfully!"
echo "📁 Location: projects/completed/$PROJECT_NAME/"
echo ""
echo "🎉 Next steps:"
echo "   - Review completed work"
echo "   - Document lessons learned"
echo "   - Plan next project: ./scripts/build.sh [idea-name]"