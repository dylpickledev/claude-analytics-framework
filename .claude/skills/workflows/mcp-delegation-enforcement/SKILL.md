---
name: mcp-delegation-enforcement
description: Enforce specialist-first delegation pattern for domain-specific questions. Prevents bypassing specialist architecture by ensuring domain questions are delegated to appropriate specialists before attempting direct tool use.
disable-model-invocation: false
---

# MCP Delegation Enforcement Pattern

**Created**: 2025-10-07
**Purpose**: Prevent Claude from bypassing the Role → Specialist delegation architecture
**Status**: Mandatory - enforce in all sessions

## The Problem This Solves

**Bad Behavior** (What happened):
```
User: "Are there failing Snowflake tasks?"
Claude: Tries snowsql directly → Fails → Then delegates to snowflake-expert
```

**Why this is wrong**:
- Bypasses the specialist architecture we built
- Wastes time with failed approaches
- Doesn't leverage specialist expertise first
- Violates the 80/20 delegation principle (roles should delegate when confidence <0.60)

**Correct Behavior** (Enforcement pattern):
```
User: "Are there failing Snowflake tasks?"
Claude: Immediately delegates to snowflake-expert
snowflake-expert: Uses snowflake-mcp or documents why it can't and uses alternative
Claude: Returns specialist findings to user
```

## Mandatory Delegation Rules

### Rule 1: Specialist-First for Domain Questions

**ALWAYS delegate immediately when**:
- Question is about specific technology (Snowflake, dbt, Tableau, AWS, Orchestra, Prefect, React, Streamlit)
- Question requires domain expertise to answer correctly
- Specialist exists for that domain
- Confidence level <0.60 for answering directly

**Specialist Trigger Keywords**:
- "Snowflake" → snowflake-expert
- "dbt" → dbt-expert
- "Tableau" / "dashboard" → tableau-expert
- "AWS" / "infrastructure" / "deploy" → aws-expert
- "Orchestra" / "pipeline" / "workflow" → orchestra-expert
- "Prefect" / "flow" → prefect-expert
- "React" → react-expert
- "Streamlit" → streamlit-expert
- "cost" / "savings" / "expensive" → cost-optimization-specialist
- "test" / "quality" / "bug" → data-quality-specialist
- "GitHub" / "repository" / "issue" → github-sleuth-expert
- "ingestion" / "connector" / "dlthub" → dlthub-expert

### Rule 2: Never Try Tools Before Delegating

**WRONG Order**:
1. Try snowsql directly
2. Fail
3. Try dbt-mcp show
4. Fail
5. Finally delegate to snowflake-expert

**CORRECT Order**:
1. Immediately delegate to snowflake-expert
2. Specialist tries snowflake-mcp tools
3. If MCP fails, specialist documents why and uses alternative
4. Return specialist findings

**Exception**: Only use tools directly if:
- Question is NOT domain-specific (e.g., "list files in directory")
- No specialist exists for that domain
- Confidence >0.85 for handling directly

### Rule 3: MCP Tools Are Specialist Territory

**Claude should NOT directly use**:
- snowflake-mcp tools (snowflake-expert uses these)
- dbt-mcp tools (dbt-expert uses these)
- tableau-mcp tools (tableau-expert uses these)
- aws-api tools (aws-expert uses these for domain questions)

**Claude CAN directly use**:
- Read, Grep, Glob, Write, Edit (file operations)
- Bash (for non-domain-specific commands like git)
- TodoWrite, Task (task management)
- github-mcp (if not domain-specific repository analysis)
- slack-mcp (if not domain-specific team communication)

**Gray area** (delegate if domain-specific):
- aws-api for infrastructure questions → Delegate to aws-expert
- dbt-mcp for model questions → Delegate to dbt-expert
- github-mcp for repository investigation → Delegate to github-sleuth-expert

### Rule 4: Document When Specialists Can't Answer

**If specialist hits a blocker** (like snowflake-mcp not working):
- ✅ Specialist documents the issue
- ✅ Specialist provides alternative approach
- ✅ Specialist returns findings to user (even if "can't check, here's why")
- ✅ Claude adds issue to backlog (fix snowflake-mcp, fix network policy, etc.)

