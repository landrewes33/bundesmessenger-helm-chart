#!/bin/sh
# SPDX-FileCopyrightText: 2024–2025 BWI GmbH
# SPDX-License-Identifier: Apache-2.0
#
# Rewrites the license header of the given YAML file to match its git history.
set -e

usage() {
    echo "Usage: $0 <helm|sh|yaml> <filename>"
    echo "$1"
    exit 1
}

# Check that comment type is provided as first argument
case "$1" in
    sh|yaml)
        COMMENT="# %s"
        COMMENT_REGEX="# %s";;
    helm)
        COMMENT="{{/* %s */}}"
        COMMENT_REGEX="{{/\* %s \*/}}";;
    *) usage "Comment type must be 'helm', 'sh' or 'yaml', but was '$1'.";;
esac

# Check if filename is provided as second argument
[ -z "$2" ] && usage "You must provide a filename as the second argument."
FILENAME="$2"

echo "Processing file: $FILENAME"

STARTYEAR=$(git log --follow --format=%as "$FILENAME" | tail -n 1 | grep -o ^....)
# Use earlier start date from file, if already there
STARTYEAR_FILE=$(sed -n '/SPDX-FileCopyrightText:.*BWI GmbH/ {s/.*SPDX-FileCopyrightText:[^0-9]*//;s/[^0-9].*//;p;q}' "$FILENAME")
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
    # shellcheck disable=SC2059
    sed -i "1 i$(printf "$COMMENT" "SPDX-License-Identifier: Apache-2.0")" "$FILENAME"
fi
# Ensure BWI copyright exists
if ! grep -q "SPDX-FileCopyrightText:.*BWI GmbH" "$FILENAME"; then
    echo "$FILENAME: BWI copyright not found. Adding…"
    # shellcheck disable=SC2059
    sed -i "1 i$(printf "$COMMENT "SPDX-FileCopyrightText: BWI GmbH)" "$FILENAME"
fi
# Write copyright year range to file
# shellcheck disable=SC2059
FIND=$(printf "$COMMENT_REGEX" "SPDX-FileCopyrightText:.*BWI GmbH")
# shellcheck disable=SC2059
REPLACE=$(printf "$COMMENT" "SPDX-FileCopyrightText: $COPYRIGHTYEARS BWI GmbH")
sed -i "s|$FIND|$REPLACE|" "$FILENAME"
