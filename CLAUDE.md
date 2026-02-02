don't look at the full .env file. Only search for the var names up to the equals sign.

# Claude Analytics Framework: AI-Powered Analytics Development

## Quick Start (First Time Setup)

### 1. Configure MCP for dbt Cloud Access

**IMPORTANT**: MCP (Model Context Protocol) integration with dbt Cloud is required for Claude Analytics Framework to work.

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your credentials
# - Get API token: https://cloud.getdbt.com/settings/tokens
# - Get Account ID from URL: https://cloud.getdbt.com/accounts/<ID>

# Validate configuration
./scripts/validate-mcp.sh
```

### 2. Restart Claude Code (REQUIRED)

**CRITICAL**: MCP servers only load when Claude Code starts.

1. Exit Claude Code completely (Cmd+Q on Mac, or kill the process)
2. Restart Claude Code in this directory
3. Verify MCP is loaded

### 3. Verify MCP is Working

```bash
# Check MCP servers loaded
claude /mcp
# Should show: dbt - dbt Cloud integration

# Test it
claude "List my dbt Cloud jobs"
```

### 4. Run Setup Wizard (Optional)

```bash
claude /setup
# Customizes Claude Analytics Framework for your specific data stack and role
```

**Troubleshooting**: If you encounter issues, see `docs/troubleshooting-mcp.md` or ask the onboarding-agent:
```bash
claude "I need help with Claude Analytics Framework setup" --agent onboarding-agent
```

---

## Quick Reference

**Security**: See `.claude/rules/git-workflow-patterns.md` for protected branch rules
**Testing**: See `.claude/skills/reference-knowledge/testing-patterns/SKILL.md` for ADLC testing framework
**Cross-System Analysis**: See `.claude/skills/reference-knowledge/cross-system-analysis-patterns/SKILL.md` for multi-tool coordination

### Mandatory Workflow (CRITICAL - Never Violate)
1. **ALWAYS create feature branch** before making any code changes
2. **ALWAYS create Pull Request** for code review and approval
3. **NEVER push directly** to protected branches
4. **NEVER merge without approval** (except for da-agent-hub documentation updates)

## Three-Layer Architecture

```
💡 LAYER 1: PLAN → Ideation & strategic planning with AI organization
🔧 LAYER 2: DEVELOP + TEST + DEPLOY → Local development with specialist agents
🤖 LAYER 3: OPERATE + OBSERVE + DISCOVER + ANALYZE → Automated operations
```

## Simplified Workflow Commands

### Essential Commands (Use Slash Commands)
1. **`/idea "[idea]"`** → Quick idea capture (creates GitHub issues)
2. **`/research [text|issue#]`** → Deep exploration and analysis (pre-capture or issue analysis)
3. **`/start [issue#|"text"]`** → Begin development (from issue OR creates issue from text + starts)
4. **`/switch [optional-branch]`** → Zero-loss context switching with automated backup
5. **`/complete [project]`** → Complete and archive projects (closes GitHub issue)

### Support Commands
6. **`/pause [description]`** → Save conversation context for seamless resumption

**Note**: For roadmap planning and prioritization, use GitHub's native issue management (labels, milestones, projects).

### Deprecated (Still Work, But Use New Names)
- **`/build`** → Use `/start` instead

### Underlying Scripts (Called by Slash Commands)
- `/idea` → `./scripts/idea.sh`
- `/research` → `./scripts/research.sh`
- `/start` → `./scripts/start.sh`
- `/switch` → `./scripts/switch.sh`
- `/complete` → `./scripts/finish.sh`
- `/pause` → (Claude-native, no script)

**Note**: Prefer slash commands for better Claude integration. Scripts can be run directly if needed.

### Repository Management (Git Submodules)

External repositories (knowledge bases, data stack repos) are managed as **git submodules** for version control and collaboration.

**Quick Commands**:
- **`./scripts/setup-submodules.sh`** → Initialize all submodules (first time setup)
- **`./scripts/pull-all-repos.sh`** → Update all submodules to latest versions
- **`git submodule update --remote`** → Standard git command to update all
- **`git submodule status`** → Check current submodule commits

**Configuration**: Edit `config/repositories.json` to add/remove submodules

**Full Documentation**: See `docs/git-submodules-workflow.md` for complete workflow guide

### GitHub Issues Integration
All ideas are managed as GitHub issues with 'idea' label:
- **View all ideas**: `gh issue list --label idea --state open`
- **Filter by category**: `gh issue list --label idea --label bi-analytics`
- **Search ideas**: `gh issue list --label idea --search "dashboard"`
- **Track progress**: Issues automatically labeled 'in-progress' when built

## Project File Structure

```
projects/active/<project-name>/
├── README.md           # Navigation hub with quick links and progress
├── spec.md            # Project specification (stable requirements)
├── context.md         # Working context (dynamic state tracking)
└── tasks/             # Agent coordination directory
    ├── current-task.md     # Current agent assignments
    └── <tool>-findings.md  # Detailed agent findings
```

**File Purposes**:
- **README.md**: Entry point for navigation, progress summary, key decisions
- **spec.md**: Stable project requirements, end goals, implementation plan, success criteria
- **context.md**: Dynamic state tracking - branches, PRs, blockers, current focus
- **tasks/**: Agent coordination - task assignments and detailed findings

## Role-Based Agent System

### Agent Creation Guidelines

**ALWAYS use templates when creating new agents**:
- **New role agent**: Copy `.claude/agents/roles/role-template.md`
- **New specialist agent**: Copy `.claude/agents/specialists/specialist-template.md`

Templates encode correct architecture patterns:
- Roles delegate to specialists (80% independent, 20% consultation)
- Specialists use MCP tools + expertise (correctness-first)
- Both include quality standards, validation protocols, /complete integration

### Primary Agents (Use These First - Handle 80% Independently)
**Analytics Engineer** (`analytics-engineer-role`) - Owns transformation layer (dbt + Snowflake + BI data)
- SQL transformations, data modeling, performance optimization
- Business logic implementation, metrics, semantic layer
- Delegates to dbt-expert and snowflake-expert for complex cases

**Data Engineer** (`data-engineer-role`) - Owns ingestion layer (Orchestra + dlthub + Prefect + Airbyte)
- Pipeline setup and orchestration (batch AND streaming)
- Source system integration, data quality at ingestion
- Chooses right tool (dlthub vs Prefect) based on requirements
- Delegates to dlthub-expert for complex ingestion patterns

**Data Architect** (`data-architect-role`) - Strategic platform decisions and system design
- Architecture patterns, technology selection, cross-system integration
- Platform roadmap, governance, standards
- Coordinates with all specialists for system-level decisions

### Tool Specialists (Consultation Layer - 20% Edge Cases)
Role agents delegate to specialists who combine deep domain expertise with MCP tool access for informed, validated recommendations.

**Data Platform (Available)**:
- `dbt-expert`: SQL transformations, dbt patterns (MCP-enabled for dbt Cloud API)
- `snowflake-expert`: Warehouse optimization, cost analysis (MCP-enabled for Snowflake)
- `dlthub-expert`: Data ingestion patterns for dlthub pipelines
- `tableau-expert`: BI optimization and dashboard performance

**Cross-Functional (Available)**:
- `github-sleuth-expert`: Repository analysis, issue investigation (MCP-enabled for GitHub)

**Note**: Other specialists (aws-expert, business-context, documentation-expert, etc.) were removed in cleanup. Role agents now handle most work directly or can request specialist agent creation when needed.

**Pattern**: Role agents delegate when confidence <0.60 OR domain expertise needed
**Specialists**: Use MCP tools + expertise to provide validated, correct recommendations
**Correctness > Speed**: 15x token cost justified by significantly better outcomes (per Anthropic research)

### MCP Tool Execution Pattern

**Specialist agents provide MCP tool recommendations, main Claude executes them**:

1. **Specialist creates recommendation**:
   ```markdown
   ### RECOMMENDED MCP TOOL EXECUTION
   **Tool**: snowflake_query_manager
   **Query**: SELECT * FROM TASK_HISTORY WHERE STATE = 'FAILED'
   **Expected Result**: List of failed tasks
   **Fallback**: Direct Python execution if MCP unavailable
   ```

2. **Main Claude executes**:
   - Reads specialist recommendation
   - Executes MCP tool call or fallback approach
   - Returns results to specialist (if needed for analysis)
   - Implements specialist recommendations

3. **Why this pattern**:
   - Specialists focus on expertise (what to do, which tools to use)
   - Main Claude handles execution (MCP calls, Python scripts, Bash commands)
   - Specialists can't execute directly (research-only by design)
   - Clear separation of concerns: planning vs execution

*See `.claude/skills/reference-knowledge/cross-system-analysis-patterns/SKILL.md` for detailed agent coordination*

## Skills System: Workflow Automation

### What are Skills?

**Skills** are reusable workflows that automate repetitive procedures through organized folders containing instructions, scripts, and resources. Skills complement the agent system by handling procedural automation, while agents provide domain expertise.

**Location**: `.claude/skills/[skill-name]/skill.md`
**Invocation**: Use the Skill tool to execute skill workflows

### When to Use Skills vs Agents vs Patterns

**Use Skills for**:
- ✅ Repeatable multi-step workflows (project setup, PR generation)
- ✅ Tool orchestration (coordinating Read, Write, Bash, Task tools)
- ✅ Template-driven document generation
- ✅ Process automation that you've done 3+ times manually

**Use Agents for**:
- ✅ Domain expertise and problem-solving (dbt optimization, AWS architecture)
- ✅ MCP-enhanced analysis (real-time data investigation)
- ✅ Complex decisions requiring research and recommendations
- ✅ Specialist consultation when confidence <0.60

**Use Patterns for**:
- ✅ Quick reference documentation (git workflows, delegation protocols)
- ✅ Decision frameworks ("when to use X vs Y")
- ✅ Production-validated solutions from completed projects
- ✅ Best practices and technical implementation patterns

**Complete Guide**: See `.claude/skills/reference-knowledge/knowledge-organization-strategy/SKILL.md` for comprehensive decision framework

### Current Skill Status

**Implementation Status**: ✅ ACTIVE (4 high-value skills deployed)

**Available Skills**:
1. **project-setup** (`.claude/skills/project-setup/skill.md`)
   - Initialize new project structure with README, spec.md, context.md
   - Create git branch with proper naming conventions
   - Generate task tracking structure
   - **Saves**: 10-15 minutes per project setup

2. **pr-description-generator** (`.claude/skills/pr-description-generator/skill.md`)
   - Generate comprehensive PR descriptions from project context
   - Analyze git changes and create structured summary
   - Include test plan and quality checklist
   - **Saves**: 5-10 minutes per PR

3. **dbt-model-scaffolder** (`.claude/skills/dbt-model-scaffolder/skill.md`)
   - Generate dbt model boilerplate (staging, intermediate, mart)
   - Create schema.yml with tests and documentation
   - Follow dbt style guide and best practices
   - **Saves**: 15-20 minutes per model

4. **documentation-validator** (`.claude/skills/documentation-validator/skill.md`)
   - Validate documentation completeness before project closure
   - Check required files and sections exist
   - Verify internal links work
   - Generate comprehensive validation report
   - **Used by**: `/complete` command to ensure quality

**How to Use Skills**:
```
# Skills are invoked automatically when appropriate, or manually:
"Set up new project for [name]"  → project-setup skill
"Generate PR description"         → pr-description-generator skill
"Create dbt staging model"        → dbt-model-scaffolder skill
"Validate documentation"          → documentation-validator skill
```

**Integration**: Skills work alongside agents and reference patterns for comprehensive automation + expertise

### Skills + Agents + Patterns Architecture

```
Skills (.claude/skills/) - "HOW to execute workflows"
   ↓ Uses
Agents (.claude/agents/) - "WHO to consult for expertise"
   ↓ References
Patterns (.claude/rules/ + .claude/skills/reference-knowledge/) - "WHAT solutions work"
```

**Example Flow**:
```
User: "Set up new dbt optimization project"
  ↓
Skill: project-setup
  - Creates project directories
  - Invokes analytics-engineer-role agent for technical approach
  - Generates README using agent recommendations + pattern templates
  - Creates git branch with appropriate naming
  ↓
Result: Structured project with expert guidance in 30 seconds
```

## Context Management & Memory System

### Context Discovery Protocol
When starting work on a new task, check these locations for relevant context:
1. **Recent Projects** (`projects/archive/`) → Review similar solutions from completed work
2. **Task Context** (`.claude/tasks/`) → Check for unfinished work
3. **Project Templates** (`.claude/skills/project-setup/templates/`) → Use appropriate template

**Note**: `.claude/rules/` files are automatically loaded - no manual reading required.

### Pattern Documentation Protocol
Use these markers in `.claude/tasks/*/findings.md` for automatic extraction:

```markdown
PATTERN: [Description of reusable pattern]
SOLUTION: [Specific solution that worked]
ERROR-FIX: [Error message] -> [Fix that resolved it]
ARCHITECTURE: [System design pattern]
INTEGRATION: [Cross-system coordination approach]
```

## Critical Rules

### Security & Git Workflow
**CRITICAL**: NEVER commit directly to protected branches (main, master, production, prod)
- Always create feature branch first
- All code changes require PR workflow
- Exception: da-agent-hub documentation-only changes

*See `.claude/rules/git-workflow-patterns.md` for complete git workflow patterns*

### Sandbox Principle
**CRITICAL**: `projects/active/<project-name>/` functions as an **isolated sandbox**

**All work stays in project folder until explicit deployment**:
- Analysis, code, documentation, testing → `projects/active/<project>/`
- Never write to production repos during active development
- Read-only access to production for comparison only

**Deploy only when user explicitly requests**:
- "Deploy this to [repo]"
- "Push to production"
- "Create PR in [repo]"
- Project finalized with `/finish` command

### Development Best Practices
- **Always start from up-to-date main branch**: Run `git checkout main && git pull origin main` before starting any work
- **DO NOT MOVE FORWARD until you've fixed a problem**: If blocked on step 1, stop and fix completely before step 2
- **Git branches**: Prefix with `feature/` or `fix/`
- **Use subagents**: Optimize context window with task delegation
- **Preserve context links**: Maintain connections between ideas → projects → operations

## Task vs Project Classification

### Use Project Structure When:
- Multi-day efforts spanning multiple work sessions
- Cross-repository coordination (dbt + snowflake + tableau)
- Research and analysis informing multiple decisions
- Collaborative work with team members/reviewers
- Knowledge preservation needed for future reference
- Complex troubleshooting requiring systematic investigation

### Use Simple Task Execution When:
- Quick fixes (typos, small config changes, single-file updates)
- Immediate responses to questions or information requests
- One-off scripts or utilities
- Documentation updates without research
- Status checks or system diagnostics
- Simple file operations or code formatting

## Context Clarity & File Reference System

### Visual File Reference Indicators
- **📁 PROJECT**: Working files in `projects/active/<project-name>/`
- **📦 REPO**: Source repository files (original/production versions)
- **🎯 DEPLOY**: Deployment target locations

### Context Declaration Protocol
Before analysis, declare context assumptions:

```
📍 Context Check:
- Working File: 📁 PROJECT projects/active/feature-x/app.py
- Reference: 📦 REPO ../original-repo/app.py
- Deploy Target: 🎯 DEPLOY production-repo/

If you want different sources, please redirect me.
```

## Smart Repository Context Resolution

### Automatic Owner/Repo Detection
When working with GitHub repositories, use smart context resolution to avoid specifying owner repeatedly:

```bash
# Resolve repository context from config/repositories.json
python3 scripts/resolve-repo-context.py dbt_cloud
# Output: your-org dbt_cloud

# Use resolved context in GitHub MCP operations
mcp__github__list_issues owner="your-org" repo="dbt_cloud"
```

### Available Commands
- `python3 scripts/resolve-repo-context.py <repo_name>` - Get owner and repo
- `python3 scripts/resolve-repo-context.py --json <repo_name>` - Get full context as JSON
- `python3 scripts/resolve-repo-context.py --list` - List all resolvable repositories
- `./scripts/get-repo-owner.sh <repo_name>` - Get just the owner (bash helper)

### Agent Integration
All specialist agents working with GitHub should:
1. Resolve repository context before GitHub MCP calls
2. Use explicit owner/repo parameters in all GitHub MCP operations
3. Reference pattern documentation: `.claude/rules/github-repo-context-resolution.md`

**Benefit**: Eliminates cognitive overhead of remembering "your-org" for every GitHub operation while maintaining explicit, correct MCP calls.

## Knowledge Repository Structure

### Team Documentation
`knowledge/team_documentation/` - Analytics team structured documentation (data architecture, integrations, products, templates)

### Team Knowledge Vault
`knowledge/team_knowledge_vault/` - Analytics team Obsidian vault for raw notes and unrefined ideas before ADLC planning

### Claude Analytics Framework Platform Documentation
`knowledge/da-agent-hub/` - Complete platform documentation organized by ADLC phases:
- **Planning Layer** (`planning/`): Idea management and strategic planning
- **Development Layer** (`development/`): Local development and agent coordination
- **Operations Layer** (`operations/`): Automated operations and cross-repo coordination

### Production Applications Documentation
`knowledge/applications/` - Comprehensive documentation for deployed applications

**Three-Tier Documentation Architecture**:

**Tier 1: Repository README** (Lightweight, Developer-Focused)
- **Location**: `<repo>/README.md` (e.g., `react-customer-dashboard/README.md`)
- **Purpose**: Get developers productive fast
- **Contains**: App purpose, local dev setup, npm commands, link to knowledge base
- **Audience**: Human developers, AI doing code-level work
- **Size**: < 200 lines

**Tier 2: Knowledge Base** (Comprehensive, Cross-System)
- **Location**: `knowledge/applications/<app-name>/`
- **Purpose**: Complete reference for deployment, operations, architecture
- **Structure**:
  - `architecture/` - System design, data flows, infrastructure
  - `deployment/` - Deployment runbooks, Docker builds, AWS config
  - `operations/` - Monitoring, troubleshooting, incident response
- **Audience**: AI agents coordinating deployments/operations
- **Size**: Unlimited - source of truth

**Tier 3: Agent Pattern Index** (Pointers + Confidence)
- **Location**: `.claude/agents/specialists/<agent>.md` (e.g., `aws-expert.md`)
- **Purpose**: Help agents find proven patterns quickly
- **Contains**: Pattern name, confidence score, link to Tier 2, when to use
- **Audience**: AI agents deciding what pattern to apply
- **Size**: Index only, not full content

**Key Principles**:
- **Single Source of Truth**: Each piece of info lives in ONE canonical location
- **Cross-Reference, Don't Duplicate**: Use links instead of copying content
- **Task-Aware Discovery**: Agents read what they need, when they need it
- **Layer-Appropriate Detail**: Match detail level to audience needs

**Example Flow**:
```
Agent Task: "Deploy Customer Dashboard update"
1. Check ui-ux-developer-role.md → Known Applications → Find knowledge/applications/customer-dashboard/
2. Read knowledge/applications/customer-dashboard/deployment/production-deploy.md → Complete runbook
3. Delegate AWS work → aws-expert reads same knowledge base docs + applies patterns
```

## Repository Branch Structures

**dbt_cloud**: master (prod), dbt_dw (staging) - Branch from dbt_dw
**dbt_errors_to_issues**: main (prod) - Branch directly from main
**roy_kent**: master (prod) - Branch directly from master
**sherlock**: main (prod) - Branch directly from main

*See `.claude/rules/git-workflow-patterns.md` for detailed workflows*

## ADLC Continuous Improvement Strategy

### During Project Completion
Actively identify and capture:
- **Agent Capability Enhancements**: New tool patterns, integration strategies, troubleshooting insights
- **Agent File Updates**: Novel patterns for specialist agents (`.claude/agents/`)
- **Knowledge Base Enhancement**: System architecture patterns, process improvements (`knowledge/`)

### Knowledge Extraction Locations

When completing projects, extract learnings to appropriate locations based on content type:

**Production Application Knowledge** → `knowledge/applications/<app-name>/`
- **When**: Deploying new apps or major app updates
- **Structure**: Three-tier pattern (Tier 2 - comprehensive docs)
  - `architecture/` - System design, data flows, infrastructure details
  - `deployment/` - Complete deployment runbooks, Docker builds, AWS configuration
  - `operations/` - Monitoring, troubleshooting guides, incident response
- **Examples**: ALB OIDC authentication, ECS deployment patterns, multi-service Docker
- **Updates Required**:
  1. Create/update knowledge base docs for the application
  2. Update agent pattern index (e.g., aws-expert.md with confidence scores)
  3. Add to "Known Applications" in relevant role agents (e.g., ui-ux-developer-role.md)
  4. Create lightweight README in actual repo (Tier 1) linking to knowledge base

**Platform/Tool Patterns** → `knowledge/da-agent-hub/`
- **When**: Discovering reusable patterns for ADLC workflow
- **Structure**: Organized by ADLC phase (planning/, development/, operations/)
- **Examples**: Testing frameworks, git workflows, cross-system analysis patterns

**Agent Expertise** → `.claude/agents/specialists/<agent>.md`
- **When**: Validating patterns in production, improving confidence scores
- **Updates**: Add production-validated patterns section, update confidence levels
- **Reference**: Link to knowledge base (Tier 2) for full implementation

**Role Agent Applications** → `.claude/agents/roles/<role>.md`
- **When**: New applications deployed that role will work on
- **Updates**: Add to "Known Applications" section with stack, patterns, key learnings
- **Purpose**: Help agents quickly find context when tasked with app work

### Improvement PR Decision Framework
Create separate improvement PRs for:
- **HIGH IMPACT**: Agent updates benefiting multiple future projects
- **KNOWLEDGE GAPS**: Missing documentation causing repeated research
- **PROCESS OPTIMIZATION**: Workflow improvements with measurable efficiency gains
- **INTEGRATION ENHANCEMENT**: Cross-tool coordination improvements
- **ADLC METHODOLOGY**: Core system workflow refinements

**Examples**:
- "feat: Enhance aws-expert with ALB OIDC production patterns from customer-dashboard deployment"
- "docs: Add React + FastAPI application architecture to knowledge/applications/"
- "feat: Document three-tier documentation pattern for future app deployments"

## Agent Training & Learning System

### Chat Analysis Features
- User-agnostic discovery of Claude conversations
- Privacy-preserving local analysis
- Effectiveness metrics and improvement recommendations
- Integration with `/complete` command for automatic learning extraction

**Usage**: `./scripts/analyze-claude-chats.sh`

**Results**: `knowledge/da-agent-hub/training/analysis-results/` (local only)

### Continuous Learning Loop
```
🔧 PROJECT WORK → 💬 CONVERSATIONS → 📊 ANALYSIS
    ↑                                      ↓
🚀 ENHANCED AGENTS ← 📝 IMPROVEMENT PRs ← 💡 RECOMMENDATIONS
```

## Complete Development Workflow

```
💡 CAPTURE: /idea → GitHub issue creation
    ↓ (Use GitHub for prioritization)
🔬 RESEARCH: /research [text|issue#] → Deep exploration → Feasibility → Technical approach
    ↓ Informed decision-making
🚀 START: /start [issue#|"text"] → project setup → branch creation → specialist agents → development
    ↓ Deploy to production
✅ COMPLETE: /complete → archive → close GitHub issue → next iteration
```

## Additional Resources

**Git Workflows**: `.claude/rules/git-workflow-patterns.md`
**Testing Patterns**: `.claude/skills/reference-knowledge/testing-patterns/SKILL.md`
**Cross-System Analysis**: `.claude/skills/reference-knowledge/cross-system-analysis-patterns/SKILL.md`
**Agent Definitions**: `.claude/agents/`
**Platform Documentation**: `knowledge/da-agent-hub/README.md`
