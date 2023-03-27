#!/bin/sh

# Script to update images and tags in values.yaml
# Parameters:
# - $1: version number to set (file: ci/version/v"version".yaml)

version=$1
default_registry="registry.opencode.de"

scriptDir=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))

chart_file=$scriptDir/../Chart.yaml
values_file=$scriptDir/../values.yaml
mapping_file=$scriptDir/version/mapping_versions.yaml
version_file=$scriptDir/version/*.yaml
docs_output_file=$scriptDir/../docs/versions/v$version.md


# Um nicht mehrfach den Inhalt aus der Datei zu laden, laden der wesentliche Informationen in Variablen.
version_content=$(yq ea '.[] | select(.version == "'$version'")' $version_file)
mapping_content=$(yq '.' $mapping_file)
chart_content=$(yq '.' $chart_file)

# ermitteln wie oft diese eine Version vorkommt
# Der String count_versions wird mit jedem Vorkommen der gleichen Version länger
# Zählen mit Hilfe von length funktioniert nicht, da es mehrere Dateien sind und yq nur je Datei zählt
count_versions=$(yq ea -N '.[] | select(.version == "'$version'") | .version | document_index' $version_file)

if [ ${#count_versions} -gt 1 ]; then
  echo -e "\e[31mERROR: Die Version $version wird ${#count_versions} Mal definiert.\e[39m" >&2
  exit 1
elif [ ${#count_versions} -eq 0 ]; then
  echo -e "\e[31mERROR: Die Version $version wird nicht definiert.\e[39m" >&2
  exit 1
fi

# Umgang mit Helm dpendencies erfolgt in einem späteren Release
## update Chart.yaml
#
## Synpase Tag wird über die Chart.yaml gesteuert.
#export chart_content=$(echo "$chart_content" | yq '.appVersion = "'$(echo "$version_content" | yq '.images[] | select(.name == "Synapse") | .version')'"')
#
#export chart_content=$(echo "$chart_content" | yq '.version = "'$version'"')
#
## Dependencies aus der version.yaml importieren und die condition setzen
#export helm_version_content=$(echo "$version_content" | yq '.helm')
#chart_content=$(echo "$chart_content" | yq '.dependencies = env(helm_version_content)')
#chart_content=$(echo "$chart_content" | yq 'with(.dependencies[]; .condition = .name + ".enabled")')
#
## Leere Zeilen im YAML erhalten: https://github.com/mikefarah/yq/issues/515#issuecomment-1113420114
#yq '. = env(chart_content)' $chart_file | diff -B $chart_file - | patch $chart_file -


# update values.yaml
loop_var=$(echo "$mapping_content" | yq '.[].path')

# Schleife durch jeden Pfad in der Mapping-Datei, da dieser eindeutig ist.
for path in $loop_var ; do
  # Aus dem Mapping den App-Namen zu dem Pfad auslesen
  app=$(echo "$mapping_content" | yq '.[] | select(.path == "'$path'") | .app')

  echo "Run \"$app\" in \"$path\""

  # Die Werte zu dem Pfad aus der values.yaml auslesen
  values_content=$(yq '.'$path'' $values_file)

  # Aus den Versionsinformationen die Werte zu der App/Namen auslesen
  app_version_content=$(echo "$version_content" | yq '.images[] | select(.name == "'$app'")')

  if [ $(echo "$values_content" | yq 'has("tag")') = "true" ]; then
    values_content=$(echo "$values_content" | yq '.tag = "'$(echo "$app_version_content" | yq '.tag')'"')
  fi

  if [ $(echo "$values_content" | yq 'has("repository")') = "true" ]; then
    if [ $(echo "$values_content" | yq 'has("registry")') = "true" ]; then
      values_content=$(echo "$values_content" | yq '.registry = "'$(echo "$app_version_content" | yq '.registry // "'$default_registry'"')'"')
      values_content=$(echo "$values_content" | yq '.repository = "'$(echo "$app_version_content" | yq '.image')'"')
    else
      values_content=$(echo "$values_content" | yq '.repository = "'$(echo "$app_version_content" | yq '(.registry // "'$default_registry'") + "/" + .image')'"')
    fi
  fi

  # values_content zurück in die values.yaml schreiben
  # yq kann nur exportierete Variablen lesen
  export values_content
  # Leere Zeilen im YAML erhalten: https://github.com/mikefarah/yq/issues/515#issuecomment-1113420114
  yq '.'$path' = env(values_content)' $values_file | diff -B $values_file - | patch $values_file -
done


# generate docs
echo "Generate doc \"$docs_output_file\""

echo "# Abhängigkeiten BundesMessenger Helm Chart $version ($(echo "$version_content" | yq '.date'))\n" > $docs_output_file

echo "## Container Images\n" >> $docs_output_file
echo "| Name | Version | Image | Tag |\n|---------|---------|---------|---------|" >> $docs_output_file
echo "$version_content" | yq '
  .images |
  map(
    "| " +
    .name +
    " | " +
    (.version // "") +
    " | " +
    (.registry // "'$default_registry'") + "/" + .image +
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
