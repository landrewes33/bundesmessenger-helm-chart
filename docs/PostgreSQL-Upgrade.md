# PostgreSQL Upgrade

> ⚠ **Achtung** – Es wird empfohlen, die PostgreSQL-Datenbank des
> BundesMessengers getrennt zu pflegen, und nicht innerhalb von Kubernetes zu
> verwenden. Entscheidest du dich dagegen, kann das zu Unzuverlässigkeiten und
> Leistungsproblemen führen.

Verwendest du – entgegen der offiziellen Empfehlung – die PostgreSQL-Datenbank
des BundesMessenger Helm-Charts, hilft dir diese Seite bei dem Upgrade auf eine
neue Hauptversion.

```log
FATAL:  database files are incompatible with server
DETAIL:  The data directory was initialized by PostgreSQL version 14, which is
not compatible with this version 16.4.
```

Fehlermeldung von PostgreSQL im Fall, dass kein Upgrade durchgeführt wurde.

## Beispiel: Migration auf PostgreSQL 16

Die folgenden Schritte führen innerhalb von Kubernetes ein Upgrade von
PostgreSQL auf die Hauptversion 16 durch. Der beschriebene Weg legt mit
`pg_dumpall` einen Dump der bestehenden Datenbank an, initialisiert eine neue
leere Datenbank in der neuen Hauptversion und spielt dann die Daten zurück ein.

