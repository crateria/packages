// SPDX-License-Identifier: MIT

use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

fn run_cmd(cmd: &mut Command) -> Result<(), String> {
    let status = cmd.status().map_err(|e| e.to_string())?;
    if !status.success() {
        return Err(format!(
            "Command failed with exit status: {:?}",
            status.code()
        ));
    }
    Ok(())
}

fn command_exists(name: &str) -> bool {
    Command::new("which")
        .arg(name)
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .status()
        .map(|s| s.success())
        .unwrap_or(false)
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let gpg_name = match env::var("CRATERIA_GPG_NAME") {
        Ok(val) if !val.trim().is_empty() => val,
        _ => {
            eprintln!(
                "ERROR: CRATERIA_GPG_NAME is not set.\n\n\
                 Export the signing identity (email or exact uid string), for example:\n\
                 \texport CRATERIA_GPG_NAME='packages@example.com'\n\
                 \t# optional:\n\
                 \texport CRATERIA_GPG_PATH=\"$HOME/.gnupg\"\n\
                 \tcargo run --release --bin sign\n\n\
                 See docs/SIGNING.md."
            );
            std::process::exit(1);
        }
    };

    let gpg_bin = env::var("CRATERIA_GPG_BIN").unwrap_or_else(|_| "gpg".to_string());
    let gpg_path = env::var("CRATERIA_GPG_PATH").ok();
    let skip_install = env::var_os("CRATERIA_SKIP_RPM_SIGN_INSTALL").is_some();

    // Check if rpmsign exists
    if !command_exists("rpmsign") {
        if skip_install {
            eprintln!("ERROR: rpmsign not found and CRATERIA_SKIP_RPM_SIGN_INSTALL is set.");
            std::process::exit(1);
        }
        if command_exists("dnf") {
            println!("Installing rpm-sign...");
            // Manual validation rule: do not use -y or --assumeyes in package manager commands.
            run_cmd(Command::new("sudo").args(["dnf", "install", "rpm-sign"]))?;
        } else {
            eprintln!(
                "ERROR: rpmsign not found. Install rpm-sign (or rpm-sign package) and retry."
            );
            std::process::exit(1);
        }
    }

    // Verify secret GPG key
    let mut gpg_check = Command::new(&gpg_bin);
    if let Some(ref path) = gpg_path {
        gpg_check.args(["--homedir", path]);
    }
    gpg_check.args(["--list-secret-keys", &gpg_name]);
    let status = gpg_check
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .status()?;

    if !status.success() {
        eprintln!(
            "ERROR: No GPG secret key found for: {}\n\
             Import the signing key into this environment first, for example:\n\
             \t{} {} --import /path/to/private-key.asc",
            gpg_name,
            gpg_bin,
            if let Some(ref path) = gpg_path {
                format!("--homedir {}", path)
            } else {
                "".to_string()
            }
        );
        std::process::exit(1);
    }

    // Write .rpmmacros
    let home = env::var("HOME")?;
    let rpmmacros_path = PathBuf::from(home).join(".rpmmacros");
    let mut macros_content = format!(
        "%_signature gpg\n\
         %_gpg_name {}\n\
         %_gpgbin {}\n",
        gpg_name, gpg_bin
    );
    if let Some(ref path) = gpg_path {
        macros_content.push_str(&format!("%_gpg_path {}\n", path));
    }
    fs::write(&rpmmacros_path, macros_content)?;
    println!(
        "Wrote {} for identity: {}",
        rpmmacros_path.display(),
        gpg_name
    );

    // Find all RPMs in rpm/pool/
    let mut rpms = Vec::new();
    let rpm_pool = Path::new("rpm/pool");
    if rpm_pool.exists() {
        for entry in fs::read_dir(rpm_pool)? {
            let entry = entry?;
            let path = entry.path();
            if path.is_file() && path.extension().and_then(|s| s.to_str()) == Some("rpm") {
                rpms.push(path);
            }
        }
    }

    if rpms.is_empty() {
        eprintln!("ERROR: no RPMs under rpm/pool/");
        std::process::exit(1);
    }

    println!("Signing {} RPM package(s) in rpm/pool/...", rpms.len());
    let mut sign_cmd = Command::new("rpmsign");
    sign_cmd.arg("--resign");
    for rpm in &rpms {
        sign_cmd.arg(rpm);
    }
    run_cmd(&mut sign_cmd)?;

    println!("Rebuilding and signing repository metadata...");
    run_cmd(Command::new("cargo").args(["run", "--release", "--bin", "update"]))?;

    println!("==========================================================");
    println!("Signed packages and updated repository metadata.");
    println!("Review, commit, and push, then consumers can:");
    println!("  sudo dnf clean all && sudo dnf upgrade");
    println!("==========================================================");

    Ok(())
}
