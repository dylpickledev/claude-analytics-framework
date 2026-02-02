---
name: documentation-validator
description: Validate documentation completeness and quality before project completion
version: 1.0.0
---

# Documentation Validator Skill

Systematically validates project documentation completeness and quality before project closure.

## Purpose

Prevent incomplete documentation by:
- Checking all required files exist
- Validating required sections present
- Verifying links work
- Ensuring consistent formatting
- Confirming quality standards met

## Usage

This skill is invoked during project completion (`/complete`) or when explicitly requested.

**Trigger phrases**:
- "Validate documentation"
- "Check documentation completeness"
- "Is documentation ready?"

## Workflow Steps

### 1. Identify Project Location

**Determine project**:
- If in project directory: Use current directory
- Ask user if ambiguous
- Support both active and archived projects

**Expected location**:
```
projects/active/{project_name}/
```

### 2. Check Required Files Exist

**Required files**:
- [x] `README.md` - Navigation and overview
- [x] `spec.md` - Requirements and goals
- [x] `context.md` - Working state
- [x] `tasks/current-task.md` - Task tracking

**Execute checks**:
```bash
test -f projects/active/{project_name}/README.md
test -f projects/active/{project_name}/spec.md
test -f projects/active/{project_name}/context.md
test -f projects/active/{project_name}/tasks/current-task.md
```

**Report missing files**.

### 3. Validate README.md Structure

**Required sections**:
- [ ] Title (H1)
- [ ] Created date and status
- [ ] Overview section
- [ ] Project Structure section
- [ ] Quick Links section
- [ ] Progress Summary section

**Optional but recommended**:
- [ ] Key Decisions section (if decisions made)
- [ ] Notes section

**Checks**:
- Title matches project
- Status reflects current state
- Overview describes purpose
- Links to spec.md and context.md present

### 4. Validate spec.md Structure

**Required sections**:
- [ ] Title
- [ ] Overview
- [ ] Goals
- [ ] Requirements (Functional, Non-Functional, Constraints)
- [ ] Implementation Plan
- [ ] Technical Approach
- [ ] Success Criteria

**Optional but recommended**:
- [ ] Risks & Mitigation
- [ ] Dependencies
- [ ] Timeline

**Checks**:
- All sections have content (not just placeholders)
- Success criteria are measurable
- Implementation plan has concrete steps

### 5. Validate context.md Structure

**Required sections**:
- [ ] Current State (Git branch, PRs, deployment)
- [ ] Current Focus
- [ ] Decisions Log
- [ ] Agent Activity

**Checks**:
- Git branch documented
- PR links included (if PRs created)
- Major decisions documented
- Agent consultations recorded

### 6. Check Internal Links

**Extract and test links**:
```
Find all markdown links: [text](path)
Test each relative link:
  - Does file exist?
  - Does anchor exist (if specified)?
```

