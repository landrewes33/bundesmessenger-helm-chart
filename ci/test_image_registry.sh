#!/bin/sh

# Script to check image availability in container registry
# Parameters:
# - $1: Path to input file / helm template

images=$(yq -N '..|.image?|select(.)' $1 | sort -u)

success=0
error=0
for item in $images; do
    echo -e "Image: $item"
    if $(skopeo inspect "docker://$item" > /dev/null 2>&1); then
        echo -e "\e[0;32m✅ Verfügbar\e[0m"
        success=$((success+1))
    else
        echo -e "\e[0;31m❌ Fehler\e[0m"
        error=$((error+1))
    fi
    echo "---"
done

echo -e "\e[1;35mZusammenfassung\e[0m"
echo -e "\e[0;32m✅ Verfügbar: $success\e[0m"
echo -e "\e[0;31m❌ Fehler: $error\e[0m"

if [ "$error" -ne 0 ]; then
    echo -e "\e[31m❌ Mindestens ein Image wurde nicht gefunden.\e[39m"
    exit 1
fi
