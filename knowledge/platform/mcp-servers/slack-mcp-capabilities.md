# Slack MCP Server Capabilities

**Server**: `@modelcontextprotocol/server-slack`
**Version**: 2025.4.25
**Maintainer**: Zencoder Inc. (originally based on Anthropic code)
**License**: MIT

## Executive Summary

The Slack MCP server enables AI agents to interact with Slack workspaces through eight core tools for channel management, messaging, thread interactions, reactions, user profiles, and conversation history retrieval. This server transforms AI assistants into active participants in team communication workflows.

## Status & Maintenance

**Current Status**: Active and maintained by Zencoder
**Original Source**: Anthropic's Model Context Protocol servers (now archived)
**Repository**: https://github.com/zencoderai/slack-mcp-server
**npm Package**: https://www.npmjs.com/package/@modelcontextprotocol/server-slack

**Note**: The original Anthropic version is archived. The actively maintained version is by Zencoder Inc.

## Available Tools

### 1. slack_list_channels

**Purpose**: List public or pre-defined channels in the workspace with pagination support

**Parameters**:
- `cursor` (string, optional): Pagination cursor for next page of results
- `limit` (number, optional): Maximum number of channels to return (default: 100, max: 200)

**Returns**:
- Array of channel objects with channel details (ID, name, description, member count, etc.)
- `next_cursor` for pagination if more results exist

**OAuth Scopes Required**:
- `channels:read`

**Rate Limit Tier**: Tier 2 (~20 requests per minute)

**Example Use Cases**:
- Discovery: Find all public channels to determine where to post notifications
- Channel inventory: Audit workspace channels for governance
- User onboarding: Show new users available channels to join

**Edge Cases**:
- Returns only public channels unless bot has been added to private channels
- Private channels require explicit bot invitation
- Archived channels not included unless specifically requested

---

### 2. slack_post_message

**Purpose**: Post new messages to specified channels

**Parameters**:
- `channel_id` (string, required): Channel ID where message will be posted (format: C01234567)
- `text` (string, required): Message content (supports Slack markdown formatting)

**Returns**:
- Message confirmation with timestamp (`ts`)
- Channel ID
- Message text as posted

**OAuth Scopes Required**:
- `chat:write`

**Rate Limit Tier**: Tier 3 (~50 requests per minute)
**Additional Limit**: Maximum 1 message per second per channel (with short burst tolerance)

**Example Use Cases**:
- Automated notifications: CI/CD pipeline status, error alerts, deployment notifications
- Team updates: Daily digests, weekly reports, milestone achievements
- Bot responses: Answer questions, provide information on demand
- Workflow triggers: Post updates when tasks complete or conditions met

**Edge Cases**:
- Bot must be member of channel before posting (or channel must be public)
- Messages cannot exceed 40,000 characters
- Slack markdown formatting differs from standard markdown
- Rate limit is PER CHANNEL (1/sec per channel)

**Best Practices**:
- Always check bot has access to channel before posting
- Use formatted text for better readability (bold, italic, code blocks)
- Include relevant context in notifications
- Respect the 1 message/second per channel limit

---

### 3. slack_reply_to_thread

**Purpose**: Post replies to existing message threads

**Parameters**:
- `channel_id` (string, required): Channel ID containing the thread (format: C01234567)
- `thread_ts` (string, required): Timestamp of parent message (format: `1234567890.123456`)
- `text` (string, required): Reply message content (supports Slack markdown)

**Returns**:
- Reply confirmation with timestamp
- Thread timestamp reference
- Channel ID

**OAuth Scopes Required**:
- `chat:write`

**Rate Limit Tier**: Tier 3 (~50 requests per minute)

**Example Use Cases**:
- Threaded conversations: Keep related messages organized
- Context preservation: Reply to specific questions without cluttering main channel
- Status updates: Update thread with progress on ongoing work
- Multi-step workflows: Post updates to same thread as work progresses

**Edge Cases**:
- `thread_ts` MUST be timestamp of PARENT message, not a reply's timestamp
- Thread timestamp format: `1234567890.123456` (Unix timestamp with microseconds)
- Cannot thread `channel_join` or `channel_leave` message subtypes
- Thread not found error if parent message deleted

