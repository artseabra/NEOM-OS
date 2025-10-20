#!/bin/bash

# NEOM OS GitHub Setup Helper
# This script helps prepare the project for GitHub

set -e

# Colors
GREEN='\033[38;2;0;255;65m'
PURPLE='\033[38;2;135;91;225m'
YELLOW='\033[38;2;255;232;31m'
BLUE='\033[38;2;0;102;204m'
RESET='\033[0m'
BOLD='\033[1m'

echo -e "${GREEN}${BOLD}NEOM OS GitHub Setup Helper${RESET}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Initializing git repository...${RESET}"
    git init
    echo -e "${GREEN}✓ Git repository initialized${RESET}"
else
    echo -e "${GREEN}✓ Git repository already exists${RESET}"
fi

# Check git status
echo -e "${YELLOW}Checking git status...${RESET}"
git status --porcelain

echo ""
echo -e "${YELLOW}${BOLD}Next Steps:${RESET}"
echo ""
echo -e "${BLUE}1. Create a new repository on GitHub:${RESET}"
echo -e "${BLUE}   - Go to https://github.com/new${RESET}"
echo -e "${BLUE}   - Name it 'NEOM-OS'${RESET}"
echo -e "${BLUE}   - Make it public or private${RESET}"
echo -e "${BLUE}   - Don't initialize with README (we already have one)${RESET}"
echo ""
echo -e "${BLUE}2. Add the remote origin:${RESET}"
echo -e "${BLUE}   git remote add origin https://github.com/YOUR_USERNAME/NEOM-OS.git${RESET}"
echo ""
echo -e "${BLUE}3. Add and commit all files:${RESET}"
echo -e "${BLUE}   git add .${RESET}"
echo -e "${BLUE}   git commit -m 'Initial commit: NEOM OS v1.0.1'${RESET}"
echo ""
echo -e "${BLUE}4. Push to GitHub:${RESET}"
echo -e "${BLUE}   git branch -M main${RESET}"
echo -e "${BLUE}   git push -u origin main${RESET}"
echo ""
echo -e "${BLUE}5. Set up GitHub Pages (optional):${RESET}"
echo -e "${BLUE}   - Go to Settings > Pages${RESET}"
echo -e "${BLUE}   - Source: Deploy from a branch${RESET}"
echo -e "${BLUE}   - Branch: main${RESET}"
echo -e "${BLUE}   - Folder: /docs${RESET}"
echo ""
echo -e "${GREEN}Your NEOM OS project is ready for GitHub! 🚀${RESET}"
