# GitHub Repository Context Resolution Pattern

## Overview
Automatic resolution of GitHub owner/repo information from `config/repositories.json` for seamless GitHub MCP operations.

## Problem Solved
Previously, agents and MCP tools required explicit `owner="your-org"` for every GitHub operation. This created cognitive overhead and potential for errors.

## Solution
Smart context resolution system that automatically extracts owner/repo from repository URLs in configuration.

## Tools Available

### 1. Python Resolver (`scripts/resolve-repo-context.py`)
**Primary tool for context resolution**

```bash
# Get owner and repo (space-separated)
python3 scripts/resolve-repo-context.py dbt_cloud
# Output: your-org dbt_cloud

# Get full JSON context
python3 scripts/resolve-repo-context.py --json dbt_cloud
# Output: {"owner": "your-org", "repo": "dbt_cloud", ...}

# List all resolvable repositories
python3 scripts/resolve-repo-context.py --list
```

### 2. Bash Helper (`scripts/get-repo-owner.sh`)
**Quick owner extraction**

```bash
# Get just the owner
./scripts/get-repo-owner.sh dbt_cloud
# Output: your-org
```

## Agent Integration Pattern

### For Claude/AI Agents
When you need to perform GitHub MCP operations and only have a repo name:

```markdown
STEP 1: Resolve repository context
- Use: python3 scripts/resolve-repo-context.py <repo_name>
- Extract owner and repo from output

STEP 2: Use resolved context in GitHub MCP calls
- owner=<resolved_owner>
- repo=<resolved_repo>

Example:
User asks: "Check issues in dbt_cloud"

Claude executes:
1. python3 scripts/resolve-repo-context.py dbt_cloud
   → Returns: your-org dbt_cloud
2. mcp__github__list_issues owner="your-org" repo="dbt_cloud"
```

### For Bash Scripts
```bash
#!/bin/bash
REPO_NAME="dbt_cloud"

# Resolve owner
OWNER=$(./scripts/get-repo-owner.sh "$REPO_NAME")

# Use in GitHub operations
gh issue list --repo "$OWNER/$REPO_NAME"
```

## Specialist Agent Instructions

### GitHub-Related Specialists
Add this to agent instructions:

```markdown
## Repository Context Resolution

Before making GitHub MCP calls, resolve repository context:

1. If user provides only repo name (e.g., "dbt_cloud"):
   - Run: python3 scripts/resolve-repo-context.py <repo_name>
   - Extract owner from output
   - Use in GitHub MCP: owner=<resolved> repo=<resolved>

2. If user provides full path (e.g., "your-org/dbt-project"):
   - Parse directly, no resolution needed

3. If resolution fails:
   - Repo might not be in config/repositories.json
   - Ask user for owner explicitly
```

### Example Agent Update

**github-sleuth-expert** integration:
```markdown
## GitHub Issue Investigation

When analyzing repository issues:

1. Resolve repo context if needed:
   ```bash
   python3 scripts/resolve-repo-context.py <repo_name>
   ```

2. Use resolved owner/repo in MCP calls:
   ```
   mcp__github__list_issues owner=<resolved> repo=<resolved>
   ```

This eliminates need for user to specify "your-org" each time.
```

## Configuration Source

**File**: `config/repositories.json`

All GitHub repositories are tracked with full URLs:
```json
{
  "data_stack": {
    "transformation": {
      "dbt_cloud": {
        "url": "https://github.com/your-org/dbt-project.git",
        "branch": "dbt_dw",
        "description": "Main dbt transformation project"
      }
    }
  }
}
```

The resolver extracts owner from URL pattern: `https://github.com/{owner}/{repo}.git`

## Supported Repositories

All repositories in `config/repositories.json` with GitHub URLs:
- Knowledge repos: da_team_documentation, da_obsidian
- Orchestration: orchestra, prefect
- Ingestion: source1-etl, source2-etl, source3-ingestion, database-pipelines, notebook-pipelines
- Transformation: dbt_cloud, dbt-project-secondary
- Front-end: streamlit-apps, data-notebooks, react-data-app
- Operations: monitoring-system, investigation-tool

**Note**: Repos with `"url": "local"` (tableau, legacy-reporting) cannot be resolved - no GitHub URL.

## Error Handling

### Repository Not Found
```bash
python3 scripts/resolve-repo-context.py unknown_repo
# Exit code: 1
# Stderr: Error: Repository 'unknown_repo' not found in config/repositories.json
```

**Agent response**: Ask user to clarify repository name or provide owner explicitly.

### Local Repositories
Some repos have `"url": "local"` and cannot be resolved:
- tableau
- legacy-reporting

These require explicit owner specification.

## Benefits

1. **Reduced Cognitive Load**: No need to remember "your-org" for every GitHub operation
2. **Error Prevention**: Eliminates typos in owner name
3. **Consistency**: Single source of truth for repository context
4. **Scalability**: Easy to add new repositories to config
5. **Agent Simplicity**: Agents can focus on task, not configuration details

## Testing Pattern

Before deploying agent updates, test resolution:

```bash
# Test single repo
python3 scripts/resolve-repo-context.py dbt_cloud

# Test multiple repos
for repo in dbt_cloud prefect orchestra monitoring-system; do
  echo "Testing $repo..."
  python3 scripts/resolve-repo-context.py "$repo"
done

# Test JSON output (for programmatic use)
python3 scripts/resolve-repo-context.py --json dbt_cloud | jq '.owner'
```

## Future Enhancements

Potential improvements to consider:

1. **Direct MCP Integration**: Wrapper function that auto-resolves before MCP calls
2. **Caching**: Cache resolution results for session performance
3. **Fuzzy Matching**: Handle slight repo name variations
4. **Multi-Org Support**: If repos span multiple GitHub orgs
5. **Claude Memory Integration**: Auto-inject resolved context into agent memory

## Related Files

- `scripts/resolve-repo-context.py` - Python resolver implementation
- `scripts/get-repo-owner.sh` - Bash wrapper for quick owner extraction
- `config/repositories.json` - Source of truth for repository configuration
- `.claude/agents/specialists/github-sleuth-expert.md` - Example integration

## Implementation Date
2025-10-06 - Week 1 Day 5 of MCP Architecture Transformation (Issue #88)
