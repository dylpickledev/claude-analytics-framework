# Filesystem MCP Server Capabilities

## Overview

The `@modelcontextprotocol/server-filesystem` is a Node.js server implementing the Model Context Protocol (MCP) for secure filesystem operations. It provides AI agents with controlled access to local filesystem operations through a set of well-defined tools, enforcing strict security boundaries through allowed directory configurations.

**Package**: `@modelcontextprotocol/server-filesystem`
**Source**: [GitHub - modelcontextprotocol/servers/filesystem](https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem)
**npm**: [@modelcontextprotocol/server-filesystem](https://www.npmjs.com/package/@modelcontextprotocol/server-filesystem)

## Security Model

### Allowed Directories

The filesystem MCP server enforces strict access control through "allowed directories" - a whitelist of directories where all filesystem operations must occur. This prevents unauthorized access to system files or sensitive directories.

**Two Configuration Methods**:

1. **Command-line Arguments** (Static):
   ```json
   {
     "mcpServers": {
       "filesystem": {
         "command": "npx",
         "args": [
           "-y",
           "@modelcontextprotocol/server-filesystem",
           "/Users/username/Desktop",
           "/path/to/project"
         ]
       }
     }
   }
   ```

2. **Dynamic Roots Protocol** (Recommended):
   - MCP clients that support the Roots protocol can dynamically update allowed directories
   - Enables runtime directory updates via `roots/list_changed` notifications without server restart
   - Client-provided roots completely replace server-side allowed directories when provided
   - More flexible and modern integration experience

### Path Validation & Security

**Built-in Security Features**:
- **Path Sanitization**: Automatic prevention of directory traversal attacks (e.g., `../../../etc/passwd`)
- **Canonical Path Resolution**: All paths are resolved to their absolute canonical form before validation
- **Allowed Directory Enforcement**: All operations strictly validated against allowed directory list
- **Subdirectory Access**: Subdirectories within allowed directories are accessible
- **Initialization Protection**: Server throws error if started without allowed directories (no command-line args AND no roots protocol support)

**Security Best Practices**:
- Never rely on blacklist filters (blocking `../`) - easily bypassed
- Always use absolute path resolution before validation
- Set narrow allowed directories - only grant access to directories truly needed
- Use Roots protocol for dynamic updates instead of overly broad initial allowlist
- Treat filesystem access as privileged operation requiring explicit authorization

**Known Vulnerability (Fixed)**:
Earlier versions used simple `.startsWith()` comparison for path validation without enforcing that paths were directories. This has been addressed in current versions with proper canonical path validation.

## Complete Tool Inventory

### 1. read_text_file

**Description**: Read complete contents of a file as text with optional line limits.

**Parameters**:
- `path` (string, required): File path to read
- `head` (number, optional): Return only first N lines
- `tail` (number, optional): Return only last N lines

**Constraints**:
- Cannot specify both `head` and `tail` simultaneously
- Always treats file as UTF-8 text
- Memory-efficient implementation for large files when using head/tail

**Returns**: File contents as UTF-8 text

**Use Cases**:
- Read configuration files
- Preview large log files without loading entire content
- Check headers/metadata at start of files (head)
- View recent log entries (tail)
- Quick inspection of file contents

**Example**:
```json
{
  "path": "/allowed/directory/config.yaml",
  "head": 20
}
```

### 2. read_media_file

**Description**: Read image or audio files, returning base64-encoded data with MIME type.

**Parameters**:
- `path` (string, required): Path to image or audio file

**Returns**:
- Base64-encoded file data
- MIME type of the file

**Use Cases**:
- Read image files for analysis
- Process audio files
- Embed media in responses
- Validate media file formats

**Example**:
```json
{
  "path": "/allowed/directory/screenshot.png"
}
```

### 3. read_multiple_files

**Description**: Read multiple files simultaneously in a single operation.

**Parameters**:
- `paths` (array of strings, required): Array of file paths to read

**Behavior**:
- Failed reads for individual files won't stop entire operation
- Returns results for all successfully read files
- More efficient than reading files one by one

**Returns**: Array of file contents with path references

**Use Cases**:
- Compare multiple files
- Analyze related files together
- Batch file operations
- Reduce round-trip overhead for multi-file analysis

**Example**:
```json
{
  "paths": [
    "/allowed/directory/file1.txt",
    "/allowed/directory/file2.txt",
    "/allowed/directory/file3.txt"
  ]
}
```

### 4. write_file

**Description**: Create a new file or completely overwrite an existing file with new content.

**Parameters**:
- `path` (string, required): File path to write
- `content` (string, required): Content to write to file

**Behavior**:
- Overwrites existing files WITHOUT warning
- Creates parent directories if they don't exist (within allowed directories)
- Handles text content with proper encoding

**Returns**: Success confirmation

**Use Cases**:
- Create new configuration files
- Save generated code
- Write analysis results
- Export data to files

**Caution**: Use with care as it silently overwrites existing files. Consider using `edit_file` for selective modifications.

**Example**:
```json
{
  "path": "/allowed/directory/new-config.yaml",
  "content": "version: 1.0\nname: my-project"
}
```

### 5. edit_file

**Description**: Make selective, line-based edits to existing files with pattern matching and diff preview.

**Parameters**:
- `path` (string, required): File path to edit
- `edits` (array, required): Array of edit operations
  - `oldText` (string): Text to search for (exact match or substring)
  - `newText` (string): Text to replace with
- `dryRun` (boolean, optional, default: false): Preview changes without applying

**Features**:
- Line-based and multi-line content matching
- Whitespace normalization for flexible matching
- Multiple simultaneous edits in single operation
- Automatic indentation preservation
- Git-style diff output for previews
- Dry run mode for safe preview before applying

**Returns**:
- Dry run: Detailed diff showing proposed changes
- Apply: Confirmation of changes made

**Use Cases**:
- Refactor code (rename variables, functions)
- Update configuration values
- Fix typos or errors
- Apply systematic changes across files
- Safe file modifications with preview

**Best Practice**: ALWAYS use `dryRun: true` first to preview changes before applying.

**Example**:
```json
{
  "path": "/allowed/directory/app.js",
  "edits": [
    {
      "oldText": "const oldVariable",
      "newText": "const newVariable"
    },
    {
      "oldText": "function hello() {",
      "newText": "function helloWorld() {"
    }
  ],
  "dryRun": true
}
```

### 6. create_directory

**Description**: Create a new directory or ensure a directory exists.

**Parameters**:
- `path` (string, required): Directory path to create

**Behavior**:
- Creates parent directories automatically if needed (like `mkdir -p`)
- Succeeds silently if directory already exists
- All parent directories must be within allowed directories

**Returns**: Success confirmation

**Use Cases**:
- Set up project directory structures
- Ensure required paths exist before file operations
- Create nested directory hierarchies
- Prepare workspace for operations

**Example**:
```json
{
  "path": "/allowed/directory/new/nested/structure"
}
```

### 7. list_directory

**Description**: Get listing of all files and directories in specified path with type prefixes.

**Parameters**:
- `path` (string, required): Directory path to list

**Returns**:
- List of directory contents
- Each item prefixed with `[FILE]` or `[DIR]`

**Use Cases**:
- Understand directory structure
- Find specific files within directory
- Navigate filesystem
- Validate directory contents

**Example**:
```json
{
  "path": "/allowed/directory/projects"
}
```

**Sample Output**:
```
[DIR] subfolder
[FILE] config.yaml
[FILE] README.md
[DIR] src
```

### 8. list_directory_with_sizes

**Description**: List directory contents with file sizes and summary statistics.

**Parameters**:
- `path` (string, required): Directory path to list
- `sortBy` (string, optional): Sort by "name" or "size" (default: "name")

**Returns**:
- List of directory contents with sizes
- Type prefixes ([FILE] or [DIR])
- Summary statistics (total files, total directories)

**Use Cases**:
- Identify large files
- Disk space analysis
- Sort files by size for cleanup
- Directory size auditing

**Example**:
```json
{
  "path": "/allowed/directory/data",
  "sortBy": "size"
}
```

### 9. move_file

**Description**: Move or rename files and directories.

**Parameters**:
- `source` (string, required): Source path
- `destination` (string, required): Destination path

**Behavior**:
- Both source and destination must be within allowed directories
- Fails if destination already exists (no overwrite)
- Works across different directories
- Can be used for simple renaming within same directory

**Returns**: Success confirmation

**Use Cases**:
- Rename files or directories
- Reorganize project structure
- Move files between directories
- Archive files to different locations

**Example**:
```json
{
  "source": "/allowed/directory/old-name.txt",
  "destination": "/allowed/directory/new-name.txt"
}
```

### 10. search_files

**Description**: Recursively search for files and directories matching a pattern.

**Parameters**:
- `path` (string, required): Starting directory for search
- `pattern` (string, required): Search pattern (glob-style)
- `excludePatterns` (array of strings, optional): Patterns to exclude

**Behavior**:
- Searches through all subdirectories from starting path
- Case-insensitive partial name matching
- Returns full paths to all matching items
- Supports glob-style wildcard patterns

**Returns**: Array of full paths to matching files/directories

**Use Cases**:
- Find files when exact location unknown
- Search for specific file types (e.g., `*.yaml`)
- Locate configuration files
- Find files by naming convention
- Filter out unwanted directories (node_modules, .git)

**Example**:
```json
{
  "path": "/allowed/directory/project",
  "pattern": "*.yaml",
  "excludePatterns": ["node_modules", ".git", "dist"]
}
```

### 11. directory_tree

**Description**: Generate recursive JSON directory structure with detailed metadata.

**Parameters**:
- `path` (string, required): Starting directory
- `excludePatterns` (array of strings, optional): Patterns to exclude from tree

**Returns**:
- JSON structure with nested hierarchy
- Each entry includes: `name`, `type` (file/directory), `children` (for directories)
- Files have no children array
- Directories always have children array (may be empty)
- Formatted with 2-space indentation for readability

**Use Cases**:
- Visualize project structure
- Document directory organization
- Understand complex codebases
- Generate project maps
- Create navigation structures

**Example**:
```json
{
  "path": "/allowed/directory/project",
  "excludePatterns": ["node_modules", ".git"]
}
```

**Sample Output**:
```json
{
  "name": "project",
  "type": "directory",
  "children": [
    {
      "name": "src",
      "type": "directory",
      "children": [
        {
          "name": "index.js",
          "type": "file"
        }
      ]
    },
    {
      "name": "README.md",
      "type": "file"
    }
  ]
}
```

### 12. get_file_info

**Description**: Retrieve detailed metadata about a file or directory.

**Parameters**:
- `path` (string, required): Path to file or directory

**Returns**:
- Size (in bytes)
- Creation time
- Last modified time
- Last access time
- Type (file or directory)
- Permissions

**Use Cases**:
- Check file characteristics without reading content
- Verify file existence
- Compare file timestamps
- Audit file permissions
- Determine file type
- Monitor file changes

**Example**:
```json
{
  "path": "/allowed/directory/important-file.txt"
}
```

**Sample Output**:
```json
{
  "size": 1024,
  "created": "2025-01-15T10:30:00Z",
  "modified": "2025-01-16T14:20:00Z",
  "accessed": "2025-01-16T15:45:00Z",
  "type": "file",
  "permissions": "rw-r--r--"
}
```

### 13. list_allowed_directories

**Description**: Returns list of all directories the server is allowed to access.

**Parameters**: None

**Returns**: Array of allowed directory paths

**Use Cases**:
- Understand current access boundaries
- Verify server configuration
- Debug permission issues
- Document allowed access scope
- Validate security settings

**Example**:
```json
{}
```

**Sample Output**:
```json
{
  "allowedDirectories": [
    "/Users/username/projects",
    "/Users/username/Desktop",
    "/var/tmp/workspace"
  ]
}
```

## Agent Integration Recommendations

### Agents That Should Have Filesystem Access

Based on the tool capabilities and typical use cases:

**HIGH PRIORITY - Core Development Agents**:

1. **github-sleuth-expert** (CURRENTLY HAS ACCESS)
   - **Why**: Needs to read repository files for issue investigation context
   - **Tools Used**: `read_text_file`, `read_multiple_files`, `search_files`, `directory_tree`
   - **Use Cases**: Reading config files, analyzing code for issue context, reviewing project structure
   - **Security**: Read-only access to project repositories

2. **documentation-expert**
   - **Why**: Creates and maintains documentation files, organizes knowledge base
   - **Tools Used**: `write_file`, `edit_file`, `create_directory`, `list_directory`, `search_files`
   - **Use Cases**: Creating docs, updating knowledge base, organizing documentation structure
   - **Security**: Write access to `knowledge/` directory

3. **qa-coordinator** / **qa-engineer-role**
   - **Why**: Needs to read test files, analyze code for testing, create test documentation
   - **Tools Used**: `read_text_file`, `read_multiple_files`, `search_files`, `write_file`
   - **Use Cases**: Test file analysis, test plan creation, quality report generation
   - **Security**: Read access to all repos, write access to test documentation

4. **analytics-engineer-role**
   - **Why**: Works with dbt project files, needs to read/analyze SQL models
   - **Tools Used**: `read_text_file`, `read_multiple_files`, `search_files`, `directory_tree`
   - **Use Cases**: dbt model analysis, SQL file review, project structure understanding
   - **Security**: Read-only access to dbt_cloud repository

5. **data-engineer-role**
   - **Why**: Analyzes pipeline code, configuration files, orchestration scripts
   - **Tools Used**: `read_text_file`, `read_multiple_files`, `search_files`, `get_file_info`
   - **Use Cases**: Pipeline code review, config analysis, debugging orchestration
   - **Security**: Read-only access to data engineering repositories

**MEDIUM PRIORITY - Specialized Analysis**:

6. **dbt-expert**
   - **Why**: Deep analysis of dbt project structure, models, macros, tests
   - **Tools Used**: `read_text_file`, `read_multiple_files`, `search_files`, `directory_tree`
   - **Use Cases**: dbt lineage analysis, model optimization, macro review
   - **Security**: Read-only access to dbt projects

7. **ui-ux-developer-role**
   - **Why**: Reads React/Streamlit code, analyzes UI component structure
   - **Tools Used**: `read_text_file`, `read_multiple_files`, `search_files`, `directory_tree`
   - **Use Cases**: Component analysis, code review, project structure understanding
   - **Security**: Read-only access to UI repositories

8. **react-expert** / **streamlit-expert**
   - **Why**: Specialized code analysis for framework-specific issues
   - **Tools Used**: `read_text_file`, `read_multiple_files`, `search_files`
   - **Use Cases**: Deep code analysis, pattern identification, troubleshooting
   - **Security**: Read-only access to relevant repositories

**LOW PRIORITY / OPTIONAL**:

9. **business-analyst-role**
   - **Why**: May need to read documentation, requirements files
   - **Tools Used**: `read_text_file`, `list_directory`
   - **Use Cases**: Documentation review, requirements analysis
   - **Security**: Read-only access to documentation directories

10. **project-manager-role**
    - **Why**: Project documentation access, progress tracking files
    - **Tools Used**: `read_text_file`, `list_directory`, `search_files`
    - **Use Cases**: Project status review, documentation access
    - **Security**: Read-only access to project directories

### Agents That Should NOT Have Filesystem Access

**No legitimate use case for filesystem operations**:

1. **snowflake-expert** - Works via Snowflake MCP, no file access needed
2. **orchestra-expert** - Works via Orchestra MCP/API, no file access needed
3. **prefect-expert** - Works via Prefect MCP, no file access needed
4. **aws-expert** - Works via AWS MCP, no file access needed
5. **tableau-expert** - Works via Tableau MCP/API, no file access needed
6. **business-context** - Works via Atlassian/Slack MCP, no file access needed

## Configuration Examples

### Current da-agent-hub Configuration

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/TehFiestyGoat/GRC/da-agent-hub"
      ],
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

