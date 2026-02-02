# /build Command Protocol

⚠️ **DEPRECATED**: This command has been renamed to `/start` for better semantics. Please use `/start` instead.

This command still works but will redirect to `/start`.

---

## Purpose
Begin development on ideas from GitHub Issues as complete projects. **Use `/start` instead - action-oriented, clearer intent.**

Implements ADLC Develop + Test + Deploy phases with specialist agent coordination and full project management integration.

## Usage
```bash
claude /build <issue-number>
```

## Protocol

### 1. Execute build.sh Script
```bash
./scripts/build.sh <issue-number>
```

### 2. Complete Project Creation Workflow
- **Fetches GitHub issue**: Retrieves idea details from issue number
- **Creates project structure**: Integrates with `work-init.sh` for full project setup
- **Links issue to project**: Adds comment to issue with project location
- **Updates issue labels**: Adds 'in-progress' label to track status
- **Provides development guidance**: Next steps for implementation

## Claude Instructions

When user runs `/build <issue-number>`:

1. **Validate issue exists**: Check that issue number is valid and preferably has 'idea' label
2. **Execute the script**: Run `./scripts/build.sh <issue-number>`
3. **Validate structure**: Confirm project directory and files created properly
4. **Guide development**: Explain specialist agent coordination and next steps

### Response Format
```
🔧 Building project from GitHub issue #[number]
📋 Issue: [title]
🏗️  Creating project structure: [project-name]
✅ Project structure created
🔗 Linking project to GitHub issue...

✅ Project successfully created from issue #[number]!
📁 Project location: projects/active/[project-name]/
🔗 Linked to: https://github.com/[org]/[repo]/issues/[number]

🎯 Next steps:
   1. Review project spec: projects/active/[project-name]/spec.md
   2. Begin development work
   3. Update issue #[number] with progress comments
   4. When complete: ./scripts/finish.sh [project-name]
```

## Integration with ADLC
- **ADLC Develop Phase**: Human-readable code with specialist agent guidance
- **ADLC Test Phase**: Quality assurance through agent coordination
- **ADLC Deploy Phase**: Integration with existing CI/CD workflows
- **Cross-layer context**: Maintains links from GitHub issue through operations
- **Team visibility**: All team members can track progress via GitHub issue

## Project Structure Created
```
projects/active/feature-[project-name]/
├── README.md           # Navigation hub with progress tracking
├── spec.md            # Project specification from GitHub issue
├── context.md         # Dynamic state tracking
└── tasks/             # Agent coordination directory
    ├── current-task.md     # Current agent assignments
    └── [tool]-findings.md  # Detailed agent findings
```

## GitHub Integration Features

### Automatic Issue Linking
- **Comment added to issue**: Links project location and structure
- **Label management**: Adds 'in-progress' label automatically
- **Bidirectional tracking**: Project spec links back to source issue
- **Progress updates**: Team can comment on issue throughout development

### Issue-to-Project Lifecycle
```
GitHub Issue (#[number])
    ↓ /build <issue-number>
Project Created (projects/active/feature-[name]/)
    ↓ Development work
Progress Comments on Issue
    ↓ /finish [project-name]
Issue Closed & Project Archived
```

## Specialist Agent Coordination
The build process enables access to:
- **analytics-engineer-role**: SQL transformations, model optimization, test development
- **data-engineer-role**: Pipeline setup, orchestration, source integration
- **bi-developer-role**: Dashboard development, report model analysis
- **ui-ux-developer-role**: Streamlit/React applications, user experience
- **business-analyst-role**: Requirements gathering, stakeholder alignment
- **data-architect-role**: System design, data flow analysis, strategic decisions
- **qa-engineer-role**: Testing strategies, data quality validation
- **project-manager-role**: Delivery coordination, UAT frameworks

## Examples

### Example 1: BI Dashboard from Issue
```bash
claude /build 85
# Issue #85: "Create executive KPI dashboard with real-time metrics"
# → Creates: projects/active/feature-create-executive-kpi-dashboard-w/
```

### Example 2: Data Pipeline from Issue
```bash
claude /build 86
# Issue #86: "Implement real-time customer data pipeline"
# → Creates: projects/active/feature-implement-real-time-customer-da/
```

### Example 3: Architecture from Issue
```bash
claude /build 87
# Issue #87: "Evaluate Snowflake cost optimization strategies"
# → Creates: projects/active/feature-evaluate-snowflake-cost-optimi/
```

## Success Criteria
- [ ] GitHub issue fetched successfully
- [ ] Complete project structure created with all required files
- [ ] Issue linked to project with comment and labels
- [ ] Development guidance provided for next steps
- [ ] Specialist agent coordination enabled

## Development Workflow
After project creation:
1. **Review spec.md**: Understand requirements from GitHub issue
2. **Coordinate with agents**: Use specialist agents for domain expertise
3. **Implement iteratively**: Follow ADLC Develop/Test cycles
4. **Update GitHub issue**: Post progress comments and blockers
5. **Deploy with quality**: Ensure testing and review before deployment
6. **Complete project**: Use `/finish [project-name]` when done (closes issue)

## Viewing Available Ideas

### List All Ideas
```bash
gh issue list --label idea --state open
```

### Filter by Category
```bash
gh issue list --label idea --label bi-analytics
gh issue list --label idea --label data-engineering
gh issue list --label idea --label architecture
```

## Error Handling
- **Issue not found**: Clear error message with instructions to check issue number
- **Missing 'idea' label**: Warning but proceeds anyway (any issue can become a project)
- **Project creation fails**: Falls back to basic structure if `work-init.sh` unavailable
- **Missing dependencies**: Provides clear error messages and resolution steps

---

*Complete ADLC Develop + Test + Deploy implementation - from GitHub issue to production-ready project.*
