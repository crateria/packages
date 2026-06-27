# UberMetroid Packages Repository

This repository serves as the central distribution hub for the **UberMetroid** ecosystem applications (such as `trance`, `beam`, `todo`, etc.). It supports distribution across multiple package managers and environments.

Supported formats:
*   **APT** (Debian, Ubuntu, Pop!_OS) — hosted under `/apt` and served via GitHub Pages
*   **Nix Flakes** (NixOS, Unraid Nix Plugin) — defined at the root (`flake.nix`)

---

## 1. Debian / Ubuntu Setup (APT)

To install compiled Debian packages (such as `trance`):

### Automated Installation (Recommended)
```bash
curl -fsSL https://ubermetroid.github.io/packages/apt/install.sh | sudo bash
sudo apt install trance
```

For manual installation instructions and GPG keyring details, see the [APT Readme](apt/README.md).

### Repository maintenance

The `apt/pool/main/` directory retains every version of every package
ever published, which has grown to ~143 MB / 131 files. To keep the
repository lean, prune the pool to the latest 3 versions of each
package:

```bash
./scripts/prune.sh          # default: keep latest 3
./scripts/prune.sh 5        # keep latest 5
```

After pruning, regenerate the APT index (see `apt/MAINTAINER.md`).

---

## 2. NixOS / Unraid Nix Setup (Flakes)

> **Note:** the Nix flake at the root of this repo is currently a
> **placeholder**. It exports `pkgs.hello` as `default` and does not yet
> provide the per-application overlays that `nix run` and flake inputs
> would require. Tracking the implementation is a portfolio-level TODO.
>
> Until the flake is implemented, install UberMetroid apps via Nix by
> pulling each application's own flake directly:
>
> ```bash
> nix run github:UberMetroid/trance
> nix run github:UberMetroid/beam
> ```
>
> The Unraid Nix plugin (`github:UberMetroid/unraid-nix`) does not
> currently consume this repo's flake.
