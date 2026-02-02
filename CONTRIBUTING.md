# Contributing to Claude Analytics Framework

Thank you for your interest in contributing to the Analytics Development Lifecycle (ADLC) Agent Hub! This document provides guidelines for contributing to the project.

---

## Ways to Contribute

### 1. Report Issues
- **Bug Reports**: Found a bug? Open an issue with:
  - Clear description of the problem
  - Steps to reproduce
  - Expected vs actual behavior
  - Environment details (OS, Claude Code version, dbt version)

- **Feature Requests**: Have an idea? Open an issue describing:
  - The problem you're trying to solve
  - Proposed solution
  - Use cases and benefits

### 2. Implement Planned Skills
We have 8 planned skills ready for implementation! See `.claude/skills/README.md` for the full list.

**High-Priority Skills**:
- `dbt-test-suite-generator` - Generate comprehensive test YAML
- `dbt-incremental-strategy-advisor` - Recommend optimal incremental strategy
- `dbt-cloud-job-monitor` - Monitor dbt Cloud job runs

**How to contribute a skill**:
1. Choose a planned skill from `.claude/skills/README.md`
2. Create skill folder: `.claude/skills/{skill-name}/`
3. Add `skill.md` following the template structure
4. Add templates if needed: `.claude/skills/{skill-name}/templates/`
5. Test on appropriate platforms (dbt Core and/or Cloud)
6. Update `.claude/skills/README.md` to mark as implemented
7. Submit PR

### 3. Improve Documentation
- Fix typos or unclear instructions
- Add examples and use cases
- Improve setup guides
- Translate documentation

### 4. Share Patterns
Discovered a useful pattern while using ADLC? Share it!
- Add to `.claude/skills/reference-knowledge/`
- Follow existing pattern structure
- Include context, solution, and when to use

### 5. Enhance Detection Libraries
Improve platform/capability detection:
- Better error messages
- Additional detection methods
- Support for new dbt features
- Performance optimizations

---

## Development Setup

### Prerequisites
- Claude Code installed
- Git
- Python 3.8+ (for repository management scripts)
- dbt Core or dbt Cloud access (for testing dbt skills)

### Setup Steps

```bash
# 1. Fork the repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR-USERNAME/claude-analytics-framework.git
cd claude-analytics-framework

# 3. Setup submodules (optional)
./scripts/setup-submodules.sh

# 4. Create feature branch
git checkout -b feature/your-feature-name

# 5. Make your changes
# ... edit files ...

# 6. Test your changes
# For skills: Test on both dbt Core and Cloud if applicable
# For scripts: Run and verify output

# 7. Commit with clear message
git add -A
git commit -m "feat: Add dbt-test-suite-generator skill"

# 8. Push to your fork
git push origin feature/your-feature-name

# 9. Open Pull Request on GitHub
```

---

## Pull Request Guidelines

### Before Submitting

- [ ] Code follows existing patterns and structure
- [ ] New skills include:
  - [ ] Clear frontmatter (name, description, version)
  - [ ] Step-by-step workflow
  - [ ] Platform requirements documented
  - [ ] Trigger phrases defined
  - [ ] Templates included (if applicable)
- [ ] Documentation updated
- [ ] Tested on appropriate platforms
- [ ] Commit messages follow conventions (see below)

### PR Description Should Include

- **What**: Brief summary of changes
- **Why**: Problem being solved or feature being added
- **How**: Technical approach taken
- **Testing**: How changes were tested
- **Screenshots**: For UI/workflow changes

### Commit Message Conventions

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: Add dbt-test-suite-generator skill
fix: Correct platform detection for dbt Cloud CLI
docs: Update submodule workflow documentation
chore: Update dependencies
test: Add tests for semantic layer detection
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `chore`: Maintenance tasks
- `test`: Test additions/changes
- `refactor`: Code refactoring

---

## Skill Development Guide

### Skill Template Structure

```markdown
---
name: skill-name
description: Brief description of what skill does
version: 1.0.0
platform: ["dbt_core", "dbt_cloud"]  # or ["universal"]
---

# Skill Name

Brief overview.

## Purpose

What problem does this solve? Time savings?

## Usage

Trigger phrases and expected outcomes.

## Workflow Steps

### Step 0: Platform Detection (if platform-specific)
[Use detection libraries]

### Step 1: [Action]
[Detailed instructions]

### Step 2: [Action]
[Detailed instructions]

## Templates

[If skill uses templates, describe them]

## Testing

[How to test this skill]

## Error Handling

[Common errors and solutions]
```

### Detection Library Integration

Always use detection libraries for platform-aware skills:

```markdown
## Step 0: Platform Detection

platform = detect_dbt_platform()  # Use platform-detector.md

IF platform != "dbt_cloud":
  ERROR: "This skill requires dbt Cloud (you're on dbt Core)"
  SUGGEST: [Alternative skill for Core]
  EXIT
```

### Testing Checklist

- [ ] Tested on dbt Core (if applicable)
- [ ] Tested on dbt Cloud (if applicable)
- [ ] Tested with small project (<100 models)
- [ ] Tested with large project (>500 models) if using MCP
- [ ] Error messages are clear and helpful
- [ ] Fallback options provided when features unavailable

---

## Code Review Process

1. **Automated Checks**: GitHub Actions runs tests
2. **Maintainer Review**: Core team reviews code and design
3. **Feedback**: Address review comments
4. **Approval**: Maintainer approves PR
5. **Merge**: Squash and merge to main

**Review Timeline**: Expect initial response within 3-5 business days.

---

## Community Guidelines

### Be Respectful
- Treat all contributors with respect
- Welcome newcomers and help them learn
- Focus on constructive feedback

### Be Collaborative
- Share knowledge and learn from others
- Give credit where credit is due
- Ask questions when unclear

### Be Professional
- Keep discussions on-topic
- Avoid off-topic or inflammatory comments
- Respect maintainer decisions

---

## Questions?

- **General Questions**: Open a GitHub Discussion
- **Bug Reports**: Open a GitHub Issue
- **Security Issues**: Email security@your-domain.com (replace with actual contact)
- **Chat**: Join our community (link TBD)

---

## Recognition

Contributors will be:
- Listed in release notes
- Added to CONTRIBUTORS.md
- Acknowledged in documentation

Thank you for contributing to Claude Analytics Framework! 🎉
