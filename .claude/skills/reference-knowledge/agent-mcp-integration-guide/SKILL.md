---
name: agent-mcp-integration-guide
description: Complete reference for MCP tool integration across specialist and role agents including server inventory, tool recommendations, and security protocols
user-invocable: false
---

# Agent MCP Integration Guide

**Status**: Production Guide
**Last Updated**: 2025-10-08
**Purpose**: Complete reference for MCP tool integration across specialist and role agents

---

## Overview

This guide documents the complete MCP (Model Context Protocol) integration strategy for DA Agent Hub, ensuring all agents have comprehensive knowledge of their available tools and can make informed recommendations.

### Key Principles

1. **Specialists Recommend → Main Claude Executes → Specialists Analyze**
   - Specialist agents are research-only (cannot execute MCP tools directly)
   - Specialists provide detailed MCP tool recommendations with parameters
   - Main Claude executes the actual MCP tool calls
   - Results returned to specialist for analysis (if needed)

2. **Complete Tool Knowledge**
   - Every specialist knows exactly what MCP tools they have access to
   - Tool capabilities, parameters, limitations documented
   - Confidence scores guide reliability expectations

3. **Tool Selection Frameworks**
   - Clear decision trees for when to use which tool
   - Fallback strategies when MCP unavailable
   - Integration patterns for cross-tool coordination

---

## MCP Server Inventory

### Complete Server List (8/8 Configured)

| Server | Package | Tools | Primary Users | Status |
|--------|---------|-------|---------------|--------|
| **dbt-mcp** | `dbt-mcp` (uvx) | 40+ tools, 7 categories | dbt-expert, analytics-engineer-role | ✅ Connected |
| **snowflake-mcp** | `snowflake-labs-mcp` (uvx) | 26+ tools, 4 categories | snowflake-expert, dbt-expert, analytics-engineer-role | ✅ Connected |
| **aws-api** | `awslabs.aws-api-mcp-server` (uvx) | 3 core tools | aws-expert, frontend-developer-role, data-engineer-role | ✅ Connected |
| **aws-docs** | `awslabs.aws-documentation-mcp-server` (uvx) | 3 documentation tools | aws-expert | ✅ Connected |
| **github** | `@modelcontextprotocol/server-github` (npx) | 28 tools, 4 categories | github-sleuth-expert, documentation-expert, all role agents | ✅ Connected |
| **slack** | `@modelcontextprotocol/server-slack` (npx) | 8 tools | project-manager-role, business-analyst-role, qa-engineer-role | ✅ Connected |
| **filesystem** | `@modelcontextprotocol/server-filesystem` (npx) | 13 tools | github-sleuth-expert, documentation-expert, qa-engineer-role | ✅ Connected |
| **sequential-thinking** | `@modelcontextprotocol/server-sequential-thinking` (npx) | 1 cognitive tool | data-architect-role, qa-engineer-role, business-analyst-role | ✅ Connected |

---

## Specialist Agent MCP Integration

### MCP-Enhanced Specialists (5/5 Complete)

#### 1. dbt-expert
**MCP Access**: dbt-mcp, snowflake-mcp, github-mcp, sequential-thinking-mcp
**Tool Count**: 40+ dbt tools, 26+ Snowflake tools

**Primary Tools**:
- **Discovery API** (5 tools): Model exploration, dependency analysis
- **Semantic Layer** (4 tools): Governed business metrics
- **Administrative API** (7 tools): Job orchestration, monitoring
- **CLI Commands** (8 tools): dbt run, test, build, compile
- **SQL Execution** (3 tools): DISABLED by default for security

**Key Patterns**:
- Model performance optimization: dbt-mcp + snowflake-mcp coordination
- Test failure analysis: Discovery API → Semantic Layer → SQL validation
- Impact analysis: get_model_parents + get_model_children for blast radius

**Confidence**: HIGH (0.92-0.95) for Discovery/Semantic/Admin tools

---

#### 2. snowflake-expert
**MCP Access**: snowflake-mcp, dbt-mcp, sequential-thinking-mcp
**Tool Count**: 26+ Snowflake tools