**Don't**: Try to work around the specialist by using tools directly

## Enforcement Checklist

**Before responding to user questions, ask**:

1. **Is this a domain-specific question?**
   - Yes → Proceed to #2
   - No → Answer directly with appropriate tools

2. **Do we have a specialist for this domain?**
   - Yes → Proceed to #3
   - No → Answer directly, document gap (maybe create specialist?)

3. **Is my confidence >0.85 for this specific question?**
   - No → DELEGATE to specialist immediately
   - Yes → Consider delegating anyway if specialist would add value

4. **Would specialist provide better answer?**
   - Yes → DELEGATE (higher quality worth token cost)
   - Maybe → DELEGATE (err on side of quality)
   - No → Answer directly (simple factual questions)

## Delegation Pattern Template

**When user asks domain-specific question**:

```markdown
[Immediately recognize domain: Snowflake]
[Check specialist exists: snowflake-expert ✓]
[Confidence <0.60 or specialist would add value]
[Delegate without trying tools first]

Task(
  subagent_type="snowflake-expert",
  description="[Brief task description]",
  prompt="[Complete delegation context with user's question]"
)
```

**After specialist returns**:
```markdown
[Read specialist findings]
[Return answer to user with specialist's analysis]
[If specialist hit blockers, add to backlog and inform user]
```

## Common Violations to Avoid

### Violation 1: Trying Tools Before Delegating
**Don't**:
```
User: "Check Snowflake tasks"
Claude: Tries snowsql → Fails → Tries dbt-mcp → Fails → Delegates
```

**Do**:
```
User: "Check Snowflake tasks"
Claude: Immediately delegates to snowflake-expert
snowflake-expert: Tries snowflake-mcp, documents if fails, provides answer
```

### Violation 2: Using Domain MCP Tools Directly
**Don't**:
```
User: "Optimize this dbt model"
Claude: Uses dbt-mcp to analyze model directly
```

**Do**:
```
User: "Optimize this dbt model"
Claude: Delegates to dbt-expert
dbt-expert: Uses dbt-mcp + expertise to analyze and recommend
```

### Violation 3: Skipping Delegation Because "It's Quick"
**Don't**:
```
User: "What's the best Snowflake warehouse size?"
Claude: "Use MEDIUM warehouse" (guessing)
```

**Do**:
```
User: "What's the best Snowflake warehouse size?"
Claude: Delegates to snowflake-expert (provides context, workload, requirements)
snowflake-expert: Analyzes with snowflake-mcp, recommends with rationale
```

### Violation 4: Not Following Up on Specialist Blockers
**Don't**:
```
snowflake-expert: "Can't check, snowflake-mcp not working"
Claude: "Sorry, can't help" (gives up)
```

**Do**:
```
snowflake-expert: "Can't check, snowflake-mcp not working"
Claude: Documents issue, creates fix task, provides user with manual approach
Claude: Adds snowflake-mcp fix to backlog/todo list
```

## Self-Enforcement Protocol

**At start of each response, mentally check**:
1. Did user ask domain-specific question?
2. Does specialist exist for this domain?
3. Should I delegate immediately?

**Red flags that indicate delegation needed**:
- User mentions specific technology (Snowflake, dbt, AWS, etc.)
- Question requires expertise (optimization, troubleshooting, design)
- Answer would benefit from MCP tool access
- Confidence <0.60 for answering correctly

**Green flags for direct response**:
- Simple factual question (not requiring expertise)
- File operation (read, write, edit, grep)
- Git operation (commit, branch, status)
- General knowledge question (not system-specific)

## Validation Questions (Ask Yourself)

**Before responding, ask**:
- "Would [domain]-expert give a better answer than me?"
  - If YES → Delegate
  - If MAYBE → Delegate (err on quality side)
  - If NO → Answer directly

- "Am I about to use [domain]-mcp tools directly?"
  - If YES → STOP, delegate to [domain]-expert instead
  - If NO → Proceed

- "Did I just fail with a tool and am about to try another approach?"
  - If YES → STOP, delegate to specialist to figure it out
  - If NO → Proceed

## Benefits of Strict Enforcement

