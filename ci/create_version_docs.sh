#!/usr/bin/env sh

# Script to create docs of used images and dependencies in specific version.
# yq is required in PATH.
#
# Parameters:
# - $1: version number to read (file: ci/versions/v"version".yaml)

if [ "$#" -ne 1 ]
then
  echo "Incorrect number of arguments"
  exit 1
fi

version=$1
scriptDir=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))

docs_output_file=$scriptDir/../docs/versions/v$version.md
version_content=$(yq '.[]' $scriptDir/versions/v$version.yaml)


# generate docs
echo "Generate doc \"$docs_output_file\""

echo "# Abhängigkeiten BundesMessenger Helm Chart $version ($(echo "$version_content" | yq '.date'))\n" > $docs_output_file

echo "## Container Images\n" >> $docs_output_file
echo "| Name | Image | Tag |\n|---------|---------|---------|" >> $docs_output_file
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
' >> $docs_output_file

echo "" >> $docs_output_file
echo "## Helm Charts\n" >> $docs_output_file
echo "| Name | Version | Repository |\n|---------|---------|---------|" >> $docs_output_file
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
' >> $docs_output_file
