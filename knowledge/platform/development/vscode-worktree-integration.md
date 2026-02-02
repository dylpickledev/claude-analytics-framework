# VS Code Worktree Integration for ADLC Workflow

**Complete guide to seamless VS Code worktree management integrated with the Analytics Development Lifecycle**

## Overview

The DA Agent Hub implements native VS Code worktree support (available in VS Code 2025+) to provide **dedicated VS Code instances per project** with zero context contamination. This integration is seamlessly built into the ADLC 4-command workflow.

### Benefits

✅ **Project Isolation**: Each feature/project gets dedicated worktree and VS Code workspace
✅ **Zero Context Loss**: Switch between projects without losing state
✅ **Claude Context Separation**: Each worktree maintains independent AI conversation history
✅ **Parallel Development**: Work on multiple projects simultaneously without branch switching
✅ **Automatic Cleanup**: Worktrees removed when projects complete

## Quick Start

### One-Time Setup

```bash
# Configure VS Code worktree integration (recommended)
claude /setup-worktrees

# Or run script directly if needed
./scripts/setup-worktrees.sh
```

**What this does:**
- Creates `../da-agent-hub-worktrees/` base directory
- Installs recommended VS Code extensions (GitWorktrees, GitLens, Git Graph)
- Configures VS Code global settings for worktree detection
- Updates .gitignore to exclude worktree directories

### Daily Workflow

```bash
# 1. Build project (creates worktree automatically)
claude /build "customer-analytics"
# → Prompts to launch VS Code
# → Opens dedicated workspace if you choose yes

# 2. Switch between projects
claude /switch feature-safety-metrics
# → Detects worktree
# → Prompts to open in VS Code

# 3. Complete project (removes worktree)
claude /complete "feature-customer-analytics"
# → Checks for open VS Code instances
# → Safely removes worktree

# Note: Slash commands call underlying scripts:
# /build → ./scripts/build.sh
# /switch → ./scripts/switch.sh
# /complete → ./scripts/finish.sh
```

## Integration with ADLC Phases

### 💡 PLAN Phase (Layer 1)

**Setup creates foundation for isolated development:**
- Each roadmap item can have dedicated worktree
- Strategic planning artifacts stay isolated per initiative

### 🔧 DEVELOP + TEST + DEPLOY Phase (Layer 2)

**Automatic worktree management:**

```bash
# Build command creates everything
claude /build "data-quality-monitoring"

# Creates:
# 1. Git worktree: ../da-agent-hub-worktrees/feature-data-quality-monitoring/
# 2. VS Code workspace file with optimized settings
# 3. Project structure in worktree
# 4. Prompts to launch dedicated VS Code instance
```

**Benefits during development:**
- Each project has isolated file system state
- No branch switching required
- Separate Claude Code conversation per project
- Zero contamination between features

### 🤖 OPERATE + OBSERVE + DISCOVER + ANALYZE Phase (Layer 3)

**Investigation and debugging:**
- Create worktree for production issue investigation
- Main repo vs fix branch side-by-side comparison
- Isolated debugging environment

## Architecture

### Directory Structure

```
~/da-agent-hub/                           # Main repository (always on main)
~/da-agent-hub-worktrees/                 # Worktree base directory
    ├── feature-customer-analytics/       # Dedicated worktree
    │   ├── .git → ~/da-agent-hub/.git/  # Git reference (not full clone)
    │   ├── projects/active/...          # Project files
    │   └── feature-customer-analytics.code-workspace  # VS Code config
    ├── fix-pipeline-error/               # Another project
    └── research-ml-models/               # Research project
```

### Worktree Benefits

**Traditional branch switching:**
```bash
git checkout feature-branch
# ❌ VS Code state changes
# ❌ Claude context mixed
# ❌ Working directory changes
# ❌ Can't work on multiple features simultaneously
```

**With worktrees:**
```bash
claude /build "feature-name"
# ✅ Dedicated directory
# ✅ Separate VS Code instance
# ✅ Isolated Claude context
# ✅ Parallel development enabled
# ✅ Main repo always clean
```

## VS Code Workspace Configuration

### Auto-Generated Workspace File

Each `build.sh` execution creates optimized workspace configuration:

```json
{
  "folders": [
    {
      "name": "🔧 feature-project-name",
      "path": "."
    }
  ],
  "settings": {
    "git.detectWorktrees": true,
    "files.autoSave": "onFocusChange",
    "files.autoSaveDelay": 1000,
    "files.watcherExclude": {
      "**/.git/objects/**": true,
      "**/.git/subtree-cache/**": true,
      "**/.git/worktrees/**": false,
      "**/node_modules/**": true,
      "**/.venv/**": true
    },
    "terminal.integrated.cwd": "${workspaceFolder}"
  },
  "extensions": {
    "recommendations": [
      "GitWorktrees.git-worktrees",
      "eamodio.gitlens",
      "mhutchie.git-graph"
    ]
  }
}
```