**Primary Tools**:
- **Object Management** (~10 tools): DDL operations, warehouse management
- **Query Execution** (1 tool): SQL with granular permission controls
- **Semantic Views** (~5 tools): Business metrics layer
- **Cortex AI** (optional): Search, Analyst, Agent capabilities

**Key Patterns**:
- Cost analysis: ACCOUNT_USAGE queries via run_snowflake_query
- Performance optimization: Query profiling + dbt-mcp model analysis
- Warehouse sizing: Utilization metrics → right-sizing recommendations

**Confidence**: HIGH (0.90-0.95) for core operations, MEDIUM (0.70-0.75) for Cortex

---

#### 3. aws-expert
**MCP Access**: aws-api, aws-docs, sequential-thinking-mcp
**Tool Count**: 6 tools across 2 MCP servers

**Primary Tools**:
- **aws-api**: `call_aws` (execute CLI), `suggest_aws_commands` (discover), `get_execution_plan` (experimental)
- **aws-docs**: `read_documentation`, `search_documentation`, `recommend` (related content)

**Key Patterns**:
- Infrastructure inventory: call_aws with READ_OPERATIONS_ONLY
- Documentation currency: Verify with aws-docs before recommending (post-training cutoff)
- Command discovery: suggest_aws_commands → call_aws execution

**Critical Insight**: aws-docs MCP provides **current documentation** (not just training data from January 2025) - essential for service limits, new features, best practices, security, API parameters

**Confidence**: HIGH (0.92) for aws-api, HIGH (0.92-0.95) for aws-docs

---

#### 4. github-sleuth-expert
**MCP Access**: github-mcp, filesystem-mcp, sequential-thinking-mcp
**Tool Count**: 28 GitHub tools, 13 filesystem tools

**Primary Tools**:
- **Issue Management** (6 tools): create, list, get, update, comment, search
- **Pull Request Management** (10 tools): create, review, merge, status, files
- **Repository Management** (9 tools): files, branches, commits, search
- **Search & Discovery** (3 tools): repos, code, users

**Key Patterns**:
- Cross-repo pattern analysis: search_issues across org
- Issue investigation: get_issue → search_issues (similar) → filesystem (code context)
- Repository context resolution: Always resolve owner/repo first

**Known Issues**: get_file_contents missing SHA (use push_files for updates)

**Confidence**: HIGH (0.88-0.95) for all operations except file updates (MEDIUM 0.65-0.70)

---

#### 5. documentation-expert
**MCP Access**: filesystem-mcp, github-mcp, dbt-mcp
**Tool Count**: 13 filesystem tools, 28 GitHub tools

**Primary Tools**:
- **Filesystem Read** (5 tools): read_text_file, read_multiple_files, get_file_info
- **Filesystem Write** (2 tools): write_file, edit_file (with dry run)
- **Filesystem Search** (3 tools): search_files, directory_tree, list_directory
- **GitHub Documentation**: push_files (batch updates), get_file_contents, search_code

**Key Patterns**:
- Knowledge base management: filesystem-mcp for knowledge/ directory
- Repository documentation: github-mcp for README, CONTRIBUTING, docs/
- Documentation quality: dbt-mcp for model documentation analysis

**Confidence**: HIGH (0.90-0.95) for filesystem, HIGH (0.85-0.88) for GitHub docs

---

## MCP Tool Recommendation Pattern

### Standard Recommendation Format

When specialist agents provide MCP tool recommendations to main Claude:

```markdown
### RECOMMENDED MCP TOOL EXECUTION

**Tool**: mcp__<server>__<tool_name>
**Parameters**:
  - parameter1: "value1"
  - parameter2: value2
  - parameter3: [list, of, values]
**Expected Result**: Description of what this should return
**Success Criteria**: How to validate the operation succeeded
**Fallback**: Alternative approach if MCP unavailable
**Confidence**: HIGH (0.95) - Production-validated pattern
```

### Example Recommendations

**dbt-expert recommendation**:
```markdown
### RECOMMENDED MCP TOOL EXECUTION

**Tool**: mcp__dbt-mcp__get_model_details
**Parameters**:
  - model_name: "fct_orders"
**Expected Result**: Compiled SQL, column definitions, dependencies
**Success Criteria**: Returns model metadata with all fields populated
**Fallback**: Read compiled SQL from target/ directory if MCP unavailable
**Confidence**: HIGH (0.95) - Core discovery operation
```

