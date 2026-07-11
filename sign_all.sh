#!/usr/bin/env bash
# Sign all RPMs in rpm/pool/ and rebuild repository metadata.
#
# Required environment:
#   CRATERIA_GPG_NAME   GPG uid or email used for package signing
#                       (must match a secret key available to gpg)
#
# Optional environment:
#   CRATERIA_GPG_PATH   Override GNUPGHOME / %_gpg_path (default: gpg default)
#   CRATERIA_GPG_BIN    gpg binary (default: gpg)
#   CRATERIA_SKIP_RPM_SIGN_INSTALL  if set, do not auto-install rpm-sign
#
# Never commit private keys. See docs/SIGNING.md.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

GPG_NAME="${CRATERIA_GPG_NAME:-}"
GPG_BIN="${CRATERIA_GPG_BIN:-gpg}"
GPG_PATH="${CRATERIA_GPG_PATH:-}"

if [[ -z "$GPG_NAME" ]]; then
  cat <<'EOF' >&2
ERROR: CRATERIA_GPG_NAME is not set.

Export the signing identity (email or exact uid string), for example:
  export CRATERIA_GPG_NAME='packages@example.com'
  # optional:
  export CRATERIA_GPG_PATH="$HOME/.gnupg"
  ./sign_all.sh

See docs/SIGNING.md.
EOF
  exit 1
fi

if ! command -v rpmsign &>/dev/null; then
  if [[ -n "${CRATERIA_SKIP_RPM_SIGN_INSTALL:-}" ]]; then
    echo "ERROR: rpmsign not found and CRATERIA_SKIP_RPM_SIGN_INSTALL is set." >&2
    exit 1
  fi
  if command -v dnf &>/dev/null; then
    echo "Installing rpm-sign..."
    sudo dnf install -y rpm-sign
  else
    echo "ERROR: rpmsign not found. Install rpm-sign (or rpm-sign package) and retry." >&2
    exit 1
  fi
fi

GPG_LIST_ARGS=()
if [[ -n "$GPG_PATH" ]]; then
  GPG_LIST_ARGS+=(--homedir "$GPG_PATH")
fi

if ! "$GPG_BIN" "${GPG_LIST_ARGS[@]}" --list-secret-keys "$GPG_NAME" &>/dev/null; then
  cat <<EOF >&2
ERROR: No GPG secret key found for: $GPG_NAME
Import the signing key into this environment first, for example:
  $GPG_BIN ${GPG_PATH:+--homedir "$GPG_PATH"} --import /path/to/private-key.asc
EOF
  exit 1
fi

# Configure rpm macros for this user only (not committed).
RPMMACROS="${HOME}/.rpmmacros"
{
  echo "%_signature gpg"
  echo "%_gpg_name ${GPG_NAME}"
  echo "%_gpgbin ${GPG_BIN}"
  if [[ -n "$GPG_PATH" ]]; then
    echo "%_gpg_path ${GPG_PATH}"
  fi
} >"$RPMMACROS"
echo "Wrote $RPMMACROS for identity: $GPG_NAME"

shopt -s nullglob
rpms=(rpm/pool/*.rpm)
if ((${#rpms[@]} == 0)); then
  echo "ERROR: no RPMs under rpm/pool/" >&2
  exit 1
fi

echo "Signing ${#rpms[@]} RPM package(s) in rpm/pool/..."
rpmsign --resign "${rpms[@]}"

echo "Rebuilding and signing repository metadata..."
./update.sh

cat <<'EOF'
==========================================================
Signed packages and updated repository metadata.
Review, commit, and push, then consumers can:
  sudo dnf clean all && sudo dnf upgrade
==========================================================
EOF
