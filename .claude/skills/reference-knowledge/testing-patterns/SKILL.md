---
name: testing-patterns
description: Reference for analytics development testing patterns including unit tests, data quality tests, integration tests, and QA standards
user-invocable: false
---

# Testing Patterns for Analytics Development

## ADLC Testing Alignment

Following the Analytics Development Lifecycle testing approach:

### Unit Tests
**Purpose**: Logic testing within individual models

**Patterns**:
- Test individual transformation logic
- Validate calculation accuracy
- Check edge case handling
- Verify data type conversions

**Example dbt Tests**:
```yaml
# Test specific column logic
- name: revenue
  tests:
    - not_null
    - dbt_utils.expression_is_true:
        expression: ">= 0"
```

### Data Tests
**Purpose**: Data quality and conformance validation

**Patterns**:
- Schema conformance tests
- Referential integrity checks
- Uniqueness constraints
- Null value validation
- Accepted value ranges

**Example dbt Tests**:
```yaml
# Data quality tests
tests:
  - unique:
      column_name: customer_id
  - not_null:
      column_name: order_date
  - relationships:
      to: ref('dim_customers')
      field: customer_id
```

### Integration Tests
**Purpose**: Cross-system and end-to-end validation

**Patterns**:
- Cross-model consistency checks
- Source-to-target reconciliation
- Business metric validation
- End-to-end data flow tests

**Example dbt Tests**:
```yaml
# Cross-system validation
- name: reconciliation_test
  tests:
    - dbt_utils.recency:
        datepart: day
        field: created_at
        interval: 1
```

## Data Quality Testing Framework

### Schema Tests
**What to Test**:
- Column existence and names
- Data types match expectations
- Required columns present
- Column order (if critical)

**Pattern**:
```sql
-- Validate schema structure
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'target_table'
  AND column_name NOT IN (expected_columns)
```

**When to Use**:
- After schema migrations
- Source system changes
- Model refactoring
- Production deployments

### Business Logic Tests
**What to Test**:
- Metric calculations accurate
- Business rules enforced
- Referential integrity maintained
- Historical data consistency

**Pattern**:
```sql
-- Validate business metric
WITH actual AS (
  SELECT SUM(revenue) as total_revenue
  FROM {{ ref('fct_sales') }}
  WHERE date = '2024-01-01'
),
expected AS (
  SELECT 1000000 as total_revenue  -- Known good value
)
SELECT *
FROM actual
CROSS JOIN expected
WHERE ABS(actual.total_revenue - expected.total_revenue) > 100
```

**When to Use**:
- New business logic implementation
- Metric definition changes
- Stakeholder validation needed
- Production reconciliation

### Performance Tests
**What to Test**:
- Query execution time acceptable
- Result set sizes reasonable
- Resource consumption appropriate
- Incremental model efficiency

**Pattern**:
```sql
-- Monitor query performance
SELECT
  query_text,
  execution_time,
  rows_produced,
  bytes_scanned
FROM snowflake.account_usage.query_history
WHERE query_text ILIKE '%model_name%'
  AND execution_time > 60000  -- Over 1 minute
ORDER BY execution_time DESC
```

**When to Use**:
- Model optimization work
- Production performance issues
- Cost reduction initiatives
- Capacity planning

### Cross-System Tests
**What to Test**:
- Source system data vs warehouse data
- Expected row counts match
- Key business metrics reconcile
- Data freshness acceptable

**Pattern**:
```sql
-- Source to target reconciliation
WITH source_counts AS (
  SELECT COUNT(*) as source_count
  FROM source_system.orders
  WHERE order_date = CURRENT_DATE - 1
),
target_counts AS (
  SELECT COUNT(*) as target_count
  FROM {{ ref('stg_orders') }}
  WHERE order_date = CURRENT_DATE - 1
)
SELECT *
FROM source_counts
CROSS JOIN target_counts
WHERE source_count != target_count
```

**When to Use**:
- Data pipeline validation
- Source system changes
- Ingestion troubleshooting
- Data quality monitoring

## Testing Commands for Analytics Work

