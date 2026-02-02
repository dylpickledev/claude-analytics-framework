#!/usr/bin/env bash

# idea.sh - Quick idea capture with GitHub issue creation
# Part of DA Agent Hub - Analytics Development Lifecycle (ADLC) AI Platform
# Usage: ./scripts/idea.sh "your idea description"

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
    echo "Usage: $0 \"idea description\""
    echo ""
    echo "Creates a GitHub issue for the idea with automatic labeling."
    echo ""
    echo "Examples:"
    echo "  $0 \"Build customer churn prediction model\""
    echo "  $0 \"Optimize Snowflake warehouse costs\""
    exit 1
}

# Check if idea was provided
if [ -z "$1" ]; then
    print_color $RED "❌ Error: No idea description provided"
    echo ""
    usage
fi

IDEA="$1"

print_color $BLUE "💡 Creating GitHub issue for idea..."
print_color $BLUE "📝 Idea: $IDEA"
echo ""

# Create GitHub issue
# Auto-adds 'idea' label for tracking
ISSUE_URL=$(gh issue create \
    --title "$IDEA" \
    --body "## Idea Description

$IDEA

## Context
- Created via \`/idea\` command
- Status: Needs analysis
- Next steps: Use \`/research <issue#>\` for deep analysis or \`/start <issue#>\` to begin development

## Analysis
(Add research findings here or use \`/research <issue#>\`)

## Implementation Plan
(Will be created during \`/start\` or manual planning)
" \
    --label "idea" 2>&1)

if [ $? -eq 0 ]; then
    # Extract issue number from URL
    ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -oE '[0-9]+$')

    print_color $GREEN "✅ GitHub issue created successfully!"
    print_color $GREEN "🔗 Issue #$ISSUE_NUMBER: $ISSUE_URL"
    echo ""
    print_color $YELLOW "🎯 Next steps:"
    echo "   1. View issue: gh issue view $ISSUE_NUMBER"
    echo "   2. Deep analysis: /research $ISSUE_NUMBER"
    echo "   3. Start development: /start $ISSUE_NUMBER"
    echo ""
    print_color $BLUE "💡 Or use /roadmap to see all ideas and prioritize"
else
    print_color $RED "❌ Error: Failed to create GitHub issue"
    echo "$ISSUE_URL"
    exit 1
fi
