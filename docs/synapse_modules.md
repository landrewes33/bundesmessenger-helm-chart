# Synapse Module

Der Synapse Matrix Homeserver kann mit [Modulen](https://element-hq.github.io/synapse/latest/modules/index.html)
erweitert werden. Die Module können Funktionalitäten ausweiten oder anpassen.

Module sind Python Code, die in die Umgebung eingebunden und durch
die Konfiguration im Synapse aktiviert werden.

Neben der Erweiterung mit Modulen gibt es auch [Synapse Application Services](./synapse_appservice.md).

| :warning: Wenn Sie Module von Drittanbietern verwenden, gestatten Sie anderen Personen, benutzerdefinierten Code auf Ihrem Synapse Homeserver auszuführen. Serveradministratoren wird empfohlen, die Herkunft der Module, die sie auf ihrem Homeserver verwenden, zu überprüfen und sicherzustellen, dass die Module keinen bösartigen Code auf ihrer Instanz ausführen oder Schwachstellen öffnen. |
| --- |

- [Details zu Modulen, deren API und Callbacks](https://element-hq.github.io/synapse/latest/modules/index.html)

## Beispiel `synapse-auto-accept-invite`

Ein Benutzer startet typischer Weise eine Unterhaltung bzw. Chat
indem er weitere Nutzer in einen (neuen) Raum einlädt.
Der eingeladene Benutzer erhält darüber eine Information und
muss die Einladung, bevor er an dem Chat teilnehmen kann,
annehmen.

Dieses Verhalten kann verändert werden, sodass der Eingeladene
sofort Mitglied in dem eingeladenen Raum wird.
Hierfür gibt es ein Modul [synapse-auto-accept-invite](https://github.com/matrix-org/synapse-auto-accept-invite),
welches Einladungen automatisch für den Benutzer akzeptiert.

## Einbindung und Konfiguration

Am Beispiel von [synapse-auto-accept-invite](https://github.com/matrix-org/synapse-auto-accept-invite)
wird die Einbindung und Konfiguration eines Modules erklärt.

### ConfigMap erstellen

Der Python Code muss den Synapse Containern (Pods) zur Verfügung gestellt werden.
Hierfür wird der Code in eine
[Kubernetes ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
eingebunden werden.

Der Python Code wird aus dem Git Repository heruntergeladen und
und in dem BundesMessenger Namespace (hier: `bum`) zur Verfügung gestellt.

```console
git clone https://github.com/matrix-org/synapse-auto-accept-invite

kubectl create configmap synapse-auto-accept-invite \
  --from-file=./synapse-auto-accept-invite/synapse_auto_accept_invite \
  -n bum
```

Es gibt auch weitere Wege um den Python Code zu importieren, u.a.
über Tools wie [git2kube](https://github.com/wandera/git2kube).

### Modul aktivieren

Die Dateisysteme der Container (Pods) stehen zur Laufzeit nur lesend "read-only"
zur Verfügung. Daher kann der Python Code nicht mit Hilfe von
[`pip`](https://pip.pypa.io/en/stable/installation/) installiert werden.

Das Modul wird für Python direkt im Verzeichnis der Python-Bibliotheken
bereitgestellt.

:pushpin: Hinweis: Python führt Versionsangaben in den Pfaden mit sich.
Bei jedem Upgrade bzw. der Aktualisierung der Container Images
muss manuell darauf geachtet werden, dass die Pfade weiterhin stimmen.
Sonst kann es beim Starten oder der Ausführung der Pods zu Fehlern kommen und
das Modul nicht genutzt werden.

Je nach Art des Modules und der gewünschten Art der Lastverteilung
kommen die Module auf dem Haupt-Prozess oder der Worker-Prozesse zum Einsatz.
Die Einbindung erfolgt in leichter Variation.

Die Einbindung und Konfiguration erfolgt über die [`values.yaml`](../values.yaml)
des Helm-Charts.

#### Haupt-Prozess

Einbindung des Python Codes durch die ConfigMap:

```yaml
synapse:
  extraVolumes:
    - name: synapse-auto-accept-invite
      configMap:
        name: synapse-auto-accept-invite
  extraVolumeMounts:
    - name: synapse-auto-accept-invite
      mountPath: /usr/local/lib/python3.9/dist-packages/synapse_auto_accept_invite
      readOnly: true
```

Konfiguration des Modules:

```yaml
extraConfig:
  modules:
    - module: synapse_auto_accept_invite.InviteAutoAccepter
      config:
        accept_invites_only_for_direct_messages: false
```

#### Worker-Prozess

Es können alle Worker über den Parameter `workers.default`
oder jede Worker-Art z.B. über `workers.generic_worker` unterschiedlich
konfiguriert werden.

Bei notwendigen Angaben zum Worker- bzw. Prozess-Namen entspricht
der Hostname des Pods (z.B.: `bum-generic-worker-0` dem `worker_name`).

Einbindung des Python Codes durch die ConfigMap:

```yaml
workers:
  default:
    volumes:
      - name: synapse-auto-accept-invite
        configMap:
          name: synapse-auto-accept-invite
    volumeMounts:
      - name: synapse-auto-accept-invite
        mountPath: /usr/local/lib/python3.9/dist-packages/synapse_auto_accept_invite
        readOnly: true
```

Konfiguration des Modules:

```yaml
    extraConfig:
      modules:
        - module: synapse_auto_accept_invite.InviteAutoAccepter
          config:
            accept_invites_only_for_direct_messages: false
            worker_to_run_on: bum-generic-worker-0
```
