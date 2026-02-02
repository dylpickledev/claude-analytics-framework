# /onboard Command Protocol

## Purpose
Interactive onboarding for claude-analytics-framework that configures the system for each user's specific data stack. This command is typically called by `setup.sh` but can be run directly to reconfigure your stack.

## Protocol

### Phase 1: Welcome & Context Setting

Start with a friendly welcome:

```
🎉 Welcome to claude-analytics-framework!

I'll configure this framework for your data stack in about 5 minutes.

We'll cover:
  1. Your data tools (dbt, Snowflake, Tableau, etc.)
  2. AI specialist agents for your stack
  3. Optional MCP servers for real-time data access
  4. Quick walkthrough of the workflow

Ready to get started? [Press Enter to continue]
```

### Phase 2: Tech Stack Discovery

Use the `AskUserQuestion` tool to gather tech stack information. Ask ALL questions at once for efficiency:

**Question 1: Transformation Tool**
- Header: "Transform"
- Question: "What transformation tool do you use?"
- Options:
  - dbt Core (description: "Open-source dbt installed locally")
  - dbt Cloud (description: "Managed dbt service with job scheduling")
  - Databricks SQL (description: "SQL-based transformations in Databricks")
  - Raw SQL / Stored Procedures (description: "Direct SQL in warehouse")
  - Other (description: "Different transformation tool - we'll help you create a custom agent")

**Follow-up if dbt selected**: Ask for version (1.5, 1.6, 1.7, 1.8+) and plan (Developer, Team, Enterprise for dbt Cloud)

**Question 2: Data Warehouse**
- Header: "Warehouse"
- Question: "What data warehouse do you use?"
- Options:
  - Snowflake
  - BigQuery
  - Databricks
  - Redshift
  - PostgreSQL
  - Other

**Question 3: Orchestration**
- Header: "Orchestration"
- Question: "What orchestration tool do you use?"
- Options:
  - Prefect (description: "Modern Python-based workflow orchestration")
  - Airflow (description: "Apache Airflow for workflow management")
  - Dagster (description: "Data orchestrator for machine learning, analytics, and ETL")
  - dbt Cloud (description: "Use dbt Cloud's built-in scheduler")
  - None / Manual (description: "Run jobs manually or via cron")
  - Other

**Question 4: BI/Visualization**
- Header: "BI Tool"
- Question: "What BI or visualization tool do you use?"
- Options:
  - Tableau
  - Power BI
  - Looker
  - Streamlit
  - Metabase
  - Other

### Phase 3: Save Configuration

Create `.claude/config/tech-stack.json` using the Write tool:

```json
{
  "transformation": {
    "tool": "dbt_cloud",
    "version": "1.8",
    "plan": "team"
  },
  "warehouse": {
    "platform": "snowflake"
  },
  "orchestration": {
    "tool": "prefect"
  },
  "bi": {
    "tool": "tableau"
  },
  "configured_at": "2025-10-21T10:30:00Z"
}
```

Ensure the `.claude/config/` directory exists first.

### Phase 4: Agent Lifecycle Management

Based on the tech-stack.json configuration, manage specialist agents:

**Always Create (Universal Agents)**:
- `.claude/agents/specialists/claude-code-expert.md` - Setup and troubleshooting
- `.claude/agents/roles/data-architect-role.md` - Already exists, no action needed
- `.claude/agents/roles/data-engineer-role.md` - Already exists, no action needed
- `.claude/agents/roles/analytics-engineer-role.md` - Already exists, no action needed

**Conditionally Create**:
- If `transformation.tool` is "dbt_core" or "dbt_cloud":
  - Create `.claude/agents/specialists/dbt-expert.md` (already exists, check and update version context if needed)
- If `warehouse.platform` is "snowflake":
  - `.claude/agents/specialists/snowflake-expert.md` (already exists)
- If `bi.tool` is "tableau":
  - `.claude/agents/specialists/tableau-expert.md` (already exists)
- If `orchestration.tool` is "dlthub" or uses dlthub:
  - `.claude/agents/specialists/dlthub-expert.md` (already exists)

**Delete Irrelevant Agents**:
- If NOT using Tableau → Remove `.claude/agents/specialists/tableau-expert.md`
- If NOT using dlthub → Remove `.claude/agents/specialists/dlthub-expert.md`
- Check for other tool-specific agents and remove if not in stack

**Handle "Other" Selections**:
If user selects "Other" for any tool, offer to create a custom agent:

