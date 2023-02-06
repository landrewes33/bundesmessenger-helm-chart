#!/bin/sh

# Script to check image availability in container registry
# Parameters:
# - $1: Path to input file / helm template

images=$(yq -N '..|.image?|select(.)' $1 | sort -u)

success=0
error=0
for item in $images; do
    echo -e "\nInspect: $item"
    if skopeo inspect "docker://$item" > /dev/null; then
        echo -e "\e[0;32mVerfügbar\e[0m"
        success=$((success+1))
    else
        echo -e "\e[0;31mFehler\e[0m"
        error=$((error+1))
    fi
done

echo -e "Zusammenfassung"
echo -e "\e[0;32mVerfügbar: $success\e[0m"
echo -e "\e[0;31mFehler: $error\e[0m"

if [ "$error" -ne 0 ]; then
    echo -e "\e[31mMindestens ein Image wurde nicht gefunden.\e[39m"
    exit 1
fi
