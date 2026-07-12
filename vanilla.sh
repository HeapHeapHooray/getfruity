#!/usr/bin/env bash

# Automatically bootstrap dependencies if not present globally
if ! command -v cheapwine &> /dev/null || ! command -v wine &> /dev/null || ! command -v winetricks &> /dev/null; then
    echo "Missing global dependencies. Bootstrapping setup..."
    "$(dirname "$0")/setup.sh"
fi

# Ensure ~/.local/bin is in the PATH (where uv tool installs cheapwine)
export PATH="$HOME/.local/bin:$PATH"

wget -O /tmp/flstudio_win64.exe https://support.image-line.com/redirect/flstudio_win_installer
cheapwine init --runner="kron4ek" --latencyflex --tricks corefonts --tricks webview2
cheapwine run /tmp/flstudio_win64.exe "/S"
cheapwine add "FL Studio" FL64
cheapwine export "FL Studio"
