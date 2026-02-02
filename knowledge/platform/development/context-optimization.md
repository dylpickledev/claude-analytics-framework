# Context Optimization Guide

## Overview
This guide documents the context management and memory system for the DA Agent Hub, designed to work within Claude Code's actual capabilities.

## Understanding Claude Code Context

### What Claude Code CAN Do
- ✅ Read/write files that persist between sessions
- ✅ Load context from files at conversation start
- ✅ Automatic context editing (removes stale tool calls)
- ✅ Access full file system for knowledge storage
- ✅ Extract patterns to files via commands

### What Claude Code CANNOT Do
- ❌ True memory between sessions (each session is independent)
- ❌ Control prompt caching directly (handled automatically by API)
- ❌ See token budget or usage metrics
- ❌ Persist conversation state automatically

## File-Based Knowledge System

### Directory Structure
```
.claude/
├── rules/                      # Simple conventions (auto-loaded)
├── skills/
│   ├── reference-knowledge/   # Deep patterns (user-invocable: false)
│   └── workflows/             # Procedural automation
└── agents/                     # Agent definitions
```

### Pattern Markers
Use these markers in task findings for automatic extraction:

- `PATTERN:` - Reusable implementation pattern
- `SOLUTION:` - Specific solution that worked
- `ERROR-FIX:` - Error and its resolution
- `ARCHITECTURE:` - System design pattern
- `INTEGRATION:` - Cross-system coordination

### Example Pattern Documentation
```markdown
# In .claude/tasks/dbt-expert/findings.md

PATTERN: Incremental model for large fact tables
- Use `is_incremental()` macro
- Set unique_key for merge behavior
- Add lookback window for late-arriving data

SOLUTION: Fix for "column not found" in incremental models
- Always use `adapter.get_columns_in_relation()`
- Handle schema evolution with on_schema_change config

ERROR-FIX: "Compilation Error in model 'dm_sales'" -> Check for missing ref() functions in CTEs
```

## Branch-Based Workflow Enhancement

### Branch Types and Memory Loading

#### Investigation Branches (`feature/investigate-*`)
```bash
# Auto-loads from memory:
.claude/skills/reference-knowledge/investigation-checklist/SKILL.md
projects/archive/ (completed project learnings)
```

#### Building Branches (`feature/build-*`)
```bash
# Auto-loads from memory:
.claude/skills/reference-knowledge/[project-type]-patterns/SKILL.md
.claude/skills/project-setup/templates/
```

#### Fix Branches (`fix/*`)
```bash
# Auto-loads from memory:
.claude/skills/reference-knowledge/common-error-fixes/SKILL.md
projects/archive/ (recent project completions)
```

## Memory Extraction Process

### During Work
1. Document findings with pattern markers
2. Save to `.claude/tasks/*/findings.md`
3. Reference existing patterns before investigating

### At Project Completion (`/complete`)
1. Scans all task findings for pattern markers
2. Extracts to project documentation for review
3. Cleans up task findings
4. Preserves valuable patterns

### Monthly Pattern Review
```bash
# Review and promote valuable patterns
cat projects/active/current-project/README.md

# Promote to permanent patterns
echo "# New pattern" > .claude/skills/reference-knowledge/new-pattern/SKILL.md
```

## Optimizing Context Usage

### Start of Session Checklist
1. Check recent patterns: `ls -la .claude/skills/reference-knowledge/`
2. Review relevant domain patterns
3. Load appropriate templates
4. Check for unfinished tasks

### During Investigation
1. Check memory first: "Have we solved this before?"
2. Document findings with pattern markers
3. Reference patterns to avoid redundant work

### Pattern Reuse Examples

#### Before Memory System
```
Claude: Let me investigate this Tableau performance issue...
[Spends 30 minutes discovering it's a missing index]
```

#### With Memory System
```
Claude: Checking memory for Tableau performance patterns...
Found: ERROR-FIX: Slow dashboard -> Missing index on fact table
Applying known solution...
[Fixes in 5 minutes]
```

## Best Practices

### DO:
- ✅ Use pattern markers consistently
- ✅ Check memory at session start
- ✅ Extract patterns via `/complete`
- ✅ Review monthly patterns for promotion
- ✅ Create domain-specific pattern files

### DON'T:
- ❌ Expect automatic memory between sessions
- ❌ Rely on conversation persistence
- ❌ Skip pattern documentation
- ❌ Let memory directories grow unbounded

## Integration with Agents

### Agent Memory References
Each agent should check relevant memory:

```markdown
# In agent prompt
## Memory Check
Before analysis, review:
- `.claude/skills/reference-knowledge/[domain]-patterns/SKILL.md`
- `projects/archive/` (last 30 days)
```

### Agent-Specific Patterns
- `dbt-patterns.md` - SQL transformations, testing
- `snowflake-patterns.md` - Query optimization, costs
- `tableau-patterns.md` - Dashboard performance
- `react-patterns.md` - Component structures
- `integration-patterns.md` - Cross-system coordination

## Maintenance Schedule

### Daily
- Document findings with pattern markers
- Reference memory before investigations

### Weekly
- Review extracted patterns in recent/
- Promote high-value patterns

### Monthly
- Consolidate monthly pattern files
- Update domain pattern documents
- Clean old task findings

### Quarterly
- Archive old patterns no longer relevant
- Reorganize pattern categories
- Update templates based on learnings

## Success Metrics

### Measurable Improvements
- **30% faster investigation starts** - Skip known dead ends
- **50% reduction in repeated discoveries** - Patterns recognized
- **60% fewer agent re-invocations** - Context preserved
- **3x faster debugging** - Error memory lookup

### Quality Indicators
- Pattern files growing with valuable content
- Reduced time to solution for similar problems
- Agents referencing memory successfully
- Teams benefiting from shared learnings

## Troubleshooting

### Common Issues

#### Patterns Not Extracting
- Check pattern markers are formatted correctly
- Ensure findings are in `.claude/tasks/*/`
- Verify finish.sh has execute permissions

#### Memory Not Loading
- Explicitly read memory files at session start
- Check file paths are correct
- Ensure .claude/rules/ and .claude/skills/ exist

#### Patterns Getting Lost
- Run `/complete` before merging branches
- Don't delete .claude/tasks/ manually
- Check monthly files in recent/

## Future Enhancements

### Potential Improvements (When Available)
- Automatic memory tool integration
- Cross-session state persistence
- Token budget visibility
- Direct prompt caching control

### Current Workarounds
- File-based memory system
- Pattern extraction scripts
- Branch-based context
- Manual memory loading