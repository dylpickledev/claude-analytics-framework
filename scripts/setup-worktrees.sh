#!/bin/bash

# setup-worktrees.sh - Initial setup for VS Code worktree integration
# Usage: ./scripts/setup-worktrees.sh

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_header() {
    echo -e "${BLUE}🔄 $1${NC}"
}

print_header "VS Code Worktree Integration Setup"
echo ""

# Step 1: Check git version for worktree support
print_info "Checking git version..."
GIT_VERSION=$(git --version | awk '{print $3}')
print_status "Git version: $GIT_VERSION"

# Step 2: Create worktree base directory
print_info "Creating worktree base directory..."
WORKTREE_BASE="../da-agent-hub-worktrees"
mkdir -p "$WORKTREE_BASE"
print_status "Created: $WORKTREE_BASE"

# Step 3: Check VS Code installation
if command -v code &> /dev/null; then
    print_status "VS Code CLI detected"

    # Step 4: Install recommended extensions
    print_info "Installing recommended VS Code extensions..."

    EXTENSIONS=(
        "GitWorktrees.git-worktrees"
        "eamodio.gitlens"
        "mhutchie.git-graph"
    )

    for ext in "${EXTENSIONS[@]}"; do
        if code --list-extensions | grep -q "$ext"; then
            print_status "Already installed: $ext"
        else
            print_info "Installing: $ext"
            code --install-extension "$ext" --force
            print_status "Installed: $ext"
        fi
    done
else
    echo -e "${YELLOW}⚠️  VS Code CLI not found${NC}"
    echo "   Install VS Code and add 'code' to PATH"
    echo "   https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line"
fi

# Step 5: Configure VS Code settings
print_info "Configuring VS Code global settings..."

VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
VSCODE_SETTINGS_FILE="$VSCODE_SETTINGS_DIR/settings.json"

# Create settings directory if it doesn't exist
mkdir -p "$VSCODE_SETTINGS_DIR"

# Check if settings file exists
if [ -f "$VSCODE_SETTINGS_FILE" ]; then
    print_info "Updating existing settings.json"

    # Backup current settings
    cp "$VSCODE_SETTINGS_FILE" "$VSCODE_SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    print_status "Backup created"

    # Note: Manual merge required for existing settings
    echo ""
    echo -e "${YELLOW}⚠️  Manual settings update required${NC}"
    echo "   Add these settings to: $VSCODE_SETTINGS_FILE"
    echo ""
    cat << 'SETTINGS_EOF'
{
  "git.detectWorktrees": true,
  "git.autoRepositoryDetection": true,
  "files.autoSave": "onFocusChange",
  "files.autoSaveDelay": 1000,
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/.git/worktrees/**": false,
    "**/node_modules/**": true,
    "**/.venv/**": true
  }
}
SETTINGS_EOF
    echo ""
else
    print_info "Creating new settings.json"
    cat > "$VSCODE_SETTINGS_FILE" << 'SETTINGS_EOF'
{
  "git.detectWorktrees": true,
  "git.autoRepositoryDetection": true,
  "files.autoSave": "onFocusChange",
  "files.autoSaveDelay": 1000,
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/.git/worktrees/**": false,
    "**/node_modules/**": true,
    "**/.venv/**": true
  },
  "window.restoreWindows": "all",
  "workbench.editor.revealIfOpen": true
}
SETTINGS_EOF
    print_status "Settings file created"
fi

# Step 6: Create .gitignore entry for worktrees directory
print_info "Checking .gitignore configuration..."
if [ -f ".gitignore" ]; then
    if grep -q "da-agent-hub-worktrees" ".gitignore"; then
        print_status ".gitignore already configured"
    else
        echo "" >> .gitignore
        echo "# Worktree directories (created by build.sh)" >> .gitignore
        echo "../da-agent-hub-worktrees/" >> .gitignore
        print_status "Added worktrees to .gitignore"
    fi
else
    print_info ".gitignore not found, skipping"
fi

# Summary
echo ""
print_header "Setup Complete! 🎉"
echo ""
print_info "📋 Summary:"
echo "   • Worktree base directory: $WORKTREE_BASE"
echo "   • VS Code extensions installed (if VS Code available)"
echo "   • Global settings configured for worktree support"
echo ""
print_info "🚀 Next steps:"
echo "   1. Build a project: ./scripts/build.sh [idea-name]"
echo "   2. The script will automatically create worktrees"
echo "   3. Switch between projects: ./scripts/switch.sh [branch-name]"
echo ""
print_info "💡 Usage examples:"
echo "   ./scripts/build.sh \"customer-analytics\"  # Creates worktree + VS Code workspace"
echo "   ./scripts/switch.sh feature-urgent-fix    # Opens worktree in VS Code"
echo "   ./scripts/finish.sh feature-project       # Cleans up worktree"
echo ""
print_status "VS Code worktree integration is ready! 🎯"
