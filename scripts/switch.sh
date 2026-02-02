#!/bin/bash

# switch.sh - Seamless project/task switching workflow
# Usage: ./scripts/switch.sh [optional-target-branch-name]
#
# This script provides a complete context switch workflow:
# 1. Save current sub-repo branches to project context.md
# 2. Commit current work with auto-generated message
# 3. Push current branch to remote for preservation
# 4. Switch to main branch and sync (or target branch)
# 5. Restore target project's sub-repo branches from context.md

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

# Function to find project context.md based on branch name
find_project_context() {
    local branch_name="$1"
    # Try to find matching project directory
    local project_name=$(echo "$branch_name" | sed 's/^feature-//' | sed 's/^feature\///')

    # Check active projects
    for dir in projects/active/*/; do
        if [ -f "$dir/context.md" ]; then
            local dir_name=$(basename "$dir")
            if [[ "$dir_name" == *"$project_name"* ]] || [[ "$dir_name" == "feature-$project_name" ]]; then
                echo "$dir/context.md"
                return 0
            fi
        fi
    done
    return 1
}

# Function to get current sub-repo branches
get_current_repo_branches() {
    local branches=""
    local repos_dir="repos"

    if [ -d "$repos_dir" ]; then
        for repo in "$repos_dir"/*/; do
            if [ -d "$repo/.git" ] || [ -f "$repo/.git" ]; then
                local repo_name=$(basename "$repo")
                pushd "$repo" > /dev/null
                local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
                popd > /dev/null
                branches="$branches$repo_name: $branch
"
            fi
        done
    fi
    echo "$branches"
}

# Function to save repo branches to context.md
save_repo_branches_to_context() {
    local context_file="$1"
    local framework_branch="$2"

    if [ ! -f "$context_file" ]; then
        return 1
    fi

    # Get current sub-repo branches
    local sub_repo_branches=$(get_current_repo_branches)
    local all_branches="framework: $framework_branch
$sub_repo_branches"

    # Update the REPO_BRANCHES section in context.md
    if grep -q "REPO_BRANCHES_START" "$context_file"; then
        # Create temp file with updated content
        awk -v branches="$all_branches" '
            /<!-- REPO_BRANCHES_START/ {
                print;
                print branches;
                skip=1;
                next
            }
            /<!-- REPO_BRANCHES_END/ {
                skip=0
            }
            !skip { print }
        ' "$context_file" > "$context_file.tmp"
        mv "$context_file.tmp" "$context_file"
    fi
}

# Function to read repo branches from context.md
read_repo_branches_from_context() {
    local context_file="$1"

    if [ ! -f "$context_file" ]; then
        return 1
    fi

    # Extract content between REPO_BRANCHES markers
    sed -n '/<!-- REPO_BRANCHES_START/,/<!-- REPO_BRANCHES_END/p' "$context_file" | \
        grep -v "REPO_BRANCHES" | \
        grep -v "^$"
}

# Function to switch sub-repos to specified branches
switch_sub_repos() {
    local target_branches="$1"
    local repos_dir="repos"

    if [ -z "$target_branches" ] || [ ! -d "$repos_dir" ]; then
        return 0
    fi

    print_info "Switching sub-repository branches..."

    echo "$target_branches" | while IFS=': ' read -r repo_name branch_name; do
        # Skip framework entry and empty lines
        if [ "$repo_name" == "framework" ] || [ -z "$repo_name" ] || [ -z "$branch_name" ]; then
            continue
        fi

        local repo_path="$repos_dir/$repo_name"
        branch_name=$(echo "$branch_name" | tr -d '[:space:]')

        if [ -d "$repo_path" ]; then
            print_info "   $repo_name → $branch_name"
            pushd "$repo_path" > /dev/null

            # Stash uncommitted changes
            if ! git diff-index --quiet HEAD -- 2>/dev/null; then
                git stash push -m "auto-stash during project switch" 2>/dev/null || true
            fi

            # Switch to branch
            if git rev-parse --verify "$branch_name" > /dev/null 2>&1; then
                git checkout "$branch_name" 2>/dev/null
            elif git ls-remote --exit-code --heads origin "$branch_name" > /dev/null 2>&1; then
                git checkout -b "$branch_name" "origin/$branch_name" 2>/dev/null
            else
                # Branch doesn't exist, stay on current
                print_warning "   Branch $branch_name not found in $repo_name, staying on current"
            fi

            popd > /dev/null
        fi
    done

    print_status "Sub-repository branches switched"
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

# Step 0: Save current project's sub-repo branches to context.md
if [[ "$CURRENT_BRANCH" != "main" ]]; then
    CURRENT_CONTEXT=$(find_project_context "$CURRENT_BRANCH")
    if [ -n "$CURRENT_CONTEXT" ] && [ -f "$CURRENT_CONTEXT" ]; then
        print_info "Saving sub-repo branches to: $CURRENT_CONTEXT"
        save_repo_branches_to_context "$CURRENT_CONTEXT" "$CURRENT_BRANCH"
    fi
fi

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
fi

# Step 5: Switch sub-repos to target project's branches
FINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$FINAL_BRANCH" != "main" ]]; then
    TARGET_CONTEXT=$(find_project_context "$FINAL_BRANCH")
    if [ -n "$TARGET_CONTEXT" ] && [ -f "$TARGET_CONTEXT" ]; then
        print_info "Reading sub-repo branches from: $TARGET_CONTEXT"
        TARGET_REPO_BRANCHES=$(read_repo_branches_from_context "$TARGET_CONTEXT")
        if [ -n "$TARGET_REPO_BRANCHES" ]; then
            switch_sub_repos "$TARGET_REPO_BRANCHES"
        fi
    fi
else
    # Switching to main - reset sub-repos to their default branches
    print_info "Switching sub-repos to default branches..."
    REPOS_DIR="repos"
    if [ -d "$REPOS_DIR" ]; then
        for repo in "$REPOS_DIR"/*/; do
            if [ -d "$repo/.git" ] || [ -f "$repo/.git" ]; then
                repo_name=$(basename "$repo")
                pushd "$repo" > /dev/null

                # Stash uncommitted changes
                if ! git diff-index --quiet HEAD -- 2>/dev/null; then
                    git stash push -m "auto-stash switching to main" 2>/dev/null || true
                fi

                # Get default branch
                DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
                git checkout "$DEFAULT_BRANCH" 2>/dev/null || true
                print_info "   $repo_name → $DEFAULT_BRANCH"

                popd > /dev/null
            fi
        done
    fi
fi

# Step 6: Clear context and provide guidance
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