### Global VS Code Settings

**Location**: `~/Library/Application Support/Code/User/settings.json`

**Key settings for worktree support:**
```json
{
  "git.detectWorktrees": true,
  "git.autoRepositoryDetection": true,
  "files.autoSave": "onFocusChange",
  "files.watcherExclude": {
    "**/.git/worktrees/**": false
  },
  "window.restoreWindows": "all",
  "workbench.editor.revealIfOpen": true
}
```

## Script Enhancements

### build.sh Integration

**Enhanced workflow:**
1. Creates project structure (existing functionality)
2. Creates git worktree in `../da-agent-hub-worktrees/[project-name]`
3. Generates optimized VS Code workspace file
4. Prompts user to launch VS Code
5. Returns to original branch

**User experience:**
```bash
claude /build "customer-analytics"

# Output:
🔧 Building project for idea: customer-analytics
📋 Found idea in organized: ideas/organized/analytics/customer-analytics.md
📦 Promoting idea to pipeline...
🏗️ Creating project structure...
✅ Project structure created

🌿 Setting up git worktree for isolated development...
✅ Worktree created: ../da-agent-hub-worktrees/feature-customer-analytics
✅ VS Code workspace file created

🚀 VS Code Integration:
   📁 Workspace: ../da-agent-hub-worktrees/feature-customer-analytics/feature-customer-analytics.code-workspace

Launch VS Code for this project? (y/n) y
✅ VS Code launched!

✅ Idea successfully built into project!
📁 Project location: projects/active/feature-customer-analytics/
🌿 Worktree location: ../da-agent-hub-worktrees/feature-customer-analytics
```

### switch.sh Integration

**Enhanced workflow:**
1. Commits and pushes current work (existing functionality)
2. Switches to target branch
3. Detects if worktree exists for target branch
4. Prompts to open worktree in VS Code

**User experience:**
```bash
claude /switch feature-safety-metrics

# Output:
🔄 Starting project/task switch workflow...
ℹ️  Current branch: feature-customer-analytics
ℹ️  Uncommitted changes detected. Committing current work...
✅ Changes committed successfully
ℹ️  Pushing feature-customer-analytics to remote for preservation...
✅ Branch pushed to remote successfully
ℹ️  Switching to main branch...
✅ Switched to main and synced
ℹ️  Switching to target branch: feature-safety-metrics
✅ Switched to existing branch: feature-safety-metrics

ℹ️  Worktree detected for feature-safety-metrics

🚀 VS Code options:
   • Workspace: ../da-agent-hub-worktrees/feature-safety-metrics/*.code-workspace

Open VS Code for this worktree? (y/n) y
✅ VS Code launched with workspace file

🔄 Context switching complete!
```

### finish.sh Integration

**Enhanced workflow:**
1. Archives project (existing functionality)
2. Checks if worktree is in use (VS Code open)
3. Safely removes worktree
4. Cleans up git references

**User experience:**
```bash
claude /complete "feature-customer-analytics"

# Output:
🎯 Finishing project: feature-customer-analytics
📦 Using work-complete.sh for comprehensive cleanup...
✅ Project moved to projects/completed/

🌿 Cleaning up git worktree...
✅ Worktree removed: ../da-agent-hub-worktrees/feature-customer-analytics

📚 Extracting reusable patterns to memory...
✅ Extracted patterns from 3 files
📁 Saved to: memory/recent/2025-10.md

🔗 Updating related archived ideas...
Updated: customer-analytics.md

✅ Project 'feature-customer-analytics' completed successfully!
```

## Advanced Usage

### Multiple Projects in Parallel

```bash
# Morning: Three parallel initiatives
claude /build "customer-analytics"     # VS Code Window 1
claude /build "safety-dashboard"       # VS Code Window 2
claude /build "pipeline-optimization"  # VS Code Window 3

# Each has:
# - Dedicated worktree directory
# - Separate VS Code instance
# - Isolated Claude context
# - Independent git state
```

### Switching Between Projects

```bash
# Quick context switch
claude /switch feature-customer-analytics
# → Saves current work
# → Switches branch
# → Opens worktree in VS Code
# → Zero loss of state
```

### Manual Worktree Launch

```bash
# Open existing worktree without switching
code ../da-agent-hub-worktrees/feature-project-name/*.code-workspace

# Or navigate in terminal
cd ../da-agent-hub-worktrees/feature-project-name
code .
```

## VS Code Extensions

### Recommended Extensions (Auto-Installed)

**GitWorktrees.git-worktrees**
- Enhanced worktree management UI
- Visual worktree navigation
- Quick switching between worktrees

**eamodio.gitlens**
- Branch visualization
- Commit history per worktree
- Blame and file history

**mhutchie.git-graph**
- Visual git graph across worktrees
- Branch relationships
- Merge visualization

### Extension Features

