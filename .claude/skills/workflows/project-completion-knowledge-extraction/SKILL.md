---
name: project-completion-knowledge-extraction
description: Distribute completed project work from sandbox to proper repositories using three-tier documentation architecture. Ensures code, knowledge, and patterns are extracted and properly organized when projects complete.
disable-model-invocation: false
---

# Project Completion: Knowledge Extraction Pattern

**Pattern Type**: Project Management
**Applies To**: All projects that deploy to production or create reusable patterns
**Last Updated**: 2025-10-07
**Validated**: feature-salesjournaltoreact (production deployment)

---

## Core Principle

**Sandbox work must be distributed to proper repositories when complete**.

Projects in `projects/active/` are SANDBOXES for coordination. When projects complete:
- Code goes to production repositories
- Documentation goes to multiple locations based on audience
- Knowledge gets extracted for agent learning
- Each repository gets its own PR (never mix repos in one commit)

---

## The Problem This Solves

**Before this pattern**:
- All work stayed in project sandbox
- Documentation duplicated across repos
- Agents couldn't find patterns from completed projects
- READMEs became novels (500+ lines)
- Maintenance nightmare (update docs in 3 places)

**After this pattern**:
- Clear separation of concerns
- Zero duplication (single source of truth per topic)
- Agents discover knowledge via three-tier system
- Lightweight READMEs (< 200 lines)
- Update once, links work everywhere

---

## Three-Tier Documentation Architecture

### Tier 1: Repository README (Lightweight)
**Location**: `<repo>/README.md` (e.g., `react-customer-dashboard/README.md`)
**Purpose**: Get developers productive FAST
**Size**: < 200 lines
**Contains**:
- App purpose (2-3 sentences)
- Quick start (npm install, npm run dev)
- Technology stack (bullet list)
- Architecture overview (1 paragraph + link to Tier 2)
- Deployment quick reference (commands + link to Tier 2)
- Troubleshooting (quick fixes + link to Tier 2)

**Audience**: Human developers, AI agents doing code-level work IN that repo

**Template**:
```markdown
# App Name

One-sentence purpose.

**Production**: https://...

## Quick Start
npm install && npm run dev

## What This App Does
- Key feature 1
- Key feature 2

## Technology Stack
- Frontend: React + TypeScript
- Backend: FastAPI
- Auth: ALB OIDC

## Architecture
Brief summary (1 paragraph)

📚 For complete architecture, deployment, operations:
→ See knowledge/applications/<app-name>/ in da-agent-hub

## Deployment
Quick commands

📚 For deployment runbook:
→ See knowledge/applications/<app-name>/deployment/ in da-agent-hub
```

### Tier 2: Knowledge Base (Comprehensive)
**Location**: `knowledge/applications/<app-name>/`
**Purpose**: Complete source of truth for architecture/deployment/operations
**Size**: Unlimited
**Structure**:
```
<app-name>/
├── README.md (comprehensive overview)
├── architecture/
│   ├── system-design.md (full architecture, diagrams)
│   ├── authentication-flow.md (auth details)
│   └── data-sources.md (integrations)
├── deployment/
│   ├── production-deploy.md (complete runbook)
│   ├── docker-build.md (container details)
│   └── rollback-procedures.md
└── operations/
    ├── monitoring.md (CloudWatch, health checks)
    ├── troubleshooting.md (comprehensive guide)
    └── incident-response.md
```

**Audience**: AI agents coordinating deployments, operations, cross-system work

**Maintenance**: Update when architecture or infrastructure changes

### Tier 3: Agent Pattern Index (Pointers)
**Location**: `.claude/agents/specialists/<agent>.md`
**Purpose**: Help agents quickly find proven patterns
**Size**: Pattern name + confidence + link (not full content)

**Format**:
```markdown
## Production-Validated Architecture Patterns

### ALB OIDC Authentication Pattern (Confidence: 0.92)
**Production Status**: ✅ Validated (app-portal + customer-dashboard)
**Reference**: `knowledge/applications/app-portal/architecture/alb-oidc-authentication.md`
**When to use**: React apps requiring Azure AD SSO
```

**Audience**: AI agents deciding what pattern to apply

**Also Update**:
- Role agents (e.g., frontend-developer-role.md) with "Known Applications" section
- Points agents to knowledge base for comprehensive docs

---

## Separation by Repository: The Critical Rule

**NEVER mix repository changes in one PR or commit**.

When completing a project that touches multiple repos:

### Step 1: Identify What Goes Where

**da-agent-hub** (Platform Knowledge):
- `.claude/agents/` - Agent pattern updates
- `knowledge/applications/` - Comprehensive app docs
- `CLAUDE.md` - Pattern documentation
- `.gitignore` - Config updates

**Production App Repos** (react-customer-dashboard, da-app-portal, etc.):
- `README.md` - Lightweight Tier 1 docs ONLY
- NO architecture/deployment details (link to knowledge base)

**Never Put in Sandbox**:
- Production code doesn't stay in `projects/active/`
- Project sandbox is for COORDINATION, not final destination

### Step 2: Create Independent PRs

**PR 1: da-agent-hub** (Knowledge Base + Agent Updates)
```bash
cd da-agent-hub
git checkout main
git pull origin main
git checkout -b feat/knowledge-base-<app-name>

# Add only da-agent-hub changes
git add knowledge/applications/ .claude/agents/ CLAUDE.md .gitignore
git commit -m "feat: Add <app-name> to knowledge base with three-tier docs"
git push -u origin feat/knowledge-base-<app-name>
gh pr create
```

