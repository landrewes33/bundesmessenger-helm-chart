#!/bin/sh
# SPDX-FileCopyrightText: 2024–2025 BWI GmbH
# SPDX-License-Identifier: Apache-2.0
#
# Generates the values.schema.json from values.schema.yaml

yq --output-format=json \
    "{ \
        \"\$schema\": null, \
        \"\$id\": null, \
        \"\$comment\": \
            \"Do not modify by hand. This file is auto-generated from values.schema.yaml\" \
    } * ." \
< values.schema.yaml \
> values.schema.json
