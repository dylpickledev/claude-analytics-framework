# dbt MCP Server Setup Guide

## Three Setup Options

The dbt MCP server supports three authentication methods. Choose based on your needs:

### Option 1: Local MCP with .env Authentication (Simplest)

**Best for**: Single developer, local development, quick setup

**Setup Steps**:

1. **Install dbt MCP server**:
   ```bash
   npm install -g @modelcontextprotocol/server-dbt
   ```

2. **Create/update `.env` file** in project root:
   ```bash
   # dbt Cloud API Settings
   DBT_HOST=cloud.getdbt.com
   DBT_TOKEN=your-dbt-cloud-api-token
   DBT_PROD_ENV_ID=your-production-environment-id

   # Multi-cell Account (leave empty for single-cell accounts)
   MULTICELL_ACCOUNT_PREFIX=

   # Local dbt Project Settings
   DBT_PROJECT_DIR=~/claude-analytics-framework/repos/dbt_cloud
   DBT_PATH=/path/to/dbt

   # Feature Toggles
   DISABLE_DBT_CLI=false
   DISABLE_SEMANTIC_LAYER=false
   DISABLE_DISCOVERY=false
   DISABLE_SQL=true
   DISABLE_REMOTE=false
   ```

3. **Configure Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json`):
   ```json
   {
     "mcpServers": {
       "dbt": {
         "command": "mcp-server-dbt",
         "args": [],
         "env": {
           "DBT_HOST": "cloud.getdbt.com",
           "DBT_TOKEN": "your-dbt-cloud-api-token",
           "DBT_PROD_ENV_ID": "your-production-environment-id",
           "DBT_PROJECT_DIR": "~/claude-analytics-framework/repos/dbt_cloud"
         }
       }
     }
   }
   ```

4. **Restart Claude Desktop**

**Pros**: Simple, no OAuth flow, credentials in one place
**Cons**: API token in plaintext, manual token rotation

---

### Option 2: Local MCP with OAuth Authentication (Most Secure)

**Best for**: Security-conscious teams, shared machines, credential rotation

**Setup Steps**:

1. **Install dbt MCP server**:
   ```bash
   npm install -g @modelcontextprotocol/server-dbt
   ```

2. **Configure OAuth in dbt Cloud**:
   - Go to Account Settings → Service Tokens
   - Create OAuth application
   - Note `client_id` and `client_secret`

3. **Configure Claude Desktop** with OAuth:
   ```json
   {
     "mcpServers": {
       "dbt": {
         "command": "mcp-server-dbt",
         "args": ["--oauth"],
         "env": {
           "DBT_HOST": "cloud.getdbt.com",
           "DBT_OAUTH_CLIENT_ID": "your-oauth-client-id",
           "DBT_OAUTH_CLIENT_SECRET": "your-oauth-client-secret",
           "DBT_PROD_ENV_ID": "your-production-environment-id",
           "DBT_PROJECT_DIR": "~/claude-analytics-framework/repos/dbt_cloud"
         }
       }
     }
   }
   ```

4. **First-time authentication**:
   - Launch Claude Desktop
   - MCP will open browser for OAuth flow
   - Authorize application
   - Token cached locally

5. **Restart Claude Desktop**

**Pros**: Secure token handling, automatic refresh, no plaintext credentials
**Cons**: Initial OAuth setup, browser-based authentication

---

### Option 3: Remote MCP with OAuth (Cloud/Team Setup)

**Best for**: Teams, centralized management, Claude Web

**Setup Steps**:

1. **Deploy dbt MCP server** to cloud environment:
   ```bash
   # Example: Deploy to AWS Lambda or Cloud Run
   # (Deployment scripts not included - depends on infrastructure)
   ```

2. **Configure OAuth** in dbt Cloud (same as Option 2)

3. **Get MCP endpoint URL** from deployment

4. **Configure Claude** with remote endpoint:
   ```json
   {
     "mcpServers": {
       "dbt": {
         "url": "https://your-mcp-server.example.com/dbt",
         "auth": {
           "type": "oauth",
           "client_id": "your-oauth-client-id",
           "client_secret": "your-oauth-client-secret"
         },
         "env": {
           "DBT_HOST": "cloud.getdbt.com",
           "DBT_PROD_ENV_ID": "your-production-environment-id"
         }
       }
     }
   }
   ```

5. **Test connection** in Claude Desktop or Web

**Pros**: Centralized management, team sharing, works with Claude Web
**Cons**: Infrastructure overhead, network dependency

---

## Configuration Reference

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `DBT_HOST` | Yes | dbt Cloud host (e.g., `cloud.getdbt.com`) |
| `DBT_TOKEN` | Option 1 | dbt Cloud API token |
| `DBT_OAUTH_CLIENT_ID` | Options 2&3 | OAuth client ID |
| `DBT_OAUTH_CLIENT_SECRET` | Options 2&3 | OAuth client secret |
| `DBT_PROD_ENV_ID` | Yes | Production environment ID |
| `MULTICELL_ACCOUNT_PREFIX` | No | Multi-cell account prefix (if applicable) |
| `DBT_PROJECT_DIR` | Local only | Path to local dbt project |
| `DBT_PATH` | Local only | Path to dbt executable |

### Feature Toggles

| Variable | Default | Description |
|----------|---------|-------------|
| `DISABLE_DBT_CLI` | `false` | Disable local dbt CLI operations |
| `DISABLE_SEMANTIC_LAYER` | `false` | Disable semantic layer queries |
| `DISABLE_DISCOVERY` | `false` | Disable dbt Cloud discovery API |
| `DISABLE_SQL` | `true` | Disable direct SQL execution (recommended) |
| `DISABLE_REMOTE` | `false` | Disable remote dbt Cloud operations |

---

## Getting dbt Cloud Credentials

### API Token (Option 1)
1. Log in to dbt Cloud
2. Go to Account Settings → API Tokens
3. Click "Create Token"
4. Copy token immediately (shown once)

### OAuth Credentials (Options 2 & 3)
1. Log in to dbt Cloud
2. Go to Account Settings → Service Tokens → OAuth Applications
3. Click "Create OAuth App"
4. Set redirect URI (for local: `http://localhost:8080/callback`)
5. Note `client_id` and `client_secret`

