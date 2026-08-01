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
if ! command -v cheapwine &> /dev/null || ! command -v wine &> /dev/null || ! command -v gdown &> /dev/null || ! command -v unrar &> /dev/null || ! command -v 7z &> /dev/null; then
    echo -e "${BLUE}=== Cheapwine, Wine, Gdown, 7zip & Unrar Global Environment Setup ===${NC}\n"

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
        old_version=$(uv tool list --no-cache | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
        upgrade_output=$(uv tool upgrade --no-cache cheapwine 2>&1 || true)
        new_version=$(uv tool list --no-cache | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
        if [ "$old_version" != "$new_version" ] && [ "$old_version" != "unknown" ]; then
            echo -e "${GREEN}cheapwine has been updated from $old_version to $new_version!${NC}"
        else
            echo -e "${GREEN}cheapwine is already up-to-date ($new_version).${NC}"
        fi
    else
        uv tool install --no-cache cheapwine
        new_version=$(uv tool list --no-cache | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}cheapwine $new_version installed successfully.${NC}"
    fi

    # 3. Install or upgrade gdown globally as a uv tool
    echo -e "\n${BLUE}[3/4] Installing/Upgrading gdown globally as a uv tool...${NC}"
    if command -v gdown &> /dev/null; then
        old_gdown_version=$(uv tool list --no-cache | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
        upgrade_gdown_output=$(uv tool upgrade --no-cache gdown 2>&1 || true)
        new_gdown_version=$(uv tool list --no-cache | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
        if [ "$old_gdown_version" != "$new_gdown_version" ] && [ "$old_gdown_version" != "unknown" ]; then
            echo -e "${GREEN}gdown has been updated from $old_gdown_version to $new_gdown_version!${NC}"
        else
            echo -e "${GREEN}gdown is already up-to-date ($new_gdown_version).${NC}"
        fi
    else
        uv tool install --no-cache gdown
        new_gdown_version=$(uv tool list --no-cache | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}gdown $new_gdown_version installed successfully.${NC}"
    fi

    # 4. Install Wine and dependencies globally
    echo -e "\n${BLUE}[4/4] Installing Wine and dependencies globally...${NC}"

    if command -v apt-get &> /dev/null; then
        echo -e "${YELLOW}Updating package lists and installing packages via apt (requires sudo)...${NC}"
        sudo apt-get update
        sudo apt-get install -y wine cabextract unzip 7zip p7zip-full unrar wget curl || sudo apt-get install -y wine cabextract unzip p7zip-full unrar wget curl
    elif command -v dnf &> /dev/null; then
        echo -e "${YELLOW}Installing packages via dnf (requires sudo)...${NC}"
        sudo dnf install -y wine cabextract unzip 7zip p7zip unrar wget curl || sudo dnf install -y wine cabextract unzip p7zip unrar wget curl
    elif command -v pacman &> /dev/null; then
        echo -e "${YELLOW}Installing packages via pacman (requires sudo)...${NC}"
        sudo pacman -Sy --noconfirm wine cabextract unzip 7zip p7zip unrar wget curl || sudo pacman -Sy --noconfirm wine cabextract unzip p7zip unrar wget curl
    elif command -v brew &> /dev/null; then
        echo -e "${YELLOW}Installing packages via brew...${NC}"
        brew install wine-stable cabextract unzip 7zip p7zip unrar wget curl || brew install wine-stable cabextract unzip p7zip unrar wget curl
    else
        echo -e "${RED}Error: Supported package manager (apt, dnf, pacman, brew) not found.${NC}"
        echo -e "Please install wine, cabextract, unzip, 7zip, p7zip, unrar, and wget/curl manually."
        exit 1
    fi

    echo -e "\n${GREEN}=== Global environment setup completed successfully! ===${NC}"
else
    echo -e "${BLUE}Checking for updates...${NC}"

    # cheapwine
    old_version=$(uv tool list --no-cache | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
    upgrade_output=$(uv tool upgrade --no-cache cheapwine 2>&1 || true)
    new_version=$(uv tool list --no-cache | grep "^cheapwine " | awk '{print $2}' 2>/dev/null || echo "unknown")
    if [ "$old_version" != "$new_version" ] && [ "$old_version" != "unknown" ]; then
        echo -e "${GREEN}cheapwine has been updated from $old_version to $new_version!${NC}"
    else
        echo -e "${GREEN}cheapwine is already up-to-date ($new_version).${NC}"
    fi

    # gdown
    old_gdown_version=$(uv tool list --no-cache | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
    upgrade_gdown_output=$(uv tool upgrade --no-cache gdown 2>&1 || true)
    new_gdown_version=$(uv tool list --no-cache | grep "^gdown " | awk '{print $2}' 2>/dev/null || echo "unknown")
    if [ "$old_gdown_version" != "$new_gdown_version" ] && [ "$old_gdown_version" != "unknown" ]; then
        echo -e "${GREEN}gdown has been updated from $old_gdown_version to $new_gdown_version!${NC}"
    else
        echo -e "${GREEN}gdown is already up-to-date ($new_gdown_version).${NC}"
    fi
fi

# Execute mozart_downloader scripts in-place via stdin
echo -e "${BLUE}Downloading FL Studio installer via mozart_downloader...${NC}"
curl -sSL https://raw.githubusercontent.com/HeapHeapHooray/mozart_downloader/main/download_flstudio.sh | bash -s -- /tmp/flstudio_win64.exe

echo -e "${BLUE}Downloading EDIROL Orchestral VST via mozart_downloader...${NC}"
curl -sSL https://raw.githubusercontent.com/HeapHeapHooray/mozart_downloader/main/download_edirol.sh | bash -s -- /tmp/edirol_orchestral.rar

echo -e "${BLUE}Downloading Copycat installer via mozart_downloader...${NC}"
curl -sSL https://raw.githubusercontent.com/HeapHeapHooray/mozart_downloader/main/download_copycat.sh | bash -s -- /tmp/copycat-windows.zip

echo -e "${BLUE}Downloading Synful Orchestra installer via mozart_downloader...${NC}"
curl -sSL https://raw.githubusercontent.com/HeapHeapHooray/mozart_downloader/main/download_synful_orchestra.sh | bash -s -- /tmp/synful_orchestra.zip

echo -e "${BLUE}Downloading Native Access installer via mozart_downloader...${NC}"
curl -sSL https://raw.githubusercontent.com/HeapHeapHooray/mozart_downloader/main/download_native_access.sh | bash -s -- /tmp/native_access_setup.exe

mkdir -p /tmp/edirol_maestro/
mkdir -p /tmp/native_access_extracted/
unrar x -o+ /tmp/edirol_orchestral.rar /tmp/edirol_maestro/
unzip -o /tmp/copycat-windows.zip -d /tmp/copycat_installer_windows
unzip -o /tmp/synful_orchestra.zip -d /tmp/synful_installer

echo -e "${BLUE}Extracting Native Access installer...${NC}"
7z x -y -o/tmp/native_access_extracted /tmp/native_access_setup.exe
PLUGINS_DIR=$(find /tmp/native_access_extracted/ -type d -name "\$PLUGINSDIR" -print -quit 2>/dev/null || echo "/tmp/native_access_extracted/\$PLUGINSDIR")
if [ -f "${PLUGINS_DIR}/app-64.7z" ]; then
    (cd "${PLUGINS_DIR}" && 7z x -y app-64.7z)
fi

cheapwine init --runner="wine-d2d1" --env "WINEDLLOVERRIDES=d3d11=b;dxgi=b;d3d9=b" --env "_JAVA_AWT_WM_NONREPARENTING=1" --env "_JAVA_OPTIONS=-Dprism.order=sw -Dprism.lcdtext=false -Dglass.win.uiScale=1.0" --env "WINEDLLOVERRIDES=d3d11=b;dxgi=b;d3d9=b;mfc140=b;msxml3=b;gdiplus=b" --env "WINEDBG_FLAGS=nodialog" --latencyflex --tricks corefonts --tricks webview2 --tricks vcrun2015 --tricks tahoma --tricks nocrashdialog --tricks powershell

cheapwine run /tmp/copycat_installer_windows/copycat_installer.exe "--silent" || true
cheapwine run /tmp/synful_installer/SynfulOrchestraSetup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- || true
cheapwine run /tmp/edirol_maestro/setup-ttdown.EXE "/S" || true

# Windows has C:\Users\Public\Downloads but Wine prefixes don't create it.
# The NTK Daemon expects it as its default download location (otherwise it
# logs "Required part of default location does not exist" on startup).
mkdir -p "${PWD}/.cheapwine/drive_c/users/Public/Downloads"

NA_INSTALL_DIR="${PWD}/.cheapwine/drive_c/Program Files/Native Instruments/Native Access"
mkdir -p "${NA_INSTALL_DIR}"
if [ -d "${PLUGINS_DIR}" ]; then
    cp -r "${PLUGINS_DIR}"/* "${NA_INSTALL_DIR}/" 2>/dev/null || true
fi

NTK_EXE=$(find "${NA_INSTALL_DIR}/resources/daemon" -type f -name "*.exe" ! -path "*/__MACOSX/*" ! -name "._*" -print -quit 2>/dev/null || true)
if [ -n "${NTK_EXE}" ] && [ -f "${NTK_EXE}" ]; then
    echo -e "${BLUE}Installing NTK Daemon...${NC}"
    # Kill stale daemons from previous sessions first, otherwise the freshly
    # started daemon dies with "Address in use" (ports 5146/5563/7865 squatted)
    pkill -f NTKDaemon.exe 2>/dev/null || true
    # The silent installer can die instantly on a freshly-created prefix
    # (wineserver still initializing), leaving nothing behind. Verify via
    # install.json and retry a few times instead of trusting the exit code.
    NTK_INSTALL_JSON="${PWD}/.cheapwine/drive_c/users/Public/Documents/Native Instruments/NTK/install.json"
    ntk_attempt=0
    while [ ! -f "${NTK_INSTALL_JSON}" ] && [ "${ntk_attempt}" -lt 3 ]; do
        ntk_attempt=$((ntk_attempt+1))
        cheapwine run "${NTK_EXE}" /S SILENT=TRUE || true
        sleep 3
    done
    # Native Access refuses to start without this file (falls into the broken
    # elevated-reinstall path -> "Please grant permission..." dialog)
    if [ -f "${NTK_INSTALL_JSON}" ]; then
        echo -e "${GREEN}NTK Daemon installed (install.json present, attempt ${ntk_attempt}).${NC}"
    else
        echo -e "${RED}⚠️ Error: NTK Daemon install failed after ${ntk_attempt} attempts (install.json missing). Native Access will not start.${NC}"
    fi
fi

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



# Write Native Access launcher batch script
# Native Access cannot start NTKDaemonService itself under Wine (its elevation
# goes through a PowerShell stub), and it STOPS the service whenever it cannot
# reach it. So the launcher must guarantee the daemon is RUNNING before the app
# starts. The retry loop covers cold wineserver boots, where the first service
# start can die on a control handshake timeout (sc query exit code 1077).
NATIVE_ACCESS_BAT="${PREFIX_PATH}/drive_c/launch_native_access.bat"
echo -e "\n${BLUE}Generating Native Access launcher script (NTK Daemon service)...${NC}"
cat << 'EOF' > "${NATIVE_ACCESS_BAT}"
@echo off
rem Start NTKDaemonService and wait until it is actually RUNNING.
rem The first start on a cold wineserver boot can fail (service control
rem handshake timeout while services.exe is still initializing), so retry.
setlocal
set /a tries=0
:retry
net start NTKDaemonService >nul 2>&1
set /a waits=0
:waitrun
sc query NTKDaemonService | find "RUNNING" >nul && goto running
ping -n 3 127.0.0.1 >nul
set /a waits+=1
if %waits% lss 25 goto waitrun
set /a tries+=1
if %tries% lss 4 goto retry
:running
rem give the daemon a few seconds to bind its IPC ports
ping -n 4 127.0.0.1 >nul
start "" "C:\Program Files\Native Instruments\Native Access\Native Access.exe" %*
rem Resize Native Access window up by 10% when it opens, forcing a redraw so the interface shows up, known Wine bug.
start /b powershell -NoProfile -ExecutionPolicy Bypass -Command "$code = 'using System; using System.Runtime.InteropServices; public class Win32 { [DllImport(\"user32.dll\")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect); [DllImport(\"user32.dll\")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint); } [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }'; Add-Type -TypeDefinition $code; $hwnd = [IntPtr]::Zero; for ($i = 0; $i -lt 40; $i++) { Start-Sleep -Milliseconds 500; $procs = Get-Process -Name 'Native Access' -ErrorAction SilentlyContinue; foreach ($p in $procs) { if ($p.MainWindowHandle -ne [IntPtr]::Zero) { $hwnd = $p.MainWindowHandle; break } }; if ($hwnd -ne [IntPtr]::Zero) { break } }; if ($hwnd -ne [IntPtr]::Zero) { $rect = New-Object RECT; if ([Win32]::GetWindowRect($hwnd, [ref]$rect)) { $w = $rect.Right - $rect.Left; $h = $rect.Bottom - $rect.Top; $nw = [int]($w * 1.10); $nh = [int]($h * 1.10); [Win32]::MoveWindow($hwnd, $rect.Left, $rect.Top, $nw, $nh, $true) } }"
endlocal
EOF
# CRLF line endings are required for cmd label/goto parsing
sed -i 's/$/\r/' "${NATIVE_ACCESS_BAT}"
cp "${NATIVE_ACCESS_BAT}" "${PREFIX_PATH}/launch_native_access.bat"

cheapwine add "FL Studio" FL64
cheapwine export "FL Studio"

cheapwine extract_icon "C:\Program Files\Native Instruments\Native Access\Native Access.exe" "./.cheapwine/drive_c/native_access_icon.ico" || true
cheapwine add "Native Access" "C:\launch_native_access.bat" --icon "./.cheapwine/drive_c/native_access_icon.ico" || true
cheapwine export "Native Access" || true
