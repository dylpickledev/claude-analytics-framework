---
name: dbt-snowflake-optimization-pattern
description: Cross-Tool Integration Pattern: dbt + Snowflake Model Optimization
user-invocable: false
---

# Cross-Tool Integration Pattern: dbt + Snowflake Model Optimization

**Pattern Type**: Performance Optimization
**Tools**: dbt-mcp, snowflake-mcp
**Confidence**: HIGH (0.92) - Production-validated pattern
**Primary Users**: dbt-expert, snowflake-expert, analytics-engineer-role

---

## Problem Statement

**Scenario**: Slow-running dbt model impacting downstream dashboards and reports
**Symptoms**: Model runtime >30 minutes, warehouse queuing, excessive costs
**Goal**: Reduce runtime to <5 minutes while maintaining data accuracy

---

## Integration Pattern Overview

### Tool Coordination Strategy
```
dbt-mcp → Get model metadata, dependencies, compiled SQL
    ↓
snowflake-mcp → Profile query performance, analyze warehouse usage
    ↓
dbt-expert → Analyze findings, design optimization strategy
    ↓
snowflake-mcp → Validate optimized query performance
    ↓
dbt-mcp → Update model configuration, verify impact
```

**Why both tools needed**:
- **dbt-mcp**: Transformation logic, model structure, dependencies
- **snowflake-mcp**: Query execution, performance metrics, warehouse data
- **Together**: Complete picture of transformation + execution performance

---

## Step-by-Step Workflow

### Step 1: Model Discovery (dbt-mcp)

**Gather model context**:
```bash
# 1. Get model details (compiled SQL, config, dependencies)
mcp__dbt-mcp__get_model_details \
  model_name="fct_orders"
```

**Returns**:
- Compiled SQL (transformation logic)
- Model configuration (materialization, incremental strategy)
- Column definitions and data types
- Dependencies (upstream models)

**Extract for analysis**:
- Current materialization strategy (table, view, incremental)
- Incremental logic (if applicable)
- Complex transformations (window functions, recursive CTEs)
- Join patterns and cardinality

---

### Step 2: Performance Profiling (snowflake-mcp)

**Execute model query for profiling**:
```bash
# 2. Run the compiled SQL to get query profile
mcp__snowflake-mcp__run_snowflake_query \
  statement="[Compiled SQL from step 1]"
```

**Get query execution details**:
```bash
# 3. Query Snowflake query history for performance metrics
mcp__snowflake-mcp__run_snowflake_query \
  statement="
SELECT
  query_id,
  execution_time / 1000 as execution_seconds,
  bytes_scanned,
  partitions_scanned,
  partitions_total,
  compilation_time,
  warehouse_size,
  credits_used_cloud_services
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text ILIKE '%fct_orders%'
  AND start_time >= DATEADD(hour, -24, CURRENT_TIMESTAMP())
ORDER BY start_time DESC
LIMIT 5
"
```

**Analyze bottlenecks**:
- Execution time breakdown (scan, join, aggregation)
- Partitions scanned vs total (clustering effectiveness)
- Bytes scanned (data volume)
- Warehouse size vs workload

---

### Step 3: Dependency Analysis (dbt-mcp)

**Check upstream dependencies**:
```bash
# 4. Get parent models (upstream dependencies)
mcp__dbt-mcp__get_model_parents \
  model_name="fct_orders"
```

**Check downstream impact**:
```bash
# 5. Get child models (blast radius of changes)
mcp__dbt-mcp__get_model_children \
  model_name="fct_orders"
```

**Assess impact**:
- Number of downstream models/reports
- Critical dependencies (production dashboards)
- Acceptable downtime window
- Testing requirements for validation

---

### Step 4: Optimization Strategy Design (dbt-expert)

**Delegate to specialist**:
```markdown
DELEGATE TO: dbt-expert

CONTEXT:
- Task: Optimize slow-running fct_orders model
- Current State:
  - Model: fct_orders (fact table, 50M rows)
  - Runtime: 45 minutes (unacceptable)
  - Materialization: view (full table scan on every query)
  - Dependencies: 3 upstream staging models, 12 downstream marts

- Performance Metrics (from Snowflake):
  - Execution time: 45 minutes
  - Partitions scanned: 2,500 / 2,500 (100% - no clustering)
  - Bytes scanned: 15 GB
  - Warehouse: MEDIUM (4 credits/hour)

- Requirements:
  - Reduce runtime to <5 minutes
  - Maintain daily refresh SLA
  - No data accuracy impact
  - Must support downstream mart dependencies

- Constraints:
  - Production model (high visibility)
  - Cannot increase warehouse size (cost constraint)
  - Downstream marts run at 3 AM daily

REQUEST: "Validated optimization strategy with dbt model changes and expected performance improvement"
```

**Specialist provides**:
1. **Incremental strategy**: Convert view → incremental table
2. **Clustering recommendation**: Cluster on `order_date` (common filter)
3. **Lookback window**: 3-day lookback for late-arriving data
4. **Updated dbt model code** with new config
5. **Testing plan**: Validate data accuracy, performance metrics

---

### Step 5: Snowflake Validation (snowflake-mcp)

