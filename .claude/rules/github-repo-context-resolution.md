# GitHub Repository Context Resolution

Automatic resolution of GitHub owner/repo from `config/repositories.json` for GitHub MCP operations.

## Commands

**Python resolver** (primary):
```bash
python3 scripts/resolve-repo-context.py <repo_name>
python3 scripts/resolve-repo-context.py --json <repo_name>
python3 scripts/resolve-repo-context.py --list
```

**Bash helper** (quick owner extraction):
```bash
./scripts/get-repo-owner.sh <repo_name>
```

## Configuration

Source: `config/repositories.json` - Extracts owner from GitHub URLs in pattern: `https://github.com/{owner}/{repo}.git`

## Local Repositories (Cannot Resolve)

Some repos have `"url": "local"` and cannot be resolved:
- tableau
- legacy-reporting

These require explicit owner specification.
