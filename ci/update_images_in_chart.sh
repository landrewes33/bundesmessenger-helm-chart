#!/usr/bin/env sh

# Script to update images and tags in values.yaml.
# yq is required in PATH.
#
# Parameters:
# - $1: version number to set (file: ci/versions/v"version".yaml)

if [ "$#" -ne 1 ]
then
  echo "Incorrect number of arguments"
  exit 1
fi

version=$1
default_registry="registry.opencode.de"

scriptDir=$(readlink -f "$0" | xargs dirname)

values_file=$scriptDir/../values.yaml
mapping_file=$scriptDir/versions/mapping_versions.yaml
versions_dir="$scriptDir/versions/"


# Um nicht mehrfach den Inhalt aus der Datei zu laden, laden der wesentliche Informationen in Variablen.
version_content=$(yq ea ".[] | select(.version == \"$version\")" "$versions_dir"/*.yaml)
mapping_content=$(yq '.' "$mapping_file")

# ermitteln wie oft diese eine Version vorkommt
# Der String count_versions wird mit jedem Vorkommen der gleichen Version länger
# Zählen mit Hilfe von length funktioniert nicht, da es mehrere Dateien sind und yq nur je Datei zählt
count_versions=$(yq ea -N ".[] | select(.version == \"$version\") | .version | document_index" "$versions_dir"/*.yaml)

if [ ${#count_versions} -gt 1 ]; then
  printf "\033[31mERROR: Die Version %s wird %s Mal definiert.\033[39m\n" "$version" "${#count_versions}" >&2
  exit 1
elif [ ${#count_versions} -eq 0 ]; then
  printf "\033[31mERROR: Die Version %s wird nicht definiert.\033[39m\n" "$version" >&2
  exit 1
fi


# update values.yaml
loop_var=$(echo "$mapping_content" | yq '.[].path')

# Schleife durch jeden Pfad in der Mapping-Datei, da dieser eindeutig ist.
for path in $loop_var ; do
  # Aus dem Mapping den App-Namen zu dem Pfad auslesen
  app=$(echo "$mapping_content" | yq ".[] | select(.path == \"$path\") | .app")

  echo "Run \"$app\" in \"$path\""

  # Die Werte zu dem Pfad aus der values.yaml auslesen
  values_content=$(yq ".$path" "$values_file")

  # Aus den Versionsinformationen die Werte zu der App/Namen auslesen
  app_version_content=$(echo "$version_content" | yq ".images[] | select(.name == \"$app\")")

  if [ "$(echo "$values_content" | yq 'has("tag")')" = "true" ]; then
    tag=$(echo "$app_version_content" | yq '.tag')
    values_content=$(echo "$values_content" | yq ".tag = \"$tag\"")
  fi

  if [ "$(echo "$values_content" | yq 'has("repository")')" = "true" ]; then
    if [ "$(echo "$values_content" | yq 'has("registry")')" = "true" ]; then
      values_content=$(echo "$values_content" | yq ".registry = \"$(echo "$app_version_content" | yq '.registry // "'$default_registry'"')\"")
      values_content=$(echo "$values_content" | yq ".repository = \"$(echo "$app_version_content" | yq '.image')\"")
    else
      values_content=$(echo "$values_content" | yq ".repository = \"$(echo "$app_version_content" | yq '(.registry // "'$default_registry'") + "/" + .image')\"")
    fi
  fi

  # values_content zurück in die values.yaml schreiben
  # yq kann nur exportierete Variablen lesen
  export values_content
  # Leere Zeilen im YAML erhalten: https://github.com/mikefarah/yq/issues/515#issuecomment-1113420114
  yq ".$path = env(values_content)" "$values_file" | diff -B "$values_file" - | patch "$values_file" -
done
