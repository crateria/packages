# Security Policy

## Supported repository content

| Content | Supported |
|---------|-----------|
| Current `stable` APT + DNF indexes on GitHub Pages | Yes |
| Historical pool versions retained by prune policy | Best-effort |
| Unsigned local builds / forks | No |

## Reporting a vulnerability

Use [private vulnerability reporting](https://github.com/crateria/packages/security/advisories/new)
for issues that could affect package consumers (signing, malicious packages in
the pool, index integrity, compromised key material).

Do not open a public issue for active key compromise or injected packages.

We aim to acknowledge reports within 72 hours.

## Threat model (summary)

* Consumers trust the **published GPG public key** and HTTPS transport to
  `crateria.github.io` / GitHub.
* A compromised signing key or a malicious push to this repository can deliver
  arbitrary code to users who install from the Crateria repos.
* Mitigations: org 2FA, secret scanning, restricted maintainers, documented
  signing ceremony (`docs/SIGNING.md`), prune old packages, web commit signoff.

## Maintainer expectations

* Never commit private keys or passphrases.
* Sign only from a host that holds the intended key; see `docs/SIGNING.md`.
* Prefer `CRATERIA_GPG_NAME` / optional `CRATERIA_GPG_PATH` over hardcoding paths.
