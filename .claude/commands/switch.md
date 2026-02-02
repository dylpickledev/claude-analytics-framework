# /switch Command - Fast Branch Switching

## Purpose
**Instant** branch switching with optional work preservation. Simple, fast, no scripts.

## Usage
```bash
claude /switch [branch-name]
```

## Protocol

### Quick Switch (Clean Working Directory)
```bash
git checkout [branch-name]
```

### Switch with Uncommitted Work (Stash)
```bash
git stash && git checkout [branch-name]
```

### Switch to Main (Default)
```bash
git checkout main
```

## Claude Instructions

When user runs `/switch [optional-branch]`:

1. **Check for uncommitted changes**: `git status --porcelain`
2. **If clean**: Direct `git checkout [branch]`
3. **If dirty**: Offer to stash or commit
4. **Default to main** if no branch specified

### Response Format
```
✅ Switched to: [branch-name]

Current branch: [branch-name]
💡 Use '/clear' to reset conversation context if needed
```

## Examples

```bash
# Switch to main
claude /switch

# Switch to specific branch
claude /switch feature-safety-sleuthing

# If you have uncommitted changes, Claude will ask:
# "You have uncommitted changes. Stash them? (y/n)"
```

## Options for Uncommitted Work

**Stash (Quick)**
```bash
git stash
git checkout [branch]
# Later: git stash pop
```

**Commit (Permanent)**
```bash
git add .
git commit -m "WIP: [description]"
git checkout [branch]
```

---

*Fast, simple branch switching - no overhead, just git.*