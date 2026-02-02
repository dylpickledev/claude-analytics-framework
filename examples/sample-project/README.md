# Sample Project: Customer Churn Dashboard

This is an example of what a completed project looks like in the Claude Analytics Framework.

## Project Context

**Goal:** Build a customer churn prediction dashboard combining dbt models, Snowflake analysis, and Tableau visualization.

**Timeline:** Started Oct 15, 2024 → Completed Oct 18, 2024 (3 days)

**Team:** 1 analytics engineer using the framework

---

## What the Framework Created

When you run `/start "customer churn dashboard"`, you get this structure:

```
projects/active/feature-customer-churn-dashboard/
├── README.md           # This file - navigation hub
├── spec.md            # Requirements and implementation plan
├── context.md         # Working state tracking
└── tasks/
    ├── current-task.md          # Current focus
    ├── dbt-expert-findings.md   # dbt model recommendations
    ├── tableau-expert-findings.md  # Dashboard design
    └── analytics-engineer-role-findings.md  # Overall coordination
```

---

## Real Agent Output Examples

### dbt-expert-findings.md (excerpt)

```markdown
## Task: Design churn prediction model

### Analysis
Customer churn requires combining:
- Historical transaction data (fct_orders)
- Customer demographic data (dim_customers)
- Product engagement metrics (fct_product_usage)

### Recommended Approach

**Model Type:** Incremental model with daily refresh
**Materialization:** Table (needed for Tableau performance)

### Implementation

CREATE MODEL: `marts/customer_analytics/fct_customer_churn_risk.sql`

```sql
{{ config(
    materialized='incremental',
    unique_key='customer_id',
    on_schema_change='append_new_columns'
) }}

WITH customer_metrics AS (
    SELECT
        customer_id,
        DATE_TRUNC('day', metric_date) AS metric_date,
        days_since_last_order,
        total_orders_last_90d,
        avg_order_value_last_90d,
        product_usage_score
    FROM {{ ref('int_customer_daily_metrics') }}
    {% if is_incremental() %}
    WHERE metric_date > (SELECT MAX(metric_date) FROM {{ this }})
    {% endif %}
),

churn_risk AS (
    SELECT
        customer_id,
        metric_date,
        CASE
            WHEN days_since_last_order > 90 THEN 'HIGH'
            WHEN days_since_last_order > 60 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS churn_risk_level
    FROM customer_metrics
)

SELECT * FROM churn_risk
```

### Tests Required
- `not_null` on customer_id, metric_date
- `unique` on customer_id + metric_date
- `accepted_values` on churn_risk_level
- Custom test: verify daily grain
```

---

## What This Shows

**Agent Coordination:**
- analytics-engineer-role delegated model design to dbt-expert
- dbt-expert used MCP tools to analyze existing models
- Provided specific SQL with dbt best practices
- Included testing strategy

**Knowledge Capture:**
After `/complete`, the framework extracted:
- Incremental model pattern for customer metrics
- Churn risk calculation logic
- Testing patterns for daily-grain models

**Future projects benefit:** Next time someone builds a customer dashboard, agents already know this pattern.

---

## Time Breakdown

**Without framework (estimated):**
- 2 hours: Context switch between repos, find similar models
- 1 hour: Write dbt model, debate incremental strategy
- 45 min: Add tests after model works
- 30 min: Coordinate with Tableau requirements
- **Total: ~4.5 hours**

**With framework (actual):**
- 2 min: `/start` creates project structure
- 10 min: Ask dbt-expert for model design → Get complete implementation
- 5 min: Ask tableau-expert for dashboard requirements → Get layout
- 15 min: Implement and test the model
- **Total: ~32 minutes**

**Time saved: 4 hours** (and the pattern is now captured for future projects)

---

## Key Files from This Project

- [spec.md](spec.md) - Original requirements
- [context.md](context.md) - Working state and decisions
- [tasks/dbt-expert-findings.md](tasks/dbt-expert-findings.md) - Model design
- [tasks/analytics-engineer-role-findings.md](tasks/analytics-engineer-role-findings.md) - Coordination

---

## Lessons Learned

**What worked:**
- Incremental model pattern from dbt-expert was correct first try
- Agent coordination (analytics-engineer → dbt-expert → tableau-expert) was smooth
- Pattern extraction during `/complete` captured reusable logic

**What could improve:**
- Initial requirements in spec.md were vague, needed clarification
- Could have used `/research` command first for better planning

**Extracted patterns (now in agent memory):**
- `PATTERN: Customer churn risk calculation using recency metrics`
- `PATTERN: Daily-grain incremental models with deduplication`
- `PATTERN: Tableau-optimized dbt models (table materialization)`

---

This example demonstrates the complete lifecycle: start → agent consultation → implementation → completion → learning extraction.