**From Week 3-4 testing**:
- **Quality**: 37.5 percentage points higher (100% vs 62.5%)
- **ROI**: 100-500x return (3.35x token cost, massive value)
- **Correctness**: Specialists caught critical bugs (deterministic MERGE)
- **Efficiency**: Specialists know the right approach (no trial-and-error)

**From this snowflake-mcp investigation**:
- snowflake-expert properly investigated (documented all blockers)
- Claude trying snowsql wasted time (wrong approach)
- Specialist found root cause (network policy, config issue)
- Proper delegation would have been faster and more thorough

## Enforcement Mechanism

**Week 7 Addition**: Add pre-response checklist to session protocol

**Before every response**:
```
1. Scan user question for domain keywords
2. If domain keyword found → Check if specialist exists
3. If specialist exists → Delegate immediately (don't try tools first)
4. If no specialist → Answer directly with appropriate tools
```

**Enforcement Level**: MANDATORY
- Not a suggestion
- Not "consider delegating"
- ALWAYS delegate when specialist exists and question is domain-specific

## Example: Correct Delegation Flow

**User**: "Are there failing Snowflake tasks in the last 24 hours?"

**Claude's Thought Process** (Enforce pattern):
```
1. Scan: "Snowflake tasks" → Domain-specific (Snowflake)
2. Check: snowflake-expert exists ✓
3. Confidence: <0.60 for Snowflake task status (need Snowflake expertise)
4. Decision: DELEGATE immediately (don't try snowsql, don't try dbt-mcp)
```

**Claude's Action**:
```
Task(
  subagent_type="snowflake-expert",
  description="Check Snowflake task failures (24hr)",
  prompt="User asked: Are there failing Snowflake tasks in last 24 hours?

  Use snowflake-mcp if available to query task_history.
  If snowflake-mcp not working, document why and provide alternative approach.
  Return: Failed tasks (if any) or confirmation all healthy."
)
```

**Result**: snowflake-expert investigates properly, documents blockers, provides complete answer

## Pattern Application Examples

### Example 1: Snowflake Question
**User**: "What's our Snowflake warehouse utilization?"
**Correct**: Delegate to snowflake-expert → Uses snowflake-mcp → Returns utilization analysis
**Wrong**: Try to query Snowflake directly with snowsql or dbt-mcp

### Example 2: dbt Question
**User**: "Which dbt models are failing tests?"
**Correct**: Delegate to dbt-expert → Uses dbt-mcp → Returns failing models with analysis
**Wrong**: Try dbt-mcp tools directly without specialist context

### Example 3: AWS Question
**User**: "Are our ECS tasks healthy?"
**Correct**: Delegate to aws-expert → Uses aws-api → Returns ECS task health analysis
**Wrong**: Try aws-api commands directly without specialist validation

### Example 4: Cost Question
**User**: "Why is our cloud bill so high?"
**Correct**: Delegate to cost-optimization-specialist → Coordinates with snowflake-expert + aws-expert → Returns comprehensive cost analysis
**Wrong**: Try to analyze costs directly without cross-system optimization expertise

### Example 5: File Question (Direct OK)
**User**: "Show me the contents of app.py"
**Correct**: Use Read tool directly (not domain-specific, no specialist needed)
**Wrong**: Delegate to react-expert just to read a file

## Maintenance and Updates

**Add to this pattern when**:
- New specialists are created (add to trigger keywords)
- New MCP servers integrated (add to tool restrictions)
- Delegation violations observed (add to common violations)
- Better enforcement mechanisms discovered

**Review this pattern**:
- Weekly during MCP architecture transformation
- Monthly after go-live
- Whenever delegation violations occur

---

**Bottom Line**: When user asks about Snowflake, dbt, AWS, Tableau, or any domain with a specialist - DELEGATE FIRST, don't try tools yourself. The specialists are built to handle MCP tool failures gracefully. Your job is to recognize when expertise is needed and delegate appropriately.

**Violation Consequence**: Lower quality answers, wasted effort, missed specialist insights, frustrated users who built the architecture specifically to avoid this behavior.

**Enforcement**: MANDATORY from this point forward. No exceptions without explicit user override.
