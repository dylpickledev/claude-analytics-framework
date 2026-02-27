don't look at the full .env file. Only search for the var names up to the equals sign.

# Claude Analytics Framework

## Security (CRITICAL)

NEVER commit directly to protected branches (main, master, production, prod). Always create a feature branch and PR. See `.claude/rules/git-workflow-patterns.md`.

All work stays in `projects/active/<project-name>/` until user explicitly requests deployment.

## Repository Branch Structures

- **dbt_cloud**: master (prod), dbt_dw (staging) - branch from dbt_dw
- **dbt_errors_to_issues**: main - branch from main
- **roy_kent**: master - branch from master
- **sherlock**: main - branch from main

## Repo Context Resolution

Resolve GitHub owner/repo before MCP calls: `python3 scripts/resolve-repo-context.py <repo_name>`

## MCP Setup

Required for dbt Cloud integration. Copy `.env.example` to `.env` with credentials, restart Claude Code. See `docs/troubleshooting-mcp.md` if issues.

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/idea "[idea]"` | Capture idea as GitHub issue |
| `/research [text\|issue#]` | Deep exploration and analysis |
| `/start [issue#\|"text"]` | Begin development |
| `/switch [branch]` | Context-preserving branch switch |
| `/complete [project]` | Archive and close |
| `/pause` | Save conversation context |

## Submodules

External repos managed as git submodules. Config: `config/repositories.json`.
Init: `./scripts/setup-submodules.sh` | Update: `./scripts/pull-all-repos.sh`

## Project Structure

Active projects: `projects/active/<name>/` with README.md, spec.md, context.md, and tasks/.

## Skills

Available: `project-setup`, `pr-description-generator`, `dbt-model-scaffolder`, `documentation-validator`. Located in `.claude/skills/<name>/skill.md`.
