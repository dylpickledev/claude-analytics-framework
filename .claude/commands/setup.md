# /setup Command Protocol

## Purpose
Interactive repository customization that helps users configure da-agent-hub for their specific data stack and team needs. Uses conversational discovery to understand the user's tools, role, and requirements, then creates a customization plan.

## Usage
```bash
claude /setup
```

## Protocol

### 0. Pre-Setup Validation (CRITICAL - Run First)

**BEFORE starting conversational discovery**, ensure MCP foundation is in place:

```bash
# Check if .env exists
if [ ! -f .env ]; then
  echo "📋 Creating .env from template..."
  cp .env.example .env
  echo "⚠️  IMPORTANT: Edit .env with your dbt Cloud credentials before continuing"
  echo "   1. Get API token: https://cloud.getdbt.com/settings/tokens"
  echo "   2. Get Account ID from URL: https://cloud.getdbt.com/accounts/<ID>"
  echo ""
  echo "Run ./scripts/validate-mcp.sh when ready to validate your setup"
  exit 0
fi

# Check if .env has real values (not placeholders)
if grep -q "your_.*_here" .env || ! grep -q "^DBT_CLOUD_ACCOUNT_ID=[0-9]" .env; then
  echo "⚠️  .env needs your credentials"
  echo "   Run: ./scripts/validate-mcp.sh to check what's missing"
  exit 0
fi

# Validate MCP config
echo "🔍 Validating MCP configuration..."
./scripts/validate-mcp.sh

echo "✅ MCP foundation is ready! Starting customization..."
echo ""
```

**Key Points:**
- Project uses **project-level** MCP config (`.claude/mcp.json` in repo, not `~/.claude/mcp.json`)
- Credentials go in `.env` (NOT committed to git)
- Start minimal with just `dbt` MCP server
- Validation script catches issues before they become problems

### 1. Discovery Phase - Ask Questions Conversationally

**Goal**: Understand the user's data stack, role, and needs through natural conversation.

Start with:
```
Welcome to DA Agent Hub setup! I'll ask a few questions to customize this for YOUR data stack.

First, tell me about yourself:
- What's your primary role? (e.g., analytics engineer, data engineer, data architect, full-stack)
- What does your typical day look like with data tools?
```

### 2. Tool Discovery - Conversational Detection

**Instead of listing every tool**, ask open-ended questions:

```
What tools are you currently using? For example:
- Data transformation? (dbt, Spark, custom SQL scripts, etc.)
- Data warehouse? (Snowflake, BigQuery, Redshift, Databricks, etc.)
- Orchestration? (Airflow, Prefect, Dagster, Orchestra, Temporal, etc.)
- Ingestion? (Airbyte, Fivetran, dlthub, custom Python, etc.)
- BI/Analytics? (Tableau, PowerBI, Looker, Metabase, Streamlit, etc.)

Just tell me what you use - no need to answer all categories!
```

**Auto-detect where possible**:
- Check `~/.dbt/profiles.yml` for dbt configuration
- Check `~/.snowflake/` for Snowflake credentials
- Look for `airflow.cfg`, `prefect.toml`, etc.
- Check git repos in current directory

### 3. Team Context Discovery

Ask about team structure:
```
A few more questions:
- Are you setting this up for yourself or a team?
- If team: How many people? What are their roles?
- Do you have separate environments? (dev, staging, prod)
- Any specific repos I should connect to?
```

### 4. Use Case Discovery

Understand what they want to accomplish:
```
What do you want to use DA Agent Hub for? Examples:
- "Help me investigate failing dbt tests"
- "Optimize Snowflake query performance"
- "Build new data models faster"
- "Debug pipeline failures"
- "Generate documentation"

Tell me your top 2-3 use cases.
```

### 5. Create Customization Plan

Based on the conversation, generate a detailed plan:

