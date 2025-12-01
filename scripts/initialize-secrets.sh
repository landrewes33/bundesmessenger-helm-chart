#!/bin/sh
# SPDX-FileCopyrightText: 2025 BWI GmbH
# SPDX-License-Identifier: Apache-2.0
#
# Generate Kubernetes Secrets for the BundesMessenger.

# shellcheck disable=SC3040
set -euo pipefail

if [ -z "${1-}" ]; then
    echo "Usage: $0 <namespace>"
    echo
    echo "Generate Kubernetes Secrets for the BundesMessenger."
    exit 1
fi

NAMESPACE=$1


alphanum_password() {
    tr -cd "0-9a-zA-Z" < /dev/urandom | head -c 42
}

# Erstellen des Synapse Signierschlüssels.
KID=$(tr -cd "0-9" < /dev/urandom | head -c 4) || true
KEY=$(openssl genpkey -algorithm ed25519  | cut -c 49-92 | sed '2p;d')
SIGNINGKEY="ed25519 a_$KID $KEY"

# Erstellen der MAS Signierschlüssel.
MAS_SIGNINGKEY_RSA="$(openssl genpkey -algorithm rsa 2> /dev/null)"
MAS_SIGNINGKEY_EC="$(openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256)"

# Erstellen der MAS Datenbankschlüssel.
MAS_DB_KEY="$(openssl rand -hex 32)"


# Secret mit dem Synapse Signierschlüssel.
kubectl create -n "$NAMESPACE" secret generic "signingkey" \
    --from-literal="signing.key=$SIGNINGKEY"

# Secret mit verschiedenen Synapse-Geheimnissen.
kubectl create -n "$NAMESPACE" secret generic "synapse" \
    --from-literal="registration-shared-secret=$(alphanum_password)" \
    --from-literal="macaroon-secret-key=$(alphanum_password)" \
    --from-literal="form-secret=$(alphanum_password)" \
    --from-literal="worker-replication-secret=$(alphanum_password)"

# Secret mit den Synapse-PostgreSQL-Passwörtern.
kubectl create -n "$NAMESPACE" secret generic "postgresql" \
    --from-literal="password=$(alphanum_password)" \
    --from-literal="postgres-password=$(alphanum_password)"

# Secret mit dem Redis-Passwort.
kubectl create -n "$NAMESPACE" secret generic "redis" \
    --from-literal="redis-password=$(alphanum_password)"

# Secret mit dem LiveKit-Schlüssel und -Geheimnis.
kubectl create -n "$NAMESPACE" secret generic "call" \
    --from-literal="livekit-key=$(alphanum_password)" \
    --from-literal="livekit-secret=$(alphanum_password)"

# Secret mit den Sygnal-Schlüsseln.
# kubectl create -n "$NAMESPACE" secret generic "sygnal" \
#     --from-file="AuthKey.p8" \
#     --from-file="bundesmessenger.json"

# Secret mit den MAS Signierschlüsseln.
# Die Dateinamen der Signierschlüssel sind frei wählbar. Es muss mindestens ein
# RSA-Schlüssel angegeben werden.
kubectl create -n "$NAMESPACE" secret generic "mas-signingkeys" \
    --from-literal="0000-mas-signingkey-rsa.pem=$MAS_SIGNINGKEY_RSA" \
    --from-literal="0001-mas-signingkey-ec.pem=$MAS_SIGNINGKEY_EC"

# Secret mit dem MAS Datenbankschlüssel.
kubectl create -n "$NAMESPACE" secret generic "mas" \
    --from-literal="encryption=$MAS_DB_KEY" \
    --from-literal="matrix-shared-secret=$(alphanum_password)"
