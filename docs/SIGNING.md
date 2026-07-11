# Crateria package signing

This repository publishes **APT** and **DNF** package indexes and signed
artifacts for Crateria products. Treat the signing key like production
infrastructure: compromise of the private key is a supply-chain incident.

## Roles

| Role | Responsibility |
|------|----------------|
| Signing key holder | Generate, store, and rotate the GPG key; run `sign_all.sh` / `update.sh` |
| Publisher | Commit pool + metadata to `main` (or approved release path); verify Pages deploy |
| Consumers | Trust the **public** keyring shipped under `apt/` and `rpm/` |

Never commit private keys, passphrases, or machine-local paths into this repo.

## Required environment (signing host)

```bash
export CRATERIA_GPG_NAME='YOUR_SIGNING_UID_OR_EMAIL'
# optional overrides:
# export CRATERIA_GPG_PATH="$HOME/.gnupg"
# export CRATERIA_GPG_BIN=gpg
```

Then:

```bash
./sign_all.sh    # resigns rpm/pool/*.rpm and runs update.sh
# or, if metadata-only:
./update.sh
```

`sign_all.sh` writes a **local** `~/.rpmmacros` for the current user. It does not
embed home directories or personal emails in the repository.

## Public key material in-tree

| Path | Purpose |
|------|---------|
| `apt/crateria-keyring.gpg` | APT keyring consumers install under `/etc/apt/keyrings` |
| `apt/crateria-key.gpg` | Public key (legacy/alternate) |
| `rpm/crateria-key.gpg` | RPM/DNF public key |
| `rpm/crateria.repo` | DNF repo file (references key URL) |

After key **rotation**, publish the new public key files, re-sign packages and
metadata, and document the change in the product READMEs if the fingerprint
changes.

## Key ceremony (checklist)

1. Generate a dedicated key (RSA ≥ 3072 or modern equivalent) with a clear uid
   such as `Crateria Packages <packages@…>`. Prefer a subkey used only for
   signing if you manage primary offline.
2. Store the private key offline or in a restricted environment; backup encrypted.
3. Export **public** key only into `apt/` and `rpm/` as needed.
4. Record fingerprint and creation date in your private runbook (not necessarily public).
5. Sign packages with `CRATERIA_GPG_NAME` set; never paste private key material into CI logs.

## Compromise response

1. **Revoke** the compromised key and publish the revocation to keyservers if used.
2. Generate a new key; update `apt/*` and `rpm/*` public material.
3. Re-sign the current package pool and metadata; force a Pages deploy.
4. Announce via product SECURITY notes / GitHub Security Advisories: old key
   untrusted after date *T*; instruct users to reinstall the keyring and
   `apt update` / `dnf clean all`.
5. Audit recent commits to `packages` for unexpected artifacts.

## What not to automate carelessly

- Do **not** put the private key in GitHub Actions secrets unless you accept CI
  as a trust boundary and lock down workflows (OIDC, environment protection,
  no `pull_request` from forks with secret access).
- Prefer signing on a dedicated host, then push only signed outputs.

## Related

- Product install docs: org profile and each product README
- Pruning old pool versions: `./scripts/prune.sh` (default keep 3)
- Security contact: see `SECURITY.md`