**PR 2: react-<app-name>** (Lightweight README)
```bash
cd react-<app-name>
git checkout main  # or appropriate base branch
git pull origin main
git checkout -b docs/update-readme-with-knowledge-base-links

# Add ONLY README.md
git add README.md
git commit -m "docs: Update README with three-tier pattern"
git push -u origin docs/update-readme-with-knowledge-base-links
gh pr create --base main
```

**PR 3: da-app-portal** (if applicable)
```bash
# Same pattern as PR 2
```

### Step 3: Archive Project Sandbox

```bash
cd da-agent-hub
git checkout main
mkdir -p projects/completed
mv projects/active/<project-name> projects/completed/
git add projects/
git commit -m "chore: Archive completed <project-name>"
```

---

## Knowledge Extraction Checklist

When completing a project with production deployment:

### da-agent-hub Updates
- [ ] Create `knowledge/applications/<app-name>/` structure
- [ ] Write `architecture/system-design.md` (comprehensive)
- [ ] Write `deployment/production-deploy.md` (complete runbook)
- [ ] Write `operations/troubleshooting.md` (common issues)
- [ ] Update `knowledge/applications/README.md` (add app to index)
- [ ] Update specialist agent (e.g., `aws-expert.md`) with patterns + confidence scores
- [ ] Update role agent (e.g., `frontend-developer-role.md`) "Known Applications" section
- [ ] Update `CLAUDE.md` if pattern is novel
- [ ] Update `.gitignore` if new knowledge directory added

### Production Repo Updates
- [ ] Create lightweight README (< 200 lines)
- [ ] Include quick start for local dev
- [ ] Link to knowledge base for comprehensive docs
- [ ] Remove duplicated architecture/deployment details
- [ ] Keep troubleshooting quick fixes (link for comprehensive)

### Project Archival
- [ ] Move `projects/active/<name>` to `projects/completed/`
- [ ] Commit archival to da-agent-hub main branch
- [ ] Document where knowledge was extracted (commit message)

---

## Anti-Patterns to Avoid

❌ **Mixing repos in one PR**
```bash
# WRONG - This mixes da-agent-hub and react-app changes
git add knowledge/ ../react-app/README.md
git commit -m "Update everything"
```

✅ **Separate PRs per repo**
```bash
# CORRECT - Independent PRs
# PR 1: da-agent-hub (knowledge base)
# PR 2: react-app (README only)
```

❌ **Duplicating comprehensive docs**
```bash
# WRONG - Same architecture diagram in both places
react-app/README.md: [full architecture diagram]
knowledge/applications/app/architecture/: [same diagram]
```

✅ **Link instead of duplicate**
```bash
# CORRECT - Diagram lives once, README links to it
react-app/README.md: "See knowledge/applications/... for architecture"
knowledge/applications/app/architecture/: [full diagram]
```

❌ **Keeping work in sandbox**
```bash
# WRONG - Completed work stays in projects/active/
projects/active/feature-app/production-code.ts
```

✅ **Deploy to proper repos**
```bash
# CORRECT - Code goes to production repo
react-app/src/production-code.ts
projects/completed/feature-app/ (just coordination docs)
```

---

## Example: feature-salesjournaltoreact Completion

### What We Had (Sandbox):
```
projects/active/feature-salesjournaltoreact/
├── working/ (deployment experiments)
├── tasks/ (agent coordination)
├── RESUME_POINT_*.md (session notes)
└── context.md (working state)
```

### What We Created (Distributed):

**PR #96: da-agent-hub** (`feat/knowledge-base-three-tier-docs`)
- `knowledge/applications/app-portal/` (architecture, deployment, operations)
- `knowledge/applications/customer-dashboard/` (architecture, deployment, operations)
- `.claude/agents/specialists/aws-expert.md` (ALB OIDC 0.92, ECS 0.88)
- `.claude/agents/roles/frontend-developer-role.md` (Known Applications)
- `CLAUDE.md` (three-tier pattern docs)
- `.gitignore` (allow knowledge/applications/**)

**PR #3: da-app-portal** (`docs/update-readme-with-knowledge-base-links`)
- `README.md` (lightweight, links to knowledge base)

**PR: react-customer-dashboard** (`docs/update-readme-with-knowledge-base-links`)
- `README.md` (lightweight, links to knowledge base)

**Commit: da-agent-hub main**
- `projects/completed/feature-salesjournaltoreact/` (archived sandbox)

### Result:
- ✅ Production repos have lightweight READMEs
- ✅ Knowledge base has comprehensive docs (zero duplication)
- ✅ Agents know how to find information (Known Applications)
- ✅ Patterns indexed with confidence scores
- ✅ Sandbox archived (git history preserved)

---

## Benefits

**For Developers**:
- Quick start from repo README
- Links to comprehensive docs when needed
- No information overload

**For AI Agents**:
- Clear discovery path (role → knowledge base → specialist)
- Task-aware documentation (read what you need)
- Production-validated patterns with confidence scores

**For Maintenance**:
- Update once in knowledge base
- Links from READMEs don't break
- No duplicated content to keep in sync

---

## Related Patterns

- **Git Workflow**: `.claude/rules/git-workflow-patterns.md`
- **Cross-System Analysis**: `.claude/skills/reference-knowledge/cross-system-analysis-patterns/SKILL.md`
- **Testing Patterns**: `.claude/skills/reference-knowledge/testing-patterns/SKILL.md`

---

**Pattern Status**: ✅ Production-Validated
**Success Rate**: 100% (1 project: feature-salesjournaltoreact)
**Confidence**: 0.95 (proven effective, clear benefits)
