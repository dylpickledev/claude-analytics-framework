---
name: claude-code-quality-checklists
description: Quality validation checklists for Claude Code configuration artifacts including agents, skills, patterns, and CLAUDE.md files with scoring rubrics
user-invocable: false
---

# Claude Code Quality Validation Checklists

**Created**: 2025-10-21
**Source**: PR #164 claude-code-expert (your-org/da-agent-hub)
**Purpose**: Systematic quality validation for Claude Code configuration artifacts
**Status**: Production guidance

---

## Overview

These checklists ensure Claude Code configuration follows Anthropic best practices for agents, skills, patterns, and CLAUDE.md files. Use during creation, review, and optimization.

**When to use**:
- Creating new agents or skills
- Reviewing configuration changes in PRs
- Auditing existing Claude Code setup
- Optimizing AI effectiveness

---

## Agent Quality Checklist (7 Points)

### 1. YAML Frontmatter Complete and Valid ✅
- [ ] `name:` present (lowercase-hyphenated)
- [ ] `description:` present and action-oriented
- [ ] `model:` specified (sonnet or inherit)
- [ ] `color:` specified (optional but recommended)
- [ ] YAML syntax valid (no indentation errors)

**Why**: Frontmatter enables Claude Code to discover and invoke agents correctly.

**Example**:
```yaml
---
name: dbt-expert
description: dbt transformation specialist. Consult proactively for model optimization, testing strategies, and performance issues.
model: sonnet
color: blue
---
```

### 2. Single-Purpose Focus ✅
- [ ] Agent has one clear responsibility
- [ ] Scope is neither too broad nor too narrow
- [ ] Role clearly defined in opening paragraph
- [ ] Expertise domain explicitly stated

**Why**: Single-purpose agents are easier to invoke correctly and provide more focused expertise.

**Anti-pattern**: "General data expert" (too broad)
**Good pattern**: "dbt transformation specialist" (focused)

### 3. Detailed System Prompt with Examples ✅
- [ ] Opening paragraph states agent's role
- [ ] Core responsibilities listed (3-7 items)
- [ ] Expertise areas documented
- [ ] Example consultations provided
- [ ] Output format specified

**Why**: Detailed prompts improve agent response quality and consistency.

**Sections to include**:
- Role & Expertise
- Core Responsibilities
- Available Tools
- Example Consultations
- Quality Standards

### 4. Strategic Tool Restrictions ✅
- [ ] Only necessary tools granted
- [ ] Tool access rationale documented
- [ ] Restricted tools explicitly listed
- [ ] Security implications considered

**Why**: Limiting tools maintains focus and reduces security risk.

**Example**:
```markdown
### ✅ Allowed Tools
- Read, Grep, Glob (analysis)
- WebFetch (documentation research)

### ❌ Restricted Tools
- Bash, Write (research-only agent)
```

### 5. Action-Oriented Description ✅
- [ ] Description uses active verbs
- [ ] Includes "Consult proactively" or similar
- [ ] Specifies when to delegate
- [ ] Triggers are clear

**Why**: Encourages Claude to delegate to specialists when appropriate.

**Good**: "Consult proactively for dbt optimization, testing, and performance issues"
**Bad**: "Helps with dbt" (passive, vague)

### 6. Quality Standards Documented ✅
- [ ] Output format specified
- [ ] Quality requirements listed
- [ ] Validation protocols included
- [ ] Success criteria defined

**Why**: Ensures consistent, high-quality agent outputs.

**Example**:
```markdown
## Quality Standards

**Every recommendation must include**:
- ✅ Analysis of current state
- ✅ Specific recommendations
- ✅ Implementation steps
- ✅ Validation approach
```

### 7. Integration with Agent Ecosystem ✅
- [ ] Related specialists documented
- [ ] Delegation patterns explained
- [ ] MCP tool usage specified (if applicable)
- [ ] Consultation protocol defined

**Why**: Agents work together effectively when integration is clear.

---

## Skill Quality Checklist (5 Points)

### 1. Clear Workflow Steps ✅
- [ ] Steps numbered and sequential
- [ ] Each step has clear objective
- [ ] Tools to use specified
- [ ] Expected outputs defined
- [ ] Error handling included

**Why**: Step-by-step workflows ensure consistent execution.

**Structure**:
```markdown
### 1. Step Name
**Execute**: [tools/commands to use]
**Output**: [expected result]
**Error handling**: [what to do if fails]
```

