#!/bin/bash
# Post-create setup script for DA Agent Hub devcontainer

set -e

echo "🚀 Setting up DA Agent Hub environment..."

# Make all scripts executable
chmod +x scripts/*.sh

# Install Claude Code CLI
echo "📦 Installing Claude Code CLI..."
npm install -g @anthropic/claude-code

# Configure git (users will customize this)
git config --global init.defaultBranch main

echo "✅ DA Agent Hub setup complete!"
echo ""
echo "Next steps:"
echo "1. Authenticate with GitHub: gh auth login"
echo "2. Configure Claude Code: claude auth"
echo "3. Start using: claude /capture \"Your first idea\""