**Best Practices**:
- Always use parent message timestamp, never a reply's timestamp
- Validate thread exists before posting replies
- Keep threads focused on single topic
- Use threads to reduce channel noise

**Critical Format Note**:
The `thread_ts` parameter uses format `1234567890.123456` (with period). If you receive timestamps in format without period (e.g., from Slack events), you must convert by adding period such that 6 digits come after it.

---

### 4. slack_add_reaction

**Purpose**: Add emoji reactions to messages

**Parameters**:
- `channel_id` (string, required): Channel ID containing the message (format: C01234567)
- `timestamp` (string, required): Message timestamp (format: `1234567890.123456`)
- `reaction` (string, required): Emoji name without colons (e.g., `thumbsup`, not `:thumbsup:`)

**Returns**:
- Reaction confirmation
- Message timestamp
- Emoji added

**OAuth Scopes Required**:
- `reactions:write`

**Rate Limit Tier**: Tier 3 (~50 requests per minute)

**Example Use Cases**:
- Acknowledgment: Confirm message received/processed without text reply
- Status indicators: Use checkmark for completed tasks, hourglass for in-progress
- Sentiment tracking: Gather quick feedback with emoji reactions
- Workflow signals: Use specific emoji to trigger automated actions

**Edge Cases**:
- Emoji name must be valid Slack emoji (standard or custom workspace emoji)
- Duplicate reactions are ignored (no error, just no-op)
- Cannot react to deleted messages
- Custom emoji names are workspace-specific

**Best Practices**:
- Use standard emoji for cross-workspace compatibility
- Document emoji meaning in team conventions
- Don't overuse reactions (can become visual clutter)
- Combine with threads for detailed responses

---

### 5. slack_get_channel_history

**Purpose**: Retrieve recent messages from a channel

**Parameters**:
- `channel_id` (string, required): Channel ID to retrieve history from (format: C01234567)
- `limit` (number, optional): Number of messages to retrieve (default: 10, max: 1000)

**Returns**:
- Array of message objects (text, user, timestamp, reactions, etc.)
- Channel metadata
- Pagination cursors if more messages exist

**OAuth Scopes Required**:
- `channels:history` (for public channels)
- `groups:history` (for private channels)

**Rate Limit Tier**: Tier 3 (~50 requests per minute)

**Example Use Cases**:
- Context gathering: Read recent conversation before posting relevant response
- Sentiment analysis: Analyze team mood from recent messages
- Search/discovery: Find specific information in channel history
- Daily digest creation: Summarize yesterday's important messages
- Conversation analysis: Identify topics, questions, action items

**Edge Cases**:
- Bot requires appropriate history scope for channel type
- Returns up to 1000 messages per request (use pagination for more)
- Deleted messages not included in history
- Messages older than workspace retention policy not available

