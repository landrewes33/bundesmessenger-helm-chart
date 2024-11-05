#!/bin/sh
# SPDX-FileCopyrightText: 2024 BWI GmbH
# SPDX-License-Identifier: Apache-2.0
#
# Das Script dient zur Fake-Überwachung vom signing-key-job

# Überprüfen der Anzahl der übergebenen Parameter
# Optionen und ihre Standardwerte
option=""

# Optionen parsen
while getopts o: opt; do
  case $opt in
    o)
      option=$OPTARG
      ;;
    \?)
      echo "Ungültige Option: -$OPTARG"
      echo "[-o ready] für readiness oder [-o health] für healtcheck"
      exit 1
      ;;
  esac
done

# Überprüfen der Eingabeoption
case $option in
  ready)
    if test -f "/usr/local/bin/generate_signing_key" ; then
      #Job ist bereit
      exit 0
    else
      exit 1
    fi
    ;;
  health)
    if pgrep -f "generate_signing_key.py" >/dev/null || pgrep -f "/scripts/signing-key.sh" >/dev/null ; then
    #Job läuft, alles gut
      exit 0
    else
    #Job läuft nicht
      exit 1
    fi
    ;;
  *)
    echo "Ungültige Eingabeoption. Bitte ready oder health als Option angeben angeben."
    exit 1
    ;;
esac

