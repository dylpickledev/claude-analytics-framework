---
name: github-investigation-pattern
description: Cross-Tool Integration Pattern: GitHub Cross-Repository Investigation
user-invocable: false
---

# Cross-Tool Integration Pattern: GitHub Cross-Repository Investigation

**Pattern Type**: Issue Investigation & Root Cause Analysis
**Tools**: github-mcp, filesystem-mcp, sequential-thinking-mcp, dbt-mcp (optional)
**Confidence**: HIGH (0.88) - Production-validated pattern
**Primary Users**: github-sleuth-expert, qa-engineer-role, data-engineer-role

---

## Problem Statement

**Scenario**: Recurring error appearing across multiple repositories
**Challenge**: Need to analyze pattern, understand root cause, recommend fix
**Goal**: Comprehensive cross-repo investigation with actionable recommendations

---

## Integration Pattern Overview

### Tool Coordination Strategy
```
github-mcp → Search issues across org (pattern discovery)
    ↓
github-mcp → Get detailed issue information (context gathering)
    ↓
filesystem-mcp → Read local repository code (root cause analysis)
    ↓
github-mcp → Search code across repos (pattern analysis)
    ↓
sequential-thinking-mcp → Systematic root cause analysis (complex bugs)
    ↓
github-sleuth-expert → Synthesize findings, recommend fix
    ↓
github-mcp → Document findings (issue comment or new issue)
```

**Why multiple tools needed**:
- **github-mcp**: Cross-repo issue search, PR analysis, issue tracking
- **filesystem-mcp**: Local code context, detailed analysis
- **sequential-thinking-mcp**: Complex root cause analysis (15x better outcomes)
- **Together**: Complete investigation from discovery → analysis → resolution

---

## Step-by-Step Workflow

### Step 1: Pattern Discovery (github-mcp)

**Search for similar issues across organization**:
```bash
# 1. Search issues org-wide for error pattern
mcp__github__search_issues \
  q="org:your-org type:issue state:open \"dbt test failure\"" \
  per_page=50
```

**Filter by specific error message**:
```bash
# 2. Search for specific error text
mcp__github__search_issues \
  q="org:your-org type:issue \"unique_key not defined\" in:body" \
  per_page=30
```

**Returns**:
- Issue numbers, titles, repositories
- Issue state (open/closed)
- Creation dates (pattern timeline)
- Labels (categorization)

**Analyze results for**:
- Number of affected repositories
- Frequency (recurring vs one-time)
- Common patterns (same error message, similar context)
- Timeline (when did pattern start appearing?)

---

### Step 2: Detailed Issue Analysis (github-mcp)

**Get detailed information for each match**:
```bash
# 3. Get issue details (repository A)
mcp__github__get_issue \
  owner="your-org" \
  repo="dbt_cloud" \
  issue_number=123

# 4. Get issue details (repository B)
mcp__github__get_issue \
  owner="your-org" \
  repo="analytics-pipelines" \
  issue_number=456
```

**Extract from each issue**:
- Error messages (exact text, stack traces)
- Reproduction steps (how to trigger)
- Affected files/models (scope)
- Environment details (dbt version, Snowflake version)
- User reports (impact, frequency)

---

### Step 3: Code Context Gathering (filesystem-mcp OR github-mcp)

**For local repositories** (filesystem-mcp):
```bash
# 5. Read affected file from local repo
mcp__filesystem__read_text_file \
  path="/Users/TehFiestyGoat/GRC/dbt_cloud/models/marts/fct_orders.sql"
```

**For remote repositories** (github-mcp):
```bash
# 6. Get file contents from GitHub
mcp__github__get_file_contents \
  owner="your-org" \
  repo="dbt_cloud" \
  path="models/marts/fct_orders.sql" \
  branch="main"
```

**Search for pattern in code**:
```bash
# 7. Search code across org for similar patterns
mcp__github__search_code \
  q="org:your-org incremental unique_key" \
  per_page=20
```

**Analyze code for**:
- Common configuration patterns
- Missing configurations (like `unique_key`)
- Implementation differences across repos
- Recent changes (git blame/history)

---

### Step 4: Root Cause Analysis (sequential-thinking-mcp)

