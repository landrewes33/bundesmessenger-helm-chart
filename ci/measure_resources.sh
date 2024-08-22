#!/usr/bin/env sh

# Script zum Messen der definierten angefragten und maximalen Ressourcen.
# Einfaches Summieren über alle Angaben. Berücksichtigt kein HPA oder
# geclusterte Pods wie z.B. Worker.
# yq is required in PATH.
#
# Parameters:
# - $1: Kubernetes manifest file (helm template)

if [ "$#" -ne 1 ]
then
  echo "Incorrect number of arguments"
  exit 1
fi

if [ ! -f "$1" ]; then
  printf "\033[31mWARNING: File does not exists.\033[39m\n"
  exit 1
fi

resources_minmax='requests limits'
resources_kind='cpu memory'

for minmax in $resources_minmax; do
    for kind in $resources_kind; do

        printf '%s' "$minmax $kind"
        res=$(yq -N "..| .resources? | select(has(\"$minmax\")) | .$minmax.$kind| select (.)" "$1")

        # debug, print list of definitions
        # printf '\n%s' $res

        tot=0
        for i in $res; do
            if expr "$i" : ".*m" > /dev/null || expr "$i" : ".*Mi" > /dev/null ; then
                i=$(echo "$i" | sed 's/[^0-9]*//g')
                tot=$(( tot + i ))
            elif  expr "$i" : ".*Gi" > /dev/null ; then
                i=$(echo "$i" | sed 's/[^0-9]*//g')
                tot=$(( tot + i*1000 ))
            else
                tot=$(( tot + i*1000 ))
            fi
        done
        printf '\t%s\n' "$tot"
    done
done
