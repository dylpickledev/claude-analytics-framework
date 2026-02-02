# Changelog

All notable changes to claude-analytics-framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-27

### Added
- **Initial public release** of claude-analytics-framework
- **5-command workflow**: `/idea`, `/research`, `/start`, `/switch`, `/complete`
- **Interactive onboarding**: `/onboard` command for stack-specific setup
- **4 production skills**:
  - `project-setup`: Initialize new projects with standard structure
  - `pr-description-generator`: Generate comprehensive PR descriptions
  - `dbt-model-scaffolder`: Create dbt models with best practices
  - `documentation-validator`: Validate documentation completeness
- **10 AI agents**:
  - Role agents: `analytics-engineer-role`, `data-engineer-role`, `data-architect-role`, `onboarding-agent`
  - Specialists: `dbt-expert`, `snowflake-expert`, `tableau-expert`, `claude-code-expert`
  - Templates: `role-template`, `specialist-template`
- **MCP integration support**:
  - dbt MCP with 3 setup methods (local .env, local OAuth, remote OAuth)
  - Snowflake MCP for direct warehouse access
  - GitHub MCP for repository operations
  - Sequential thinking MCP for complex problem-solving
- **Memory system**:
  - Automatic pattern extraction from completed projects
  - Recent patterns (30-day sliding window)
  - Agent-specific knowledge accumulation
- **Git workflow automation**:
  - Protected branch enforcement
  - Feature branch creation
  - Git worktree support
  - VS Code integration
- **Comprehensive documentation**:
  - 950+ line README with progressive disclosure
  - CLAUDE.md with framework instructions
  - Platform documentation in `knowledge/platform/`
  - MCP setup guides and troubleshooting

### Infrastructure
- Devcontainer setup for one-click development environment
- Shell scripts for workflow automation (11 scripts)
- Template files for easy customization
- Example configurations for common data stacks

### Documentation
- Complete README with "Is this for you?" decision framework
- Quick start guide (5 minutes to first project)
- Troubleshooting guides
- Agent development guides
- MCP integration documentation

## [Unreleased]

### Planned
- Additional specialist agents based on community feedback
- Enhanced MCP server integrations
- Workflow visualization tools
- Team collaboration features

---

## Version History

**1.0.0** - First public release, ready for data teams worldwide

---

For upgrade instructions and migration guides, see the [documentation](knowledge/platform/README.md).
