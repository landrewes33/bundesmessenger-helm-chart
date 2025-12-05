# PostgreSQL Major Upgrade (Advanced Procedure)

> :warning: **Achtung** – Diese Anleitung beschreibt das Upgrade der PostgreSQL-Datenbank
> innerhalb eines Kubernetes-Clusters, das über das BundesMessenger Helm-Chart
> bereitgestellt wird.
> Die Verwendung der internen Datenbank wird für produktive Umgebungen **nicht empfohlen**.
> Alternativ kann eine externe PostgreSQL-Instanz genutzt werden.

Dieses Dokument beschreibt einen **fortgeschrittenen Upgradepfad**, der besonders
für größere PostgreSQL-Hauptversionen geeignet ist und als Vorbereitung zum Tausch
von Bitnami Helm-Chart auf CloudPirates Helm-Chart genutzt werden kann.

Die folgenden Platzhalter sind mit den Werten des Deployments zu versehen:

- `<NAMESPACE>`: Namespace des Deployments
- `<RELEASE>`: Der Release-Name des Deployments (gewählter Name z.Bsp.: `bundesmessenger`,
`demo`, `matrix`, ...)

Der Ablauf:

1. Wartungsmodus aktivieren
2. Datenbank exportieren
3. Alte PostgreSQL-Instanz entfernen
4. Neue Version konfigurieren und initialisieren
5. Neues Release deployen
6. Aufräumen

---

## 1. Wartungsmodus aktivieren

Der BundesMessenger sollte während des Upgrades in den Wartungsmodus versetzt werden,
damit keine Daten verloren gehen. Die Konfiguration von `additionalConfig.maintenance`
visualisiert in den Clients die Wartungsarbeiten via Wellknown und verhindert auch,
dass BundesMessenger Clients zugreifen. `extraConfig.hs_disabled` blockt den
Zugriff direkt im Server ab.

Erklärung Maintenance-Definition:

```yaml
  downtime:
    warning_start_time: Startzeit der Warnmeldung (ISO 8601)
                        Beispiele: 2025-08-06T14:00:00Z (UTC)
                                   2026-01-01T12:00:00+01:00 (MEZ)
                                   2026-06-30T18:30:00+02:00 (MESZ - Sommerzeit)
    start_time:         Startzeit der Downtime (ISO 8601)
    end_time:           Ende der Downtime (ISO 8601)
    type:
      MAINTENANCE:  Default Text in Anwendung für Wartungsfenster.
                    Feld `description` wird zusätzlich darunter mit 1 Zeile Abstand angezeigt,
                    wenn vorhanden
      ADHOC_MESSAGE: Nur der Text aus dem Feld `description` wird angezeigt.
    description:  optionaler Text zusätzlich zum Standard-Wartungstext
    blocking:     Bei true werden Login und Requests vom Client blockiert (auch im eingeloggten Zustand)
                  Requests auf die Maintenance-Schnittstelle werden nicht blockiert.
```

Beispielkonfiguration:

```yaml
# maintenance-mode.yaml
additionalConfig:
  maintenance:
    downtime:
      - warning_start_time: "2025-12-13T11:00:00Z"
        start_time: "2025-12-14T11:00:00Z"
        end_time: "2025-12-15T11:00:00Z"
        type: MAINTENANCE
        description: "Weihnachtswartung 2025"
        blocking: true
extraConfig:
  hs_disabled: true
```

Führe anschließend ein Upgrade auf Version 1.17.1 aus, um die
Konfiguration zu übernehmen:

```sh
helm upgrade --version 1.17.1 -n <NAMESPACE> <RELEASE> \
  oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
  -f values.yaml \
  -f maintenance-mode.yaml
```

---

## 2. Datenbank exportieren

Zur Sicherung der bestehenden Datenbank legen wir einen
**PersistentVolumeClaim (PVC)** und einen **Job** an, der den SQL-Dump erzeugt.
Der Platzhalter `<RELEASE>` muss angepasst werden.

```sh
kubectl apply -n <NAMESPACE> -f export-postgresql-major-upgrade.yaml
```

