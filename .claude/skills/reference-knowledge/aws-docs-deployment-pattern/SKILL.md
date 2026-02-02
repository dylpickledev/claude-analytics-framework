---
name: aws-docs-deployment-pattern
description: Cross-Tool Integration Pattern: AWS Infrastructure + Documentation
user-invocable: false
---

# Cross-Tool Integration Pattern: AWS Infrastructure + Documentation

**Pattern Type**: Infrastructure Deployment
**Tools**: aws-api, aws-docs
**Confidence**: HIGH (0.90) - Production-validated pattern
**Primary Users**: aws-expert, data-engineer-role, frontend-developer-role, data-architect-role

---

## Problem Statement

**Scenario**: Deploy new AWS service or update existing infrastructure
**Challenge**: AWS documentation changes frequently, training data becomes outdated
**Goal**: Deploy infrastructure following CURRENT best practices and service limits

---

## Integration Pattern Overview

### Tool Coordination Strategy
```
aws-docs → Search for current best practices
    ↓
aws-docs → Read specific service documentation
    ↓
aws-docs → Get related content (new features, security)
    ↓
aws-api → Validate existing infrastructure state
    ↓
aws-expert → Design infrastructure based on current docs
    ↓
HUMAN → Implement changes (aws-api is read-only)
```

**Critical Insight**: aws-docs provides **CURRENT documentation** (post-training cutoff)
- Service limits may have increased since training
- New features released after Jan 2025
- Updated security best practices
- Changed API parameters

**Why both tools needed**:
- **aws-docs**: CURRENT best practices, limits, features (not just training data)
- **aws-api**: Existing infrastructure state, validation
- **Together**: Informed decisions based on latest AWS knowledge + current state

---

## Step-by-Step Workflow

### Step 1: Documentation Search (aws-docs)

**Search for service best practices**:
```bash
# 1. Search for current best practices
mcp__aws-docs__search_documentation \
  search_phrase="ECS Fargate deployment best practices 2025" \
  limit=10
```

**Returns**:
- Top 10 documentation pages ranked by relevance
- URLs to official AWS documentation
- Brief context snippets for each result

**Review results for**:
- Official best practices guides
- Service launch announcements (new features)
- Security recommendations
- Performance optimization guides

---

### Step 2: Read Best Practices (aws-docs)

**Read specific documentation page**:
```bash
# 2. Read best practices guide
mcp__aws-docs__read_documentation \
  url="https://docs.aws.amazon.com/ecs/latest/bestpracticesguide/intro.html" \
  max_length=5000 \
  start_index=0
```

**If document is long (truncated)**:
```bash
# 3. Continue reading from where we left off
mcp__aws-docs__read_documentation \
  url="https://docs.aws.amazon.com/ecs/latest/bestpracticesguide/intro.html" \
  max_length=5000 \
  start_index=5000
```

**Extract key information**:
- Task definition best practices (CPU/memory sizing)
- Network configuration (VPC, security groups, ALB)
- IAM role requirements (task role vs execution role)
- Logging and monitoring recommendations
- Auto-scaling strategies
- Cost optimization tips

---

### Step 3: Get Related Documentation (aws-docs)

**Discover related content**:
```bash
# 4. Get recommendations for related documentation
mcp__aws-docs__recommend \
  url="https://docs.aws.amazon.com/ecs/latest/bestpracticesguide/intro.html"
```

**Returns 4 types of recommendations**:
1. **Highly Rated**: Popular pages within ECS (frequently viewed)
2. **New**: Recently added pages (**NEW FEATURES** after training cutoff)
3. **Similar**: Related topics (security, networking, troubleshooting)
4. **Journey**: Commonly viewed next (typical learning path)

**Check "New" recommendations for**:
- Features released after Jan 2025
- Updated service limits
- New integration patterns
- Recent security updates

---

### Step 4: Service Limits Verification (aws-docs)

