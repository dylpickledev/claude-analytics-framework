# Filesystem MCP Server - Quick Reference

## Tool Summary (13 Tools Total)

### Read Operations (5 tools)
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `read_text_file` | Read file as text | `path`, `head`, `tail` |
| `read_media_file` | Read images/audio | `path` |
| `read_multiple_files` | Batch read files | `paths[]` |
| `get_file_info` | Get file metadata | `path` |
| `list_allowed_directories` | Show accessible dirs | none |

### Write Operations (2 tools)
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `write_file` | Create/overwrite file | `path`, `content` |
| `edit_file` | Selective edits | `path`, `edits[]`, `dryRun` |

### Directory Operations (3 tools)
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `create_directory` | Create dir (mkdir -p) | `path` |
| `list_directory` | List contents | `path` |
| `list_directory_with_sizes` | List with sizes | `path`, `sortBy` |

### Search/Navigation (3 tools)
| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `search_files` | Recursive file search | `path`, `pattern`, `excludePatterns[]` |
| `directory_tree` | JSON tree structure | `path`, `excludePatterns[]` |
| `move_file` | Move/rename | `source`, `destination` |

## Common Patterns

### Read File with Preview
```json
{
  "tool": "read_text_file",
  "path": "/allowed/dir/large-log.txt",
  "head": 50
}
```

### Safe File Edit (Always Dry Run First)
```json
// Step 1: Preview
{
  "tool": "edit_file",
  "path": "/allowed/dir/config.js",
  "edits": [{"oldText": "const old", "newText": "const new"}],
  "dryRun": true
}

// Step 2: Apply (if preview looks good)
{
  "tool": "edit_file",
  "path": "/allowed/dir/config.js",
  "edits": [{"oldText": "const old", "newText": "const new"}],
  "dryRun": false
}
```

### Find Files by Pattern
```json
{
  "tool": "search_files",
  "path": "/allowed/dir/project",
  "pattern": "*.yaml",
  "excludePatterns": ["node_modules", ".git", "dist"]
}
```

### Batch Read Related Files
```json
{
  "tool": "read_multiple_files",
  "paths": [
    "/allowed/dir/package.json",
    "/allowed/dir/tsconfig.json",
    "/allowed/dir/.eslintrc.json"
  ]
}
```

## Agent Access Recommendations

### HIGH PRIORITY (Core Development)
- **github-sleuth-expert** (CURRENTLY HAS) - Issue investigation needs code context
- **documentation-expert** - Creates/maintains docs, needs write access
- **qa-engineer-role** - Test analysis, report generation
- **analytics-engineer-role** - dbt model analysis
- **data-engineer-role** - Pipeline code review

### MEDIUM PRIORITY (Specialized Analysis)
- **dbt-expert** - Deep dbt project analysis
- **ui-ux-developer-role** - UI code review
- **react-expert** / **streamlit-expert** - Framework-specific analysis

### LOW PRIORITY (Optional)
- **business-analyst-role** - Documentation reading
- **project-manager-role** - Project status files

### NO ACCESS NEEDED
- **snowflake-expert** - Uses Snowflake MCP
- **orchestra-expert** - Uses Orchestra MCP
- **prefect-expert** - Uses Prefect MCP
- **aws-expert** - Uses AWS MCP
- **tableau-expert** - Uses Tableau MCP
- **business-context** - Uses Atlassian/Slack MCP

## Security Essentials

### Allowed Directories
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/username/projects",
        "/Users/username/workspace"
      ]
    }
  }
}
```

**Key Points**:
- ALL operations must occur within allowed directories
- Subdirectories automatically accessible
- Server throws error if no allowed directories configured
- Use Roots protocol for dynamic updates (recommended)

### Path Validation
- Automatic directory traversal prevention (blocks `../../../`)
- Canonical path resolution before validation
- Both source AND destination must be allowed (for move_file)

## Common Pitfalls

1. **Don't specify both head and tail** - Use one or the other
2. **Always dry run edits first** - Preview before applying changes
3. **write_file overwrites silently** - Use edit_file for modifications
4. **No delete operations** - Cannot remove files or directories
5. **Binary files as text** - Use read_media_file for images/audio
6. **Case sensitivity** - Paths are case-sensitive on Unix/Mac

## Testing

```bash
# Test server interactively
npx @modelcontextprotocol/inspector \
  npx @modelcontextprotocol/server-filesystem \
  /path/to/allowed/directory
```

## Full Documentation

See `filesystem-mcp-server-capabilities.md` for:
- Complete tool specifications
- Detailed use cases for each tool
- Security model deep dive
- Configuration examples
- Limitations and edge cases
- Best practices
