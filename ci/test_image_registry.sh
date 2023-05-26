#!/bin/sh

# Script to check image availability in container registry
# Parameters:
# - $1: Path to input file / helm template

images=$(yq -N '..|.image?|select(.)' $1 | sort -u)

success=0
error=0
for item in $images; do
    printf "Image: $item\n"
    if $(skopeo inspect "docker://$item" > /dev/null 2>&1); then
        printf "\033[0;32m✅ Verfügbar\033[0m\n"
        success=$((success+1))
    else
        printf "\033[0;31m❌ Fehler\033[0m\n"
        error=$((error+1))
    fi
    echo "---"
done

printf "\033[1;35mZusammenfassung\033[0m\n"
printf "\033[0;32m✅ Verfügbar: $success\033[0m\n"
printf "\033[0;31m❌ Fehler: $error\033[0m\n"

if [ "$error" -ne 0 ]; then
    printf "\033[31m❌ Mindestens ein Image wurde nicht gefunden.\033[39m\n"
    exit 1
fi