```markdown
# 🎯 Your DA Agent Hub Customization Plan

## Detected Configuration
- **Role**: [detected role]
- **Primary Tools**: [list of tools]
- **Team Size**: [solo/team]
- **Top Use Cases**: [use cases]

## Recommended Configuration

### 1. MCP Servers to Enable
- [x] **dbt-core** (detected ~/.dbt/profiles.yml)
- [x] **snowflake** (for warehouse access)
- [x] **github** (for issue tracking and PRs)
- [ ] **dbt-cloud** (you mentioned using dbt Core, not Cloud)
- [ ] **clickup** (not detected - skip unless needed)

### 2. Agents to Activate
**Primary Agents** (these will be your go-to):
- `analytics-engineer-role` - Your main agent for dbt/SQL work
- `dbt-expert` - Deep dbt patterns and optimizations
- `snowflake-expert` - Query performance and cost optimization

**Available But Hidden** (can call when needed):
- `data-engineer-role` - For pipeline work if needed
- `dlthub-expert` - Not needed (you don't use dlthub)
- `tableau-expert` - Not needed (you use PowerBI)

### 3. Repository Configuration
Based on your repos, I recommend:
```yaml
repos:
  transformation:
    - path: ~/projects/dbt_project
      type: dbt_core

  warehouse:
    - snowflake: your_account
```

### 4. Quick Start Commands for YOUR Use Cases

**Use Case 1**: "Investigate failing dbt tests"
```bash
claude "Why is the unique_order_id test failing on dim_customers?"
# I'll use dbt-expert + snowflake-expert to investigate
```

**Use Case 2**: "Optimize Snowflake costs"
```bash
claude "Show me my most expensive Snowflake queries this week"
# I'll use snowflake-expert to analyze and recommend optimizations
```

**Use Case 3**: "Build new models faster"
```bash
claude "/capture 'Create fact_daily_sales model'"
claude "/start [issue-number]"
# analytics-engineer-role will scaffold the model with best practices
```

## Implementation Steps

Would you like me to:
1. ✅ Update MCP configuration (`~/.claude/mcp.json`)
2. ✅ Create stack config file (`~/.claude/da-stack.yaml`)
3. ✅ Generate your personalized quick reference
4. ✅ Copy only relevant agent files
5. ✅ Create role-specific documentation link

Respond with "yes" to implement this plan, or tell me what to adjust.
```

### 6. Implementation Phase

If user approves, execute the plan:

1. **Update MCP Configuration**:
   ```bash
   # Read current ~/.claude/mcp.json
   # Add/remove servers based on plan
   # Validate JSON structure
   ```

2. **Create Stack Config**:
   ```yaml
   # Generate ~/.claude/da-stack.yaml
   persona: analytics-engineer
   tools:
     dbt: core
     warehouse: snowflake
     bi: powerbi

   mcp_servers:
     enabled: [dbt-core, snowflake, github]
     disabled: [clickup, orchestra-wrapper, freshservice]

   agents:
     primary: [analytics-engineer-role, dbt-expert, snowflake-expert]
     hidden: [data-engineer-role, dlthub-expert, tableau-expert]

   use_cases:
     - "Investigate dbt test failures"
     - "Optimize Snowflake costs"
     - "Build data models faster"
   ```

3. **Create Personalized Quick Reference**:
   ```markdown
   # Your DA Agent Hub Quick Reference

   ## Your Top Commands
   [Based on detected use cases]

   ## Your Active Agents
   [Only relevant agents listed]

   ## First Steps
   [Role-specific getting started]
   ```

4. **Provide Next Steps**:
   ```
   ✅ Setup complete! Your DA Agent Hub is now customized for:
   - Role: Analytics Engineer
   - Tools: dbt Core + Snowflake + PowerBI
   - Use cases: dbt testing, query optimization, model development

   🎯 Try this right now:
   claude "Show me my 5 slowest dbt models and suggest optimizations"

   📖 Your personalized docs: ~/.claude/da-agent-hub-quickstart.md
   🔧 Your config: ~/.claude/da-stack.yaml

   Run /setup again anytime to reconfigure!
   ```

## Agent Consideration

**Do we need a setup-specialist agent?**

