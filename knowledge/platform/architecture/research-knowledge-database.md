# Research: Structured Knowledge Database for Claude Analytics Framework

**Date**: 2026-03-01
**Status**: Research complete - awaiting decision
**Problem**: Should we replace or augment the markdown-based knowledge system with a structured database (SQLite, DuckDB, or other)?

---

## Executive Summary

After deep research across the current codebase, industry patterns, and available tooling, the recommendation is:

**SQLite as a structured index layer alongside (not replacing) markdown files.**

Markdown stays the source of truth for human-readable, Git-versioned knowledge. SQLite adds structured querying for the specific data types that are painful to manage in prose: pattern registries, agent confidence scores, project history, decision logs, and entity relationships.

DuckDB is a strong contender but is overkill for the current scale (~30 knowledge files, ~16K lines). It becomes valuable if the dataset grows significantly or if analytical queries over the knowledge store become a primary use case.

---

## Current State Analysis

### What Exists Today

The framework is **100% file-based and markdown-centric**:

| Category | Size | Files | Format |
|----------|------|-------|--------|
| Knowledge base | 335 KB | 29 files | Markdown |
| .claude/ rules + skills + agents | ~250 KB | 50+ files | Markdown + JSON |
| Configuration | ~30 KB | 4 files | JSON |
| Scripts | ~85 KB | 13 files | Bash/Python |
| **Total** | **~700 KB** | **95+ files** | **Markdown + JSON** |

No database files exist anywhere in the repository. All state is tracked through:
- `context.md` files (per-project dynamic state)
- Git version history (audit trail)
- Pattern markers in findings files (`PATTERN:`, `SOLUTION:`, `ERROR-FIX:`)
- Agent definition files (confidence levels in prose)
- Monthly learning extraction via `finish.sh`

### What Works Well in Markdown

These should **stay as markdown** - the format is ideal and Claude Code auto-loads them:

1. **Agent definitions** (`.claude/agents/`) - Prose with domain expertise, delegation protocols, consultation patterns. Claude needs the full narrative context.
2. **Rules** (`.claude/rules/`) - Auto-loaded by Claude Code. Decision frameworks work best as readable prose with examples.
3. **Skills** (`.claude/skills/`) - Procedural workflows with step-by-step instructions. Templates and scripts naturally live alongside.
4. **Architecture docs** (`knowledge/platform/`) - Long-form documentation, runbooks, integration guides. Needs human review and Git history.
5. **Project specs and context** (`projects/active/`) - Ephemeral per-project state that gets archived. Simple structure works.
6. **CLAUDE.md** - Must be markdown by design. The navigation hub and core instructions.

### What's Painful in Markdown

These are the specific pain points where structured querying would help:

1. **Pattern Registry**: Patterns are marked with `PATTERN:`, `SOLUTION:`, `ERROR-FIX:` across dozens of files. Finding "all patterns related to Snowflake" requires grep across the entire repo. No metadata (when discovered, which project, confidence level, how often referenced).

2. **Agent Confidence Scores**: The `confidence-routing.md` doc describes a sophisticated confidence-based routing system (0.00-1.00 scores, positive/negative adjustments from `/complete`). But scores are stored as **prose** in individual agent files. There's no way to query "which agent has highest confidence for dbt optimization?" without reading every agent file.

3. **Project History**: When projects complete, they get archived but there's no queryable record of: duration, agents involved, tools used, patterns discovered, blockers encountered. The `finish.sh` script extracts patterns to monthly files, but project metadata is lost.

4. **Decision Log**: Decisions made during projects (technology choices, architecture decisions, trade-offs) are buried in `context.md` files that get archived. No way to query "what decisions did we make about pipeline orchestration?"

5. **Entity Ownership**: "Who owns the dbt_cloud repo?", "What systems does Snowflake depend on?", "What MCP tools does dbt-expert have access to?" - these relationships are scattered across config files, agent definitions, and prose documentation.

6. **Cross-Project Analytics**: "What's our average project duration?", "Which agent combination is most successful?", "What are the top 5 recurring blockers?" - currently impossible without manual analysis.

---

## Technology Comparison

### SQLite vs DuckDB vs Others

