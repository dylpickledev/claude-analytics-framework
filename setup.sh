#!/usr/bin/env bash
# setup.sh - Bootstrap claude-adlc-framework
# Minimal setup script that checks for Claude Code, then hands off to /onboard command

set -e

echo "🚀 claude-adlc-framework Setup"
echo ""

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code not installed"
    echo ""
    echo "Please install Claude Code first:"
    echo "  https://docs.claude.com/en/docs/claude-code"
    echo ""
    echo "Quick install (macOS/Linux):"
    echo "  curl -fsSL https://claude.com/install.sh | sh"
    echo ""
    exit 1
fi

echo "✅ Claude Code installed"
echo ""
echo "Starting interactive setup with Claude..."
echo ""

# Hand off to Claude - it handles authentication and all configuration
claude /onboard
