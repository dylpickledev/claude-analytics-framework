#!/bin/bash

# work-init.sh - Initialize a new work project
# Usage: ./scripts/work-init.sh <type> "<description>"
# Example: ./scripts/work-init.sh feature "snowflake optimization"

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validate arguments
if [ $# -ne 2 ]; then
    echo -e "${RED}Error: Invalid arguments${NC}"
    echo "Usage: $0 <type> \"<description>\""
    echo "Types: feature, fix, research, refactor, docs"
    echo "Example: $0 feature \"snowflake optimization\""
    exit 1
fi

PROJECT_TYPE="$1"
DESCRIPTION="$2"

# Validate project type
case "$PROJECT_TYPE" in
    feature|fix|research|refactor|docs)
        ;;
    *)
        echo -e "${RED}Error: Invalid project type '$PROJECT_TYPE'${NC}"
        echo "Valid types: feature, fix, research, refactor, docs"
        exit 1
        ;;
esac

# Generate project folder name
CLEAN_DESC=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 ]//g' | tr ' ' '-' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
PROJECT_NAME="${PROJECT_TYPE}-${CLEAN_DESC}"
PROJECT_DIR="projects/active/$PROJECT_NAME"

# Check if project already exists
if [ -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Error: Project '$PROJECT_NAME' already exists${NC}"
    exit 1
fi

# Get current branch and ensure we're on main (unless in worktree mode)
if [ -z "$WORKTREE_MODE" ]; then
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" != "main" ]; then
        echo -e "${YELLOW}Warning: Not on main branch (currently on: $CURRENT_BRANCH)${NC}"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 1
        fi
    fi
fi

# Create project directory and tasks subdirectory
mkdir -p "$PROJECT_DIR/tasks"

# Generate README.md (Navigation Hub)
cat > "$PROJECT_DIR/README.md" << EOF
# $PROJECT_TYPE: $DESCRIPTION

**Status:** 🟡 Active  
**Created:** $(date '+%Y-%m-%d %H:%M:%S')  
**Type:** $PROJECT_TYPE  
**Work Branch:** $PROJECT_NAME

## Quick Navigation

- 📋 **[Specification](./spec.md)** - Project goals, requirements, and implementation plan
- 🔄 **[Working Context](./context.md)** - Current state, branches, PRs, and blockers
- 🤖 **[Agent Tasks](./tasks/)** - Sub-agent coordination and findings

## Progress Summary

<!-- High-level status updates go here -->

## Key Decisions Made

<!-- Document major choices and rationale -->

---

*Use \`./scripts/work-complete.sh $PROJECT_NAME\` when ready to complete this work.*
EOF

# Generate spec.md (Project Specification)
cat > "$PROJECT_DIR/spec.md" << EOF
# Project Specification: $DESCRIPTION

## End Goal

$DESCRIPTION

<!-- Expand this section with specific, measurable outcomes -->

## Success Criteria

- [ ] Define specific success metrics here
- [ ] Add measurable completion criteria
- [ ] Include user/business value delivered

## Scope

### Included
- Core functionality to be delivered
- Systems and repositories affected
- Required integrations

### Excluded
- Out-of-scope items to avoid scope creep
- Future enhancements for later phases

## Implementation Plan

### Phase 1: Analysis & Planning
- [ ] Initial investigation
- [ ] Requirements gathering
- [ ] Technical design
- [ ] Risk assessment

### Phase 2: Development
- [ ] Core implementation
- [ ] Testing framework
- [ ] Documentation

### Phase 3: Deployment & Validation
- [ ] Integration testing
- [ ] Production deployment
- [ ] Success metric validation

## Technical Requirements

### Systems Involved
- **Repositories:** (list affected repos)
- **Data Sources:** (if applicable)
- **Integration Points:** (APIs, databases, etc.)

### Tools & Technologies
- dbt (transformations)
- Snowflake (data warehouse)
- Tableau (reporting)
- Orchestra (orchestration)
- Other: (specify)

## Acceptance Criteria

### Functional Requirements
- [ ] Specific functional requirements
- [ ] User experience criteria
- [ ] Performance requirements

### Non-Functional Requirements  
- [ ] Security considerations
- [ ] Scalability requirements
- [ ] Maintainability standards

## Risk Assessment

### High Risk
- Potential blockers and mitigation strategies

### Medium Risk
- Moderate concerns and contingency plans

### Dependencies
- External dependencies that could impact delivery
- Coordination required with other teams/projects

## Timeline Estimate

- **Analysis:** X days
- **Implementation:** X days  
- **Testing & Deployment:** X days
- **Total Estimated:** X days

---

*This specification should remain stable throughout the project. Updates to working context go in context.md*
EOF

# Generate context.md (Working Context)
cat > "$PROJECT_DIR/context.md" << EOF
# Working Context: $DESCRIPTION

**Last Updated:** $(date '+%Y-%m-%d %H:%M:%S')
**Current Focus:** Initial setup

## File Sources & Working Versions

### Primary Working Files (Active Development)
- **[Component Name]**: \`projects/active/$PROJECT_NAME/[filename]\`
  - Status: Working version with active modifications
  - Use for: Analysis, development, testing
  - DO NOT push directly to production repos

### Reference Files (Read-Only)
- **[Original/Production]**: \`[path to source repo]\`
  - Status: Production/reference version
  - Use for: Comparison, baseline reference
  - Changes require explicit deployment request

### Deployment Targets
- **[Target Repo]**: TBD or specify path
  - Deployment: After testing and approval
  - Testing: Required before deployment

## Repository Status

### da-agent-hub
- **Branch:** $PROJECT_NAME
- **Status:** Active work branch
- **Changes:** Project initialization

### dbt_cloud
- **Branch:** (none yet)
- **Status:** (not started)
- **Changes:** (none)

### Other Repositories
- **Add other repos as needed**

## Active Pull Requests

<!-- Update as PRs are created -->
- No PRs created yet

## Current Blockers

<!-- Track impediments and resolution plans -->
- No blockers identified

## Environment State

### Test Results
- No tests run yet

### Deployment Status  
- No deployments yet

## Agent Findings Summary

<!-- Links to detailed findings in tasks/ directory -->
- **dbt-expert:** (pending assignment)
- **snowflake-expert:** (pending assignment)
- **tableau-expert:** (pending assignment)
- **business-context:** (pending assignment)

## Next Actions

1. Complete initial project setup
2. Assign research tasks to appropriate agents
3. Begin implementation based on spec.md requirements

---

*This file tracks dynamic state - update frequently as work progresses*
EOF

# Create work branch (skip if in worktree mode - branch already created)
if [ -z "$WORKTREE_MODE" ]; then
    echo -e "${GREEN}Creating work branch: $PROJECT_NAME${NC}"
    git checkout -b "$PROJECT_NAME"
else
    echo -e "${GREEN}Using existing worktree branch: $PROJECT_NAME${NC}"
fi

# Stage all project files
git add "$PROJECT_DIR/"

echo
echo -e "${GREEN}✅ Work project initialized successfully!${NC}"
echo "Project: $PROJECT_NAME"
echo "Directory: $PROJECT_DIR"
echo "Branch: $PROJECT_NAME"
echo
echo "Files created:"
echo "  📋 $PROJECT_DIR/README.md (navigation hub)"
echo "  📝 $PROJECT_DIR/spec.md (project specification)"
echo "  🔄 $PROJECT_DIR/context.md (working context)"
echo "  📁 $PROJECT_DIR/tasks/ (agent coordination)"
echo
echo "Next steps:"
echo "1. Edit spec.md to define clear requirements and implementation plan"
echo "2. Update context.md as work progresses"
echo "3. Use tasks/ directory for agent coordination"
echo "4. Run './scripts/work-complete.sh $PROJECT_NAME' when finished"