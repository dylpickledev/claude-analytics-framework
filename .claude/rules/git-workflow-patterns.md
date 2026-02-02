# Git Workflow Patterns

## Protected Branches - Security Rules

### Protected Branch List
- `main`
- `master`
- `production`
- `prod`
- Any branch matching pattern: `release/*`, `hotfix/*`

### Mandatory Workflow
1. **ALWAYS create feature branch** before making any code changes
2. **ALWAYS create Pull Request** for code review and approval
3. **NEVER push directly** to protected branches
4. **NEVER merge without approval** (except for da-agent-hub documentation updates)

### Pre-Commit Safety Check
Before executing ANY git commit command, Claude MUST:

```bash
# Check current branch
CURRENT_BRANCH=$(git branch --show-current)

# Protected branches list
PROTECTED_BRANCHES=("main" "master" "production" "prod")

# Check if on protected branch
for branch in "${PROTECTED_BRANCHES[@]}"; do
    if [ "$CURRENT_BRANCH" = "$branch" ]; then
        echo "❌ ERROR: Cannot commit directly to protected branch '$CURRENT_BRANCH'"
        echo "Please create a feature branch first:"
        echo "  git checkout -b feature/your-feature-name"
        exit 1
    fi
done
```

### Enforcement Protocol
**If user asks to commit to protected branch:**
1. **Stop immediately** - Do not execute the commit
2. **Explain the security policy** - Protected branches require PR workflow
3. **Offer to create feature branch** - Suggest branch name based on work
4. **Create PR after commit** - Ensure changes go through approval process

### Exceptions
**ONLY exception**: Documentation-only changes in da-agent-hub repository
- Changes to `*.md` files in da-agent-hub can be committed to main
- All code changes still require feature branch + PR workflow
- Claude should confirm: "These are documentation-only changes, proceeding with direct commit to main"

## Branch Naming Conventions

### Standard Prefixes
- `feature/[description]` - New features
- `fix/[description]` - Bug fixes
- `docs/[description]` - Documentation updates (code repos only)
- `refactor/[description]` - Code refactoring
- `test/[description]` - Testing improvements

### Best Practices
- Use descriptive, kebab-case names
- Keep branch names concise but clear
- Include issue/ticket numbers when applicable (e.g., `feature/TICKET-123-add-dashboard`)

## Repository-Specific Branch Structures

### dbt_cloud
- **master**: Production branch
- **dbt_dw**: Staging branch
- **Workflow**: Branch from dbt_dw, sync before creating features

### dbt_errors_to_issues
- **main**: Production branch (no staging branch)
- **Workflow**: Branch directly from main

### roy_kent
- **master**: Production branch (no staging branch)
- **Workflow**: Branch directly from master

### sherlock
- **main**: Production branch (no staging branch)
- **Workflow**: Branch directly from main

## Standard Workflow Steps

### Always Start from Up-to-Date Main
**CRITICAL**: Ensure main branch is current before creating features

```bash
# Standard startup sequence
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

**Why This Matters:**
- Prevents merge conflicts
- Ensures you have latest code
- Critical for `/build` command and all da-agent-hub changes

### Complete Workflow Checklist
1. ✅ Sync with production/staging branch before creating features
2. ✅ Create descriptive branch names
3. ✅ Keep branches focused and atomic
4. ✅ Test locally before pushing
5. ✅ Create PR with clear description
6. ✅ Wait for approval (except da-agent-hub docs)
7. ✅ Clean up branches after merge

## Common Git Patterns

### Feature Development
```bash
# Start feature
git checkout main && git pull origin main
git checkout -b feature/new-dashboard

# Regular commits
git add .
git commit -m "feat: Add customer dashboard component"

# Push and create PR
git push -u origin feature/new-dashboard
gh pr create --title "Add customer dashboard" --body "..."
```

### Bug Fixes
```bash
# Start fix
git checkout main && git pull origin main
git checkout -b fix/data-quality-issue

# Fix and commit
git add .
git commit -m "fix: Correct null handling in customer model"

# Push and create PR
git push -u origin fix/data-quality-issue
```

### Documentation Updates (da-agent-hub only)
```bash
# Can commit directly to main
git checkout main
git pull origin main
# Make changes to .md files
git add *.md
git commit -m "docs: Update agent coordination guide"
git push origin main
```

## Error Recovery Patterns

### Accidentally Committed to Protected Branch
```bash
# Create feature branch from current state
git checkout -b feature/rescue-work

# Reset protected branch (if not pushed)
git checkout main
git reset --hard origin/main

# Work from feature branch
git checkout feature/rescue-work
```

### Merge Conflicts
```bash
# Update from main
git checkout main
git pull origin main
git checkout feature/your-branch
git merge main

# Resolve conflicts
# Edit conflicted files
git add .
git commit -m "fix: Resolve merge conflicts with main"
```

## Pattern Markers for Memory Extraction

When documenting git workflow discoveries:
- `PATTERN:` Reusable workflow sequences
- `SOLUTION:` Specific git command solutions
- `ERROR-FIX:` Git errors and their resolutions
- `ARCHITECTURE:` Branch strategy decisions
