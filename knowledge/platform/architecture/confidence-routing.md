# 🎯 Confidence-Based Agent Routing

## Overview

The DA Agent Hub implements confidence-based routing to intelligently select the optimal agent combinations based on historical performance data. This system continuously learns from project completions to improve agent selection effectiveness.

## How Confidence Scoring Works

### Confidence Levels
- **0.95-1.00**: Expert level - Agent has consistently succeeded at this task type
- **0.80-0.94**: Proficient - Agent regularly succeeds with occasional learning opportunities
- **0.60-0.79**: Developing - Agent has mixed results, benefits from collaboration
- **0.40-0.59**: Basic - Agent struggles, needs support or alternative approach
- **0.00-0.39**: Limited - Agent lacks sufficient experience in this area

### Confidence Updates via `/complete` Command

When completing projects, confidence scores are updated based on:

#### Positive Adjustments (+0.03 to +0.15)
- **Successful first attempt** (+0.05): Agent completed task without retries
- **Novel pattern discovery** (+0.10): Agent identified new effective approaches
- **Complex problem solving** (+0.15): Agent handled high-complexity scenarios successfully
- **Cross-agent coordination** (+0.08): Agent collaborated effectively with others

#### Negative Adjustments (-0.03 to -0.10)
- **Required retry** (-0.03): Task needed multiple attempts
- **Knowledge gap identified** (-0.05): Agent lacked necessary domain knowledge
- **Performance degradation** (-0.10): Agent struggled with previously mastered tasks

#### Neutral (No Change)
- **Limited involvement**: Agent had minimal role in project
- **Standard execution**: Task completed as expected within normal parameters

## Routing Decision Framework

### Single Agent Selection
```
Task Type: "Optimize dbt model performance"
┌─────────────────────────────────────┐
│ Confidence Analysis:                │
│ • dbt-expert: 0.92 (high)          │
│ • snowflake-expert: 0.78 (medium)  │
│ • da-architect: 0.65 (developing)  │
└─────────────────────────────────────┘
Routing Decision: Primary → dbt-expert
```

### Multi-Agent Coordination
```
Task Type: "Cross-system data pipeline optimization"
┌─────────────────────────────────────┐
│ Optimal Sequence:                   │
│ 1. da-architect (0.85) - Design    │
│ 2. dbt-expert (0.92) - Transform   │
│ 3. snowflake-expert (0.88) - Store │
└─────────────────────────────────────┘
Routing Decision: Sequential coordination
```

### Parallel Execution Candidates
```
Task Type: "Performance analysis across stack"
┌─────────────────────────────────────┐
│ Parallel Candidates:                │
│ • dbt-expert (0.90) + snowflake-expert (0.88) │
│ • High confidence in both domains  │
│ • Proven coordination history      │
└─────────────────────────────────────┘
Routing Decision: Parallel execution
```

## Agent Selection Strategies

### Strategy 1: Confidence Threshold
- **High confidence (≥0.85)**: Direct assignment
- **Medium confidence (0.60-0.84)**: Paired with supporting agent
- **Low confidence (<0.60)**: Alternative agent or learning opportunity

### Strategy 2: Task Complexity Matching
- **Simple tasks**: Single agent with sufficient confidence
- **Medium tasks**: Primary agent with backup expertise
- **Complex tasks**: Multi-agent coordination with proven patterns

### Strategy 3: Learning Optimization
- **Established patterns**: Use highest confidence agents
- **Growth opportunities**: Pair developing agents with experts
- **Knowledge gaps**: Route to agents who need specific experience

## Implementation in `/complete` Command

### Confidence Tracking
```markdown
🎯 Confidence Updates:
   ↗️ dbt-expert: +0.10 (incremental model optimization)
   ↗️ snowflake-expert: +0.05 (query performance tuning)
   ↘️ tableau-expert: -0.03 (dashboard complexity underestimated)
```

### Routing Recommendations
```markdown
🤖 Routing Recommendations for Future Projects:
   • For incremental model work: Prefer dbt-expert (confidence: 0.92)
   • For query optimization: dbt-expert + snowflake-expert (high coordination success)
   • For dashboard complexity: tableau-expert + business-context (support pattern)
```

## Confidence Data Storage

### Agent File Structure
Each agent file (`.claude/agents/*.md`) should include:

```markdown
## Capability Confidence Levels

### Primary Expertise (≥0.85)
- SQL transformations: 0.92
- Model optimization: 0.88
- Testing strategies: 0.90

### Secondary Expertise (0.60-0.84)
- Schema design: 0.78
- Performance tuning: 0.82

### Developing Areas (<0.60)
- Advanced window functions: 0.55
- Complex macros: 0.48

Last updated: [timestamp from /complete]
```

## Benefits of Confidence Routing

### 1. Data-Driven Decisions
- Objective agent selection based on historical performance
- Reduces guesswork in complex multi-agent scenarios
- Identifies optimal collaboration patterns

### 2. Continuous Improvement
- Agents become more effective through targeted experience
- System learns from both successes and failures
- Knowledge gaps are systematically identified and addressed

### 3. Risk Management
- Low-confidence tasks get appropriate support
- High-stakes scenarios use proven agent combinations
- Learning opportunities are balanced with reliability needs

### 4. Efficiency Optimization
- Reduces trial-and-error in agent selection
- Minimizes retries through better initial routing
- Optimizes execution time through proven coordination patterns

## Future Enhancements

### Advanced Routing Patterns
- **Magnetic routing**: Agents with high affinity for specific problem types
- **Group chat scenarios**: Multi-agent collaborative problem solving
- **Dynamic re-routing**: Mid-task agent switching based on performance
- **Confidence-weighted voting**: Multiple agents with weighted input based on confidence

### Machine Learning Integration
- **Pattern recognition**: Identify optimal agent combinations automatically
- **Performance prediction**: Estimate success probability before task assignment
- **Adaptive learning**: Faster confidence updates based on task similarity

---

*Confidence-based routing enables the DA Agent Hub to become increasingly effective through systematic learning from project outcomes.*