**snowflake-expert recommendation**:
```markdown
### RECOMMENDED MCP TOOL EXECUTION

**Tool**: mcp__snowflake-mcp__run_snowflake_query
**Parameters**:
  - statement: "SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY WHERE START_TIME >= DATEADD(day, -7, CURRENT_TIMESTAMP()) ORDER BY CREDITS_USED DESC LIMIT 10"
**Expected Result**: Top 10 warehouses by credit usage (last 7 days)
**Success Criteria**: Query returns warehouse names with credit totals
**Fallback**: Direct snowflake-connector-python if MCP unavailable
**Confidence**: HIGH (0.90) - Standard cost analysis query
```

**aws-expert recommendation**:
```markdown
### RECOMMENDED MCP TOOL EXECUTION

**Tool**: mcp__aws-api__call_aws
**Parameters**:
  - cli_command: "aws ecs describe-services --cluster my-cluster --services my-service --region us-west-2"
**Expected Result**: ECS service configuration and status
**Success Criteria**: Returns service ARN, status, task definition details
**Fallback**: AWS Console if MCP unavailable
**Confidence**: HIGH (0.92) - Standard infrastructure query
```

---

## Confidence Scoring Framework

### Confidence Levels

- **HIGH (0.85-0.95)**: Production-validated, straightforward operations, minimal risk
- **MEDIUM (0.65-0.84)**: Multi-step workflows, workarounds required, some uncertainty
- **LOW (0.40-0.64)**: Experimental features, edge cases, significant limitations
- **RESEARCH NEEDED (<0.40)**: Novel use cases requiring investigation

### Confidence Factors

**Increases Confidence**:
- ✅ Production-validated in real projects
- ✅ Official tool with stable API
- ✅ Clear documentation and examples
- ✅ Security controls in place
- ✅ Known limitations documented

**Decreases Confidence**:
- ❌ Experimental or beta features
- ❌ Known bugs or missing functionality
- ❌ Workarounds required
- ❌ Can modify data without safeguards
- ❌ Limited testing or validation

---

## Security & Authentication Summary

### Authentication by MCP Server

| Server | Auth Method | Credentials | Security Controls |
|--------|-------------|-------------|-------------------|
| **dbt-mcp** | Service Token or PAT | `DBT_TOKEN` env var | SQL execution DISABLED by default |
| **snowflake-mcp** | OAuth/Password/Key Pair | `SNOWFLAKE_PASSWORD` env var | Read-only by default (SELECT, DESCRIBE, USE) |
| **aws-api** | AWS credentials | IAM/SSO/named profiles | READ_OPERATIONS_ONLY=true |
| **aws-docs** | None (public docs) | N/A | No auth required |
| **github** | Personal Access Token | `GITHUB_PERSONAL_ACCESS_TOKEN` | Scopes: repo, read:org, read:project |
| **slack** | Bot Token | `SLACK_BOT_TOKEN` | Scopes: channels:read, chat:write, users:read |
| **filesystem** | Allowed directories | N/A | Whitelist: `/Users/TehFiestyGoat/da-agent-hub` |
| **sequential-thinking** | None (cognitive tool) | N/A | No auth required |

### Security Best Practices

**dbt-mcp**:
- ✅ Keep `DISABLE_SQL=true` unless explicitly needed
- ✅ Use Service Token for read-only operations
- ✅ Only enable PAT for SQL execution users

**snowflake-mcp**:
- ✅ Read-only by default (SELECT, DESCRIBE, USE)
- ✅ Write operations explicitly disabled
- ✅ Password injected at runtime (not in config)
- ✅ Granular SQL permission control via YAML

**aws-api**:
- ✅ `READ_OPERATIONS_ONLY=true` restricts to read-only
- ✅ No shell operators (pipes, redirection, etc.)
- ✅ Absolute paths only
- ✅ Command validation before execution

**github**:
- ✅ Scoped OAuth tokens (minimal required scopes)
- ✅ Rate limit awareness (5000 req/hour, search 30 req/min)
- ✅ Exponential backoff on HTTP 429

