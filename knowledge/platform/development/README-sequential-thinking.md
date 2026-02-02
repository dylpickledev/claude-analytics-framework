# Sequential Thinking MCP Documentation Index

## Quick Navigation

**🎯 Start Here**: Choose your path based on your needs

### For Agents Making Real-Time Decisions
**📋 Quick Reference Pattern Guide**
- **File**: `.claude/rules/sequential-thinking-usage-pattern.md`
- **Use When**: Need to decide "should I use sequential thinking for this task?"
- **Contains**: Decision matrix, parameter quick reference, common patterns
- **Read Time**: 5 minutes

### For Deep Understanding of Capabilities
**📚 Comprehensive Capabilities Reference**
- **File**: `knowledge/da-agent-hub/development/sequential-thinking-mcp-capabilities.md`
- **Use When**: Need complete technical specifications and advanced patterns
- **Contains**: Full tool spec, installation, use cases, examples, limitations
- **Read Time**: 15-20 minutes

### For Platform Team Planning Integration
**🚀 Agent Integration Recommendations**
- **File**: `knowledge/da-agent-hub/development/sequential-thinking-agent-recommendations.md`
- **Use When**: Planning which agents should use sequential thinking and how
- **Contains**: Priority tiers, agent-by-agent analysis, implementation plan
- **Read Time**: 20-25 minutes

### For Executive Summary
**📊 Research Summary**
- **File**: `sequential-thinking-research-summary.md` (repo root)
- **Use When**: Need high-level overview and key findings
- **Contains**: Research overview, key findings, recommendations, next steps
- **Read Time**: 10 minutes

---

## Document Relationship

```
📊 Research Summary (Executive Overview)
    ↓
    ├─→ 📚 Capabilities Reference (Technical Deep Dive)
    │       └─→ Full tool specification
    │       └─→ Installation & configuration
    │       └─→ Complete use cases & examples
    │
    ├─→ 📋 Usage Pattern Guide (Quick Reference)
    │       └─→ When to use decision guide
    │       └─→ Parameter quick reference
    │       └─→ Common patterns by role
    │
    └─→ 🚀 Agent Recommendations (Implementation Planning)
            └─→ Priority tiers (High/Medium/Low)
            └─→ Agent-by-agent analysis
            └─→ Implementation phases
```

---

## Common Workflows

### Workflow 1: "Should I use sequential thinking right now?"
1. Read: `.claude/rules/sequential-thinking-usage-pattern.md`
2. Check: Decision matrix (YES/NO criteria)
3. Apply: Quick reference parameters
4. Execute: Use tool with recommended pattern

### Workflow 2: "How do I implement sequential thinking in an agent?"
1. Read: `sequential-thinking-agent-recommendations.md` (find your agent tier)
2. Review: Agent-specific patterns and examples
3. Reference: Comprehensive capabilities doc for advanced features
4. Implement: Add guidance to agent definition

### Workflow 3: "What can sequential thinking actually do?"
1. Read: `sequential-thinking-mcp-capabilities.md` (complete reference)
2. Review: Tool parameters and capabilities section
3. Study: Practical examples section
4. Explore: Integration patterns section

### Workflow 4: "Present findings to stakeholders"
1. Start: `sequential-thinking-research-summary.md` (executive summary)
2. Highlight: Key findings and recommendations
3. Support: Reference comprehensive docs for questions
4. Plan: Use implementation plan from recommendations doc

---

## Quick Facts

**Tool Name**: `sequentialthinking`
**Package**: `@modelcontextprotocol/server-sequential-thinking`
**Status**: ✅ Configured in DA Agent Hub (`.mcp.json`)
**License**: MIT
**Token Cost**: ~15x direct responses (justified by quality improvement)

**Current Integration**:
- ✅ 5 specialist agents already use it
- ❌ 0 role agents currently use it
- 🎯 3 high-priority role agents recommended (data-architect, qa-engineer, business-analyst)

---

## File Locations

| Document | Path | Size |
|----------|------|------|
| Research Summary | `/Users/TehFiestyGoat/GRC/da-agent-hub/sequential-thinking-research-summary.md` | ~8 KB |
| Capabilities Reference | `knowledge/da-agent-hub/development/sequential-thinking-mcp-capabilities.md` | ~15 KB |
| Usage Pattern Guide | `.claude/rules/sequential-thinking-usage-pattern.md` | ~6 KB |
| Agent Recommendations | `knowledge/da-agent-hub/development/sequential-thinking-agent-recommendations.md` | ~12 KB |

**Total Documentation**: ~41 KB across 4 comprehensive documents

---

## Related Documentation

- **MCP Configuration**: `.mcp.json` (sequential-thinking server setup)
- **Agent Definitions**: `.claude/agents/roles/` (role agent files)
- **Specialist Agents**: `.claude/agents/specialists/` (5 already using sequential thinking)
- **General Patterns**: `.claude/rules/` (cross-system analysis, testing, git workflow)

---

**Index Version**: 1.0
**Last Updated**: 2025-10-08
**Maintained By**: DA Agent Hub Platform Team
