#!/bin/bash
# Cleanup internal company references for public release
# Run this script before sharing the repository publicly

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Cleaning up internal references for public release...${NC}\n"

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$REPO_ROOT"

# Backup original files
BACKUP_DIR="$REPO_ROOT/.cleanup-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo -e "${YELLOW}📦 Creating backup in: $BACKUP_DIR${NC}"

# Priority 1: Critical fixes

echo -e "\n${BLUE}=== Priority 1: Critical Fixes ===${NC}\n"

# Fix 1: Remove non-existent agent delegations in /complete
echo -e "${YELLOW}Fixing /complete agent delegations...${NC}"
cp .claude/commands/complete.md "$BACKUP_DIR/"
sed -i '' \
  -e '/#### 1\.9\.1 DELEGATE to memory-system-expert/,/^#### 1\.10 Synthesize Specialist Recommendations/d' \
  -e '/\*\*DELEGATE to documentation-expert\*\*/,/^#### 1\.10 Synthesize Specialist Recommendations/d' \
  .claude/commands/complete.md
echo -e "${GREEN}✓ Removed memory-system-expert and documentation-expert delegations${NC}"

# Fix 2: Update data-architect-role.md company reference
echo -e "${YELLOW}Genericizing data-architect-role.md...${NC}"
cp .claude/agents/roles/data-architect-role.md "$BACKUP_DIR/"
sed -i '' 's/Granite Rock D&A ecosystem/your data ecosystem/g' \
  .claude/agents/roles/data-architect-role.md
echo -e "${GREEN}✓ Updated data-architect-role.md${NC}"

# Fix 3: Update github-repo-context-resolution.md
echo -e "${YELLOW}Genericizing github-repo-context-resolution.md...${NC}"
cp .claude/rules/github-repo-context-resolution.md "$BACKUP_DIR/"
sed -i '' \
  -e 's/your-org\/dbt_cloud/your-org\/dbt-project/g' \
  -e 's/react_sales_journal/react-data-app/g' \
  -e 's/roy_kent/monitoring-system/g' \
  -e 's/sherlock/investigation-tool/g' \
  -e 's/plantdemand_etl/source1-etl/g' \
  -e 's/mapistry_etl/source2-etl/g' \
  -e 's/xbe_data_ingestion/source3-ingestion/g' \
  -e 's/postgres_pipelines/database-pipelines/g' \
  -e 's/hex_pipelines/notebook-pipelines/g' \
  -e 's/streamlit_apps_snowflake/streamlit-apps/g' \
  -e 's/snowflake_notebooks/data-notebooks/g' \
  -e 's/dbt_postgres/dbt-project-secondary/g' \
  -e 's/quarryreport/legacy-reporting/g' \
  .claude/rules/github-repo-context-resolution.md
echo -e "${GREEN}✓ Updated github-repo-context-resolution.md${NC}"

# Priority 2: Highly Recommended

echo -e "\n${BLUE}=== Priority 2: Highly Recommended Fixes ===${NC}\n"

# Fix 4: Update CLAUDE.md team naming
echo -e "${YELLOW}Updating CLAUDE.md branding...${NC}"
cp CLAUDE.md "$BACKUP_DIR/"
sed -i '' \
  -e 's/DA Agent Hub/ADLC Agent Hub/g' \
  -e 's/Data & Analytics team/Analytics team/g' \
  -e 's/D&A team/Analytics team/g' \
  -e 's/da_team_documentation/team_documentation/g' \
  -e 's/da_obsidian/team_knowledge_vault/g' \
  CLAUDE.md
echo -e "${GREEN}✓ Updated CLAUDE.md${NC}"

# Fix 5: Update README.md
echo -e "${YELLOW}Updating README.md...${NC}"
if [ -f README.md ]; then
  cp README.md "$BACKUP_DIR/"
  sed -i '' \
    -e 's/DA Agent Hub/ADLC Agent Hub/g' \
    -e 's/Data & Analytics team/Analytics team/g' \
    README.md
  echo -e "${GREEN}✓ Updated README.md${NC}"
fi