**Best Practices**:
- Request only needed messages (don't default to max limit)
- Cache results to avoid redundant API calls
- Respect workspace data retention policies
- Filter results client-side for specific needs

---

### 6. slack_get_thread_replies

**Purpose**: Retrieve all replies in a specific message thread

**Parameters**:
- `channel_id` (string, required): Channel ID containing thread (format: C01234567)
- `thread_ts` (string, required): Parent message timestamp (format: `1234567890.123456`)

**Returns**:
- Array of all messages in thread (including parent)
- Thread metadata
- User information for participants

**OAuth Scopes Required**:
- `channels:history` (for public channels)
- `groups:history` (for private channels)

**Rate Limit Tier**: Tier 3 (~50 requests per minute)

**Example Use Cases**:
- Thread context: Read full conversation before adding reply
- Issue tracking: Monitor thread for problem resolution
- Decision documentation: Capture full discussion for records
- Conversation summarization: Create summary of threaded discussion

**Edge Cases**:
- Parent message always included as first message in response
- Thread must exist (error if thread_ts invalid)
- Requires same permissions as channel history
- Bot tokens may have limited access vs user tokens

**Best Practices**:
- Verify thread exists before attempting to read
- Use parent timestamp only (not reply timestamp)
- Cache thread content to minimize API calls
- Consider thread age for relevance

---

### 7. slack_get_users

**Purpose**: List all users in the workspace with basic profile information

**Parameters**:
- `cursor` (string, optional): Pagination cursor for next page of results
- `limit` (number, optional): Maximum users to return (default: 100, max: 200)

**Returns**:
- Array of user objects (ID, name, real name, profile, status)
- Pagination cursor for next page if more users exist

**OAuth Scopes Required**:
- `users:read`

**Rate Limit Tier**: Tier 2 (~20 requests per minute)

**Example Use Cases**:
- User directory: Build internal contact list or org chart
- @mention validation: Verify user exists before mentioning
- Team roster: Generate team member lists for reports
- User lookup: Find user ID from display name for other API calls

**Edge Cases**:
- Includes deleted/deactivated users (check `deleted` field)
- Bot users included in results (check `is_bot` field)
- Guest users have limited profile information
- Pagination required for workspaces with >200 users

**Best Practices**:
- Filter out bots and deleted users if not needed
- Cache user list (updates infrequently)
- Use pagination for large workspaces
- Handle user privacy settings appropriately

---

### 8. slack_get_user_profile

**Purpose**: Retrieve detailed profile information for specific user

**Parameters**:
- `user_id` (string, required): User ID (format: U01234567 or W01234567)

**Returns**:
- Comprehensive user profile (email, phone, title, timezone, etc.)
- Custom profile fields
- User status and presence

**OAuth Scopes Required**:
- `users:read`
- `users.profile:read` (for full profile details including email)

**Rate Limit Tier**: Tier 4 (~100 requests per minute)

**Example Use Cases**:
- Contact information: Get email/phone for user outreach
- Timezone awareness: Schedule messages appropriately for user's timezone
- Org chart data: Build reporting structure from manager fields
- User context: Personalize interactions based on role/title

**Edge Cases**:
- Email requires `users.profile:read` scope (not just `users:read`)
- Guest users have minimal profile information
- Custom fields vary by workspace
- Deleted users return error

**Best Practices**:
- Request only when detailed info needed (vs get_users for basic info)
- Respect user privacy settings
- Cache profile data appropriately
- Handle missing fields gracefully (optional fields may be empty)

---

## Setup Requirements

### 1. Create Slack App

1. Go to https://api.slack.com/apps
2. Click "Create New App" > "From scratch"
3. Name your app and select workspace
4. Navigate to "OAuth & Permissions"

### 2. Configure OAuth Scopes

**Required Bot Token Scopes**:
- `channels:history` - View messages in public channels
- `channels:read` - View basic channel information
- `chat:write` - Send messages as bot
- `reactions:write` - Add emoji reactions
- `users:read` - View users in workspace
- `users.profile:read` - View detailed user profiles (including email)

**Optional Scopes** (depending on use case):
- `groups:history` - View messages in private channels
- `groups:read` - View basic private channel information
- `im:history` - View direct message history
- `mpim:history` - View group DM history

### 3. Install App to Workspace

1. Click "Install to Workspace" button
2. Review and authorize permissions
3. Copy Bot User OAuth Token (starts with `xoxb-`)
4. Save token securely in 1Password or environment variables

### 4. Get Team/Workspace ID

**Method 1**: From workspace URL
- URL format: `https://your-team.slack.com`
- Team ID format: `T01234567`

**Method 2**: Using API
```bash
curl -H "Authorization: Bearer xoxb-your-token" \
  https://slack.com/api/team.info
```

### 5. Environment Variables

Configure the following in `.mcp.json` or environment:

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM_ID}",
        "SLACK_CHANNEL_IDS": "C01234567,C76543210"
      }
    }
  }
}
```

**Environment Variables**:
- `SLACK_BOT_TOKEN` (required): Bot user OAuth token (starts with `xoxb-`)
- `SLACK_TEAM_ID` (required): Workspace/team ID (starts with `T`)
- `SLACK_CHANNEL_IDS` (optional): Comma-separated list of channel IDs to restrict access

**Security Best Practices**:
- Store `SLACK_BOT_TOKEN` in 1Password or secure secret manager
- Never commit tokens to version control
- Use environment variable substitution (e.g., `${SLACK_BOT_TOKEN}`)
- Rotate tokens periodically
- Use minimum required OAuth scopes

---

## Rate Limits & Performance

### Rate Limit Tiers

Slack organizes API methods into four rate limit tiers (per workspace, per app, per minute):

| Tier | Approx. Limit | MCP Tools in Tier |
|------|---------------|-------------------|
| Tier 1 | 1+ req/min | (none in MCP) |
| Tier 2 | 20+ req/min | `slack_list_channels`, `slack_get_users` |
| Tier 3 | 50+ req/min | `slack_post_message`, `slack_reply_to_thread`, `slack_add_reaction`, `slack_get_channel_history`, `slack_get_thread_replies` |
| Tier 4 | 100+ req/min | `slack_get_user_profile` |

**Note**: Exact limits are purposefully vague. Most apps stay well under limits without trying.

### Special Rate Limits

**Message Posting**:
- 1 message per second per channel (with short burst tolerance)
- Several hundred messages per minute workspace-wide limit

**Channel History** (new apps as of May 2025):
- Commercially distributed non-Marketplace apps: 1 req/min
- Maximum 15 objects returned (reduced from 1000)

### Rate Limit Handling

**When you hit rate limit**:
1. Slack returns `HTTP 429 Too Many Requests`
2. Response includes `Retry-After` header (seconds to wait)
3. Implement exponential backoff

**Best Practices**:
- Design for 1 request per second as baseline
- Implement retry logic with exponential backoff
- Respect `Retry-After` header values
- Cache results to minimize API calls
- Batch operations when possible
- Monitor rate limit usage

---

## Practical Use Cases

### 1. CI/CD Pipeline Notifications

**Scenario**: Notify team when CI fails, deployments complete, or code reviews needed

**Tools Used**:
- `slack_post_message` - Post build status to #engineering channel
- `slack_reply_to_thread` - Update existing deployment thread with progress
- `slack_add_reaction` - Add ✅ to deployment announcement when smoke tests pass

**Implementation Pattern**:
```
1. CI pipeline detects failure
2. AI agent reads error logs and analyzes root cause
3. slack_post_message to #engineering with:
   - Build status (failed/success)
   - Error summary (AI-generated)
   - Link to logs and PR
