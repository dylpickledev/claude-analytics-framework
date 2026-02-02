# MCP Troubleshooting Guide

This guide helps resolve common MCP (Model Context Protocol) configuration issues in DA Agent Hub.

## Quick Diagnosis

Run the validation script to identify issues:
```bash
./scripts/validate-mcp.sh
```

---

## Common Issues

### 1. "/mcp shows No MCP servers configured"

**Symptoms:**
- Run `claude /mcp` and see "No MCP servers configured"
- Even though `.claude/mcp.json` exists and looks correct

**Cause:** MCP servers only load when Claude Code starts. The `/mcp` command shows what's currently loaded in memory, not what's in the config files.

**Solution:**
1. Verify `.claude/mcp.json` exists and is valid JSON:
   ```bash
   python3 -m json.tool .claude/mcp.json
   ```
2. Verify `.env` has your credentials:
   ```bash
   ./scripts/validate-mcp.sh
   ```
3. **Exit Claude Code completely** (Cmd+Q on Mac, not just close window)
4. Restart Claude Code in this directory
5. Run `claude /mcp` again

**Expected result:** Should see `dbt - dbt Cloud integration (enabled)`

---

### 2. "dbt MCP server fails to start"

**Symptoms:**
- Error message when Claude Code starts
- `/mcp` shows dbt server but it's disabled or errored

**Cause:** Missing or invalid credentials in `.env`

**Solution:**
1. Check `.env` exists:
   ```bash
   ls -la .env
   ```
2. Check credentials are set (not placeholders):
   ```bash
   grep "^DBT_CLOUD" .env
   ```
3. Validate configuration:
   ```bash
   ./scripts/validate-mcp.sh
   ```
4. Fix any errors reported
5. Restart Claude Code

**Common credential issues:**
- `DBT_CLOUD_API_TOKEN` is still `your_dbt_cloud_api_token_here`
- `DBT_CLOUD_ACCOUNT_ID` is empty or not a number
- Credentials have extra spaces or quotes

---

### 3. ".env file missing"

**Symptoms:**
- Error: `.env file not found`
- MCP server can't start

**Cause:** `.env` hasn't been created from `.env.example`

**Solution:**
```bash
# Copy template
cp .env.example .env

# Edit with your credentials
# Get API token: https://cloud.getdbt.com/settings/tokens
# Get Account ID from URL: https://cloud.getdbt.com/accounts/<ID>

# Validate
./scripts/validate-mcp.sh
```

---

### 4. "Where should MCP config live?"

**Question:** Should I use project-level (`.claude/mcp.json`) or user-level (`~/.claude/mcp.json`)?

**Answer for DA Agent Hub:** **Project-level** (`.claude/mcp.json` in this repo)

**Why:**
- Checked into git (shared with team)
- Everyone uses same MCP configuration
- Credentials in `.env` (NOT checked in)
- Easier to troubleshoot (everyone has same setup)

**User-level config (`~/.claude/mcp.json`) is for:**
- Personal tools not used by the team
- Global MCP servers across all projects
- Your own customizations

**Priority:** Project-level overrides user-level if same server name exists.

---

### 5. "dbt API token invalid or expired"

**Symptoms:**
- Authentication errors when running dbt commands
- "401 Unauthorized" or "403 Forbidden" errors

**Cause:** dbt Cloud API token is invalid, expired, or has insufficient permissions