**Test optimized query**:
```bash
# 6. Execute optimized SQL to validate performance
mcp__snowflake-mcp__run_snowflake_query \
  statement="[Optimized SQL from dbt-expert]"
```

**Validate clustering effectiveness**:
```bash
# 7. Check clustering metrics
mcp__snowflake-mcp__run_snowflake_query \
  statement="
SELECT
  clustering_depth,
  partition_depth,
  total_partitions
FROM TABLE(INFORMATION_SCHEMA.AUTOMATIC_CLUSTERING_HISTORY(
  TABLE_NAME => 'FCT_ORDERS',
  DATABASE_NAME => 'ANALYTICS_DW',
  SCHEMA_NAME => 'PROD_SALES_DM'
))
WHERE start_time >= DATEADD(day, -1, CURRENT_TIMESTAMP())
LIMIT 5
"
```

**Expected improvements**:
- Execution time: 45 min → 4 min (91% reduction)
- Partitions scanned: 2,500 → 150 (94% reduction)
- Bytes scanned: 15 GB → 800 MB (95% reduction)
- Cost: Same warehouse, 90% fewer credits per query

---

### Step 6: Implementation & Testing (dbt-mcp)

**Update model configuration**:
```sql
-- models/marts/fct_orders.sql
{{
  config(
    materialized='incremental',
    unique_key='order_id',
    cluster_by=['order_date'],
    incremental_strategy='merge',
    on_schema_change='fail'
  )
}}

WITH source_data AS (
  SELECT * FROM {{ ref('stg_orders') }}
  {% if is_incremental() %}
  WHERE order_date >= DATEADD(day, -3, CURRENT_DATE)
  {% endif %}
),
-- ... rest of transformation logic
```

**Run dbt build**:
```bash
# 8. Build incremental model (first run - full refresh)
mcp__dbt-mcp__build \
  selector="fct_orders" \
  is_full_refresh=true
```

**Validate model health**:
```bash
# 9. Check model health after build
mcp__dbt-mcp__get_model_health \
  model_name="fct_orders"
```

**Run tests**:
```bash
# 10. Execute dbt tests
mcp__dbt-mcp__test \
  selector="fct_orders"
```

---

### Step 7: Performance Validation (snowflake-mcp)

**Validate incremental runtime**:
```bash
# 11. Run incremental update to test daily runtime
mcp__dbt-mcp__build \
  selector="fct_orders" \
  is_full_refresh=false
```

**Check actual performance**:
```bash
# 12. Query performance metrics for validation
mcp__snowflake-mcp__run_snowflake_query \
  statement="
SELECT
  execution_time / 1000 as execution_seconds,
  partitions_scanned,
  bytes_scanned / 1024 / 1024 / 1024 as gb_scanned,
  credits_used_cloud_services
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text ILIKE '%fct_orders%'
  AND start_time >= DATEADD(hour, -1, CURRENT_TIMESTAMP())
ORDER BY start_time DESC
LIMIT 1
"
```

**Success criteria**:
- ✅ Incremental runtime <5 minutes
- ✅ Tests pass (no data quality issues)
- ✅ Downstream marts unaffected
- ✅ Cost reduction achieved

---

## Real-World Example

### Before Optimization

**Model**: `fct_customer_transactions` (75M rows)
**Issue**: 60-minute runtime, blocking downstream dashboards

**Metrics**:
- Materialization: VIEW (full scan every query)
- Partitions scanned: 3,200 / 3,200 (100%)
- Bytes scanned: 22 GB
- Warehouse: MEDIUM
- Cost: 4 credits × 1 hour = 4 credits per refresh

**dbt-mcp findings**:
```bash
# Model details showed:
- Materialization: view
- No incremental logic
- No clustering
- Complex window functions (recalculating all history)
```

**snowflake-mcp findings**:
```bash
# Performance query showed:
- 60-minute execution time
- Full table scan on every query
- No partition pruning
- Sorting 75M rows repeatedly
```

---

### After Optimization

**Changes implemented**:
1. Converted to incremental table (7-day lookback)
2. Clustered on `transaction_date`
3. Added deduplication logic in incremental strategy
4. Optimized window functions (partition by customer, order by transaction_date)

**Results**:
- Materialization: INCREMENTAL TABLE
- Partitions scanned: 3,200 → 180 (94% reduction)
- Bytes scanned: 22 GB → 1.2 GB (95% reduction)
- Incremental runtime: 60 min → 3.5 min (94% reduction)
- Cost: 4 credits → 0.23 credits per refresh (94% reduction)

**Annual savings**: 365 days × 3.77 credits × $4/credit = **$5,505/year** for single model

---

## Tool-Specific Responsibilities

### dbt-mcp Responsibilities
- ✅ Model metadata (structure, config, dependencies)
- ✅ Compiled SQL (transformation logic)
- ✅ Model health (tests, freshness)
- ✅ Dependency analysis (parents, children)
- ✅ Build execution (incremental runs)
- ❌ Query performance metrics (delegate to snowflake-mcp)
- ❌ Warehouse-level optimization (delegate to snowflake-mcp)