**For complex, unclear root causes**:
```bash
# 8. Use sequential thinking for systematic analysis
mcp__sequential-thinking__sequentialthinking \
  thought="Define symptoms: 'unique_key not defined' errors in 5 repositories" \
  thought_number=1 \
  total_thoughts=10 \
  next_thought_needed=true
```

**Sequential thinking process**:
```markdown
Thought 1: Define symptoms and gather evidence
  - 5 repositories affected
  - All incremental models
  - Error: "unique_key not defined"
  - Started appearing after dbt 1.7 upgrade

Thought 2: Hypothesis A - Breaking change in dbt 1.7
  - dbt 1.7 made unique_key mandatory for incremental models
  - Previous versions allowed missing unique_key (defaulted to all columns)

Thought 3: Test Hypothesis A
  - Check dbt 1.7 release notes (via github search)
  - Verify affected models are all incremental
  - Confirm all repos upgraded to dbt 1.7 in same timeframe

Thought 4: Evidence supports Hypothesis A
  - dbt 1.7 release notes confirm breaking change
  - All 5 repos upgraded to 1.7 within 2 weeks
  - All affected models are incremental materialization

Thought 5: Hypothesis B (Alternative) - Configuration drift
  - Templates updated but not applied retroactively
  - New models have unique_key, old models don't

Thought 6: Compare hypotheses
  - Hypothesis A: Breaking change (timing matches)
  - Hypothesis B: Drift (timing doesn't match - all simultaneous)
  - Hypothesis A more likely

Thought 7: Root cause identified
  - dbt 1.7 breaking change made unique_key mandatory
  - Existing incremental models without unique_key now fail
  - Fix: Add unique_key to all incremental models

Thought 8: Validate solution approach
  - Scan all incremental models for missing unique_key
  - Add appropriate unique_key based on business logic
  - Test each model after update
  - Deploy fixes across all affected repos

Thought 9: No further analysis needed
  - Root cause clear
  - Solution straightforward
  - High confidence in fix

Thought 10: COMPLETE
  - Root cause: dbt 1.7 breaking change
  - Solution: Add unique_key to all incremental models
  - Confidence: HIGH (0.95)
```

**Why sequential thinking valuable here**:
- Complex multi-repo pattern (not obvious single cause)
- Multiple hypotheses to evaluate (breaking change vs drift vs configuration)
- Evidence gathering from multiple sources (issues, code, release notes)
- Systematic validation prevents false diagnoses

---

### Step 5: Cross-Repository Pattern Analysis (github-mcp)

**Search for all affected incremental models**:
```bash
# 9. Search for incremental models without unique_key
mcp__github__search_code \
  q="org:your-org \"materialized='incremental'\" -unique_key" \
  per_page=100
```

**List all repositories with the issue**:
```bash
# 10. List issues with same error across org
mcp__github__search_issues \
  q="org:your-org type:issue state:open \"unique_key not defined\"" \
  per_page=50
```

**Identify pattern scope**:
- Total affected repositories: 5
- Total affected models: 23 incremental models
- Fix complexity: Low (add unique_key config)
- Risk: Medium (production models)

---

### Step 6: Solution Validation (dbt-mcp - Optional)

**If dbt models involved**:
```bash
# 11. Get model details to understand structure
mcp__dbt-mcp__get_model_details \
  model_name="fct_orders"

# 12. Validate model health
mcp__dbt-mcp__get_model_health \
  model_name="fct_orders"
```

**Understand**:
- Model schema (which column(s) should be unique_key)
- Current test coverage (do we have unique tests?)
- Dependencies (impact of changes)

---

### Step 7: Document Findings (github-mcp)

**Add comprehensive comment to original issue**:
```bash
# 13. Document root cause analysis
mcp__github__add_issue_comment \
  owner="your-org" \
  repo="dbt_cloud" \
  issue_number=123 \
  body="## Root Cause Analysis

**Issue**: unique_key not defined error in incremental models

**Root Cause**: dbt 1.7 breaking change
- dbt 1.7 made unique_key mandatory for incremental models
- Previous versions allowed missing unique_key (defaulted to all columns)
- All affected repos upgraded to dbt 1.7 within 2-week window

**Scope**:
- 5 repositories affected
- 23 incremental models require update
- Started after dbt 1.7 upgrade

**Solution**:
- Add unique_key configuration to all incremental models
- Base unique_key on business logic (primary key or composite)
- Add unique tests to validate key uniqueness
- Deploy fixes across all affected repos

**Implementation**:
- Created PR #456 with fixes for dbt_cloud repository
- Will create similar PRs for remaining 4 repositories

**Estimated Impact**:
- Fix complexity: Low (configuration change)
- Risk: Medium (production models)
- Timeline: 2-3 hours for all repos
"
```

