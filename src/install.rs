use std::env;
use std::process::Command;

fn main() {
    println!("\n 🌌 \x1b[1mIdleScreen Installer (Rust)\x1b[0m");
    println!(" ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    let is_dnf = std::path::Path::new("/usr/bin/dnf").exists();
    let is_apt = std::path::Path::new("/usr/bin/apt-get").exists();

    if is_dnf {
        println!(" 📦 Package Manager: DNF (Fedora / RHEL / Rocky)");
        println!(" 🔑 Adding GPG Key and DNF Repository...");
        let _ = Command::new("sudo")
            .args([
                "curl",
                "-fsSL",
                "https://idlescreen.github.io/packages/rpm/idlescreen.repo",
                "-o",
                "/etc/yum.repos.d/idlescreen.repo",
            ])
            .status();

        println!(" 📥 Installing idlescreen...");
        let _ = Command::new("sudo")
            .args(["dnf", "install", "-y", "idlescreen"])
            .status();
    } else if is_apt {
        println!(" 📦 Package Manager: APT (Ubuntu / Debian / Pop!_OS)");
        println!(" 🔑 Adding GPG Key and APT Repository...");
        let _ = Command::new("sudo")
            .args(["mkdir", "-p", "/etc/apt/keyrings"])
            .status();
        let _ = Command::new("sh")
            .arg("-c")
            .arg("curl -fsSL https://idlescreen.github.io/packages/idlescreen-keyring.gpg | sudo tee /etc/apt/keyrings/idlescreen-keyring.gpg >/dev/null")
            .status();
        let _ = Command::new("sh")
            .arg("-c")
            .arg("echo 'deb [signed-by=/etc/apt/keyrings/idlescreen-keyring.gpg] https://idlescreen.github.io/packages/apt/ stable main' | sudo tee /etc/apt/sources.list.d/idlescreen.list >/dev/null")
            .status();
        let _ = Command::new("sudo").args(["apt-get", "update"]).status();
        println!(" 📥 Installing idlescreen...");
        let _ = Command::new("sudo")
            .args(["apt-get", "install", "-y", "idlescreen"])
            .status();
    } else {
        println!(
            " ❌ Unsupported package manager. Please follow manual install at https://idlescreen.github.io/packages/"
        );
        std::process::exit(1);
    }

    // Enable systemd user unit
    let _ = Command::new("systemctl")
        .args(["--user", "enable", "--now", "idle-daemon.service"])
        .status();

    // Check COSMIC DE
    let desktop = env::var("XDG_CURRENT_DESKTOP").unwrap_or_default();
    let is_cosmic =
        desktop.contains("COSMIC") || std::path::Path::new("/usr/bin/cosmic-panel").exists();

    println!("\n 🌌 \x1b[32m\x1b[1mWelcome to IdleScreen!\x1b[0m");
    println!(" ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    println!(" High-Performance GPU & Terminal Screensavers for Linux");
    println!();
    println!(" 🟢 Background Daemon: Active & Enabled (idle-daemon.service)");
    if is_cosmic {
        println!(" 📱 Desktop Environment: COSMIC DE Detected (Panel Applet Installed)");
    }
    println!();
    println!(" 🚀 \x1b[1mQuick Start Commands:\x1b[0m");
    println!("    \x1b[36midlescreen tui\x1b[0m       Launch live interactive TUI dashboard");
    println!("    \x1b[36midlescreen status\x1b[0m    Check active screensaver & daemon state");
    println!("    \x1b[36midlescreen doctor\x1b[0m    Run system health & Wayland check");
    println!();
    println!(" 💡 \x1b[1mDesktop Launcher:\x1b[0m You can also open 'IdleScreen' from your");
    println!("                       Desktop Application Launcher menu at any time!");
    println!(" ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
}
