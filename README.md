# 🍇 getfruity

A self-contained, zero-configuration, one-command installer for **FL Studio 2026** on Linux. Featuring full out-of-the-box integration with **FL Cloud** and the **Gopher AI Assistant**.

---

## 🚀 Overview

**getfruity** is designed to provide a perfect global installation of FL Studio on Linux systems. It installs **cheapwine** globally using `uv tool` and installs other system dependencies (`wine`, etc.) using your distribution's native package manager.

### ✨ Key Features

* **Seamless Unlock**: FL Studio can be unlocked directly from the browser in this installation.
* **Native System Integration**: After installation, FL Studio is available as a normal application on your host Linux system.
* **Multiple Flavors / One-Command Install**: Choose from three installer scripts: `./vanilla.sh` (standard), `./natural.sh` (includes Copycat), or `./maestro.sh` (includes Copycat + classic Edirol Orchestral VST).
* **Mozart Downloader**: All plugin and software installers are fetched reliably via `mozart_downloader`.
* **Optimized Wine Runner & Environment**: Powered by `cheapwine` using the `wine-d2d1` runner, custom low-latency environment overrides, and bundled winetricks (`corefonts`, `webview2`, `vcrun2015`, `tahoma`, `nocrashdialog`).
* **Global CLI Tools**: Installs `cheapwine` and `gdown` globally using the `uv` tool manager with `--no-cache` upgrade checks.
* **FL Cloud Integration**: Full support for Image-Line's FL Cloud sounds, mastering, and cloud services.
* **Gopher AI Assistant**: Out-of-the-box support for the integrated AI assistant for smart music generation and workflow helpers.
* **Automatic Bootstrapping**: Automatically detects and installs all missing host and Wine environment dependencies (`uv`, `cheapwine`, `gdown`, `wine`, and utility packages).

---

## 🛠️ How it Works

The installer automates environment setup, dependency management, software downloading, and desktop integration:

```mermaid
graph TD
    A["vanilla.sh, natural.sh, or maestro.sh"] -->|Check dependencies| B{"Dependencies present?"}
    B -->|No| C[Bootstrap Setup]
    C -->|1. Install| D[uv]
    C -->|2. Install tools| E["cheapwine & gdown (uv --no-cache)"]
    C -->|3. System packages| F["wine, cabextract, unzip, 7zip, p7zip, unrar, wget, curl"]
    B -->|Yes| G["Upgrade CLI Tools"]
    G --> H["Download via mozart_downloader"]
    C --> H
    H -->|Initialize Prefix with wine-d2d1 & tricks| I["cheapwine init --runner=wine-d2d1 --tricks --env"]
    I -->|Run Installers| J[cheapwine run]
    J -->|Register App| K[cheapwine add]
    K -->|Export Desktop Entry| L[cheapwine export]
```

**vanilla.sh**: The standard installer flavor. Bootstraps/upgrades `cheapwine` and system utilities, downloads FL Studio 2026 via `mozart_downloader`, initializes the `wine-d2d1` Wine prefix, installs FL Studio 2026, and exports it to the host desktop.

**natural.sh**: The natural installer flavor. In addition to standard bootstrapping/installation, it downloads and installs the **Copycat** plugin (which lets you create melodies with a microphone and your voice).

**maestro.sh**: The maestro installer flavor. In addition to the Copycat plugin and standard setup, it downloads and extracts the classic **Edirol Orchestral VST**, and automatically applies a [registry/wrapper compatibility patch](https://github.com/HeapHeapHooray/edirol-orchestral-patch) so the VST runs flawlessly in FL Studio under Wine.

---

## 🏁 Getting Started

### 📋 Prerequisites

An active internet connection and `sudo` access (to allow your package manager to install `wine` and other system tools).

### 🏃 Quick Start

Simply clone this repository and run one of the installer scripts:

**Vanilla (Standard FL Studio 2026):**
```bash
chmod +x vanilla.sh
./vanilla.sh
```

**Natural (Includes the Copycat plugin for creating melodies via microphone/voice):**
```bash
chmod +x natural.sh
./natural.sh
```

**Maestro (Includes Copycat + classic [Edirol Orchestral VST patched](https://github.com/HeapHeapHooray/edirol-orchestral-patch) for Wine):**
```bash
chmod +x maestro.sh
./maestro.sh
```

---

## 🔧 Under the Hood

### Dependencies Installed
The bootstrapping logic handles installing the following tools globally:
* **cheapwine**: Installed globally via `uv tool install --no-cache cheapwine` (located in `~/.local/bin`)
* **gdown**: Installed globally via `uv tool install --no-cache gdown` (to download files from Google Drive)
* **wine**: The Windows compatibility layer
* **cabextract, unzip, 7zip, p7zip, unrar**: Core archiving utilities needed to extract packages/DLLs
* **wget, curl**: Networking utilities

---

## 🙏 Credits

* **Gemini**: For AI assistance and code generation.
* **DeepSeek**: For AI assistance and code generation.
