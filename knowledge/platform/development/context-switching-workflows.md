# Context Switching for Analytics Development

## Overview

The DA Agent Hub context switching system enables seamless transitions between different analytics projects while preserving work and maintaining development continuity. This system implements zero-loss project switching with automated work preservation and state management.

## Context

Context switching is critical in analytics development environments where:
- Multiple projects run simultaneously with different priorities
- Urgent issues require immediate attention while preserving current work
- Team collaboration requires clean repository states
- Development contexts need fresh starts for optimal AI assistance

## Architecture

### Core Components

#### 1. Switch Command Integration
- **Command File**: `.claude/commands/switch.md` - Protocol documentation
- **Implementation Script**: `scripts/switch.sh` - Technical execution
- **ADLC Integration**: Seamless workflow transitions across development phases

#### 2. Automated Work Preservation
```
Current Work → Auto-Commit → Remote Push → Main Branch Sync → New Context
     ↓              ↓             ↓              ↓              ↓
Stage All      Generate      Preserve      Clean State    Ready for
Changes        Message       Remotely      Locally        New Work
```

#### 3. Context-Aware State Management
- **Branch Type Detection**: Automatic classification of work types
- **Commit Message Generation**: Context-appropriate preservation messages
- **Remote Synchronization**: Team visibility and backup assurance
- **Clean State Preparation**: Main branch readiness for new work

## Implementation Patterns

### Automated Git Workflow Management

#### Commit Message Generation Strategy
**Branch Pattern Recognition**:
```bash
# Feature branches → "feat:" prefix
if [[ $BRANCH =~ ^feature/ ]]; then
    COMMIT_TYPE="feat"
    WORK_TYPE="feature"

# Fix branches → "fix:" prefix
elif [[ $BRANCH =~ ^fix/ ]]; then
    COMMIT_TYPE="fix"
    WORK_TYPE="fix"

# Research branches → "docs:" prefix
elif [[ $BRANCH =~ ^research/ ]]; then
    COMMIT_TYPE="docs"
    WORK_TYPE="research"

# Default → "chore:" prefix
else
    COMMIT_TYPE="chore"
    WORK_TYPE="work"
fi
```

**Auto-Generated Commit Format**:
```
{type}: Save current progress on {work description}

Work in progress - switching to different task/project.
Current state preserved for future continuation.

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

#### Branch Management Automation
**Work Preservation Workflow**:
1. **Automatic Staging**: All changes staged with `git add .`
2. **Context-Aware Commit**: Generated message based on branch type and work description
3. **Remote Push**: Ensures work is preserved remotely for team access and backup
4. **Main Branch Sync**: Clean return to main with latest changes
5. **Optional Target Branch**: Switch to specified branch if provided

### Integration with ADLC Phases

#### ADLC Phase Transitions
- **Plan → Develop**: Clean context for implementation work
- **Develop → Test**: State preservation during testing phases
- **Test → Deploy**: Seamless transitions during deployment
- **Deploy → Operate**: Clean handoff to operations monitoring

#### Project Management Integration
```
Active Project → Context Switch → Preserved Branch → Resume Capability
      ↓               ↓                ↓                    ↓
  Current Work    Auto-Archive    Remote Backup      Simple Return
```

## Usage Patterns

### Basic Context Switching
```bash
# Save current work and switch to main
claude /switch

# Save current work and switch to specific branch
claude /switch feature-customer-dashboard

# Resume previous work
claude /switch previous-branch-name
```

### Integration with 4-Command Workflow
```bash
# Capture new idea while preserving current work
claude /switch
claude /capture "New urgent idea"

# Switch to roadmap planning context
claude /switch
claude /roadmap quarterly

# Begin new project implementation
claude /switch
claude /build high-priority-project

# Complete current project and switch contexts
claude /complete current-project
claude /switch next-project-branch
```

## Team Collaboration Patterns

### Work Visibility Strategy
- **Remote Branch Push**: All work automatically available to team
- **Review Readiness**: Committed work ready for PR creation
- **Conflict Avoidance**: Clean main branch reduces merge issues
- **Knowledge Sharing**: Preserved work enables collaboration

### Resume Capability
```bash
# List available work branches
git branch -r | grep origin | grep -E "(feature|fix|research)"

