# /research Command Protocol

## Purpose
Deep exploration and analysis - either before capturing an idea (pre-capture mode) or analyzing an existing GitHub issue (issue analysis mode). Enables informed decision-making through specialist agent consultation.

## Usage
```bash
# Pre-capture exploration
claude /research "topic to explore in depth"

# Existing issue analysis
claude /research <issue-number>
```

## Two Operating Modes

### Mode 1: Pre-Capture Exploration
**When to use**: You have an idea but want deep analysis before committing to capture it.

**Process**:
1. Claude analyzes the topic with relevant specialist agents
2. Explores feasibility, effort estimates, implementation approaches
3. Identifies potential challenges and alternatives
4. Presents comprehensive findings interactively
5. **Asks user**: "Should I capture this as a GitHub issue?"
   - If yes → Creates issue via `capture.sh`
   - If no → Discussion ends, no issue created

**Output**: Interactive discussion with specialist insights

**Example**:
```bash
/research "Make DA Agent Hub AI-agnostic for Codex CLI and Gemini CLI"
# → Analyzes architecture, effort, approaches
# → Presents findings
# → "Should I capture this as an issue?"
```

### Mode 2: Issue Analysis & Enhancement
**When to use**: GitHub issue exists but needs deeper technical analysis.

**Process**:
1. Fetches issue details from GitHub
2. Analyzes with relevant specialist agents
3. Adds comprehensive findings as GitHub issue comments
4. Updates issue labels based on analysis (if needed)
5. Provides effort estimates and implementation recommendations

**Output**: GitHub comment + terminal summary

**Example**:
```bash
/research 86
# → Reads issue #86
# → Analyzes with data-architect-role
# → Posts detailed findings as issue comment
```

## Agent Selection Strategy

Claude automatically selects appropriate specialist agents based on topic:

| Topic Category | Primary Agent | Supporting Agents |
|----------------|---------------|-------------------|
| Architecture & Platform | data-architect-role | aws-expert, snowflake-expert |
| BI & Analytics | bi-developer-role | tableau-expert, business-analyst-role |
| Data Engineering | data-engineer-role | dlthub-expert, prefect-expert, orchestra-expert |
| Analytics Engineering | analytics-engineer-role | dbt-expert, snowflake-expert |
| UI/UX Development | ui-ux-developer-role | streamlit-expert, react-expert |
| Testing & Quality | qa-engineer-role | qa-coordinator |
| Cross-functional | business-context | documentation-expert |

## Claude Instructions

### Pre-Capture Mode (No Issue Number)

When user runs `/research "topic text"`:

1. **Parse topic**: Identify domain (architecture, BI, data engineering, etc.)
2. **Select agents**: Choose 1-2 most relevant specialist agents
3. **Conduct analysis**:
   - Feasibility assessment
   - Technical approach options
   - Effort estimation (complexity, timeline)
   - Dependencies and prerequisites
   - Risk identification
   - Alternative approaches
4. **Present findings**: Comprehensive but concise summary
5. **Offer capture**: "Should I capture this as a GitHub issue?"
   - Wait for user response
   - If "yes": Run `./scripts/capture.sh "[topic]"`
   - If "no": End discussion

**Response Format**:
```
🔬 Researching: [topic]
🤖 Consulting: [agent-name]

📊 Analysis:

### Feasibility
[Assessment]

### Technical Approaches
1. [Approach 1] - [pros/cons]
2. [Approach 2] - [pros/cons]

### Effort Estimate
- Complexity: [Low|Medium|High]
- Timeline: [estimate]
- Dependencies: [list]

### Risks & Challenges
[Identified risks]

### Recommendation
[Suggested path forward]

💡 Should I capture this as a GitHub issue?
   - Type 'yes' to create issue
   - Type 'no' to end discussion
```

### Issue Analysis Mode (Issue Number Provided)

When user runs `/research <issue-number>`:

1. **Fetch issue**: `gh issue view <issue-number> --json title,body,labels`
2. **Parse content**: Extract issue title and description
3. **Select agents**: Based on issue labels and content
4. **Conduct deep analysis**:
   - Technical approach recommendations
   - Architecture considerations
   - Implementation steps breakdown
   - Effort and complexity assessment
   - Risk analysis
   - Success criteria definition
