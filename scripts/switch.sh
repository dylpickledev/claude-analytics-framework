#!/bin/bash

# switch.sh - Seamless project/task switching workflow
# Usage: ./scripts/switch.sh [optional-new-branch-name]
#
# This script provides a complete context switch workflow:
# 1. Commit current work with auto-generated message
# 2. Push current branch to remote for preservation
# 3. Switch to main branch and sync
# 4. Clear Claude Code context
# 5. Optionally switch to specified branch

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${BLUE}🔄 $1${NC}"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Get current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
print_info "Current branch: $CURRENT_BRANCH"

# Optional target branch parameter
TARGET_BRANCH="$1"

print_header "Starting project/task switch workflow..."

# Step 1: Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_info "Uncommitted changes detected. Committing current work..."

    # Stage all changes
    git add .

    # Generate auto-commit message based on branch name
    if [[ $CURRENT_BRANCH == feature/* ]]; then
        COMMIT_TYPE="feat"
        WORK_TYPE="feature"
    elif [[ $CURRENT_BRANCH == fix/* ]]; then
        COMMIT_TYPE="fix"
        WORK_TYPE="fix"
    elif [[ $CURRENT_BRANCH == research/* ]]; then
        COMMIT_TYPE="docs"
        WORK_TYPE="research"
    else
        COMMIT_TYPE="chore"
        WORK_TYPE="work"
    fi

    # Extract work description from branch name
    WORK_DESC=$(echo "$CURRENT_BRANCH" | sed 's/^[^-]*-//' | sed 's/-/ /g')

    # Create commit message
    git commit -m "$(cat <<EOF
$COMMIT_TYPE: Save current progress on $WORK_DESC

Work in progress - switching to different task/project.
Current state preserved for future continuation.

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
    print_status "Changes committed successfully"
else
    print_info "No uncommitted changes detected"
fi

# Step 2: Push current branch to remote (if not main)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
    print_info "Pushing $CURRENT_BRANCH to remote for preservation..."

    # Check if remote branch exists
    if git ls-remote --exit-code --heads origin "$CURRENT_BRANCH" > /dev/null 2>&1; then
        git push origin "$CURRENT_BRANCH"
    else
        git push -u origin "$CURRENT_BRANCH"
        print_status "New remote branch created: $CURRENT_BRANCH"
    fi
    print_status "Branch pushed to remote successfully"
else
    print_info "Already on main branch, skipping push"
fi

# Step 3: Switch to main and sync
if [[ "$CURRENT_BRANCH" != "main" ]]; then
    print_info "Switching to main branch..."
    git checkout main

    print_info "Syncing main branch with remote..."
    git pull origin main
    print_status "Switched to main and synced"
else
    print_info "Already on main branch, syncing..."
    git pull origin main
    print_status "Main branch synced"
fi

# Step 4: Switch to target branch if specified
if [[ -n "$TARGET_BRANCH" ]]; then
    print_info "Switching to target branch: $TARGET_BRANCH"

    # Check if branch exists locally
    if git rev-parse --verify "$TARGET_BRANCH" > /dev/null 2>&1; then
        git checkout "$TARGET_BRANCH"
        print_status "Switched to existing branch: $TARGET_BRANCH"
    else
        # Check if branch exists on remote
        if git ls-remote --exit-code --heads origin "$TARGET_BRANCH" > /dev/null 2>&1; then
            git checkout -b "$TARGET_BRANCH" "origin/$TARGET_BRANCH"
            print_status "Checked out remote branch: $TARGET_BRANCH"
        else
            print_warning "Branch '$TARGET_BRANCH' not found locally or remotely"
            print_info "Staying on main branch"
        fi
    fi

    # Worktree navigation support
    WORKTREE_PATH="../da-agent-hub-worktrees/$TARGET_BRANCH"

    if [ -d "$WORKTREE_PATH" ]; then
        print_info "Worktree detected for $TARGET_BRANCH"

        if command -v code &> /dev/null; then
            echo ""
            print_info "🚀 VS Code options:"
            echo "   • Workspace: $WORKTREE_PATH/*.code-workspace"
            echo ""

            read -p "Open VS Code for this worktree? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                WORKSPACE_FILE=$(find "$WORKTREE_PATH" -name "*.code-workspace" -maxdepth 1 2>/dev/null | head -n 1)
                if [ -n "$WORKSPACE_FILE" ]; then
                    code "$WORKSPACE_FILE"
                    print_status "VS Code launched with workspace file"
                else
                    code "$WORKTREE_PATH"
                    print_status "VS Code launched for worktree directory"
                fi
            else
                echo "💡 Launch later with: code $WORKTREE_PATH/*.code-workspace"
            fi
        fi
    fi
fi

# Step 5: Clear context and provide guidance
print_header "Context switching complete!"

echo ""
print_status "✅ Work preserved and context switched successfully"
echo ""
print_info "📋 Summary:"
echo "   • Previous work on '$CURRENT_BRANCH' committed and pushed"
echo "   • Now on: $(git rev-parse --abbrev-ref HEAD)"
echo "   • Repository state: clean and ready for new work"
echo ""
print_info "🚀 Next steps:"
echo "   • Use '/clear' in Claude Code to reset conversation context"
echo "   • Or restart Claude Code for completely fresh context"
echo "   • Ready to begin new project or task!"
echo ""

# If we switched away from a project branch, show project resume command
if [[ "$CURRENT_BRANCH" != "main" && "$CURRENT_BRANCH" != $(git rev-parse --abbrev-ref HEAD) ]]; then
    print_info "💡 To resume previous work:"
    echo "   ./scripts/switch.sh $CURRENT_BRANCH"
fi

print_status "Project/task switch workflow completed successfully! 🎯"