**filesystem**:
- ✅ Directory whitelist (da-agent-hub only)
- ✅ Directory traversal prevention
- ✅ No delete capability

---

## Cross-Tool Integration Patterns

### Pattern 1: dbt + Snowflake Coordination

**Use Case**: Optimize slow dbt model

**Workflow**:
1. **dbt-mcp**: Get model details, compiled SQL, dependencies
2. **snowflake-mcp**: Execute query profile analysis
3. **dbt-expert**: Analyze results, design optimization
4. **snowflake-mcp**: Validate optimized query performance
5. **dbt-mcp**: Update model configuration

**Confidence**: HIGH (0.92) - Production-validated pattern

---

### Pattern 2: AWS Infrastructure + Documentation

**Use Case**: Deploy new AWS service

**Workflow**:
1. **aws-docs**: Search for current best practices
2. **aws-docs**: Read specific service documentation
3. **aws-expert**: Design infrastructure based on current docs
4. **aws-api**: Validate existing infrastructure state
5. **aws-expert**: Provide deployment recommendations

**Confidence**: HIGH (0.90) - Documentation currency critical

---

### Pattern 3: GitHub Issue Investigation

**Use Case**: Analyze recurring dbt error across repositories

**Workflow**:
1. **github-mcp**: Search issues across org for error pattern
2. **github-mcp**: Get detailed issue information for matches
3. **filesystem-mcp**: Read local repository code context
4. **dbt-expert** (if dbt-related): Analyze model/test failures
5. **github-sleuth-expert**: Synthesize findings, recommend fix

**Confidence**: HIGH (0.88) - Cross-tool coordination

---

### Pattern 4: Documentation Quality Analysis

**Use Case**: Assess and improve documentation across projects

**Workflow**:
1. **filesystem-mcp**: Search for all .md files in knowledge base
2. **filesystem-mcp**: Read multiple files for pattern analysis
3. **github-mcp**: Search code repos for README files
4. **dbt-mcp**: Analyze dbt model documentation coverage
5. **documentation-expert**: Synthesize quality report, recommend improvements

**Confidence**: HIGH (0.90) - Documentation standards enforcement

---

## Role Agent MCP Access Patterns

### Recommended MCP Access by Role

| Role Agent | Primary MCP Access | Delegation Pattern |
|------------|-------------------|-------------------|
| **analytics-engineer-role** | dbt-mcp, snowflake-mcp | Direct for simple queries, delegate complex to dbt-expert |
| **data-engineer-role** | github-mcp, filesystem-mcp | Direct for pipelines, delegate AWS to aws-expert |
| **data-architect-role** | sequential-thinking-mcp | Delegate tool-specific work to specialists |
| **qa-engineer-role** | filesystem-mcp, sequential-thinking-mcp | Direct for testing, delegate domain work to specialists |
| **business-analyst-role** | slack-mcp, sequential-thinking-mcp | Direct for communication, delegate technical to specialists |
| **project-manager-role** | slack-mcp, github-mcp | Direct for coordination, delegate technical to specialists |
| **frontend-developer-role** | github-mcp | Delegate AWS deployment to aws-expert |
| **bi-developer-role** | dbt-mcp (metrics), snowflake-mcp | Delegate complex analysis to dbt-expert, snowflake-expert |

### Delegation Guidelines

**When role agents should use MCP tools directly**:
- ✅ Simple, straightforward operations within their domain
- ✅ Standard queries with confidence ≥ 0.85
- ✅ Proven patterns from previous successful use
- ✅ Time-sensitive operations requiring immediate action

**When role agents should delegate to specialists**:
- ❌ Complex operations requiring deep domain expertise (confidence <0.60)
- ❌ Cross-system coordination (multiple MCP servers)
- ❌ Novel use cases without established patterns
- ❌ Operations with high risk or business impact
- ❌ Optimization requiring performance analysis

---

## Known Issues & Limitations

