# /start Command Protocol

## Purpose
Begin development on ideas - either from existing GitHub issues or by creating an issue automatically from text. The primary command for starting work. Implements ADLC Develop + Test + Deploy phases with specialist agent coordination.

## Usage
```bash
# Start from existing issue
claude /start <issue-number>

# Create issue and start immediately
claude /start "your idea description"
```

## Protocol

### 1. Determine Input Type
- **If numeric**: Treats as existing issue number
- **If text**: Creates GitHub issue first (via `idea.sh`), then proceeds

### 2. Execute start.sh Script
```bash
./scripts/start.sh <issue-number-or-text>
```

### 3. Complete Project Creation Workflow
- **Fetches/Creates GitHub issue**: Gets or creates issue with idea details
- **Creates project structure**: Integrates with `work-init.sh` for full project setup
- **Creates git worktree**: Isolated development environment (if worktrees configured)
- **Links issue to project**: Adds comment to issue with project location
- **Updates issue labels**: Adds 'in-progress' label to track status
- **Provides development guidance**: Next steps for implementation

## Claude Instructions

When user runs `/start <issue-number-or-text>`:

1. **Determine input type**: Check if numeric (issue#) or text (new idea)
2. **Execute the script**: Run `./scripts/start.sh "<input>"`
   - If text: Script creates issue first, then proceeds
   - If number: Script uses existing issue
3. **Validate structure**: Confirm project directory and files created properly
4. **Guide development**: Explain specialist agent coordination and next steps

### Response Format (Starting from Existing Issue)
```
🚀 Starting project from GitHub issue #[number]
📋 Issue: [title]
🏗️  Creating project structure: [project-name]
✅ Project structure created
🔗 Linking project to GitHub issue...

✅ Project successfully created from issue #[number]!
📁 Project location: projects/active/[project-name]/
🔗 Linked to: https://github.com/[org]/[repo]/issues/[number]

🎯 Next steps:
   1. Review project spec: projects/active/[project-name]/spec.md
   2. Begin development work with specialist agents
   3. Update issue #[number] with progress comments
   4. When complete: /complete [project-name]
```

### Response Format (Starting from Text/New Idea)
```
💡 Creating GitHub issue for: [idea text]
✅ Created issue #[number]

🚀 Starting project from GitHub issue #[number]
📋 Issue: [title]
🏗️  Creating project structure: [project-name]
✅ Project structure created
🔗 Linking project to GitHub issue...

✅ Project successfully created!
📁 Project location: projects/active/[project-name]/
🔗 Linked to: https://github.com/[org]/[repo]/issues/[number]

🎯 Next steps:
   1. Review project spec: projects/active/[project-name]/spec.md
   2. Begin development work with specialist agents
   3. Update issue #[number] with progress comments
   4. When complete: /complete [project-name]
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

## Git Worktree Integration
If worktrees are configured (via `/setup-worktrees`):
- **Isolated environment**: Each project gets dedicated worktree
- **Clean context**: No interference between projects
- **VS Code integration**: Automatic workspace switching
- **Branch management**: Feature branches auto-created

*See `knowledge/da-agent-hub/development/vscode-worktree-integration.md` for details*

## GitHub Integration Features

### Automatic Issue Linking
- **Comment added to issue**: Links project location and structure
- **Label management**: Adds 'in-progress' label automatically
- **Bidirectional tracking**: Project spec links back to source issue
- **Progress updates**: Team can comment on issue throughout development

### Issue-to-Project Lifecycle
```
GitHub Issue (#[number])
    ↓ /start [number]
Project Created (projects/active/feature-[name]/)
    ↓ Development work
Progress Comments on Issue
    ↓ /complete [project-name]
Issue Closed & Project Archived
```

## Specialist Agent Coordination
The start process enables access to:
- **analytics-engineer-role**: SQL transformations, model optimization, test development
- **data-engineer-role**: Pipeline setup, orchestration, source integration
- **bi-developer-role**: Dashboard development, report model analysis
- **ui-ux-developer-role**: Streamlit/React applications, user experience
- **business-analyst-role**: Requirements gathering, stakeholder alignment
- **data-architect-role**: System design, data flow analysis, strategic decisions
- **qa-engineer-role**: Testing strategies, data quality validation
- **project-manager-role**: Delivery coordination, UAT frameworks

## Examples

### Example 1: Start from Existing Issue
```bash
/start 85
# Issue #85 already exists: "Create executive KPI dashboard with real-time metrics"
# → Fetches issue → Creates: projects/active/feature-create-executive-kpi-dashboard-w/
```

### Example 2: Start from New Idea (Auto-creates Issue)
```bash
/start "Implement real-time customer data pipeline"
# → Creates issue #123 → Creates: projects/active/feature-implement-real-time-customer-da/
```

### Example 3: Quick Start (No Prior Issue Needed)
```bash
/start "Build customer churn prediction model"
# → Creates issue #124 → Sets up complete project structure → Ready to develop
```

### Example 4: Complex Project from Issue
```bash
/start 87
# Issue #87: "Evaluate Snowflake cost optimization strategies" (with research analysis)
# → Fetches issue with analysis → Creates project with context
```

## Best Practices

### Before Starting
1. **Review issue**: Ensure requirements are clear
2. **Consider research**: Run `/research [number]` for complex issues
3. **Check dependencies**: Verify prerequisites are met
4. **Plan approach**: Think through implementation strategy

### During Development
1. **Use specialist agents**: Leverage domain expertise
2. **Update issue comments**: Keep team informed of progress
3. **Commit frequently**: Small, atomic commits
4. **Test continuously**: Don't wait until the end

### Before Completing
1. **Verify requirements**: All success criteria met
2. **Run tests**: Ensure quality standards
3. **Document learnings**: Capture patterns and insights
4. **Prepare for review**: Clean code, clear commits

## Success Criteria
- [ ] GitHub issue fetched/created successfully
- [ ] Complete project structure created with all required files
- [ ] Git worktree created (if configured)
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
6. **Complete project**: Use `/complete [project-name]` when done (closes issue)

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

### Sort by Priority
```bash
gh issue list --label idea --sort created --order desc
gh issue list --label idea --sort updated --order desc
```

## Error Handling
- **Issue not found**: Clear error message with instructions to check issue number
- **Missing 'idea' label**: Warning but proceeds anyway (any issue can become a project)
- **Project creation fails**: Falls back to basic structure if `work-init.sh` unavailable
- **Missing dependencies**: Provides clear error messages and resolution steps

---

*Complete ADLC Develop + Test + Deploy implementation - from GitHub issue to production-ready project.*