```yaml
# export-postgresql-major-upgrade.yaml
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
      storage: 16Gi # Größe an die zu erwartende Größe des Exports anpassen
---
apiVersion: batch/v1
kind: Job
metadata:
  name: postgresql-major-upgrade
spec:
  ttlSecondsAfterFinished: 300 # 5 Minuten nach Abschluss
  template:
    metadata:
      labels:
        # Zugriff auf die Datenbank bei aktiven NetworkPolicies
        app.kubernetes.io/component: synapse
    spec:
      securityContext:
        fsGroup: 1001
      containers:
        - name: postgresql-major-upgrade
          image: docker.io/bitnamilegacy/postgresql:16
          env:
            - name: PGHOST
              value: <RELEASE>-postgresql
            - name: PGDATABASE
              value: synapse_db
            - name: PGUSER
              value: synapse
            - name: PGPASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgresql
                  key: password
          command:
            - sh
            - -c
            - |
              set -e

              echo "⏳ Waiting for PostgreSQL to enter ready state…"
              until pg_isready; do sleep 1; done

              echo "🚀 Starting Synapse database dump…"

              pg_dump \
                --load-via-partition-root \
                --quote-all-identifiers \
                --no-password \
                > /major-upgrade-dump/upgrade-to-18.sql

              rc=$?

              if [ $rc -eq 0 ]; then
                echo "✅ Successfully dumped Synapse database"
                ls -alh /major-upgrade-dump/upgrade-to-18.sql
              else
                echo "❌ pg_dump failed with exit code $rc"
                exit $rc
              fi
          volumeMounts:
            - name: major-upgrade-dump
              mountPath: /major-upgrade-dump
      volumes:
        - name: major-upgrade-dump
          persistentVolumeClaim:
            claimName: postgresql-major-upgrade
      restartPolicy: Never
```

> Hinweis: `pg_dump` statt `pg_dumpall` kann für selektive oder größere Upgrades
> verwendet werden.

---

## 3. Migrationsvorbereitungen

### Secrets anpassen

