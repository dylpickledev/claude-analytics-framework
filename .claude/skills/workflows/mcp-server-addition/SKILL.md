---
name: mcp-server-addition
description: Comprehensive checklist for integrating new MCP servers into the specialist and role agent ecosystem. Ensures complete integration including configuration, validation, specialist updates, documentation, and testing.
disable-model-invocation: false
---

# MCP Server Addition Protocol

**Purpose**: Checklist for adding new MCP servers to ensure complete integration
**Created**: 2025-10-08 (Learning from Week 7-8 MCP integration)
**Status**: Production Protocol

---

## Overview

When adding a new MCP server to DA Agent Hub, follow this comprehensive protocol to ensure the MCP server is properly integrated into the specialist and role agent ecosystem.

---

## Phase 1: MCP Server Setup & Validation (2-3 hours)

### Step 1: Configure MCP Server
**Location**: `.claude/mcp.json`

**Actions**:
- [ ] Add MCP server configuration with authentication
- [ ] Configure security restrictions (read-only by default when possible)
- [ ] Set up credential management (1Password environment variables)
- [ ] Test MCP server connection (`claude mcp list`)

**Example**:
```json
{
  "mcpServers": {
    "new-mcp-server": {
      "command": "uvx",
      "args": ["package-name"],
      "env": {
        "API_TOKEN": "${NEW_MCP_TOKEN}",
        "READ_ONLY": "true"
      },
      "disabled": false
    }
  }
}
```

---

### Step 2: Research MCP Server Tools
**Duration**: 1-2 hours (depending on server complexity)

**Actions**:
- [ ] Inventory all available MCP tools
- [ ] Document tool parameters and usage
- [ ] Identify security considerations
- [ ] Test critical tools (3-5 most common operations)
- [ ] Document known issues and limitations
- [ ] Assign confidence levels (HIGH/MEDIUM/LOW)

**Output**: Create comprehensive documentation
**Location**: `knowledge/mcp-servers/<server-name>/`

**Contents**:
- Tool inventory with descriptions
- Authentication and security notes
- Usage examples for common operations
- Known issues and workarounds
- Confidence scoring

---

### Step 3: Validate MCP Tools
**Duration**: 30-60 minutes

**Actions**:
- [ ] Test 3-5 critical tools
- [ ] Verify authentication works
- [ ] Confirm security restrictions enforced
- [ ] Document test results
- [ ] Update confidence scores based on testing

**Output**: Validation report
**Location**: `projects/active/.../WEEK*_MCP_VALIDATION.md`

---

## Phase 2: Specialist Agent Integration (1-2 hours)

### Step 4: Update Specialist Agent(s)
**Identify which specialists need this MCP server**

**Actions**:
- [ ] Add MCP tool inventory to specialist agent file
- [ ] Document tool selection framework (when to use which tool)
- [ ] Add MCP recommendation pattern examples
- [ ] Include security notes and authentication
- [ ] Add confidence levels for each tool category
- [ ] Document integration patterns with other MCP servers

**Location**: `.claude/agents/specialists/<specialist-name>.md`

**Section to Add**:
```markdown
## MCP Tools

### <server-name> Tools

**Tool Category 1** (X tools):
- tool_name_1: Description, confidence level
- tool_name_2: Description, confidence level

**Tool Category 2** (Y tools):
- tool_name_3: Description, confidence level

### Tool Selection Framework
- Use tool_1 when: [criteria]
- Use tool_2 when: [criteria]

### MCP Recommendation Pattern
[Example of how specialist recommends MCP tool usage]

### Confidence Levels
| Tool Category | Confidence | Notes |
|---------------|------------|-------|
| Category 1 | HIGH (0.92) | Production-validated |
| Category 2 | MEDIUM (0.70) | Requires validation |

### Security Notes
- Authentication: [method]
- Restrictions: [read-only, permissions]
- Known issues: [workarounds]
```

---

## Phase 3: Role Agent Integration (1-2 hours)

### Step 5: Identify Affected Role Agents
**Determine which roles should have direct access vs specialist delegation**

**Questions to answer**:
- Which roles work in this domain regularly? (direct access)
- Which roles occasionally need this tool? (specialist delegation)
- What's the confidence threshold for direct use? (typically ≥0.85)

**Examples**:
- dbt-mcp: analytics-engineer (direct), bi-developer (minimal), others (delegate)
- aws-api: data-engineer (minimal), ui-ux (delegate only)
- slack-mcp: project-manager (heavy), business-analyst (moderate)