# Fix 6: Update config/repositories.json
echo -e "${YELLOW}Updating config/repositories.json...${NC}"
cp config/repositories.json "$BACKUP_DIR/"
sed -i '' \
  -e 's/da_team_documentation/team_documentation/g' \
  -e 's/da_obsidian/team_knowledge_vault/g' \
  -e 's/react-sales-journal/react-data-app/g' \
  -e 's/da-app-portal/app-portal/g' \
  config/repositories.json
echo -e "${GREEN}✓ Updated config/repositories.json${NC}"

# Fix 7: Update scripts/work-init.sh
if [ -f scripts/work-init.sh ]; then
  echo -e "${YELLOW}Updating scripts/work-init.sh...${NC}"
  cp scripts/work-init.sh "$BACKUP_DIR/"
  sed -i '' \
    -e 's/da_team_documentation/team_documentation/g' \
    -e 's/da_obsidian/team_knowledge_vault/g' \
    scripts/work-init.sh
  echo -e "${GREEN}✓ Updated scripts/work-init.sh${NC}"
fi

# Fix 8: Update agent pattern files
echo -e "${YELLOW}Updating agent pattern references...${NC}"

# Update dbt-expert.md
if [ -f .claude/agents/specialists/dbt-expert.md ]; then
  cp .claude/agents/specialists/dbt-expert.md "$BACKUP_DIR/"
  sed -i '' 's/your-org/your-org/g' .claude/agents/specialists/dbt-expert.md
  echo -e "${GREEN}✓ Updated dbt-expert.md${NC}"
fi

# Update data-engineer-role.md
if [ -f .claude/agents/roles/data-engineer-role.md ]; then
  cp .claude/agents/roles/data-engineer-role.md "$BACKUP_DIR/"
  sed -i '' 's/your-org/your-org/g' .claude/agents/roles/data-engineer-role.md
  echo -e "${GREEN}✓ Updated data-engineer-role.md${NC}"
fi

# Fix 9: Update pattern docs with ui-ux-developer-role references
echo -e "${YELLOW}Updating pattern docs...${NC}"

for file in \
  .claude/skills/reference-knowledge/aws-docs-deployment-pattern/SKILL.md \
  .claude/skills/reference-knowledge/agent-mcp-integration-guide/SKILL.md \
  .claude/skills/workflows/project-completion-knowledge-extraction/SKILL.md; do

  if [ -f "$file" ]; then
    cp "$file" "$BACKUP_DIR/$(basename $file)"
    # Replace ui-ux-developer-role with generic frontend-developer-role
    sed -i '' 's/ui-ux-developer-role/frontend-developer-role/g' "$file"
    echo -e "${GREEN}✓ Updated $(basename $file)${NC}"
  fi
done

# Fix 10: Update sales-journal references
echo -e "${YELLOW}Replacing sales-journal app references...${NC}"
find . -type f -name "*.md" ! -path "./.cleanup-backup-*/*" -exec sed -i '' \
  -e 's/sales-journal/customer-dashboard/g' \
  -e 's/Sales Journal/Customer Dashboard/g' \
  -e 's/react-sales-journal/react-customer-dashboard/g' \
  {} +
echo -e "${GREEN}✓ Replaced sales-journal references${NC}"

# Summary
echo -e "\n${GREEN}✅ Cleanup complete!${NC}\n"
echo -e "${BLUE}Changes made:${NC}"
echo -e "  • Removed non-existent agent delegations (memory-system-expert, documentation-expert)"
echo -e "  • Genericized company name (Granite Rock → your organization)"
echo -e "  • Updated team branding (DA Agent Hub → ADLC Agent Hub)"
echo -e "  • Replaced internal repository names with generic examples"
echo -e "  • Updated internal app references (sales-journal → customer-dashboard)"
echo -e "  • Renamed team repos (da_team_documentation → team_documentation)"
echo -e ""
echo -e "${YELLOW}Backup location:${NC} $BACKUP_DIR"
echo -e ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Review changes: ${YELLOW}git diff${NC}"
echo -e "  2. Test the changes work correctly"
echo -e "  3. Commit: ${YELLOW}git add -A && git commit -m 'chore: Remove internal references for public release'${NC}"
echo -e "  4. Run submodule conversion: ${YELLOW}./scripts/convert-to-submodules.sh${NC}"
echo -e ""
