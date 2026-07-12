# 🍇 getfruity

A self-contained, zero-configuration, one-command installer for **FL Studio 2026** on Linux. Featuring full out-of-the-box integration with **FL Cloud** and the **Gopher AI Assistant**.

---

## 🚀 Overview

**getfruity** is designed to provide a perfect global installation of FL Studio on Linux systems. It installs **cheapwine** globally using `uv tool` and installs other system dependencies (`wine`, etc.) using your distribution's native package manager.

### ✨ Key Features

* **Seamless Unlock**: FL Studio can be unlocked directly from the browser in this installation.
* **Native System Integration**: After installation, FL Studio is available as a normal application on your host Linux system.
* **Multiple Flavors / One-Command Install**: Choose between `./vanilla.sh` (standard) or `./natural.sh` (includes the Copycat plugin to easily create melodies with a microphone and your voice).
* **Global CLI Tools**: Installs `cheapwine` globally using the `uv` tool manager.
* **FL Cloud Integration**: Full support for Image-Line's FL Cloud sounds, mastering, and cloud services.
* **Gopher AI Assistant**: Out-of-the-box support for the integrated AI assistant for smart music generation and workflow helpers.
* **Automatic Bootstrapping**: The script automatically detects missing dependencies and installs them (uv, cheapwine, wine, and system packages).

---

## 🛠️ How it Works

The project is a single self-contained script:

```mermaid
graph TD
    A[vanilla.sh or natural.sh] -->|Check dependencies| B{cheapwine & wine present?}
    B -->|No| C[Bootstrap Setup]
    C -->|1. Install| D[uv]
    C -->|2. Install global tool| E[cheapwine]
    C -->|3. System packages| F[wine, cabextract, unzip, p7zip, wget, curl]
    B -->|Yes| G[Upgrade cheapwine]
    G --> H[Download Installer/s]
    C --> H
    H -->|Initialize Prefix| I[cheapwine init]
    I -->|Run Installer| J[cheapwine run]
    J -->|Register App| K[cheapwine add]
    K -->|Export Desktop Entry| L[cheapwine export]
```

**vanilla.sh**: The standard installer flavor. If `cheapwine` or `wine` are missing, it bootstraps them (installing `uv`, then `cheapwine` via `uv tool install`, and system packages via the native package manager). Otherwise it upgrades `cheapwine`. Then it proceeds to download and install FL Studio.

**natural.sh**: The natural installer flavor. In addition to the standard bootstrapping, it also downloads and installs the **Copycat** plugin, which lets you easily create melodies with a microphone and your voice.

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

---

## 🔧 Under the Hood

### Dependencies Installed
The bootstrapping logic handles installing the following tools globally:
* **cheapwine**: Installed globally via `uv tool install cheapwine` (located in `~/.local/bin`)
* **wine**: The Windows compatibility layer
* **cabextract, unzip, p7zip**: Core archiving utilities needed by winetricks to install DLLs
* **wget, curl**: Networking utilities

---

## 🙏 Credits

* **Gemini**: For AI assistance and code generation.
* **DeepSeek**: For AI assistance and code generation.


