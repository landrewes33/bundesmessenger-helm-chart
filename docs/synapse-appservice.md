# Synapse Application Service

Der Synapse Matrix Homeserver kann mit [Application Services](https://element-hq.github.io/synapse/latest/application_services.html)
erweitert werden. Die Application Service können Bots oder ähnliches bereit stellen.
Application Services sind im [Matrix Protokoll](https://matrix.org/docs/spec/application_service/unstable.html)
verankert und spezifiziert.

Neben der Erweiterung mit Application Services gibt es auch [Synapse Module](./synapse-modules.md).

## Einbindung und Konfiguration

Am Beispiel von [Matrix Hookshot](https://matrix-org.github.io/matrix-hookshot/latest/index.html)
wird die Einbindung und Konfiguration eines Application Services erklärt.

### ConfigMap erstellen

Synapse muss Informationen zu dem Application Service erhalten.
Diese Daten werden in Form von Konfigurationsdateien Synapse bereit gestellt.

```console
kubectl create configmap synapse-appservice-hookshot \
  --from-file=./synapse_hookshot.yaml \
  -n bum
```

Eine leere Konfiguration hat folgendes Format:

```yaml
# synapse_hookshot.yaml
---
id: <your-AS-id>
url: <base url of AS>
as_token: <token AS will add to requests to HS>
hs_token: <token HS will add to requests to AS>
sender_localpart: <localpart of AS user>
namespaces:
  users:  # List of users we're interested in
    - exclusive: <bool>
      regex: <regex>
      group_id: <group>
    - ...
  aliases: []  # List of aliases we're interested in
  rooms: [] # List of room ids we're interested in
```

### Application Service aktivieren

Die Einbindung und Konfiguration erfolgt über die [`values.yaml`](../values.yaml)
des Helm-Charts.

Einbindung des Application Service durch die ConfigMap:

```yaml
synapse:
  extraVolumes:
    - name: synapse-appservice-hookshot
      configMap:
        name: synapse-appservice-hookshot
  extraVolumeMounts:
    - name: synapse-appservice-hookshot
      mountPath: /data/hookshot
      readOnly: true

workers:
  default:
    extraVolumes:
      - name: synapse-appservice-hookshot
        configMap:
          name: synapse-appservice-hookshot
    extraVolumeMounts:
      - name: synapse-appservice-hookshot
        mountPath: /data/hookshot
        readOnly: true
```

Konfiguration des Application Service:

```yaml
extraConfig:
  app_service_config_files:
    - /data/hookshot/synapse_hookshot.yaml
```

Nach einem erfolgreichen Einbinden und neustarten von Synapse sollt ein solche
Ausgabe im Logging erfolgen.

```console
synapse.config.appservice - 96 - INFO - main - Loaded application service: ApplicationService
```
