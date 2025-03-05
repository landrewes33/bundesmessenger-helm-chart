#!/bin/sh
# SPDX-FileCopyrightText: 2025 BWI GmbH
# SPDX-License-Identifier: Apache-2.0
#
# Asserts all Synapse versions mentioned in the chart are identical.

# shellcheck disable=SC3040
set -euo pipefail

tags=$(
    yq '.appVersion' Chart.yaml
    yq '.image.tag' values.yaml
    yq '.signingkey.job.generateImage.tag' values.yaml
)
versions=$(echo "$tags" | grep -Eo '^[0-9]+\.[0-9]+\.[0-9]+')
[ "$(echo "$versions" | uniq | wc -l)" -eq 1 ]