---

### Step 8: Create Fix Issues (github-mcp)

**Create tracking issue for each affected repo**:
```bash
# 14. Create issue in repository B
mcp__github__create_issue \
  owner="your-org" \
  repo="analytics-pipelines" \
  title="fix: Add unique_key to incremental models (dbt 1.7 breaking change)" \
  body="## Issue
Incremental models failing with 'unique_key not defined' error after dbt 1.7 upgrade.

## Root Cause
dbt 1.7 breaking change - see dbt_cloud#123 for analysis.

## Solution
Add unique_key configuration to affected incremental models:
- int_customer_orders
- fct_transactions
- dim_products_scd

## Acceptance Criteria
- [ ] unique_key added to all incremental models
- [ ] unique tests added to validate key uniqueness
- [ ] dbt test passes
- [ ] Models build successfully
" \
  labels=["bug", "dbt", "breaking-change"]
```

---

## Real-World Example

### Scenario: "dbt test failure: duplicate records" in 3 Repositories

**Step 1: Pattern Discovery** (github-mcp)
```bash
mcp__github__search_issues \
  q="org:your-org type:issue state:open \"duplicate records\" dbt test" \
  per_page=50
```

**Found**:
- 3 repositories affected (dbt_cloud, analytics-pipelines, data-platform)
- 7 total issues
- All mention "duplicate records in incremental models"
- Started appearing in last 30 days

---

**Step 2: Detailed Analysis** (github-mcp)
```bash
# Get details for each issue
mcp__github__get_issue owner="your-org" repo="dbt_cloud" issue_number=234
mcp__github__get_issue owner="your-org" repo="analytics-pipelines" issue_number=567
mcp__github__get_issue owner="your-org" repo="data-platform" issue_number=890
```

**Common patterns**:
- All incremental models using `merge` strategy
- All have `unique_key` defined (not missing)
- All handle late-arriving data (lookback windows)
- Duplicates appear randomly (intermittent failure)

---

**Step 3: Code Analysis** (filesystem-mcp + github-mcp)
```bash
# Read local affected model
mcp__filesystem__read_text_file \
  path="/Users/TehFiestyGoat/GRC/dbt_cloud/models/marts/fct_customer_transactions.sql"

# Search for similar incremental patterns
mcp__github__search_code \
  q="org:your-org incremental_strategy merge unique_key" \
  per_page=30
```

**Findings**:
- All models use `incremental_strategy='merge'`
- All use `unique_key` (single column or composite)
- All have lookback windows (2-7 days)
- Code looks correct at first glance

---

**Step 4: Root Cause Analysis** (sequential-thinking-mcp)
```bash
mcp__sequential-thinking__sequentialthinking
```

**Systematic reasoning**:
```
Thought 1: Symptoms - duplicates in incremental models with merge strategy
Thought 2: Hypothesis A - unique_key not actually unique in source data
Thought 3: Test A - Query source for duplicates... FOUND duplicates in source!
Thought 4: Hypothesis validated - source has duplicates, merge doesn't deduplicate
Thought 5: Why now? Source system change introduced duplicates 30 days ago
Thought 6: Solution - Add deduplication logic BEFORE merge
Thought 7: Implementation - Use ROW_NUMBER() window function to deduplicate
Thought 8: Validate - Test deduplication logic on sample data
Thought 9: Root cause confirmed - source duplicates + no deduplication = incremental duplicates
Thought 10: COMPLETE - High confidence solution
```

**Root Cause**: Source system introduced duplicates, dbt merge doesn't automatically deduplicate

---

**Step 5: Solution Validation** (dbt-mcp)
```bash
# Test deduplication logic
mcp__dbt-mcp__show sql_query="
WITH source_with_duplicates AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY transaction_id
      ORDER BY updated_at DESC
    ) as row_num
  FROM {{ ref('stg_transactions') }}
)
SELECT * FROM source_with_duplicates
WHERE row_num = 1
LIMIT 10
"
```

