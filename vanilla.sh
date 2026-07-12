#!/usr/bin/env bash

# Ensure user binary paths are in PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Automatically bootstrap dependencies if not present globally
if ! command -v cheapwine &> /dev/null || ! command -v wine &> /dev/null; then
    echo "Missing global dependencies. Bootstrapping setup..."
    "$(dirname "$0")/setup.sh"
else
    # cheapwine is already installed, make sure it is the latest version
    echo "Checking for cheapwine updates..."
    uv tool upgrade cheapwine || true
fi

wget -O /tmp/flstudio_win64.exe https://support.image-line.com/redirect/flstudio_win_installer
cheapwine init --runner="kron4ek" --latencyflex --tricks corefonts --tricks webview2
cheapwine run /tmp/flstudio_win64.exe "/S"
cheapwine add "FL Studio" FL64
cheapwine export "FL Studio"
