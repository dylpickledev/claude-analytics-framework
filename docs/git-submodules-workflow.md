# Git Submodules Workflow for Claude Analytics Framework

**Purpose**: Manage external repositories (knowledge bases, data stack repos) using git submodules for version control and collaboration.

**Version**: 1.0.0
**Last Updated**: 2025-10-24

---

## Why Git Submodules?

**Benefits over clone-based approach**:
- ✅ **Version tracking**: Pin specific commits of external repos
- ✅ **Standard git practice**: Other developers familiar with workflow
- ✅ **Automatic updates**: Simple commands to update all repos
- ✅ **Lightweight**: Only clone what you need
- ✅ **Better collaboration**: Team shares same repo versions

---

## Quick Start

### First Time Setup (New Clone)

```bash
# Clone the main repository
git clone https://github.com/your-org/claude-analytics-framework.git
cd claude-analytics-framework

# Setup all submodules
./scripts/setup-submodules.sh
```

**That's it!** All configured submodules are now initialized and updated.

---

## Daily Workflow

### Update All Submodules

```bash
# Pull latest from all submodules
./scripts/pull-all-repos.sh

# Or use git directly
git submodule update --remote --recursive
```

### Update Specific Submodule

```bash
# Update just one submodule
git submodule update --remote knowledge/team_documentation

# Or navigate and pull
cd knowledge/team_documentation
git pull origin main
```

### Check Submodule Status

```bash
# See all submodule commits
git submodule status

# See uncommitted changes in submodules
git submodule foreach 'git status'
```

---

## Configuration

### Adding New Submodules

**Method 1: Via Script (Recommended)**

1. Edit `config/repositories.json`:
```json
{
  "knowledge": {
    "new_knowledge_repo": {
      "url": "https://github.com/your-org/new-repo.git",
      "branch": "main",
      "description": "New knowledge repository"
    }
  }
}
```

2. Run conversion script:
```bash
./scripts/convert-to-submodules.sh
```

**Method 2: Manual Addition**

```bash
# Add submodule manually
git submodule add -b main https://github.com/your-org/new-repo.git knowledge/new_repo

# Initialize and update
git submodule init
git submodule update
```

### Removing Submodules

```bash
# Remove submodule
git submodule deinit knowledge/old_repo
git rm knowledge/old_repo
rm -rf .git/modules/knowledge/old_repo

# Commit the change
git commit -m "Remove old_repo submodule"
```

---

## Submodule Structure

### Default Layout

```
claude-analytics-framework/
├── .gitmodules                    # Submodule configuration
├── knowledge/                     # Knowledge repositories
│   ├── team_documentation/        # Submodule: team docs
│   └── team_knowledge_vault/      # Submodule: team notes
└── repos/                         # Data stack repositories
    ├── orchestration/
    │   ├── prefect/              # Submodule: orchestration
    │   └── dbt_orchestrator/     # Submodule: dbt workflows
    ├── ingestion/
    │   └── data_pipelines/       # Submodule: ingestion
    ├── transformation/
    │   └── dbt_project/          # Submodule: dbt models
    └── operations/
        └── monitoring/           # Submodule: monitoring
```

### Customizing Structure

Edit `config/repositories.json` to control folder structure:

```json
{
  "data_stack": {
    "transformation": {
      "dbt_cloud": {
        "url": "https://github.com/your-org/dbt-project.git",
        "branch": "main",
        "folder": "repos/transformation/dbt_project",  // Custom path
        "description": "Main dbt transformation project"
      }
    }
  }
}
```

---

## Common Tasks

### Working in a Submodule

```bash
# Navigate to submodule
cd knowledge/team_documentation

# Make changes
echo "# New doc" > new-doc.md
git add new-doc.md
git commit -m "Add new documentation"

# Push to submodule's remote
git push origin main

# Return to main repo
cd ../..

# Main repo now tracks new commit
git add knowledge/team_documentation
git commit -m "Update team_documentation to latest"
git push
```

### Updating Parent Repo After Submodule Changes

```bash
# After pulling submodule changes
git submodule update --remote

# Commit the submodule pointer update
git add knowledge/team_documentation
git commit -m "Update team_documentation submodule"
git push
```

### Clone with Submodules (One Command)

```bash
# Clone and initialize all submodules
git clone --recurse-submodules https://github.com/your-org/claude-analytics-framework.git
```

---

## Troubleshooting

