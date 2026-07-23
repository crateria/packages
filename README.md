# Crateria packages

[![CI](https://github.com/crateria/packages/actions/workflows/ci.yml/badge.svg)](https://github.com/crateria/packages/actions/workflows/ci.yml)
[![Pages](https://img.shields.io/badge/index-crateria.github.io%2Fpackages-orange)](https://crateria.github.io/packages/)

APT (`.deb`) and DNF (`.rpm`) package repositories for **Crateria** desktop applications
(currently the Trance screensaver family).

Public index: **[crateria.github.io/packages](https://crateria.github.io/packages/)**  
Brand: [crateria/brand](https://github.com/crateria/brand)

## User install

### Debian / Ubuntu / Pop!_OS

```bash
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://crateria.github.io/packages/apt/crateria-keyring.gpg \
  -o /etc/apt/keyrings/crateria.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/crateria.gpg] https://crateria.github.io/packages/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/crateria.list
sudo apt update
sudo apt install trance
```

### Fedora

```bash
sudo curl -fsSL https://crateria.github.io/packages/rpm/crateria.repo \
  -o /etc/yum.repos.d/crateria.repo
sudo dnf install trance
```

Optional plugin packages: `trance-plugin-*`, meta package `trance-plugins-all`.

## Release → index pipeline

1. Product repo (e.g. `trance`) tags `vX.Y.Z` and publishes release assets (`.deb` / `.rpm`).
2. Product **Release** workflow may send `repository_dispatch` type `new_release` here
   (secret: `CRATERIA_PACKAGES_DISPATCH_TOKEN` on the product repo).
3. **Import Product Release** downloads assets, prunes old versions, signs, rebuilds indexes, deploys Pages.

## Build tooling from source

```bash
git clone https://github.com/crateria/packages.git
cd packages
cargo build --release
```

## Security

[Private vulnerability reporting](https://github.com/crateria/packages/security/advisories/new) · [SECURITY.md](https://github.com/crateria/.github/blob/master/SECURITY.md)

## License

Apache-2.0. See [LICENSE](LICENSE).
