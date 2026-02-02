# Blank Dashboard Troubleshooting Playbook

**Last Updated:** 2025-10-03
**Based On:** Concrete Pre/Post Trip Dashboard Investigation

---

## Role-Based Investigation Flow

### Step 1: Verify Data Exists (analytics-engineer-role)

**Quick check (30 seconds):**
```sql
SELECT
  COUNT(*) as total_records,
  MAX(date_column) as most_recent_date,
  COUNT(CASE WHEN DATE(date_column) = CURRENT_DATE - 1 THEN 1 END) as yesterday_count
FROM report_table
WHERE date_column >= CURRENT_DATE - 7;
```

**Outcomes:**
- ✅ **Recent data exists** → Go to Step 3 (bi-developer-role)
- ❌ **No data or stale data** → Go to Step 2 (trace pipeline)

---

### Step 2: Trace Data Pipeline (analytics-engineer-role + data-engineer-role)

#### Phase A: Check Transformation Layer (analytics-engineer-role)

**Verify fact tables have recent data:**
```bash
dbt show --inline "
SELECT
  MAX(DATE(date_col)) as most_recent,
  CURRENT_DATE - 1 as expected,
  DATEDIFF(day, MAX(DATE(date_col)), CURRENT_DATE - 1) as days_behind
FROM {{ ref('fact_table') }}
"
```

**Outcomes:**
- **Fact fresh** → Transformation issue (review model logic)
- **Fact stale** → Continue to Phase B

#### Phase B: Check Source Layer (data-engineer-role)

**Verify source extraction completed:**
```bash
dbt show --inline "
SELECT
  MAX(DATE(LOADEDON)) as last_extraction,
  MAX(DATE(business_date_column)) as latest_business_date,
  COUNT(CASE WHEN DATE(business_date_column) = CURRENT_DATE - 1 THEN 1 END) as yesterday_records
FROM {{ ref('source_table') }}
"
```

**Decision Matrix:**

| Source LOADEDON | Business Dates | Root Cause | Action |
|----------------|----------------|------------|--------|
| Fresh (today) | Current | Source extraction working | Manual dbt job trigger |
| Fresh (today) | Old | Source system is behind | Contact source owner |
| Stale (yesterday+) | Old | Extraction pipeline issue | Check Orchestra/error logs |
| After dbt job ran | Current | Timing mismatch | Adjust Orchestra dependencies |

**Resolution:**
```bash
# If source is fresh but transformations stale
dbt build --select fact_table_name+ rpt_table_name+
```

---

### Step 3: Dashboard Investigation (bi-developer-role)

**ONLY investigate dashboard if data exists in underlying table**

#### Connection Type Check
- **Live connection** → Data refreshes automatically ✅ (rarely the issue)
- **Extract** → Check extract refresh schedule

#### Filter Configuration
1. Review date filters (relative vs absolute)
2. Verify filter values match available data dates
3. Check for cascading filter conflicts

#### Published Data Source
1. Verify data source connection is active
2. Refresh data source metadata if stale
3. Check connection credentials

#### Common Fixes
- Update relative date filters for reliability
- Convert extract to live connection
- Refresh published data source
- Clear and reapply filters

---

## Real World Example: Concrete Pre/Post Trip Dashboard

### Investigation Summary

**Symptoms:**
- Dashboard showed blank Pre-Trip and Post-Trip sections
- Users expected yesterday's data (2025-10-02)
- Live connection to Snowflake (not an extract issue)

**Investigation Path:**

1. **Step 1 - Check Report Table:**
   - ❌ Most recent data: 2025-10-01 (1 day behind)
   - ✅ Data quality good (Pre/Post categories populated correctly)
   - **Decision:** Data missing, proceed to Step 2

2. **Step 2A - Check Fact Table:**
   - ❌ fact_trakit_statuses_with_shifts: Only has data through 2025-10-01
   - **Decision:** Transformation layer current with source, check source