```
You selected "[Tool Name]" for [category].

claude-analytics-framework doesn't have a [tool-name]-expert specialist yet.

Would you like to create one now? [y/N]

[If yes]
  I'll create a custom specialist agent based on the template...

  [Use Write tool to create .claude/agents/specialists/[tool-name]-expert.md from specialist-template.md]

  ✅ Created: .claude/agents/specialists/[tool-name]-expert.md

  Next steps:
  1. Review the template structure
  2. Add [tool-name]-specific knowledge and patterns
  3. Define MCP tools if available
  4. Test with a simple task

  Documentation: knowledge/da-agent-hub/development/creating-custom-agents.md
```

Show summary of agent changes:

```
🤖 Configured AI agents for your stack:

  ✅ Created: dbt-expert.md (dbt Cloud 1.8 specialist)
  ✅ Kept: snowflake-expert.md (warehouse optimization)
  ✅ Kept: tableau-expert.md (BI dashboards)
  ✅ Created: claude-code-expert.md (setup & troubleshooting)
  🗑️  Removed: dlthub-expert.md (not in your stack)

  Universal agents: data-architect-role, data-engineer-role, analytics-engineer-role
```

### Phase 5: MCP Server Configuration (Optional Per-Server)

For each relevant MCP server based on their stack, offer opt-in configuration:

**dbt-mcp** (if using dbt Cloud or dbt Core):
```
🔌 dbt MCP Server (optional)

This enables real-time dbt access:
  • Query model metadata and status
  • Run jobs programmatically (dbt Cloud)
  • Access Semantic Layer metrics
  • Analyze test results
  • Execute local dbt commands (dbt Core)

Configure now? [y/N]

[If yes]
  Choose your dbt MCP setup method:

  1. Local MCP with .env (simplest)
     → Credentials in .env file
     → Best for: Single developer, quick setup

  2. Local MCP with OAuth (most secure)
     → Browser-based authentication
     → Best for: Security-conscious teams, credential rotation

  3. Remote MCP with OAuth (cloud/team)
     → Centralized MCP server
     → Best for: Teams, Claude Web integration

  Which option? [1/2/3]

  [If option 1 - Local .env]
    dbt Cloud API Settings:
      Host: [default: cloud.getdbt.com]
      API Token: [secure input]
      Production Environment ID: [input]
      Multi-cell account prefix (optional): [input]

    Local dbt Project Settings (if using dbt Core):
      dbt project directory: [default: ~/claude-analytics-framework/repos/dbt_cloud]
      dbt executable path: [default: /usr/local/bin/dbt]

    Creating .env file...
    ✅ .env configured with dbt credentials

    Installing MCP server...
    npm install -g @modelcontextprotocol/server-dbt

    Configuring Claude Desktop...
    ✅ Updated ~/Library/Application Support/Claude/claude_desktop_config.json

    Next steps:
      1. Restart Claude Desktop to load the MCP server
      2. Try: "What dbt models failed in the last run?"

    Setup guide: config/dbt-mcp-setup.md

  [If option 2 - Local OAuth]
    First, create an OAuth app in dbt Cloud:
      1. Go to dbt Cloud → Account Settings → Service Tokens → OAuth Applications
      2. Click "Create OAuth App"
      3. Set redirect URI: http://localhost:8080/callback
      4. Copy the client_id and client_secret

    dbt Cloud OAuth Settings:
      Host: [default: cloud.getdbt.com]
      OAuth Client ID: [input]
      OAuth Client Secret: [secure input]
      Production Environment ID: [input]
      Multi-cell account prefix (optional): [input]

    Local dbt Project Settings (if using dbt Core):
      dbt project directory: [default: ~/claude-analytics-framework/repos/dbt_cloud]
      dbt executable path: [default: /usr/local/bin/dbt]

    Installing MCP server...
    npm install -g @modelcontextprotocol/server-dbt

    Configuring Claude Desktop with OAuth...
    ✅ Updated ~/Library/Application Support/Claude/claude_desktop_config.json

    Next steps:
      1. Restart Claude Desktop
      2. Browser will open for OAuth authorization
      3. Authorize the application
      4. Try: "What dbt models failed in the last run?"

    Setup guide: config/dbt-mcp-setup.md

  [If option 3 - Remote OAuth]
    Remote MCP setup requires infrastructure deployment.

    This option is for teams who want:
      • Centralized MCP server management
      • Claude Web compatibility
      • Shared team configuration

    I'll create a deployment guide for your infrastructure team.

    Creating deployment guide...
    ✅ Created: docs/mcp-setup/dbt-mcp-remote-deployment.md

    This guide includes:
      • AWS Lambda deployment example
      • Docker containerization
      • OAuth configuration
      • Claude Desktop/Web configuration

    After your team deploys the remote MCP:
      1. Get the MCP endpoint URL
      2. Run /onboard again and select option 3
      3. I'll configure Claude with the remote endpoint

[If no]
  No problem! Setup guide available at: config/dbt-mcp-setup.md
  You can configure this anytime by running /onboard again.
```

