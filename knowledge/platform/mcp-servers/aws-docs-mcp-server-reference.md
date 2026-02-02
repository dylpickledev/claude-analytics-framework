# AWS Documentation MCP Server Reference

**Package**: `awslabs.aws-documentation-mcp-server`
**Source**: [GitHub - awslabs/mcp](https://github.com/awslabs/mcp)
**Type**: Python-based MCP server
**Installation**: `uvx awslabs.aws-documentation-mcp-server@latest`

## Overview

The AWS Documentation MCP Server provides AI agents with programmatic access to AWS documentation, enabling them to search, read, and discover AWS documentation content. This MCP server bridges the gap between AI assistants and up-to-date AWS documentation, ensuring recommendations are based on current AWS capabilities.

## Available Tools

### 1. `read_documentation`

**Purpose**: Fetch and convert an AWS documentation page to markdown format.

**Function Signature**:
```
mcp__aws-docs__read_documentation(
    url: str,
    max_length: int = 5000,
    start_index: int = 0
) -> str
```

**Parameters**:
- `url` (required): URL of the AWS documentation page to read
  - Must be from `docs.aws.amazon.com` domain
  - Must end with `.html`
- `max_length` (optional): Maximum number of characters to return (default: 5000, max: 1,000,000)
- `start_index` (optional): Character index to start from (default: 0)
  - Useful for reading long documents in chunks

**Returns**: Markdown-formatted content of the AWS documentation page

**Output Format**:
- Preserved headings and structure
- Code blocks for examples
- Lists and tables converted to markdown format
- May be truncated if exceeds max_length

**Handling Long Documents**:
1. **Continue Reading**: If truncated, make another call with `start_index` set to end of previous response
2. **Stop Early**: For very long documents (>30,000 characters), stop if you've found specific information needed

**Example Usage**:
```
Read S3 bucket naming rules documentation:
url: "https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html"
max_length: 5000
start_index: 0
```

**Example URLs**:
- `https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html`
- `https://docs.aws.amazon.com/lambda/latest/dg/lambda-invocation.html`
- `https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html`

**Use Cases**:
- Verifying AWS service capabilities before making recommendations
- Reading architecture best practices for specific services
- Getting detailed parameter documentation for AWS API operations
- Reviewing security and compliance requirements

---

### 2. `search_documentation`

**Purpose**: Search across all AWS documentation using the official AWS Documentation Search API.

**Region Availability**: Global AWS regions only (`AWS_DOCUMENTATION_PARTITION=aws`)

**Function Signature**:
```
mcp__aws-docs__search_documentation(
    search_phrase: str,
    limit: int = 10
) -> list[dict]
```

**Parameters**:
- `search_phrase` (required): Search query to execute
- `limit` (optional): Maximum number of results to return (default: 10, min: 1, max: 50)

**Returns**: List of search results with:
- `rank_order`: Relevance ranking (lower is more relevant)
- `url`: Documentation page URL
- `title`: Page title
- `context`: Brief excerpt or summary (if available)

**Search Tips**:
- Use specific technical terms rather than general phrases
- Include service names to narrow results (e.g., "S3 bucket versioning" instead of just "versioning")
- Use quotes for exact phrase matching (e.g., "AWS Lambda function URLs")
- Include abbreviations and alternative terms to improve results

**Example Usage**:
```
Search for S3 versioning documentation:
search_phrase: "S3 bucket versioning"
limit: 10

Search for exact phrase:
search_phrase: "AWS Lambda function URLs"
limit: 5
```

**Use Cases**:
- Finding relevant documentation when you don't have a specific URL
- Discovering AWS services that solve specific problems
- Locating best practices guides for AWS architectures
- Finding troubleshooting guides for error messages

**Limitations**:
- Only works with global AWS partition (not AWS China)
- Search quality depends on AWS's search index
- May return irrelevant results for very broad queries

---

### 3. `recommend`

**Purpose**: Get content recommendations for related AWS documentation pages.

**Region Availability**: Global AWS regions only (`AWS_DOCUMENTATION_PARTITION=aws`)

**Function Signature**:
```
mcp__aws-docs__recommend(
    url: str
) -> list[dict]
```

**Parameters**:
- `url` (required): URL of the AWS documentation page to get recommendations for

**Returns**: List of recommended pages organized by category:
1. **Highly Rated**: Popular pages within the same AWS service
2. **New**: Recently added pages within the same AWS service (useful for finding newly released features)
3. **Similar**: Pages covering similar topics to the current page
4. **Journey**: Pages commonly viewed next by other users

**Each recommendation includes**:
- `url`: Documentation page URL
- `title`: Page title
- `context`: Brief description (if available)

**Example Usage**:
```
Get recommendations for S3 documentation page:
url: "https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html"

Result categories:
- Highly Rated: Most popular S3 documentation pages
- New: Recently released S3 features
- Similar: Related storage services (EFS, EBS, etc.)
- Journey: Next steps commonly taken by other users
```

**Finding New Features**:
To discover newly released information about a service:
1. Find the service's welcome page (e.g., S3 welcome page)
2. Call `recommend` with that URL
3. Look specifically at the **New** recommendation type in results

**Use Cases**:
- After reading a documentation page to find related content
- Exploring a new AWS service to discover important pages
- Finding alternative explanations of complex concepts
- Discovering the most popular pages for a service
- Finding newly released features for a specific service

**Limitations**:
- Only works with global AWS partition (not AWS China)
- Recommendations depend on AWS's usage analytics
- Quality varies by service popularity

---

### 4. `get_available_services`

**Purpose**: Get a list of available AWS services in China regions.

**Region Availability**: AWS China regions only (`AWS_DOCUMENTATION_PARTITION=aws-cn`)

**Function Signature**:
```
mcp__aws-docs__get_available_services() -> str
```

**Parameters**: None

**Returns**: String listing available AWS services in China regions

**Use Cases**:
- Verifying service availability in China regions
- Planning China-specific AWS architectures
- Understanding regional service limitations

**Limitations**:
- Only works with AWS China partition (`aws-cn`)
- Not available in global AWS regions

---

## Configuration

### Environment Variables

**FASTMCP_LOG_LEVEL**: Set logging level
- Values: `DEBUG`, `INFO`, `WARNING`, `ERROR`
- Default: `INFO`
- Recommended: `ERROR` (reduces noise in production)

**AWS_DOCUMENTATION_PARTITION**: Choose AWS region partition
- Values: `aws` (global), `aws-cn` (China)
- Default: `aws`
- Determines which tools are available

### MCP Configuration Example

```json
{
  "mcpServers": {
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
  }
}
```

---

## Tool Selection Decision Tree

```
Need AWS documentation?
│
├─ Know exact documentation URL?
│  └─ YES → Use read_documentation
│
├─ Need to find documentation?
│  └─ YES → Use search_documentation
│
├─ Want to explore related topics?
│  └─ YES → Use recommend
│
└─ Working with AWS China?
   └─ YES → Use get_available_services (China only)
```

---

## Best Practices

### When to Use aws-docs MCP

**Use aws-docs MCP when**:
- Verifying AWS service capabilities before making recommendations
- Need current AWS best practices (MCP always has latest docs)
- Looking up specific AWS API parameters or limits
- Discovering new AWS features or services
- Need authoritative source for AWS security/compliance requirements

**Don't use aws-docs MCP when**:
- You already have the information in your training data
- Question is about general cloud concepts (not AWS-specific)
- Need to execute AWS API calls (use aws-api MCP instead)

### Search Strategy

**For Best Search Results**:
1. Start with service-specific searches: "S3 bucket versioning"
2. Use exact phrases for specific features: "Lambda function URLs"
3. Include error codes when troubleshooting: "AccessDenied S3"
4. If no results, broaden search terms

**For Exploration**:
1. Start with `search_documentation` to find starting point
2. Use `read_documentation` to read the page
3. Use `recommend` to discover related topics
4. Follow "Journey" recommendations for learning paths

### Reading Long Documents

**Chunked Reading Pattern**:
```
1. First call: read_documentation(url, max_length=5000, start_index=0)
2. If truncated and need more:
   read_documentation(url, max_length=5000, start_index=5000)
3. Repeat until you have needed information
```

**Stop Early Pattern**:
- For very long documents (>30,000 chars), stop once you find what you need
- Don't read entire document if specific information already found

---

## Rate Limits and Constraints

**Read Documentation**:
- Max document length: 1,000,000 characters
- Recommended chunk size: 5,000 characters
- No explicit rate limits documented

**Search Documentation**:
- Max results per query: 50
- Recommended: 10 results (balance between coverage and speed)
- Global AWS only

**Recommend**:
- Returns 4 categories of recommendations
- Number of recommendations per category varies
- Global AWS only

---

## Integration with aws-expert Agent

### Pattern: Verify Before Recommend

```markdown
1. User asks: "How do I configure S3 bucket versioning?"

2. aws-expert thinks:
   - I know S3 versioning basics from training
   - But let me verify current AWS recommendations

3. aws-expert recommends:
   RECOMMENDED MCP TOOL EXECUTION
   Tool: read_documentation
   URL: https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html
   Expected: Current versioning best practices

4. Main Claude executes MCP call

5. aws-expert provides answer based on current documentation
```

### Pattern: Discovery Before Recommendation

```markdown
1. User asks: "What's the best way to handle Lambda errors?"

2. aws-expert thinks:
   - Multiple approaches exist
   - Let me search for latest AWS guidance

3. aws-expert recommends:
   RECOMMENDED MCP TOOL EXECUTION
   Tool: search_documentation
   Query: "Lambda error handling best practices"
   Limit: 10
   Expected: Official AWS error handling guides

4. Main Claude executes search

5. aws-expert reviews results, provides recommendation
```

---

## Common Error Scenarios

### Invalid URL Format

**Error**: URL must be from docs.aws.amazon.com and end with .html

**Solution**: Ensure URL follows format:
```
https://docs.aws.amazon.com/{service}/{version}/{guide}/{page}.html
```

### China vs Global Partition Mismatch

**Error**: Tool not available in current partition

**Solution**:
- `search_documentation`, `recommend` → Require `aws` partition
- `get_available_services` → Requires `aws-cn` partition

### Document Too Long

**Scenario**: Document exceeds max_length

**Solution**: Use chunked reading with start_index:
```
read_documentation(url, max_length=5000, start_index=0)
read_documentation(url, max_length=5000, start_index=5000)
read_documentation(url, max_length=5000, start_index=10000)
```

---

## Comparison with Other AWS MCP Servers

### aws-docs vs aws-api

| Feature | aws-docs | aws-api |
|---------|----------|---------|
| **Purpose** | Read AWS documentation | Execute AWS API calls |
| **Requires AWS Credentials** | No | Yes |
| **Can Modify Resources** | No | Yes (if not read-only) |
| **Use Case** | Learning, verification | Operations, inspection |
| **Example** | "Read S3 docs" | "List S3 buckets" |

### aws-docs vs aws-knowledge (future)

| Feature | aws-docs | aws-knowledge |
|---------|----------|---------------|
| **Purpose** | Read official docs | Access AWS knowledge base |
| **Content Type** | Documentation pages | Support articles, FAQs |
| **Structure** | Markdown conversion | Structured knowledge |

---

## Example Workflows

### Workflow 1: Research New AWS Service

```
1. search_documentation("AWS EventBridge Pipes", limit=10)
   → Find overview page

2. read_documentation(overview_url)
   → Understand service basics

3. recommend(overview_url)
   → Discover related topics:
     - Highly Rated: Key concepts page
     - New: Recently released features
     - Similar: EventBridge rules, Step Functions
     - Journey: Getting started guide

4. read_documentation(getting_started_url)
   → Learn implementation details
```

### Workflow 2: Troubleshoot AWS Error

```
1. search_documentation("AccessDenied S3 bucket policy", limit=5)
   → Find troubleshooting guides

2. read_documentation(troubleshooting_url)
   → Understand common causes

3. recommend(troubleshooting_url)
   → Find related:
     - Similar: IAM policy examples
     - Journey: Bucket policy examples
```

### Workflow 3: Validate Architecture Recommendation

```
1. User asks: "Should I use Lambda or ECS for this workload?"

2. search_documentation("Lambda vs ECS comparison", limit=5)
   → Find comparison guides

3. read_documentation(lambda_use_cases_url)
   → Understand Lambda best practices

4. read_documentation(ecs_use_cases_url)
   → Understand ECS best practices

5. Provide informed recommendation based on AWS guidance
```

---

## Security and Privacy

**No AWS Credentials Required**: aws-docs MCP server only reads public AWS documentation

**Data Privacy**:
- No customer data accessed
- No AWS account inspection
- Purely documentation retrieval

**Network Access**:
- Requires internet connectivity to docs.aws.amazon.com
- Uses AWS's public documentation search API

---

## Version and Updates

**Package Updates**: `@latest` tag ensures you always get newest version

**Breaking Changes**: AWS Labs maintains backward compatibility

**Documentation Currency**: Documentation is always current (pulled from live AWS docs)

---

## Installation Requirements

**Python Version**: 3.10 or newer

**Package Manager**: `uv` (Astral's Python package installer)

**Installation Command**:
```bash
uvx awslabs.aws-documentation-mcp-server@latest
```

**Platforms Supported**:
- Linux
- macOS
- Windows
- Docker

---

## References

- **GitHub Repository**: https://github.com/awslabs/mcp
- **Official Documentation**: https://awslabs.github.io/mcp/servers/aws-documentation-mcp-server
- **PyPI Package**: https://pypi.org/project/awslabs.aws-documentation-mcp-server/
- **MCP Protocol**: https://modelcontextprotocol.io/

---

## Changelog

**Latest Version Features**:
- read_documentation with chunked reading support
- search_documentation with configurable result limits
- recommend for content discovery
- get_available_services for China regions
- Markdown conversion for all documentation pages

---

*Last Updated: 2025-10-08*
*Research Source: awslabs/mcp GitHub repository, official AWS MCP documentation*
