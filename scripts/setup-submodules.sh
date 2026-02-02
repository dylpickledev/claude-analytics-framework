#!/bin/bash
# Setup git submodules for new clones of this repository
# Run this after cloning the repository for the first time

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Setting up ADLC Agent Hub submodules...${NC}\n"

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$REPO_ROOT"

# Check if .gitmodules exists
if [ ! -f ".gitmodules" ]; then
  echo -e "${YELLOW}⚠️  No .gitmodules file found.${NC}"
  echo -e "${YELLOW}This repository may not have submodules configured yet.${NC}\n"

  echo -e "${BLUE}Would you like to configure submodules from config/repositories.json? (y/n)${NC}"
  read -r response

  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Running submodule configuration...${NC}\n"
    bash "$SCRIPT_DIR/convert-to-submodules.sh"
    exit 0
  else
    echo -e "${YELLOW}Skipping submodule setup.${NC}"
    exit 0
  fi
fi

# Initialize and update submodules
echo -e "${BLUE}📦 Initializing submodules...${NC}"
git submodule init

echo -e "\n${BLUE}🔄 Updating submodules to latest versions...${NC}"
git submodule update --init --recursive --remote

echo -e "\n${GREEN}✅ Submodule setup complete!${NC}\n"

# Show status
echo -e "${BLUE}📋 Submodule status:${NC}"
git submodule status

echo -e "\n${BLUE}Useful submodule commands:${NC}"
echo -e "  • Update all: ${YELLOW}git submodule update --remote${NC}"
echo -e "  • Update one: ${YELLOW}git submodule update --remote <path>${NC}"
echo -e "  • Check status: ${YELLOW}git submodule status${NC}"
echo -e "  • Pull all changes: ${YELLOW}git submodule foreach 'git pull origin \$(git rev-parse --abbrev-ref HEAD)'${NC}"
echo -e ""
