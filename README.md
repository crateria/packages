# IdleScreen Packages Repository

This repository contains official package definitions, manifests, and repository indexes for **IdleScreen** across Linux distributions.

Official Package Web Portal: **[idlescreen.github.io/packages](https://idlescreen.github.io/packages/)**

---

## 🚀 Repository & Package Installation by OS

### 1. Fedora / RHEL / CentOS Stream (DNF)

#### Step 1: Install the IdleScreen Repository
Add the repository configuration file to your system:
```bash
sudo curl -fsSL https://idlescreen.github.io/packages/rpm/idlescreen.repo \
  -o /etc/yum.repos.d/idlescreen.repo
```

#### Step 2: Install IdleScreen Products
```bash
# Refresh package metadata
sudo dnf check-update

# Install main desktop application (COSMIC integration)
sudo dnf install idle-cosmic

# Optional: Install TUI interface or Studio
sudo dnf install idle-tui
```

---

### 2. Debian / Ubuntu / Pop!_OS / Linux Mint (APT)

#### Step 1: Install the IdleScreen Repository & GPG Key
```bash
# Create keyrings directory
sudo mkdir -p /etc/apt/keyrings

# Download and install the IdleScreen GPG keyring
sudo curl -fsSL https://idlescreen.github.io/packages/apt/idlescreen-keyring.gpg \
  -o /etc/apt/keyrings/idlescreen.gpg

# Add the APT repository source list
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/idlescreen.gpg] https://idlescreen.github.io/packages/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/idlescreen.list

# Update package database
sudo apt update
```

#### Step 2: Install IdleScreen Products
```bash
# Install COSMIC desktop integration
sudo apt install idle-cosmic

# Optional: Install live TUI
sudo apt install idle-tui
```

---

### 3. Arch Linux / Manjaro / EndeavourOS (`makepkg`)

#### Step 1: Clone the Package Definitions Repository
```bash
git clone https://github.com/idlescreen/packages.git
cd packages/arch
```

#### Step 2: Build & Install Packages
```bash
# Build and install the core daemon
makepkg -si
```

---

### 4. Nix / NixOS

#### Step 1: Using Nix Flakes (Direct Run)
```bash
nix run github:idlescreen/packages#idle-cosmic
```

#### Step 2: Building with Nix
```bash
git clone https://github.com/idlescreen/packages.git
cd packages/nix
nix-build default.nix
```

---

### 5. Flatpak (Cross-Distro)

#### Step 1: Clone Manifests & Build
```bash
git clone https://github.com/idlescreen/packages.git
cd packages/flatpak
flatpak-builder --user --install --force-clean build-dir io.github.idlescreen.idle.yaml
```

---

## 📦 Products Overview

| Package | Description |
|---------|-------------|
| **`idle-cosmic`** | COSMIC Desktop screensaver integration, daemon, and applet |
| **`idle-tui`** | Interactive live Terminal User Interface |
| **`idle-studio`** | Offline scene director and renderer |

> **Note:** Low-level engine components (`idle-daemon`, `idle-cli`, `idle-saver-*`) are pulled automatically as dependencies.

---

## 🔗 Links

- **Main Engine:** [github.com/idlescreen/idle](https://github.com/idlescreen/idle)
- **Web Portal:** [idlescreen.github.io/packages](https://idlescreen.github.io/packages/)
