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
if ! command -v cheapwine &> /dev/null || ! command -v wine &> /dev/null || ! command -v gdown &> /dev/null || ! command -v unrar &> /dev/null; then
    echo -e "${BLUE}=== Cheapwine, Wine, Gdown & Unrar Global Environment Setup ===${NC}\n"

    # 1. Ensure uv is installed
    echo -e "${BLUE}[1/4] Checking uv installation...${NC}"
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
    echo -e "\n${BLUE}[2/4] Installing/Upgrading cheapwine globally as a uv tool...${NC}"
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

    # 3. Install or upgrade gdown globally as a uv tool
    echo -e "\n${BLUE}[3/4] Installing/Upgrading gdown globally as a uv tool...${NC}"
    if command -v gdown &> /dev/null; then
        old_gdown_version=$(uv tool list | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
        upgrade_gdown_output=$(uv tool upgrade gdown 2>&1 || true)
        new_gdown_version=$(uv tool list | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
        if [ "$old_gdown_version" != "$new_gdown_version" ] && [ "$old_gdown_version" != "unknown" ]; then
            echo -e "${GREEN}gdown has been updated from $old_gdown_version to $new_gdown_version!${NC}"
        else
            echo -e "${GREEN}gdown is already up-to-date ($new_gdown_version).${NC}"
        fi
    else
        uv tool install gdown
        new_gdown_version=$(uv tool list | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}gdown $new_gdown_version installed successfully.${NC}"
    fi

    # 4. Install Wine and dependencies globally
    echo -e "\n${BLUE}[4/4] Installing Wine and dependencies globally...${NC}"

    if command -v apt-get &> /dev/null; then
        echo -e "${YELLOW}Updating package lists and installing packages via apt (requires sudo)...${NC}"
        sudo apt-get update
        sudo apt-get install -y wine cabextract unzip p7zip-full unrar wget curl
    elif command -v dnf &> /dev/null; then
        echo -e "${YELLOW}Installing packages via dnf (requires sudo)...${NC}"
        sudo dnf install -y wine cabextract unzip p7zip unrar wget curl
    elif command -v pacman &> /dev/null; then
        echo -e "${YELLOW}Installing packages via pacman (requires sudo)...${NC}"
        sudo pacman -Sy --noconfirm wine cabextract unzip p7zip unrar wget curl
    elif command -v brew &> /dev/null; then
        echo -e "${YELLOW}Installing packages via brew...${NC}"
        brew install wine-stable cabextract unzip p7zip unrar wget curl
    else
        echo -e "${RED}Error: Supported package manager (apt, dnf, pacman, brew) not found.${NC}"
        echo -e "Please install wine, cabextract, unzip, p7zip, unrar, and wget/curl manually."
        exit 1
    fi

    echo -e "\n${GREEN}=== Global environment setup completed successfully! ===${NC}"
else
    echo -e "${BLUE}Checking for updates...${NC}"
    
    # cheapwine
    old_version=$(uv tool list | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
    upgrade_output=$(uv tool upgrade cheapwine 2>&1 || true)
    new_version=$(uv tool list | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
    if [ "$old_version" != "$new_version" ] && [ "$old_version" != "unknown" ]; then
        echo -e "${GREEN}cheapwine has been updated from $old_version to $new_version!${NC}"
    else
        echo -e "${GREEN}cheapwine is already up-to-date ($new_version).${NC}"
    fi

    # gdown
    old_gdown_version=$(uv tool list | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
    upgrade_gdown_output=$(uv tool upgrade gdown 2>&1 || true)
    new_gdown_version=$(uv tool list | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
    if [ "$old_gdown_version" != "$new_gdown_version" ] && [ "$old_gdown_version" != "unknown" ]; then
        echo -e "${GREEN}gdown has been updated from $old_gdown_version to $new_gdown_version!${NC}"
    else
        echo -e "${GREEN}gdown is already up-to-date ($new_gdown_version).${NC}"
    fi
fi

wget -O /tmp/flstudio_win64.exe https://support.image-line.com/redirect/flstudio_win_installer
wget -O /tmp/copycat-windows.zip https://github.com/HeapHeapHooray/Copycat/releases/latest/download/copycat-windows.zip
gdown "https://drive.google.com/file/d/1x5gnelKSljXLl_sDurlaAYBUBEov8rJr/view" -O "/tmp/edirol_orchestral.rar"
mkdir -p /tmp/edirol_maestro/
unrar x -o+ /tmp/edirol_orchestral.rar /tmp/edirol_maestro/
unzip -o /tmp/copycat-windows.zip -d /tmp/copycat_installer_windows
cheapwine init --runner="wine-ge" --latencyflex --tricks corefonts --tricks webview2
cheapwine run /tmp/copycat_installer_windows/copycat_installer.exe "--silent" || true
cheapwine run /tmp/edirol_maestro/setup-ttdown.EXE "/S" || true
cheapwine run /tmp/flstudio_win64.exe "/S" || true

# Apply EDIROL Orchestral Registry Patch
PREFIX_PATH="${PWD}/.cheapwine"
PARAM_PATH=$(find "${PREFIX_PATH}/drive_c" -type f -name "param.dat" -print -quit 2>/dev/null || true)

if [ -n "${PARAM_PATH}" ]; then
    VST_DIR=$(dirname "${PARAM_PATH}")
    echo -e "\n${BLUE}Applying EDIROL Orchestral Registry Patch...${NC}"
    echo "Found EDIROL Orchestral assets in: ${VST_DIR}"

    WINE_VST_DIR_RAW="${VST_DIR#"${PREFIX_PATH}/drive_c/"}"
    WINE_VST_DIR_RAW="${WINE_VST_DIR_RAW#"${PREFIX_PATH}/drive_c"}"
    WINE_VST_DIR="C:\\\\${WINE_VST_DIR_RAW//\//\\\\}"

    echo "Wine-internal VST path: ${WINE_VST_DIR}"

    REG_FILE=$(mktemp /tmp/orchestral_fix.XXXXXX.reg)

    cat <<EOF > "${REG_FILE}"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\\SOFTWARE\\EDIROL\\Orchestral VST]
"BaseDataFile"="${WINE_VST_DIR}\\\\param.dat"
"HelpIndex"="${WINE_VST_DIR}\\\\HELP\\\\index_e.htm"
"InstallPath"="${WINE_VST_DIR}"
"ModuleDestinations"="C:\\\\Program Files\\\\Steinberg\\\\Vstplugins\\\\EDIROL;"
"ProductID"="NO-SERIAL-HERE-IM-AFRAID"
"ProductName"="Orchestral VST Version 1.03"
"SeriesName"="High Quality Software Synthesizer"
"UserChorus"="${WINE_VST_DIR}\\\\UserChorus"
"UserOption"="${WINE_VST_DIR}\\\\UserOption"
"UserPatch"="${WINE_VST_DIR}\\\\UserPatchBank"
"UserReverb"="${WINE_VST_DIR}\\\\UserReverb"
"UserRhythm"="${WINE_VST_DIR}\\\\UserRhythmBank"
"VstAutomation"=dword:00000001

[HKEY_LOCAL_MACHINE\\SOFTWARE\\EDIROL\\Orchestral VST\\1.01]
@=""

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\EDIROL\\Orchestral VST]
"BaseDataFile"="${WINE_VST_DIR}\\\\param.dat"
"HelpIndex"="${WINE_VST_DIR}\\\\HELP\\\\index_e.htm"
"InstallPath"="${WINE_VST_DIR}"
"ModuleDestinations"="C:\\\\Program Files\\\\Steinberg\\\\Vstplugins\\\\EDIROL;"
"ProductID"="NO-SERIAL-HERE-IM-AFRAID"
"ProductName"="Orchestral VST Version 1.03"
"SeriesName"="High Quality Software Synthesizer"
"UserChorus"="${WINE_VST_DIR}\\\\UserChorus"
"UserOption"="${WINE_VST_DIR}\\\\UserOption"
"UserPatch"="${WINE_VST_DIR}\\\\UserPatchBank"
"UserReverb"="${WINE_VST_DIR}\\\\UserReverb"
"UserRhythm"="${WINE_VST_DIR}\\\\UserRhythmBank"
"VstAutomation"=dword:00000001

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\EDIROL\\Orchestral VST\\1.01]
@=""

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion]
"ProductID"="1"

[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion]
"ProductID"="1"

[HKEY_CURRENT_USER\\Software\\Image-Line\\Shared\\Plugins\\Fruity Wrapper\\Plugins\\EDIROL]
"BridgedExternalWindow"=dword:00000001
"UseFixedBuffers"=dword:00000001

[HKEY_CURRENT_USER\\Software\\Image-Line\\Shared\\Plugins\\Fruity Wrapper\\Plugins\\Orchestral]
"BridgedExternalWindow"=dword:00000001
"UseFixedBuffers"=dword:00000001

[HKEY_CURRENT_USER\\Software\\Image-Line\\Shared\\Plugins\\Fruity Wrapper\\Plugins\\EDIROL\\Orchestral]
"BridgedExternalWindow"=dword:00000001
"UseFixedBuffers"=dword:00000001

[HKEY_CURRENT_USER\\Software\\Image-Line\\Shared\\Plugins\\Fruity Wrapper\\Plugins\\VST\\Orchestral]
"BridgedExternalWindow"=dword:00000001
"UseFixedBuffers"=dword:00000001
EOF

    WINE_REG_FILE="Z:\\\\${REG_FILE//\//\\\\}"
    cheapwine wine reg import "${WINE_REG_FILE}"
    rm -f "${REG_FILE}"
    echo -e "${GREEN}✅ Success! EDIROL Orchestral registry patch applied.${NC}"
else
    echo -e "\n${YELLOW}⚠️ Warning: Could not find 'param.dat' inside the Wine prefix. Registry patch was not applied.${NC}"
fi

cheapwine add "FL Studio" FL64
cheapwine export "FL Studio"
