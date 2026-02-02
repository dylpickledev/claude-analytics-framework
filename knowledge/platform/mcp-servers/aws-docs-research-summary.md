# AWS Documentation MCP Server Research Summary

**Research Date**: 2025-10-08
**Researcher**: Claude (sonnet-4-5)
**MCP Server**: awslabs.aws-documentation-mcp-server
**Version**: Latest (@latest)

## Executive Summary

The AWS Documentation MCP Server (`awslabs.aws-documentation-mcp-server`) is a Python-based MCP server that provides AI agents with programmatic access to AWS documentation. It exposes **three primary tools** for global AWS regions and **one additional tool** for AWS China regions.

This MCP server bridges the critical gap between AI training data (which has cutoffs) and current AWS documentation, ensuring recommendations are based on the latest AWS capabilities, best practices, and service limits.

## Key Findings

### Available Tools (Global AWS Regions)

1. **`read_documentation`** - Fetch and convert AWS docs to markdown
   - Primary use: Read specific documentation pages when you have URL
   - Supports chunked reading for long documents
   - Returns markdown-formatted content

2. **`search_documentation`** - Search all AWS documentation
   - Primary use: Find documentation when you don't have URL
   - Uses official AWS Documentation Search API
   - Returns ranked results with URLs and excerpts

3. **`recommend`** - Get related content recommendations
   - Primary use: Discover related topics and new features
   - Returns 4 categories: Highly Rated, New, Similar, Journey
   - Great for finding recently released AWS features

### Available Tools (AWS China Regions Only)

4. **`get_available_services`** - List AWS services available in China
   - Only works with `AWS_DOCUMENTATION_PARTITION=aws-cn`
   - Returns list of services available in China regions

### Current Configuration Status

**In .mcp.json**:
```json
"aws-docs": {
  "command": "uvx",
  "args": ["awslabs.aws-documentation-mcp-server@latest"],
  "env": {
    "FASTMCP_LOG_LEVEL": "ERROR",
    "AWS_DOCUMENTATION_PARTITION": "aws"
  },
  "disabled": false,
  "autoApprove": []
}
```

**Status**: ✅ Configured and enabled
**Partition**: Global AWS (`aws`)
**Available Tools**: read_documentation, search_documentation, recommend

## Critical Insights for aws-expert Agent

### 1. Correctness Through Currency

**Problem**: AI training data has cutoffs (January 2025 for current model)
**Solution**: aws-docs MCP always accesses current AWS documentation

**Impact**: Recommendations based on current AWS capabilities, not outdated knowledge

**Use Cases Where This Matters**:
- Service limits/quotas (change frequently)
- New AWS features (released after training cutoff)
- Best practices (evolve over time)
- Security recommendations (critical to have latest)
- API parameters (exact syntax must be current)

### 2. No AWS Credentials Required

**Key Advantage**: Unlike aws-api MCP, aws-docs requires NO credentials
**Why**: Only reads public AWS documentation
**Benefit**: Can be used freely without AWS account access concerns

### 3. Research-Only Pattern for Specialist Agents

**aws-expert Cannot Execute MCP Tools Directly**:
- Specialist agents are research-only
- aws-expert **recommends** MCP tool executions
- Main Claude **executes** the tools
- aws-expert **analyzes** results after main Claude returns them

**Pattern**:
```
User Question → aws-expert recommends MCP strategy → Main Claude executes → aws-expert analyzes results → Recommendation
```

## Documentation Deliverables

Created three comprehensive documents:

### 1. Technical Reference (Complete Tool Documentation)
**Location**: `knowledge/mcp-servers/aws-docs-mcp-server-reference.md`

**Contents**:
- Complete tool inventory with signatures
- All parameters and return types
- Configuration options and environment variables
- Error scenarios and troubleshooting
- Example workflows and use cases
- Rate limits and constraints
- Comparison with other AWS MCP servers

**Audience**: Deep technical reference for any agent working with aws-docs MCP

### 2. Integration Guide (aws-expert Agent Focus)
**Location**: `knowledge/mcp-servers/aws-docs-mcp-integration-guide.md`

