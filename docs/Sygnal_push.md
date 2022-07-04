_Übersetzt von https://github.com/matrix-org/sygnal_
# App-Typen
Es gibt zwei unterstützte App-Typen:

## apns
Damit werden Push-Benachrichtigungen an iOS-Apps über den Apple Push Notification Service (APNS) gesendet.

Die erwartete Konfiguration hängt von der Art der Authentifizierung ab, die Sie verwenden möchten.

Bei zertifikatsbasierter Authentifizierung wird erwartet:


- Der Parameter ``` certfile ``` muss ein Pfad relativ zum Arbeitsverzeichnis von sygnal einer PEM-Datei sein, die das APNS-Zertifikat und den unverschlüsselten privaten Schlüssel enthält.

Für die Token-basierte Authentifizierung erwartet er:


- den Parameter ```keyfile``` als Pfad relativ zum Arbeitsverzeichnis von Sygnal für eine p8-Datei

- den Parameter ```key_id```
- den ```team_id```-Parameter
- den ```topic```-Parameter, der in der Regel der "Bundle Identifier" für Ihre iOS-Anwendung ist

Für beide Typen kann er akzeptiert werden:

- den ```platform```-Parameter, der bestimmt, ob die APNS-Umgebung "production" oder "sandbox" verwendet wird. Gültige Werte sind 'production' oder 'sandbox'. Wenn er nicht angegeben wird, wird "production" verwendet.
- den Parameter ```push_type```, der bestimmt, welcher Wert für den apns-push-type-Header an APNs gesendet wird. Wenn er nicht angegeben wird, wird der Header nicht gesendet.
## gcm
Diese Funktion sendet Nachrichten über Google/Firebase Cloud Messaging (GCM/FCM) und kann daher verwendet werden, um Benachrichtigungen an Android-Anwendungen zu übermitteln. Der Parameter "```api_key```" muss den "Server-Schlüssel" enthalten, der von der Firebase-Konsole unter ```https://console.firebase.google.com/project/<PROJEKTNAME>/settings/cloudmessaging/``` abgerufen werden kann.

# Verwendung eines HTTP-Proxys für ausgehenden Datenverkehr
Sygnal erkennt standardmäßig beim Start automatisch eine ```HTTPS_PROXY```-Umgebungsvariable.

Wenn eine solche vorhanden ist, wird sie für den ausgehenden Datenverkehr zu APNs und GCM/FCM verwendet.

Derzeit werden nur HTTP-Proxys mit der CONNECT-Methode unterstützt. (Sowohl APNs als auch FCM verwenden HTTPS-Verkehr, der in einem CONNECT-Tunnel getunnelt wird).

Wenn Sie möchten, können Sie stattdessen einen HTTP-CONNECT-Proxy in sygnal.yaml konfigurieren.

# Konfiguration der Pusher-Daten
Die folgenden Parameter können im Wörterbuch [data]{.title-ref} angegeben werden, das bei der Konfiguration des Pusher über ```POST /_matrix/client/r0/pushers/set``` angegeben wird:

```default_payload```: ein Wörterbuch, das die grundlegende Nutzlast definiert, die an den Benachrichtigungsdienst gesendet wird. Sygnal fügt die für das Push-Ereignis spezifischen Informationen in dieses Wörterbuch ein. Wenn es nicht gesetzt ist, wird das leere Wörterbuch verwendet.

Dies kann für Clients nützlich sein, um Standard-Push-Payload-Inhalte festzulegen. So haben iOS-Clients beispielsweise die Freiheit, stille/veränderbare Benachrichtigungen zu verwenden und können einige Standardfelder für Warnungen/Töne/Badges festlegen.