**Validate deduplication works**: Single record per transaction_id

---

**Step 6: Document Findings** (github-mcp)
```bash
# Add analysis to each affected issue
mcp__github__add_issue_comment \
  owner="your-org" \
  repo="dbt_cloud" \
  issue_number=234 \
  body="## Root Cause Identified

**Issue**: Duplicate records in incremental models

**Root Cause**: Source system introduced duplicates 30 days ago
- Source changed: Updated records now appear as new inserts
- dbt merge strategy: Does not automatically deduplicate
- Result: Both old and new records merged into table

**Cross-Repo Impact**: 3 repositories, 7 models affected

**Solution**: Add deduplication logic before merge
\`\`\`sql
WITH deduped_source AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY {{ unique_key }}
      ORDER BY updated_at DESC
    ) as row_num
  FROM source
)
SELECT * FROM deduped_source
WHERE row_num = 1
\`\`\`

**Implementation**: PR #789 created with fix

**Related Issues**:
- analytics-pipelines#567
- data-platform#890
"
```

---

## Tool-Specific Responsibilities

### github-mcp Responsibilities
- ✅ Cross-repo issue search (organization-wide patterns)
- ✅ Issue details gathering (error messages, reproduction steps)
- ✅ Code search (find similar patterns across repos)
- ✅ PR analysis (change impact, test scope)
- ✅ Issue documentation (comment findings, create tracking issues)
- ❌ Local code analysis (delegate to filesystem-mcp)
- ❌ Complex root cause analysis (delegate to sequential-thinking-mcp)

### filesystem-mcp Responsibilities
- ✅ Local repository code reading (detailed analysis)
- ✅ Multi-file batch reading (compare implementations)
- ✅ Directory structure analysis (project organization)
- ✅ Search local files (pattern discovery)
- ❌ Remote repository access (delegate to github-mcp)
- ❌ Issue tracking (delegate to github-mcp)

### sequential-thinking-mcp Responsibilities
- ✅ Systematic root cause analysis (complex bugs)
- ✅ Hypothesis generation and testing (multiple possible causes)
- ✅ Evidence evaluation (weigh competing explanations)
- ✅ Decision making under uncertainty (confidence building)
- ❌ Data gathering (delegate to github-mcp, filesystem-mcp)
- ❌ Implementation (provide analysis, not code)

### Why All Tools Required
- **github-mcp alone**: Can find issues but not analyze local code deeply
- **filesystem-mcp alone**: Can read local code but not see cross-repo patterns
- **sequential-thinking alone**: Can reason but needs data from other tools
- **Together**: Complete investigation from discovery → analysis → resolution

---

## Common Investigation Patterns

### Pattern 1: Error Message Investigation
```
github-mcp (search issues) → github-mcp (get details) →
filesystem-mcp (read code) → github-sleuth-expert (synthesize)
```
**When**: Clear error message, unknown root cause
**Tools**: github-mcp for discovery, filesystem-mcp for code analysis

---

### Pattern 2: Performance Degradation Analysis
```
github-mcp (search related issues) → github-mcp (get PR history) →
filesystem-mcp (read changed files) → sequential-thinking (analyze causes) →
dbt-mcp/snowflake-mcp (validate hypothesis)
```
**When**: Performance regression, unclear trigger
**Tools**: github-mcp for history, sequential-thinking for hypothesis testing

---

### Pattern 3: Cross-Repository Bug Pattern
```
github-mcp (search org-wide) → filesystem-mcp (local analysis) →
github-mcp (code search) → sequential-thinking (pattern analysis) →
github-mcp (document findings)
```
**When**: Same issue in multiple repos, unclear common cause
**Tools**: All 3 tools for comprehensive cross-repo analysis

---

### Pattern 4: Test Failure Root Cause
```
github-mcp (get PR + files) → filesystem-mcp (read test files) →
dbt-mcp (get model health) → sequential-thinking (root cause) →
github-mcp (comment findings)
```
**When**: Test failing after PR merge, unclear which change caused it
**Tools**: github-mcp for PR context, dbt-mcp for test execution

---

## Best Practices

