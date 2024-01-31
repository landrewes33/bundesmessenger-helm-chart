# Helm Chart mit Demomodus

Dies ist eine Anleitung für das Helm Chart, der den Demomodus bekommen hat.
Es gibt unterschiedliche Varianten, die hier beschrieben werden.

## Demomodus `complete`

Dieser Demomodus setzt die komplette Umgebung auf einen leeren Zustand
zurück. Dazu wird ein Cronjob erstellt der diese Aufgabe übernimmt.
Weiterhin besteht die Möglichkeit über die beiden CSV-Dateien
`scripts/admins.csv` für Administratoren und `scripts/users.csv` für
Nutzer, den Grundzustand der Demoungebung und der registrierten Nutzer und
Administratoren anzupassen. Die enthaltenen Angaben werden zur Erstellung
der entsprechenden Gruppe genutzt. Bei Fehlen der Dateien wird ein
Default-Grundzustand erstellt.

:warning: Von diesem Default-Grundzustand raten wir bei Instanzen mit Zugriff
aus dem öffentlichen Internet ab, da alle Beispiele bei OpenCoDE einsehbar sind.

### Zurücksetzen der Umgebung

Die CronJob-Vorlage für das Zurücksetzen des Zustands der Anwendung wird
in der Datei `demomode.yaml` definiert.

Die Konfiguration wird allerdings über die folgenden Werte in der `values.yaml`
vorgenommen:

```yaml
  # -- (string) Angabe der Laufzeit des Demomodus
  # Nutzung der Crontab-Zeitnotation
  # @default 0 0 * * 0, Dies bedeutet, dass die Aufgabe um 0:00 Uhr (Mitternacht) an jedem Sonntag (Tag der Woche = 0) ausgeführt wird
  interval: "0 0 * * 0"

  # -- (string) existingClaim für PostgreSQL-Dump
  existingClaim: ""

  # -- (string) Postgresql-Dump, welcher auf dem PVC vom PostgreSQL-Server liegt
  sqldump: dump.sql
```