| Criteria | SQLite | DuckDB | ChromaDB/LanceDB |
|----------|--------|--------|-------------------|
| **Architecture** | Row-oriented (OLTP) | Column-oriented (OLAP) | Vector-oriented |
| **Best for** | Key-value lookups, frequent small writes, simple queries | Analytical aggregations, joins over large datasets | Semantic similarity search |
| **Performance** | Fast point lookups, slower aggregations | 10-100x faster aggregations, slower point writes | Fast similarity search, no SQL |
| **File format** | Single `.db` file | Single `.duckdb` file | Directory of files |
| **Maturity** | 25+ years, battle-tested | ~5 years, rapidly maturing | 2-3 years, still evolving |
| **Git-friendly** | Binary file (needs LFS or gitignore) | Binary file (same) | Not practical in Git |
| **MCP servers** | Official (archived but functional) + community options | MotherDuck official + 3 community servers + native DuckDB extension | Limited/custom |
| **Full-text search** | FTS5 built-in | Basic LIKE/regex | Not applicable |
| **Vector search** | Via sqlite-vec extension | Via VSS extension (experimental) | Native |
| **Python support** | Built into stdlib | pip install duckdb | pip install chromadb/lancedb |
| **Team sharing** | Git (binary diffs) or shared filesystem | Same as SQLite | Requires service layer |

### Recommendation: SQLite

**Why SQLite over DuckDB for this framework:**

1. **Scale doesn't justify DuckDB**: With ~100 knowledge files and projected hundreds (not millions) of patterns/decisions, SQLite handles this trivially. DuckDB's columnar advantage kicks in at larger scales.

2. **Access patterns are mixed**: The knowledge database needs both key-value lookups ("get agent X's confidence for capability Y") and light analytics ("top patterns by category"). SQLite handles both adequately at this scale.

3. **Zero dependencies**: SQLite is in Python's standard library. DuckDB requires `pip install duckdb`.

4. **Ecosystem maturity**: SQLite FTS5 for keyword search and sqlite-vec for (optional) semantic search are well-proven. DuckDB's VSS extension is still experimental.

5. **Simpler team integration**: A SQLite file can be reconstructed from markdown source files at any time. It's an index, not the source of truth.

**When to reconsider DuckDB:**
- If the pattern registry grows to 10,000+ entries
- If complex analytical queries become a primary use case
- If you need to query across external data sources (Parquet, CSV, S3)
- DuckDB can always be layered on top of SQLite later - it can read SQLite files directly

### Why Not a Vector Database?

Vector databases (ChromaDB, LanceDB) add semantic search - finding content by meaning rather than exact keywords. For this framework:

- **Not needed yet**: The knowledge base is ~335 KB of well-structured markdown. Grep and FTS5 keyword search will find what you need.
- **Adds complexity**: Requires an embedding model, embedding pipeline, and index management.
- **Future option**: If the knowledge base grows significantly or if semantic search ("find patterns similar to this problem description") becomes valuable, `sqlite-vec` or LanceDB can be added later without changing the core architecture.

---

## What Goes in the Database

### Database Tables (Recommended)

