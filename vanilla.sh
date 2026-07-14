#!/usr/bin/env bash
set -e

# Colors for terminal output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Ensure user binary paths are in PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Bootstrap dependencies if not present globally
if ! command -v cheapwine &> /dev/null || ! command -v wine &> /dev/null; then
    echo -e "${BLUE}=== Cheapwine & Wine Global Environment Setup ===${NC}\n"

    # 1. Ensure uv is installed
    echo -e "${BLUE}[1/3] Checking uv installation...${NC}"
    if ! command -v uv &> /dev/null; then
        echo -e "${YELLOW}uv is not installed. Installing uv locally...${NC}"
        if command -v curl &> /dev/null; then
            curl -LsSf https://astral.sh/uv/install.sh | sh
        elif command -v wget &> /dev/null; then
            wget -qO- https://astral.sh/uv/install.sh | sh
        else
            echo -e "${RED}Error: Neither curl nor wget is installed. Cannot install uv automatically.${NC}"
            exit 1
        fi
        # Refresh PATH after uv install
        export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
    else
        echo -e "${GREEN}uv is already installed.${NC}"
    fi

    # 2. Install or upgrade cheapwine globally as a uv tool
    echo -e "\n${BLUE}[2/3] Installing/Upgrading cheapwine globally as a uv tool...${NC}"
    if command -v cheapwine &> /dev/null; then
        old_version=$(uv tool list | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
        upgrade_output=$(uv tool upgrade cheapwine 2>&1 || true)
        new_version=$(uv tool list | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
        if [ "$old_version" != "$new_version" ] && [ "$old_version" != "unknown" ]; then
            echo -e "${GREEN}cheapwine has been updated from $old_version to $new_version!${NC}"
        else
            echo -e "${GREEN}cheapwine is already up-to-date ($new_version).${NC}"
        fi
    else
        uv tool install cheapwine
        new_version=$(uv tool list | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}cheapwine $new_version installed successfully.${NC}"
    fi

    # 3. Install Wine and dependencies globally
    echo -e "\n${BLUE}[3/3] Installing Wine and dependencies globally...${NC}"

    if command -v apt-get &> /dev/null; then
        echo -e "${YELLOW}Updating package lists and installing packages via apt (requires sudo)...${NC}"
        sudo apt-get update
        sudo apt-get install -y wine cabextract unzip p7zip-full wget curl
    elif command -v dnf &> /dev/null; then
        echo -e "${YELLOW}Installing packages via dnf (requires sudo)...${NC}"
        sudo dnf install -y wine cabextract unzip p7zip wget curl
    elif command -v pacman &> /dev/null; then
        echo -e "${YELLOW}Installing packages via pacman (requires sudo)...${NC}"
        sudo pacman -Sy --noconfirm wine cabextract unzip p7zip wget curl
    elif command -v brew &> /dev/null; then
        echo -e "${YELLOW}Installing packages via brew...${NC}"
        brew install wine-stable cabextract unzip p7zip wget curl
    else
        echo -e "${RED}Error: Supported package manager (apt, dnf, pacman, brew) not found.${NC}"
        echo -e "Please install wine, cabextract, unzip, p7zip, and wget/curl manually."
        exit 1
    fi

    echo -e "\n${GREEN}=== Global environment setup completed successfully! ===${NC}"
else
    echo -e "${BLUE}Checking for cheapwine updates...${NC}"
    old_version=$(uv tool list | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
    upgrade_output=$(uv tool upgrade cheapwine 2>&1 || true)
    new_version=$(uv tool list | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
    if [ "$old_version" != "$new_version" ] && [ "$old_version" != "unknown" ]; then
        echo -e "${GREEN}cheapwine has been updated from $old_version to $new_version!${NC}"
    else
        echo -e "${GREEN}cheapwine is already up-to-date ($new_version).${NC}"
    fi
fi

wget -O /tmp/flstudio_win64.exe https://support.image-line.com/redirect/flstudio_win_installer
cheapwine init --runner="wine-ge" --latencyflex --tricks corefonts --tricks webview2
cheapwine run /tmp/flstudio_win64.exe "/S" || true
cheapwine add "FL Studio" FL64
cheapwine export "FL Studio"
