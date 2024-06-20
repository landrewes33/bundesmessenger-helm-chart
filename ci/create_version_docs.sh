#!/usr/bin/env sh

# Script to create docs of used images and dependencies in specific version.
# yq is required in PATH.
#
# Parameters:
# - $1: version number to read (file: ci/versions/v"version".yaml)

set -e

if [ "$#" -ne 1 ]; then
  echo "Incorrect number of arguments"
  exit 1
fi

version=$1
scriptDir=$(readlink -f "$0" | xargs dirname)

docs_output_file=$scriptDir/../docs/versions/v$version.md
version_content=$(yq '.[]' "$scriptDir/versions/v$version.yaml")

echo "Generate doc \"$docs_output_file\""
{
  echo "# Abhängigkeiten BundesMessenger Helm Chart $version ($(echo "$version_content" | yq '.date'))"
  echo
  echo "## Container Images"
  echo
  echo "| Name | Image | Tag |"
  echo "|---------|---------|---------|"
  echo "$version_content" | yq '
    .images |
    map(
      "| " +
      .name +
      " | " +
      .image +
      " | " +
      (.tag // "") +
      " |"
    ) |
    join("\n")
  '

  echo
  echo "## Helm Charts"
  echo
  echo "| Name | Version | Repository |"
  echo "|---------|---------|---------|"
  echo "$version_content" | yq '
    .helm |
    map(
      "| " +
      .name +
      " | " +
      (.version // "") +
      " | " +
      .repository +
      " |"
    ) |
    join("\n")
  '
} > "$docs_output_file"
