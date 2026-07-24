# IdleScreen Packages Repository

This repository contains official package definitions, manifests, and repository indexes for **IdleScreen** across Linux distributions.

Official Package Web Portal: **[idlescreen.github.io/packages](https://idlescreen.github.io/packages/)**

> 💡 **Standard Package:** `idlescreen` is the universal, recommended package for all desktop environments.  
> 🪐 **COSMIC DE Only:** `idle-cosmic` is specifically built for the COSMIC Desktop Environment.

---

## 🚀 Repository & Package Installation by OS

Click your operating system below to expand repository setup and installation instructions.

<details>
<summary><b>Fedora / RHEL / CentOS Stream (DNF)</b></summary>

<br>

#### Step 1: Add the IdleScreen DNF Repository
```bash
sudo curl -fsSL https://idlescreen.github.io/packages/rpm/idlescreen.repo \
  -o /etc/yum.repos.d/idlescreen.repo
```

#### Step 2: Refresh Metadata & Install Product
```bash
# Refresh DNF package database
sudo dnf check-update

# Install standard package (Universal for all DEs / Wayland compositors)
sudo dnf install idlescreen

# Launch TUI controller
idlescreen tui

# Optional (COSMIC DE Only): Install COSMIC desktop integration & applet
sudo dnf install idle-cosmic
```

</details>

<details>
<summary><b>Debian / Ubuntu / Pop!_OS / Linux Mint (APT)</b></summary>

<br>

#### Step 1: Download GPG Key & Add APT Repository
```bash
# Create keyrings directory
sudo mkdir -p /etc/apt/keyrings

# Download and install GPG keyring
sudo curl -fsSL https://idlescreen.github.io/packages/apt/idlescreen-keyring.gpg \
  -o /etc/apt/keyrings/idlescreen.gpg

# Add IdleScreen APT repository source
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/idlescreen.gpg] https://idlescreen.github.io/packages/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/idlescreen.list
```

#### Step 2: Update Package Database & Install Product
```bash
# Update APT package index
sudo apt update

# Install standard package (Universal for all DEs / Wayland compositors)
sudo apt install idlescreen

# Launch TUI controller
idlescreen tui

# Optional (COSMIC DE Only): Install COSMIC desktop integration & applet
sudo apt install idle-cosmic
```

</details>

<details>
<summary><b>Arch Linux / Manjaro / EndeavourOS (`makepkg`)</b></summary>

<br>

#### Step 1: Clone Package Definitions
```bash
git clone https://github.com/idlescreen/packages.git
cd packages/arch
```

#### Step 2: Build & Install Packages
```bash
# Build and install the standard IdleScreen package
makepkg -si
```

</details>

<details>
<summary><b>Flatpak (Cross-Distribution)</b></summary>

<br>

#### Step 1: Clone Manifests & Build
```bash
git clone https://github.com/idlescreen/packages.git
cd packages/flatpak
flatpak-builder --user --install --force-clean build-dir io.github.idlescreen.idle.yaml
```

</details>

---

## 📦 Products Overview

| Package | Role | Command | Compatibility |
|---------|------|---------|---------------|
| **`idlescreen`** | **Standard Package** — Universal host, TUI controller & all screensavers | `idlescreen tui` (or `idle tui`) | All Wayland Compositors & DEs |
| **`idle-cosmic`** | **COSMIC DE Only** — COSMIC panel applet & desktop integration | Applet GUI | COSMIC Desktop Environment |
| **`idle-studio`** | Offline director & scene renderer | `idle-studio` | All Linux environments |

---

## 🔗 Links

- **Main Engine:** [github.com/idlescreen/idle](https://github.com/idlescreen/idle)
- **Web Portal:** [idlescreen.github.io/packages](https://idlescreen.github.io/packages/)
