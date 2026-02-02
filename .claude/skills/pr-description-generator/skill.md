---
name: pr-description-generator
description: Generate comprehensive PR descriptions from project context and git changes
version: 1.0.0
---

# PR Description Generator Skill

Automatically generates high-quality, consistent PR descriptions based on project documentation and git changes.

## Purpose

Save 5-10 minutes per PR by:
- Analyzing project files (README, spec, context)
- Reviewing git diff for changes made
- Generating structured PR description following best practices
- Including test plan and quality checklist

## Usage

This skill is invoked when creating a PR or when explicitly requested.

**Trigger phrases**:
- "Generate PR description"
- "Create pull request description"
- "What should I put in the PR description?"

## Workflow Steps

### 1. Locate Project Context

**Determine project location**:
- If in project directory: Use current directory
- If in worktree: Identify associated project
- Ask user if ambiguous

**Required files**:
- `README.md` - Project overview
- `spec.md` - Requirements and implementation
- `context.md` - Working state and decisions
- Git history - Actual changes made

### 2. Read Project Documentation

**Execute Read operations**:
```
Read: projects/active/{project_name}/README.md
Read: projects/active/{project_name}/spec.md
Read: projects/active/{project_name}/context.md
```

**Extract key information**:
- Project title and description
- Implementation goals
- Key decisions made
- Agent consultations
- Test status

### 3. Analyze Git Changes

**Execute git commands**:
```bash
# Get current branch
git branch --show-current

# Get commits since divergence from main
git log main..HEAD --oneline

# Get detailed commit history
git log main..HEAD --format="%h %s%n%b"

# Get file changes summary
git diff main...HEAD --stat

# Get detailed changes
git diff main...HEAD
```

**Analyze**:
- Number of commits
- Files changed
- Lines added/removed
- Nature of changes (new features, fixes, refactors)

### 4. Generate Summary Section

**Format**:
```markdown
## Summary

{1-3 bullet points summarizing what was accomplished}

- Primary change: {brief description}
- Secondary changes: {additional work}
- Impact: {who benefits and how}
```

**Guidelines**:
- Focus on "what" and "why", not "how"
- Business value first, technical details second
- Maximum 3 bullet points
- Each bullet 1-2 sentences

### 5. Generate Files Changed Section

**List key files** with brief explanation:
```markdown
## Files Changed

1. **{file_path}** - {brief description of changes}
2. **{file_path}** - {brief description of changes}
```

**Rules**:
- List significant files only (not every config file)
- Group related files if many changed
- Explain purpose of changes, not mechanics

### 6. Generate Test Plan Section

**From context.md and spec.md**:
```markdown
## Test Plan

- [ ] {Test scenario 1}
- [ ] {Test scenario 2}
- [ ] {Test scenario 3}
- [ ] All existing tests passing
- [ ] No new warnings or errors
```

**Sources**:
- Acceptance criteria from spec.md
- Test status from context.md
- Common testing requirements for project type

### 7. Generate Quality Checklist

**Standard checklist**:
```markdown
## Quality Checklist

- [ ] Code follows project conventions
- [ ] Documentation updated (README, comments, etc.)
- [ ] Tests written and passing
- [ ] No breaking changes (or documented if unavoidable)
- [ ] Ready for review
```

**Customize based on project**:
- Add security checks if relevant
- Add performance requirements if specified
- Add compliance items if required

### 8. Add Metadata

**Append**:
```markdown
## Related Issues

{Links to related GitHub issues}

## Agent Consultations

{List specialist agents consulted and their contributions}

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### 9. Format and Return

**Complete PR description structure**:
```markdown
## Summary
{summary section}

## Files Changed
{files section}

## Test Plan
{test plan}

## Quality Checklist
{quality checklist}

## Related Issues
{issues}

## Agent Consultations
{agents}

---
🤖 Generated with [Claude Code](https://claude.com/claude-code)
Co-Authored-By: Claude <noreply@anthropic.com>
```

### 10. Output to User

**Display**:
```
✅ PR Description Generated

📋 Description ready for pull request creation.

Use with:
  gh pr create --title "{title}" --body "{description}"

Or copy to clipboard for manual PR creation.

Review and edit as needed before submitting.
```

## Error Handling

### No Project Context Found
**Check**: Project files exist
**Action**: Ask user to specify project or run from project directory

### No Git Changes
**Check**: `git diff main..HEAD` has content
**Action**: Warn user there are no changes to include in PR

### Uncommitted Changes
**Check**: `git status` shows staged/unstaged changes
**Action**: Warn that uncommitted changes won't be included

## Quality Standards

**Every PR description must**:
- ✅ Include clear summary (1-3 bullets)
- ✅ List significant files changed with explanations
- ✅ Provide actionable test plan
- ✅ Include quality checklist
- ✅ Reference related issues/agents
- ✅ Follow consistent markdown formatting

## Integration with ADLC Workflow

### Called when creating PR
```
User: "Create PR for this project"
→ Invokes pr-description-generator skill
→ Generates description
→ Executes gh pr create with generated description
```

### Called manually
```
User: "Generate PR description"
→ Invokes pr-description-generator skill
→ Displays description for review
→ User can edit before using
```

## Best Practices

### Summary Writing
- **DO**: Focus on business value and user impact
- **DO**: Keep it concise (3 bullets max)
- **DON'T**: List every file or function changed
- **DON'T**: Include implementation details in summary

### Test Plan Creation
- **DO**: Base on acceptance criteria from spec
- **DO**: Include edge cases and error scenarios
- **DON'T**: Write vague tests like "test everything"
- **DON'T**: Skip test plan even for small changes

### File Descriptions
- **DO**: Explain why files changed, not just what
- **DO**: Group related files when many changed
- **DON'T**: List trivial changes (formatting, whitespace)
- **DON'T**: Omit significant new files

## Success Metrics

**Time savings**: 5-10 minutes per PR
**Quality**: Consistent, comprehensive PR descriptions
**Adoption**: Used for 90%+ of PRs

---

**Version**: 1.0.0
**Last Updated**: 2025-10-21
**Maintainer**: ADLC Platform Team