5. **Post to GitHub**: Add findings as issue comment
6. **Update labels**: Add technical labels if missing (e.g., 'architecture', 'complex')
7. **Terminal summary**: Show what was added

**Response Format**:
```
🔬 Analyzing GitHub Issue #[number]
📋 Issue: [title]
🤖 Consulting: [agent-name]

📊 Deep Analysis Complete

✅ Findings posted to GitHub issue
🔗 Comment: https://github.com/[org]/[repo]/issues/[number]#issuecomment-[id]

🏷️  Labels updated: [any new labels added]

📝 Summary:
- Complexity: [assessment]
- Recommended approach: [summary]
- Key considerations: [highlights]

💡 Ready to build? Run: /start [number]
```

## GitHub Comment Format (Issue Analysis Mode)

When posting to GitHub issues, use this structure:

```markdown
## 🔬 Research Analysis

**Analyzed by**: AI Agent Hub
**Date**: YYYY-MM-DD
**Specialist**: [agent-name]

### Technical Approach

[Detailed implementation recommendations]

### Architecture Considerations

[System design implications]

### Implementation Steps

1. [Step 1]
2. [Step 2]
3. [Step 3]

### Effort Estimate

- **Complexity**: [Low|Medium|High]
- **Estimated Timeline**: [timeframe]
- **Dependencies**: [list]

### Risks & Mitigation

- **Risk 1**: [description] → [mitigation]
- **Risk 2**: [description] → [mitigation]

### Success Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

### Recommended Next Steps

1. [Action 1]
2. [Action 2]

---
*Generated by DA Agent Hub `/research` command*
```

## Integration with ADLC Workflow

```
💭 Brainstorm idea
    ↓
🔬 /research "topic" → Deep analysis
    ↓ Decision point
💡 /capture "topic" → Create issue (or captured during research)
    ↓
🗺️ Use GitHub for prioritization
    ↓
🔬 /research <issue#> → Technical deep-dive (optional but recommended)
    ↓
🚀 /start <issue#> → Begin development
    ↓
✅ /complete → Finish project
```

## When to Use /research vs /capture

| Scenario | Use |
|----------|-----|
| Quick thought, obvious value | `/capture` directly |
| Complex idea, unclear feasibility | `/research` first, then decide |
| Existing issue needs analysis | `/research <issue#>` |
| Strategic planning session | `/research` multiple topics |
| Before `/start` on complex issue | `/research <issue#>` for prep |

## Success Criteria

### Pre-Capture Mode
- [ ] Specialist agents consulted appropriately
- [ ] Comprehensive analysis provided
- [ ] Clear recommendation presented
- [ ] User decision captured (capture or not)
- [ ] If captured, issue created successfully

### Issue Analysis Mode
- [ ] GitHub issue fetched successfully
- [ ] Deep analysis conducted with specialists
- [ ] Findings posted as GitHub comment
- [ ] Labels updated appropriately
- [ ] Terminal summary provided
- [ ] Clear next steps identified

## Examples

### Example 1: Pre-Capture Architecture Research
```bash
/research "Create adapter layer for AI-agnostic agent hub supporting multiple CLI tools"
# → data-architect-role analysis
# → Architecture patterns explored
# → Effort estimated
# → "Should I capture this?" → User decides
```

### Example 2: Issue Deep-Dive Before Building
```bash
/research 86
# Issue #86: "Implement real-time customer churn prediction"
# → analytics-engineer-role + data-engineer-role analysis
# → Implementation steps posted to issue
# → Complexity and timeline estimated
# → Ready for /start 86
```

### Example 3: Strategic Technology Evaluation
```bash
/research "Evaluate dlthub vs Airbyte for customer data ingestion"
# → data-engineer-role + dlthub-expert analysis
# → Side-by-side comparison
# → Recommendation with rationale
# → "Should I capture decision as issue?"
```

---

*ADLC-aligned research and analysis - informed decision-making through specialist agent consultation.*
