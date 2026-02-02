#!/bin/bash
# Validates MCP configuration is ready to use

set -e

echo "🔍 Validating DA Agent Hub MCP setup..."
echo ""

# Check .env exists
if [ ! -f .env ]; then
  echo "❌ .env file missing"
  echo "   Fix: cp .env.example .env"
  echo "   Then edit .env with your dbt Cloud credentials"
  exit 1
fi
echo "✅ .env file exists"

# Check required variables are set (not placeholders)
if ! grep -q "^DBT_CLOUD_API_TOKEN=dbt" .env; then
  echo "❌ DBT_CLOUD_API_TOKEN not set in .env"
  echo "   Current value: $(grep '^DBT_CLOUD_API_TOKEN=' .env | cut -d= -f2)"
  echo "   Get token at: https://cloud.getdbt.com/settings/tokens"
  exit 1
fi
echo "✅ DBT_CLOUD_API_TOKEN is set"

if ! grep -q "^DBT_CLOUD_ACCOUNT_ID=[0-9]" .env; then
  echo "❌ DBT_CLOUD_ACCOUNT_ID not set in .env"
  echo "   Current value: $(grep '^DBT_CLOUD_ACCOUNT_ID=' .env | cut -d= -f2)"
  echo "   Get Account ID from your dbt Cloud URL: https://cloud.getdbt.com/accounts/<ID>"
  exit 1
fi
echo "✅ DBT_CLOUD_ACCOUNT_ID is set"

# Check MCP config exists
if [ ! -f .claude/mcp.json ]; then
  echo "❌ .claude/mcp.json missing"
  exit 1
fi
echo "✅ .claude/mcp.json exists"

# Check MCP config is valid JSON
if ! python3 -m json.tool .claude/mcp.json > /dev/null 2>&1; then
  echo "❌ .claude/mcp.json is invalid JSON"
  exit 1
fi
echo "✅ .claude/mcp.json is valid JSON"

# Check MCP config has dbt server
if ! grep -q '"dbt"' .claude/mcp.json; then
  echo "⚠️  Warning: No 'dbt' server found in .claude/mcp.json"
fi

echo ""
echo "✅ MCP configuration looks good!"
echo ""
echo "🎯 Next steps:"
echo "   1. Exit Claude Code completely (Cmd+Q on Mac, or kill the process)"
echo "   2. Restart Claude Code in this directory"
echo "   3. Run: claude /mcp"
echo "   4. You should see: dbt - dbt Cloud integration"
echo "   5. Test it: claude \"List my dbt Cloud jobs\""
echo ""