**Search for current service limits**:
```bash
# 5. Search for service quotas and limits
mcp__aws-docs__search_documentation \
  search_phrase="ECS service quotas limits" \
  limit=5
```

**Read service limits page**:
```bash
# 6. Read current service limits
mcp__aws-docs__read_documentation \
  url="https://docs.aws.amazon.com/ecs/latest/developerguide/service-quotas.html" \
  max_length=5000
```

**Why critical**:
- Service limits may have increased since training (e.g., tasks per service: 100 → 1000)
- New quotas added for new features
- Regional differences in limits
- Soft limits vs hard limits

---

### Step 5: Validate Current Infrastructure (aws-api)

**Check current AWS account/region**:
```bash
# 7. Verify AWS account and credentials
mcp__aws-api__call_aws \
  cli_command="aws sts get-caller-identity"
```

**List existing ECS clusters**:
```bash
# 8. List ECS clusters in current region
mcp__aws-api__call_aws \
  cli_command="aws ecs list-clusters --region us-west-2"
```

**Get cluster details**:
```bash
# 9. Describe specific cluster
mcp__aws-api__call_aws \
  cli_command="aws ecs describe-clusters --clusters my-cluster --region us-west-2"
```

**List services in cluster**:
```bash
# 10. List services
mcp__aws-api__call_aws \
  cli_command="aws ecs list-services --cluster my-cluster --region us-west-2"
```

**Get service details**:
```bash
# 11. Describe specific service
mcp__aws-api__call_aws \
  cli_command="aws ecs describe-services --cluster my-cluster --services my-service --region us-west-2"
```

---

### Step 6: Design Deployment Strategy (aws-expert)

**Delegate to specialist**:
```markdown
DELEGATE TO: aws-expert

CONTEXT:
- Task: Deploy new ECS Fargate service for data pipeline
- Current State:
  - Cluster: analytics-cluster (existing, us-west-2)
  - Services: 3 existing services running
  - VPC: Existing (private subnets, NAT gateway)
  - ALB: Existing (HTTPS listener with OIDC auth)

- Documentation Research (from aws-docs):
  - Best Practices: Task size 0.5 vCPU / 1 GB minimum for Python apps
  - Network: Use awsvpc network mode with private subnets
  - IAM: Separate task role (permissions) from execution role (ECR/CloudWatch)
  - Logging: CloudWatch Logs with log group per service
  - Auto-scaling: Target tracking on CPU (70% threshold)
  - New Feature (2025): ECS Exec enabled for debugging (post-training)

- Current Service Limits (verified with aws-docs):
  - Tasks per service: 5,000 (increased from 1,000 in training)
  - Services per cluster: 5,000 (no change)
  - Task definition size: 64 KB (increased from 32 KB)

- Requirements:
  - Service: data-ingestion-pipeline
  - Task: Python application (dlthub connector)
  - CPU: 0.5 vCPU
  - Memory: 1 GB
  - Schedule: Run every hour (EventBridge trigger)
  - Logs: CloudWatch Logs (7-day retention)
  - Network: Private subnet with NAT for internet access

- Constraints:
  - Must use existing VPC and ALB
  - Cost-optimized (use Fargate Spot if possible)
  - No public IP exposure
  - IAM least-privilege principle

REQUEST: "Infrastructure deployment recommendations based on CURRENT AWS docs and best practices"
```

**Specialist provides**:
1. **Task definition** (JSON with current best practices)
2. **Service definition** (launch type, network config, auto-scaling)
3. **IAM roles** (task role, execution role with least privilege)
4. **CloudWatch configuration** (log groups, metrics, alarms)
5. **Cost optimization** (Fargate Spot, right-sizing)
6. **Security configuration** (network isolation, secrets management)

---

### Step 7: Validation Before Deployment (aws-api)