# Simple resume command
./scripts/switch.sh [previous-branch-name]

# Check work status after resume
git log --oneline -5
git status
```

## Error Handling & Recovery

### Common Scenarios

#### Uncommitted Changes
- **Detection**: `git diff-index --quiet HEAD --` check
- **Resolution**: Automatic staging and commit with preservation message
- **Recovery**: Work preserved with clear restoration instructions

#### Remote Connectivity Issues
```bash
# Graceful degradation
if ! git push origin "$BRANCH" 2>/dev/null; then
    echo "⚠️ Remote push failed - work preserved locally"
    echo "Manual push required: git push origin $BRANCH"
fi
```

#### Branch Conflicts
- **Local Branch Exists**: Checkout existing branch and pull latest
- **Remote Branch Exists**: Create local tracking branch from remote
- **Branch Not Found**: Clear error message with available options

### Recovery Procedures

#### Work Recovery After Failed Switch
```bash
# Check work status
git status
git stash list

# Recover uncommitted changes
git stash pop

# Resume interrupted switch
./scripts/switch.sh [target-branch]
```

## Performance Considerations

### Optimization Strategies
- **Minimal Network Calls**: Single push operation per switch
- **Efficient Git Operations**: Streamlined command sequences
- **Error Prevention**: Pre-validation of git repository state
- **Clean Exit**: Proper cleanup on all execution paths

### Monitoring & Metrics
- **Switch Success Rate**: Percentage of successful context switches
- **Recovery Time**: Time to resume previous work contexts
- **Team Adoption**: Usage patterns across development team
- **Error Frequency**: Common failure modes and resolution effectiveness

## Integration Points

### With Claude Code
- **Context Reset**: Clear guidance for conversation context clearing
- **Command Integration**: Seamless /switch command execution
- **State Preparation**: Repository ready for new AI assistance context

### With Project Management
- **Active Project Preservation**: Project files maintained across switches
- **Task Context**: Links preserved between projects and work branches
- **Agent Coordination**: Specialist agents available in any context

### With Git Workflow
- **Standard Conventions**: Follows da-agent-hub branch naming patterns
- **Commit Standards**: Consistent message format and attribution
- **Remote Strategy**: Team-friendly remote branch management

## Best Practices

### When to Use Context Switching
- **Priority Changes**: Urgent work requires immediate attention
- **Context Confusion**: Current work becoming mentally complex
- **Fresh Perspective**: Need clean start for creative problem solving
- **Team Coordination**: Switching to collaborate on different projects

### Context Switching Hygiene
- **Frequent Switches**: Avoid excessive context switching (impacts productivity)
- **Clear Stopping Points**: Switch at logical work boundaries
- **Documentation**: Update project context before switching
- **Team Communication**: Inform team of context changes when collaborative

### Resume Best Practices
```bash
# Always check status after resume
git status
git log --oneline -3

# Review project context
cat projects/active/[project]/context.md

# Check for updates since last work
git pull origin [branch]
```

## Success Criteria

### Context Switching Effectiveness
- [ ] Zero work loss during context switches
- [ ] Clean repository state after switches
- [ ] Simple resume capability for previous work
- [ ] Team visibility of all work branches
- [ ] Clear guidance for Claude Code context reset

### Integration Success
- [ ] Seamless ADLC phase transitions
- [ ] Project management context preservation
- [ ] Agent coordination across contexts
- [ ] Git workflow standard compliance

### Team Adoption
- [ ] Developer productivity maintenance during switches
- [ ] Reduced merge conflicts from clean main branch
- [ ] Improved collaboration through remote branch visibility
- [ ] Faster onboarding for context switching workflows

## References

### Related Documentation
- [Claude Code Commands](../.claude/commands/switch.md) - Switch command protocol
- [4-Command Workflow](../CLAUDE.md#simplified-analytics-development-commands) - Overall workflow integration
- [Git Workflow Standards](../CLAUDE.md#general-git-workflow) - Branch naming and management conventions
- [Project Management](../development/project-management-patterns.md) - Project structure and coordination

### Implementation Files
- `scripts/switch.sh` - Core implementation script
- `.claude/commands/switch.md` - Command protocol documentation
- GitHub Actions workflows for verification and integration

---

*Complete context switching solution for analytics development - preserving work while enabling seamless project transitions.*