### snowflake-mcp Responsibilities
- ✅ Query execution metrics (runtime, bytes scanned, partitions)
- ✅ Warehouse performance (credits, queue time)
- ✅ Clustering effectiveness (partition pruning)
- ✅ Cost analysis (credit usage, query history)
- ❌ Transformation logic (delegate to dbt-mcp)
- ❌ Model dependencies (delegate to dbt-mcp)

### Why Both Tools Required
- **dbt-mcp alone**: Can see SQL but not execution performance
- **snowflake-mcp alone**: Can see performance but not transformation context
- **Together**: Complete optimization picture (logic + execution)

---

## Common Optimization Patterns

### Pattern 1: View → Incremental Table
**When**: Large fact tables queried frequently
**dbt-mcp**: Change materialization config
**snowflake-mcp**: Validate query performance improvement
**Benefit**: 90-95% runtime reduction typical

### Pattern 2: Add Clustering
**When**: Large tables with common filter columns
**dbt-mcp**: Add `cluster_by` config
**snowflake-mcp**: Validate partition pruning effectiveness
**Benefit**: 80-95% scan reduction on filtered queries

### Pattern 3: Optimize Incremental Strategy
**When**: Incremental models with duplicates or late arrivals
**dbt-mcp**: Update `unique_key` and `incremental_strategy`
**snowflake-mcp**: Validate merge performance
**Benefit**: Data accuracy + performance improvement

### Pattern 4: Warehouse Right-Sizing
**When**: Warehouse too large or too small for workload
**dbt-mcp**: Understand query patterns and dependencies
**snowflake-mcp**: Analyze warehouse utilization and queue times
**Benefit**: Cost optimization without performance degradation

---

## Troubleshooting

### Issue: Optimization Doesn't Improve Performance
**Symptoms**: Same runtime after incremental conversion
**Root causes**:
- Clustering on low-cardinality column (not effective)
- Lookback window too large (scanning too much data)
- Upstream models still slow (bottleneck moved)

**Debug with snowflake-mcp**:
```bash
# Check if clustering is working
mcp__snowflake-mcp__run_snowflake_query \
  statement="
SELECT
  clustering_depth,
  partition_depth
FROM TABLE(INFORMATION_SCHEMA.AUTOMATIC_CLUSTERING_HISTORY(...))
"
```

### Issue: Incremental Model Has Duplicates
**Symptoms**: Tests fail, duplicate primary keys
**Root causes**:
- Missing or incorrect `unique_key`
- Improper deduplication logic
- Late-arriving data not handled

**Debug with dbt-mcp**:
```bash
# Check model tests
mcp__dbt-mcp__test selector="fct_orders"

# Validate data with query
mcp__dbt-mcp__show sql_query="
SELECT order_id, COUNT(*)
FROM {{ ref('fct_orders') }}
GROUP BY order_id
HAVING COUNT(*) > 1
LIMIT 10
"
```

### Issue: Downstream Models Break
**Symptoms**: Child models fail after optimization
**Root causes**:
- Materialization change affects downstream queries
- Column order changed
- Data type changes

**Debug with dbt-mcp**:
```bash
# Identify affected downstream models
mcp__dbt-mcp__get_model_children model_name="fct_orders"

# Test downstream models
mcp__dbt-mcp__test selector="fct_orders+"
```

---

## Best Practices

### 1. Always Profile Before Optimizing
- Use snowflake-mcp to get baseline metrics
- Understand bottlenecks before making changes
- Document current performance for comparison

### 2. Test Incrementally
- Optimize one model at a time
- Validate performance improvement before moving to next
- Run full test suite after each change

### 3. Monitor Downstream Impact
- Check child models with dbt-mcp `get_model_children`
- Run downstream tests with `dbt test --select fct_orders+`
- Validate data accuracy with spot checks

### 4. Document Optimization Decisions
- Record baseline metrics (runtime, bytes scanned, costs)
- Document optimization strategy and rationale
- Track actual improvement vs expected

### 5. Consider Total Cost of Ownership
- Warehouse credits (query execution)
- Storage costs (incremental tables vs views)
- Maintenance overhead (clustering, archiving)
- Development time (implementation, testing)

---

## Success Metrics

### Performance Metrics
- **Runtime reduction**: >80% improvement typical
- **Scan reduction**: >90% fewer partitions scanned
- **Cost reduction**: >85% fewer credits per query

### Quality Metrics
- **Data accuracy**: 100% (tests must pass)
- **Downstream impact**: 0 broken dependencies
- **Incremental logic**: No duplicates or data loss

### Business Metrics
- **Dashboard refresh**: Faster, more frequent updates
- **Analyst productivity**: Reduced query wait times
- **Annual cost savings**: $1K-$10K+ per optimized model

---

## Related Patterns

- **dbt Testing Strategy**: `.claude/skills/reference-knowledge/testing-patterns/SKILL.md`
- **Snowflake Cost Optimization**: Integrated within this pattern
- **Incremental Model Design**: `.claude/agents/specialists/dbt-expert.md`

---

*Created: 2025-10-08*
*Pattern Type: Cross-Tool Integration*
*Confidence: HIGH (0.92) - Production-validated*
