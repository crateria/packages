# Maintainer Guide (How to Update Packages)

This guide documents how to add new package versions and update the repository metadata indices.

## Steps to Update

1.  **Copy the newly compiled packages** into the repository.
    *   Example: `cp ../trance/target/debian/*.deb pool/main/`

2.  **Run the update indexer script** from the repository root to regenerate the database indices and cryptographically sign the Release files:
    ```bash
    ./update.sh
    ```

3.  **Commit and push the changes** to GitHub to make them available to clients:
    ```bash
    git add .
    git commit -m "Add packages and update index"
    git push origin main
    ```

## Pool Pruning

The pool directory grows unboundedly with every release. To prune the
pool to the latest 3 versions of each package:

```bash
./scripts/prune.sh          # default: keep latest 3
./scripts/prune.sh 5        # keep latest 5
```

Run this before regenerating the index in step 2 above.

## GPG Key Rotation Policy

The repository signing key is committed at `apt/ubermetroid-key.gpg`
as the **public key only** (the private key is held offline by the
maintainer). Rotation policy:

*   Rotate annually, or immediately on suspected compromise.
*   After rotation, re-sign the `Release` file with the new key.
*   Old releases remain valid as long as clients have the old key in
    their keyring; clients should be notified to update.
*   Publish the new public key fingerprint in this file and in
    `apt/README.md`.

## Guidelines
*   **Aesthetics**: The Gentoo/systemd-style TUI progress formatting is great. Preserve this clean, text-based interactive styling for installer and setup scripts.
