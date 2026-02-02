# DSGVO-Export Job

Um auf Nachfragen von Nutzern Daten DSGVO-konform zu exportieren und diese dem
Nutzer zur Verfügung zu stellen, wird der `dsgvo-exporter-job` als Cronjob
zur Verfügung gestellt.

Die benötigten Komponenten müssen initial in der `values.yaml` aktiviert werden:
`additionalConfig.dsgvoExport.enabled: true`

Dieser kann über 2 Wege ausgelöst werden:

  1. ~~im Synapse-Admin (muss noch inkludiert werden ):
    Zuerst Secret erstellen mit Nutzer und dann den Export als Job aus
    Cronjob-template auslösen~~ - in Planung
  2. per Terminal:
    Zuerst Secret importieren/updaten und dann den Job aus Cronjob starten

Secret:

```yaml
# export_user.yaml
apiVersion: v1
kind: Secret
metadata:
  name: dsgvo-dump-user
type: Opaque
data:
  user: @exportUser:example.com
```

```console
# Secret importieren
kubectl apply -n NAMESPACE -f export_user.yaml
# Job starten
kubectl -n NAMESPACE create job --from=cronjob/dsgvo-exporter-job export-job
```

Final stehen die Daten auf dem PVC unter dem Ordner des Usernamens
zur Verfügung. Somit können auch mehrere Nutzer auf einem
PVC gespeichert werden.

Der Ort an dem die exportierten Daten gespeichert wurden,
sollte danach nachweislich bereinigt werden.
Das lässt sich über ein PVC, welches gelöscht und neu angelegt wird,
am Besten umsetzen.

Die aktuelle Verfassung des Exporters exportiert keine Mediendateien,
sondern nur deren ID. Dies kann sich zukünftig ändern oder selbst
vorgenommen erweitert werden.

Siehe [Export von Medien in der Synapse Dokumentation](https://element-hq.github.io/synapse/latest/usage/administration/admin-faq.html#how-can-i-export-user-data)
