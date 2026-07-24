#!/bin/sh
# Universal IdleScreen Installer
# Usage: curl -fsSL https://idlescreen.github.io/packages/install.sh | sh

set -e

BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

echo ""
echo " 🌌 ${BOLD}IdleScreen Installer${RESET}"
echo " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Detect OS / Package Manager
if command -v dnf >/dev/null 2>&1; then
    PKG_MGR="dnf"
    echo " 📦 Detected Package Manager: DNF (Fedora / RHEL / Rocky)"
    echo " 🔑 Adding GPG Key and Repository..."
    sudo curl -fsSL https://idlescreen.github.io/packages/rpm/idlescreen.repo -o /etc/yum.repos.d/idlescreen.repo
    sudo dnf check-update || true
    echo " 📥 Installing idlescreen..."
    sudo dnf install -y idlescreen
elif command -v apt-get >/dev/null 2>&1; then
    PKG_MGR="apt"
    echo " 📦 Detected Package Manager: APT (Ubuntu / Debian / Pop!_OS)"
    echo " 🔑 Adding GPG Key and Repository..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://idlescreen.github.io/packages/idlescreen-keyring.gpg | sudo tee /etc/apt/keyrings/idlescreen-keyring.gpg >/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/idlescreen-keyring.gpg] https://idlescreen.github.io/packages/apt/ stable main" | sudo tee /etc/apt/sources.list.d/idlescreen.list >/dev/null
    sudo apt-get update
    echo " 📥 Installing idlescreen..."
    sudo apt-get install -y idlescreen
else
    echo " ❌ Unsupported package manager. Please install manually from https://idlescreen.github.io/packages/"
    exit 1
fi

# Enable systemd user service for current user if running interactively
if [ -n "${USER:-}" ] && [ "$USER" != "root" ]; then
    systemctl --user enable --now idle-daemon.service 2>/dev/null || true
fi

# Detect DE
DE_MSG=""
if [ "${XDG_CURRENT_DESKTOP:-}" = "COSMIC" ] || [ "${DESKTOP_SESSION:-}" = "cosmic" ] || [ -f "/usr/bin/cosmic-panel" ]; then
    DE_MSG=" 📱 Desktop Environment: COSMIC DE Detected (Panel Applet Installed)"
fi

echo ""
echo " 🌌 ${GREEN}${BOLD}Welcome to IdleScreen!${RESET}"
echo " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " High-Performance GPU & Terminal Screensavers for Linux"
echo ""
echo " 🟢 Background Daemon: Active & Enabled (idle-daemon.service)"
if [ -n "$DE_MSG" ]; then
    echo "$DE_MSG"
fi
echo ""
echo " 🚀 ${BOLD}Quick Start Commands:${RESET}"
echo "    ${CYAN}idlescreen tui${RESET}       Launch live interactive TUI dashboard"
echo "    ${CYAN}idlescreen status${RESET}    Check active screensaver & daemon state"
echo "    ${CYAN}idlescreen doctor${RESET}    Run system health & Wayland check"
echo ""
echo " 💡 ${BOLD}Desktop Launcher:${RESET} You can also open 'IdleScreen' from your"
echo "                       Desktop Application Launcher menu at any time!"
echo " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
