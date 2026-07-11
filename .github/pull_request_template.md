## Summary

<!-- What does this PR change in the package repositories? -->

## Checklist

- [ ] No private keys, passphrases, or local home paths committed
- [ ] Public key material only under `apt/` / `rpm/` when intentionally rotated
- [ ] Pool changes are intentional; prune considered if adding many artifacts
- [ ] Metadata regenerated via `update.sh` / `sign_all.sh` when packages change
- [ ] Signing used env-based identity (`CRATERIA_GPG_NAME`) per `docs/SIGNING.md`
