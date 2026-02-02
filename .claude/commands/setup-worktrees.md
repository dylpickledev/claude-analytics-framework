# /setup-worktrees Command Protocol

## Purpose
Configure VS Code worktree integration for the DA Agent Hub ADLC workflow. One-time setup that enables seamless project isolation with dedicated VS Code instances per feature/project.

## Usage
```bash
claude /setup-worktrees
```

## Protocol

### 1. Execute setup-worktrees.sh Script
```bash
./scripts/setup-worktrees.sh
```

### 2. Complete Setup Workflow
- **Check git version**: Verify worktree support available
- **Create base directory**: Initialize `../da-agent-hub-worktrees/` for all project worktrees
- **Install VS Code extensions**: GitWorktrees, GitLens, Git Graph (if VS Code CLI available)
- **Configure VS Code settings**: Enable worktree detection, auto-save, file watchers
- **Update .gitignore**: Exclude worktree directory from version control
- **Provide usage guidance**: Next steps and example commands

## Claude Instructions

When user runs `/setup-worktrees`:

1. **Execute setup script**: Run `./scripts/setup-worktrees.sh`
2. **Monitor output**: Watch for warnings or errors during setup
3. **Verify completion**: Check that all steps completed successfully
4. **Provide guidance**: Explain how worktrees integrate with ADLC workflow
5. **Show examples**: Demonstrate build/switch/finish commands with worktrees

### Response Format

```
🔄 VS Code Worktree Integration Setup

ℹ️  Checking git version...
✅ Git version: 2.x.x

ℹ️  Creating worktree base directory...
✅ Created: ../da-agent-hub-worktrees

✅ VS Code CLI detected
ℹ️  Installing recommended VS Code extensions...
✅ Installed: GitWorktrees.git-worktrees
✅ Already installed: eamodio.gitlens
✅ Installed: mhutchie.git-graph

ℹ️  Configuring VS Code global settings...
✅ Settings file created

ℹ️  Checking .gitignore configuration...
✅ Added worktrees to .gitignore

🔄 Setup Complete! 🎉

📋 Summary:
   • Worktree base directory: ../da-agent-hub-worktrees
   • VS Code extensions installed
   • Global settings configured for worktree support

🚀 Next steps:
   1. Build a project: ./scripts/build.sh [idea-name]
   2. The script will automatically create worktrees
   3. Switch between projects: ./scripts/switch.sh [branch-name]

💡 Usage examples:
   ./scripts/build.sh "customer-analytics"  # Creates worktree + VS Code workspace
   ./scripts/switch.sh feature-urgent-fix    # Opens worktree in VS Code
   ./scripts/finish.sh feature-project       # Cleans up worktree

✅ VS Code worktree integration is ready! 🎯
```

## Integration with ADLC Workflow

### 💡 PLAN Phase
- Setup creates foundation for isolated project development
- Each roadmap item can have dedicated worktree

### 🔧 DEVELOP + TEST + DEPLOY Phase
- `./scripts/build.sh` automatically creates worktrees
- Each project gets isolated VS Code instance
- Zero context contamination between projects

### 🤖 OPERATE + OBSERVE + DISCOVER + ANALYZE Phase
- Investigation worktrees for production debugging
- Side-by-side comparison of main vs fix branches

## What Gets Configured

### Directory Structure
```
~/da-agent-hub/                      # Main repository
~/da-agent-hub-worktrees/            # Worktree base (created by setup)
    ├── feature-customer-analytics/  # Future project worktrees
    ├── fix-pipeline-error/
    └── research-ml-models/
```

### VS Code Settings
```json
{
  "git.detectWorktrees": true,
  "git.autoRepositoryDetection": true,
  "files.autoSave": "onFocusChange",
  "files.autoSaveDelay": 1000,
  "files.watcherExclude": {
    "**/.git/worktrees/**": false
  }
}
```

### VS Code Extensions
- **GitWorktrees.git-worktrees**: Enhanced worktree management
- **eamodio.gitlens**: Branch visualization and history
- **mhutchie.git-graph**: Visual worktree navigation

## After Setup

### Building Projects with Worktrees
```bash
# Build creates worktree automatically
./scripts/build.sh "customer-analytics"

# Prompts:
# - Launch VS Code for this project? (y/n)
# - If yes: Opens dedicated VS Code instance
# - If no: Shows command to launch later
```

### Switching Between Projects
```bash
# Switch detects and offers to open worktree
./scripts/switch.sh feature-safety-metrics

# Prompts:
# - Worktree detected
# - Open VS Code for this worktree? (y/n)
```

### Completing Projects
```bash
# Finish cleans up worktree automatically
./scripts/finish.sh "feature-customer-analytics"

# Handles:
# - Checks for open VS Code instances
# - Removes worktree safely
# - Updates git references
```

## Troubleshooting

### VS Code CLI Not Found
If `code` command not available:
```bash
# macOS: Install Shell Command
# Open VS Code → Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"

# Or install VS Code first:
# https://code.visualstudio.com/
```

### Git Worktree Not Available
If git version too old:
```bash
# macOS
brew upgrade git

# Should be git 2.5+ for worktree support
```

### Manual Settings Update Required
If VS Code settings.json already exists, setup will show settings to add manually:
```
⚠️  Manual settings update required
   Add these settings to: ~/Library/Application Support/Code/User/settings.json
```

## Success Criteria
- [ ] Worktree base directory created successfully
- [ ] VS Code extensions installed (if VS Code available)
- [ ] Global settings configured for worktree detection
- [ ] .gitignore updated to exclude worktrees
- [ ] Usage guidance provided for next steps

## Benefits

### Before Worktrees
```bash
# Manual branch switching
git checkout main
git pull
git checkout feature-branch
# VS Code state contaminated
# Claude context mixed
```

### After Worktrees
```bash
# Automatic isolation
./scripts/build.sh "new-feature"
# → Dedicated worktree created
# → Separate VS Code window
# → Isolated Claude context
# → Zero contamination
```

## Examples

### First-Time Setup
```bash
# 1. Run setup once
claude /setup-worktrees
# → Configures everything

# 2. Start using immediately
./scripts/build.sh "customer-analytics"
# → Worktree created automatically
# → VS Code opens with workspace
```

### Daily Workflow
```bash
# Morning: Multiple parallel projects
./scripts/build.sh "dashboard-refresh"    # VS Code Window 1
./scripts/build.sh "data-quality-fix"     # VS Code Window 2

# Switch between projects seamlessly
./scripts/switch.sh feature-dashboard-refresh   # Focus Window 1
./scripts/switch.sh feature-data-quality-fix    # Focus Window 2

# Complete projects
./scripts/finish.sh "feature-data-quality-fix"  # Cleanup Window 2
```

---

*One-time setup for seamless VS Code worktree integration with ADLC workflow - dedicated instances per project for maximum focus and zero context contamination.*
