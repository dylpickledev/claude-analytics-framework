# Sequential Thinking MCP Usage Pattern

## Quick Decision Guide

**Should you use sequential thinking for this task?**

### ✅ YES - Use Sequential Thinking When:

- **Problem scope unclear** - Don't know full complexity upfront
- **Multiple viable approaches** - Need to explore alternatives
- **High correctness requirement** - Wrong answer is costly
- **Multi-step reasoning required** - Can't solve in single step
- **Assumptions may change** - Requirements evolving during analysis
- **Hypothesis testing needed** - Competing theories to validate
- **Cross-system coordination** - Multiple tools/systems involved
- **Stakeholder alignment critical** - Need to show reasoning trail

### ❌ NO - Direct Response Better When:

- **Simple, well-defined task** - Single-step solution
- **Quick lookup** - Just need information
- **Time-sensitive** - Need immediate answer
- **Repeatable pattern** - Done this before, know the approach
- **Token cost matters** - 15x cost not justified for this task

## Tool Parameters Quick Reference

### Required Every Call
```typescript
{
  thought: string,              // Current reasoning step
  nextThoughtNeeded: boolean,   // false = done, true = continue
  thoughtNumber: number,         // Current step (1, 2, 3...)
  totalThoughts: number         // Estimate (can adjust)
}
```

### Optional for Advanced Patterns
```typescript
{
  isRevision: boolean,          // Reconsidering previous thought?
  revisesThought: number,       // Which thought # to revise
  branchFromThought: number,    // Starting alternative path
  branchId: string,             // Name this branch
  needsMoreThoughts: boolean    // Scope expanded, need more steps
}
```

## Usage Patterns by Agent Role

### Data Architect (High Value)
**Always use for**:
- System design decisions
- Technology selection with trade-offs
- Cross-system integration planning
- Architecture pattern selection

**Example**:
```
Thought 1: Define requirements (performance, cost, maintainability)
Thought 2: Option A - Snowflake native tasks
Thought 3: Option B - Prefect orchestration
Thought 4: Option C - Orchestra unified platform
Thought 5: Evaluation matrix (each option vs requirements)
Thought 6: [BRANCH A] Best for current team capabilities
Thought 7: [BRANCH B] Best for long-term scalability
Thought 8: Synthesis - Recommendation with migration path
```

### Analytics Engineer (Medium Value)
**Use for complex tasks**:
- Data model design with multiple source systems
- Performance optimization requiring investigation
- Metric definition with business logic complexity

**Skip for**:
- Simple transformations (adding column, filter)
- Well-established patterns (SCD Type 2)
- Documentation updates

### QA Engineer (High Value)
**Always use for**:
- Test strategy development
- Root cause analysis (production issues)
- Test coverage gap analysis

**Example**:
```
Thought 1: Symptom analysis (what's failing, when, how often)
Thought 2: Hypothesis A - Data quality issue upstream
Thought 3: Verification A - Check source data patterns
Thought 4: [NEGATIVE] Hypothesis A disproven
Thought 5: Hypothesis B - Warehouse timeout on large dataset
Thought 6: Verification B - Check query execution times
Thought 7: [POSITIVE] Confirmed - 10x data volume in prod
Thought 8: Root cause - Query needs optimization
Thought 9: Solution - Add incremental logic + warehouse size
```

### Business Analyst (High Value)
**Always use for**:
- Requirements decomposition
- Stakeholder alignment across competing needs
- Feasibility analysis with unknowns

### Data/BI Developer (Situational)
**Use for**:
- Unfamiliar tools/patterns
- Architecture decisions
- Cross-tool integration

**Skip for**:
- Standard dashboard updates
- Known patterns (KPI card, filter setup)

## Common Patterns

### Pattern 1: Hypothesis Testing
```
Thought 1-N: Gather evidence
Thought N+1: Generate hypothesis
Thought N+2: Test hypothesis against evidence
Thought N+3: [REVISION if failed] Alternative hypothesis
Repeat until hypothesis verified
```

### Pattern 2: Alternative Exploration
```
Thought 1-3: Problem definition + constraints
Thought 4: [BRANCH A] Approach 1
Thought 5: [BRANCH B] Approach 2
Thought 6: [BRANCH C] Approach 3
Thought 7: Evaluation matrix
Thought 8: Synthesis + recommendation
```

### Pattern 3: Iterative Refinement
```
Thought 1: Initial approach
Thought 2: Implementation consideration
Thought 3: [REVISION Thought 1] - Found constraint
Thought 4: Refined approach
Thought 5: Validation
Thought 6: [REVISION Thought 4] - Edge case discovered
Thought 7: Final approach
```

## Best Practices

### Start Right
- Begin with realistic `totalThoughts` estimate
- First thought should define problem clearly
- Early thoughts gather context, later synthesize

### Revise Freely
- Use `isRevision: true` when understanding improves
- Explain WHY revising in thought text
- Reference specific thought number being reconsidered

### Branch Purposefully
- Give branches clear labels (Option A, Approach 1, etc.)
- Each branch should be meaningfully different
- Always synthesize branches before completion

### Complete Properly
- Only set `nextThoughtNeeded: false` when truly done
- Final thought should be actionable
- Summarize key decisions and trade-offs

### Express Uncertainty
- State confidence levels explicitly
- Use questions to highlight unknowns
- Set `needsMoreThoughts: true` if scope expands

## Token Cost Consideration

**Reality Check**: Sequential thinking uses ~15x more tokens than direct responses

**When 15x cost is justified**:
- Architecture decisions (long-term impact)
- Production debugging (downtime cost high)
- Stakeholder-critical decisions (political/business risk)
- Complex migrations (failure cost high)

**When 15x cost NOT justified**:
- Simple updates
- Repetitive tasks
- Low-stakes decisions
- Quick prototypes

**Anthropic Research**: Despite 15x token cost, sequential thinking produces significantly better outcomes for complex problems.

## Tool Access

**Current Configuration**: Available in DA Agent Hub MCP setup
```json
{
  "sequential-thinking": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
  }
}
```

**Verify availability**: Check `.mcp.json` for `sequential-thinking` entry

## Full Documentation

For complete capabilities, parameters, examples, and implementation patterns:
**📄 See**: `knowledge/da-agent-hub/development/sequential-thinking-mcp-capabilities.md`

---

**Pattern Version**: 1.0
**Last Updated**: 2025-10-08
**Related Patterns**:
- Cross-system analysis patterns
- Testing patterns
- Agent coordination patterns
