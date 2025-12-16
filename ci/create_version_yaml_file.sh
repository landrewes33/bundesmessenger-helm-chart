#!/usr/bin/env sh

# Script to generate ci/versions/v"version".yaml from current version of values.yaml.
# yq is required in PATH.
#
# Parameters:
# - $1: version number to set (file: ci/versions/v"version".yaml)

set -e

if [ "$#" -ne 1 ]; then
  echo "Incorrect number of arguments"
  exit 1
fi

version=$1
scriptDir=$(readlink -f "$0" | xargs dirname)

chart_file=$scriptDir/../Chart.yaml
values_file=$scriptDir/../values.yaml
mapping_file=$scriptDir/versions/mapping_versions.yaml
version_file=$scriptDir/versions/v${version}.yaml


# Um nicht mehrfach den Inhalt aus der Datei zu laden, laden der wesentliche Informationen in Variablen.
mapping_content=$(yq '.' "$mapping_file")
chart_content=$(yq '.' "$chart_file")

if [ -f "$version_file" ]; then
  printf "\033[31mWARNING: Die Version %s (%s) existiert bereits und wird überschrieben.\033[39m\n" "$version" "$version_file" >&2
fi

version="$version" \
date="$(date -u -I)" \
yq -n '[{
  "version": strenv(version),
  "tag": "v" + strenv(version),
  "date": strenv(date)
}]' | tee "$version_file" > /dev/null

# Schleife durch jeden Pfad in der Mapping-Datei, da dieser eindeutig ist.
loop_var=$(echo "$mapping_content" | yq '.[].path')
for path in $loop_var ; do
  # Aus dem Mapping den App-Namen zu dem Pfad auslesen
  app=$(echo "$mapping_content" | yq ".[] | select(.path == \"$path\") | .app")

  echo "Run \"$app\" in \"$path\""

  # Die Werte zu dem Pfad aus der values.yaml auslesen
  values_content=$(yq ".$path" "$values_file")

  # falls die registry ein extra Wert ist, z.B. bei Bitnami Charts
  if [ "$(echo "$values_content" | yq 'has("registry")')" = "true" ]; then
    registry=$(echo "$values_content" | yq '.registry')/
  else
    registry=""
  fi

  # neue Werte sammeln
  name=$app \
  image=$registry$(echo "$values_content" | yq '.repository') \
  tag=$(echo "$values_content" | yq '.tag') \
  yq -i '.[].images += [{
    "name": strenv(name),
    "image": strenv(image),
    "tag": strenv(tag)
  }]' "$version_file"
done

# Doppele Images entfernen
yq -i '.[].images |= unique_by(.name)' "$version_file"


# Schleife durch jede Dependency und aus der Chart.yaml übernehmen
# Benutzt Index anstatt Namen, da dependencies doppelt vorkommen können
indexes=$(echo "$chart_content" | yq '.dependencies | keys | .[]')

for i in $indexes ; do
  dep="$(echo "$chart_content" | yq ".dependencies[$i].name")"
  echo "Run dependency \"$dep\""

  dep=$dep \
  version=$(echo "$chart_content" | yq ".dependencies[$i].version") \
  repository=$(echo "$chart_content" | yq ".dependencies[$i].repository") \
  yq -i '.[].helm += [{
    "name": strenv(dep),
    "version": strenv(version),
    "repository": strenv(repository)
  }]' "$version_file"
done
