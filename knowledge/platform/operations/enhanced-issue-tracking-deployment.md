# Enhanced Issue Tracking System - Deployment Guide

## Overview

This guide walks through deploying the enhanced issue tracking system with Claude-powered classification across **dbt_cloud**, **roy_kent**, and **da-agent-hub** repositories.

## Prerequisites

### Required Secrets
Each repository needs the following secrets configured:

#### In da-agent-hub repository:
```bash
ANTHROPIC_API_KEY=your_claude_oauth_token
GITHUB_TOKEN=automatically_provided
DA_AGENT_HUB_PAT=personal_access_token_with_workflow_permissions
```

#### In dbt repositories (dbt_cloud, roy_kent):
```bash
DBT_CLOUD_API_TOKEN=your_dbt_cloud_token
DBT_CLOUD_ACCOUNT_ID=your_account_id
GITHUB_TOKEN=automatically_provided
DA_AGENT_HUB_PAT=personal_access_token_for_cross_repo_triggers
```

### Required Permissions
- The `DA_AGENT_HUB_PAT` token needs:
  - `repo` scope for all repositories
  - `workflow` scope for triggering workflows
  - `issues` scope for creating and managing issues

## Deployment Steps

### Phase 1: Deploy Core Agents (da-agent-hub)

1. **Deploy the new specialized agents**:
   ```bash
   # These files should already be created in da-agent-hub
   .claude/agents/github-sleuth-expert.md
   .claude/agents/issue-lifecycle-expert.md
   ```

2. **Deploy the classification workflows**:
   ```bash
   # Copy these files to da-agent-hub/.github/workflows/
   claude-error-classifier.yml
   auto-resolution-monitor.yml
   cross-repository-coordination.yml
   ```

3. **Test the agents**:
   ```bash
   # In da-agent-hub, test the new agents
   claude "using github-sleuth-expert, analyze recent issues in dbt_cloud"
   claude "using issue-lifecycle-expert, review our current workflow automation"
   ```

### Phase 2: Update Repository Monitoring (dbt_cloud & roy_kent)

1. **Update each dbt repository with enhanced monitoring**:
   ```bash
   # In dbt_cloud repository
   cp da-agent-hub/templates/enhanced-dbt-error-monitor.yml .github/workflows/dbt-error-monitor.yml

   # In roy_kent repository
   cp da-agent-hub/templates/enhanced-dbt-error-monitor.yml .github/workflows/dbt-error-monitor.yml
   ```

2. **Verify workflow permissions**:
   - Ensure each repository can trigger workflows in da-agent-hub
   - Test the `DA_AGENT_HUB_PAT` token has proper permissions

### Phase 3: Configure Cross-Repository Coordination

1. **Set up repository-specific labels** in each repository:
   ```bash
   # Create standard labels for classification
   gh label create "claude:classified" --color "0E8A16" --description "Issue has been classified by Claude"
   gh label create "category:transient_failure" --color "F9D71C" --description "Self-resolving error"
   gh label create "category:code_fix_required" --color "D73A4A" --description "Requires code changes"
   gh label create "category:data_quality_issue" --color "FF8C00" --description "Data quality problem"
   gh label create "category:infrastructure_issue" --color "8B0000" --description "Platform/infrastructure issue"
   gh label create "category:false_positive" --color "CCCCCC" --description "Not a real error"
   gh label create "priority:critical" --color "B60205" --description "Critical priority"
   gh label create "priority:high" --color "D93F0B" --description "High priority"
   gh label create "priority:medium" --color "FBCA04" --description "Medium priority"
   gh label create "priority:low" --color "0E8A16" --description "Low priority"
   ```

2. **Configure repository-specific automation rules**:

   **dbt_cloud** (Production Critical):
   ```yaml
   # Add to repository description or README
   Repository Priority: CRITICAL
   SLA: 4 hours for critical issues
   Auto-assign: dbt-expert for schema/compilation errors
   Escalation: Immediate for P0 issues
   ```

   **roy_kent** (Business Intelligence):
   ```yaml
   # Add to repository description or README
   Repository Priority: HIGH
   SLA: 24 hours for business impact
   Auto-assign: dbt-expert for metrics, tableau-expert for dashboards
   Business notification: Required for metric calculation errors
   ```

### Phase 4: Test the Complete System

1. **Create a test error issue** in dbt_cloud:
   ```bash
   gh issue create \
     --title "Test Error: Model compilation failed for stg_test_customers" \
     --body "Error during dbt run: column 'customer_id' does not exist in relation 'raw_customers'" \
     --label "dbt-error"
   ```

2. **Verify the automated workflow**:
   - Check that Claude classification is triggered
   - Verify proper labels are applied
   - Confirm expert assignment occurs
   - Test cross-repository coordination

