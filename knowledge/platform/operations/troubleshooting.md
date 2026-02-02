# Troubleshooting Guide

Comprehensive troubleshooting guide for the DA Agent Hub system.

## 🚨 Common Issues

### Workflow Not Triggering

**Symptoms:**
- No GitHub Actions runs after @claude mention
- Scheduled monitoring doesn't execute
- Repository dispatch not working

**Solutions:**

1. **Check workflow location**:
   ```bash
   # Workflows must be on main/default branch
   ls -la .github/workflows/
   git branch -r | grep origin/main
   ```

2. **Verify workflow syntax**:
   ```bash
   # Use GitHub CLI to validate
   gh workflow list
   gh workflow view "Claude Collaborative Fixes"
   ```

3. **Check permissions**:
   ```yaml
   # Ensure workflow has proper permissions
   permissions:
     issues: write
     pull-requests: write
     contents: write
   ```

### Authentication Failures

**Symptoms:**
- "Invalid API key" errors
- "Forbidden" responses from APIs
- OAuth token authentication failed

**Solutions:**

1. **Verify secrets exist**:
   ```bash
   gh secret list
   # Should show: ANTHROPIC_API_KEY, DBT_CLOUD_API_TOKEN, etc.
   ```

2. **Check token permissions**:
   ```bash
   # Test dbt Cloud API
   curl -H "Authorization: Bearer $DBT_TOKEN" \
     "https://cloud.getdbt.com/api/v2/accounts/$ACCOUNT_ID/"

   # Should return account information, not 403/401
   ```

3. **Validate OAuth token**:
   ```bash
   # Claude OAuth tokens are from Pro/Max subscriptions
   # Check in Claude settings → API Keys
   ```

### No Issues Created

**Symptoms:**
- dbt tests failing but no GitHub issues
- Monitoring workflow runs successfully but creates nothing
- Issues created in wrong repository

**Solutions:**

1. **Check dbt Cloud environment**:
   ```bash
   # Verify environment ID is correct
   curl -H "Authorization: Bearer $DBT_TOKEN" \
     "https://cloud.getdbt.com/api/v2/accounts/$ACCOUNT_ID/environments/"
   ```

2. **Review error filtering**:
   ```python
   # Check if errors meet severity threshold
   if error_severity >= MINIMUM_SEVERITY:
       create_issue()
   ```

3. **Validate repository permissions**:
   ```bash
   # GitHub token needs issues:write permission
   gh auth status
   gh issue create --title "Test" --body "Test issue creation"
   ```

### Claude Not Responding

**Symptoms:**
- Workflow runs but no Claude comments
- Investigation starts but never completes
- Empty or error responses from Claude

**Solutions:**

1. **Check Claude Code Action version**:
   ```yaml
   # Use latest version
   uses: anthropics/claude-code-action@v1
   ```

2. **Verify authentication method**:
   ```yaml
   # For OAuth tokens
   with:
     claude_code_oauth_token: ${{ secrets.ANTHROPIC_API_KEY }}

   # NOT anthropic_api_key for OAuth
   ```

3. **Review prompt complexity**:
   ```yaml
   # Simplify prompts if too complex
   prompt: |
     Please investigate this dbt issue and provide recommendations.
   ```

### Performance Issues

**Symptoms:**
- Workflows timeout after 6+ hours
- Claude responses very slow
- High GitHub Actions usage

**Solutions:**

1. **Optimize workflow efficiency**:
   ```yaml
   # Set reasonable timeouts
   timeout-minutes: 30

   # Use concurrency limits
   concurrency:
     group: claude-investigation
     cancel-in-progress: true
   ```

2. **Reduce Claude prompt complexity**:
   ```yaml
   # Focus prompts on specific tasks
   prompt: |
     Analyze this specific dbt test failure and suggest a fix.
     Do not perform general system analysis.
   ```

3. **Implement workflow caching**:
   ```yaml
   # Cache dependencies
   - uses: actions/cache@v3
     with:
       path: ~/.cache/pip
       key: pip-${{ hashFiles('requirements.txt') }}
   ```

## 🔍 Debugging Steps

### 1. Workflow Execution

```bash
# Check recent workflow runs
gh run list --limit 10

# View specific run details
gh run view RUN_ID

# Check failed run logs
gh run view RUN_ID --log-failed

# Watch running workflow
gh run watch RUN_ID
```

### 2. API Connectivity

```bash
# Test dbt Cloud API
curl -v -H "Authorization: Bearer $DBT_TOKEN" \
  "https://cloud.getdbt.com/api/v2/accounts/$ACCOUNT_ID/environments/$ENV_ID"

# Test GitHub API
gh api user

# Check rate limits
gh api rate_limit
```

### 3. Repository State

```bash
# Check repository configuration
gh repo view --json owner,name,defaultBranchRef

# Verify workflow files
find .github/workflows -name "*.yml" -exec basename {} \;

# Check recent issues
gh issue list --limit 10 --json number,title,state,labels
```

### 4. Authentication Debug

```bash
# Check GitHub authentication
gh auth status

# Verify secrets (names only, not values)
gh secret list

# Test repository access
gh repo view your-org/your-repo
```

## 🛠️ Advanced Debugging

### Enable Debug Logging

```yaml
# Add to workflow for detailed logs
env:
  ACTIONS_STEP_DEBUG: true
  ACTIONS_RUNNER_DEBUG: true
```

### Custom Debug Steps

