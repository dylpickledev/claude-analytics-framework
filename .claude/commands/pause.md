# /pause Command Protocol

## Purpose
Save conversation context to resume later. Captures current work state, decisions made, next steps, and conversation details for seamless continuation in future sessions.

## Usage
```bash
# Pause current conversation with auto-generated context
claude /pause

# Pause with custom context description
claude /pause "working on ETL pipeline refactoring, need to validate approach with team"

# Pause active project work
claude /pause [project-name]
```

## Protocol

### 1. Capture Conversation Context
Claude automatically extracts and saves:
- **Current task/goal**: What you're working on
- **Progress made**: What's been accomplished this session
- **Decisions made**: Key choices and rationale
- **Next steps**: Where to pick up next time
- **Blockers/questions**: Issues needing resolution
- **Relevant file paths**: Files discussed or modified
- **Agent context**: Which specialist agents were involved

### 2. Save to Context File

**Project-first approach**:
- **If active project exists**: `projects/active/[project-name]/paused-contexts/YYYY-MM-DD-HH-MM-[description].md`
- **Otherwise**: `.claude/paused-contexts/YYYY-MM-DD-HH-MM-[description].md`

**File structure**:
```markdown
# Paused Context: [Brief Description]

**Date**: YYYY-MM-DD HH:MM
**Session Duration**: [estimated duration]
**Primary Focus**: [main topic/goal]

## Current Task

[What you were working on]

## Progress Made

- [Accomplishment 1]
- [Accomplishment 2]
- [Accomplishment 3]

## Decisions Made

1. **Decision**: [description]
   - **Rationale**: [why]
   - **Implications**: [impact]

## Next Steps

- [ ] [Action 1]
- [ ] [Action 2]
- [ ] [Action 3]

## Blockers & Questions

- [Blocker 1]
- [Question 1]

## Relevant Files

- `path/to/file1.py` - [why relevant]
- `path/to/file2.sql` - [why relevant]

## Agents Involved

- **[agent-name]**: [what they helped with]

## Context for Resume

[Additional context needed to resume seamlessly]

## Conversation Summary

**Total exchanges**: [number]
**Key topics**: [topic1, topic2, topic3]

---
*Paused via `/pause` command - resume with: "Continue from [filename]"*
```

### 3. Project Detection & Context Location

**Automatic project detection**:
1. Check for active projects in `projects/active/`
2. If project exists, use project-specific location
3. Otherwise, use global `.claude/paused-contexts/`

**If pausing within an active project**:
- **Primary location**: `projects/active/[project-name]/paused-contexts/YYYY-MM-DD-HH-MM-[description].md`
- **Update context.md**: Append pause reference to project's context file
- **Git-tracked**: Project pauses are committed with project work
- **Benefit**: All project context in one place

**If no active project**:
- **Fallback location**: `.claude/paused-contexts/YYYY-MM-DD-HH-MM-[description].md`
- **Gitignored**: Personal conversation contexts remain private
- **Benefit**: General work contexts don't clutter project directories

## Claude Instructions

When user runs `/pause [optional-description]`:

1. **Detect active project**:
   - Check `projects/active/` for current project
   - Look for project matching current git branch
   - Or detect from recent file access patterns

2. **Analyze current conversation**:
   - Identify main topic/goal
   - Extract key progress points
   - List decisions made with rationale
   - Identify next steps
   - Note any blockers or questions
   - Collect relevant file paths mentioned
   - List specialist agents used

3. **Generate context description**:
   - If user provided description, use it
   - Otherwise, auto-generate from conversation topic
   - Keep brief (3-5 words)

4. **Determine save location**:
   - **If project found**: `projects/active/[project-name]/paused-contexts/`
   - **If no project**: `.claude/paused-contexts/`
   - Create directory if it doesn't exist

5. **Create paused context file**:
   - Filename: `YYYY-MM-DD-HH-MM-[description].md`
   - Full structured content as shown above

6. **If project-specific pause**:
   - Update project's `context.md` with pause reference
   - Ensure paused-contexts directory exists
   - Context is git-tracked with project

7. **If global pause**:
   - Save to `.claude/paused-contexts/`
   - Context is gitignored (personal/private)
   - Update global README index

8. **Provide resume instructions**:
   - Show how to resume the conversation
   - Indicate where context was saved
   - Suggest next actions

### Response Format
```
⏸️  Pausing conversation...

📊 Session Summary:
   • Focus: [main topic]
   • Duration: [estimated time]
   • Progress: [key accomplishments]
   • Agents used: [agent-name, agent-name]

💾 Context saved to:
   [PROJECT MODE]
   projects/active/feature-customer-pipeline/paused-contexts/2025-10-07-14-30-etl-pipeline-refactor.md
   projects/active/feature-customer-pipeline/context.md (updated)

   [OR GLOBAL MODE]
   .claude/paused-contexts/2025-10-07-14-30-etl-pipeline-refactor.md

🔄 To resume:
   [PROJECT MODE]
   1. Open: projects/active/feature-customer-pipeline/paused-contexts/2025-10-07-14-30-etl-pipeline-refactor.md
   2. Say: "Continue project feature-customer-pipeline"
   3. Or: "Resume from 2025-10-07-14-30-etl-pipeline-refactor.md"

   [GLOBAL MODE]
   1. Open: .claude/paused-contexts/2025-10-07-14-30-etl-pipeline-refactor.md
   2. Say: "Continue from 2025-10-07-14-30-etl-pipeline-refactor.md"
   3. Or reference specific topic from the context file

💡 Quick resume options:
   • "Continue project [project-name]" (if project mode)
   • "Resume from where we left off on [topic]"
   • "Continue [description] work"

✅ Context preserved successfully!
```

