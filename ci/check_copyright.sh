#!/bin/sh
# SPDX-FileCopyrightText: 2024 BWI GmbH
# SPDX-License-Identifier: Apache-2.0
#
# Checks if SPDX copyright notices exist and contain the correct year. Assumes a
# pristine git checkout.
set -e

BASEDIR=$(dirname "$0")

# Rewrite template license headers
find "$BASEDIR/../templates" -name "*.yaml" -exec sh -c \
    "$BASEDIR/../scripts/rewrite-license-header.sh \"\$1\"" \
sh {} ';'
# Print all modifications
git diff
# Check if any files were modified.
! git status --porcelain=1 | grep "^ M"
