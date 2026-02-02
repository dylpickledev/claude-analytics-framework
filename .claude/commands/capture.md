# /capture Command Protocol

## Purpose
Quick idea capture using GitHub Issues for ADLC Plan phase. Creates trackable GitHub issues that connect ideation directly to project execution.

## Usage
```bash
claude /capture "idea description"
```

## Protocol

### 1. Execute capture.sh Script
```bash
./scripts/capture.sh "[idea]"
```

### 2. Automatic GitHub Issue Creation
- **Creates GitHub issue**: Idea stored as issue with appropriate labels
- **Auto-labeling**: Intelligently categorizes ideas (bi-analytics, data-engineering, analytics-engineering, architecture, ui-development, general)
- **ADLC tracking**: Issues tagged with 'idea' label for roadmap planning
- **Next step guidance**: Clear path to roadmap and build commands

## Claude Instructions

When user runs `/capture [idea]`:

1. **Execute the script**: Run `./scripts/capture.sh "[idea]"`
2. **Monitor output**: Display script progress and GitHub issue creation
3. **Provide guidance**: Show next steps from script output

### Response Format
```
💡 Capturing idea...
📝 Idea: [idea description]

✅ GitHub issue created successfully!
🔗 Issue #[number]: [URL]

🎯 Next steps:
   1. View issue: gh issue view [number]
   2. Deep analysis: /research [number]
   3. Start development: /start [number]

💡 Use GitHub's native issue management for prioritization and roadmap planning
```

## Integration with ADLC
- **ADLC Plan Phase**: Business case validation and implementation planning
- **GitHub Issues integration**: Ideas become trackable, commentable, and linkable
- **Seamless workflow**: Direct path from issue to project via `/build <issue-number>`
- **Team visibility**: All team members can see and prioritize ideas

## GitHub Issue Labels

### Automatic Labeling
- **idea**: All captured ideas (enables filtering)
- **bi-analytics**: Dashboard, visualization, Tableau, Power BI projects
- **data-engineering**: Pipeline, ETL, ingestion, orchestration work
- **analytics-engineering**: dbt models, transformations, SQL work
- **architecture**: Platform, infrastructure, AWS, Snowflake architecture
- **ui-development**: Streamlit, React, frontend applications
- **general**: Ideas not matching specific categories

## Examples

### Example 1: BI Dashboard Idea
```bash
claude /capture "Create executive KPI dashboard with real-time metrics"
# → Creates issue with labels: idea, bi-analytics
```

### Example 2: Data Engineering Idea
```bash
claude /capture "Implement real-time customer data pipeline from Salesforce"
# → Creates issue with labels: idea, data-engineering
```

### Example 3: Architecture Idea
```bash
claude /capture "Evaluate Snowflake cost optimization strategies"
# → Creates issue with labels: idea, architecture
```

## Workflow Integration

### From Idea Capture to Project
```
/capture → GitHub Issue Created (#123)
    ↓
/research 123 → Deep analysis (optional)
    ↓
Use GitHub for prioritization (labels, milestones, projects)
    ↓
/start 123 → Create project from issue
    ↓
Development → Project work with agent coordination
    ↓
/complete → Complete project, close linked issue
```

## Success Criteria
- [ ] GitHub issue created successfully
- [ ] Appropriate labels automatically applied
- [ ] Issue description includes ADLC context
- [ ] Clear next step guidance provided
- [ ] Issue URL returned for reference

## Viewing and Managing Ideas

### List All Ideas
```bash
gh issue list --label idea
```

### Filter by Category
```bash
gh issue list --label idea --label bi-analytics
gh issue list --label idea --label data-engineering
gh issue list --label idea --label architecture
```

### Search Ideas
```bash
gh issue list --label idea --search "dashboard"
gh issue list --label idea --state open
```

---

*Streamlined ADLC Plan phase implementation - from brainstorm to GitHub-tracked execution plan.*
