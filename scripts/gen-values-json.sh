#!/bin/sh
# SPDX-FileCopyrightText: 2024–2025 BWI GmbH
# SPDX-License-Identifier: Apache-2.0
#
# Generates the values.schema.json from values.schema.yaml
# shellcheck disable=SC3040
set -euo pipefail

INFILE="${1:-values.schema.yaml}"
[ "$INFILE" = "-" ] && INFILE=/dev/stdin

# Transformations performed:
# - Convert YAML to JSON
# - Add auto-generation note
# - Bundle external schemas
yq --output-format=json \
    "{ \
        \"\$schema\": null, \
        \"\$id\": null, \
        \"\$comment\": \
            \"Do not modify by hand. This file is auto-generated from values.schema.yaml\" \
    } * ." \
< "$INFILE" \
| scripts/schema-tools.py bundle - \
> values.schema.json