---

### Step 6: Update Role Agents
**For each affected role agent**

**Actions**:
- [ ] Add MCP Tool Access section (if not exists)
- [ ] Document primary MCP servers for this role
- [ ] Define "When to Use MCP Tools Directly" (confidence ≥0.85)
- [ ] Define "When to Delegate to Specialists" (confidence <0.60)
- [ ] Add usage examples (copy-paste ready)
- [ ] Update "When to Handle Directly" checklist (add simple MCP queries)

**Location**: `.claude/agents/roles/<role-name>.md`

**Template**:
```markdown
## MCP Tool Access

### Primary MCP Servers
**Direct Access**: <server-name>, [other servers]
**Purpose**: [What role uses these MCP tools for]

### When to Use MCP Tools Directly (Confidence ≥0.85)

**<server-name>** ([Usage Level: Heavy/Moderate/Minimal]):
- ✅ Tool 1: Common operation description
- ✅ Tool 2: Common operation description

**Example**:
[Copy-paste ready code example]

### When to Delegate to Specialists (Confidence <0.60 OR Complex Operations)

**<specialist-name>** ([Domain]):
- ❌ Complex operation type 1
- ❌ Complex operation type 2
```

---

## Phase 4: Documentation & Patterns (2-3 hours)

### Step 7: Create Quick Reference Card
**Purpose**: Fast lookup for common MCP tool operations

**Actions**:
- [ ] Create quick reference card
- [ ] Document most common operations (80/20 principle)
- [ ] Add 3-5 common workflows
- [ ] Include troubleshooting guide (common issues)
- [ ] Add confidence levels
- [ ] Document when to delegate to specialist

**Location**: `.claude/skills/reference-knowledge/<server-name>-quick-reference/SKILL.md`

**Structure**:
- 🚀 Most Common Operations (by category)
- 🎯 Common Workflows (multi-step real-world patterns)
- ⚠️ Important Notes (security, performance, authentication)
- 🔧 Troubleshooting (common issues with solutions)
- 📊 Confidence Levels (tool reliability ratings)
- 🎓 When to Delegate (direct use vs specialist)

---

### Step 8: Document Cross-Tool Integration Patterns
**Purpose**: Show how new MCP server combines with existing servers

**Actions**:
- [ ] Identify 1-3 cross-tool integration patterns
- [ ] Document step-by-step workflow
- [ ] Include real-world example (production-validated if possible)
- [ ] Define tool-specific responsibilities
- [ ] Add troubleshooting for integration issues
- [ ] Document success metrics

**Location**: `.claude/skills/reference-knowledge/cross-tool-integration-<pattern-name>/SKILL.md`

**Required Patterns** (1-3 depending on MCP complexity):
1. **Primary integration**: How new MCP combines with most-used existing MCP
2. **Secondary integration** (if applicable): Alternative workflow pattern
3. **Specialist coordination** (if applicable): How specialists use multiple MCPs together

**Example Patterns**:
- dbt + Snowflake: Model optimization
- AWS + Docs: Infrastructure deployment
- GitHub + Investigation: Cross-repo error analysis
- **NEW SERVER**: [server] + [existing-server]: [workflow name]

---

### Step 9: Update Central MCP Integration Guide
**Location**: `.claude/skills/reference-knowledge/agent-mcp-integration-guide/SKILL.md`

**Actions**:
- [ ] Add server to MCP Server Inventory table
- [ ] Add specialist(s) to Specialist Agent MCP Integration section
- [ ] Document cross-tool integration pattern
- [ ] Update role agent MCP access table
- [ ] Add known issues/limitations (if any)
- [ ] Update maintenance & verification checklist

---

## Phase 5: Validation & Testing (1-2 hours)

### Step 10: Execute Integration Pattern Test
**Purpose**: Validate cross-tool pattern works as documented

**Actions**:
- [ ] Execute documented integration pattern step-by-step
- [ ] Use actual MCP tool calls (not just documentation)
- [ ] Document any issues or adjustments needed
- [ ] Validate success metrics achieved
- [ ] Update pattern documentation with findings