**Contents**:
- Quick reference for three core tools
- Integration patterns for aws-expert
- Decision trees for tool selection
- When to use MCP vs training knowledge
- Common MCP recommendation patterns
- Quality standards for MCP recommendations
- Complete interaction examples

**Audience**: aws-expert specialist agent (for integration into agent definition)

### 3. Research Summary (This Document)
**Location**: `knowledge/mcp-servers/aws-docs-research-summary.md`

**Contents**:
- Executive summary of findings
- Key insights and recommendations
- Documentation deliverables overview
- Next steps for integration

**Audience**: Project stakeholders and future reference

## Research Sources

### Primary Sources

1. **GitHub Repository**
   - URL: https://github.com/awslabs/mcp
   - File: `/src/aws-documentation-mcp-server/README.md`
   - Status: Authoritative source

2. **Official Documentation**
   - URL: https://awslabs.github.io/mcp/servers/aws-documentation-mcp-server
   - Status: Complete documentation

3. **PyPI Package**
   - URL: https://pypi.org/project/awslabs.aws-documentation-mcp-server/
   - Status: Package information and installation

### Verification Methods

1. **Web Search**: Multiple queries to find all documentation sources
2. **Web Fetch**: Direct reading of GitHub README and official docs
3. **MCP Configuration Review**: Verified current .mcp.json configuration
4. **Tool Signature Analysis**: Examined available function definitions

### Research Confidence: HIGH

All information verified across multiple authoritative sources:
- ✅ Official GitHub repository (awslabs/mcp)
- ✅ Official documentation site (awslabs.github.io/mcp)
- ✅ PyPI package listing
- ✅ Current .mcp.json configuration
- ✅ Available tool signatures in Claude session

## Recommendations for aws-expert Agent Integration

### 1. Update aws-expert.md with MCP Integration Section

**Add Section**: "AWS Documentation MCP Integration"

**Content to Include**:
- Link to integration guide: `knowledge/mcp-servers/aws-docs-mcp-integration-guide.md`
- Quick reference for three tools
- Decision tree for when to use aws-docs MCP
- Standard recommendation patterns

**Benefit**: aws-expert has clear guidance on when and how to recommend aws-docs MCP usage

### 2. Add Pattern Index Entry

**Pattern**: "Verify AWS Best Practices with aws-docs MCP"
**Confidence**: HIGH (0.85)
**When to Use**: Before making architecture or configuration recommendations
**Reference**: `knowledge/mcp-servers/aws-docs-mcp-integration-guide.md`

### 3. Create "Known MCP Tools" Section

**In aws-expert.md**, add:

```markdown
## Known MCP Tools

### aws-docs (Documentation Access)
**Purpose**: Access current AWS documentation
**Tools**: read_documentation, search_documentation, recommend
**Reference**: knowledge/mcp-servers/aws-docs-mcp-integration-guide.md
**When to Use**: Verify current AWS capabilities before recommending

### aws-api (AWS API Execution)
**Purpose**: Execute AWS API calls to inspect/manage resources
**Tools**: call_aws, suggest_aws_commands
**Reference**: [To be documented]
**When to Use**: Inspect current AWS resource state
```

### 4. Enhance Quality Standards

**Add to aws-expert.md quality standards**:

```markdown
## Recommendation Quality Standards

### Source Attribution
Every recommendation MUST include:

**Recommendation Based On**:
- [X] Current AWS Documentation (via aws-docs MCP)
- [ ] Training Knowledge (cutoff: January 2025)
- [ ] Combination of both

**Verification Status**:
- [X] Verified with current AWS docs
- [ ] Based on training knowledge - recommend verification

### When to Verify with aws-docs MCP
ALWAYS verify when:
- Service limits/quotas involved
- New features (released after Jan 2025)
- Security/compliance recommendations
- Exact API parameters needed
- Architecture best practices cited
```

## Next Steps

### Immediate (This Session)
1. ✅ Complete research on aws-docs MCP capabilities
2. ✅ Create technical reference documentation
3. ✅ Create integration guide for aws-expert
4. ✅ Create research summary (this document)
5. ⏳ Update .claude/agents/specialists/aws-expert.md with MCP integration

### Follow-Up (Future Sessions)
1. Research aws-api MCP capabilities (similar depth)
2. Document integration patterns for aws-docs + aws-api coordination
3. Create example workflows for common aws-expert tasks
4. Test MCP integration patterns in real scenarios
5. Extract learnings to pattern library

