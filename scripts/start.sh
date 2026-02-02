#!/usr/bin/env bash

# start.sh - Begin development on ideas (from issue or create new issue)
# Part of DA Agent Hub - Analytics Development Lifecycle (ADLC) AI Platform
# Usage: ./scripts/start.sh <issue-number-or-text>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function to show usage
usage() {
    echo "Usage: $0 <issue-number|\"idea text\">"
    echo ""
    echo "Start development either from existing issue or by creating new issue."
    echo ""
    echo "Examples:"
    echo "  $0 85                                    # Start from existing issue #85"
    echo "  $0 \"Build customer churn prediction\"    # Create issue and start"
    exit 1
}

# Pre-flight check: Verify tech stack is configured
if [ ! -f ".claude/config/tech-stack.json" ]; then
    echo ""
    print_color $YELLOW "⚠️  Tech stack not configured yet"
    echo ""
    echo "For the best experience, we recommend running setup to configure"
    echo "agents for your specific tools:"
    echo ""
    echo "  ./setup.sh"
    echo ""
    echo "This ensures AI specialists match your actual data stack."
    echo ""
    read -p "Continue without setup? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_color $BLUE "Run ./setup.sh when ready!"
        exit 0
    fi
    print_color $YELLOW "Proceeding without stack configuration..."
    echo ""
fi

# Check if input was provided
if [ -z "$1" ]; then
    print_color $RED "❌ Error: No issue number or idea text provided"
    echo ""
    usage
fi

INPUT="$1"
ISSUE_NUMBER=""

# Determine if input is a number (existing issue) or text (new issue)
if [[ "$INPUT" =~ ^[0-9]+$ ]]; then
    # It's an issue number
    ISSUE_NUMBER="$INPUT"
    print_color $BLUE "🚀 Starting project from existing GitHub issue #$ISSUE_NUMBER"
else
    # It's idea text - create issue first
    print_color $BLUE "💡 Creating GitHub issue for: $INPUT"

    # Call idea.sh to create the issue
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    ISSUE_OUTPUT=$("$SCRIPT_DIR/idea.sh" "$INPUT" 2>&1)

    # Extract issue number from output
    ISSUE_NUMBER=$(echo "$ISSUE_OUTPUT" | grep -oE 'Issue #[0-9]+' | grep -oE '[0-9]+' | head -1)

    if [ -z "$ISSUE_NUMBER" ]; then
        print_color $RED "❌ Error: Failed to create GitHub issue"
        echo "$ISSUE_OUTPUT"
        exit 1
    fi

    print_color $GREEN "✅ Created issue #$ISSUE_NUMBER"
    echo ""
fi

# Fetch issue details
print_color $BLUE "📋 Fetching issue details..."
ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --json title,body,labels 2>&1)

if [ $? -ne 0 ]; then
    print_color $RED "❌ Error: Could not fetch issue #$ISSUE_NUMBER"
    echo "$ISSUE_DATA"
    exit 1
fi

ISSUE_TITLE=$(echo "$ISSUE_DATA" | jq -r '.title')
print_color $GREEN "📋 Issue: $ISSUE_TITLE"
echo ""

# Create project name from issue title
# Convert to lowercase, replace spaces with hyphens, remove special chars, truncate
PROJECT_NAME=$(echo "$ISSUE_TITLE" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z0-9 -]//g' | \
    tr -s ' ' '-' | \
    cut -c1-50 | \
    sed 's/-$//')

PROJECT_DIR="projects/active/feature-$PROJECT_NAME"

print_color $BLUE "🏗️  Creating project structure: $PROJECT_DIR"

# Call work-init.sh to create project structure
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/work-init.sh" ]; then
    # Pass issue number and project name to work-init.sh
    "$SCRIPT_DIR/work-init.sh" "$ISSUE_NUMBER" "$PROJECT_NAME"
else
    print_color $YELLOW "⚠️  work-init.sh not found, creating basic structure..."

    # Create basic project structure
    mkdir -p "$PROJECT_DIR/tasks"

    # Create README.md
    cat > "$PROJECT_DIR/README.md" <<EOF
# $ISSUE_TITLE

**GitHub Issue**: #$ISSUE_NUMBER
**Project**: $PROJECT_DIR
**Created**: $(date +%Y-%m-%d)

## Quick Links
- [GitHub Issue](https://github.com/\$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/issues/$ISSUE_NUMBER)
- [Project Specification](./spec.md)
- [Working Context](./context.md)
- [Current Tasks](./tasks/current-task.md)

## Progress Tracker
- [ ] Requirements analyzed
- [ ] Implementation approach defined
- [ ] Development complete
- [ ] Testing complete
- [ ] Ready for deployment

## Key Decisions
(Document major decisions here)
EOF

    # Create spec.md
    ISSUE_BODY=$(echo "$ISSUE_DATA" | jq -r '.body // "No description provided"')
    cat > "$PROJECT_DIR/spec.md" <<EOF
# Project Specification: $ISSUE_TITLE

**Source**: GitHub Issue #$ISSUE_NUMBER
**Created**: $(date +%Y-%m-%d)

## Description

$ISSUE_BODY

## Requirements
(Extract/refine requirements from issue description)

## Success Criteria
- [ ] (Define success criteria)

## Implementation Plan
(Define implementation approach)
EOF

    # Create context.md
    cat > "$PROJECT_DIR/context.md" <<EOF
# Working Context: $ISSUE_TITLE

**Last Updated**: $(date +%Y-%m-%d)

## Current State
- Branch: feature-$PROJECT_NAME
- Status: Just started

## Active Work
(What you're currently working on)

## Blockers
(Any blockers or dependencies)

## Next Steps
1. Review spec.md
2. Define implementation approach
3. Begin development
EOF

    # Create tasks/current-task.md
    cat > "$PROJECT_DIR/tasks/current-task.md" <<EOF
# Current Task

**Project**: $ISSUE_TITLE
**Updated**: $(date +%Y-%m-%d)

## Active Task
Review project specification and define implementation approach

## Agent Assignments
(Assign tasks to specialist agents here)

## Findings
(Link to agent findings files as they're created)
EOF

fi

print_color $GREEN "✅ Project structure created"
echo ""

# Link project to GitHub issue
print_color $BLUE "🔗 Linking project to GitHub issue..."
gh issue comment "$ISSUE_NUMBER" --body "## 🚀 Project Started

**Project Location**: \`$PROJECT_DIR\`
**Branch**: \`feature-$PROJECT_NAME\`
**Started**: $(date +%Y-%m-%d)

Development work is now in progress. Check project directory for details.

---
*Created by DA Agent Hub \`/start\` command*"

# Add 'in-progress' label
gh issue edit "$ISSUE_NUMBER" --add-label "in-progress" 2>/dev/null || true

print_color $GREEN "✅ Project successfully created!"
print_color $GREEN "📁 Project location: $PROJECT_DIR/"
print_color $GREEN "🔗 Linked to: https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/issues/$ISSUE_NUMBER"
echo ""

print_color $YELLOW "🎯 Next steps:"
echo "   1. Review project spec: $PROJECT_DIR/spec.md"
echo "   2. Begin development work with specialist agents"
echo "   3. Update issue #$ISSUE_NUMBER with progress comments"
echo "   4. When complete: /complete feature-$PROJECT_NAME"
echo ""
