#!/usr/bin/env sh

# Script to check if newer images are available in container registry.
# skopeo and yq are required in PATH.
#
# Parameters:
# - f: version/file to use (default: current version in Chart.yaml)
# - t: task to do (default: check)
#   - check: only check if a newer version is available
#   - update: set latest version for all images
#   - ask: ask for decision for every image
# - n: Number of tags displayed when the ask option is selected. (default: 5)

default_registry="registry.opencode.de"

scriptDir=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))

chart_file=$scriptDir/../Chart.yaml
CHART_VERSION=$(grep "^version:" ${chart_file} | cut -d' ' -f2-)

while getopts f:t:n: flag
do
  case "${flag}" in
    f) version=${OPTARG};;
    t) task=${OPTARG};;
    n) number=${OPTARG};;
    \?) exit;;
  esac
done

task=${task:-check}
version=${version:-$CHART_VERSION}
count_show_tags=${number:-5}

if [ "$task" != "check" ] && [ "$task" != "update" ] && [ "$task" != "ask" ]; then
  printf "Ungültige Aufgabe (-t)\n"
  exit 1
fi


version_file=$scriptDir/versions/v$version.yaml

printf "Verarbeite Version: $version\n"
printf "Aufgabe: $task\n"
printf "Datei: $version_file\n"
printf -- "---\n"


# Um nicht mehrfach den Inhalt aus der Datei zu laden, laden der wesentliche Informationen in Variablen.
# nur die eigenen Images, z.B. nicht Postgres aus IGBvC
version_content=$(yq ea '.[].images | map(select(.image == "bwi/*"))' $version_file)

ret=$?
if [ $ret -ne 0 ]; then
  printf "Fehler beim lesen der Datei.\n"
  exit 1
fi

loop_var=$(echo "$version_content" | yq '.[].name')

up2date=0
notUp2date=0
updated=0
error=0
# Schleife durch jeden "name" in der Mapping-Datei, da dieser eindeutig ist.
for name in $loop_var ; do
  # Aus dem Mapping den App-Namen zu dem Pfad auslesen
  image=$(echo "$version_content" | yq '.[] | select(.name == "'$name'") | .image')
  current_tag=$(echo "$version_content" | yq '.[] | select(.name == "'$name'") | .tag')

  # ! Skopeo listet die Tags in der Reihenfolge aus, wie es diese von der Registry erhält.
  # Es ist keine Reihenfolge sortiert nach dem Alter garantiert.
  # Gitlab scheint dies nach Upload-Datum auszuliefern (wird hier genutzt).
  # U.U. muss die Abfrage mit Hilfe von "curl" oder "regctl" genauer gestaltet werden.
  printf "Run \"$name\" for \"$image\" with \"\033[0;32m$current_tag\033[0m\".\n"
  if skopeo_result=$(skopeo list-tags "docker://$default_registry/$image" 2>&1); then

    # filtert verschiedene Tags heraus
    all_tags=$(echo $skopeo_result | \
      yq '.Tags | map(select(
        (test(".*-b\d+$|^latest$") | not)
        and
        (test("production$"))
      )) | .')

    # gibt nur das letzte Tag zurück
    latest_tag=$(echo $all_tags | yq -P '.[-1:] | .[]')

    if [ "$latest_tag" = "$current_tag" ]; then
      printf "\033[0;32mIs up2date: ${current_tag}\033[0m\n"
      up2date=$((up2date+1))
    else
      printf "\033[0;31mLatest tag: ${latest_tag}\033[0m\n"
      skip=0

      # Ermitteln des Tags via Benutzerabfrage
      if [ "$task" = "ask" ]; then
        count_tags=$(echo $all_tags | yq '. | length')
        min=$(( count_show_tags < count_tags ? count_show_tags : count_tags))

        printf "Anzahl an Tags für das Image: ${count_tags}\n"
        printf "Zeige die letzten $min Tags:\n"
        echo $all_tags | yq '.[-'$(echo $min)':] | sort | reverse'

        while true; do
          read -p "Welches Tag soll verwendet werden? (\"a\" für Abbruch, \"n\" für Überspringen) " yn
          case $yn in
            [Aa]* ) exit 1;;
            [Nn]* ) skip=1; break;;
            * )
              # Es werden auch ältere, aber gültige Tags, die nicht angezeigt werden akzeptiert
              if [ $(echo $all_tags | yq '. | any_c(. == "'$(echo $yn)'")') = "true" ]; then
                read -p "Ist der ausgewählte Tag \"$yn\" richtig? (yes/no) default to yes? " confirm
                confirm=${confirm:-yes}
                if [ ${confirm} = "yes" ]; then
                  latest_tag=$yn
                  if [ "$latest_tag" = "$current_tag" ]; then
                    skip=1
                  fi
                  break
                fi
              else
                printf "Bitte einen gültigen Tag eingeben.\n"
              fi
              ;;
            esac
          done
      fi

      # Setzen der Auswahl des Benutzers bzw. das Neuste
      if [ "$task" = "update" ] || [ "$task" = "ask" ] && [ $skip -eq 0 ]; then
        printf "Aktualisiere \"$name\" von \"${current_tag}\" auf \"${latest_tag}\".\n"

        new_version=${latest_tag%%-*}  # remove all behind -
        new_version=${new_version#*_}  # remove all to _
        yq -i '
          (.[].images[] | select(.name == "'$name'") | .tag) = "'${latest_tag}'" |
          (.[].images[] | select(.name == "'$name'") | .version) = "'${new_version}'"
        ' $version_file
        printf "$name auf Version \`$new_version\` aktualisiert." > $scriptDir/../changelog.d/+$(echo "$name" | tr '[:upper:]' '[:lower:]').feature
        updated=$((updated+1))

      else # task = check and skipped
        notUp2date=$((notUp2date+1))
      fi
    fi
  else
    printf "\033[0;31m❌ Fehler\033[0m\n"
    error=$((error+1))
  fi
  printf -- "---\n"
done

printf "\033[1;35mZusammenfassung\033[0m\n"
printf "\033[0;32m✅ Aktuell: $up2date\033[0m\n"
printf "\033[0;32m✅ Aktualisiert: $updated\033[0m\n"
printf "\033[0;31m❌ Update verfügbar: $notUp2date\033[0m\n"

if [ "$error" -ne 0 ]; then
    printf "\033[31m❌ Mindestens ein Image wurde nicht gefunden.\033[39m\n"
    exit 1
fi