### 2. Error Handling and Rollback ✅
- [ ] Failure scenarios identified
- [ ] Graceful degradation defined
- [ ] Rollback procedures documented
- [ ] User feedback on errors

**Why**: Skills should handle failures gracefully and inform users.

**Example**:
```markdown
## Error Handling

### Project Already Exists
**Check**: Directory exists
**Action**: Ask user to confirm overwrite or choose new name

### Git Branch Exists
**Check**: Branch exists
**Action**: Suggest alternative or checkout existing
```

### 3. Reusability Across Contexts ✅
- [ ] Works with different inputs
- [ ] No hardcoded project-specific values
- [ ] Templates use variables
- [ ] Tested with diverse scenarios

**Why**: Skills should be reusable, not one-off scripts.

**Use variables**: `{project_name}`, `{date}`, `{user_input}`

### 4. Quality Standards and Validation ✅
- [ ] Success criteria defined
- [ ] Output validation checks
- [ ] Quality requirements listed
- [ ] Acceptance tests specified

**Why**: Skills should validate their own outputs.

**Example**:
```markdown
## Quality Standards

**Every project setup must**:
- ✅ Create all 4 core files
- ✅ Use consistent naming
- ✅ Create valid git branch
- ✅ Verify all files created
```

### 5. User-Facing Documentation ✅
- [ ] Purpose clearly stated
- [ ] Usage examples provided
- [ ] Trigger phrases listed
- [ ] Success metrics documented

**Why**: Users need to know when and how to use skills.

---

## CLAUDE.md Quality Checklist (6 Points)

### 1. Specific Instructions, Not Generic Advice ✅
- [ ] Instructions are actionable
- [ ] Examples provided for key workflows
- [ ] Clear do's and don'ts
- [ ] No vague guidance

**Why**: Specific instructions improve Claude's effectiveness.

**Bad**: "Write good code"
**Good**: "Use PEP 8 style guide. Run `black .` before committing."

### 2. Markdown Structure with Clear Headers ✅
- [ ] Logical hierarchy (H1 → H2 → H3)
- [ ] Table of contents if >300 lines
- [ ] Code blocks properly formatted
- [ ] Lists consistently styled

**Why**: Well-structured documentation is easier to parse and reference.

### 3. Import Patterns for Modularity (if >500 lines) ✅
- [ ] Main CLAUDE.md is focused (<300 lines ideal)
- [ ] Detailed patterns imported from .claude/rules/ and .claude/skills/reference-knowledge/
- [ ] Import syntax: `@path/to/pattern.md`
- [ ] Imported files are self-contained

**Why**: Modular structure improves readability and maintainability.

**Example**:
```markdown
## Git Workflow
See @.claude/rules/git-workflow-patterns.md

## Testing
See @.claude/skills/reference-knowledge/testing-patterns/SKILL.md
```

### 4. Progressive Disclosure ✅
- [ ] Most important info first
- [ ] Quick reference at top
- [ ] Detailed sections below
- [ ] Advanced topics last

**Why**: Claude should find key information quickly.

**Structure**:
1. Quick Start / Most Important
2. Core Workflows
3. Reference Documentation
4. Advanced Topics

### 5. Version Control and Team Sharing ✅
- [ ] CLAUDE.md committed to version control
- [ ] .claude/agents/ committed
- [ ] Team-specific conventions documented
- [ ] Change history trackable

**Why**: Teams benefit from shared, versioned Claude Code configuration.

### 6. Regular Review and Updates ✅
- [ ] Last updated date included
- [ ] Obsolete sections removed
- [ ] New patterns incorporated
- [ ] Review schedule defined (quarterly recommended)

**Why**: Outdated instructions reduce AI effectiveness.

---

## Pattern Quality Checklist (5 Points)

### 1. Production-Validated Solution ✅
- [ ] Used successfully in ≥2 real projects
- [ ] Results documented and verified
- [ ] Edge cases tested
- [ ] Confidence level assigned

**Why**: Only proven patterns should be documented.

**Validation notes**:
```markdown
**Validated**:
- Project A: Reduced query time 80% (2024-09-15)
- Project B: Eliminated incremental issues (2024-10-03)
**Confidence**: 0.95 (High)
```

### 2. Decision Criteria ("When to Use") ✅
- [ ] Clear triggering conditions
- [ ] Alternative approaches mentioned
- [ ] Trade-offs documented
- [ ] Anti-patterns identified

**Why**: Helps decide when to apply the pattern.