```yaml
- name: Debug Environment
  run: |
    echo "=== System Information ==="
    echo "Runner OS: $RUNNER_OS"
    echo "GitHub Event: ${{ github.event_name }}"
    echo "Repository: ${{ github.repository }}"
    echo "Actor: ${{ github.actor }}"

    echo "=== Environment Variables ==="
    env | grep -E "(GITHUB_|DBT_|ANTHROPIC_)" | sort

    echo "=== Workflow Context ==="
    echo "Run ID: ${{ github.run_id }}"
    echo "Run Number: ${{ github.run_number }}"
    echo "Job: ${{ github.job }}"
```

### API Response Debugging

```yaml
- name: Debug API Responses
  run: |
    echo "=== Testing dbt Cloud API ==="
    RESPONSE=$(curl -s -w "%{http_code}" -H "Authorization: Bearer ${{ secrets.DBT_CLOUD_API_TOKEN }}" \
      "https://cloud.getdbt.com/api/v2/accounts/${{ secrets.DBT_CLOUD_ACCOUNT_ID }}/")

    HTTP_CODE=${RESPONSE: -3}
    BODY=${RESPONSE%???}

    echo "HTTP Code: $HTTP_CODE"
    echo "Response Body: $BODY"

    if [[ $HTTP_CODE != "200" ]]; then
      echo "::error::dbt Cloud API failed with code $HTTP_CODE"
    fi
```

## 📊 Health Monitoring

### System Health Checks

```bash
# Check workflow success rates
gh run list --workflow="dbt Error Monitoring" --limit 20 --json status \
  | jq '[.[] | .status] | group_by(.) | map({status: .[0], count: length})'

# Monitor Claude response times
gh run list --workflow="Claude Collaborative Fixes" --limit 10 --json conclusion,createdAt,updatedAt

# Check issue resolution rates
gh issue list --label="dbt-error" --state=closed --limit 50 --json closedAt,createdAt
```

### Automated Health Monitoring

```yaml
name: System Health Check

on:
  schedule:
    - cron: '0 8 * * 1'  # Weekly on Monday

jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
    - name: Check Workflow Success Rate
      run: |
        SUCCESS_COUNT=$(gh run list --workflow="dbt Error Monitoring" --limit 20 --json status | jq '[.[] | select(.status=="completed")] | length')
        TOTAL_COUNT=20
        SUCCESS_RATE=$((SUCCESS_COUNT * 100 / TOTAL_COUNT))

        echo "Success rate: ${SUCCESS_RATE}%"

        if [[ $SUCCESS_RATE -lt 80 ]]; then
          gh issue create --title "🚨 System Health Alert: Low Success Rate" \
            --body "dbt monitoring workflow success rate is ${SUCCESS_RATE}%, below 80% threshold"
        fi
```

## 🔧 Common Fixes

### Reset Workflow State

```bash
# Cancel running workflows
gh run list --status=in_progress | cut -f 3 | xargs -I {} gh run cancel {}

# Re-run failed workflows
gh run list --status=failure --limit 5 | cut -f 3 | xargs -I {} gh run rerun {}
```

### Update Secrets

```bash
# Rotate dbt Cloud token
gh secret set DBT_CLOUD_API_TOKEN --body "new_token_value"

# Update Claude OAuth token
gh secret set ANTHROPIC_API_KEY --body "new_oauth_token"

# Verify secret updates
gh secret list
```

### Fix Repository Permissions

```bash
# Check repository collaborators
gh api repos/:owner/:repo/collaborators

# Add claude[bot] if missing
gh api repos/:owner/:repo/collaborators/claude[bot] -X PUT \
  -f permission=write
```

### Workflow File Recovery

```bash
# Backup current workflows
cp -r .github/workflows .github/workflows.backup

# Restore from repository (if you forked this project)
curl -o .github/workflows/claude-collaborative-fixes.yml \
  https://raw.githubusercontent.com/your-org/claude-analytics-framework/main/.github/workflows/claude-collaborative-fixes.yml

# Validate workflow syntax
gh workflow list
```

## 📞 Getting Help

### Self-Service Debugging

1. **Check this troubleshooting guide** for common issues
2. **Review workflow logs** for specific error messages
3. **Test API connectivity** to isolate problems
4. **Validate configuration** against working examples

### Community Support

1. **GitHub Issues**: Report bugs and request features in your organization's repository
2. **GitHub Discussions**: Ask questions and share experiences with your team
3. **Documentation**: [Review additional guides](../README.md)

### Professional Support

For enterprise deployments requiring guaranteed support:

1. **Anthropic Support**: For Claude Code Action issues
2. **GitHub Support**: For GitHub Actions problems
3. **dbt Support**: For dbt Cloud API issues

## 📋 Diagnostic Checklist

Use this checklist when troubleshooting:

### Basic Checks
- [ ] Workflows exist on main/default branch
- [ ] Required secrets are configured
- [ ] Repository permissions are correct
- [ ] API tokens are valid and not expired

### Authentication Checks
- [ ] dbt Cloud API token has environment permissions
- [ ] GitHub token has repository and workflow permissions
- [ ] Claude OAuth token is from Pro/Max subscription
- [ ] Secrets are accessible to workflows

### Functionality Checks
- [ ] Manual workflow triggers work
- [ ] @claude mentions trigger collaborative workflow
- [ ] Issues are created for dbt errors
- [ ] Claude provides responses to mentions

### Performance Checks
- [ ] Workflows complete within reasonable time
- [ ] No excessive API rate limiting
- [ ] Claude responses are relevant and helpful
- [ ] System operates within cost expectations

---

**Remember**: Most issues are related to authentication or configuration. Start with the basics before investigating complex problems!