# Push-Service mit Sygnal

Um diesen Dienst nutzen zu können, muss der Matrix-Dienst mit der öffentlichen
(bzw. closed network) erreichbaren URL des Matrix-Servers bei der BWI GmbH registriert
und freigeschaltet sein.
Dadurch erhalten Sie von uns die entsprechende Konfiguration,
mit der Sie den Dienst aktivieren und nutzen können.

Den Nutzern werden damit Benachrichtigungen bei neuen ungelesenen Nachrichten
auf den mobilen Apps angezeigt.

- Quelle: https://github.com/element-hq/sygnal
- Beispielkonfiguration: https://github.com/element-hq/sygnal/blob/main/sygnal.yaml.sample

## App-Typen

Sygnal unterstützt Push-Benachrichtigungen über den
[Apple Push Notification Service (APNS)](#apple-ios-apns)
und über das [Firebase Cloud Messaging (FCM)](#google-android-gcm) von Google.

### Apple iOS (`apns`)

Damit werden Push-Benachrichtigungen an iOS-Apps über den
Apple Push Notification Service (APNS) gesendet.

Die erwartete Konfiguration hängt von der Art der Authentifizierung ab, die
Sie verwenden möchten.

- Bei Zertifikats-basierter Authentifizierung wird erwartet:
  - Der Parameter `certfile` muss ein Pfad relativ zum Arbeitsverzeichnis von
  Sygnal einer PEM-Datei sein, die das APNS-Zertifikat und den
  unverschlüsselten privaten Schlüssel enthält.
- Für die Token-basierte Authentifizierung wird erwartet:
  - der Parameter `keyfile` als Pfad relativ zum Arbeitsverzeichnis von Sygnal
  für eine p8-Datei
  - der Parameter `key_id`
  - der Parameter `team_id`
  - der Parameter `topic`, der in der Regel der "Bundle Identifier" für Ihre
  iOS-Anwendung ist

Für beide Typen wird zusätzlich optional akzeptiert:

- der Parameter `platform`, der bestimmt, ob die APNS-Umgebung `production`
  oder `sandbox` verwendet wird. Gültige Werte sind `production` oder
  `sandbox`. Wenn er nicht angegeben wird, wird `production` verwendet.
- der Parameter `push_type`, der bestimmt, welcher Wert für den
  `apns-push-type`-Header an APNs gesendet wird. Wenn er nicht angegeben wird,
  wird der Header nicht gesendet.

Das `keyfile` muss als Schlüssel-Werte-Paar innerhalb eines Kubernetes Secrets
angegeben werden. Dabei entspricht der Schlüssel dem Dateinamen und der Wert dem
Inhalt der Datei (siehe Definition [Sygnal Secret]). Mit der Einstellung
`sygnal.existingSecret` wird das von Sygnal zu verwendende Secret über seinen
Namen referenziert.

### Google Android (`gcm`)

Diese Funktion sendet Nachrichten über (Google) Firebase Cloud Messaging
(FCM, ehemals GCM) und kann verwendet werden, um Benachrichtigungen an
Android-Anwendungen zu übermitteln.

- Der Parameter `api_version` muss `v1` enthalten
- Der Parameter `project_id` muss die `Projekt-ID` enthalten, die von der
  Firebase-Konsole unter folgender Adresse abgerufen werden kann:
  `https://console.cloud.google.com/project/<PROJECT NAME>/settings/general/`
- Der Parameter `service_account_file`, der den Pfad zur Dienstkontodatei enthält,
  die in der Firebase-Konsole unter folgender Adresse abgerufen werden kann:
  `https://console.firebase.google.com/project/<PROJECT NAME>/settings/serviceaccounts/adminsdk`

Das `service_account_file` muss als Schlüssel-Werte-Paar innerhalb eines
Kubernetes Secrets angegeben werden. Dabei entspricht der Schlüssel dem
Dateinamen und der Wert dem Inhalt der Datei (siehe Definition [Sygnal Secret]).
Mit der Einstellung `sygnal.existingSecret` wird das von Sygnal zu verwendende
Secret über seinen Namen referenziert.

[Sygnal Secret]: <../templates/secrets.yaml#:~:text=name:%20sygnal>

## Verwendung eines HTTP-Proxys für ausgehenden Datenverkehr

Sygnal erkennt standardmäßig beim Start automatisch eine
`HTTPS_PROXY`-Umgebungsvariable.
Wenn eine solche vorhanden ist, wird sie für den ausgehenden Datenverkehr zu
APNS und FCM verwendet.

Derzeit werden nur HTTP-Proxys mit der CONNECT-Methode unterstützt. (Sowohl
APNS als auch FCM verwenden HTTPS-Verkehr, der in einem CONNECT-Tunnel
getunnelt wird).

Alternativ kann der Proxy direkt in der Konfiguration über den Schalter `proxy`
angegeben werden.

## Nutzung eines Secrets für Sygnal Push Konfiguration

Es ist empfohlen geheime Zugangsdaten, Passwörter und Tokens als Secret
zu mounten und nicht als unverschlüsselten Text im Helm-Chart anzugeben.

Dafür kann der Konfigurationsschalter `sygnal.existingSecret` mit dem Namen
eines vorhandenen Secrets besetzt werden.

Die Schlüssel des Secrets sind die Dateinamen der Zugangsschlüssel für FCM und
APN. Um beispielsweise ein Secret mit Namen `sygnal-pusher-secret` zu erstellen,
das die beiden Schlüsseldateien `MyKey.p007` und `fcm-example.json` enthält,
kann der folgende Befehl verwendet werden:

```sh
kubectl --namespace=bum create secret generic "sygnal-pusher-secret" \
  --from-file="MyKey.p007" \
  --from-file="fcm-example.json"
```

Die so hinterlegten Dateien werden auch unter `sygnal.apps` referenziert und mit
in den Container eingebunden. In der Referenzierung wird der Dateiname samt Pfad
angegeben, in diesem Fall mit dem Präfix `/secrets`. Als Beispiel:

Secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: sygnal-pusher-secret
  namespace: bum
stringData:
  fcm-example.json: |
    [...]
data:
  MyKey.p007: [...]
```

Konfiguration:

```yaml
sygnal:
  enabled: true
  existingSecret: sygnal-pusher-secret
  apps:
    de.bwi.messenger.x.ios.example:
      type: apns
      keyfile: /secrets/MyKey.p007
      [...]
    de.bwi.messenger.x.android.prod:
      type: gcm
      [...]
      service_account_file: /secrets/fcm-example.json
```

Die Konfigurationen, welche wir registrierten Nutzerhäusern zur Verfügung
stellen, enthalten bereits die richtigen Angaben. Diese können zur nachhaltigen
Nutzung auch manuell in ein Secret und in ein Vault überführt werden.

Werden noch die abgekündigten Optionen `ioskey_filename`, `ioskey_keyvalue`,
`fcmkey_filename` oder `fcmkey_keyvalue` verwendet, so wird im Zuge eines
Deployment ein Secret mit den Schlüsseln angelegt, wenn nicht bereits vorhanden.