**snowflake-mcp** (if using Snowflake):
```
🔌 Snowflake MCP Server (optional)

This enables direct Snowflake warehouse access:
  • Execute queries directly
  • Analyze query performance
  • Check data quality
  • Cost analysis with Cortex AI

Configure now? [y/N]

[If yes]
  Snowflake account (format: org-account): [input]
  Snowflake username: [input]
  Snowflake password: [secure input]
  Snowflake warehouse: [input, default: COMPUTE_WH]
  Snowflake database (optional): [input]
  Snowflake role (optional): [input]

  Testing connection...
  ✅ Connected to Snowflake!

  Updated .claude/mcp.json

[If no]
  No problem! Setup guide saved to: docs/mcp-setup/snowflake-mcp.md
```

**github-mcp** (always offer):
```
🔌 GitHub MCP Server (optional)

This enables GitHub integration:
  • Repository analysis
  • Issue and PR management
  • Code search across repos
  • Commit history analysis

Configure now? [y/N]

[If yes]
  GitHub personal access token: [secure input]

  Testing connection...
  ✅ Connected to GitHub!

  Updated .claude/mcp.json

[If no]
  No problem! Setup guide saved to: docs/mcp-setup/github-mcp.md
```

**MCP Configuration Updates**:
Use Edit or Write tool to update `.claude/mcp.json` with the appropriate server configuration. If file doesn't exist, create it.

### Phase 6: Validation & Tutorial

Show completion summary and quick tutorial:

```
✅ Setup complete!

Your configuration:
  📦 Stack: dbt Cloud (1.8) + Snowflake + Tableau + Prefect
  🤖 Agents: 6 specialists configured for your tools
  🔌 MCP: 2 servers connected (dbt, snowflake)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Quick Tutorial: The ADLC Workflow

1. 💡 Capture ideas → GitHub issues
   /capture "build customer churn prediction dashboard"
   → Creates GitHub issue for tracking

2. 🔬 Research (optional, for complex projects)
   /research 123
   → Specialist agents analyze approach, feasibility, technical details

3. 🚀 Start development
   /start 123
   → Creates project structure, git worktree, links to GitHub issue

4. 🔄 Switch between projects
   /switch
   → Zero-loss context switching with automatic backup

5. ✅ Complete and archive
   /complete project-name
   → Extracts learnings, closes issue, archives project

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Try it now:
  /start "your first project idea"

Need help anytime? Ask me:
  use claude-code-expert to explain [topic]
  use dbt-expert to analyze my dbt models
  use data-architect-role for system design questions

Happy building! 🎉
```

## Implementation Notes

### Creating claude-code-expert.md

If `.claude/agents/specialists/claude-code-expert.md` doesn't exist, create it with these core sections:

```markdown
# Claude Code Expert

## Role & Expertise
Claude Code specialist providing expert guidance on installation, configuration, MCP integration, and best practices. Serves as the setup and troubleshooting specialist for claude-analytics-framework itself.

## Core Responsibilities
- **Installation Support**: Guide OS-specific Claude Code installation
- **MCP Integration**: Configure MCP servers for user's tech stack
- **Agent System**: Explain role vs specialist agent patterns
- **Command Mastery**: Teach /capture, /research, /start, /switch, /complete workflow
- **Troubleshooting**: Debug Claude Code issues, MCP connection problems
- **Best Practices**: Workflow optimization, memory system usage

## Common Delegation Scenarios

**First-time setup**:
- "How do I install Claude Code?" → OS-specific installation guide
- "What are MCP servers?" → Explain Model Context Protocol, show examples for their stack
- "Which agents should I use?" → Based on tech-stack.json, recommend relevant agents

**Configuration issues**:
- "dbt-mcp not connecting" → Debug .claude/mcp.json, check credentials, test connection
- "Agent not responding" → Check agent file exists, syntax valid, role vs specialist delegation

**Workflow optimization**:
- "When should I use /research vs /start?" → Explain decision framework
- "How do I switch between projects?" → /switch command walkthrough, worktree explanation
- "How does the memory system work?" → Pattern extraction, reuse, continuous improvement

## Quality Standards

**Every recommendation must include**:
- ✅ Clear step-by-step instructions
- ✅ Expected outcomes at each step
- ✅ Troubleshooting for common issues
- ✅ Links to relevant documentation

## Available Tools
- Read claude-analytics-framework documentation
- WebFetch Claude Code documentation
- Guide MCP server configuration
- Explain agent coordination patterns
```