**Example**:
```markdown
## When to Use This Pattern

**Use when**:
- ✅ Incremental models with large datasets (>10M rows)
- ✅ Query runtime > 1 hour
- ✅ Source system supports incremental extraction

**Don't use when**:
- ❌ Small datasets (<1M rows)
- ❌ Full refresh is acceptably fast
- ❌ Source system lacks updated_at column
```

### 3. Real-World Examples ✅
- [ ] Concrete code examples
- [ ] Before/after comparisons
- [ ] Actual project references
- [ ] Screenshots or diagrams (if helpful)

**Why**: Examples make patterns immediately actionable.

### 4. Cross-References to Related Patterns ✅
- [ ] Links to related patterns
- [ ] Links to relevant agents
- [ ] Links to applicable skills
- [ ] External documentation referenced

**Why**: Patterns form a knowledge network.

**Example**:
```markdown
## Related Patterns
- [dbt Testing Patterns](./dbt-testing-patterns.md)
- [Snowflake Optimization](./snowflake-optimization-patterns.md)

## Related Agents
- dbt-expert: Use this pattern for optimization consultations
- snowflake-expert: For warehouse-side performance tuning
```

### 5. Maintenance Information ✅
- [ ] Last validated date
- [ ] Next review date
- [ ] Known limitations
- [ ] Future improvements identified

**Why**: Patterns evolve as technologies and practices change.

**Metadata**:
```markdown
**Last Validated**: 2025-10-15
**Next Review**: 2026-01-15 (quarterly)
**Confidence**: 0.92
**Limitations**: Requires dbt 1.6+, Snowflake warehouse
```

---

## Usage Guide

### During Creation

**New Agent**:
1. Create agent file from template
2. Use Agent Quality Checklist (7 points)
3. Ensure all ✅ checked before committing

**New Skill**:
1. Document workflow steps clearly
2. Use Skill Quality Checklist (5 points)
3. Test with 3+ diverse scenarios

**New Pattern**:
1. Validate in ≥2 projects first
2. Use Pattern Quality Checklist (5 points)
3. Add confidence score

### During PR Review

**Review Checklist**:
1. Identify which checklists apply
2. Verify all items checked
3. Request changes for failures
4. Approve when all items pass

### During Optimization

**Periodic Audit**:
1. Run all checklists against existing config
2. Identify gaps or outdated content
3. Update to meet current standards
4. Document improvements made

---

## Quality Metrics

### Per-Artifact Quality Score

**Formula**: `(Checked Items / Total Items) * 100`

**Thresholds**:
- **100%**: Excellent - production ready
- **85-99%**: Good - minor improvements needed
- **70-84%**: Fair - significant gaps to address
- **<70%**: Poor - major rework required

### Overall Configuration Health

**Aggregate score across all**:
- Agent files
- Skill files
- Pattern files
- CLAUDE.md

**Target**: ≥90% average across all artifacts

---

## Continuous Improvement

### After Every Project Completion

**Review and Update**:
- [ ] Did agents perform well? Update confidence levels
- [ ] Did skills work as expected? Refine workflows
- [ ] Did patterns apply? Update validation notes
- [ ] Is CLAUDE.md still accurate? Update instructions

### Quarterly Configuration Audit

**Systematic Review**:
1. Run all checklists on all files
2. Calculate quality scores
3. Identify lowest-scoring artifacts
4. Prioritize improvements
5. Update and re-validate

---

## References

### Anthropic Documentation
- **Sub-agents**: https://docs.claude.com/en/docs/claude-code/sub-agents.md
- **Skills**: https://docs.claude.com/en/docs/claude-code/skills.md
- **Memory/CLAUDE.md**: https://docs.claude.com/en/docs/claude-code/memory.md
- **Hooks**: https://docs.claude.com/en/docs/claude-code/hooks-guide.md
- **Plugins**: https://docs.claude.com/en/docs/claude-code/plugins.md

### Internal Documentation
- **Knowledge Organization**: `.claude/skills/reference-knowledge/knowledge-organization-strategy/SKILL.md`
- **Agent README**: `.claude/agents/README.md`
- **claude-code-expert**: `.claude/agents/specialists/claude-code-expert.md`

---

**Version**: 1.0.0
**Last Updated**: 2025-10-21
**Next Review**: 2026-01-21
**Source**: Extracted from PR #164 (your-org/da-agent-hub)
**Maintainer**: ADLC Platform Team
