#!/bin/sh
# SPDX-FileCopyrightText: 2024 BWI GmbH
# SPDX-License-Identifier: Apache-2.0
#
# Rewrites the license header of the given YAML file to match its git history.
set -e

# Check if filename is provided as first argument
if [ -z "$1" ]; then
    echo "Usage: $0 <filename>"
    echo "You must provide a filename as the first argument."
    exit 1
fi

FILENAME="$1"

echo "Processing file: $FILENAME"

STARTYEAR=$(git log --follow --format=%as "$FILENAME" | tail -n 1 | grep -o ^....)
# Use earlier start date from file, if already there
STARTYEAR_FILE=$(sed -n '/SPDX-FileCopyrightText:.*BWI GmbH/ {s/.*SPDX-FileCopyrightText:[^0-9]*//;s/[^0-9].*//;p}' "$FILENAME")
if [ -n "$STARTYEAR_FILE" ] && [ "$STARTYEAR_FILE" -lt "$STARTYEAR" ]; then
    STARTYEAR=$STARTYEAR_FILE
fi
ENDYEAR=$(git log --follow --format=%as "$FILENAME" | head -n 1 | grep -o ^....)
if [ "$STARTYEAR" = "$ENDYEAR" ]; then
    COPYRIGHTYEARS="$STARTYEAR"
else
    COPYRIGHTYEARS="$STARTYEAR–$ENDYEAR"
fi

# Ensure SPDX license tag exists
if ! grep -q "SPDX-License-Identifier:" "$FILENAME"; then
    echo "$FILENAME: SPDX license tag not found. Adding…"
    sed -i "1 i{{/* SPDX-License-Identifier: Apache-2.0 */}}" "$FILENAME"
fi
# Ensure BWI copyright exists
if ! grep -q "SPDX-FileCopyrightText:.*BWI GmbH" "$FILENAME"; then
    echo "$FILENAME: BWI copyright not found. Adding…"
    sed -i "1 i{{/* SPDX-FileCopyrightText: BWI GmbH */}}" "$FILENAME"
fi
# Write copyright year range to file
sed -i "s|{{/\* SPDX-FileCopyrightText:.*BWI GmbH \*/}}|{{/* SPDX-FileCopyrightText: $COPYRIGHTYEARS BWI GmbH */}}|" "$FILENAME"
