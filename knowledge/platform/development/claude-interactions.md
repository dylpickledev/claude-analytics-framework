# Claude Interaction Guide

Complete reference for interacting with Claude in the DA Agent Hub system.

## 💬 Comment Commands

### @claude Mentions

Use `@claude` mentions in GitHub issue comments to trigger AI assistance:

#### **Fix Requests**
```bash
@claude create PR                          # Create pull request with fix
@claude create PR to fix the constraint    # Create PR for specific issue
@claude make a PR for this error          # Alternative phrasing
@claude fix this                          # Simple fix request
```

#### **Investigation Requests**
```bash
@claude investigate                       # General investigation
@claude investigate the data quality      # Specific investigation
@claude analyze this error pattern        # Analysis request
@claude look into the upstream issues     # Upstream analysis
```

#### **Collaborative Discussion**
```bash
@claude what do you think?               # General opinion
@claude what caused this?                # Root cause inquiry
@claude any ideas for fixing this?       # Solution brainstorming
@claude is this related to X?            # Pattern investigation
```

#### **Context-Specific Requests**
```bash
@claude I think this is related to ERP timing, can you check?
@claude This started after the data load, investigate that angle
@claude Check if this affects downstream dashboards
@claude What's the impact on our users?
```

## 🏷️ Label-Based Triggers

Add labels to issues to trigger specific Claude actions:

### Available Labels

| Label | Action | Result |
|-------|--------|--------|
| `claude:fix` | Create PR | Claude creates pull request with fix |
| `claude:investigate` | Deep analysis | Claude performs thorough investigation |
| `claude:collaborate` | Discussion mode | Claude engages in interactive conversation |

### Usage Examples

```bash
# Add labels via GitHub CLI
gh issue edit 123 --add-label "claude:fix"
gh issue edit 123 --add-label "claude:investigate"

# Add labels via GitHub web interface
# Navigate to issue → Labels → Add claude:fix
```

## 👤 Assignment-Based Actions

### Assign to claude[bot]

Assign any issue to `claude[bot]` for automatic analysis and fix attempts:

```bash
# Via GitHub CLI
gh issue edit 123 --assignee "claude[bot]"

# Via GitHub web interface
# Navigate to issue → Assignees → Add claude[bot]
```

### Auto-Fix Behavior

When assigned, Claude will:

1. **Analyze the issue** comprehensively
2. **Assess complexity** and fix appropriateness
3. **Create PR** for simple, safe fixes
4. **Explain reasoning** if manual intervention needed

### Auto-Fix Criteria

✅ **Appropriate for auto-fix:**
- Simple SQL logic corrections
- Test configuration updates
- Missing column additions
- Basic deduplication issues
- Schema adjustments

❌ **Requires manual review:**
- Complex business logic changes
- Schema migrations
- Performance optimizations
- Cross-system integration changes

## 🔄 Multi-Turn Conversations

### Context Retention

Claude maintains conversation context across multiple comments:

```bash
You: @claude investigate this unique constraint issue

Claude: I found duplicate primary keys in the staging model.
The issue is in the bt4_rpt_stock_receipt_reconciliation table.

You: @claude what about the upstream data source?

Claude: Good question! Checking the ERP data ingestion patterns...
I found the source system isn't deduplicating before our ingestion.
```

### Follow-Up Questions

Continue conversations naturally:

```bash
# Building on previous analysis
@claude can you check if this affects other models too?
@claude what would be the performance impact of your suggested fix?
@claude how should we test this change?
@claude create a PR implementing your recommendation
```

## 🧠 Agent Specialization

Claude automatically selects appropriate expert agents based on context:

### Automatic Agent Selection

| Issue Type | Agent Used | Specialization |
|------------|------------|----------------|
| SQL/Model errors | `dbt-expert` | dbt transformations, testing |
| Performance issues | `snowflake-expert` | Query optimization, costs |
| Dashboard problems | `tableau-expert` | Report model analysis |
| Business logic | `business-context` | Requirements validation |
| System architecture | `da-architect` | Cross-platform decisions |
| Data ingestion | `dlthub-expert` | Source system integration |

### Requesting Specific Expertise

You can request specific agent expertise:

```bash
@claude use the snowflake-expert to analyze query performance
@claude have the business-context agent review requirements
@claude get the da-architect's perspective on this design
```

## 📊 Response Types

### Investigation Responses

Claude provides comprehensive analysis including:

- **Root cause identification**
- **Impact assessment**
- **Related issue detection**
- **Historical context**
- **Fix recommendations**
- **Testing strategies**

### PR Creation Responses

When creating PRs, Claude includes:

- **Clear problem description**
- **Solution explanation**
- **Implementation details**
- **Testing requirements**
- **Rollback procedures**
- **Related documentation updates**

### Collaborative Responses

In discussion mode, Claude offers:

- **Interactive problem-solving**
- **Alternative solution exploration**
- **Risk assessment**
- **Implementation guidance**
- **Best practice recommendations**

## ⚡ Performance Tips

### Effective Communication

1. **Be specific**: "Investigate unique constraint in dim_customer" vs. "Look at this"
2. **Provide context**: "This started after ERP upgrade" vs. "Something's broken"
3. **Ask direct questions**: "Create a PR" vs. "What should we do?"
4. **Reference specifics**: "Check the staging model" vs. "Look at the data"

### Optimal Workflow

```bash
# 1. Let Claude investigate first
@claude investigate this test failure

# 2. Review findings and ask follow-ups
@claude what about impact on downstream models?

# 3. Request implementation
@claude create PR implementing the deduplication fix

# 4. Collaborate on refinements
@claude update the PR to include performance tests
```

### Parallel Processing

Use multiple issues/comments for parallel work:

```bash
# Issue A: @claude investigate model performance
# Issue B: @claude check data quality patterns
# Issue C: @claude analyze dashboard load times
```

## 🚨 Troubleshooting Interactions

### Common Issues

| Problem | Symptom | Solution |
|---------|---------|----------|
| No response | Claude doesn't comment | Check workflow triggered properly |
| Incorrect context | Wrong analysis focus | Provide more specific instructions |
| Missing expertise | Generic responses | Request specific agent explicitly |
| Workflow errors | No PR created | Check Claude's error messages |

### Debug Commands

```bash
# Check if workflow triggered
gh run list --limit 5

# View workflow logs
gh run view --log-failed

# Check issue comments
gh issue view 123 --comments
```

### Getting Better Results

1. **Review issue context** - Ensure Claude has sufficient information
2. **Be iterative** - Start with investigation, then request specific actions
3. **Provide feedback** - Let Claude know if responses miss the mark
4. **Use examples** - Reference similar issues or desired outcomes

## 🎯 Best Practices

### For Data Teams

1. **Start with investigation** before requesting fixes
2. **Use specific terminology** relevant to your data stack
3. **Reference related issues** to help Claude understand patterns
4. **Provide business context** when relevant to the technical issue

### For Complex Issues

1. **Break down problems** into specific components
2. **Use multiple interactions** for comprehensive analysis
3. **Leverage different agents** for different perspectives
4. **Document decisions** in follow-up comments

### For Maintenance

1. **Regular health checks**: `@claude analyze system health trends`
2. **Pattern recognition**: `@claude identify recurring issue patterns`
3. **Performance monitoring**: `@claude check model performance trends`
4. **Proactive analysis**: `@claude suggest preventive measures`

---

**Remember**: Claude is designed to be collaborative and helpful. Don't hesitate to ask questions, request clarifications, or iterate on solutions!