4. slack_add_reaction with ⚠️ emoji for high-priority failures
```

**Benefits**:
- Immediate team awareness
- Context-rich notifications (AI analysis vs raw logs)
- Threaded updates keep conversation organized

---

### 2. Daily Digest / Team Summary

**Scenario**: Generate daily summary of important Slack activity for executives or remote team members

**Tools Used**:
- `slack_get_channel_history` - Read messages from key channels (#general, #product, #engineering)
- `slack_get_thread_replies` - Read full context of important threads
- `slack_post_message` - Post daily digest to #leadership-digest

**Implementation Pattern**:
```
1. Every morning at 8am (user's timezone)
2. slack_get_channel_history from last 24 hours (#general, #product, #engineering)
3. AI analyzes messages for:
   - Important decisions
   - Action items
   - Blockers/issues
   - Milestone achievements
4. slack_get_thread_replies for threads with high engagement
5. slack_post_message formatted summary to #leadership-digest
```

**Benefits**:
- Stay informed without reading every channel
- AI filters noise, surfaces important information
- Consistent daily routine

---

### 3. Question Answering Bot

**Scenario**: Answer team questions about internal docs, policies, or code from Slack

**Tools Used**:
- `slack_get_channel_history` - Monitor channels for questions
- `slack_reply_to_thread` - Answer questions in organized threads
- `slack_add_reaction` - Add 👀 when processing question, ✅ when answered
- `slack_get_user_profile` - Get user timezone for context-aware responses

**Implementation Pattern**:
```
1. Monitor #help-desk channel with slack_get_channel_history
2. Detect questions using AI analysis
3. slack_add_reaction with 👀 to acknowledge question
4. AI searches knowledge base, docs, codebase
5. slack_reply_to_thread with answer
6. slack_add_reaction with ✅ to mark resolved
```

**Benefits**:
- Instant answers to common questions
- Reduces burden on human team members
- Knowledge surfaced from multiple sources

---

### 4. Onboarding Assistant

**Scenario**: Help new team members get oriented in workspace

**Tools Used**:
- `slack_list_channels` - Show new user relevant channels to join
- `slack_get_users` - Introduce new user to team members
- `slack_post_message` - Welcome message to #general or #introductions
- `slack_get_user_profile` - Customize onboarding based on role/timezone

**Implementation Pattern**:
```
1. New user joins workspace (trigger from HR system)
2. slack_get_user_profile to understand role, timezone, team
3. slack_list_channels filtered for role-relevant channels
4. slack_post_message personalized onboarding guide
5. slack_post_message to #introductions with new hire introduction
6. Schedule follow-up messages (day 1, week 1, month 1 check-ins)
```

**Benefits**:
- Consistent onboarding experience
- Personalized to role and needs
- Reduces manual onboarding tasks

---

### 5. Incident Response Coordination

**Scenario**: Coordinate team during production incidents

**Tools Used**:
- `slack_post_message` - Create incident channel announcement
- `slack_get_channel_history` - Monitor incident channel for updates
- `slack_reply_to_thread` - Post status updates to incident thread
- `slack_add_reaction` - Mark messages as acknowledged or resolved

**Implementation Pattern**:
```
1. Monitoring system detects P1 incident
2. slack_post_message to #incidents with:
   - Incident severity and description
   - Affected systems
   - Initial responders
3. Create incident thread for coordination
4. slack_reply_to_thread with automated status updates:
   - System health metrics
   - Customer impact analysis
   - Suggested remediation steps
5. slack_add_reaction on action items (👀 = acknowledged, ✅ = completed)
6. Post-incident summary to thread when resolved
```

**Benefits**:
- Centralized incident communication
- Automated status updates reduce manual work
- Complete incident timeline for post-mortems

---

### 6. Data Query Automation

**Scenario**: Allow team to ask data questions in Slack, get answers from data warehouse

**Tools Used**:
- `slack_get_channel_history` - Monitor #data-requests channel
- `slack_reply_to_thread` - Post query results with visualizations
- `slack_add_reaction` - Status indicators (⏳ = processing, ✅ = complete, ❌ = error)

**Implementation Pattern**:
```
1. User posts natural language question in #data-requests
   Example: "How did Q3 sales compare to Q2?"
2. AI converts question to SQL query
3. slack_add_reaction with ⏳ while processing
4. Execute query against data warehouse (via Snowflake MCP)
5. slack_reply_to_thread with:
   - Results table
   - Summary analysis
   - Chart/visualization (as image)
6. slack_add_reaction ✅ when complete
```

**Benefits**:
- Self-service data access for non-technical users
- No need to learn SQL or BI tools
- Fast answers to business questions

---

## Limitations & Edge Cases

### Permission Limitations

**Bot vs User Tokens**:
- Bot tokens have more restrictions than user tokens
- Cannot access private channels unless explicitly invited
- Cannot read DM history between other users
- Limited admin/workspace management capabilities

**Channel Access**:
- Bot must be member of channel to post (or channel must be public)
- Private channel history requires bot invitation + `groups:history` scope
- Cannot access archived channels by default

### Data Retention

- Message history limited by workspace retention policy (varies by plan)
- Free workspaces: 10,000 recent messages
- Paid workspaces: Complete history OR custom retention policy
- Cannot retrieve messages older than retention window

### Message Format

**Character Limits**:
- Message text: 40,000 characters max
- Attachments: Additional limits apply
- Thread replies: Same 40,000 character limit

**Formatting Differences**:
- Slack uses markdown-like syntax but not standard markdown
- Code blocks use triple backticks but different syntax
- Links use `<URL|text>` format instead of `[text](URL)`
- User mentions: `<@U01234567>` format

### Timestamp Format

**Critical Format**:
- Thread timestamps: `1234567890.123456` (Unix timestamp with microseconds)
- Must include period with 6 digits after
- Common error: Using timestamp without period
- Conversion needed from some Slack event formats

### Rate Limit Edge Cases

**Per-Channel Message Limit**:
- 1 message per second PER CHANNEL
- Can post to multiple channels simultaneously
- Burst tolerance exists but not documented
- Exceeding limit causes rate limit error

**New App Restrictions** (as of May 2025):
- Non-Marketplace distributed apps have stricter limits
- Channel history: 1 req/min (vs 50+ for established apps)
- Maximum 15 results returned (vs 1000)
- Affects `slack_get_channel_history` primarily

### Thread Limitations

**Cannot Thread These Message Types**:
- `channel_join` messages
- `channel_leave` messages
- Some system messages

**Thread Timestamp Issues**:
- Must use PARENT message timestamp, not reply timestamp
- Thread not found error if parent deleted
- Cannot create thread from another thread reply

### User Profile Privacy

**Limited Information for**:
- Guest users (minimal profile data)
- Users with strict privacy settings
- Deleted/deactivated users (some fields empty)

**Email Access**:
- Requires `users.profile:read` scope (not just `users:read`)
- Some users can hide email from API
- External/guest users may not have email in system

---

## Agent Recommendations

Based on capabilities analysis, these agents should have Slack MCP access:

### High Priority (Should Have Access)

1. **project-manager-role**
   - **Why**: Stakeholder communication, project updates, team coordination
   - **Tools**: `slack_post_message`, `slack_reply_to_thread`, `slack_get_channel_history`
   - **Use Cases**: Sprint updates, milestone notifications, blocker escalation

2. **business-analyst-role**
   - **Why**: Stakeholder communication, requirements gathering, feedback collection
   - **Tools**: `slack_get_channel_history`, `slack_get_thread_replies`, `slack_post_message`
   - **Use Cases**: Requirement discussions, feedback synthesis, stakeholder updates

3. **qa-engineer-role**
   - **Why**: Test result notifications, bug reports, quality alerts
   - **Tools**: `slack_post_message`, `slack_reply_to_thread`, `slack_add_reaction`
   - **Use Cases**: Test suite results, bug notifications, UAT coordination

4. **data-engineer-role**
   - **Why**: Pipeline alerts, data quality notifications, operational updates
   - **Tools**: `slack_post_message`, `slack_reply_to_thread`
   - **Use Cases**: Pipeline failures, data quality issues, ETL status updates

5. **analytics-engineer-role**
   - **Why**: dbt run notifications, model deployment updates, data quality alerts
   - **Tools**: `slack_post_message`, `slack_reply_to_thread`
   - **Use Cases**: dbt Cloud run results, model validation, metrics alerts

### Medium Priority (Conditional Access)

6. **ui-ux-developer-role**
   - **Why**: Deployment notifications, user feedback discussions
   - **Tools**: `slack_post_message`, `slack_get_channel_history`
   - **Use Cases**: App deployment announcements, user feedback analysis

7. **bi-developer-role**
   - **Why**: Dashboard update notifications, report delivery
   - **Tools**: `slack_post_message`
   - **Use Cases**: Dashboard refresh notifications, report delivery confirmations

### Low Priority (Specialist Tools Only)

Most specialist agents likely don't need direct Slack access - they provide technical recommendations that role agents can communicate via Slack.

**Exception**: Could provide Slack access to:
- `documentation-expert` - Post doc updates to #documentation channel
- `github-sleuth-expert` - Post repository analysis findings

---

## Integration Patterns

### Pattern 1: Notification Broadcast

**When to Use**: One-way communication of status/updates to team

**Tools**: `slack_post_message`

**Example**:
```
Trigger: dbt Cloud job completes
→ Analytics Engineer agent analyzes results
→ slack_post_message to #data-engineering:
   "✅ Production dbt run completed
    - 247 models built
    - 3 tests failed (see thread)
    - Runtime: 12m 34s"
```

### Pattern 2: Threaded Conversation

**When to Use**: Maintain context over multiple exchanges, organized discussion

**Tools**: `slack_post_message` → `slack_get_thread_replies` → `slack_reply_to_thread`

**Example**:
```
1. User posts: "@ai-assistant analyze Q3 sales trends"
2. AI slack_reply_to_thread: "Analyzing Q3 data..." (creates thread)
3. AI runs Snowflake queries
4. slack_reply_to_thread with results and visualizations
5. User asks follow-up in thread
6. AI slack_get_thread_replies to read full context
7. slack_reply_to_thread with answer
```

### Pattern 3: Status Indicator Reactions

**When to Use**: Quick status updates without text, visual progress tracking

**Tools**: `slack_add_reaction`

**Example**:
```
User request in thread:
1. slack_add_reaction 👀 (acknowledged)
2. Process request...
3. slack_add_reaction ✅ (completed)

Or if error:
3. slack_add_reaction ❌ (failed)
4. slack_reply_to_thread with error details
```

### Pattern 4: Daily Digest Compilation

**When to Use**: Regular summaries, information aggregation from multiple sources

**Tools**: `slack_get_channel_history` → AI analysis → `slack_post_message`

**Example**:
```
Daily at 8am:
1. slack_get_channel_history from last 24h:
   - #general
   - #engineering
   - #product
2. AI extracts:
   - Decisions made
   - Action items
   - Blockers
   - Wins
3. slack_post_message formatted digest to #leadership
```

### Pattern 5: Interactive Q&A

**When to Use**: Answer questions with full context awareness

**Tools**: `slack_get_channel_history` + `slack_get_thread_replies` + `slack_reply_to_thread`

**Example**:
```
Monitor #help-desk:
1. slack_get_channel_history detects question
2. slack_get_thread_replies for context
3. AI searches knowledge base
4. slack_reply_to_thread with answer
5. If follow-up question, repeat from step 2
```

---

## Security & Privacy Considerations

### Token Security

**CRITICAL**:
- **NEVER** commit `SLACK_BOT_TOKEN` to version control
- Store in 1Password or encrypted secret manager
- Use environment variable substitution in config files
- Rotate tokens periodically (quarterly recommended)

**Audit Trail**:
- Slack logs all bot actions
- Bot name visible on all messages
- Users can see bot permissions in workspace settings

### Data Privacy

**What Bots Can See**:
- All public channel content (if bot member)
- Private channel content (only if explicitly invited)
- User profile information (within granted scopes)

**What Bots Cannot See**:
- DMs between other users
- Channels bot not member of (unless public and using list)
- Admin workspace settings
- Billing information

### Scope Minimization

**Principle**: Request minimum scopes needed for functionality

**Bad**: Request all possible scopes "just in case"

**Good**: Analyze actual tool usage and request only necessary scopes

**Example**:
```
If only posting notifications:
✅ channels:read, chat:write
❌ Don't add: reactions:write, users:read, channels:history
```

### Workspace Governance

**Considerations**:
- Some workspaces require admin approval for apps
- Enterprise Grid workspaces have additional restrictions
- Data residency requirements may affect usage
- Compliance requirements (GDPR, HIPAA) may limit data access

---

## Troubleshooting

### Common Errors

#### Error: `not_in_channel`
**Cause**: Bot not member of target channel
**Solution**:
- Add bot to channel: `/invite @your-bot-name`
- Or ensure channel is public and bot has `channels:read` scope

#### Error: `thread_not_found`
**Cause**: Invalid thread timestamp or deleted parent message
**Solution**:
- Verify `thread_ts` format: `1234567890.123456`
- Ensure using PARENT timestamp, not reply timestamp
- Check if parent message still exists

#### Error: `invalid_auth`
**Cause**: Invalid or expired bot token
**Solution**:
- Verify `SLACK_BOT_TOKEN` is correct (starts with `xoxb-`)
- Check token hasn't been revoked
- Regenerate token if necessary

#### Error: `rate_limited` (HTTP 429)
**Cause**: Exceeded rate limit for API method
**Solution**:
- Check `Retry-After` header for wait time
- Implement exponential backoff
- Review rate limit tier for method
- Reduce request frequency

#### Error: `missing_scope`
**Cause**: Bot token lacks required OAuth scope
**Solution**:
- Check error message for required scope
- Add scope in Slack App settings
- Reinstall app to workspace
- Update bot token

### Debug Checklist

When Slack MCP tools fail:

1. **Verify Configuration**
   - [ ] `SLACK_BOT_TOKEN` set correctly
   - [ ] `SLACK_TEAM_ID` set correctly
   - [ ] Environment variables loaded

2. **Check Permissions**
   - [ ] Bot has required OAuth scopes
   - [ ] Bot is member of target channel
   - [ ] User hasn't restricted bot access

3. **Validate Parameters**
   - [ ] Channel ID format: `C01234567`
   - [ ] Thread timestamp format: `1234567890.123456`
   - [ ] Emoji name without colons: `thumbsup`

4. **Test Rate Limits**
   - [ ] Not exceeding 1 msg/sec per channel
   - [ ] Not exceeding tier rate limits
   - [ ] Implementing backoff on 429 errors

5. **Review Logs**
   - [ ] Check Slack API responses
   - [ ] Verify MCP server logs
   - [ ] Look for deprecation warnings

---

## Migration Notes

### From Archived Anthropic Version

The original `@modelcontextprotocol/server-slack` from Anthropic is now archived. Zencoder maintains the actively updated version.

**Migration Steps**:
1. Update package reference (no action needed, npm redirects)
2. Verify OAuth scopes unchanged
3. Test all tools still work as expected
4. Monitor Zencoder repo for updates: https://github.com/zencoderai/slack-mcp-server

**Breaking Changes**: None identified in current Zencoder version

---

## Future Enhancements

Potential additions to Slack MCP (not currently available):

### Requested Features

1. **Direct Message Support**
   - Tools: `slack_send_dm`, `slack_list_dms`, `slack_get_dm_history`
   - Use Case: Private notifications, personal reminders

2. **File Upload**
   - Tools: `slack_upload_file`, `slack_share_file`
   - Use Case: Share reports, visualizations, logs

3. **Channel Management**
   - Tools: `slack_create_channel`, `slack_archive_channel`, `slack_set_topic`
   - Use Case: Dynamic channel creation for projects/incidents

4. **Search**
   - Tools: `slack_search_messages`, `slack_search_files`
   - Use Case: Find historical information, retrieve context

5. **Workflow Triggers**
   - Tools: `slack_trigger_workflow`, `slack_workflow_status`
   - Use Case: Integrate with Slack Workflow Builder

**Note**: These are NOT currently available. Check Zencoder repo for roadmap.

---

## References

### Official Documentation

- **Slack MCP Server (Zencoder)**: https://github.com/zencoderai/slack-mcp-server
- **npm Package**: https://www.npmjs.com/package/@modelcontextprotocol/server-slack
- **Slack API Documentation**: https://api.slack.com/
- **OAuth Scopes Reference**: https://api.slack.com/scopes
- **Rate Limits**: https://docs.slack.dev/apis/web-api/rate-limits/

### Model Context Protocol

- **MCP Documentation**: https://modelcontextprotocol.io/
- **MCP Servers Repository**: https://github.com/modelcontextprotocol/servers
- **MCP TypeScript SDK**: https://github.com/modelcontextprotocol/typescript-sdk

### Community Resources

- **MCP Server Directory**: https://mcp.so/server/slack
- **Cursor Directory**: https://cursor.directory/mcp/slack
- **Slack Developers**: https://slack.dev/

---

## Changelog

### 2025-10-08
- Initial documentation created
- Comprehensive tool inventory (8 tools)
- Rate limit analysis and best practices
- Use case examples and integration patterns
- Agent recommendations
- Security and troubleshooting guidance

---

**Document Status**: Active
**Last Updated**: 2025-10-08
**Maintained By**: DA Agent Hub Team
**Next Review**: When Slack MCP server updates released