**Current Access**:
- Single allowed directory: `/Users/TehFiestyGoat/GRC/da-agent-hub`
- All subdirectories accessible (projects/, knowledge/, .claude/, etc.)
- Sufficient for current platform needs

### Multi-Repository Configuration

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/username/GRC/da-agent-hub",
        "/Users/username/GRC/dbt_cloud",
        "/Users/username/GRC/react-customer-dashboard"
      ],
      "disabled": false
    }
  }
}
```

### Scoped Access Configuration

```json
{
  "mcpServers": {
    "filesystem-readonly": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/username/GRC/dbt_cloud",
        "/Users/username/GRC/orchestra-pipelines"
      ],
      "disabled": false,
      "_comment": "Read-only access for analysis agents"
    },
    "filesystem-docs": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/username/GRC/da-agent-hub/knowledge"
      ],
      "disabled": false,
      "_comment": "Write access for documentation agents"
    }
  }
}
```

## Testing & Debugging

### MCP Inspector

Test filesystem server interactively using MCP Inspector:

```bash
npx @modelcontextprotocol/inspector npx @modelcontextprotocol/server-filesystem /path/to/allowed/dir
```

This provides interactive testing interface for:
- Trying different tools
- Validating parameters
- Testing path validation
- Debugging configuration issues

## Limitations & Edge Cases

### Path Restrictions
- **Absolute Paths Required**: All paths must be absolute, not relative
- **Symlink Handling**: Symlinks are resolved to canonical paths and validated against allowed directories
- **Case Sensitivity**: Path matching is case-sensitive on Unix-like systems, case-insensitive on Windows
- **Hidden Files**: No special handling - hidden files (`.git`, `.env`) accessible if in allowed directories

### File Operations
- **File Size**: No explicit file size limits, but very large files may impact performance
- **Binary Files**: `read_text_file` treats all files as UTF-8 text, may produce garbage for binary files (use `read_media_file` instead)
- **Line Ending Handling**: Preserves original line endings (CRLF vs LF)
- **Encoding**: Always assumes UTF-8 for text operations

### Directory Operations
- **Empty Directories**: Can be created and listed
- **Directory Deletion**: NOT SUPPORTED - no tool for deleting directories or files
- **Recursive Operations**: `search_files` and `directory_tree` can be expensive on large directory trees
- **Permission Errors**: Operations fail if OS-level permissions deny access, even within allowed directories

### Concurrency
- **Race Conditions**: Multiple concurrent writes to same file can cause race conditions
- **File Locking**: No built-in file locking mechanism
- **Atomic Operations**: Individual operations are atomic, but multi-step operations are not

### Security Edge Cases
- **Time-of-Check-Time-of-Use**: Small window between path validation and operation execution
- **Allowed Directory Changes**: If using Roots protocol, allowed directories can change during session
- **Permission Escalation**: Cannot access files/directories without OS-level read/write permissions
- **Dangerous Operations**: No built-in protection against overwriting critical files within allowed directories

## Best Practices

### For Agent Developers

1. **Always Check Allowed Directories First**:
   ```
   Use list_allowed_directories to understand current access scope
   ```

2. **Use Dry Run for Edits**:
   ```json
   { "dryRun": true }  // ALWAYS preview edits first
   ```

3. **Prefer edit_file Over write_file**:
   ```
   Use edit_file for modifications, write_file only for new files
   ```

4. **Use read_multiple_files for Batch Operations**:
   ```
   More efficient than sequential single-file reads
   ```

5. **Leverage search_files with Exclusions**:
   ```json
   { "excludePatterns": ["node_modules", ".git", "dist", "__pycache__"] }
   ```

6. **Use head/tail for Large Files**:
   ```json
   { "head": 50 }  // Preview instead of loading entire file
   ```

### For Platform Administrators

1. **Principle of Least Privilege**:
   - Grant minimal necessary directory access
   - Use multiple filesystem server instances for different access levels

2. **Explicit Allow Lists**:
   - Never grant access to home directory root
   - Explicitly list each project directory needed

3. **Monitor Access Patterns**:
   - Review which agents access which directories
   - Audit for unexpected access patterns

4. **Separate Read/Write Access**:
   - Consider separate server instances for read-only vs write access
   - Different agents can use different server configurations

5. **Regular Configuration Review**:
   - Periodically review allowed directories
   - Remove access to deprecated projects

## References

- **Official Repository**: https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem
- **npm Package**: https://www.npmjs.com/package/@modelcontextprotocol/server-filesystem
- **MCP Documentation**: https://modelcontextprotocol.io/
- **Security Best Practices**: https://www.mcpevals.io/blog/mcp-security-best-practices
- **Path Traversal Prevention**: https://owasp.org/www-community/attacks/Path_Traversal

## Related Documentation

- `.claude/agents/specialists/github-sleuth-expert.md` - Example agent using filesystem MCP
- `.claude/skills/reference-knowledge/cross-system-analysis-patterns/SKILL.md` - Multi-tool coordination patterns
