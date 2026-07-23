# IdleScreen packages

[![CI](https://github.com/idlescreen/packages/actions/workflows/ci.yml/badge.svg)](https://github.com/idlescreen/packages/actions/workflows/ci.yml)
[![Pages](https://img.shields.io/badge/index-idlescreen.github.io%2Fpackages-orange)](https://idlescreen.github.io/packages/)

APT (`.deb`) and DNF (`.rpm`) repositories for **IdleScreen** (Trance screensaver family).

Public index: **[idlescreen.github.io/packages](https://idlescreen.github.io/packages/)**  
Brand: [idlescreen/brand](https://github.com/idlescreen/brand)

## User install

### Debian / Ubuntu / Pop!_OS

```bash
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://idlescreen.github.io/packages/apt/crateria-keyring.gpg \
  -o /etc/apt/keyrings/idlescreen.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/idlescreen.gpg] https://idlescreen.github.io/packages/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/idlescreen.list
sudo apt update
sudo apt install trance
```

### Fedora

```bash
sudo curl -fsSL https://idlescreen.github.io/packages/rpm/crateria.repo \
  -o /etc/yum.repos.d/idlescreen.repo
sudo dnf install trance
```

Optional: `trance-plugin-*`, meta package `trance-plugins-all`.

> Server filenames may still use the `crateria-*` prefix until assets are renamed; the host is **idlescreen.github.io**.

## Release → index pipeline

1. Product repo tags `vX.Y.Z` and publishes `.deb` / `.rpm`.
2. Product Release workflow may `repository_dispatch` type `new_release` here
   (secret on product: `IDLESCREEN_PACKAGES_DISPATCH_TOKEN`).
3. Import workflow downloads assets, signs, rebuilds indexes, deploys Pages.

## Build tooling from source

```bash
git clone https://github.com/idlescreen/packages.git
cd packages
cargo build --release
```

## Security

[Private vulnerability reporting](https://github.com/idlescreen/packages/security/advisories/new)

## License

Apache-2.0. See [LICENSE](LICENSE).