**NO - Keep it simple**. Here's why:
- Setup is conversational discovery (Claude's strength)
- One-time activity per user
- Simple file writes (no complex logic)
- Main Claude can handle Q&A + file operations

**When to add setup-specialist**:
- If setup becomes complex multi-step orchestration
- If we need to validate configs across multiple tools
- If we need deep expertise in MCP server configuration

## Plugin/Extension Opportunities

### Option 1: Claude Code Command Pack
**Publish**: Pre-configured `.claude/commands/` directory
- Users: `gh repo clone your-org/da-agent-hub-commands ~/.claude/commands/da`
- Gets: All slash commands (idea, research, start, setup, etc.)
- Benefit: Distribution without full repo clone

### Option 2: MCP Server Registry Entry
**Publish**: Custom MCP servers (dbt-core, data-ops, orchestra-wrapper)
- Register at: https://github.com/modelcontextprotocol/servers
- Users: Install via `npx @modelcontextprotocol/create-server`
- Benefit: Standardized MCP server distribution

### Option 3: Agent Library
**Publish**: Pre-configured agents (analytics-engineer-role, dbt-expert, etc.)
- Users: `claude agent add your-org/analytics-engineer-role`
- Gets: Agent definition automatically installed
- Benefit: Mix-and-match agents from community

### Option 4: Stack Template Repository
**Publish**: Template repo per common stack
- `da-agent-hub-dbt-snowflake` (dbt Core + Snowflake minimal)
- `da-agent-hub-dbt-cloud-complete` (dbt Cloud + full stack)
- `da-agent-hub-data-engineering` (Airflow + Airbyte + BigQuery)
- Benefit: One-click setup for common configurations

## Recommended Plugin Strategy

**Phase 1: Command Pack (Easiest)**
```bash
# Publish commands as standalone repo
your-org/claude-commands-data-stack
  ├── idea.md
  ├── research.md
  ├── start.md
  ├── setup.md
  └── complete.md

# Users install:
gh repo clone your-org/claude-commands-data-stack ~/.claude/commands/data
```

**Phase 2: Agent Library (Medium)**
```bash
# Publish agents as standalone
your-org/claude-agents-data-stack
  ├── analytics-engineer-role.md
  ├── data-engineer-role.md
  ├── dbt-expert.md
  └── snowflake-expert.md

# Future: Claude Code native support
claude agent install your-org/analytics-engineer-role
```

**Phase 3: MCP Server Registry (When stable)**
- Publish custom MCP servers to official registry
- Requires: Stable APIs, good documentation, community support

## Examples

### Example 1: Analytics Engineer with dbt Core

**User runs**: `claude /setup`

**Conversation**:
```
Claude: What's your role and typical day?
User: I'm an analytics engineer. I write dbt models, fix tests, optimize queries.

Claude: Great! What tools are you using?
User: dbt Core (not Cloud), Snowflake, and we're evaluating PowerBI.

Claude: Perfect! I detected your dbt profile. Do you have any repos I should know about?
User: My dbt project is at ~/work/dbt_project

Claude: What do you want help with most?
User: Investigating failing tests and optimizing slow models.

Claude: [Generates plan showing dbt-core + snowflake MCP, analytics-engineer-role + dbt-expert + snowflake-expert agents]

Claude: Should I implement this?
User: yes

Claude: ✅ Done! Try: claude "Show me my slowest dbt models"
```

### Example 2: Data Engineer with Multiple Tools

**User runs**: `claude /setup`

**Conversation**:
```
Claude: Tell me about your role and tools.
User: Data engineer. We use Airflow, Airbyte, and BigQuery. No dbt.

Claude: Got it! Any orchestration I should know about?
User: Airflow DAGs are in ~/airflow/dags

Claude: What are your top use cases?
User: Debug pipeline failures, monitor Airbyte syncs, optimize BigQuery costs.

Claude: [Generates plan with: no dbt agents, focus on data-engineer-role, bigquery-expert, potential airflow MCP]

Claude: I notice we don't have native BigQuery MCP yet. Want me to:
1. Use SQL execution for queries
2. Add BigQuery MCP from community registry
User: Option 1 for now

Claude: ✅ Setup complete! Try: claude "Show me Airflow DAG failures from last 24 hours"
```

## Success Criteria

- [ ] User completes setup in < 5 minutes
- [ ] Only relevant tools/agents configured
- [ ] First command succeeds (validates config)
- [ ] User understands next steps
- [ ] Personalized quick reference created

## Re-run Capability

Users can run `/setup` again to:
- Add new tools ("We just started using Tableau")
- Change role ("I'm now a data architect")
- Reconfigure for team ("Setting up for 3 new analysts")

---

*Conversational setup leveraging Claude's natural strengths - no complex scripts, just intelligent Q&A and file operations.*