**Verify prerequisites exist**:
```bash
# 12. Check VPC and subnets
mcp__aws-api__call_aws \
  cli_command="aws ec2 describe-subnets --filters Name=tag:Name,Values=*private* --region us-west-2"

# 13. Check security groups
mcp__aws-api__call_aws \
  cli_command="aws ec2 describe-security-groups --filters Name=vpc-id,Values=vpc-12345 --region us-west-2"

# 14. Check IAM roles exist
mcp__aws-api__call_aws \
  cli_command="aws iam get-role --role-name ecsTaskExecutionRole"

# 15. Check ECR repository
mcp__aws-api__call_aws \
  cli_command="aws ecr describe-repositories --repository-names data-ingestion-pipeline --region us-west-2"
```

**Get latest Docker image tag**:
```bash
# 16. List ECR images
mcp__aws-api__call_aws \
  cli_command="aws ecr list-images --repository-name data-ingestion-pipeline --region us-west-2"
```

---

### Step 8: Deployment (HUMAN Implementation)

**Why human implements**:
- aws-api MCP has `READ_OPERATIONS_ONLY=true` (safety restriction)
- Write operations (Create/Update/Delete) blocked in MCP
- aws-expert provides recommendations, human implements via:
  - AWS Console (visual interface)
  - AWS CLI directly (outside MCP)
  - CloudFormation/Terraform (IaC)

**Deployment checklist** (provided by aws-expert):
```bash
# HUMAN executes these commands (outside MCP):

# 1. Register task definition
aws ecs register-task-definition --cli-input-json file://task-definition.json --region us-west-2

# 2. Create service
aws ecs create-service --cli-input-json file://service-definition.json --region us-west-2

# 3. Create CloudWatch alarms
aws cloudwatch put-metric-alarm --cli-input-json file://cpu-alarm.json --region us-west-2

# 4. Create EventBridge rule (hourly trigger)
aws events put-rule --name hourly-ingestion --schedule-expression "rate(1 hour)" --region us-west-2

# 5. Add ECS task as target
aws events put-targets --rule hourly-ingestion --targets file://ecs-target.json --region us-west-2
```

---

### Step 9: Post-Deployment Validation (aws-api)

**Verify service created**:
```bash
# 17. Check service status
mcp__aws-api__call_aws \
  cli_command="aws ecs describe-services --cluster analytics-cluster --services data-ingestion-pipeline --region us-west-2"
```

**Check task is running**:
```bash
# 18. List running tasks
mcp__aws-api__call_aws \
  cli_command="aws ecs list-tasks --cluster analytics-cluster --service-name data-ingestion-pipeline --region us-west-2"

# 19. Describe task details
mcp__aws-api__call_aws \
  cli_command="aws ecs describe-tasks --cluster analytics-cluster --tasks [task-arn] --region us-west-2"
```

**Verify CloudWatch logs**:
```bash
# 20. Check log streams exist
mcp__aws-api__call_aws \
  cli_command="aws logs describe-log-streams --log-group-name /ecs/data-ingestion-pipeline --region us-west-2"
```

---

## Real-World Example

### Scenario: Deploy Customer Dashboard React App to ECS

**Step 1: Documentation Research** (aws-docs)
```bash
# Search for React app deployment
mcp__aws-docs__search_documentation \
  search_phrase="ECS Fargate React application deployment NGINX" \
  limit=5

# Read best practices
mcp__aws-docs__read_documentation \
  url="https://docs.aws.amazon.com/ecs/latest/bestpracticesguide/application.html"

# Get new features
mcp__aws-docs__recommend \
  url="https://docs.aws.amazon.com/ecs/latest/developerguide/Welcome.html"
```

**Key findings from docs**:
- Use NGINX as reverse proxy (lightweight, production-ready)
- Task sizing: 0.25 vCPU / 0.5 GB for NGINX + static React
- Health checks: ALB health check on /health endpoint
- Logging: NGINX access logs to CloudWatch
- **New (2025)**: ECS Service Connect for service mesh (post-training feature)

---