Der BundesMessenger sollte während des Upgrades in den Wartungsmodus versetzt
werden, sodass keine Daten verloren gehen, die in diesem Zeitraum anfallen. Die
Konfiguration des Wartungsmodus sollte `blocking: true` beinhalten und kann über
[additionalConfig.maintenance](../values.yaml#:~:text=maintenance:%20{})
angepasst werden. Zusätzlich zu dem client-seitigen Wartungsmodus, setzt
[`extraConfig.hs_disabled`](https://element-hq.github.io/synapse/develop/usage/configuration/config_documentation.html#hs_disabled-and-hs_disabled_message)
den Homeserver selbst in einen sicheren Zustand.

> 📌 **Hinweis** – Die Befehle sind angelehnt an die Anweisung zur Installation
> der [BundesMessenger Testumgebung](installation_testumgebung.md#bundesmessenger).
> Im Beispiel heißt der Namespace `bum` und das zugrundeliegende Deployment
> `bundesmessenger`. Um für ein Cluster die korrekten Namen der
> Kubernetes-Ressourcen zu finden, können Befehle wie der folgende verwendet
> werden: `kubectl --namespace=bum get pods | grep postgres`

### Schritt 1: Datenbank exportieren

Um die Datenbank in eine SQL-Datei zu exportieren, können die folgend in
`postgres-major-upgrade.yaml` beschriebenen Kubernetes-Ressourcen verwendet
werden. Der Job führt den Datenbankexport auf den PersistentVolumeClaim aus.

```yaml
# postgres-major-upgrade.yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: postgresql-major-upgrade
  annotations:
    helm.sh/resource-policy: keep
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      # Bei Bedarf vergrößern – muss den Dump aufnehmen können
      storage: 16Gi
---
apiVersion: batch/v1
kind: Job
metadata:
  name: postgresql-major-upgrade
spec:
  ttlSecondsAfterFinished: 300 # 5 Minuten bleibt der Job bestehen, wird dann abgelöscht
  template:
    spec:
      securityContext:
        fsGroup: 1001
      containers:
        - name: postgresql-major-upgrade
          image: docker.io/bitnamilegacy/postgresql:16
          env:
            - name: PGHOST
              # Bei Bedarf anpassen
              value: bundesmessenger-postgresql
            - name: PGDATABASE
              value: synapse_db
            - name: PGUSER
              value: synapse
            - name: PGPASSWORD
              valueFrom:
                secretKeyRef:
                  # Bei Bedarf anpassen
                  name: bundesmessenger-postgresql
                  key: password
          command:
            - sh
            - -c
            - |
              until pg_isready; do sleep 1; done
              pg_dumpall \
                --no-role-passwords \
                --clean \
                --if-exists \
                --load-via-partition-root \
                --quote-all-identifiers \
                --no-password \
              > /major-upgrade-dump/upgrade-to-16.sql
          volumeMounts:
            - name: major-upgrade-dump
              mountPath: /major-upgrade-dump
      volumes:
        - name: major-upgrade-dump
          persistentVolumeClaim:
            claimName: postgresql-major-upgrade
      restartPolicy: Never
```

Die Ressourcen können jetzt im Kubernetes-Cluster erstellt werden.

```sh
kubectl apply --namespace=bum -f postgres-major-upgrade.yaml
```

### Schritt 2: Wechsel auf neue Datenbankversion

In der Hauptkonfiguration des BundesMessengers kann jetzt der Schlüssel
`postgresql.image.tag` auf die neue PostgreSQL-Version `"16"` gesetzt werden.

```yaml
# bum-configuration.yaml
---
# […]
postgresql:
  image:
    tag: "16"
# […]
```

### Schritt 3: Zurücksetzen der Datenbank

> ⚠ **Achtung** – Du wirst in diesem Schritt alle Daten der Datenbank löschen!
> Stelle sicher, dass du eine rückspielbare Sicherung der Datenbank angelegt
> hast.

Lösche den Persistent Volume Claim (PVC) der Datenbank.

```sh
kubectl scale --namespace=bum statefulset/bundesmessenger-postgresql-0 --replicas=0
kubectl delete pvc --namespace=bum data-bundesmessenger-postgresql-0
```

### Schritt 4: Datenbank neu initialisieren

Zum Initialisieren der Datenbank und anschließendem Rückspielen der Daten kann
nun ein BundesMessenger-Release mit der folgenden Extrakonfiguration
(`import-postgresql-major-upgrade.yaml`) durchgeführt werden:

```yaml
# import-postgresql-major-upgrade.yaml
---
postgresql:
  primary:
    initdb:
      scripts:
        reinit.sh: |
          #!/bin/sh
          postgresql_execute \
            "$POSTGRESQL_DATABASE" \
            "$POSTGRESQL_INITSCRIPTS_USERNAME" \
            "$POSTGRESQL_INITSCRIPTS_PASSWORD" \
          < /major-upgrade-dump/upgrade-to-16.sql
    extraVolumes:
      - name: major-upgrade-dump
        persistentVolumeClaim:
          claimName: postgresql-major-upgrade
    extraVolumeMounts:
      - name: major-upgrade-dump
        mountPath: /major-upgrade-dump
```

```sh
helm upgrade bundesmessenger \
    oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
    --namespace bum \
    -f bum-configuration.yaml \
    -f bum-tls.yaml \
    -f import-postgresql-major-upgrade.yaml
```

### Schritt 5: Aufräumen

Die nach einem erfolgreichen Upgrade nun nicht mehr benötigten Ressourcen und
Konfigurationen können mit den folgenden Befehlen aufgeräumt werden.

Ein neues BundesMessenger-Release ohne die upgradespezifischen Einstellungen
vornehmen:

```sh
helm upgrade bundesmessenger \
    oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
    --namespace bum \
    -f bum-configuration.yaml \
    -f bum-tls.yaml
    # -f import-postgresql-major-upgrade.yaml
```

Upgrade-Job und temporären Persistent Volume Claim (PVC)
mit dem SQL-Dump darauf entfernen:

```sh
kubectl delete --namespace=bum -f postgres-major-upgrade.yaml
```

## Referenzen

- <https://github.com/bitnami/containers/tree/main/bitnami/postgresql>
- <https://github.com/bitnami/charts/blob/main/bitnami/postgresql/values.yaml>
- <https://www.postgresql.org/docs/16/upgrading.html#UPGRADING-VIA-PGDUMPALL>