```sql
-- Things Claude needs to remember between chats and projects

-- 1. Pattern Registry
-- Currently: PATTERN:/SOLUTION:/ERROR-FIX: markers scattered across files
-- Benefit: Queryable by domain, type, confidence, source project
CREATE TABLE patterns (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,          -- 'pattern', 'solution', 'error-fix', 'architecture', 'integration'
    name TEXT NOT NULL,          -- Short descriptive name
    description TEXT NOT NULL,   -- Full pattern description
    domains TEXT,                -- JSON array: ['dbt', 'snowflake', 'prefect']
    source_project TEXT,         -- Project that discovered this
    source_file TEXT,            -- File path where originally documented
    confidence REAL DEFAULT 0.5, -- 0.0-1.0, updated by /complete
    times_referenced INTEGER DEFAULT 0,
    discovered_date TEXT,
    last_validated TEXT,
    tags TEXT                    -- JSON array for flexible categorization
);

-- 2. Agent Capabilities & Confidence
-- Currently: Prose in each agent .md file
-- Benefit: Enables the confidence-based routing system described in confidence-routing.md
CREATE TABLE agent_capabilities (
    id INTEGER PRIMARY KEY,
    agent_id TEXT NOT NULL,      -- 'dbt-expert', 'analytics-engineer-role', etc.
    capability TEXT NOT NULL,    -- 'sql-transformations', 'incremental-models', etc.
    confidence REAL NOT NULL,    -- 0.00-1.00
    tier TEXT,                   -- 'primary', 'secondary', 'developing'
    last_updated TEXT,
    update_source TEXT,          -- Which /complete run updated this
    notes TEXT
);

-- 3. Project History
-- Currently: Lost after archive (finish.sh moves to completed/)
-- Benefit: Track what worked, what didn't, project velocity
CREATE TABLE projects (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    github_issue INTEGER,
    branch TEXT,
    status TEXT DEFAULT 'active', -- 'active', 'paused', 'completed', 'abandoned'
    started_date TEXT,
    completed_date TEXT,
    duration_days INTEGER,
    agents_used TEXT,            -- JSON array
    tools_used TEXT,             -- JSON array
    patterns_discovered TEXT,    -- JSON array of pattern IDs
    blockers_encountered TEXT,   -- JSON array
    outcome TEXT,                -- Brief description of result
    notes TEXT
);

-- 4. Decision Log
-- Currently: Buried in context.md files that get archived
-- Benefit: Query "what did we decide about X?" across all projects
CREATE TABLE decisions (
    id INTEGER PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    date TEXT NOT NULL,
    topic TEXT NOT NULL,         -- What the decision was about
    decision TEXT NOT NULL,      -- What was decided
    rationale TEXT,              -- Why
    alternatives_considered TEXT, -- JSON array of rejected options
    outcome TEXT,                -- How it turned out (updated later)
    tags TEXT                    -- JSON array: ['architecture', 'tooling', 'process']
);

-- 5. Entity Ownership Map
-- Currently: Scattered across config, agent files, and prose
-- Benefit: "Who owns what?", "What depends on what?"
CREATE TABLE entities (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,          -- 'dbt_cloud', 'snowflake_warehouse', 'customer_dashboard'
    type TEXT NOT NULL,          -- 'repository', 'service', 'dashboard', 'pipeline', 'database'
    owner TEXT,                  -- Team/person responsible
    description TEXT,
    status TEXT DEFAULT 'active',
    metadata TEXT                -- JSON for flexible attributes
);

CREATE TABLE entity_relationships (
    id INTEGER PRIMARY KEY,
    source_entity_id INTEGER REFERENCES entities(id),
    target_entity_id INTEGER REFERENCES entities(id),
    relationship_type TEXT NOT NULL, -- 'depends_on', 'feeds_into', 'owned_by', 'deployed_to'
    description TEXT
);

-- 6. Session Tracking (Optional - for analytics)
-- Currently: Not tracked at all
-- Benefit: Understand usage patterns, improve agent effectiveness
CREATE TABLE sessions (
    id INTEGER PRIMARY KEY,
    date TEXT NOT NULL,
    project_id INTEGER REFERENCES projects(id),
    commands_used TEXT,          -- JSON array: ['/start', '/research', '/complete']
    agents_invoked TEXT,         -- JSON array
    duration_minutes INTEGER,
    blockers TEXT,               -- JSON array
    notes TEXT
);
```

### What Does NOT Go in the Database

| Content | Why It Stays in Markdown |
|---------|------------------------|
| Agent definitions (`.claude/agents/`) | Claude Code auto-loads these. Prose context is essential for agent behavior. |
| Rules (`.claude/rules/`) | Auto-loaded by Claude Code. Decision frameworks need narrative explanation. |
| Skills (`.claude/skills/`) | Procedural workflows with templates. Markdown is the natural format. |
| Architecture docs (`knowledge/platform/`) | Long-form reference documentation. Needs human review and Git diffs. |
| CLAUDE.md | Must be markdown. The entry point for Claude Code. |
| Project specs and context | Ephemeral per-project files. Simple structure works. |
| MCP server documentation | Reference docs that agents read wholesale. |
| Troubleshooting guides | Step-by-step prose with examples. |

### The Key Principle

> **The database is an index over your markdown files, not a replacement for them.**

Markdown stays the source of truth for everything Claude needs to read as prose. The database tracks the **structured metadata** that's awkward to query across files: scores, dates, relationships, categories, metrics.

