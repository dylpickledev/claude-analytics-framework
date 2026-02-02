#!/bin/bash
# Update all git submodules to latest versions
# Replaces legacy clone-based approach with submodule strategy

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

echo -e "${BLUE}🔄 Updating all git submodules${NC}\n"

cd "$REPO_ROOT"

# Check if submodules are configured
if [ ! -f ".gitmodules" ]; then
  echo -e "${RED}❌ No .gitmodules file found!${NC}"
  echo -e "${YELLOW}Run ./scripts/setup-submodules.sh to configure submodules${NC}"
  exit 1
fi

# Pull main repository first
echo -e "${GREEN}📦 claude-adlc-framework (main)${NC}"
git pull origin main
echo ""

# Update all submodules
echo -e "${BLUE}=== Updating All Submodules ===${NC}\n"

# Initialize any new submodules
git submodule init

# Update all submodules to their configured branches
git submodule update --remote --recursive

# Alternative: Update each submodule individually with branch tracking
# This is more verbose but shows progress for each submodule

echo -e "\n${BLUE}=== Detailed Submodule Status ===${NC}\n"

# Get list of submodules
submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')

if [ -z "$submodules" ]; then
  echo -e "${YELLOW}No submodules configured${NC}"
else
  for submodule in $submodules; do
    if [ -d "$submodule" ]; then
      echo -e "${GREEN}📦 $(basename $submodule)${NC}"

      cd "$submodule"

      # Get current branch
      branch=$(git rev-parse --abbrev-ref HEAD)

      # Pull latest
      git pull origin "$branch" --quiet || echo -e "${YELLOW}  ⚠️  Could not pull (check credentials/access)${NC}"

      cd "$REPO_ROOT"
      echo ""
    fi
  done
fi

echo -e "${GREEN}✅ All repositories updated successfully!${NC}\n"

# Show submodule status
echo -e "${BLUE}📋 Submodule Status:${NC}"
git submodule status

echo -e "\n${BLUE}Tip:${NC} To update a specific submodule:"
echo -e "  ${YELLOW}git submodule update --remote <path>${NC}"
echo -e ""
