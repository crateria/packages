# Contributing

Thanks for your interest in the Crateria package repositories.

## Setup

- Rust toolchain for the small `update` / `prune` helpers (`cargo run --release --bin …`)
- Signing: see [docs/SIGNING.md](docs/SIGNING.md) — set `CRATERIA_GPG_NAME` (never commit private keys)

## Pull requests

- Target `main`
- Keep changes focused; include a short rationale in the PR body
- Do not commit secrets, GPG private keys, machine home paths, or unrelated binary artifacts
- When adding packages, regenerate metadata (`./update.sh` or `./sign_all.sh`) and consider `./scripts/prune.sh`

## Install docs

Prefer the canonical APT keyring path (`/etc/apt/keyrings` + `signed-by`) and DNF `.repo` curl used across Crateria READMEs.
