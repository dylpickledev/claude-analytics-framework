# Claude Analytics Framework

> AI-powered analytics development with specialized agents and workflows

A framework for analytics teams that combines Claude Code with specialized agents, patterns, and MCP integrations for your data stack.

**What you get:**
- 5 slash commands for project lifecycle (`/idea` → `/research` → `/start` → `/switch` → `/complete`)
- AI agents created based on YOUR tools (setup asks what you use)
- Optional live system access via MCP servers
- Automatic learning from completed projects

**Built on:** [Claude Code](https://docs.claude.com/en/docs/claude-code) (Anthropic's official AI coding assistant)

---

## TL;DR - Is This For You?

**You'll love this if you want:**
- 🤖 **AI agents specialized for YOUR stack** - knows your dbt patterns, warehouse setup, BI standards
- 📂 **Organized project workflow** - structured folders, clear documentation, automated git workflow
- 🔗 **Coordinated cross-repo changes** - one project manages dbt + warehouse + BI changes together
- 📝 **Team knowledge capture** - patterns extracted automatically, new team members get your expertise
- 🔌 **Live system integration** - MCP servers connect to dbt Cloud, Snowflake, GitHub for real-time context
- ⚡ **Workflow automation** - `/idea` → `/research` → `/start` → `/complete` commands guide your process

**What makes it different:**
- **Specialized agents**: Not generic AI - agents configured for your specific tools and patterns
- **Learning system**: After 3-5 projects, knows your incremental strategies, naming conventions, testing standards
- **Structured workflow**: Project organization, branch management, PR creation built-in
- **Context management**: `/switch` for multi-project work, or focus on single projects with full context
- **Tool-agnostic**: Pre-built for dbt/Snowflake/Tableau, easily extended for your stack

**Time investment:**
- ⚡ Setup: 5 minutes (interactive questions about your stack)
- ⚡ First project: Immediate (`/start "idea"` → working folder)
- ⚡ ROI: After project #3, agents know your patterns better than documentation

---

## What This Is

**A meta-repository that orchestrates work across your data stack.**

Think of it as a control center sitting alongside your existing repositories (dbt projects, Tableau dashboards, data pipelines, etc.). It doesn't replace your repos - it provides structure and AI guidance for working on them.

**The architecture:**
```
claude-analytics-framework/          ← This repo (meta-layer)
├── .claude/                    ← AI agents + commands
│   ├── agents/                 ← Specialists for YOUR tools
│   ├── commands/               ← /idea, /start, /complete, etc.
│   └── config/                 ← Your tech stack configuration
├── projects/                   ← Active/completed project folders
│   ├── active/                 ← Current work
│   └── completed/              ← Archived learnings
├── repos/                      ← Your actual data repos (gitignored)
│   ├── dbt_cloud/              ← Your dbt project
│   ├── data_pipelines/         ← Your pipeline code
│   └── tableau_workbooks/      ← Your BI dashboards
└── scripts/                    ← Workflow automation
```

**Key:** The `repos/` folder keeps your work repositories organized in one place. It's gitignored - these repos aren't committed to the framework.

**How it augments your development:**

1. **Structured coordination**: Instead of scattered work across repos, you get organized projects that coordinate changes
2. **AI that knows your stack**: Agents read from and operate on your actual repositories with context about your tools
3. **Cross-repo workflows**: Work that spans dbt + Snowflake + Tableau gets coordinated in one project
4. **Knowledge accumulation**: As you complete projects, the framework learns your patterns and improves recommendations

**The workflow:**
1. **Capture** ideas as GitHub issues (`/idea "build customer dashboard"`)
2. **Research** complex topics before building (`/research 123` - optional)
3. **Start** projects with organized folders (`/start 123` - creates structure + git worktree)
4. **Switch** between projects seamlessly (`/switch` - zero-loss context switching)
5. **Complete** and archive (`/complete project-name` - closes issue, extracts learnings)

**The AI agents:**
- Setup asks what tools you use (dbt? Snowflake? Tableau? etc.)
- Creates specialist agents for your stack
- Agents know patterns for YOUR tools (not generic advice)
- Optionally connect to live systems (dbt Cloud API, Snowflake queries, etc.)

**The result:**
You still work in your normal repos, but now you have:
- Project organization and tracking
- AI assistance tailored to your tools
- Cross-repository coordination
- Automatic knowledge capture

**Example: Multi-repo project coordination**

```
Project: "Add customer churn prediction dashboard"

claude-analytics-framework/
├── projects/active/feature-churn-dashboard/
│   ├── spec.md              ← What we're building
│   ├── context.md           ← Current state, blockers, decisions
│   └── tasks/
│       ├── dbt-expert-findings.md      ← Model designs
│       ├── tableau-expert-findings.md  ← Dashboard layouts
│       └── data-engineer-findings.md   ← Pipeline setup
│
└── repos/                              ← Your actual repos
    ├── dbt_cloud/
    │   └── models/marts/customer_churn.sql     (new model)
    ├── data_pipelines/
    │   └── prefect/churn_refresh.py            (new pipeline)
    └── tableau_workbooks/
        └── churn_dashboard.twb                  (new dashboard)

On /complete:
✅ All changes committed to respective repos
✅ Patterns extracted: "customer churn modeling approach"
✅ Future churn projects now start with YOUR proven pattern
```

### The Workflow (Visual)

```
💡 Idea
  ↓ /idea
📋 GitHub Issue #123
  ↓ /research (optional)
🔬 Research Report
  ↓ /start 123
📁 Project Folder + Git Branch + AI Agents
  ↓ Work with specialists
🔄 /switch (context switch anytime)
  ↓ /complete
✅ Archived + Learnings Extracted + Issue Closed
  ↓
💾 Memory System (future projects benefit)
```

---

## Quick Start (Zero to Running in 5 Minutes)

**Prerequisites**: You need [Claude Code](https://docs.claude.com/en/docs/claude-code) installed first.

### Never used Claude Code?

Claude Code is Anthropic's official AI coding assistant that runs in your terminal.

**Installation:** Follow the [official installation guide](https://docs.claude.com/en/docs/claude-code/installation)

### Installation

**Step 1: Clone this repository**
```bash
git clone https://github.com/dylpickledev/claude-analytics-framework.git
cd claude-analytics-framework
```

**Step 2: Run interactive setup**
```bash
./setup.sh
```

**What setup does:**

1. **Checks** you have Claude Code installed (exits with install instructions if not)
2. **Asks** about your tech stack:
   - What transformation tool? (dbt Cloud, dbt Core, raw SQL, etc.)
   - What data warehouse? (Snowflake, BigQuery, PostgreSQL, etc.)
   - What orchestration? (Prefect, Airflow, manual, etc.)
   - What BI tool? (Tableau, Power BI, Streamlit, etc.)
3. **Creates AI specialists** matching your answers:
   - If you said "dbt Cloud" → creates `dbt-expert.md` agent
   - If you said "Snowflake" → creates `snowflake-expert.md` agent
   - If you said "Tableau" → creates `tableau-expert.md` agent
   - If you said "Other [tool]" → offers to create custom agent from template
4. **Optionally configures MCP servers** for live data access (you can skip this):
   - dbt MCP → query dbt Cloud API in real-time
   - Snowflake MCP → execute warehouse queries directly
   - GitHub MCP → analyze repositories and issues

**Step 3: Start your first project**
```bash
claude /start "your first project idea"
```

**That's it!** You have a project folder, AI agents that know your tools, and the 5-command workflow ready to use.

---

## The 5 Commands

### 1. `/idea` - Capture ideas
Creates GitHub issues for data initiatives
```bash
claude /idea "Optimize Snowflake costs"
```

### 2. `/research` - Deep exploration
Specialist agents analyze technical approach
```bash
claude /research "dbt incremental model strategy"
claude /research 123  # Analyze issue #123
```

### 3. `/start` - Begin development
Creates project structure + git worktree
```bash
claude /start 123  # From issue
claude /start "new project idea"  # Creates issue + starts
```

### 4. `/switch` - Context switching
Zero-loss project switching with backup
```bash
claude /switch  # Save current, switch to main
claude /switch feature-branch  # Switch to specific branch
```

### 5. `/complete` - Finish project
Archives project, extracts learnings, closes issue
```bash
claude /complete feature-project-name
```

**Bonus Commands:**
- `/pause [description]` - Save conversation context for seamless resumption
- `/setup-worktrees` - One-time VS Code worktree integration setup

**Note**: Use GitHub's native issue management, labels, and milestones for roadmap planning and prioritization.

---

## The AI Agents (Created During Setup)

### Role Agents (Always Created)

These handle 80% of work independently:

**analytics-engineer-role**
- Writes dbt models, SQL transformations, data modeling
- Optimizes query performance, semantic layer design
- Prepares data for BI consumption

**data-engineer-role**
- Sets up data pipelines and orchestration
- Integrates source systems, ensures data quality
- Chooses appropriate ingestion tools

**data-architect-role**
- Designs system architecture
- Makes technology selection decisions
- Plans cross-system integration

### Specialist Agents (Created Based on Your Tech Stack)

Setup creates these **only if you use these tools**:

**dbt-expert** (if you selected dbt Cloud or dbt Core)
- Deep dbt knowledge: incremental models, testing, packages
- Can connect to dbt Cloud API via MCP (optional setup)

**snowflake-expert** (if you selected Snowflake)
- Warehouse optimization and cost analysis
- Can query Snowflake directly via MCP (optional setup)

**tableau-expert** (if you selected Tableau)
- Dashboard performance and design patterns

**claude-code-expert** (always created)
- Helps with setup, troubleshooting, workflow questions

**Don't see your tool?** Setup offers to create a custom specialist agent from a template.

### Supported Tools (Out of the Box)

Setup recognizes these tools and creates appropriate specialists:

**Transformation:**
- dbt Cloud ✅
- dbt Core ✅
- Raw SQL / Stored Procedures (uses generic analytics-engineer-role)
- Databricks SQL (creates custom agent from template)
- Other (you create custom agent)

**Warehouses:**
- Snowflake ✅ (with optional MCP)
- BigQuery (uses generic knowledge)
- PostgreSQL (uses generic knowledge)
- Databricks (uses generic knowledge)
- Redshift (uses generic knowledge)
- Other (you create custom agent)

**Orchestration:**
- Prefect (uses generic data-engineer-role)
- Airflow (uses generic data-engineer-role)
- Dagster (uses generic data-engineer-role)
- dbt Cloud scheduler (uses dbt-expert)
- Other (you create custom agent)

**BI/Visualization:**
- Tableau ✅
- Power BI (uses generic knowledge)
- Looker (uses generic knowledge)
- Streamlit (uses generic knowledge)
- Metabase (uses generic knowledge)
- Other (you create custom agent)

**Always Available:**
- GitHub ✅ (with optional MCP)
- Git workflow (built-in)
- Claude Code expert (setup/troubleshooting)

✅ = Has dedicated specialist agent with deep expertise
🔌 = MCP server available for live system access

**The truth about "support":**
- ✅ = Pre-built agents with mature patterns (fastest time to value)
- "Generic knowledge" = Claude's base knowledge works, agents guide workflow
- "Custom agent" = You create specialist, framework helps it improve over time

**This framework is designed to support ANY tool:**
- Start with basic agents (even generic ones work)
- Use the ADLC workflow to build projects
- Agents learn your patterns as you complete work
- After 3-5 projects, your custom agents know YOUR specific patterns
- The `/complete` command extracts learnings automatically

**Bottom line:** You don't need pre-built agents to start. The framework is self-improving. Your first projects teach the agents about your tools.

### How Agents Work Together

Role agents delegate to specialists for complex cases (20% of work). Example:

```
You: "Optimize this slow dbt model"
  ↓
analytics-engineer-role: Reviews model structure
  ↓ (needs deep dbt expertise)
dbt-expert: Analyzes incremental strategy, suggests optimizations
  ↓ (if MCP configured)
dbt-mcp: Queries actual run history from dbt Cloud API
  ↓
Result: Specific optimization based on YOUR production data
```

---

## MCP Integration (Optional)

MCP servers connect Claude to your live systems for real-time data access.

**Setup asks** if you want to configure these (you can skip and add later):

**dbt MCP** (if using dbt):
- Query model metadata and job status
- Analyze test results from actual runs
- Access Semantic Layer metrics

**Snowflake MCP** (if using Snowflake):
- Execute queries directly in your warehouse
- Analyze query performance and costs
- Check data quality in real tables

**GitHub MCP** (always offered):
- Search code across repositories
- Analyze issues and pull requests
- Review commit history

**How it works:**
1. Setup guides you through credential collection
2. Updates `claude_desktop_config.json` with MCP server config
3. Restart Claude Desktop → MCP servers load automatically
4. Agents can now query your real systems

**Why it matters:** Instead of generic advice, agents see YOUR actual data and make informed recommendations.

---

## What You Need to Get Started

**Essential:**
- [Claude Code](https://docs.claude.com/en/docs/claude-code) - Anthropic's AI coding assistant
- Git - For version control and GitHub integration

**Your data tools:**
- The framework adapts to what YOU use
- Setup asks about your stack and configures accordingly
- No specific tools required upfront

**Optional (setup will guide you):**
- Node.js/npm - Only if you want MCP server integration
- GitHub CLI (`gh`) - For enhanced GitHub operations
- Docker + VS Code - If you want devcontainer setup (see below)

---

## Advanced Setup Options

### Devcontainer Setup (Fully Automated)

Get everything pre-installed in a Docker container:

```bash
# Prerequisites: Docker Desktop + VS Code + Dev Containers extension

git clone https://github.com/dylpickledev/claude-analytics-framework.git
cd claude-analytics-framework
code .

# VS Code will prompt "Reopen in Container" → Click it
# Wait ~2-3 minutes for first-time setup

# Once container is ready:
gh auth login        # Authenticate with GitHub
claude auth          # Authenticate with Claude Code
./setup.sh           # Run interactive setup
```

**Devcontainer includes:**
- Claude Code pre-installed
- Node.js + npm (for MCP servers)
- GitHub CLI
- Git configured
- All dependencies ready

See [.devcontainer/README.md](.devcontainer/README.md) for details.

### VS Code Worktree Integration

For seamless branch switching with dedicated VS Code windows:

```bash
claude /setup-worktrees  # One-time setup
```

After setup, `/start` and `/switch` commands automatically open the right VS Code window for each project.

---

## Example Workflow

Here's what a typical project looks like:

```bash
# 1. Capture idea → GitHub issue
claude /idea "Build customer analytics dashboard"
# Output: ✅ Created issue #123

# 2. Research (optional - for complex projects)
claude /research 123
# Specialist agents analyze approach, feasibility, technical details
# You get a research report before starting

# 3. Start project → folder + git worktree + issue link
claude /start 123
# Output:
#   ✅ Created: projects/active/feature-customer-analytics/
#   ✅ Created branch: feature/customer-analytics
#   ✅ Linked to issue #123
#   📝 VS Code opened (if worktree integration setup)

# 4. Work with AI agents
claude "use analytics-engineer-role to design the data model"
# Role agent delegates to dbt-expert for complex modeling
# If MCP configured, queries your actual dbt project structure

claude "use data-engineer-role to set up incremental refresh"
# Gets suggestions based on your orchestration tool (from setup)

# 5. Context switch (urgent work pops up)
claude /switch  # Saves current work, returns to main
claude /start 125  # Different urgent project
claude /complete feature-urgent-fix  # Finish urgent work
claude /switch feature-customer-analytics  # Resume original work
# Zero loss - picks up exactly where you left off

# 6. Complete and learn
claude /complete feature-customer-analytics
# Output:
#   ✅ Archived to: projects/completed/2025-10/feature-customer-analytics/
#   ✅ Extracted learnings to memory system
#   ✅ Closed GitHub issue #123
#   ✅ Cleaned up git worktree
#   💡 Agents now know customer analytics patterns for future projects
```

**What just happened:**
- Idea tracked in GitHub (team visibility)
- Organized project folder (not scattered files)
- AI agents with domain expertise helped (not generic chatbot)
- Work saved when context switching (no lost progress)
- Knowledge extracted automatically (future projects benefit)

---

## What Makes This Different

**This is NOT:**
- ❌ A replacement for your existing repos
- ❌ A new tool you have to migrate to
- ❌ Just AI prompts in a folder
- ❌ Locked into specific tools

**This IS:**
- ✅ A meta-repository that sits alongside your existing work
- ✅ A structured workflow for coordinating cross-repo changes
- ✅ A learning system that captures YOUR team's expertise
- ✅ Tool-agnostic with agent templates for any stack

**How it's different from just using Claude Code:**

| Plain Claude Code | claude-analytics-framework |
|---|---|
| Ad-hoc conversations | Organized projects with tracking |
| Generic AI knowledge | Agents that know YOUR tools & patterns |
| Work scattered across repos | Coordinated cross-repo workflows |
| No memory between sessions | Automatic pattern extraction & learning |
| Manual git workflow | Built-in branch/PR workflow |
| Lost context when switching | Zero-loss context switching |

**Practical benefits:**

- **Works with your existing setup**: No migration, just add this repo alongside your others
- **Coordinates multi-repo work**: dbt changes + Snowflake DDL + Tableau updates in one project
- **Gets smarter over time**: After 3-5 projects, agents know YOUR specific patterns
- **Team learning**: One person's solutions become everyone's knowledge
- **Any tools work**: Pre-built agents for common tools, create custom for yours

**Who this helps:**
- **Analytics engineers**: Coordinate dbt models + warehouse objects + BI changes
- **Data engineers**: Orchestrate pipeline + ingestion + transformation workflows
- **Data architects**: Design cross-system patterns with documented decisions
- **Solo practitioners**: Structure for managing multiple data projects + build expertise
- **Teams**: Shared workflow, consistent patterns, collective learning, easy onboarding

---

## Core Scripts

Essential scripts (automatically called by slash commands):
- `idea.sh` → Creates GitHub issues (called by `/idea`)
- `start.sh` → Project initialization (called by `/start`)
- `research.sh` → Research helper (called by `/research`)
- `switch.sh` → Context switching (called by `/switch`)
- `finish.sh` → Project completion (called by `/complete`)
- `work-init.sh` → Project setup (called by start.sh)
- `setup-worktrees.sh` → VS Code integration (called by `/setup-worktrees`)
- `pull-all-repos.sh` → Sync multiple repos
- `get-repo-owner.sh` → Helper utility
- `idea.sh` → GitHub issue creation utility

---

## Project Structure

When you `/start` a project, the following structure is created:
```
projects/active/feature-project-name/
├── README.md      # Navigation hub
├── spec.md        # Requirements from GitHub issue
├── context.md     # Dynamic state tracking
└── tasks/         # Agent coordination
    ├── current-task.md
    └── [tool]-findings.md
```

**Note:** The `projects/` directory is created on-demand. After cleanup, it doesn't exist until your first `/start` command.

When completed with `/complete`, projects are archived to:
```
projects/completed/YYYY-MM/[project-name]/
```

---

## Memory System

The Claude Analytics Framework includes a sophisticated memory system that learns from your work:

### Automatic Pattern Extraction
When you `/complete` a project, the system automatically:
- Extracts reusable patterns from agent findings
- Organizes by role and specialist agent
- Makes patterns available for future projects

### Pattern Markers
Use these markers in `tasks/[tool]-findings.md` for automatic extraction:
```markdown
PATTERN: [Description of reusable pattern]
SOLUTION: [Specific solution that worked]
ERROR-FIX: [Error message] -> [Fix that resolved it]
ARCHITECTURE: [System design pattern]
INTEGRATION: [Cross-system coordination approach]
```

### Knowledge Structure
```
.claude/
├── rules/                      # Simple conventions & patterns (auto-loaded)
├── skills/
│   ├── reference-knowledge/   # Deep knowledge for agents (user-invocable: false)
│   └── workflows/             # Procedural automation
└── agents/                     # Agent definitions
```

**Result:** Every project makes your AI assistant smarter.

---

## Documentation

- `CLAUDE.md` - Project instructions for Claude
- `knowledge/da-agent-hub/` - Platform documentation organized by ADLC phase:
  - `planning/` - Idea management and strategic planning
  - `development/` - Local development and agent coordination
  - `operations/` - Automated operations and troubleshooting
  - `architecture/` - System design and agent capabilities
- `.claude/agents/` - Agent definitions and prompts

**Entry Point:** Start with `knowledge/da-agent-hub/README.md` for comprehensive documentation.

---

## Troubleshooting

### "Permission denied" on scripts
```bash
chmod +x scripts/*.sh
```

### "Command not found: claude"
You need to install Claude Code first. Follow the [official installation guide](https://docs.claude.com/en/docs/claude-code/installation).

See the [Claude Code docs](https://docs.claude.com/en/docs/claude-code) for Windows installation.

### "gh: command not found"
Install GitHub CLI:
```bash
# macOS
brew install gh

# Linux/Windows
# See: https://github.com/cli/cli#installation
```

### "Repository not found" or GitHub authentication issues
```bash
# Authenticate with GitHub CLI
gh auth login

# Verify you have access to your repository
gh repo view dylpickledev/claude-analytics-framework
```

### Setup script fails or MCP not working
```bash
# Verify prerequisites
claude --version    # Should show Claude Code version
gh --version        # Should show GitHub CLI version
node --version      # Should show Node.js version (if using MCP)

# Re-run setup
./setup.sh

# Check MCP configuration (if using MCP)
cat ~/.config/Claude/claude_desktop_config.json
```

---

## Git Workflow

**Protected branches:** Never push directly to main/master/production
- Always create feature branch
- All code changes require PR workflow
- Use commands: `/start` creates branch, `/complete` guides PR creation

**Multi-repo support:**
- Smart context resolution for GitHub operations
- Automatic owner/repo detection
- Cross-repo coordination for complex changes

---

## Creating Custom Agents

The system includes templates for creating new agents:

### Role Agent Template
Copy `.claude/agents/roles/role-template.md` when creating agents that:
- Handle 80% of domain work independently
- Delegate to specialists for edge cases
- Have broad domain expertise

### Specialist Agent Template
Copy `.claude/agents/specialists/specialist-template.md` when creating agents that:
- Provide deep expertise in specific tools/domains
- Are consulted by role agents for complex cases
- May have MCP tool integrations

See `knowledge/da-agent-hub/development/agent-development.md` for detailed guidance.

---

## Advanced Features

### VS Code Worktree Integration
Seamless branch switching with dedicated VS Code windows:
```bash
claude /setup-worktrees  # One-time setup
claude /start 123        # Opens new VS Code window
claude /switch          # Switches VS Code windows
```

See `knowledge/da-agent-hub/development/vscode-worktree-integration.md` for details.

### Multi-Repository Synchronization
Keep all your data stack repos in sync:
```bash
./scripts/pull-all-repos.sh
# Updates: dbt_cloud, snowflake utilities, tableau configs, etc.
```

### Conversation Pause/Resume
Save and resume Claude conversations:
```bash
claude /pause "Working on customer analytics dashboard optimization"
# Later...
claude "Resume work on customer analytics"
```

---

## Continuous Improvement

### Learning from Projects
Every completed project contributes to the system:
- Agent capabilities enhanced with new patterns
- Knowledge base expanded with proven solutions
- Specialist expertise refined with production experience

### Improvement PR Workflow
When completing projects, the system recommends:
- Agent updates for high-impact patterns
- Knowledge documentation for recurring topics
- Process improvements for workflow optimization

**Example:**
```bash
claude /complete feature-customer-analytics
# → Suggests: "Create improvement PR for analytics-engineer-role
#    with customer metric patterns?"
```

---

## How Teams Iteratively Improve with This

**The self-improving loop:**

```
Project 1: "Build customer dashboard"
  ↓ Use basic dbt-expert agent
  ↓ Complete project with /complete
  ✅ Extracts: "Incremental model pattern for customer_dim table"

Project 2: "Add customer churn metrics"
  ↓ Agent now knows your customer_dim pattern
  ↓ Suggests consistent approach
  ↓ Complete with /complete
  ✅ Extracts: "Churn calculation logic + dbt test pattern"

Project 3: "Optimize slow customer models"
  ↓ Agent knows your patterns + previous optimizations
  ↓ Suggests specific improvements for YOUR models
  ✅ Extracts: "Performance patterns for customer analytics"

Future projects: Agent is now an expert in YOUR customer analytics approach
```

**What gets captured and improved:**

1. **Tool-specific patterns** (stored in `.claude/agents/specialists/`)
   - dbt model structures you use
   - SQL optimization patterns that work in your warehouse
   - BI dashboard layouts that match your standards
   - Pipeline orchestration patterns

2. **Cross-system workflows** (stored in `.claude/skills/reference-knowledge/`)
   - How you coordinate dbt + Snowflake + Tableau changes
   - Testing strategies across your stack
   - Deployment procedures
   - Troubleshooting approaches

3. **Team knowledge** (stored in `knowledge/`)
   - Architecture decisions and why
   - Data model documentation
   - Integration patterns
   - Lessons learned from incidents

**How teams benefit:**

- **Onboarding**: New team members get agents that know your patterns
- **Consistency**: Everyone's AI suggests the same proven approaches
- **Documentation**: Knowledge captured automatically, not as separate task
- **Continuous improvement**: Each project makes the next one faster
- **Collective learning**: One person's solution becomes team knowledge

**The improvement workflow:**

```bash
# After completing a project
claude /complete feature-customer-analytics
# Output:
#   ✅ Extracted 3 new patterns to dbt-expert
#   💡 Suggestion: Update analytics-engineer-role with customer modeling patterns?

# Review project documentation in projects/active/customer-analytics/

# Decide: Extract to permanent knowledge OR archive
# Option A: Extract to .claude/skills/reference-knowledge/ for reusable patterns
# Option B: Archive in projects/archive/ for historical reference

# Update agent (if pattern is valuable long-term)
claude "Add the customer_dim incremental pattern to dbt-expert agent"
# Agent now has this pattern permanently

# Commit improvements back to the framework repo
git add .claude/agents/specialists/dbt-expert.md
git commit -m "feat: Add customer dimension modeling patterns to dbt-expert"
# Your team's agents get smarter
```

**Example: Improving dbt knowledge over time**

```markdown
<!-- .claude/agents/specialists/dbt-expert.md - Evolution over time -->

# Initial setup (Day 1):
- Generic dbt best practices
- Common incremental strategies
- Standard testing patterns

# After 5 projects (Month 1):
+ Your specific dbt project structure
+ Custom macro patterns you use
+ Your incremental model conventions
+ Tests that matter for YOUR data quality

# After 20 projects (Month 3):
+ Performance optimization patterns for YOUR warehouse
+ Edge cases and fixes from production incidents
+ Integration patterns with YOUR BI tools
+ Deployment procedures for YOUR CI/CD pipeline

# Result: dbt-expert now = Generic dbt knowledge + YOUR team's expertise
```

**This works for ANY tool:**
- Start with generic agent or create custom one
- Use ADLC workflow (`/start` → work → `/complete`)
- Framework extracts patterns automatically
- Agents improve with each completed project
- No tool is "unsupported" - you just start with a blank slate and build expertise

---

## How It Works (Behind the Scenes)

**Role-based agents (80/20 pattern):**
- Role agents (analytics-engineer, data-engineer, architect) handle most work
- They delegate to specialists (dbt-expert, snowflake-expert) for complex cases
- Minimizes token usage while maintaining quality

**Dynamic setup:**
- Setup script asks about YOUR tools
- Creates only relevant specialist agents
- Offers to build custom agents for tools not in library
- Saves config to `.claude/config/tech-stack.json`

**MCP integration (optional):**
- Connects Claude to your real systems
- Setup guides credential collection
- Agents query actual data instead of guessing
- You control what systems to connect

**Memory system:**
- Completed projects automatically extracted to pattern library
- Agents learn from your work over time
- Future projects benefit from past learnings
- Pattern markers in task files trigger extraction
- Recent patterns (30 days) vs permanent agent knowledge

---

## Common Questions

**Q: Do I need to know how to code?**
A: Basic comfort with command line and Git helps. The AI agents write code for you, but you should understand what they're doing.

**Q: What if my tool isn't supported?**
A: Setup offers to create a custom specialist agent from a template. You fill in tool-specific knowledge, and the agent works like the built-in ones.

**Q: Is MCP required?**
A: No! MCP is optional. The framework works fine without it - you just get more generic AI advice instead of insights from your live systems.

**Q: Can I use this without GitHub?**
A: Technically yes, but you'll lose issue tracking and some commands. Git is required (for branches/worktrees).

**Q: Does this work with Claude Desktop or just Claude Code CLI?**
A: Primarily designed for Claude Code CLI. MCP servers can be configured for Claude Desktop, but the slash commands are Claude Code specific.

**Q: How is this different from just using Claude Code normally?**
A: Structure + Learning. This is a meta-repository that orchestrates work across your existing repos (dbt, pipelines, BI, etc.). Instead of ad-hoc conversations scattered across your data stack, you get organized projects that coordinate multi-repo changes, agents that learn YOUR patterns, and automatic knowledge capture. Think: mission control for your data work.

**Q: Do I need to change how I organize my existing repos?**
A: No! This sits alongside your existing repositories. Your dbt project stays in its repo, your Tableau dashboards in theirs, etc. This framework just provides coordination and AI guidance ACROSS those repos.

**Q: Will this work with my team?**
A: Yes - projects create feature branches, use GitHub issues for tracking, and support PR workflow. Each team member runs setup for their own agent configuration.

**Q: What happens to my data?**
A: Nothing leaves your machine except normal Claude API calls. MCP servers run locally and access your systems with credentials YOU provide.

---

## License

MIT License - See LICENSE file

---

## Credits

Built for data/analytics engineers who want AI that understands their modern data stack.

**Inspired by:**
- [dbt Analytics Development Lifecycle](https://www.getdbt.com/analytics-engineering/transformation/)
- [Anthropic's Claude Code](https://docs.claude.com/en/docs/claude-code)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)

---

## Get Started

```bash
# 1. Install Claude Code first (if you haven't)
# https://docs.claude.com/en/docs/claude-code/installation

# 2. Clone and setup
git clone https://github.com/dylpickledev/claude-analytics-framework.git
cd claude-analytics-framework
./setup.sh

# Start your first project
claude /start "your first idea"
```

**Questions?** Open an issue or check the [documentation](knowledge/da-agent-hub/README.md)