### Production Environment ID
1. Go to dbt Cloud project
2. Navigate to Environments
3. Find production environment
4. Copy ID from URL: `https://cloud.getdbt.com/accounts/{account}/projects/{project}/environments/{ENV_ID}`

---

## Recommended Setup

**For Individual Developers**: Option 1 (Local + .env) - simplest to get started

**For Teams**: Option 2 (Local + OAuth) - balance of security and simplicity

**For Enterprise**: Option 3 (Remote + OAuth) - centralized, auditable, scalable

---

## Troubleshooting

### MCP Server Not Starting
- Check `~/Library/Application Support/Claude/logs/` for errors
- Verify `mcp-server-dbt` installed: `which mcp-server-dbt`
- Ensure all required env vars set

### Authentication Failures
- **API Token**: Verify token not expired, has correct permissions
- **OAuth**: Check client_id/secret, redirect URI matches
- **Multi-cell**: Verify `MULTICELL_ACCOUNT_PREFIX` if applicable

### Permission Errors
- Ensure API token/OAuth app has access to target environment
- Check dbt Cloud user permissions (Developer or higher)

---

## Security Best Practices

1. **Never commit credentials** to version control
2. **Use OAuth when possible** (Options 2 & 3)
3. **Rotate tokens regularly** (especially Option 1)
4. **Keep `DISABLE_SQL=true`** unless explicitly needed
5. **Limit MCP server permissions** to read-only when possible
6. **Use environment-specific credentials** (dev vs prod)

---

## Migration Guide

### From API Token to OAuth
1. Create OAuth app in dbt Cloud
2. Update Claude Desktop config with OAuth settings
3. Remove `DBT_TOKEN` from config
4. Restart Claude Desktop
5. Complete OAuth flow
6. Revoke old API token

### From Local to Remote
1. Deploy MCP server to cloud
2. Configure OAuth (if not already)
3. Update Claude config with remote URL
4. Test connection
5. Remove local MCP server config