Bevor die alte Instanz entfernt wird, passe die Secrets an, damit die neue
Datenbankinstanz die richtigen Credentials erhält,
entweder [interaktiv](#interaktiv) oder per [CLI](#cli).

Das bereits existierende Secret `postgresql` muss zukünftig den Schlüssel
`username` und `database` enthalten.

#### Interaktiv

```sh
kubectl -n <NAMESPACE> edit secret postgresql
```

Füge die Informationen hinzu (hier die Standardwerte des Helm-Charts):

```yaml
stringData:
  username: synapse
  database: synapse_db
```

#### CLI

```bash
kubectl -n <NAMESPACE> patch secret postgresql -p "{\"data\": {\"username\": \"$(echo -n 'synapse' | base64)\"}}"
kubectl -n <NAMESPACE> patch secret postgresql -p "{\"data\": {\"database\": \"$(echo -n 'synapse_db' | base64)\"}}"
```

---

## 4. Alte PostgreSQL-Instanz entfernen

> :warning: Wenn die Daten auf einem `PVC/PV` erhalten bleiben sollen, muss ein
neues `PVC` angelegt und unter `postgresql.persistence.existingClaim`
angegeben werden. Dann muss das bisherige PVC auch nicht gelöscht werden.

### StatefulSet und Services löschen

```sh
kubectl -n <NAMESPACE> delete statefulset <RELEASE>-postgresql
kubectl -n <NAMESPACE> delete service -l app.kubernetes.io/name=postgresql,app.kubernetes.io/instance=<RELEASE>
```

### PVC löschen

> :warning: **Achtung** – Alle Daten der alten Datenbank werden gelöscht.
> Stelle sicher, dass der Dump erfolgreich erstellt wurde.

```sh
kubectl -n <NAMESPACE> delete pvc data-<RELEASE>-postgresql-0
```

---

## 5. Neue Version initialisieren

Lege `extraVolumes` und `extraVolumeMounts` für `postgresql` in der Helm-Chart
Konfiguration fest, um den Dump wieder einzubinden:

```yaml
# import-postgresql-major-upgrade.yaml
postgresql:
  extraVolumes:
    - name: major-upgrade-dump
      persistentVolumeClaim:
        claimName: postgresql-major-upgrade
  extraVolumeMounts:
    - name: major-upgrade-dump
      mountPath: /major-upgrade-dump
  initdb:
    scripts:
        # (string) Wiederherstellen der Datenbank nach einem Upgrade.
        # Das Skript wird genau dann ausgeführt, wenn die Datenbank noch nicht
        # initialisiert ist und die Datei `/major-upgrade-dump/upgrade-to-18.sql`
        # existiert.
        05-reinit.sh: |
          #!/bin/sh
          set -e
          BACKUP_FILE=/major-upgrade-dump/upgrade-to-18.sql
          [ -f "$BACKUP_FILE" ] || exit 0
          echo "Re-importing Synapse database…"
          psql -v ON_ERROR_STOP=1 --dbname "$CUSTOM_DB" --username "$POSTGRES_USER" < "$BACKUP_FILE"
          echo "✅ Successfully re-imported Synapse database!"

```

Anschließend kann das neue Release deployed werden.

> :warning: **Achtung** – Überprüfe, dass in den values.yaml unter
> `postgresql.image.tag` die **neue** Version angegeben ist.

```sh
helm upgrade --install <RELEASE> . \
  -n <NAMESPACE> \
  -f values.yaml \
  -f maintenance-mode.yaml \
  -f import-postgresql-major-upgrade.yaml
```

In den PostgreSQL-Logs sollte nun folgendes erscheinen:

```plain
✅ Successfully re-imported Synapse database!
```

---

## 6. Aufräumen

Nach erfolgreichem Upgrade können die temporären Ressourcen entfernt werden:

```sh
kubectl delete -n <NAMESPACE> -f export-postgresql-major-upgrade.yaml
rm export-postgresql-major-upgrade.yaml
rm import-postgresql-major-upgrade.yaml
```

> :pushpin: Hinweis: Das Volume mit dem SQL-Dump bleibt bis zu einem Neustart des
> Deployments am aktuell laufenden Pod des PostgreSQL-Servers eingehängt.
> Solange wird es auch nicht unter `PVC` aufgeräumt und das `PV` auch nicht freigegeben.
>
> Sollte die Sicherung mit den `postgresql-major-upgrade` Job länger als 5 Minuten
> vergangen sein, kann dadurch eine Fehlermeldung auftreten:

```plain
Error from server (NotFound): error when deleting "`export-postgresql-major-upgrade`.yaml": jobs.batch "postgresql-major-upgrade" not found
```

---

## 7. Wartungsmodus deaktivieren

Der Wartungsmodus kann abschließend deaktiviert werden, indem das ursprüngliche
Helm-Chart erneut ohne die Wartungs-Konfiguration deployed wird:

```sh
helm upgrade <RELEASE> \
  oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
  --namespace <NAMESPACE> \
  -f values.yaml
```

:pushpin: Hinweis: Das Volume mit dem SQL-Dump bleibt bis zu einem Neustart des Deployments
am aktuell laufenden Pod des PostgreSQL-Servers eingehängt.

---

## 🔧 Hinweise und Best Practices

- Teste das Upgrade zuerst in einer **Testumgebung**.
- Vermeide gleichzeitige Zugriffe auf die Datenbank während des Upgrades. (Wartungsmodus)
- Prüfe den erfolgreichen Import durch Logs und ggf. kleine SQL-Abfragen.
- Die PVC-Größe für den Dump sollte **mindestens den Datenbankinhalt** aufnehmen
können.
- Diese Methode eignet sich für **größere Hauptversionen**, bei denen direkte
In-Place-Upgrades nicht möglich sind.
- Solange **keine Migration** der Datenbank vorgenommen wurde, ist ein Rollback
auf das vorherige Sub-Chart möglich.

---

## Referenzen

- [Bitnami PostgreSQL Helm-Chart](https://github.com/bitnami/charts/blob/main/bitnami/postgresql/values.yaml)
- [PostgreSQL Upgrading Guide](https://www.postgresql.org/docs/16/upgrading.html#UPGRADING-VIA-PGDUMPALL)
- [CloudPirates PostgreSQL Helm-Chart](https://github.com/CloudPirates-io/helm-charts/blob/main/charts/postgres/README.md)
