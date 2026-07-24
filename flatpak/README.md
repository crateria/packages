# Flatpak Package Manifests

This directory contains Flatpak build manifests for IdleScreen applications:

- `io.github.idlescreen.idle.yaml`: IdleScreen core daemon & screensaver host

## Building Flatpak Locally

```bash
flatpak-builder --force-clean build-dir io.github.idlescreen.idle.yaml
```