**Source Control View:**
- All worktrees visible in one view
- Switch between worktrees with click
- Changes tracked per worktree

**Terminal Integration:**
- Each worktree has independent terminal
- Correct working directory auto-set
- Commands run in worktree context

## Troubleshooting

### Worktree Already Exists

**Issue**: `/build` reports worktree creation skipped

**Solution**:
```bash
# List existing worktrees
git worktree list

# Remove old worktree
git worktree remove ../da-agent-hub-worktrees/[project-name] --force

# Retry build
claude /build "[idea-name]"
```

### VS Code Not Detecting Worktrees

**Issue**: Worktrees not showing in Source Control view

**Solution**:
```bash
# Check VS Code settings
code ~/Library/Application\ Support/Code/User/settings.json

# Verify this setting exists:
{
  "git.detectWorktrees": true
}

# Reload VS Code window
# Cmd+Shift+P → "Developer: Reload Window"
```

### Worktree Cleanup Blocked

**Issue**: `/complete` cannot remove worktree (VS Code open)

**Solution**:
```bash
# 1. Close VS Code instance for that worktree
# 2. Retry complete command
claude /complete "[project-name]"

# Or force remove manually
git worktree remove ../da-agent-hub-worktrees/[project-name] --force
```

### VS Code CLI Not Available

**Issue**: `code` command not found

**Solution**:
```bash
# macOS: Install Shell Command
# 1. Open VS Code
# 2. Cmd+Shift+P
# 3. "Shell Command: Install 'code' command in PATH"

# Verify installation
which code
# Should output: /usr/local/bin/code
```

## Best Practices

### Worktree Naming

✅ **Good**: Matches git branch name
```bash
# Branch: feature-customer-analytics
# Worktree: ../da-agent-hub-worktrees/feature-customer-analytics
```

❌ **Avoid**: Different names cause confusion
```bash
# Branch: feature-customer-analytics
# Worktree: ../da-agent-hub-worktrees/analytics-project  # Confusing
```

### Workspace Management

✅ **Use workspace files**: Better than opening directory directly
```bash
code ../da-agent-hub-worktrees/feature-name/*.code-workspace
```

✅ **One window per worktree**: Cleaner than multi-root workspace
```bash
# Each project gets own window
claude /build "project-1"  # Window 1
claude /build "project-2"  # Window 2
```

### Cleanup Discipline

✅ **Complete projects properly**: Use `/complete`
```bash
# Proper cleanup
claude /complete "feature-customer-analytics"
# → Archives project
# → Removes worktree
# → Updates references
```

❌ **Avoid manual deletion**: Can leave git references dangling
```bash
# Don't do this
rm -rf ../da-agent-hub-worktrees/feature-name  # Leaves git refs
```

## FAQ

### Q: Do worktrees duplicate the entire repository?

**A**: No. Worktrees share the same `.git` directory, only checking out working tree files. Very space-efficient.

### Q: Can I use worktrees with remote repositories?

**A**: Yes. Each worktree can push/pull independently. The `switch.sh` script handles this automatically.

### Q: What happens to worktrees when I move between machines?

**A**: Worktrees are local only. The main repository syncs via git, but you'll need to recreate worktrees on new machines. The `/setup-worktrees` command makes this easy.

### Q: Can I have more than one VS Code window open?

**A**: Absolutely! That's the whole point. Each project gets its own worktree and VS Code instance.

### Q: Does this work with other editors?

**A**: Worktrees are git-native, so they work with any editor. The automation scripts are VS Code-specific, but you can use worktrees manually with other tools.

## Performance Considerations

### Disk Space

**Worktree overhead**: Minimal
- Shares `.git` directory with main repo
- Only duplicates working tree files
- Example: 100MB repo → ~10MB per worktree

### VS Code Performance

**Multiple instances**: Generally fine
- Each instance is independent
- CPU/memory usage per window
- Modern machines handle 5-10 instances easily

### Git Operations

**Worktree speed**: Fast
- Native git feature (not symlinks or submodules)
- Same performance as regular working tree
- Branch operations instant

## Related Documentation

- [Context Switching Workflows](./context-switching-workflows.md) - Advanced switching patterns
- [Setup Guide](./setup.md) - Initial DA Agent Hub configuration
- [Claude Interactions](./claude-interactions.md) - Working with Claude in worktrees

## Summary

VS Code worktree integration transforms the ADLC workflow by providing:

✅ **Dedicated environments** per project with zero contamination
✅ **Seamless automation** via enhanced build/switch/finish scripts
✅ **One-time setup** with `/setup-worktrees` command
✅ **Parallel development** on multiple features simultaneously
✅ **Automatic cleanup** when projects complete

**Result**: Maximum focus, minimum context switching overhead, and professional-grade analytics development workflow.

---

*Seamless VS Code worktree integration for the Analytics Development Lifecycle - dedicated instances per project for maximum productivity.*
