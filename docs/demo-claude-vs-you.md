# Tired Dad vs. Claude -- Live Demo

This demo was part of a data@AMA presentation called "What if Claude was one of us?" where I raced Claude through three real-world tasks against our production dbt project at Graniterock.

**Starting model:** `dm_master__tickets` -- our main sales data mart. A ticket is the receipt a trucker gets when they pull off with 25 tons of rock.

**The contestants:**

| Claude | The tired dad |
|---|---|
| Analytics Engineer agent | Brain fueled by caffeine |
| dbt specialist agent | ChatGPT |
| dbt skills (from dbt Labs) | dbt Catalog |
| dbt MCP (connected to our dbt Cloud) | dbt Studio |

---

## Round 1 -- "Why is this field blank for every recent sale?"

**The scenario:** Someone runs a query, sees `ticket_export_status` is blank for every ticket since January 2025, and asks you: is this a bug?

**What I did:** Went to dbt Catalog, searched up `dm_master__tickets`, looked at the lineage (all green, so no pipeline failures), opened the code, and realized -- right, this model unions two source systems. We switched from Pearl to Apex about four years ago. The export status field exists in Pearl (historic data) but gets hard-coded as null for Apex (recent data). Not a bug. Don't worry about it.

**What Claude did:** Same thing, programmatically. Used the dbt MCP to look up the model, read the SQL, and immediately said: "The field is hard-coded null for the Apex source. Not a data issue, not a pipeline issue." Same answer, faster.

**Claude's prompt:**
```
I'm querying dm_master__tickets and ticket_export_status is blank for every ticket
after January 2025. Is this a data pipeline issue? Trace where the column comes
from and explain why it's empty.
```

**Winner:** Claude (but I could've been faster if I wasn't talking through it for the audience).

---

## Round 2 -- "Add a field"

**The scenario:** "Hey, could you add `ticket_net_tons` to `dm_master__tickets`? It's just ticket_net divided by 2000, but we should keep this logic in the model."

**What I did:** Opened dbt Studio, created a branch, added `ticket_net / 2000 as ticket_net_tons` to the Apex side of the union. Hit run. Got "invalid number of columns" -- right, because the union needs matching columns on both sides. Added a null placeholder to the Pearl side. Ran again. Worked. Committed, opened a PR.

**What Claude did:** Used the dbt MCP to find the model, read the SQL, added the field to both sides of the union (caught the union issue on its own), and opened a PR with a nicely written summary.

**The catch:** Claude changed the text file but never ran `dbt parse` or `dbt compile`. It skipped the validation step entirely. One of the audience members (Brandon) caught this -- great question. The code was correct, but Claude didn't verify it would actually compile. That's a real gap. You could tell it "before you PR, make sure you run these steps," and that's one of those loops to refine.

**Claude's prompt:**
```
I want to add a ticket_net_tons column to dm_master__tickets. It should be
ticket_net divided by 2000 (US tons). Before making the change, check whether
both data sources in the model actually have weight data, verify the source
column exists in the parent models, and handle nulls correctly. Then make
the change. Use dbt MCP and open a PR with your change.
```

**Winner:** Claude on speed, but with an asterisk for skipping validation.

---

## Round 3 -- "Build the semantic layer"

**The scenario:** Your CEO says, "Hey, I read on X about how we need a semantic layer for AI. Let's make one for our tickets so our sales team can use it." Super easy, right? Why not make that before lunch? Because that's all our jobs -- just really easy. The classic "quick question."

**What I did:** Went to ChatGPT, asked it to help me build a semantic model. Went to dbt Catalog to screenshot the model's columns for context. Got some semi-coherent YAML back. Then realized I didn't know where metrics files live in our project structure, and I'd need to set up a date/time spine that we don't have yet. This is the kind of task where the manual approach gets slow fast -- right YAML structure, right file placement, right configuration for MetricFlow.

**What Claude did:** It was also thinking harder on this one -- even tried looking up what a time spine is (again, just woke up in the Severance conference room). But with the dbt MCP and skills giving it access to our actual project structure and dbt's documentation on semantic layers, it had a much better starting point for scaffolding the full YAML.

**The honest take:** YAML is probably my favorite thing about LLMs in general. I have not hand-written YAML since I started using Claude. That used to be the bane of my existence -- one wrong tab and the whole file breaks. That's not valuable work. This round showed the biggest leverage: Claude handles the tedious YAML scaffolding while I focus on whether the metrics and dimensions actually make sense for the business.

**Claude's prompt:**
```
We don't have a semantic layer yet. Using dm_master__tickets as the foundation,
build a complete dbt semantic model -- entities, dimensions, measures, and at
least 5 metrics covering revenue, volume, tonnage, discounts, and ticket count.
Make it queryable by customer segment, product segment, branch, and date.
Output ready-to-deploy YAML. Use dbt MCP and set up a date time spine as needed.
```

**Winner:** Claude, with the caveat that both of us would need more iteration to get it production-ready.

---

## The Takeaway

Claude did the exact same things I did, just programmatically and faster. But it also skipped steps (no `dbt parse` in Round 2) and doesn't inherently know if the output is *right* -- it just knows what text is most likely to be correct.

The proper place for this tool is as a pair programmer: augmenting you, not replacing you. Less code writing, more clear requirements and validating. You still need to know what "right" looks like.

As I said in the presentation: it started as "What if Claude was one of us?" and became "What if Claude was one *with* us?"
