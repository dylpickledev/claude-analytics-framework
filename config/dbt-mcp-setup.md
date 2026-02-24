# dbt MCP Server Setup Guide

> For step-by-step interactive setup, run `/onboard` which will invoke the `dbt:configuring-dbt-mcp-server` skill automatically.

## Prerequisites

- **`uv` installed**: `brew install uv` (macOS) — required to run `uvx dbt-mcp`
- **dbt Cloud account** with your Production Environment ID ready
- Find your Environment ID: dbt Cloud → Deploy → Environments → click prod env → last number in URL

## Quick Setup (Claude Code)

### Project-level (this repo only)
Create `.mcp.json` in the project root:

```json
{
  "mcpServers": {
    "dbt-mcp": {
      "command": "/opt/homebrew/bin/uvx",
      "args": ["dbt-mcp"],
      "env": {
        "DBT_HOST": "us1.dbt.com",
        "MULTICELL_ACCOUNT_PREFIX": "te240",
        "DBT_PROD_ENV_ID": "your-prod-env-id",
        "DBT_PROJECT_DIR": "/path/to/repos/dbt_cloud",
        "DBT_PATH": "/opt/homebrew/bin/dbt"
      }
    }
  }
}
```

### User-level (all projects)
```bash
claude mcp add dbt-mcp \
  -s user \
  -e DBT_HOST=us1.dbt.com \
  -e MULTICELL_ACCOUNT_PREFIX=te240 \
  -e DBT_PROD_ENV_ID=your-prod-env-id \
  -e DBT_PROJECT_DIR=/path/to/repos/dbt_cloud \
  -e DBT_PATH=$(which dbt) \
  -- $(which uvx) dbt-mcp
```

Stored in `~/.claude.json`. Verify with: `claude mcp list`

## Multi-Cell Accounts

If your dbt Cloud URL is `abc123.us1.dbt.com` — split it:
- `DBT_HOST=us1.dbt.com` ← **not** `abc123.us1.dbt.com`
- `MULTICELL_ACCOUNT_PREFIX=abc123`

Standard accounts use `DBT_HOST=cloud.getdbt.com` with no prefix.

## Authentication

**Token auth** (simpler): Add `DBT_TOKEN=your-api-token` to env
- Get token: dbt Cloud → Account Settings → API Tokens → Personal tokens

**OAuth** (more secure, multi-cell accounts only):
- Set `DBT_HOST` to your subdomain — OAuth flow triggers automatically on first use
- Browser opens for authorization; token cached locally

## Environment Variables Reference

| Variable | Required | Description |
|----------|----------|-------------|
| `DBT_HOST` | Yes | `cloud.getdbt.com` or `us1.dbt.com` for multi-cell |
| `MULTICELL_ACCOUNT_PREFIX` | Multi-cell only | Prefix from your subdomain (e.g. `abc123`) |
| `DBT_TOKEN` | Token auth only | Personal or service token |
| `DBT_PROD_ENV_ID` | Yes | Production environment ID |
| `DBT_DEV_ENV_ID` | No | Development environment ID (for SQL tools) |
| `DBT_ACCOUNT_ID` | Admin API only | Your dbt account ID |
| `DBT_PROJECT_DIR` | CLI commands | Path to folder with `dbt_project.yml` |
| `DBT_PATH` | CLI commands | Full path to dbt executable (`which dbt`) |

## Troubleshooting

**`spawn uvx ENOENT`** — Use full path: `which uvx` → use that output in `command`

**DNS error / nodename not known** — `DBT_HOST` has wrong format; check multi-cell split above

**401/403 errors** — Token missing or expired; verify `DBT_TOKEN` and permissions

**Changes not taking effect** — MCP servers only load at startup; restart Claude Code after any config change

## Full Documentation

Official dbt MCP docs: https://docs.getdbt.com/docs/dbt-ai/setup-local-mcp
