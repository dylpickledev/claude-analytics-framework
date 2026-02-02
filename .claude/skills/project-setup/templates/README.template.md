# {project_title}

**Created**: {date}
**Status**: Planning
**Type**: {project_type}
{issue_link}

## Overview

{description}

## Project Structure

```
projects/active/{project_name}/
├── README.md          # This file - navigation and progress
├── spec.md           # Project requirements and goals
├── context.md        # Current working state
└── tasks/            # Agent coordination
    ├── current-task.md
    └── *-findings.md
```

## Quick Links

### Documentation
- [Project Specification](./spec.md) - Requirements and implementation plan
- [Working Context](./context.md) - Current state and decisions
- [Task Tracking](./tasks/current-task.md) - Agent assignments

### Related Resources
- ADLC Workflow: See main [CLAUDE.md](../../../CLAUDE.md)
- Patterns: `.claude/rules/` and `.claude/skills/reference-knowledge/`
- Agents: `.claude/agents/`

## Progress Summary

### Phase 1: Planning
- [ ] Requirements gathered and documented in spec.md
- [ ] Technical approach defined
- [ ] Success criteria established

### Phase 2: Implementation
- [ ] Core functionality implemented
- [ ] Tests written and passing
- [ ] Documentation updated

### Phase 3: Completion
- [ ] Code reviewed
- [ ] PR created and merged
- [ ] Knowledge extracted to patterns

## Key Decisions

_Document important architectural or implementation decisions here as they are made_

## Notes

_Additional context, learnings, or observations during project development_

---

**Navigation**: Use `/switch` to move between projects
**Complete**: Use `/complete {project_name}` when finished