3. **Test transient failure detection**:
   ```bash
   # Create an issue that mimics a transient failure
   gh issue create \
     --title "Test Transient: Warehouse timeout during model run" \
     --body "dbt run failed with: timeout waiting for warehouse connection" \
     --label "dbt-error"
   ```

4. **Monitor auto-resolution**:
   - Wait for the 6-hour auto-resolution check
   - Verify transient issues are properly closed
   - Check that resolution patterns are tracked

## Configuration Customization

### Repository-Specific Rules

Edit the classification prompts in `claude-error-classifier.yml` to customize repository-specific behavior:

```yaml
# For dbt_cloud - stricter SLAs
critical_error_types:
  - compilation_failure
  - schema_mismatch
  - test_failure_blocking

# For roy_kent - business impact focus
business_critical_types:
  - metric_calculation_error
  - dashboard_data_missing
  - semantic_layer_failure
```

### Expert Assignment Rules

Customize expert assignment in the classification prompts:

```yaml
assignment_rules:
  dbt_model_errors: "dbt-expert"
  warehouse_performance: "snowflake-expert"
  dashboard_issues: "tableau-expert"
  workflow_failures: "github-sleuth-expert"
  cross_system_issues: "da-architect"
```

### Escalation Thresholds

Adjust escalation rules in `cross-repository-coordination.yml`:

```yaml
escalation_triggers:
  high_volume_threshold: 5 # issues per day
  critical_response_time: 4 # hours
  recurring_issue_threshold: 3 # occurrences
  cross_repo_correlation_threshold: 2 # related issues
```

## Monitoring and Metrics

### Key Metrics to Track

1. **Response Time Metrics**:
   - Time to first classification: Target < 2 hours
   - Time to expert assignment: Target < 4 hours
   - Time to first response: Target < 8 hours

2. **Classification Accuracy**:
   - Auto-resolution rate for transient failures: Target > 30%
   - Expert assignment accuracy: Target > 90%
   - False positive reduction: Target > 50%

3. **System Health Indicators**:
   - Total issue volume trends
   - Resolution time improvements
   - Expert workload distribution

### Monitoring Dashboard

Create issues in da-agent-hub to track system performance:

```bash
# Weekly metrics review
gh issue create \
  --title "Weekly Issue Tracking Metrics - $(date '+%Y-%m-%d')" \
  --body "Review classification accuracy, resolution times, and system health" \
  --label "metrics,weekly-review" \
  --assignee "claude[bot]"
```

## Troubleshooting

### Common Issues

1. **Classification not triggering**:
   ```bash
   # Check workflow permissions
   gh workflow list --repo your-org/claude-analytics-framework

   # Verify secrets are configured
   gh secret list --repo your-org/your-data-repo
   ```

2. **Cross-repository triggers failing**:
   ```bash
   # Test PAT token permissions
   curl -H "Authorization: token $FRAMEWORK_PAT" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/repos/your-org/claude-analytics-framework/actions/workflows
   ```

3. **Agent not responding correctly**:
   ```bash
   # Test agents locally
   claude "using github-sleuth-expert, test classification capabilities"
   claude "using issue-lifecycle-expert, review automation rules"
   ```

### Debugging Workflows

Enable debug logging in GitHub Actions:

```yaml
# Add to workflow files for debugging
env:
  ACTIONS_RUNNER_DEBUG: true
  ACTIONS_STEP_DEBUG: true
```

## Maintenance

### Weekly Tasks
1. Review classification accuracy and adjust prompts
2. Check for new error patterns requiring rule updates
3. Monitor expert workload and assignment accuracy
4. Update escalation thresholds based on volume trends

### Monthly Tasks
1. Analyze cross-repository correlation patterns
2. Update automation rules based on learnings
3. Review and optimize workflow performance
4. Generate system health reports

### Continuous Improvement
1. Collect feedback from domain experts on assignment accuracy
2. Refine Claude prompts based on misclassifications
3. Add new error patterns as they're discovered
4. Optimize workflow performance and reduce execution time

## Success Criteria

The system is successfully deployed when:

- ✅ Issues are automatically classified within 2 hours
- ✅ Expert assignment accuracy exceeds 90%
- ✅ Transient failures are auto-resolved without manual intervention
- ✅ Cross-repository patterns are detected and coordinated
- ✅ Resolution times improve by 40% compared to manual triage
- ✅ False positive noise is reduced by 50%

## Next Steps

After successful deployment:

1. **Expand to additional repositories** as needed
2. **Add predictive capabilities** for proactive issue detection
3. **Integrate with external systems** (Slack, PagerDuty, etc.)
4. **Develop custom metrics dashboards** for stakeholder reporting
5. **Create automated resolution capabilities** for simple, repeatable fixes

This enhanced system transforms reactive issue management into an intelligent, proactive operation that learns from patterns and continuously improves efficiency.