## Resume Protocol

When resuming from paused context:

**User says**: "Continue from [filename]" or "Resume [topic]"

**Claude should**:
1. Read the paused context file
2. Summarize where you left off
3. Confirm next steps
4. Ask if user wants to continue with those steps or adjust

**Claude response**:
```
▶️  Resuming from: [filename]

📋 Where we left off:
   • Working on: [task]
   • Progress: [summary]
   • Next planned: [next steps]

🎯 Ready to continue with:
   1. [Next step 1]
   2. [Next step 2]

Should we proceed with these steps, or would you like to adjust the plan?
```

## Integration with Projects

### Project-First Context Storage

**Active Project Detected**:
- **Primary location**: `projects/active/[project-name]/paused-contexts/YYYY-MM-DD-HH-MM-[description].md`
- **Git-tracked**: Pauses committed with project work for team collaboration
- **Updates**: Appends reference to `context.md`
- **Benefit**: All project context in one place, team-visible

**No Active Project**:
- **Fallback location**: `.claude/paused-contexts/YYYY-MM-DD-HH-MM-[description].md`
- **Gitignored**: Personal contexts remain private
- **Benefit**: General exploration doesn't clutter project directories

### Detection Logic

Claude determines active project by:
1. **Git branch name**: Matching `projects/active/[branch-name]/`
2. **Recent file access**: Files modified in `projects/active/[project-name]/`
3. **Explicit detection**: Looks for `projects/active/*/spec.md` with recent activity

### Resume with Project Context
When resuming project work:
```bash
"Continue project [project-name]"
# → Reads project paused contexts
# → Loads project spec.md and context.md
# → Full project context restoration

"Resume from 2025-10-07-14-30-etl-pipeline-refactor.md"
# → Searches both project and global paused contexts
# → Loads appropriate context file
```

## Success Criteria
- [ ] Conversation context comprehensively captured
- [ ] Key decisions documented with rationale
- [ ] Next steps clearly identified
- [ ] Paused context file created with timestamp
- [ ] If project active, checkpoint created and context.md updated
- [ ] Clear resume instructions provided
- [ ] File paths and agent context preserved

## Examples

### Example 1: Pause General Work
```bash
/pause
# Auto-detects: "working on dbt model optimization"
# Saves: .claude/paused-contexts/2025-10-07-14-30-dbt-model-optimization.md
```

### Example 2: Pause with Description (No Active Project)
```bash
/pause "ETL pipeline approach - need team validation before proceeding"
# No active project detected
# Saves: .claude/paused-contexts/2025-10-07-14-30-etl-pipeline-approach.md
# Gitignored: Personal exploration context
```

### Example 3: Pause Active Project
```bash
/pause
# Auto-detects: "feature-customer-churn" project is active
# Saves to: projects/active/feature-customer-churn/paused-contexts/2025-10-07-14-30-working-on-model.md
# Updates: projects/active/feature-customer-churn/context.md
# Git-tracked: Team can see pause context
```

### Example 4: Resume Later
```bash
"Continue from 2025-10-07-14-30-etl-pipeline-approach.md"
# → Claude reads context, summarizes, and continues
```

## Best Practices

### When to Use /pause
- **End of work session**: Save progress before closing
- **Context switch needed**: Moving to different task/project
- **Waiting for feedback**: Need stakeholder input before proceeding
- **Blocker encountered**: Technical issue requiring research
- **Long-running research**: Multi-session investigation
- **Handoff to team member**: Preserving context for collaboration

### What Gets Captured
- **DO capture**: Decisions, rationale, next steps, blockers, progress
- **DO capture**: File paths, agent usage, key insights
- **DO capture**: Questions for stakeholders, technical concerns
- **DON'T capture**: Sensitive data, credentials, private information

## Directory Structure

### Project-Specific Pauses (Git-Tracked)
```
projects/active/feature-customer-pipeline/
├── spec.md
├── context.md (references pauses)
├── paused-contexts/
│   ├── 2025-10-07-14-30-working-on-model.md
│   ├── 2025-10-08-09-15-testing-approach.md
│   └── README.md (project pause index)
└── tasks/
```

### Global Pauses (Gitignored)
```
.claude/paused-contexts/
├── 2025-10-07-14-30-dbt-exploration.md
├── 2025-10-07-15-45-research-ideas.md
├── 2025-10-08-09-15-general-questions.md
└── README.md (global pause index)
```

**README.md in each location** auto-maintained with:
- List of all paused contexts in that location
- Sorted by date (newest first)
- Quick links to resume
- Status (resumed/active/abandoned)

---

*Seamless context preservation and resumption - never lose your place in complex work.*
