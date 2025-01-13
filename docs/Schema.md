# Schema

Die Konfiguration des BundesMessenger Helm-Charts wird durch [ein
JSON-Schema](../values.schema.yaml) beschrieben. Darin wird festgelegt, welche
Struktur die Konfiguration hat und welche Werte darin erlaubt sind. Im Falle
einer ungültigen Konfiguration gibt Helm bei Ausführung einen Fehler aus.

## Fehler im Schema

Es ist möglich, dass gültige Konfigurationen vom Schema fälschlicherweise nicht
akzeptiert werden. Eine schnelle Möglichkeit zur einmaligen Umgehung der
Überprüfung bietet dann die Kommandozeilenoption `--skip-schema-validation` von
Helm. Bitte gebt uns in einem solchen Fall Rückmeldung über einen unserer
[Kommunikationskanäle] – dann können wir das Schema dauerhaft und für alle
BuM-Nutzer korrigieren.

[Kommunikationskanäle]: <../README.md#kontakt-und-austausch>

## Informationen für Entwickler des Helm-Charts

Werden Konfigurationsoptionen in der [values.yaml] hinzugefügt, geändert oder
gelöscht, so muss auch das Schema der Konfiguration angepasst werden. Dieses
folgt der [JSON Schema Spezifikation] und ist in der [values.schema.yaml]
definiert. Nach jeder Änderung muss das Schema in die für Helm verständliche
[values.schema.json] überführt werden; das kann durch Neugenerierung der Datei
mithilfe des [gen-values-json.sh]-Skripts erreicht werden.

[JSON Schema Spezifikation]: <https://json-schema.org/specification>
[values.yaml]: <../values.yaml>
[values.schema.yaml]: <../values.schema.yaml>
[values.schema.json]: <../values.schema.json>
[gen-values-json.sh]: <../scripts/gen-values-json.sh>