**Common links to validate**:
- README → spec.md
- README → context.md
- README → tasks/current-task.md
- context.md → tasks/*-findings.md

**Report broken links**.

### 7. Validate Code Documentation (if applicable)

**For code projects**:
- [ ] Code has inline comments for complex logic
- [ ] Functions/classes have docstrings
- [ ] README has usage examples
- [ ] API endpoints documented (if applicable)

**Check**:
```bash
# Count comment lines vs code lines (basic heuristic)
# Look for TODO/FIXME comments that should be resolved
```

### 8. Check Markdown Formatting

**Standard checks**:
- [ ] Headers follow hierarchy (H1 → H2 → H3)
- [ ] Code blocks have language specified
- [ ] Lists formatted consistently
- [ ] No trailing whitespace
- [ ] Proper newline at end of file

**Use linter** (if available):
```bash
markdownlint projects/active/{project_name}/*.md
```

### 9. Validate Metadata Completeness

**In frontmatter or headers**:
- [ ] Created date present
- [ ] Last updated date present
- [ ] Status/phase indicated
- [ ] Related issue links (if from GitHub issue)

### 10. Generate Validation Report

**Format**:
```markdown
# Documentation Validation Report
**Project**: {project_name}
**Date**: {current_date}

## Summary
✅ {pass_count} checks passed
⚠️ {warning_count} warnings
❌ {fail_count} failures

## Required Files
- [✅/❌] README.md
- [✅/❌] spec.md
- [✅/❌] context.md
- [✅/❌] tasks/current-task.md

## README.md Validation
- [✅/❌] Title and metadata
- [✅/❌] Overview section
- [✅/❌] Project structure
- [✅/❌] Quick links
- [✅/❌] Progress summary

## spec.md Validation
- [✅/❌] Goals defined
- [✅/❌] Requirements documented
- [✅/❌] Implementation plan
- [✅/❌] Success criteria

## context.md Validation
- [✅/❌] Current state documented
- [✅/❌] Decisions logged
- [✅/❌] Agent activity tracked

## Link Validation
- ✅ {working_links_count} links working
- ❌ {broken_links_count} broken links:
  - {broken_link_1}
  - {broken_link_2}

## Warnings
- {warning_1}
- {warning_2}

## Failures
- {failure_1}
- {failure_2}

## Recommendations
1. {recommendation_1}
2. {recommendation_2}

## Overall Status
[✅ PASS | ⚠️ PASS WITH WARNINGS | ❌ FAIL]

{overall_assessment}
```

### 11. Output Report to User

**Display**:
```
📋 Documentation Validation Complete

Overall Status: [✅ PASS | ⚠️ PASS WITH WARNINGS | ❌ FAIL]

Summary:
- ✅ {pass_count} checks passed
- ⚠️ {warning_count} warnings
- ❌ {fail_count} failures

{If failures exist:}
❌ Critical Issues Found:
- {failure_1}
- {failure_2}

Please address failures before completing project.

{If warnings exist:}
⚠️ Warnings:
- {warning_1}
- {warning_2}

Consider addressing warnings for better documentation quality.

Full report: projects/active/{project_name}/validation-report.md
```

### 12. Save Validation Report

**Save report**:
```
projects/active/{project_name}/validation-report.md
```

**For use in `/complete` workflow**.

## Error Handling

### Project Not Found
**Check**: Project directory exists
**Action**: Ask user to specify valid project path

### No Documentation Files
**Check**: At least README.md exists
**Action**: Fail validation with clear message

### Markdownlint Not Available
**Check**: markdownlint command exists
**Action**: Skip formatting checks, continue with other validations

## Quality Standards

**Documentation validation must**:
- ✅ Check all required files and sections
- ✅ Validate internal link integrity
- ✅ Provide actionable feedback
- ✅ Distinguish failures (blockers) from warnings (nice-to-fix)
- ✅ Generate comprehensive report

## Validation Levels

### Critical (Must Fix - Blockers)
- Missing required files
- Missing required sections
- Broken internal links
- Empty or placeholder content in key sections

### Warnings (Should Fix - Quality)
- Missing optional sections
- Inconsistent formatting
- Sparse documentation
- Undocumented decisions

### Informational (Nice to Have)
- Additional best practices
- Suggested improvements
- Enhancement opportunities

## Integration with ADLC Workflow

### Called by `/complete` command
```
/complete {project_name}
→ Invokes documentation-validator skill
→ Checks pass → Proceed with completion
→ Checks fail → Block completion, show failures
→ User fixes issues
→ Re-validate
→ Complete project
```

### Called manually
```
User: "Validate documentation for my project"
→ Invokes documentation-validator skill
→ Generates report
→ User reviews and fixes issues
```

## Best Practices

### README.md
- Clear, concise overview
- Links to all key documents
- Progress tracking shows current state
- Key decisions documented as made

### spec.md
- Measurable success criteria
- Concrete implementation plan
- Clear requirements with priorities
- Risks identified with mitigations

### context.md
- Current state always up-to-date
- All major decisions logged with rationale
- Agent consultations tracked
- Blockers and resolutions documented

## Success Metrics

**Quality**: 100% projects have complete documentation before closure
**Adoption**: Validation run for every project completion
**Effectiveness**: Reduced time debugging undocumented decisions

---

**Version**: 1.0.0
**Last Updated**: 2025-10-21
**Maintainer**: ADLC Platform Team
