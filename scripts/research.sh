#!/usr/bin/env bash

# research.sh - Helper script for /research command
# Part of DA Agent Hub - Analytics Development Lifecycle (ADLC) AI Platform
#
# This script provides context for Claude to perform deep analysis.
# The actual analysis is done by Claude using specialist agents.
#
# Usage:
#   ./scripts/research.sh "topic to explore"  # Pre-capture exploration
#   ./scripts/research.sh 123                 # Analyze existing issue

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
    echo "Usage: $0 <\"topic text\"|issue-number>"
    echo ""
    echo "Perform deep exploration and analysis."
    echo ""
    echo "Mode 1 - Pre-capture exploration:"
    echo "  $0 \"Make DA Agent Hub AI-agnostic\""
    echo "  → Analyzes topic, then asks if you want to capture as issue"
    echo ""
    echo "Mode 2 - Issue analysis:"
    echo "  $0 85"
    echo "  → Fetches issue #85 and adds detailed analysis as comment"
    exit 1
}

# Check if input was provided
if [ -z "$1" ]; then
    print_color $RED "❌ Error: No topic or issue number provided"
    echo ""
    usage
fi

INPUT="$1"

# Determine if input is a number (existing issue) or text (topic exploration)
if [[ "$INPUT" =~ ^[0-9]+$ ]]; then
    # Issue analysis mode
    ISSUE_NUMBER="$INPUT"

    print_color $BLUE "🔬 Fetching GitHub issue #$ISSUE_NUMBER for analysis..."

    # Fetch issue details
    ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --json title,body,labels 2>&1)

    if [ $? -ne 0 ]; then
        print_color $RED "❌ Error: Could not fetch issue #$ISSUE_NUMBER"
        echo "$ISSUE_DATA"
        exit 1
    fi

    ISSUE_TITLE=$(echo "$ISSUE_DATA" | jq -r '.title')
    ISSUE_BODY=$(echo "$ISSUE_DATA" | jq -r '.body // "No description"')
    ISSUE_LABELS=$(echo "$ISSUE_DATA" | jq -r '.labels[].name' | tr '\n' ',' | sed 's/,$//')

    print_color $GREEN "📋 Issue: $ISSUE_TITLE"
    echo ""
    print_color $YELLOW "🤖 Claude should now:"
    echo "   1. Analyze issue with appropriate specialist agents"
    echo "   2. Post comprehensive findings as GitHub comment"
    echo "   3. Update labels if needed (e.g., add 'complex', 'architecture')"
    echo ""
    print_color $BLUE "📊 Issue Context:"
    echo "   Number: #$ISSUE_NUMBER"
    echo "   Title: $ISSUE_TITLE"
    echo "   Labels: $ISSUE_LABELS"
    echo ""
    print_color $BLUE "💬 Issue Body:"
    echo "$ISSUE_BODY"
    echo ""

else
    # Pre-capture exploration mode
    TOPIC="$INPUT"

    print_color $BLUE "🔬 Researching: $TOPIC"
    echo ""
    print_color $YELLOW "🤖 Claude should now:"
    echo "   1. Select appropriate specialist agents based on topic"
    echo "   2. Conduct comprehensive analysis (feasibility, approach, effort)"
    echo "   3. Present findings interactively"
    echo "   4. Ask: 'Should I capture this as a GitHub issue?'"
    echo ""
    print_color $BLUE "📊 Research Topic:"
    echo "   $TOPIC"
    echo ""
fi

print_color $GREEN "✅ Context prepared for Claude analysis"
echo ""
