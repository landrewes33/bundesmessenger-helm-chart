# Nutzerverwaltung

Zum Betrieb des BundesMessengers gehört das Anlegen, Verwalten und Sperren von
Nutzern. Empfohlenen ist die Nutzerverwaltung über eine externe IAM-Lösung
(Identity and Access Management). Alternativ kann die Nutzerverwaltung über
Administrationssoftware, wie den Synapse-Admin, oder direkt per
Synapse-Schnittstelle erfolgen. Auch die Möglichkeit einer offenen
Nutzerregistrierung existiert.

- [IAM-Lösung](#iam-lösung) ⭐
- [Anlegen von Nutzern auf dem Container mit `kubectl`](#anlegen-von-nutzern-auf-dem-container-mit-kubectl)
- [Synapse-Admin-Oberfläche](#synapse-admin-oberfläche)
- [Anlegen von Nutzern über die Admin-API](#anlegen-von-nutzern-über-die-admin-api)
- [Offene Registrierung](#offene-registrierung)

## IAM-Lösung

Empfohlen ist die Nutzerverwaltung über eine IAM-Lösung: Geeignet ist der Matrix
Authentication Service oder das klassische Single-Sign-On von Synapses zur
Anbindung:

- [Matrix Authentication Service](./matrix-authentication-service.md)
- [Synapse SSO](./matrix-authentication-service.md#anmeldung-via-single-sign-on-sso)

Für Testsysteme, bei sehr kleinen Installationen oder bei besonderen
Anforderungen können Nutzer auch direkter verwaltet werden. Im folgenden werden
die weiteren Methoden, die neben einer IAM-Lösung existieren, näher beschrieben.

## Anlegen von Nutzern auf dem Container mit `kubectl`

Nach der Installation sind in der Umgebung keine Benutzer vorhanden. Mindestens
der erste Benutzer muss per Kommandozeile angelegt werden. Weitere Benutzer
lassen sich im Anschluss auch per
[Admin API](https://element-hq.github.io/synapse/latest/admin_api/user_admin_api.html#create-or-modify-account)
(z.B. mit `curl`), der Administrationsoberfläche
[Synapse-Admin](https://github.com/Awesome-Technologies/synapse-admin) oder dem
[BundesMessenger Admin-Portal](./admin-portal.md) anlegen.

Am Ende der Installation werden die notwendigen Kommandozeilen ausgegeben.
In der Ausgabe sind die Umgebungsvariablen (Deployment und Namespace)
mit den richtigen Werten aus der Installation gesetzt.

Folgende Schritte sind erforderlich:

1. [Identifizieren des anzusprechenden Containers (Synapse-Hauptprozess)](#identifizieren-des-anzusprechenden-containers)
1. Anlegen des Benutzers auf der Kommandozeile innerhalb des Pods
    - [Benutzer **mit** Administratorrechten](#anlegen-eines-nutzers-mit-administratorrechten)
    - [Benutzer **ohne** Administratorrechten](#anlegen-eines-nutzers-ohne-administratorrechten)

### Identifizieren des anzusprechenden Containers

In dem Beispiel wird das Deployment mit den Namen `testmatrix` in dem Namespace
`bundesmessenger` verwaltet.

```console
export POD_NAME=$(kubectl get pods --namespace bundesmessenger -l "app.kubernetes.io/name=bundesmessenger,app.kubernetes.io/instance=testmatrix,app.kubernetes.io/component=synapse" -o jsonpath="{.items[0].metadata.name}")
```

### Anlegen eines Nutzers **mit** Administratorrechten

- NUTZER ist der Nutzername (der `localpart` der Matrix ID: `@localpart:example.com`).
- PASSWORT muss in `''` Single-Quotes gesetzt werden, sollte es Sonderzeichen enthalten.

```console
kubectl exec --namespace bundesmessenger $POD_NAME -- register_new_matrix_user -c /synapse/config/homeserver.yaml -u NUTZER -p 'PASSWORT' --admin http://localhost:8008
```

### Anlegen eines Nutzers **ohne** Administratorrechten

- NUTZER ist der Nutzername (der `localpart` der Matrix ID: `@localpart:example.com`).
- PASSWORT muss in `''` Single-Quotes gesetzt werden, sollte es Sonderzeichen enthalten.

```console
kubectl exec --namespace bundesmessenger $POD_NAME -- register_new_matrix_user -c /synapse/config/homeserver.yaml -u NUTZER -p 'PASSWORT' --no-admin http://localhost:8008
```

## Synapse-Admin-Oberfläche

Die Synapse-Admin-Oberfläche kann ganz einfach über die
BundesMessenger-Konfiguration aktiviert werden und ist dann unter der
angegebenen Domain erreichbar. Weitere Informationen dazu finden sich unter
[Synapse-Admin](./synapse-admin.md).

```yaml
adminAPIServerName: admin.example.com
synapse_admin:
  enabled: true
  uri: adminportal.example.com
```

## Anlegen von Nutzern über die Admin-API

Für das Verwenden der Admin-API benötigt man keinen Zugriff auf das
Kubernetes-Cluster, sondern nur ein Synapse-Administratorkonto. Die
Kommunikation mit der Schnittstelle erfolgt direkt über HTTPS. Das folgende
Skript benutzt beispielsweise `curl`, um eine große Anzahl von Nutzern mit Daten
aus einer CSV-Datei anzulegen.

> 📌 **Hinweis** – Empfohlen ist diese Variante nur zum Anlegen von Testnutzern.
> Für den Produktiveinsatz ist die Verwaltung über eine Adminoberfläche oder ein
> externes System zur Nutzerverwaltung empfohlen.

```bash
#!/usr/bin/env bash
# Erstellt Matrix-Nutzer aus der gegebenen CSV-Datei.
set -e

serverName="example.org"
admin_api="https://admin-api.$serverName"

# CSV-Datei mit Nutzerangaben und zwei Kopfzeilen
#
# ```csv
# # Liste von anzulegenden Matrix-Testnutzern
# # Name;MXID;Passwort
# Nadine Nutzermann;nadine;P13453!C#4N63!
# ```
USER_CSV_FILE=matrix-nutzer.csv
IFS=';'  # Trennzeichen


# Erfassen der notwendigen Daten
printf "\e[97mBitte geben Sie den Nutzernamen des Matrix-Admin an:\e[0m "
read -r admin_user
printf "\e[97mBitte geben Sie das Admin-Passwort ein:\e[0m "
read -r -s admin_passwort
echo

useragent="Matrix-Bash"
date=$(date +"%m-%d-%Y_%T")

echo "Login…"
json=$(curl -s -XPOST \
  --user-agent "$useragent" \
  -d "{ \
    \"type\": \"m.login.password\", \
    \"user\": \"$admin_user\", \
    \"password\": \"$admin_passwort\", \
    \"initial_device_display_name\": \"CLI-Script: $date\" \
  }" \
  "$admin_api/_matrix/client/v3/login" \
  --compressed \
  --show-error \
)

access_token=$(echo "$json" | jq -r ".access_token")

echo -e "Accesstoken (verkuerzt): \e[32m${access_token:0:10}…\e[0m"
if [ "$access_token" == "null" ]; then
  echo -e "\e[32mKein Access Token → Abbruch\e[0m"
  exit 1
fi

read -r -p "Press [Enter] key to proceed…"


# Benutzer anlegen bzw. abändern.
[ ! -f $USER_CSV_FILE ] && { echo "$USER_CSV_FILE file not found"; exit 99; }
while read -r name benutzer passwort
do
  username=$(echo "@$benutzer:$serverName" | tr "[:upper:]" "[:lower:]")

  sleep 1
  unset status
  status=$(curl -X PUT \
    --header "Authorization: Bearer $access_token" \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --user-agent "$useragent" \
    -d "{ \
      \"displayname\": \"$name\", \
      \"password\": \"$passwort\", \
      \"admin\": false, \
      \"deactivated\": false \
    }" \
    "$admin_api/_synapse/admin/v2/users/$username" \
    -s -o /dev/null -w "%{http_code}" \
    --compressed \
    --show-error \
  )
  echo -e "Benutzer erstellen:\t\e[31m$benutzer\e[0m\tHTTP-Status: \e[34m$status\e[0m"

done < <(tail -n +3 $USER_CSV_FILE | tr -d '\r')

echo "Abmelden…"
curl -X POST \
  --silent \
  --header "Authorization: Bearer $access_token" \
  --user-agent "$useragent" \
  --compressed \
  --show-error \
  "$admin_api/_matrix/client/v3/logout" \
> /dev/null
```

## Offene Registrierung

Um Nutzern zu ermöglichen, ihre Konten selbst anzulegen und zu verwalten, kann
die BundesMessenger-Konfiguration `extraConfig.enable_registration` verwendet
werden. Zusätzlich muss zum Schutz der Installation vor Missbrauch eine
Verifikationsmethode für die Registrierung aktiviert sein.

```yaml
extraConfig:
  # Erlaube die selbstständige Registrierung von Nutzern.
  enable_registration: true
  # Festlegen der verwendeten Verifikationsmethode, bspw. Token-basiert.
  registration_requires_token: true
```

Weitere Details dazu gibt es in der Synapse-Dokumentation zu
[`enable_registration`](https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#enable_registration).
