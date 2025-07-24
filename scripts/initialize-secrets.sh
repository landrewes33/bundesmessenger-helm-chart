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

# Erstellen des Synapse Signierschlüssels.
KID=$(tr -cd "0-9" < /dev/urandom | head -c 4)
KEY=$(openssl genpkey -algorithm ed25519  | cut -c 49-92 | sed '2p;d')
SIGNINGKEY="ed25519 a_$KID $KEY"


# Secret mit dem Synapse Signierschlüssel.
kubectl create -n "$NAMESPACE" secret generic "signingkey" \
    --from-literal="signing.key=$SIGNINGKEY"

# Secret mit verschiedenen Synapse-Geheimnissen.
kubectl create -n "$NAMESPACE" secret generic "synapse" \
    --from-literal="registration-shared-secret=$(pwgen 42 1)" \
    --from-literal="macaroon-secret-key=$(pwgen 42 1)" \
    --from-literal="form-secret=$(pwgen 42 1)" \
    --from-literal="worker-replication-secret=$(pwgen 42 1)"

# Secret mit den Synapse-PostgreSQL-Passwörtern.
kubectl create -n "$NAMESPACE" secret generic "postgresql" \
    --from-literal="password=$(pwgen 42 1)" \
    --from-literal="postgres-password=$(pwgen 42 1)"

# Secret mit dem Redis-Passwort.
kubectl create -n "$NAMESPACE" secret generic "redis" \
    --from-literal="redis-password=$(pwgen 42 1)"

# Secret mit dem LiveKit-Schlüssel und -Geheimnis.
kubectl create -n "$NAMESPACE" secret generic "call" \
    --from-literal="livekit-key=$(pwgen 42 1)" \
    --from-literal="livekit-secret=$(pwgen 42 1)"

# Secret mit den Sygnal-Schlüsseln.
# kubectl create -n "$NAMESPACE" secret generic "sygnal" \
#     --from-file="AuthKey.p8" \
#     --from-file="bundesmessenger.json"
