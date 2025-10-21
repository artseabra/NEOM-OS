#!/bin/bash

# NEOM OS Installation Script
# This script sets up NEOM OS on your macOS system

set -e  # Exit on any error

# Colors for output
GREEN='\033[38;2;0;255;65m'      # Matrix green
PURPLE='\033[38;2;135;91;225m'   # artsea purple
YELLOW='\033[38;2;255;232;31m'    # Star Wars yellow
BLUE='\033[38;2;0;102;204m'      # Traditional blue
RESET='\033[0m'
BOLD='\033[1m'

# Print banner
echo -e "${GREEN}${BOLD}"
cat << "EOF"
███╗   ██╗███████╗ ██████╗ ███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝
EOF

echo -e "${PURPLE}built by:${RESET}"
echo -e "${PURPLE}"
cat << "EOF"
   ▄▀█ █▀█ ▀█▀ █▀ █▀▀ ▄▀█
   █▀█ █▀▄ ░█░ ▄█ ██▄ █▀█
EOF

echo -e "${RESET}"
echo -e "${YELLOW}${BOLD}NEOM OS Installation${RESET}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: NEOM OS requires macOS${RESET}"
    exit 1
fi

# Check for required applications
echo -e "${YELLOW}Checking dependencies...${RESET}"

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${RESET}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}✓ Homebrew found${RESET}"
fi

# Check for SoX
if ! command -v sox &> /dev/null; then
    echo -e "${YELLOW}Installing SoX...${RESET}"
    brew install sox
else
    echo -e "${GREEN}✓ SoX found${RESET}"
fi

# Check for jq
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}Installing jq...${RESET}"
    brew install jq
else
    echo -e "${GREEN}✓ jq found${RESET}"
fi

# Check for Warp Terminal
if ! [ -d "/Applications/Warp.app" ]; then
    echo -e "${YELLOW}⚠️  Warp Terminal not found. Please install from https://www.warp.dev/${RESET}"
    echo -e "${BLUE}   Warp is required for the NEOM OS interface${RESET}"
else
    echo -e "${GREEN}✓ Warp Terminal found${RESET}"
fi

# Check for Raycast
if ! [ -d "/Applications/Raycast.app" ]; then
    echo -e "${YELLOW}⚠️  Raycast not found. Please install from https://raycast.com/${RESET}"
    echo -e "${BLUE}   Raycast is required for launching NEOM OS${RESET}"
else
    echo -e "${GREEN}✓ Raycast found${RESET}"
fi

echo ""

# Set up environment variables
echo -e "${YELLOW}Setting up environment...${RESET}"

# Set NEOM_OS_HOME to the standard location
NEOM_OS_HOME="$HOME/.neom-os"

# Add NEOM_OS_HOME to shell profile
SHELL_PROFILE=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_PROFILE="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_PROFILE="$HOME/.bash_profile"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_PROFILE="$HOME/.bashrc"
fi

if [ -n "$SHELL_PROFILE" ]; then
    # Add NEOM_OS_HOME if not already present
    if ! grep -q "NEOM_OS_HOME" "$SHELL_PROFILE"; then
        echo "" >> "$SHELL_PROFILE"
        echo "# NEOM OS Configuration" >> "$SHELL_PROFILE"
        echo "export NEOM_OS_HOME=\"$NEOM_OS_HOME\"" >> "$SHELL_PROFILE"
        echo "export PATH=\"\$NEOM_OS_HOME:\$PATH\"" >> "$SHELL_PROFILE"
        echo -e "${GREEN}✓ Added NEOM_OS_HOME to $SHELL_PROFILE${RESET}"
    else
        echo -e "${GREEN}✓ NEOM_OS_HOME already configured${RESET}"
    fi
fi

# Make scripts executable
echo -e "${YELLOW}Setting up scripts...${RESET}"
chmod +x "$NEOM_OS_HOME/neom-home"
chmod +x "$NEOM_OS_HOME/neom-transcriber"
chmod +x "$NEOM_OS_HOME/neom-os.sh"
chmod +x "$NEOM_OS_HOME/neom-welcome"
chmod +x "$NEOM_OS_HOME/neom-warp-welcome"
echo -e "${GREEN}✓ Scripts made executable${RESET}"

# Create recordings directory
mkdir -p "$NEOM_OS_HOME/recordings"
echo -e "${GREEN}✓ Created recordings directory${RESET}"

# Create .env file if it doesn't exist
if [ ! -f "$NEOM_OS_HOME/.env" ]; then
    cat > "$NEOM_OS_HOME/.env" << 'EOF'
# NEOM OS Environment Variables
# This file contains sensitive API keys and should not be committed to git

export OPENAI_API_KEY="your-openai-api-key-here"
export NOTION_DATABASE_ID="your-notion-database-id-here"
export NOTION_API_KEY="your-notion-api-key-here"
EOF
    echo -e "${GREEN}✓ Created .env file template${RESET}"
    echo -e "${YELLOW}⚠️  Please edit $NEOM_OS_HOME/.env with your actual API keys${RESET}"
else
    echo -e "${GREEN}✓ .env file already exists${RESET}"
fi

# Check for OpenAI API key
echo ""
echo -e "${YELLOW}Checking OpenAI API key...${RESET}"
if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${YELLOW}⚠️  OPENAI_API_KEY not set${RESET}"
    echo -e "${BLUE}   Please set your OpenAI API key:${RESET}"
    echo -e "${BLUE}   export OPENAI_API_KEY=\"your-api-key-here\"${RESET}"
    echo -e "${BLUE}   Add this to your $SHELL_PROFILE${RESET}"
else
    echo -e "${GREEN}✓ OpenAI API key found${RESET}"
fi

echo ""
echo -e "${YELLOW}${BOLD}Installation Complete!${RESET}"
echo ""
echo -e "${BLUE}Next steps:${RESET}"
echo -e "${BLUE}1. Set up your OpenAI API key if you haven't already${RESET}"
echo -e "${BLUE}2. Import neom-os.sh as a Raycast command${RESET}"
echo -e "${BLUE}3. Set your preferred keyboard shortcut${RESET}"
echo -e "${BLUE}4. Run 'neom-home' to start using NEOM OS${RESET}"
echo ""
echo -e "${GREEN}Welcome to NEOM OS! 🚀${RESET}"
