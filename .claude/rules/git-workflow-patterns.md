# Git Workflow Patterns

## Protected Branches
- `main`, `master`, `production`, `prod`
- Any branch matching: `release/*`, `hotfix/*`

## Mandatory Workflow
1. Always create feature branch before code changes
2. Always create Pull Request for code review and approval
3. Never push directly to protected branches
4. Never merge without approval (except da-agent-hub documentation updates)

## Branch Naming Conventions
- `feature/[description]` - New features
- `fix/[description]` - Bug fixes
- `docs/[description]` - Documentation updates
- `refactor/[description]` - Code refactoring
- `test/[description]` - Testing improvements

## Repository-Specific Branch Structures

**dbt_cloud**
- Production: `master`, Staging: `dbt_dw`
- Branch from: `dbt_dw`

**dbt_errors_to_issues**
- Production: `main`
- Branch from: `main`

**roy_kent**
- Production: `master`
- Branch from: `master`

**sherlock**
- Production: `main`
- Branch from: `main`
