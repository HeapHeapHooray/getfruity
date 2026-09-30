#!/usr/bin/env bash
set -e

echo "Resolving dependencies..."
curl -sSL https://raw.githubusercontent.com/HeapHeapHooray/mozart_utils/refs/heads/main/resolve_dependencies.sh | bash -s

echo "Initializing cheapwine as recommended by the mozart.sh project..."
curl -sSL https://raw.githubusercontent.com/HeapHeapHooray/mozart_utils/refs/heads/main/mozart_init.sh | bash -s

echo "Installing FL Studio..."
curl -sSL https://raw.githubusercontent.com/HeapHeapHooray/mozart_installer/refs/heads/main/install_flstudio.sh | bash -s