---

## What Claude Needs to Remember Between Chats

This is the core question. Analyzing the framework's workflows, here's what gets lost between sessions:

### Currently Remembered (via markdown/Git)
- Agent definitions and capabilities (prose)
- Rules and patterns (auto-loaded)
- Project specs and context (if project exists)
- MCP server configurations
- Tech stack configuration

### Currently Lost Between Sessions
1. **Which patterns solved similar problems before** - grep works but requires knowing what to search for
2. **Agent performance on previous tasks** - confidence scores described but not tracked
3. **Decisions made and their outcomes** - buried in archived project context files
4. **Cross-project relationships** - "this project built on patterns from that project"
5. **What failed and why** - blockers and error-fixes not indexed
6. **System/entity ownership** - who owns what, what depends on what
7. **Session continuity** - /pause helps but requires manual saving

### What a Team Needs in a Shared Repo
For a team repo (vs individual), the database should focus on:

1. **Shared patterns** - "The team discovered this pattern, it has 0.85 confidence" - not one person's notes, but validated team knowledge
2. **Decision history** - "We chose Prefect over Airflow because X" - institutional memory that survives team member changes
3. **Entity map** - "dbt_cloud depends on Snowflake, owned by analytics team" - system topology
4. **Agent tuning** - Confidence scores that reflect the TEAM's experience, not one person's
5. **Project outcomes** - What worked, what didn't, across all team projects

What should NOT be team-shared:
- Individual session logs (too noisy, privacy concerns)
- Personal preferences (goes in user-level CLAUDE.md)
- In-progress work state (goes in project context.md)

---

## Implementation Architecture

### Recommended Setup

```
knowledge/
├── platform/              # (existing) Prose documentation - SOURCE OF TRUTH
│   ├── architecture/
│   ├── development/
│   ├── operations/
│   └── ...
└── knowledge.db           # (new) SQLite structured index

.claude/
├── rules/                 # (existing) Auto-loaded rules
├── agents/                # (existing) Agent definitions
├── skills/                # (existing) Skills
└── ...

.mcp.json                  # (updated) Add SQLite MCP server
```

### MCP Integration

Add the SQLite MCP server to allow Claude to query the knowledge database:

```json
{
  "mcpServers": {
    "knowledge-db": {
      "command": "uvx",
      "args": [
        "mcp-server-sqlite",
        "--db-path", "./knowledge/knowledge.db"
      ]
    }
  }
}
```

This gives Claude tools to:
- `read_query` - SELECT queries against the knowledge database
- `write_query` - INSERT/UPDATE for pattern tracking, confidence updates
- `list_tables` / `describe_table` - Schema discovery
- `append_insight` - Add findings to a memo resource

### Data Flow

```
/start [project]
  └─ INSERT INTO projects (name, github_issue, started_date, ...)

During work:
  └─ INSERT INTO decisions (topic, decision, rationale, ...)
  └─ SELECT FROM patterns WHERE domains LIKE '%dbt%'  -- find relevant patterns
  └─ SELECT FROM agent_capabilities WHERE capability = 'incremental-models'  -- pick right agent

/complete [project]
  └─ UPDATE projects SET status='completed', completed_date=..., outcome=...
  └─ INSERT INTO patterns (from PATTERN:/SOLUTION:/ERROR-FIX: markers)
  └─ UPDATE agent_capabilities SET confidence=... (based on project performance)
  └─ Markdown files updated as before (the source of truth)
```

### Git Strategy for the Database

The `.db` file is binary, so Git can't diff it meaningfully. Two options:

**Option A: Gitignore the database, rebuild from markdown** (Recommended)
- Add `knowledge/knowledge.db` to `.gitignore`
- Create `scripts/rebuild-knowledge-db.sh` that scans markdown files, extracts pattern markers, reads config files, and populates the database
- Each team member rebuilds locally
- Shared structured data (patterns, decisions) lives in a dedicated markdown file that the script parses
- Pro: Git stays clean, no binary conflicts
- Con: Requires rebuild step; "shared" data requires a markdown intermediary

**Option B: Commit the database**
- Track `knowledge/knowledge.db` in Git
- Use Git LFS if it grows large
- Pro: Shared database, no rebuild needed
- Con: Binary merge conflicts, larger repo

