#!/usr/bin/env bash
# Makes a fresh RSA key pair for the dbt service user and prints the public key on one line.
#   scripts/new_keypair.sh
# The private key goes outside the repo (default ~/.ecommerce_keys, mode 600). Never commit it.
set -euo pipefail
DIR="${ECOMMERCE_KEYS:-$HOME/.ecommerce_keys}"
mkdir -p "$DIR" && chmod 700 "$DIR"
openssl genrsa 2048 2>/dev/null | openssl pkcs8 -topk8 -inform PEM -out "$DIR/dbt_user.p8" -nocrypt
openssl rsa -in "$DIR/dbt_user.p8" -pubout -out "$DIR/dbt_user.pub" 2>/dev/null
chmod 600 "$DIR/dbt_user.p8"
echo "Private key: $DIR/dbt_user.p8   (keep it secret)"
echo "Public key (for sql/01_snowflake_setup.sql):"
grep -v '^-----' "$DIR/dbt_user.pub" | tr -d '\n'; echo