### dbt Testing Workflow
```bash
# ADLC-aligned testing workflow

# 1. Run all test types for specific model
dbt test --select <model_name>

# 2. Execute model implementation
dbt run --select <model_name>

# 3. Validate results and store failures for investigation
dbt test --select <model_name> --store-failures

# 4. Run specific test type
dbt test --select test_type:generic  # Built-in tests
dbt test --select test_type:singular  # Custom SQL tests

# 5. Test entire model lineage
dbt test --select <model_name>+      # Downstream
dbt test --select +<model_name>      # Upstream
dbt test --select +<model_name>+     # Full lineage
```

### Incremental Testing Pattern
```bash
# Test incremental models efficiently

# 1. Full refresh for validation
dbt run --select <model_name> --full-refresh

# 2. Test full-refreshed data
dbt test --select <model_name>

# 3. Run incremental update
dbt run --select <model_name>

# 4. Validate incremental logic
dbt test --select <model_name> --store-failures
```

### CI/CD Testing Pattern
```bash
# Continuous integration testing

# 1. Test only modified models and downstream
dbt test --select state:modified+

# 2. Slim CI: test changes only
dbt test --select state:modified+ --defer --state ./prod-manifest

# 3. Full regression test
dbt test --exclude tag:slow
```

## QA Testing Requirements

### Hands-On Testing Standards
**CRITICAL**: "It loads" is NOT testing

**Minimum Testing Requirements**:
- ✅ Every interactive element clicked
- ✅ All buttons tested for functionality
- ✅ Forms submitted with valid/invalid data
- ✅ Filters applied and verified
- ✅ Error scenarios triggered and handled
- ✅ Screenshots captured during testing
- ✅ Real data used (no mock data shortcuts)

### UI/UX Testing Checklist
```markdown
- [ ] Dashboard/page loads successfully
- [ ] All navigation elements work
- [ ] Filters apply correctly and update data
- [ ] Buttons trigger expected actions
- [ ] Forms validate input properly
- [ ] Error messages display appropriately
- [ ] Data refreshes when expected
- [ ] Loading states show properly
- [ ] Mobile/responsive layout works
- [ ] Accessibility standards met
```

### Data Pipeline Testing Checklist
```markdown
- [ ] Source data ingested completely
- [ ] Transformations produce expected results
- [ ] Data quality tests pass
- [ ] Business metrics reconcile
- [ ] Performance acceptable
- [ ] Error handling works correctly
- [ ] Logging captures key events
- [ ] Monitoring alerts configured
- [ ] Documentation updated
- [ ] Stakeholders can access data
```

## Testing Pattern Decision Tree

```
Is this a model change?
├─ Yes → dbt test --select <model>+
│         └─ Failures? → dbt test --store-failures → Investigate
├─ No → Is this a UI change?
│      ├─ Yes → qa-coordinator (hands-on testing)
│      │       └─ Screenshot capture + findings doc
│      └─ No → Is this a pipeline change?
│             ├─ Yes → Integration tests + reconciliation
│             └─ No → Is this infrastructure?
│                    └─ Yes → Performance tests + monitoring
```

## Enterprise Testing Standards

### Production-Ready Requirements
All code changes must meet these standards:

1. **Automated Tests**:
   - dbt tests for all models
   - Unit tests for custom logic
   - Integration tests for pipelines

2. **Manual QA**:
   - Hands-on testing by qa-coordinator
   - Screenshot documentation
   - Edge case validation

3. **Performance Validation**:
   - Query execution time acceptable
   - Resource consumption reasonable
   - Scalability considerations addressed

4. **Documentation**:
   - Test results documented
   - Findings captured in project tasks/
   - Known issues flagged clearly

5. **Stakeholder Validation**:
   - Business logic confirmed
   - Metrics reconciled
   - User acceptance obtained

## Pattern Markers for Memory Extraction

When documenting testing discoveries:
- `PATTERN:` Reusable testing approaches
- `SOLUTION:` Specific test implementations
- `ERROR-FIX:` Test failures and resolutions
- `ARCHITECTURE:` Testing strategy decisions
- `INTEGRATION:` Cross-system test coordination
