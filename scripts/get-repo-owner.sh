#!/bin/bash
# Repository Owner Resolution Helper
#
# Quick bash wrapper for resolve-repo-context.py
# Returns just the owner for a given repository name
#
# Usage:
#   ./scripts/get-repo-owner.sh dbt_cloud
#   # Output: your-org
#
# Exit codes:
#   0 - Success
#   1 - Repository not found or error

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOLVER="${SCRIPT_DIR}/resolve-repo-context.py"

if [ $# -eq 0 ]; then
    echo "Usage: get-repo-owner.sh <repo_name>" >&2
    exit 1
fi

REPO_NAME="$1"

# Call Python resolver and extract just the owner
if OUTPUT=$(python3 "$RESOLVER" "$REPO_NAME" 2>&1); then
    # Output format is "owner repo", extract just owner
    echo "$OUTPUT" | awk '{print $1}'
    exit 0
else
    echo "Error: Could not resolve owner for repository '$REPO_NAME'" >&2
    exit 1
fi
