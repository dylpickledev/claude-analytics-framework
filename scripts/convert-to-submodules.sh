#!/bin/bash
# Convert cloned repositories to git submodules
# Reads from config/repositories.json and sets up submodules

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}🔄 Converting to Git Submodules Strategy${NC}\n"

cd "$REPO_ROOT"

# Check if repositories.json exists
if [ ! -f "config/repositories.json" ]; then
  echo -e "${RED}❌ config/repositories.json not found!${NC}"
  echo -e "${YELLOW}Copy config/repositories.json.example and customize for your repos${NC}"
  exit 1
fi

# Function to extract JSON values (simple jq alternative)
get_json_value() {
  local json_file=$1
  local key_path=$2
  python3 -c "import json; data=json.load(open('$json_file')); print($key_path)" 2>/dev/null || echo ""
}

# Parse repositories.json
echo -e "${YELLOW}📖 Reading config/repositories.json...${NC}\n"

# Backup existing repos directory if it exists
if [ -d "repos" ] || [ -d "knowledge/team_documentation" ] || [ -d "knowledge/team_knowledge_vault" ]; then
  BACKUP_DIR="$REPO_ROOT/.repo-backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP_DIR"

  echo -e "${YELLOW}📦 Backing up existing repositories to: $BACKUP_DIR${NC}"

  [ -d "repos" ] && cp -r repos "$BACKUP_DIR/"
  [ -d "knowledge/team_documentation" ] && cp -r knowledge/team_documentation "$BACKUP_DIR/"
  [ -d "knowledge/team_knowledge_vault" ] && cp -r knowledge/team_knowledge_vault "$BACKUP_DIR/"

  echo -e "${GREEN}✓ Backup created${NC}\n"

  # Remove existing repos (they'll be replaced with submodules)
  echo -e "${YELLOW}🗑️  Removing existing repository clones...${NC}"
  rm -rf repos
  rm -rf knowledge/team_documentation
  rm -rf knowledge/team_knowledge_vault
  echo -e "${GREEN}✓ Cleaned up${NC}\n"
fi

# Function to add submodule from config
add_submodule() {
  local category=$1
  local repo_key=$2
  local url=$(python3 -c "import json; data=json.load(open('config/repositories.json')); print(data['$category']['$repo_key']['url'])")
  local branch=$(python3 -c "import json; data=json.load(open('config/repositories.json')); print(data['$category']['$repo_key'].get('branch', 'main'))")
  local folder=$(python3 -c "import json; data=json.load(open('config/repositories.json')); print(data['$category']['$repo_key'].get('folder', 'repos/$category/$repo_key'))")

  # Skip if URL is "local" or contains "your-org" (placeholder)
  if [[ "$url" == "local" ]] || [[ "$url" == *"your-org"* ]]; then
    echo -e "${YELLOW}⊘ Skipping $repo_key (placeholder URL)${NC}"
    return
  fi

  # Add submodule
  echo -e "${BLUE}  Adding: $repo_key → $folder (branch: $branch)${NC}"

  # Create parent directory if needed
  mkdir -p "$(dirname "$folder")"

  # Add submodule
  git submodule add -b "$branch" "$url" "$folder" 2>/dev/null || {
    echo -e "${YELLOW}    Already exists, skipping...${NC}"
  }

  echo -e "${GREEN}  ✓ $repo_key added${NC}"
}

# Add knowledge repositories
echo -e "${BLUE}=== Knowledge Repositories ===${NC}\n"

if python3 -c "import json; data=json.load(open('config/repositories.json')); exit(0 if 'knowledge' in data else 1)"; then
  for repo_key in $(python3 -c "import json; data=json.load(open('config/repositories.json')); print(' '.join(data['knowledge'].keys()))"); do
    add_submodule "knowledge" "$repo_key"
  done
  echo ""
fi

# Add data stack repositories
echo -e "${BLUE}=== Data Stack Repositories ===${NC}\n"

if python3 -c "import json; data=json.load(open('config/repositories.json')); exit(0 if 'data_stack' in data else 1)"; then
  for category in orchestration ingestion transformation front_end operations; do
    echo -e "${YELLOW}${category}:${NC}"

    if python3 -c "import json; data=json.load(open('config/repositories.json')); exit(0 if '$category' in data.get('data_stack', {}) else 1)"; then
      for repo_key in $(python3 -c "import json; data=json.load(open('config/repositories.json')); print(' '.join(data['data_stack']['$category'].keys()))" 2>/dev/null || echo ""); do
        add_submodule "data_stack.$category" "$repo_key"
      done
    fi
    echo ""
  done
fi

# Initialize and update all submodules
echo -e "${BLUE}🔄 Initializing submodules...${NC}"
git submodule init
git submodule update --remote

echo -e "\n${GREEN}✅ Submodule conversion complete!${NC}\n"

# Show submodules
echo -e "${BLUE}📋 Configured submodules:${NC}"
git submodule status

echo -e "\n${BLUE}Next steps:${NC}"
echo -e "  1. Review submodules: ${YELLOW}git submodule status${NC}"
echo -e "  2. Update submodules: ${YELLOW}git submodule update --remote${NC}"
echo -e "  3. Commit .gitmodules: ${YELLOW}git add .gitmodules && git commit -m 'feat: Convert to git submodules'${NC}"
echo -e "  4. Update documentation: Run ${YELLOW}./scripts/update-submodule-docs.sh${NC}"
echo -e ""
echo -e "${YELLOW}Note:${NC} Other developers will need to run:"
echo -e "  ${YELLOW}git submodule update --init --recursive${NC}"
echo -e ""
