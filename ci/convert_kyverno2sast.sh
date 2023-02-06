#!/bin/sh

# Script to convert kyverno report into Gitlab SAST Report
# Parameters:
# - $1: Path to input file / Kyverno Report
# - $2: Path to output file / JSON Gitlab SAST Report

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
export $(yq eval-all "${severities}" rl-kyverno/policies/*.yaml)


# build SAST report
query='.results |
    map(select(.result != "pass" and .result != "skip")) |
    map(
    .description = .message |
    .message = .resources[0].kind + "/" + .resources[0].name + " -> " + .policy |
    . +
        {"scanner":{
            "id":"kyverno", "name":"Kyverno"
        },
        "identifiers":[
            {"type":"kyverno_policy_id","name":.policy,"value":.policy},
            {"type":"kyverno_rule_id","name":.rule,"value":.rule}
        ],
        "location":{
            "file":.resources[0].kind + "/" + .resources[0].name + ".dummy",
            "class":.resources[0].kind + "/" + .resources[0].name
        },
        "category":"sast",
        "id":.rule + "-" + .policy + "-" + .resources[0].kind + "-" + .resources[0].name,
        "cve":.rule + "-" + .policy + "-" + .resources[0].kind + "-" + .resources[0].name,
        "severity":"${severity_" + .policy + "}" | sub("-","_") | envsubst,
        "confidence":"High"} |
    del(.resources) |
    del(.timestamp) |
    del(.source) |
    del(.scored) |
    del(.result) |
    del(.policy) |
    del(.rule)
    ) | {"version":"14.1.3", "vulnerabilities":.}
'
yq "${query}" $1 -o=json > $2
