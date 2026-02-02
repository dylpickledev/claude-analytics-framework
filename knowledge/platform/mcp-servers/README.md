# MCP Servers Knowledge Base

This directory contains comprehensive documentation for Model Context Protocol (MCP) servers used in the DA Agent Hub.

## Purpose

MCP servers provide specialist AI agents with real-time access to external systems, tools, and data sources. This knowledge base documents:
- What each MCP server can do (tool inventory)
- How to use each MCP server (parameters, return values)
- When to use each MCP server (decision frameworks)
- Integration patterns for specialist agents

## Available MCP Server Documentation

### AWS Documentation MCP Server

**Research Date**: 2025-10-08

**Documents**:
1. **aws-docs-mcp-server-reference.md** - Complete technical reference
   - All tool signatures and parameters
   - Configuration options
   - Error scenarios and troubleshooting
   - Complete use case examples

2. **aws-docs-mcp-integration-guide.md** - Integration guide for aws-expert agent
   - Quick reference for core tools
   - Integration patterns and workflows
   - Decision trees for tool selection
   - Recommendation quality standards

3. **aws-docs-research-summary.md** - Research summary and findings
   - Executive summary of capabilities
   - Key insights for aws-expert integration
   - Next steps and recommendations

**Key Capabilities**:
- Read AWS documentation as markdown
- Search all AWS documentation
- Get content recommendations
- Access to current (not training-cutoff) AWS documentation

**Primary Users**: aws-expert specialist agent, data-architect-role

---

## MCP Server Research Status

| MCP Server | Status | Documentation | Primary Users |
|------------|--------|---------------|---------------|
| aws-docs | ✅ Complete | 3 documents (42KB) | aws-expert, data-architect-role |
| aws-api | ⏳ Partial | Function definitions only | aws-expert, data-engineer-role |
| dbt-mcp | ⏳ Partial | Function definitions only | dbt-expert, analytics-engineer-role |
| snowflake-mcp | ⏳ Partial | Function definitions only | snowflake-expert, analytics-engineer-role |
| github | ⏳ Partial | Function definitions only | github-sleuth-expert |
| slack | ⏳ Partial | Function definitions only | business-context |
| filesystem | ⏳ Partial | Function definitions only | All agents |
| sequential-thinking | ⏳ Partial | Function definitions only | All agents (problem-solving) |

**Legend**:
- ✅ Complete: Full technical reference + integration guide + research summary
- ⏳ Partial: Function definitions available, comprehensive docs needed
- ❌ Not Started: No documentation yet

---

## Documentation Standards

Each MCP server should have three documents:

### 1. Technical Reference (`<server>-mcp-server-reference.md`)
**Purpose**: Complete technical documentation
**Contents**:
- Overview and purpose
- Complete tool inventory
- Function signatures with parameters and return types
- Configuration options
- Error scenarios and troubleshooting
- Example workflows
- Limitations and constraints
- Comparison with related MCP servers

**Audience**: Any agent or developer working with the MCP server

### 2. Integration Guide (`<server>-mcp-integration-guide.md`)
**Purpose**: Agent-specific integration patterns
**Contents**:
- Quick reference for core tools
- Integration patterns for specialist agents
- Decision trees for tool selection
- When to use MCP vs other approaches
- Common recommendation patterns
- Quality standards for recommendations
- Complete interaction examples

**Audience**: Specialist agents that use this MCP server

### 3. Research Summary (`<server>-research-summary.md`)
**Purpose**: Research findings and recommendations
**Contents**:
- Executive summary of capabilities
- Key insights for integration
- Research sources and verification
- Recommendations for agent updates
- Next steps and future research
- Impact assessment

**Audience**: Project stakeholders, future researchers

---

## MCP Server Categories

### Data Platform MCP Servers
- **dbt-mcp**: dbt Cloud API access (transformations, jobs, metadata)
- **snowflake-mcp**: Snowflake operations (queries, objects, semantic layer)

### Cloud Infrastructure MCP Servers
- **aws-docs**: AWS documentation access (read, search, recommendations)
- **aws-api**: AWS API execution (inspect, manage resources)

### Development & Collaboration MCP Servers
- **github**: GitHub operations (repos, issues, PRs, code search)
- **slack**: Slack communication (channels, messages, users)

### System MCP Servers
- **filesystem**: File system operations (read, write, search)
- **sequential-thinking**: Problem-solving workflows (chain of thought)

---

## Using This Documentation

### For Specialist Agents

1. **Find your primary MCP servers** in agent definition (e.g., aws-expert uses aws-docs, aws-api)
2. **Read integration guide** for your MCP server (quick patterns and decision trees)
3. **Reference technical documentation** when you need detailed parameter info
4. **Follow quality standards** when recommending MCP tool executions

### For Role Agents

1. **Identify which specialist** to delegate to based on MCP server needed
2. **Use decision frameworks** to determine if MCP tool usage needed
3. **Review integration patterns** to understand specialist capabilities

### For Researchers

1. **Use aws-docs documentation as template** for future MCP server research
2. **Follow three-document pattern** (reference + guide + summary)
3. **Verify across multiple sources** before documenting capabilities
4. **Include real examples** from actual usage when possible

---

## Research Methodology

Each MCP server should be researched using this methodology:

### 1. Source Discovery
- Official GitHub repositories
- npm/PyPI package listings
- Official documentation sites
- Tutorial and integration guides

### 2. Verification
- Cross-reference multiple authoritative sources
- Verify current .mcp.json configuration
- Examine available function definitions
- Test basic functionality (when possible)

### 3. Documentation
- Create technical reference (complete tool inventory)
- Create integration guide (agent-specific patterns)
- Create research summary (findings and recommendations)

### 4. Validation
- Review with specialist agents
- Test patterns in real scenarios
- Extract learnings to pattern library
- Update based on actual usage

---

## Future Research Priorities

Based on specialist agent needs:

**HIGH PRIORITY** (Next to research):
1. **aws-api MCP** - Critical for aws-expert effectiveness
2. **dbt-mcp** - Essential for dbt-expert and analytics-engineer-role
3. **snowflake-mcp** - Essential for snowflake-expert

**MEDIUM PRIORITY**:
4. **github MCP** - Important for github-sleuth-expert
5. **slack MCP** - Useful for business-context agent

**LOW PRIORITY** (Basic functionality well-understood):
6. **filesystem MCP** - General-purpose, patterns emerging
7. **sequential-thinking MCP** - Problem-solving, patterns established

---

## Contributing

When adding new MCP server documentation:

1. **Research thoroughly** - Use multiple authoritative sources
2. **Follow templates** - Use three-document pattern (reference + guide + summary)
3. **Include examples** - Real usage examples are critical
4. **Verify accuracy** - Cross-reference multiple sources
5. **Update this README** - Add entry to status table and category lists
6. **Link from agents** - Update relevant specialist agent definitions

---

## Questions or Issues

If you find:
- **Inaccuracies**: Update documentation based on verified sources
- **Missing information**: Research and add to appropriate document
- **New MCP servers**: Follow research methodology to create documentation
- **Better patterns**: Extract to integration guide

---

*Last Updated: 2025-10-08*
*Template: aws-docs MCP server documentation*