**Step 2: Current Infrastructure** (aws-api)
```bash
# Check existing resources
mcp__aws-api__call_aws cli_command="aws ecs describe-clusters --clusters app-cluster --region us-west-2"
mcp__aws-api__call_aws cli_command="aws elbv2 describe-load-balancers --region us-west-2"
mcp__aws-api__call_aws cli_command="aws ecr describe-repositories --repository-names customer-dashboard --region us-west-2"
```

**Findings**:
- Cluster: app-cluster (exists)
- ALB: app-alb with OIDC auth (exists)
- ECR: customer-dashboard:latest (exists)
- VPC: Private subnets with NAT (exists)

---

**Step 3: Deployment Design** (aws-expert)
Based on CURRENT docs + existing infrastructure:

**Task Definition**:
```json
{
  "family": "customer-dashboard",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",  // 0.25 vCPU (docs recommend for NGINX + static)
  "memory": "512",  // 0.5 GB (docs recommend minimum)
  "executionRoleArn": "arn:aws:iam::account:role/ecsTaskExecutionRole",
  "taskRoleArn": "arn:aws:iam::account:role/salesJournalTaskRole",
  "containerDefinitions": [{
    "name": "customer-dashboard",
    "image": "account.dkr.ecr.us-west-2.amazonaws.com/customer-dashboard:latest",
    "portMappings": [{"containerPort": 80, "protocol": "tcp"}],
    "healthCheck": {
      "command": ["CMD-SHELL", "curl -f http://localhost/health || exit 1"],
      "interval": 30,
      "timeout": 5,
      "retries": 3
    },
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/customer-dashboard",
        "awslogs-region": "us-west-2",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }]
}
```

**Service Definition** (includes new 2025 features):
- Launch type: FARGATE
- Network: Private subnets
- Load balancer: app-alb (OIDC auth)
- Auto-scaling: Target tracking on CPU (70%)
- **NEW**: ECS Service Connect enabled (service mesh, post-training)

---

**Step 4: Deployment** (HUMAN)
```bash
# Register task definition
aws ecs register-task-definition --cli-input-json file://task-def.json

# Create service with Service Connect (NEW 2025 feature)
aws ecs create-service \
  --cluster app-cluster \
  --service-name customer-dashboard \
  --task-definition customer-dashboard \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx],securityGroups=[sg-xxx]}" \
  --load-balancers "targetGroupArn=arn:aws:elasticloadbalancing:...,containerName=customer-dashboard,containerPort=80" \
  --service-connect-configuration "enabled=true,namespace=app-services"
```

---

**Step 5: Validation** (aws-api)
```bash
# Check service status
mcp__aws-api__call_aws \
  cli_command="aws ecs describe-services --cluster app-cluster --services customer-dashboard --region us-west-2"

# Verify tasks running
mcp__aws-api__call_aws \
  cli_command="aws ecs list-tasks --cluster app-cluster --service-name customer-dashboard --region us-west-2"

# Check target health (ALB)
mcp__aws-api__call_aws \
  cli_command="aws elbv2 describe-target-health --target-group-arn [tg-arn] --region us-west-2"
```

**Result**: Service deployed successfully using CURRENT 2025 best practices (ECS Service Connect, right-sized tasks, proper health checks)

---

## Why aws-docs Currency is CRITICAL

### Example 1: Service Limits Increase
**Training Data (Jan 2025)**:
- ECS tasks per service: 1,000 max

**Current AWS Docs (Oct 2025)**:
- ECS tasks per service: 5,000 max (5x increase!)

**Impact**: Without aws-docs, would design around outdated 1,000 limit

---

### Example 2: New Features Released
**Training Data (Jan 2025)**:
- No knowledge of ECS Service Connect (released Feb 2025)

**Current AWS Docs (Oct 2025)**:
- ECS Service Connect documented in "New" recommendations

**Impact**: Without aws-docs, would miss modern service mesh feature

---

### Example 3: Security Best Practices Update
**Training Data (Jan 2025)**:
- IMDSv1 acceptable for ECS tasks

**Current AWS Docs (Oct 2025)**:
- IMDSv2 required for all new ECS tasks (security hardening)