**Example**: If added tableau-mcp
```bash
# Test: Tableau + dbt + Snowflake optimization pattern
1. mcp__tableau-mcp__get_dashboard_details (identify slow dashboard)
2. mcp__dbt-mcp__get_model_details (understand data source)
3. mcp__snowflake-mcp__run_query (analyze query performance)
4. Delegate to tableau-expert (optimization recommendations)
5. Validate improvement
```

---

### Step 11: Production Validation (Optional - Highly Recommended)
**Purpose**: Validate MCP integration with real use case

**Actions**:
- [ ] Identify small, low-risk production use case
- [ ] Execute using MCP integration patterns
- [ ] Measure actual business impact
- [ ] Document learnings and pattern refinements
- [ ] Update confidence scores based on production validation

**Example**: Use new MCP server to solve actual Issue from GitHub backlog

---

## Phase 6: Knowledge Capture (30-60 minutes)

### Step 12: Update Project Context
**Location**: `projects/active/.../context.md`

**Actions**:
- [ ] Add MCP server to Active MCP list
- [ ] Document new specialist(s) created/updated
- [ ] Update specialist count (track progress toward 17+ goal)
- [ ] Record any blockers or known issues
- [ ] Update next actions

---

### Step 13: Create Completion Documentation
**Purpose**: Record what was accomplished for future reference

**Actions**:
- [ ] Create WEEK*_<MILESTONE>_COMPLETE.md file
- [ ] Document deliverables (research, specialists, roles, patterns)
- [ ] Record metrics (time, quality, coverage)
- [ ] Capture key discoveries and learnings
- [ ] Provide next steps recommendations

**Location**: `projects/active/.../WEEK*_<MILESTONE>_COMPLETE.md`

---

## Checklist Summary

**Quick Validation** - Did you complete all critical steps?

### Configuration & Research
- [ ] MCP server configured in `.mcp.json`
- [ ] Credentials set up (1Password environment variables)
- [ ] MCP server connection tested
- [ ] Complete tool inventory documented
- [ ] 3-5 critical tools validated
- [ ] Security considerations documented

### Integration
- [ ] Specialist agent(s) updated with MCP tools
- [ ] Tool selection framework documented
- [ ] Confidence levels assigned
- [ ] Role agent(s) updated with direct access patterns
- [ ] Delegation patterns defined
- [ ] Usage examples provided (copy-paste ready)

### Documentation
- [ ] Quick reference card created
- [ ] 1-3 cross-tool integration patterns documented
- [ ] Central MCP Integration Guide updated
- [ ] Known issues and workarounds documented
- [ ] Troubleshooting guide included

### Validation
- [ ] Integration pattern tested with actual MCP calls
- [ ] Production validation (if possible)
- [ ] Confidence scores validated through testing
- [ ] Project context updated
- [ ] Completion documentation created

---

## Time Estimates

**Phase 1** (Setup & Validation): 2-3 hours
**Phase 2** (Specialist Integration): 1-2 hours
**Phase 3** (Role Integration): 1-2 hours
**Phase 4** (Documentation): 2-3 hours
**Phase 5** (Validation): 1-2 hours
**Phase 6** (Knowledge Capture): 30-60 minutes

**Total**: 8-13 hours for complete MCP server integration

**Faster if**:
- MCP server has good documentation (reduce research time)
- Tool inventory is small (<10 tools)
- Only 1-2 specialists affected
- Few role agents need direct access

**Slower if**:
- Poor documentation (require experimentation)
- Large tool inventory (>40 tools like dbt-mcp)
- Multiple specialists need updates
- Complex cross-tool integration patterns

---

## Success Criteria

**Complete integration achieved when**:
- ✅ MCP server operational and validated
- ✅ At least 1 specialist has complete tool inventory
- ✅ Affected role agents have direct access patterns
- ✅ Quick reference card created
- ✅ At least 1 cross-tool integration pattern documented
- ✅ Central MCP Integration Guide updated
- ✅ Integration pattern tested with actual MCP calls

---

## Related Resources

- **MCP Integration Guide**: `.claude/skills/reference-knowledge/agent-mcp-integration-guide/SKILL.md`
- **Quick Reference Template**: Use existing cards as template
- **Integration Pattern Template**: Use Week 7 Day 5 patterns as template
- **Specialist Template**: `.claude/agents/specialists/specialist-template.md`
- **Role Template**: `.claude/agents/roles/role-template.md`

---

*Created: 2025-10-08*
*Learning from: Week 7-8 MCP integration experience*
*Purpose: Ensure complete, consistent MCP server integration*
