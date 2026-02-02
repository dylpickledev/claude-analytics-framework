#!/bin/bash

# capture.sh - GitHub Issues-based idea capture
# Usage: ./scripts/capture.sh "idea description"
# Creates GitHub issue with appropriate labels for ADLC Plan phase

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Ensure we're in the repo root
cd "$REPO_ROOT"

# Input validation
if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/capture.sh \"[idea description]\""
    echo "Example: ./scripts/capture.sh \"Build customer analytics dashboard\""
    exit 1
fi

IDEA="$1"

echo "🧠 Capturing idea: $IDEA"
echo ""

# Determine idea type and labels based on keywords
LABELS="idea"

if echo "$IDEA" | grep -qi "dashboard\|tableau\|powerbi\|visualization\|report"; then
    LABELS="$LABELS,bi-analytics"
    IDEA_TYPE="BI/Analytics"
elif echo "$IDEA" | grep -qi "pipeline\|etl\|ingestion\|airbyte\|prefect\|orchestra"; then
    LABELS="$LABELS,data-engineering"
    IDEA_TYPE="Data Engineering"
elif echo "$IDEA" | grep -qi "model\|dbt\|transformation\|sql"; then
    LABELS="$LABELS,analytics-engineering"
    IDEA_TYPE="Analytics Engineering"
elif echo "$IDEA" | grep -qi "architecture\|platform\|infrastructure\|aws\|snowflake"; then
    LABELS="$LABELS,architecture"
    IDEA_TYPE="Architecture"
elif echo "$IDEA" | grep -qi "streamlit\|react\|ui\|ux\|frontend\|app"; then
    LABELS="$LABELS,ui-development"
    IDEA_TYPE="UI Development"
else
    LABELS="$LABELS,general"
    IDEA_TYPE="General"
fi

echo "📋 Detected type: $IDEA_TYPE"

# Create GitHub issue
ISSUE_URL=$(gh issue create \
    --title "$IDEA" \
    --label "$LABELS" \
    --body "## Idea Description
$IDEA

## ADLC Phase
**Plan**: Idea captured for strategic planning

## Next Steps
- [ ] Prioritize in roadmap planning (\`/roadmap\`)
- [ ] Build when prioritized (\`/build\`)

---
*Captured via \`capture.sh\` script - Part of Analytics Development Lifecycle (ADLC)*")

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Idea captured as GitHub issue!"
    echo "🔗 Issue: $ISSUE_URL"
    echo ""
    echo "💡 Next steps:"
    echo "   - Add more ideas: ./scripts/capture.sh \"[another idea]\""
    echo "   - View all ideas: gh issue list --label idea"
    echo "   - Plan roadmap: ./scripts/roadmap.sh [quarterly|sprint|annual]"
    echo "   - Build top priority: ./scripts/build.sh <issue-number>"
else
    echo "❌ Failed to create GitHub issue"
    exit 1
fi