### 1. Start Broad, Narrow Down
- Search org-wide first (discover full scope)
- Filter to specific repos/error messages
- Read detailed context for representative issues
- Analyze code for common patterns

### 2. Use Sequential Thinking for Complex Bugs
- Multiple possible root causes (hypothesis testing)
- Intermittent failures (uncertainty)
- Cross-system interactions (complex analysis)
- Novel issues without known patterns

### 3. Document as You Investigate
- Add findings to issues as you discover them
- Create tracking issues for each affected repo
- Link related issues together
- Provide reproduction steps and fixes

### 4. Validate Across Repositories
- Check if fix works in one repo before applying to others
- Test in development environment first
- Coordinate deployments to avoid conflicts

### 5. Repository Context Resolution
- ALWAYS resolve owner/repo from `config/repositories.json`
- Use `python3 scripts/resolve-repo-context.py <repo_name>`
- Eliminates errors from incorrect owner names

---

## Success Metrics

### Investigation Efficiency
- **Pattern discovery**: <10 minutes (github-mcp search)
- **Root cause identification**: <30 minutes (with sequential thinking)
- **Cross-repo validation**: <20 minutes (code search)
- **Total investigation time**: <60 minutes (vs 2-4 hours manual)

### Solution Quality
- **Root cause accuracy**: >90% (sequential thinking validation)
- **Fix completeness**: All affected repos identified
- **Prevention**: Pattern documented for future avoidance

### Knowledge Capture
- **Issue documentation**: Findings added to all related issues
- **Pattern library**: New pattern added for team knowledge
- **Prevention**: Root cause shared across team

---

## Troubleshooting

### Issue: Search Returns Too Many Results
**Symptom**: 500+ issues in search results, unclear which are relevant
**Solution**: Use more specific search qualifiers
```bash
# Add date filter, specific repo, labels
mcp__github__search_issues \
  q="org:your-org type:issue state:open created:>2025-09-01 label:bug \"dbt test\"" \
  per_page=20
```

### Issue: Code Search Finds Irrelevant Matches
**Symptom**: Code search returns files without actual error
**Solution**: Use more specific search terms, filter by file type
```bash
# Search .sql files only with exact phrase
mcp__github__search_code \
  q="org:your-org \"unique_key not defined\" extension:sql" \
  per_page=20
```

### Issue: Local File Not Found (filesystem-mcp)
**Symptom**: Cannot read file from local repository
**Solution**: Use github-mcp instead for remote file access
```bash
# Fall back to GitHub file contents
mcp__github__get_file_contents \
  owner="your-org" \
  repo="dbt_cloud" \
  path="models/marts/fct_orders.sql"
```

### Issue: Sequential Thinking Inconclusive
**Symptom**: Systematic analysis doesn't identify clear root cause
**Solution**: Gather more evidence with github-mcp and filesystem-mcp first
- Search for more related issues
- Read more code examples
- Check git history for recent changes
- Then retry sequential thinking with more complete context

---

## Integration with Specialist Agents

### github-sleuth-expert Pattern
**Delegates to github-sleuth-expert when**:
- Cross-repository pattern analysis needed
- Issue classification required (bug, feature, enhancement)
- Historical defect pattern analysis
- Complex issue investigation workflows

**github-sleuth-expert uses**:
- github-mcp for issue discovery and tracking
- filesystem-mcp for local code analysis
- sequential-thinking-mcp for complex root cause analysis
- Smart context resolution for owner/repo determination

### qa-engineer-role Pattern
**Uses this integration when**:
- Test failure investigation (PR broke tests)
- Defect pattern analysis (recurring bugs)
- Test scope determination (what to test for PR)
- Bug tracking and lifecycle management

### data-engineer-role Pattern
**Uses this integration when**:
- Pipeline failure investigation (recurring errors)
- Configuration drift analysis (multi-repo pipelines)
- Deployment validation (check for known issues)

---

## Related Patterns

- **Smart Context Resolution**: `.claude/rules/github-repo-context-resolution.md`
- **Sequential Thinking Guide**: `knowledge/mcp-servers/sequential-thinking/`
- **github-sleuth-expert Agent**: `.claude/agents/specialists/github-sleuth-expert.md`

---

*Created: 2025-10-08*
*Pattern Type: Cross-Tool Integration*
*Confidence: HIGH (0.88) - Production-validated*
