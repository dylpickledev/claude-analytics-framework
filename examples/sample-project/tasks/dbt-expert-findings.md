# dbt Expert Findings - Customer Churn Dashboard

**Agent:** dbt-expert
**Delegated by:** analytics-engineer-role
**Date:** 2024-10-15

---

## Task: Design dbt models for customer churn analysis

### Context Analysis

**Existing models reviewed:**
- ✅ `staging/stripe/stg_stripe__charges` - Transaction data exists
- ✅ `staging/salesforce/stg_salesforce__accounts` - Customer data exists
- ✅ `intermediate/customer/int_customer_orders` - Order aggregations exist
- ❌ Product usage staging - MISSING (need to create)

**Performance considerations:**
- 500K customers × 365 days = 182M rows potential
- Need incremental strategy to manage scale
- Tableau requires fast queries → materialize as table

### Recommended Architecture

```
stg_segment__product_events (new)
         ↓
int_customer_daily_metrics (new)
         ↓
fct_customer_churn_risk (new)
```

---

## Implementation Details

### Model 1: `staging/segment/stg_segment__product_events.sql`

**Purpose:** Clean product usage events from Segment

```sql
WITH source AS (
    SELECT * FROM {{ source('segment', 'product_events') }}
),

renamed AS (
    SELECT
        user_id AS customer_id,
        event_timestamp,
        event_name,
        -- Add other relevant fields
    FROM source
    WHERE user_id IS NOT NULL
)

SELECT * FROM renamed
```

**Tests:**
```yaml
models:
  - name: stg_segment__product_events
    columns:
      - name: customer_id
        tests:
          - not_null
      - name: event_timestamp
        tests:
          - not_null
```

---

### Model 2: `intermediate/customer/int_customer_daily_metrics.sql`

**Purpose:** Daily customer engagement metrics

**Materialization:** Incremental (append-only)

```sql
{{ config(
    materialized='incremental',
    unique_key='customer_id_date',
    on_schema_change='append_new_columns'
) }}

WITH customer_orders AS (
    SELECT
        customer_id,
        DATE_TRUNC('day', order_date) AS metric_date,
        COUNT(*) AS orders_count,
        SUM(order_amount) AS revenue
    FROM {{ ref('int_customer_orders') }}
    WHERE order_date >= CURRENT_DATE - 90
    {% if is_incremental() %}
        AND order_date > (SELECT MAX(metric_date) FROM {{ this }})
    {% endif %}
    GROUP BY 1, 2
),

product_usage AS (
    SELECT
        customer_id,
        DATE_TRUNC('day', event_timestamp) AS metric_date,
        COUNT(*) AS usage_events
    FROM {{ ref('stg_segment__product_events') }}
    WHERE event_timestamp >= CURRENT_DATE - 90
    {% if is_incremental() %}
        AND event_timestamp > (SELECT MAX(metric_date) FROM {{ this }})
    {% endif %}
    GROUP BY 1, 2
),

combined AS (
    SELECT
        COALESCE(o.customer_id, p.customer_id) AS customer_id,
        COALESCE(o.metric_date, p.metric_date) AS metric_date,
        COALESCE(o.orders_count, 0) AS orders_count,
        COALESCE(o.revenue, 0) AS revenue,
        COALESCE(p.usage_events, 0) AS usage_events,
        DATEDIFF('day', metric_date, CURRENT_DATE) AS days_since_activity
    FROM customer_orders o
    FULL OUTER JOIN product_usage p
        ON o.customer_id = p.customer_id
        AND o.metric_date = p.metric_date
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'metric_date']) }} AS customer_id_date,
    *,
    SUM(orders_count) OVER (
        PARTITION BY customer_id
        ORDER BY metric_date
        ROWS BETWEEN 89 PRECEDING AND CURRENT ROW
    ) AS orders_last_90d,
    AVG(revenue) OVER (
        PARTITION BY customer_id
        ORDER BY metric_date
        ROWS BETWEEN 89 PRECEDING AND CURRENT ROW
    ) AS avg_revenue_last_90d
FROM combined
```

**Tests:**
```yaml
models:
  - name: int_customer_daily_metrics
    tests:
      - dbt_utils.unique_combination_of_columns:
          combination_of_columns:
            - customer_id
            - metric_date
    columns:
      - name: customer_id_date
        tests:
          - unique
          - not_null
```

---

### Model 3: `marts/customer_analytics/fct_customer_churn_risk.sql`

**Purpose:** Final mart with churn risk scoring

**Materialization:** Table (Tableau performance)