Dieser Cronjob hat **nicht** das Flag [`suspend: true`](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#schedule-suspension)
und wird somit periodisch, wie im `demomode.interval` definiert, ausgeführt.

Dieser kann jedoch zu Testzwecken manuell gestartet werden:

```console
# create job for resetting demo to saved media and postgresql
kubectl -n {{ .Release.Namespace }} create job --from=cronjob/{{ .Release.Name }}-demomode-reset-job my-job-clone-testreset
```

## Demomodus `defined`

Der Demomodus ermöglicht das
Speichern und periodische Zurücksetzen des Zustands einer Anwendung.
Zum Aktivieren dieses Demomodus muss in der `values.yaml`
`demomode.mode: "defined"` konfiguriert sein.
Es kann ein Zustand konfiguriert werden, mit Nutzern und
Dateien, Räumen und Direktnachrichten, um die Funktionalität des
BundesMessenger zu präsentieren.

Dieser Zustand kann dann gesichert und wieder hergestellt werden (auch in
definierten Zeiträumen, wie z.B. 1 Woche, täglich, stündlich [...])
Dazu dienen die zwei CronJobs `{{ .Release.Name }}-demomode-save-job` und
`{{ .Release.Name }}-demomode-reset-job`.

:warning: Es wird `demomode.postgresqldump: ""` zur Konfiguration des
PostgreSQL-Dump-Container genutzt. Ist der Wert, wie hier, nicht gesetzt,
wird der default von `postgresql.image` genutzt, unabhängig davon ob
`postgresql.enabled: true` ist und genutzt wird!
**Der Container muss zur genutzten Version von PostgreSQL kompatibel sein!**
:warning:

### 1. CronJobs `demomode-save-job` und `demomode-reset-job`

Die beiden CronJobs "demomode-save-job" und "demomode-reset-job" werden
verwendet, um den Zustand der Anwendung zu sichern und
periodisch wiederherzustellen.

#### CronJob `demomode-save-job`

Die CronJob-Vorlage für das Speichern des Zustands der Anwendung wird in der
Datei [`demomode.yaml`](../templates/demomode/demomode.yaml) definiert.
Dieser Cronjob ist auf `suspend: true` gesetzt, so dass er nicht automatisch
gestartet wird. Damit der gewünschte Zustand wieder hergestellt werden kann,
muss per CLI Kommando dieser zuvor gesichert werden: (Platzhalter sind bitte
entsprechend zu ersetzen)

```console
# create job for saving media and postgresql
kubectl -n {{ .Release.Namespace }} create job --from=cronjob/{{ .Release.Name }}-demomode-save-job my-job-clone-testsave
```

Das dafür verwendete, wenn nicht anders konfigurierte,
PVC findet sich unter [`demo-pvc.yaml`](../templates/demomode/demo-pvc.yaml).

Das PVC sollte genug Platz für PostgreSQL Dump und die Sicherung der
Media-Files haben. Per Default sind hier 1GB hinterlegt.

Der Cronjob hat den Platzhalter `schedule: "0 0 31 12 "`. Damit würde ein
aktivierter Cronjob um 00:00 auf den 31.12. starten, aber nur wenn das Ereignis
auf einen Sonntag stattfindet. Somit soll sichergestellt werden, dass dieser
Cronjob nur als Vorlage für eine manuelle Aktivierung genutzt wird.

#### CronJob `demomode-reset-job`

Die CronJob-Vorlage für das Zurücksetzen des Zustands der Anwendung wird auch
in der Datei `demomode.yaml` definiert.

Die Konfiguration wird allerdings über die folgenden Werte in der `values.yaml`
vorgenommen:

```yaml
  # -- (string) Angabe der Laufzeit des Demomodus
  # Nutzung der Crontab-Zeitnotation
  # @default 0 0 * * 0, Dies bedeutet, dass die Aufgabe um 0:00 Uhr (Mitternacht) an jedem Sonntag (Tag der Woche = 0) ausgeführt wird
  interval: "0 0 * * 0"

  # -- (string) existingClaim für PostgreSQL-Dump
  existingClaim: ""

  # -- (string) Postgresql-Dump, welcher auf dem PVC vom PostgreSQL-Server liegt
  sqldump: dump.sql
```

Dieser Cronjob hat **nicht** das Flag `suspend: true` und wird somit periodisch,
wie im `demomode.interval` definiert, ausgeführt.

Dieser kann jedoch zu [Testzwecken](#4-testen-des-demomodus)
manuell gestartet werden:

```console
# create job for resetting demo to saved media and postgresql
kubectl -n {{ .Release.Namespace }} create job --from=cronjob/{{ .Release.Name }}-demomode-reset-job my-job-clone-testreset
```

### 2. Demo konfigurieren und sichern

Um die Demo zu nutzen, muss der BundesMessenger mit dem Helm-Chart installiert
werden. Daraufhin muss die Sicherung wie beschrieben durch die Ausführung
eines Jobs aus dem Cronjob gesichert werden.

### 3. Anwendung überwachen

Die CronJobs sind nun aktiv, und sie werden den Zustand deiner Anwendung gemäß
der definierten Zeitpläne wiederherstellen. Überwache die CronJobs, um
sicherzustellen, dass sie ordnungsgemäß funktionieren.

```bash
kubectl get cronjobs
kubectl get jobs # Überwache die erzeugten Jobs
kubectl get pods # Überwache die Pods, die von den Jobs erstellt werden
```

### 4. Testen des Demomodus

Jetzt kann der Demomodus getestet werden, indem manuelle Änderungen an der
Anwendung vorgenommen werden und dann der Reset-CronJob ausgeführt wird, um den
zuvor gesicherten Zustand wiederherzustellen.
Hier ist ein beispielhafter Testablauf:

1. Änderungen an der Anwendung (z. B. aktualisieren der Daten oder
Konfiguration, Hinzufügen von Nutzern, Räumen und Nachrichten).
2. manuelles Ausführen des Reset-CronJob, um den zuvor gesicherten Zustand
wiederherzustellen.
3. Überprüfen, ob die Anwendung wieder in ihrem ursprünglichen Zustand ist.

**Hinweis:** In einer produktiven Umgebung sollten umfangreichere Backup- und
Restore-Strategien in Betracht gezogen werden. Die hier gezeigte
Implementierung dient nur als einfaches Beispiel für einen Demomodus.

Herzlichen Glückwunsch!
Es wurde erfolgreich eine Demo-Umgebung mit dem BundesMessenger erstellt.