**Option C: Hybrid - commit a seed SQL file**
- Maintain `knowledge/knowledge-seed.sql` (human-readable, diffable)
- Script builds the `.db` from the seed file + markdown extraction
- Team shares the seed file via Git
- Pro: Human-readable diffs, shared data, reconstructable
- Con: Must keep seed file in sync

**Recommendation**: Start with **Option A** (gitignore + rebuild script). The database is an index that can always be reconstructed from the markdown source of truth. If team sharing of structured data (decisions, entity maps) becomes important, migrate to **Option C** with a seed SQL file.

---

## Comparison with Alternative Approaches

### Alternative 1: DuckDB Instead of SQLite

**Pros**: Faster analytics, native Parquet/CSV/JSON querying, can query SQLite files directly, built-in statistical functions, vectorized execution.

**Cons**: External dependency (`pip install duckdb`), overkill at current scale, less mature MCP ecosystem, larger binary size.

**Verdict**: Start with SQLite, add DuckDB as an analytics overlay later if needed. DuckDB can read SQLite files directly, so this migration path is smooth.

### Alternative 2: Knowledge Graph (Cognee, Zep/Graphiti)

**Pros**: Entity relationship traversal, temporal reasoning, semantic connections, hybrid retrieval (vector + graph + SQL).

**Cons**: Significant complexity (embedding pipeline, graph engine, extraction pipeline), requires LLM calls for entity extraction, overkill for current scale, harder to debug, multiple moving parts.

**Verdict**: The entity_relationships table in SQLite gives 80% of the value with 10% of the complexity. Revisit if relationship traversal becomes a primary use case.

### Alternative 3: Vector Database (ChromaDB/LanceDB)

**Pros**: Semantic search ("find patterns similar to this problem"), works across unstructured text, better recall for vague queries.

**Cons**: Requires embedding model + pipeline, storage overhead for embeddings, another dependency to manage, current knowledge base is small enough for keyword search.

**Verdict**: Not needed now. If semantic search becomes valuable, add `sqlite-vec` extension to the existing SQLite database rather than introducing a separate vector DB. Or add LanceDB alongside SQLite.

### Alternative 4: claude-mem or MemCP Plugin

**Pros**: Pre-built session memory capture, automatic context injection, vector search included.

**Cons**: Focused on session continuity (ephemeral), not team-shared structured knowledge. Solves a different problem (individual memory vs team knowledge base).

**Verdict**: Complementary, not competitive. claude-mem handles per-user session memory; the knowledge database handles team-shared structured knowledge.

---

## Existing MCP Servers (Ready to Use)

### SQLite MCP Servers