**Solution:**
1. Generate new API token:
   - Go to: https://cloud.getdbt.com/settings/tokens
   - Click "Create Token"
   - Give it a descriptive name (e.g., "DA Agent Hub MCP")
   - Copy the token immediately (you won't see it again)
2. Update `.env`:
   ```bash
   DBT_CLOUD_API_TOKEN=dbtc_abc123xyz...
   ```
3. Restart Claude Code
4. Test:
   ```bash
   claude "List my dbt Cloud jobs"
   ```

---

### 6. "Account ID not found"

**Symptoms:**
- "Account not found" or "Invalid account ID" errors

**Cause:** Wrong `DBT_CLOUD_ACCOUNT_ID` in `.env`

**Solution:**
1. Find your Account ID:
   - Log into dbt Cloud
   - Look at URL: `https://cloud.getdbt.com/accounts/123456`
   - The number `123456` is your Account ID
2. Update `.env`:
   ```bash
   DBT_CLOUD_ACCOUNT_ID=123456
   ```
3. Restart Claude Code

---

### 7. "Changes to .claude/mcp.json or .env not taking effect"

**Symptoms:**
- Updated config files but behavior hasn't changed

**Cause:** Changes to MCP config require Claude Code restart

**Solution:**
1. Exit Claude Code **completely** (don't just close window)
   - Mac: Cmd+Q or `killall claude-code`
   - Linux: Kill the process
2. Restart Claude Code
3. Verify changes: `claude /mcp`

**Note:** Hot-reloading of MCP config is not supported.

---

### 8. "uvx: command not found"

**Symptoms:**
- Error starting dbt MCP server
- `uvx: command not found` or similar

**Cause:** `uvx` (uv tool runner) is not installed

**Solution:**
```bash
# Install uv (includes uvx)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or via homebrew
brew install uv

# Verify installation
uvx --version

# Restart Claude Code
```

---

## MCP Architecture in DA Agent Hub

```
┌─────────────────────────────────────┐
│ DA Agent Hub Repository             │
├─────────────────────────────────────┤
│ .claude/mcp.json                    │  ← MCP server config (committed)
│   ↓ references                      │
│ .env                                │  ← Credentials (NOT committed)
│   ↓ used by                         │
│ MCP Server: dbt                     │  ← Runs dbt-mcp via uvx
│   ↓ connects to                     │
│ dbt Cloud API                       │  ← Your dbt Cloud account
└─────────────────────────────────────┘
```

**Key files:**
- `.claude/mcp.json` - Server configuration (shared with team)
- `.env` - Your credentials (local only, gitignored)
- `.env.example` - Template showing what variables are needed

---

## Testing MCP is Working

After fixing issues, test that MCP is working:

### 1. Check server loaded
```bash
claude /mcp
```
**Expected:** `dbt - dbt Cloud integration (enabled)`

### 2. Test dbt Cloud connection
```bash
claude "List my dbt Cloud jobs"
```
**Expected:** List of your dbt Cloud jobs with status

### 3. Test more complex query
```bash
claude "Show me failed dbt tests from the last run"
```
**Expected:** Details of failed tests

---

## Getting Help

If you're still stuck:

1. **Run validation script:**
   ```bash
   ./scripts/validate-mcp.sh
   ```

2. **Check Claude Code logs:**
   - Look for MCP-related errors at startup
   - Server initialization messages

3. **Ask the onboarding-agent:**
   ```bash
   claude "I'm having trouble with MCP setup" --agent onboarding-agent
   ```

4. **Create a GitHub issue:**
   - Include output from `./scripts/validate-mcp.sh`
   - Include relevant error messages
   - Include OS and Claude Code version

---

## Advanced: Adding More MCP Servers

Once `dbt` MCP is working, you can add more servers (Tableau, dlthub, Snowflake, etc.):

1. Find the MCP server package (e.g., `tableau-mcp`)
2. Add to `.claude/mcp.json`:
   ```json
   {
     "mcpServers": {
       "dbt": { ... },
       "tableau": {
         "command": "uvx",
         "args": ["tableau-mcp"],
         "env": {
           "TABLEAU_SERVER_URL": "${TABLEAU_SERVER_URL}"
         }
       }
     }
   }
   ```
3. Add credentials to `.env`
4. Update `.env.example` with new variables
5. Restart Claude Code

**Tip:** Start with one MCP server (dbt), get it working, then add more.