```sql
{{ config(
    materialized='table',
    tags=['tableau', 'customer_analytics']
) }}

WITH latest_metrics AS (
    SELECT
        customer_id,
        MAX(metric_date) AS latest_date
    FROM {{ ref('int_customer_daily_metrics') }}
    GROUP BY 1
),

customer_current_state AS (
    SELECT
        m.customer_id,
        m.metric_date,
        m.days_since_activity,
        m.orders_last_90d,
        m.avg_revenue_last_90d,
        m.usage_events
    FROM {{ ref('int_customer_daily_metrics') }} m
    INNER JOIN latest_metrics l
        ON m.customer_id = l.customer_id
        AND m.metric_date = l.latest_date
),

churn_risk_calculation AS (
    SELECT
        *,
        CASE
            WHEN days_since_activity > 90 OR orders_last_90d = 0 THEN 'HIGH'
            WHEN days_since_activity > 60 OR orders_last_90d < 2 THEN 'MEDIUM'
            WHEN days_since_activity > 30 THEN 'LOW'
            ELSE 'ACTIVE'
        END AS churn_risk_level,

        -- Risk score (0-100)
        LEAST(100,
            (days_since_activity * 0.5) +
            (CASE WHEN orders_last_90d = 0 THEN 50 ELSE 0 END) +
            (CASE WHEN usage_events = 0 THEN 30 ELSE 0 END)
        ) AS churn_risk_score
    FROM customer_current_state
)

SELECT
    customer_id,
    metric_date AS as_of_date,
    churn_risk_level,
    churn_risk_score,
    days_since_activity,
    orders_last_90d,
    avg_revenue_last_90d,
    usage_events,

    -- Human-readable risk reasons
    CASE
        WHEN days_since_activity > 90 THEN 'No activity in 90+ days'
        WHEN orders_last_90d = 0 THEN 'No orders in last 90 days'
        WHEN usage_events = 0 THEN 'No product usage detected'
        ELSE 'Low engagement metrics'
    END AS primary_risk_reason
FROM churn_risk_calculation
```

**Tests:**
```yaml
models:
  - name: fct_customer_churn_risk
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
      - name: churn_risk_level
        tests:
          - accepted_values:
              values: ['HIGH', 'MEDIUM', 'LOW', 'ACTIVE']
      - name: churn_risk_score
        tests:
          - dbt_utils.accepted_range:
              min_value: 0
              max_value: 100
```

---

## Performance Optimization

**Incremental strategy:**
- `int_customer_daily_metrics` → Incremental with 90-day lookback
- Expect ~1.5M rows added daily (500K customers × 3 data sources)
- Runtime: <5 minutes expected

**Tableau optimization:**
- Materialize as table (not view)
- Add clustering key on `churn_risk_level` for Tableau filters
- Consider aggregate table if dashboard is slow

**SQL optimization:**
```sql
-- Add to fct_customer_churn_risk config:
{{ config(
    materialized='table',
    cluster_by=['churn_risk_level'],
    tags=['tableau', 'customer_analytics']
) }}
```

---

## Deployment Checklist

**Before merge:**
- [ ] All tests pass in dev
- [ ] Manual QA: Check sample customers match expected risk levels
- [ ] Performance: Confirm <10 min runtime
- [ ] Documentation: Add model descriptions and column docs

**After merge:**
- [ ] Create dbt Cloud job for daily refresh (6 AM)
- [ ] Grant Tableau service account read access to mart
- [ ] Monitor first 3 runs for errors

---

## Pattern Extraction (for framework memory)

```markdown
PATTERN: Customer churn risk model using recency and frequency metrics
- Daily incremental model with 90-day lookback window
- Risk scoring based on days_since_activity + order frequency + usage
- Table materialization for BI tool performance
- Clustered by risk level for filter performance

SOLUTION: Window functions for rolling 90-day aggregations
- Handles sparse data (not all customers active every day)
- FULL OUTER JOIN pattern for multiple activity sources
- Surrogate key from customer_id + date for uniqueness

ARCHITECTURE: Staging → Intermediate → Mart pattern
- Staging: Clean source data
- Intermediate: Daily metrics with incrementality
- Mart: Business logic and risk scoring (non-incremental)
```

---

## Questions for Product Owner

1. Should we alert on customers transitioning to HIGH risk? (Not in scope for v1)
2. What customer segments need separate dashboards? (To be determined)
3. Is 90-day lookback window appropriate? (Confirmed: yes)

---

**Status:** ✅ Complete - Models designed, ready for implementation
**Next Step:** Hand off to analytics-engineer-role for implementation and testing