### Tech Stack JSON Schema

The `.claude/config/tech-stack.json` should follow this structure:

```json
{
  "transformation": {
    "tool": "dbt_core|dbt_cloud|databricks_sql|raw_sql|other",
    "version": "1.5|1.6|1.7|1.8+",
    "plan": "developer|team|enterprise",
    "custom_tool_name": "string (if tool=other)"
  },
  "warehouse": {
    "platform": "snowflake|bigquery|databricks|redshift|postgresql|other",
    "custom_platform_name": "string (if platform=other)"
  },
  "orchestration": {
    "tool": "prefect|airflow|dagster|dbt_cloud|none|other",
    "custom_tool_name": "string (if tool=other)"
  },
  "bi": {
    "tool": "tableau|powerbi|looker|streamlit|metabase|other",
    "custom_tool_name": "string (if tool=other)"
  },
  "custom_tools": [],
  "configured_at": "ISO 8601 timestamp"
}
```

### File Operations

**Creating directories**:
- Ensure `.claude/config/` exists before writing tech-stack.json
- Ensure `docs/mcp-setup/` exists if creating deferred setup guides

**Agent file management**:
- Use Write tool for new agent files
- Use Edit tool if updating existing agents with version-specific context
- When removing agents, explain why they're being removed

**MCP configuration**:
- Read existing `claude_desktop_config.json` if it exists
- Merge new server configs with existing ones
- Don't overwrite unrelated MCP servers

**dbt MCP Configuration Details**:

For **Option 1 (Local .env)**:
1. Update or create `.env` file in project root with:
   ```
   DBT_HOST=cloud.getdbt.com
   DBT_TOKEN=<user-provided>
   DBT_PROD_ENV_ID=<user-provided>
   MULTICELL_ACCOUNT_PREFIX=<user-provided-or-empty>
   DBT_PROJECT_DIR=<user-provided-or-default>
   DBT_PATH=<user-provided-or-default>
   ```

2. Update `~/Library/Application Support/Claude/claude_desktop_config.json`:
   ```json
   {
     "mcpServers": {
       "dbt": {
         "command": "mcp-server-dbt",
         "args": [],
         "env": {
           "DBT_HOST": "cloud.getdbt.com",
           "DBT_TOKEN": "<from-user-input>",
           "DBT_PROD_ENV_ID": "<from-user-input>",
           "DBT_PROJECT_DIR": "<from-user-input>"
         }
       }
     }
   }
   ```

For **Option 2 (Local OAuth)**:
1. Guide user through OAuth app creation in dbt Cloud (show instructions before collecting credentials)

2. Update `~/Library/Application Support/Claude/claude_desktop_config.json`:
   ```json
   {
     "mcpServers": {
       "dbt": {
         "command": "mcp-server-dbt",
         "args": ["--oauth"],
         "env": {
           "DBT_HOST": "cloud.getdbt.com",
           "DBT_OAUTH_CLIENT_ID": "<from-user-input>",
           "DBT_OAUTH_CLIENT_SECRET": "<from-user-input>",
           "DBT_PROD_ENV_ID": "<from-user-input>",
           "DBT_PROJECT_DIR": "<from-user-input>"
         }
       }
     }
   }
   ```

For **Option 3 (Remote OAuth)**:
1. Create deployment guide at `docs/mcp-setup/dbt-mcp-remote-deployment.md`
2. Use Write tool to create comprehensive deployment guide
3. Reference `config/dbt-mcp-setup.md` for OAuth setup details
4. Explain that actual configuration happens after infrastructure deployment

**Claude Desktop Config Path**:
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Linux: `~/.config/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`

**MCP Server Installation**:
- Always run: `npm install -g @modelcontextprotocol/server-dbt`
- Check if npm is installed first, provide installation guide if missing
- Verify installation: `which mcp-server-dbt`

### Error Handling

- If AskUserQuestion fails, fall back to collecting answers one at a time
- If Write fails (permissions, disk full), provide clear error message
- If MCP connection test fails, save config anyway but note test failure
- Always provide fallback options (manual setup guides)

## Reconfiguration Support

This command can be run multiple times:
- Detect existing tech-stack.json and offer to update vs replace
- Show current configuration before asking questions
- Preserve MCP configurations unless user wants to reconfigure
- Update agents incrementally (add new, remove obsolete, update existing)

---

*This command orchestrates the entire onboarding experience, from tech stack discovery to agent configuration to MCP setup, creating a personalized claude-analytics-framework instance for each user.*