3. **Step 2B - Check Source Table:**
   - ✅ LOADEDON: 2025-10-03 (fresh extraction ran this morning!)
   - ✅ Business dates include: 2025-10-02 (yesterday's data exists!)
   - **Root Cause Found:** dbt job ran at 01:36 AM, source arrived after 07:00 AM

**Timeline Analysis:**
```
01:36 AM UTC - dbt job runs (processes available data through 10/01)
    ↓
07:00 AM+ - Source extraction runs (brings in data through 10/03)
    ↓
Result: Fresh source data exists but hasn't been transformed yet
```

**Resolution:**
```bash
dbt build --select fact_trakit_statuses_with_shifts+ rpt_concrete_trakit_pre_post_trip_analysis+
```

**Result:** Dashboard populated with yesterday's data within 40 minutes

---

## Agent Coordination

### Optimal Workflow (Parallel Investigation)

**Launch 3 agents simultaneously for fastest resolution:**

```
Task 1: analytics-engineer-role
→ Check dbt model health
→ Validate transformation data freshness
→ Verify fact tables

Task 2: data-engineer-role
→ Check source extraction timing
→ Verify Orchestra/ingestion pipeline
→ Compare LOADEDON vs dbt job schedule

Task 3: bi-developer-role
→ Pre-check: Verify data exists first!
→ IF data exists: Parse dashboard configuration
→ IF no data: STOP and wait for other agents
```

**Time Savings:** 60-90 minutes compared to sequential investigation

---

## Key Lessons Learned

### Do NOT Assume Dashboard Issues First

**This case proved:**
- ✅ Dashboard configuration was perfect (Yesterday filter appropriate)
- ✅ Live connection was working correctly
- ✅ Tableau was not the problem
- ❌ Real issue: Upstream data pipeline timing

**Best Practice:** Always check data availability BEFORE investigating dashboard configuration

### Distinguish Load Time vs Business Time

**Critical understanding:**
- **LOADEDON:** When we extracted the data (ELT timestamp)
- **Business date columns:** When events actually occurred
- **Gap analysis:** Is source system behind, or just our pipeline?

**This matters because:**
- Source can be "fresh" (LOADEDON = today) but still contain "old" business dates
- Or source can be "stale" (LOADEDON = yesterday) but that's expected timing

### Role Separation Works

**Clear ownership prevents wasted effort:**
- **analytics-engineer-role:** Owns transformation health
- **data-engineer-role:** Owns ingestion timing
- **bi-developer-role:** Only investigates IF data exists

**Result:** No time wasted on dashboard troubleshooting when it's a data issue

---

## Escalation Paths

### When to Involve Each Role

| Symptom | First Responder | Escalate To | Why |
|---------|----------------|-------------|-----|
| Dashboard blank | bi-developer-role | Check data first! | Could be data, not dashboard |
| Data missing from report | analytics-engineer-role | Trace to source | Transformation or ingestion? |
| Source data stale | data-engineer-role | Source system owner | Extraction working but source delayed |
| Timing mismatches | data-engineer-role | Platform team | Orchestra dependency config |

### Communication Templates

**From BI Developer to Analytics Engineer:**
> "Pre/Post Trip dashboard showing blank. Checked underlying table - no data for yesterday (2025-10-02). Most recent: 2025-10-01. Can you investigate transformation pipeline?"

**From Analytics Engineer to Data Engineer:**
> "Fact table stale (2025-10-01) but report expects yesterday. Checked source table - LOADEDON shows fresh (2025-10-03) but business dates only through 2025-10-01. Can you verify extraction captured yesterday's transactions?"

**From Data Engineer to Team:**
> "Source extraction ran this morning after dbt job completed. Fresh data now available (through 2025-10-03). Triggered manual dbt run to process. Dashboard will populate in ~40 minutes."

---

## Prevention Strategies

### Orchestra Workflow Dependencies

**Problem:** dbt job runs before source extraction completes

**Solution:** Configure proper dependencies
```yaml
pipelines:
  source_extraction:
    schedule: "0 3 * * *"
    outputs:
      - source_tables_ready

  dbt_transformation:
    dependencies:
      - source_extraction.source_tables_ready
    tasks:
      - dbt_build_models
```

### Data Freshness Monitoring

**Implement proactive alerts:**
```sql
-- Alert if data is >24 hours old
SELECT
  'rpt_table_name' as table_name,
  MAX(DATE(date_col)) as most_recent,
  DATEDIFF(hour, MAX(date_col), CURRENT_TIMESTAMP) as hours_stale
FROM report_table
HAVING hours_stale > 24;
```

### User Expectation Management

**Dashboard annotation:**
> "Data typically available by 8:00 AM daily. If viewing earlier, yesterday's data may not yet be processed."

---

## Success Metrics

**Investigation completed:** 2025-10-03
**Total investigation time:** ~2 hours (manual, sequential)
**Estimated with parallel agents:** 30 minutes
**Time to resolution:** 40 minutes after root cause identified
**User impact:** 1 morning without fresh data

**Knowledge captured:**
- ✅ 3 agent role files updated with troubleshooting patterns
- ✅ Confidence scores increased (+0.07, +0.05, +0.03)
- ✅ Reusable playbook created (this document)
- ✅ Real example for training

---

**Created:** 2025-10-03
**Based On:** Concrete Pre/Post Trip Dashboard Investigation
**Agents Involved:** analytics-engineer-role, data-engineer-role, bi-developer-role
**Outcome:** ✅ Root cause identified, resolution successful, knowledge preserved