### Issue #1: github `get_file_contents` Missing SHA
**Server**: github-mcp
**Impact**: Cannot reliably update files with `create_or_update_file`
**Workaround**: Use `push_files` for batch updates OR `list_commits` to get SHA
**Confidence**: MEDIUM (0.60) - Functional workaround
**Tracking**: https://github.com/github/github-mcp-server/issues/595

### Issue #2: dbt SQL Execution Security
**Server**: dbt-mcp
**Impact**: SQL execution tools can MODIFY data
**Mitigation**: DISABLED by default via `DISABLE_SQL=true`, requires PAT
**Confidence**: MEDIUM (0.65-0.70) when enabled - requires validation
**Recommendation**: Keep disabled unless explicitly needed

### Issue #3: Snowflake Cortex Tools Optional
**Server**: snowflake-mcp
**Impact**: Cortex AI tools require explicit setup in Snowflake
**Mitigation**: Document when Cortex features are available
**Confidence**: MEDIUM (0.70-0.75) - Requires Cortex service configuration

### Issue #4: aws-api READ_OPERATIONS_ONLY
**Server**: aws-api
**Impact**: Cannot modify infrastructure via MCP (read-only mode)
**Mitigation**: Design pattern - specialists recommend, human implements
**Confidence**: Appropriate restriction - aws-expert provides guidance, not execution

---

## Future MCP Integration Opportunities

### High-Priority Additions

1. **tableau-mcp** (if available)
   - BI dashboard metadata
   - Data source analysis
   - Performance optimization
   - **Primary User**: tableau-expert, bi-developer-role

2. **prefect-mcp** (custom integration)
   - Flow orchestration
   - Deployment management
   - Run monitoring
   - **Primary User**: prefect-expert, data-engineer-role

3. **orchestra-mcp** (custom integration)
   - Pipeline orchestration
   - Workflow dependencies
   - Resource management
   - **Primary User**: orchestra-expert, data-engineer-role

### Medium-Priority Additions

4. **dbt Cloud Admin API** (enhanced dbt-mcp)
   - Environment management
   - User/group administration
   - Account-level configuration
   - **Primary User**: dba-role, data-architect-role

5. **Confluence MCP** (knowledge management)
   - Team documentation
   - Meeting notes
   - Runbook management
   - **Primary User**: documentation-expert, business-analyst-role

---

## Maintenance & Updates

### When to Update This Guide

- New MCP server added to `.mcp.json`
- Specialist agent MCP tools updated
- New integration patterns validated in production
- Known issues resolved or new issues discovered
- Confidence scores change based on production validation

### Update Protocol

1. **Research**: Comprehensive tool inventory and documentation
2. **Document**: Create detailed capability reference
3. **Integrate**: Update specialist agent files with MCP tools section
4. **Test**: Validate patterns with actual MCP calls
5. **Update Guide**: Add to this consolidated reference
6. **Communicate**: Update team on new capabilities

### Verification Checklist

- [ ] All MCP servers documented with complete tool inventory
- [ ] Specialist agents updated with their MCP access
- [ ] Confidence scores assigned based on validation
- [ ] Known issues documented with workarounds
- [ ] Integration patterns validated in production
- [ ] Authentication and security documented
- [ ] Role agent delegation patterns defined

---

## Quick Reference

### MCP Server Status Check
```bash
claude mcp list
```

### Test MCP Tool Availability
```bash
# Test dbt-mcp
mcp__dbt-mcp__list_metrics

# Test snowflake-mcp
mcp__snowflake-mcp__list_objects object_type="table" database_name="ANALYTICS_DW"

# Test aws-api
mcp__aws-api__call_aws cli_command="aws sts get-caller-identity"

# Test github
mcp__github__search_repositories query="org:your-org" perPage=5
```

### Documentation Locations

- **MCP Research**: `knowledge/mcp-servers/`
- **Specialist Agents**: `.claude/agents/specialists/`
- **Role Agents**: `.claude/agents/roles/`
- **Integration Patterns**: `.claude/rules/` and `.claude/skills/reference-knowledge/`
- **This Guide**: `.claude/skills/reference-knowledge/agent-mcp-integration-guide/SKILL.md`

---

*Guide created: 2025-10-08*
*Author: Claude Code - MCP Integration Research*
*Purpose: Complete MCP integration reference for DA Agent Hub agents*