### Validation (Future Testing)
1. Test aws-expert with real user questions requiring aws-docs MCP
2. Measure recommendation quality (with vs without MCP verification)
3. Identify gaps in documentation or patterns
4. Refine based on actual usage

## Impact Assessment

### Before This Research
- aws-expert had access to aws-docs MCP but no documentation
- No clear guidance on when/how to use aws-docs tools
- No integration patterns for MCP recommendations
- Risk of outdated recommendations based solely on training data

### After This Research
- ✅ Complete technical reference for aws-docs MCP
- ✅ Clear integration guide for aws-expert agent
- ✅ Decision frameworks for tool selection
- ✅ Recommendation patterns and quality standards
- ✅ Source attribution standards
- ✅ Foundation for future aws-api MCP integration

### Expected Benefits
1. **Higher Accuracy**: Recommendations based on current AWS docs
2. **Better Attribution**: Clear sources for recommendations
3. **Reduced Hallucination**: Verify instead of assume
4. **Faster Iteration**: Clear patterns reduce research time
5. **Knowledge Preservation**: Documented patterns reusable

## Limitations and Gaps

### Current Limitations

1. **Search Quality**: Depends on AWS's search index quality
   - May return irrelevant results for broad queries
   - No advanced search operators documented

2. **Rate Limits**: Not explicitly documented
   - Unknown if rate limits exist
   - No guidance on throttling/backoff

3. **China vs Global**: Tool availability differs by partition
   - search_documentation and recommend: Global only
   - get_available_services: China only
   - Can't query both partitions simultaneously

### Documentation Gaps

1. **aws-api MCP**: Not yet researched at same depth
2. **Cross-MCP Patterns**: aws-docs + aws-api coordination not documented
3. **Real-World Examples**: Need validation through actual usage
4. **Performance**: No data on response times, document sizes

### Future Research Needed

1. **aws-api MCP Server**: Complete similar research
2. **aws-knowledge MCP**: If/when AWS releases knowledge base MCP
3. **Performance Benchmarks**: Test response times, optimal chunk sizes
4. **Error Handling**: Document all error scenarios and resolutions

## Conclusion

The aws-docs MCP server provides aws-expert with a critical capability: **access to current AWS documentation**. This bridges the gap between training data cutoffs and current AWS reality.

**Three powerful tools**:
1. `read_documentation` - Read specific docs (have URL)
2. `search_documentation` - Find docs (don't have URL)
3. `recommend` - Discover related topics (explore)

**Key insight**: aws-expert should **verify with aws-docs MCP** before making recommendations on:
- Service limits, new features, best practices, security, API parameters

**Documentation created**: Complete technical reference + integration guide

**Ready for**: Integration into aws-expert.md agent definition

**Next step**: Update aws-expert.md with MCP integration guidance

---

## Appendix: Quick Reference

### Tool Signatures

```python
# Read AWS documentation as markdown
mcp__aws-docs__read_documentation(
    url: str,
    max_length: int = 5000,
    start_index: int = 0
) -> str

# Search AWS documentation
mcp__aws-docs__search_documentation(
    search_phrase: str,
    limit: int = 10
) -> list[dict]

# Get content recommendations
mcp__aws-docs__recommend(
    url: str
) -> list[dict]

# Get China region services (China partition only)
mcp__aws-docs__get_available_services() -> str
```

### Configuration

```json
{
  "aws-docs": {
    "command": "uvx",
    "args": ["awslabs.aws-documentation-mcp-server@latest"],
    "env": {
      "FASTMCP_LOG_LEVEL": "ERROR",
      "AWS_DOCUMENTATION_PARTITION": "aws"
    }
  }
}
```

### Example URLs

```
https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
https://docs.aws.amazon.com/lambda/latest/dg/lambda-invocation.html
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html
```

### Search Examples

```
"S3 bucket versioning"
"Lambda error handling best practices"
"AccessDenied S3 bucket policy troubleshooting"
"AWS EventBridge Pipes"
```

---

*Research completed: 2025-10-08*
*Documents ready for integration into aws-expert.md*
