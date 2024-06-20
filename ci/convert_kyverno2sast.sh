#!/usr/bin/env sh

# Script to convert kyverno report into Gitlab SAST Report.
# yq is required in PATH.
#
# Parameters:
# - $1: Path to input file / Kyverno Report
# - $2: Path to output file / JSON Gitlab SAST Report

time=$(date -u +'%FT%T')
kyverno_version=$(kyverno version | yq '.Version')
export time kyverno_version

# get attributes/annotations/labels from policies
# because this information are not part of the kyverno report
# export them to environment var to use them later
# environment vars must not have "-"
severities='[.] |
    map({
        "policy":.metadata.name,
        "severity":.metadata.labels."policies.opencode.de/bsi-protection-requirement" // "Unknown"
    }) |
    .[] |=
    (
        with(select(.severity == "basic");
            .severity = "Low"
        ) |
        with(select(.severity == "standard");
            .severity = "Medium"
        ) |
        with(select(.severity == "elevated");
            .severity = "High"
        )
    ) |
    map(
        "severity_" + (.policy // "Unknown") + "=" + .severity
    ) | join(" ") | sub("-","_")
'
serverity_envs=$(yq eval-all "$severities" richtlinien-umsetzung-kyverno/policies/*.yaml)
# shellcheck disable=SC2086
export ${serverity_envs?}


# build SAST report
# shellcheck disable=SC2016
query='.results |
    map(select(.result != "pass" and .result != "skip")) |
    map(
    .description = .message |
    .message = .resources[0].kind + "/" + .resources[0].name + " -> " + .policy |
    . + {
        "identifiers":[
            {"type":"kyverno_policy_id","name":.policy,"value":.policy},
            {"type":"kyverno_rule_id","name":.rule,"value":.rule}
        ],
        "location":{
            "file":.resources[0].kind + "/" + .resources[0].name + ".dummy",
            "class":.resources[0].kind + "/" + .resources[0].name
        },
        "id":.rule + "-" + .policy + "-" + .resources[0].kind + "-" + .resources[0].name,
        "severity":"${severity_" + .policy + "}" | sub("-","_") | envsubst
    } |
    del(.resources) |
    del(.timestamp) |
    del(.source) |
    del(.scored) |
    del(.result) |
    del(.policy) |
    del(.rule)
    ) | {
        "version":"15.0.4",
        "scan":{
            "analyzer":{
                "id":"bwi_script",
                "name":"BWI Script",
                "version":"1.0.0",
                "vendor":{"name":"BWI"},
                "url":"https://www.bwi.de/"
            },
           "scanner":{
                "id":"kyverno",
                "name":"Kyverno",
                "version":strenv(kyverno_version),
                "vendor":{"name":"Kyverno"},
                "url":"https://kyverno.io/"
            },
            "start_time":strenv(time),
            "end_time":strenv(time),
            "status":"success",
            "type":"sast"
        },
        "vulnerabilities":.
    }
'
yq "$query" "$1" -o=json > "$2"