| Server | Source | Notes |
|--------|--------|-------|
| `mcp-server-sqlite` (official) | [PyPI](https://pypi.org/project/mcp-server-sqlite/) | Archived but functional. 6 tools: read_query, write_query, create_table, list_tables, describe_table, append_insight |
| `@berthojoris/mcp-sqlite-server` | npm | TypeScript, 28 tools, granular permissions |
| `sqlite-explorer-fastmcp` | [GitHub](https://github.com/hannesrudolph/sqlite-explorer-fastmcp-mcp-server) | Read-only, query validation, safety features |
| Claude Memory MCP | Community | Knowledge graph on SQLite, entity/relation management |

### DuckDB MCP Servers (If You Choose DuckDB Later)

| Server | Source | Notes |
|--------|--------|-------|
| `mcp-server-motherduck` | [GitHub](https://github.com/motherduckdb/mcp-server-motherduck) | Official. Local + cloud. Read-only default. `claude mcp add` ready |
| `mcp-server-duckdb` | [PyPI](https://pypi.org/project/mcp-server-duckdb/) | Simple. Single query tool. Readonly mode |
| `duckdb_mcp` extension | [DuckDB Extensions](https://duckdb.org/community_extensions/extensions/duckdb_mcp) | Native extension. Bidirectional (server + client) |
| DuckDB Knowledge Graph Memory | [LobeHub](https://lobehub.com/mcp/izumisy-mcp-duckdb-memory-server) | Knowledge graph backed by DuckDB + Fuse.js fuzzy search |

---

## Implementation Phases

### Phase 1: Foundation (Low Effort, High Signal)
1. Create the SQLite schema (tables above)
2. Write `scripts/init-knowledge-db.sh` to create the database
3. Write `scripts/rebuild-knowledge-db.sh` to populate from markdown files
4. Add `knowledge/knowledge.db` to `.gitignore`
5. Add SQLite MCP server to `.mcp.json`
6. Test: Claude can query "list all patterns" and get structured results

### Phase 2: Workflow Integration
1. Update `/complete` command to write patterns to database + markdown
2. Update `/start` command to INSERT project record
3. Add confidence score tracking (agent_capabilities table)
4. Create `scripts/query-knowledge.sh` helper for CLI access
5. Document the hybrid workflow for team

### Phase 3: Team Knowledge
1. Create `knowledge/knowledge-seed.sql` for team-shared data
2. Script to merge seed data with locally-extracted data
3. Add entity ownership map (populate from config/repositories.json)
4. Decision log integration into project workflow
5. Training: team uses the database for pattern discovery

### Phase 4: Analytics & Insights (Optional)
1. Add DuckDB as analytics overlay (if warranted by scale)
2. Session tracking integration
3. Agent performance dashboards
4. Pattern effectiveness metrics
5. Project velocity tracking

---

## Key Principles

1. **Markdown is the source of truth** - The database is always reconstructable from files
2. **Database is for querying, not authoring** - Write patterns in markdown, index them in the database
3. **Start simple** - SQLite with basic tables. Add complexity only when pain justifies it
4. **Zero infrastructure** - Single file database, no servers, no cloud dependencies
5. **Team-first design** - Structure data that helps the whole team, not just one person
6. **Claude-native integration** - Use MCP server so Claude can read/write the database naturally

---

## Sources

- [DuckDB vs SQLite Comparison (Analytics Vidhya)](https://www.analyticsvidhya.com/blog/2026/01/duckdb-vs-sqlite/)
- [Structured Memory Management with DuckDB (MotherDuck)](https://motherduck.com/blog/streamlining-ai-agents-duckdb-rag-solutions/)
- [MCP + DuckDB: Connect AI Assistants to Data Pipelines (MotherDuck)](https://motherduck.com/blog/faster-data-pipelines-with-mcp-duckdb-ai/)
- [SQLite MCP Server (PyPI)](https://pypi.org/project/mcp-server-sqlite/)
- [DuckDB MCP Community Extension](https://duckdb.org/community_extensions/extensions/duckdb_mcp)
- [The Complete Guide to AI Agent Memory Files (Medium)](https://medium.com/data-science-collective/the-complete-guide-to-ai-agent-memory-files-claude-md-agents-md-and-beyond-49ea0df5c5a9)
- [AI Agent Memory Management - When Markdown Files Are All You Need (DEV)](https://dev.to/imaginex/ai-agent-memory-management-when-markdown-files-are-all-you-need-5ekk)
- [Memori: SQL-Native Memory Engine for AI Agents (GitHub)](https://github.com/MemoriLabs/Memori)
- [Cognee: Open-Source Knowledge Engine (GitHub)](https://github.com/topoteretes/cognee)
- [Claude-Mem Plugin (GitHub)](https://github.com/thedotmack/claude-mem)
- [Basic Memory MCP (GitHub)](https://github.com/basicmachines-co/basic-memory)
- [Building an Agentic Memory System for GitHub Copilot (GitHub Blog)](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/)
- [Hybrid FTS + Vector Search with SQLite (Alex Garcia)](https://alexgarcia.xyz/blog/2024/sqlite-vec-hybrid-search/index.html)
- [Local-First RAG: SQLite for AI Agent Memory (PingCAP)](https://www.pingcap.com/blog/local-first-rag-using-sqlite-ai-agent-memory-openclaw/)
- [DuckDB Tutorial: Building AI Projects (DataCamp)](https://www.datacamp.com/tutorial/building-ai-projects-with-duckdb)
- [Open-Source SQL-Native Memory Engine for AI Agents](https://aiengineering.beehiiv.com/p/open-source-sql-native-memory-engine-for-ai-agents)
- [Connect SQLite to Claude Code (MintMCP)](https://www.mintmcp.com/sqlite/claude-code)
