#!/usr/bin/env sh

# Script to generate ci/versions/v"version".yaml from current version of values.yaml.
# yq is required in PATH.
#
# Parameters:
# - $1: version number to set (file: ci/versions/v"version".yaml)

set -e

if [ "$#" -ne 1 ]
then
  echo "Incorrect number of arguments"
  exit 1
fi

version=$1
scriptDir=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))

chart_file=$scriptDir/../Chart.yaml
values_file=$scriptDir/../values.yaml
mapping_file=$scriptDir/versions/mapping_versions.yaml
version_file=$scriptDir/versions/v${version}.yaml


# Um nicht mehrfach den Inhalt aus der Datei zu laden, laden der wesentliche Informationen in Variablen.
mapping_content=$(yq '.' $mapping_file)
chart_content=$(yq '.' $chart_file)

if [ -f "$version_file" ]; then
  printf "\033[31mWARNING: Die Version $version (${version_file}) existiert bereits und wird überschrieben.\033[39m\n" >&2
fi

yq -n '[{
  "version": "'$version'",
  "tag": "v'$version'",
  "date": "'$(date -u +'%Y-%m-%d')'"
}]' > $version_file

# Schleife durch jeden Pfad in der Mapping-Datei, da dieser eindeutig ist.
loop_var=$(echo "$mapping_content" | yq '.[].path')
for path in $loop_var ; do
  # Aus dem Mapping den App-Namen zu dem Pfad auslesen
  app=$(echo "$mapping_content" | yq '.[] | select(.path == "'$path'") | .app')

  echo "Run \"$app\" in \"$path\""

  # Die Werte zu dem Pfad aus der values.yaml auslesen
  values_content=$(yq '.'$path'' $values_file)

  # falls die registry ein extra Wert ist, z.B. bei Bitnami Charts
  if [ $(echo "$values_content" | yq 'has("registry")') = "true" ]; then
    registry=$(echo "$values_content" | yq '.registry')/
  else
    registry=""
  fi

  # neue Werte sammeln
  yq -i '.[].images += [{
    "name": "'$app'",
    "image": "'$registry$(echo "$values_content" | yq '.repository')'",
    "tag": "'$(echo "$values_content" | yq '.tag')'"
  }]' $version_file
done

# Synpase Tag wird über die Chart.yaml gesteuert und
# via Helm-Template (_helpers.tpl - define "matrix-synapse.imageTag")
# um einen statischen Teil ergänzt
yq -i '.[].images[] |=
  select(.name == "Synapse").tag =
    "'$(echo "$chart_content" | yq '.appVersion')'-jammy-production"' $version_file

# Doppele Images entfernen
yq -i '.[].images |= unique_by(.name)' $version_file


# Schleife durch jede Dependency und aus der Chart.yaml übernehmen
loop_var=$(echo "$chart_content" | yq '.dependencies[].name')
for dep in $loop_var ; do
  echo "Run dependency \"$dep\""

  yq -i '.[].helm += [{
    "name": "'$dep'",
    "version": "'$(echo "$chart_content" | yq '.dependencies[] | select(.name == "'$dep'") | .version')'",
    "repository": "'$(echo "$chart_content" | yq '.dependencies[] | select(.name == "'$dep'") | .repository')'"
  }]' $version_file
done