### Submodule Shows Modified But No Changes

```bash
# Submodule is detached HEAD - check out branch
cd knowledge/team_documentation
git checkout main
```

### Submodule Won't Update

```bash
# Force update (careful - overwrites local changes)
git submodule update --init --force --remote
```

### Submodule Missing After Clone

```bash
# Initialize and update missing submodules
git submodule update --init --recursive
```

### Submodule Has Uncommitted Changes

```bash
# Stash changes in submodule
cd knowledge/team_documentation
git stash

# Update
git pull origin main

# Re-apply changes
git stash pop
```

---

## Best Practices

### DO ✅

- **Always use branch tracking**: `git submodule add -b main ...`
- **Update regularly**: Run `./scripts/pull-all-repos.sh` daily
- **Commit submodule updates**: After updating submodules, commit the pointer change
- **Use scripts**: Leverage `setup-submodules.sh` and `pull-all-repos.sh`
- **Document submodule purpose**: Update descriptions in `config/repositories.json`

### DON'T ❌

- **Don't edit submodules without committing**: Always commit changes in submodule first
- **Don't ignore submodule updates**: Regularly sync with team
- **Don't mix clone and submodule approaches**: Choose one strategy
- **Don't forget to push submodule changes**: Push to submodule remote before parent repo

---

## Team Collaboration

### When Teammate Adds Submodule

```bash
# Pull main repo
git pull

# Initialize new submodule
git submodule update --init --recursive
```

### When Teammate Updates Submodule

```bash
# Pull main repo (gets new submodule commit pointer)
git pull

# Update submodules to new commits
git submodule update --remote
```

### Sharing Submodule Changes

**Step 1: Commit in submodule**
```bash
cd knowledge/team_documentation
git add .
git commit -m "Update documentation"
git push origin main
```

**Step 2: Update parent repo**
```bash
cd ../..
git add knowledge/team_documentation
git commit -m "Update team_documentation submodule"
git push
```

---

## Advanced Usage

### Working on Feature Branch in Submodule

```bash
# In submodule, create feature branch
cd knowledge/team_documentation
git checkout -b feature/new-docs
# ... make changes ...
git push origin feature/new-docs

# Parent repo tracks feature branch commit
cd ../..
git add knowledge/team_documentation
git commit -m "Track team_documentation feature branch"
```

### Switching Submodule Branches

```bash
# Update .gitmodules
git config -f .gitmodules submodule.knowledge/team_documentation.branch develop

# Update submodule to new branch
git submodule update --remote knowledge/team_documentation

# Commit the change
git add .gitmodules knowledge/team_documentation
git commit -m "Switch team_documentation to develop branch"
```

---

## Migration from Clone-Based Approach

If you previously used `scripts/pull-all-repos.sh` with cloned repos:

### Step 1: Backup Existing Repos

```bash
# Backup is automatic in conversion script
./scripts/convert-to-submodules.sh
```

### Step 2: Verify Submodules

```bash
# Check all submodules configured
git submodule status

# Test update
./scripts/pull-all-repos.sh
```

### Step 3: Clean Up

```bash
# Remove backup after verification
rm -rf .repo-backup-*

# Commit submodule configuration
git add .gitmodules
git commit -m "Convert to git submodules"
git push
```

---

## Reference Commands

### Essential Commands

```bash
# Add submodule
git submodule add -b <branch> <url> <path>

# Initialize submodules
git submodule init

# Update all to latest
git submodule update --remote --recursive

# Update specific submodule
git submodule update --remote <path>

# Check status
git submodule status

# Run command in all submodules
git submodule foreach '<command>'

# Remove submodule
git submodule deinit <path>
git rm <path>
```

### Helper Scripts

```bash
# Setup all submodules (first time)
./scripts/setup-submodules.sh

# Update all submodules (daily use)
./scripts/pull-all-repos.sh

# Convert from clone-based (migration)
./scripts/convert-to-submodules.sh
```

---

## Resources

- **Git Submodules Official Docs**: https://git-scm.com/book/en/v2/Git-Tools-Submodules
- **Atlassian Submodules Guide**: https://www.atlassian.com/git/tutorials/git-submodule
- **GitHub Submodules Help**: https://docs.github.com/en/get-started/getting-started-with-git/about-git-submodule

---

**Version**: 1.0.0
**Last Updated**: 2025-10-24
**Maintainer**: ADLC Platform Team