**Impact**: Without aws-docs, would deploy with outdated security config

---

## Tool-Specific Responsibilities

### aws-docs Responsibilities
- ✅ CURRENT best practices (post-training updates)
- ✅ Service limits (current quotas, not outdated limits)
- ✅ New features (released after training)
- ✅ Security recommendations (latest threat landscape)
- ✅ API parameters (new parameters added)
- ✅ Related content discovery (new guides, features)
- ❌ Infrastructure state (delegate to aws-api)
- ❌ Resource inventory (delegate to aws-api)

### aws-api Responsibilities
- ✅ Infrastructure inventory (existing resources)
- ✅ Resource details (configurations, state)
- ✅ Validation queries (verify prerequisites)
- ✅ Post-deployment validation (confirm success)
- ❌ Write operations (READ_ONLY mode for safety)
- ❌ Documentation lookup (delegate to aws-docs)

### Why Both Tools Required
- **aws-docs alone**: Current knowledge but no infrastructure state
- **aws-api alone**: Infrastructure state but outdated best practices
- **Together**: Informed decisions based on latest AWS knowledge + current state

---

## Common Deployment Patterns

### Pattern 1: Documentation-First Deployment
```
aws-docs (search) → aws-docs (read) → aws-docs (recommend) →
aws-api (validate) → aws-expert (design) → HUMAN (deploy) →
aws-api (verify)
```
**When**: New service deployment, unfamiliar AWS service
**Benefit**: Follow current best practices, avoid outdated patterns

### Pattern 2: New Feature Adoption
```
aws-docs (service welcome page) → aws-docs (recommend "New") →
aws-docs (read new feature docs) → aws-expert (evaluate) →
HUMAN (implement)
```
**When**: Discover and adopt features released after training
**Benefit**: Leverage latest AWS capabilities

### Pattern 3: Service Limit Verification
```
aws-docs (search quotas) → aws-docs (read limits) →
aws-expert (design within limits) → aws-api (validate)
```
**When**: Large-scale deployments, quota planning
**Benefit**: Design within CURRENT limits (not outdated training data)

---

## Best Practices

### 1. Always Start with aws-docs
- Search for best practices BEFORE designing infrastructure
- Read current documentation (not just training knowledge)
- Check "New" recommendations for post-training features
- Verify service limits (may have increased)

### 2. Validate with aws-api
- Check existing infrastructure before deployment
- Verify prerequisites exist (VPC, IAM roles, etc.)
- Get current resource state for informed decisions

### 3. Document Documentation Sources
- Record which AWS doc URLs informed design
- Note new features discovered (for team knowledge)
- Track service limit changes (for capacity planning)

### 4. Human Implements (aws-api Read-Only)
- aws-expert provides recommendations
- Human implements via Console/CLI/IaC
- aws-api validates post-deployment

### 5. Monitor for Documentation Updates
- Periodically check "New" recommendations
- Review service announcements for limit increases
- Update deployment patterns as AWS evolves

---

## Success Metrics

### Documentation Currency
- **Best practices**: 100% current (not outdated training data)
- **Service limits**: CURRENT limits (not Jan 2025 limits)
- **New features**: Discovered via "New" recommendations

### Deployment Quality
- **First-time success**: >90% (informed by current docs)
- **Security posture**: Current best practices applied
- **Cost optimization**: Right-sized based on latest guidance

### Knowledge Transfer
- **Team learning**: New features documented and shared
- **Pattern library**: Current patterns captured for reuse
- **Incident reduction**: Fewer misconfigurations from outdated knowledge

---

## Related Patterns

- **AWS Infrastructure Optimization**: (Pattern to be created)
- **ECS Deployment Runbook**: `knowledge/applications/customer-dashboard/deployment/`
- **aws-expert Agent**: `.claude/agents/specialists/aws-expert.md`

---

*Created: 2025-10-08*
*Pattern Type: Cross-Tool Integration*
*Confidence: HIGH (0.90) - Documentation currency critical*
