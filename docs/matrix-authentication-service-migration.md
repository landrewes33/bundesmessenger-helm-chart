<!-- markdownlint-disable MD033 MD041 -->

> :pushpin: Dieses Dokument baut vollständig auf der [Hauptdokumentation zum MAS](./matrix-authentication-service.md)
> auf. Es enthält ausschließlich Inhalte zur Migration bestehender Synapse-Installationen.

Seit Ende 2024/2025 ist die Migration eines bestehenden Synapse-Homeservers
offiziell unterstützt:

➡️ [Offizielle Anleitung von Element-HQ](https://element-hq.github.io/matrix-authentication-service/setup/migration.html#migrating-an-existing-homeserver)

# 🚀 **Matrix Authentication Service (MAS) – Migrationshandbuch**

# 0. Hinweise zur Nutzung dieser Dokumentation

Dieses Dokument enthält alle Schritte zur Migration eines bestehenden
Synapse-Homeservers auf den Matrix Authentication Service (MAS).

Wir empfehlen den automatisierten Weg über das Helm-Chart.
Damit werden sowohl MAS als auch das BundesMessenger-Backend einheitlich und konsistent
verwaltet. Außerdem stellt dieser Ansatz sicher, dass alle betrieblichen Abhängigkeiten
automatisch berücksichtigt und korrekt orchestriert werden.
Die folgende Dokumentation fokussiert sich daher auf diese Installation.

> :warning: Die Pre-Checks und die Dry-Run Jobs _können_ zum laufenden Betrieb
> parallel durchgeführt werden. Diese Phase endet, sobald die eigentliche Migration
> gestartet wird.

:warning: Wichtig: Plane für die Migration eine entsprechende Downtime ein, in
der das Backend abgeschaltet ist, damit kein Delta zwischen gesicherter Datenbank
und der Datenbank für die Migration entsteht. Die Downtime und ein
Hinweis für die Benutzer ist über `additionalConfig.maintenance` konfigurierbar.

Die sichtbaren Schritte sind bewusst kompakt.
**Zusatzwissen, Hintergründe, Diagramme, technische Erklärungen** werden über
`<details>` ausgeblendet.

Beispiel:
<details><summary>Klick für Details</summary>

Dieses Dokument nutzt Platzhalter für die realen Benamungen.

```plain
<VARIABLEN>
```

Beispiele:

```plain
<NAMESPACE> # der Namespace vom Deployment des BundesMessenger
<RELEASE> # der Name des Deployments des BundesMessengers.
<REPOSITORY> # das Repository oder die Registry, aus der das Helm-Chart
<JOBNAME> # NAme des zu erstellenden Job aus einem Blueprint Cronjob
```

</details>

Diese Struktur macht das Dokument **leicht lesbar**, ohne technische Tiefe zu verlieren.

<details>
  <summary>Ein grober Ablaufplan der Migration (vereinfacht)</summary>

```bash
+------------------------------+
|   Schritt 1: Vorbereitung    |
|------------------------------|
| - Backup erstellen DB Synapse|
| - Backup Helm-Konfiguration  |
| - Backup Media-Daten         |
| - Voraussetzungen erfüllen   |
+--------------+---------------+
               |
               v
+--------------+---------------+
| Schritt 2: MAS-Installation  |
|------------------------------|
| - Postgres-DB bereitstellen  |
| - Konfiguration MAS          |
| - Deployment                 |
| - Pre-Checks/Dry-Run         |
| - Korrekturen / Rerun Checks |
+--------------+---------------+
               |
               v
+--------------+---------------+
| Schritt 3: User-Migration    |
+------------------------------+
               |
               v
+--------------+---------------+
|   Schritt 3: Umschaltung     |
|------------------------------|
| - Alte Konfiguration deaktiv.|
| - MAS als Identity Provider  |
| - oder Upstream OIDC         |
| - Helm Upgrade ScaleUp       |
+--------------+---------------+
               |
               v
+--------------+---------------+
| Schritt 4: Verifikation      |
|------------------------------|
| - Login aller Nutzer         |
| - Client-Kompatibilität      |
| - Token-Handling prüfen      |
+------------------------------+
```

</details>

[[_TOC_]]

# 1. Vorbereitung

:warning: Bevor die Migration zu einer BundesMessenger Instanz mit MAS gestartet
wird, sollte Folgendes sichergestellt werden:

1. Falls verwendet (`postgresql.enabled: true`): Postgres-Subchart von Bitnami auf
CloudPirates Migration
2. PostgreSQL-Version 18 (bei Verwendung `postgresql.enabled: true` und zukünftig
auch für MAS-Datenbank)

Dafür eignet sich die [Dokumentation für das Datenbankupgrade](./PostgreSQL-Upgrade-Advanced.md)

## 1.1 Voraussetzungen

- Funktionierendes Synapse-Deployment
- Zugriff auf das Kubernetes-Cluster
- Zugriff auf die Datenbank (Synapse & MAS)
- Helm-Installation mit verbundenem Repository (OCI-Registry oder Chart-Museum OpenCoDE)
- Möglichkeit zum Erstellen von Backups (DB & Config)

## 1.2 Wartungsmodus aktivieren

Der BundesMessenger sollte während des Upgrades in den Wartungsmodus versetzt werden,
damit keine Daten verloren gehen. Dies erfolgt über die Helm-Chart Konfiguration:

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

Führe anschließend ein Upgrade aus, um die Konfiguration zu übernehmen:

```sh
helm upgrade <RELEASE> \
  oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
  --namespace <NAMESPACE> \
  -f values.yaml \
  -f maintenance-mode.yaml
```

## 1.3 Backups erstellen (**Pflichtschritt vor jeder Migration**)

Vor Beginn der Migration ist eine Sicherung der `values.yaml/bum-configuration.yaml`
(Helm-Deploymentdaten) sowie ein vollständiges Backup der Synapse-Datenbank
(inklusive Media-Backup) dringend empfohlen.
Beide Sicherungen bilden die Grundlage für ein sauberes Rollback, falls während
der Migration unerwartete Fehler auftreten oder die Umstellung abgebrochen
werden soll.
Die Sicherungen sollten immer durchgeführt werden, bevor migrationsrelevante
Einstellungen wie `mas.migration.enabled=true` oder `mas.enabled=true` aktiviert
werden.

🔧 Hinweise und Best Practices:

- Teste das Upgrade zuerst in einer **Testumgebung**.
- Vermeide gleichzeitige Zugriffe auf die Datenbank während des Upgrades. (Wartungsmodus)
- Prüfe den erfolgreichen Import durch Logs und ggf. kleine SQL-Abfragen.
- Die PVC-Größe für den Dump sollte **mindestens den Datenbankinhalt** aufnehmen
können.

### 1.3.1 Backup der values.yaml

```bash
cp values.yaml values.backup.$(date +%Y%m%d)
# bzw.
cp bum-configuration.yaml bum-configuration.backup.$(date +%Y%m%d)
```

:pushpin: im weiteren Verlauf wird nur noch von der `values.yaml` gesprochen.
Es sind aber die Helm-Deploymentdaten gemeint, die die minimalen
Konfigurationsdaten des Deployment beinhalten.

### 1.3.2 Backup der Synapse-Datenbank (PostgreSQL)

Wir stellen für die Migration verschiedenste CronJobs als Blueprint zur Verfügung.
Da diese im gleichen Deployment wie der BundesMessenger liegen, wird auch die Integration
dieser für entsprechend benötigte Endpunkte übernommen.

Mit folgender Konfiguration wird ein Backup-Job als CronJob provisioniert, der
zur manuellen Ausführung bereitsteht (Größe des Storage nach Bedarf anpassen):

```yaml
# values.yaml
mas:
  enabled: false  # hier noch notwendig
  migration:
    enabled: true
    backup:
      enabled: true
      storage: 2Gi # optional: default ist 16Gi
```

Aktivierung:

```bash
helm upgrade --install <RELEASE> \
  oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
  -f values.yaml --namespace <NAMESPACE>
```

Wenn im Rahmen eines PoC das PostgreSQL-Subchart verwendet wurde, so kann
über folgenden Befehl das Backup als eigenständiger Job ausgeführt werden:

```bash
# Job aus CronJob-Vorlage erstellen und starten.
kubectl create job -n <NAMESPACE> --from=cronjob/mas-migration-backup-job <JOBNAME>
# (optional) Logausgabe verfolgen
kubectl logs -n <NAMESPACE> -l job-name=<JOBNAME> -f
```

Damit wird auf einem Volume ein Datenbank-Dump und das Media-Repository gesichert.

<details> <summary>Hinweise zum Cronjob</summary>
- `suspend: true` verhindert automatische Ausführung; manuelles Triggern ist erforderlich.
- Datenbank-Dump wird in `/opt/sql/` abgelegt, Media-Daten in `/opt/media/`.
- PVC stellt sicher, dass die Backups persistent gespeichert werden.
</details>

:pushpin: Eine Rückspielung ist nur manuell möglich.
<details><summary>DB-Backup: Hintergrund & Best Practices</summary>

- Immer _vor_ jeder Migrationsphase durchführen
- Vermeide gleichzeitige Zugriffe auf die Datenbank während des Upgrades. (Wartungsmodus)
- Backups nicht im Cluster speichern
- Sicherstellen, dass der Dump konsistent ist (kein laufender Writer)
- Für produktive Systeme: PITR (Point-in-time-recovery) oder Volume-Snapshots nutzen

</details>

<details> <summary>manuelle Sicherung</summary>

Als Beispiel für manuelle Ausführung auf einem externen PostgreSQL-Server:

```bash
# PostgreSQL-Beispiel
pg_dump -U synapse_user -d synapse_db -f synapse_db_backup.sql
```

</details>

### 1.3.3 Backup der Synapse Media-Daten

Ein Backup der Mediendaten ist vor der Migration empfohlen, aber nicht zwingend
erforderlich. Die Migration selbst verändert keine vorhandenen Mediendaten.
Ein Backup dient daher vor allem zur zusätzlichen Absicherung, falls dennoch
unerwartete Probleme auftreten.

Wenn der Backup-Cronjob aktiviert wurde, sichert dieser die Media-Daten.

<details> <summary>Manuelle Sicherung</summary>

```bash
# Falls Media-Repo aktiviert wurde:
INSTANZ="media-repository"
# Ansonsten synapse-main:
INSTANZ="synapse"

# Anlegen eines Backupverzeichnis PostgreSQL Dump
mkdir -p ./backup

# Datenbank-Dump erstellen
kubectl exec -it <POSTGRES-POD> -n <NAMESPACE> -- \
  env PGPASSWORD=$(kubectl get secret postgresql -n <NAMESPACE> -o jsonpath="{.data.password}" | base64 -d) \
  pg_dump -U synapse -d <SYNAPSE_DB> > ./backup/synapse-db-backup.dump

# Media-Daten kopieren
PODNAME="$(kubectl get pods --namespace <NAMESPACE> -l "app.kubernetes.io/name= bundesmessenger,app.kubernetes.io/instance=<RELEASE>,app.kubernetes.io/component="${INSTANZ}" -o jsonpath="{.items[0].metadata.name}")"

# Anlegen eines Backupverzeichnis für Media-Daten
mkdir /backup/media

kubectl cp <NAMESPACE>/$PODNAME:/synapse/data/media /backup/media --no-preserve=false
```

</details>

# 2. MAS konfigurieren

## 2.1 MAS-Konfiguration vorbereiten

Diese Aufzählung stammt zum großen Teil aus der [MAS-Dokumentation](./docs/matrix-authentication-service.md#vorbereitung).
Folgenden Punkte müssen erfüllt werden und umgesetzt sein:

1. Eigene Subdomain für den MAS
2. MAS übernimmt per default die Auslieferung der Well-Known Information der OpenID-Konfiguration.
Der OpenID Provider muss die Discovery-Endpoint selbst bereitstellen. Der Endpunkt
`https://<issuer>/.well-known/openid-configuration` muss für die Apps erreichbar
sein. Das Helm Chart konfiguriert den Ingress und stellt dies unter der Domain von
`mas.uri` bereit.
3. [Bereitstellen einer PostgreSQL-Datenbank für den MAS](#22-mas-deployment-vorbereiten)
4. Konfiguration des Homeservers zur Nutzung des MAS
    1. Deaktivierung von `extraConfig.password_config.enabled` (übernimmt Helm-Chart)
    2. Konfigurieren von `mas` mit
        `enabled: false`, `migration.enabled: true`,
        `endpoint` und `secret` (übernimmt Helm-Chart)
    3. Konfiguration eines optionalen OIDC-Providers (OpenID-Connect-Provider)
5. [Durchführung der Migration (manuell oder per Job)](#3-migration-checks-und-dry-run)
6. Konfiguration von `mas` mit
`enabled: true` und `migration.enabled: false`.

## 2.2 MAS-Deployment vorbereiten

### 2.2.1 Datenbank für MAS anlegen

Der Matrix Authentication Service (MAS) benötigt eine **eigene, dedizierte PostgreSQL-Datenbank**,
um Benutzerdaten, Tokens und Konfigurationsinformationen zu speichern.

> :pushpin: Wir empfehlen externe, gemanagte Datenbanksysteme zu nutzen, um Datenbanken
> für MAS und BundesMessenger anzubinden.

:warning: Durch die Migration muss das entsprechende Secret angepasst/korrigiert
werden. Folgend zeigt ein Beispiel für die Änderungen per `kubectl`.
Bei der Nutzung von Vaults/External-Operatoren muss die Änderung
darüber stattfinden.

```bash
kubectl -n <NAMESPACE> patch secret maspostgresql -p "{\"data\": {\"username\": \"$(echo -n 'mas' | base64)\"}}"
kubectl -n <NAMESPACE> patch secret maspostgresql -p "{\"data\": {\"database\": \"$(echo -n 'mas' | base64)\"}}"
kubectl -n <NAMESPACE> patch secret maspostgresql -p "{\"data\": {\"password\": \"$(echo -n 'CHANGE_ME_STRENG_GEHEIM' | base64)\"}}"
```

#### A) Manuelle Erstellung der Datenbank

**Schritte zur Erstellung der Datenbank und des Benutzers:**

1. Melden Sie sich als PostgreSQL-Admin an:

    ```bash
    su - postgres
    # Oder, falls Ihr System `sudo` verwendet:
    sudo -u postgres bash
    ```

2. Erstellen Sie einen dedizierten Benutzer und eine Datenbank für MAS:

    ```bash
    # Erstellt einen neuen Benutzer mit Passwortabfrage
    createuser --pwprompt mas_user

    # Erstellt eine Datenbank im Besitz des neuen Benutzers
    createdb --owner=mas_user mas
    ```

    - Der Befehl `createuser --pwprompt mas_user` fordert Sie auf, ein Passwort
    für den Benutzer `mas_user` festzulegen.
    - Der Befehl `createdb --owner=mas_user mas` erstellt eine Datenbank namens
    `mas`, die dem Benutzer `mas_user` gehört.

> Hinweis: Es ist zwingend darauf zu achten, dass der Zugriff von MAS aus dem
> Kubernetes-Cluster auf die Datenbank möglich ist und nicht durch
> **restriktive Zugriffsrichtlinien oder fehlende Firewall- oder Zertifikats-Konfigurationen**
> verhindert wird.

:warning: **Hinweis**:
Falls eine externe Datenbank (z. B. bei einem externen Cloud- oder SaaS-Anbieter)
verwendet wird, müssen die obigen Befehle durch die entsprechenden Anweisungen
des Datenbankanbieters ersetzt werden.
Es ist darauf zu achten, dass die Verbindung aus dem Kubernetes-Cluster möglich
ist.

#### B) Automatische Erstellung

Interne PostgreSQL-Datenbank für PoC

Mit dem Bundesmessenger Helm-Chart kann auch im Zuge eines _Proof-of-Concept_ (PoC)
eine interne Datenbank über das Sub-Chart der CloudPirates angelegt werden.

Dafür werden die folgenden Konfigurationen benötigt:

```yaml
# values.yaml
maspostgresql:
  # (bool) Aktivieren des internen PostgreSQL-Servers für MAS.
  # Hinweis: Nur für Demo- und Testsysteme empfohlen. Um einen extern
  # vorhandenen PostgreSQL-Server zu verwenden, setzen Sie `maspostgresql.enabled`
  # auf `false` und konfigurieren Sie den `externalmasPostgresql`-Block.
  enabled: true
  # (map) Konfiguration des Synapse Datenbanknutzers.
  customUser:
    # (string) Name vom Datenbanknutzer.
    # Muss mit der Angabe im `existingSecret` übereinstimmen.
    username: mas
    # (string) Name der Datenbank.
    # Muss mit der Angabe im `existingSecret` übereinstimmen.
    database: mas
    # (string) Name vom Secret mit dem Passwort des Synapse Datenbanknutzers.
    # Ist `maspostgresql.enabled` und es existiert kein Secret mit dem angegebenen
    # Namen, so wird ein neues Secret automatisch erstellt und verwendet.
    existingSecret: maspostgresql
    # (map) Schlüssel im angegebenen Secret.
    secretKeys:
      # (string) Verweis im `existingSecret` auf den Namen des Datenbanknutzers.
      name: username
      # (string) Verweis im `existingSecret` auf den Namen der Datenbank.
      database: database
      # (string) Verweis im `existingSecret` auf das Nutzerpasswort.
      password: password
```

Oder wenn das Sub-Chart des BundesMessenger nicht genutzt wird:

<details><summary>externe MAS-Datenbank</summary>

```yaml
externalmasPostgresql:
  host: postgresql.example.com
  port: 5432
  database: mas_db
  username: mas_user
  existingSecret: postgresql
  existingSecretPasswordKey: maspassword
```

</details>

### MAS Konfiguration vorbereiten

In der `values.yaml` wird MAS für Migration aktiviert:

```yaml
# values.yaml
mas:
  enabled: false          # noch nicht produktiv aktivieren!
  migration:
    enabled: true         # aktiviert Pre-Check, Dry-Run & Migration-Jobs
    backup:
      enabled: true       # Aktiviert Backup-Funktion
      storage: 16Gi        # Speicherplatz für Backup
  uri: "mas.example.com"  # Erreichbare URI für den MAS
  extraConfig:            # spezifische Konfiguration ab hier
    passwords:
    […]
```

:warning: **Wichtig:**
`mas.enabled=true` wird **erst während der aktiven Migration** gesetzt.
Das verhindert ein vorzeitiges Umschalten der Well-Known-Konfiguration,
Umschreibungen für Routing-Pfade und Konfigurationseinstellungen der Nutzerverwaltung.

Das Helm-Chart bietet die Möglichkeit per Job eine Beispielkonfiguration anhand
der aktuellen Konfiguration zu erstellen.

```bash
# Job aus CronJob-Vorlage erstellen und starten.
kubectl create job -n <NAMESPACE> --from=cronjob/<RELEASE>-generate-mas-config <JOBNAME>
#  Logausgabe verfolgen
kubectl logs -n <NAMESPACE> -l job-name=<JOBNAME> -f --all-containers=true
```

In der Logausgabe kann die Konfiguration abgelesen werden. Wichtig sind die
Punkte `passwords` und `secrets`. Beachtet werden sollten auch etwaige Fehler,
welche jedoch auch in Pre-Check und Dry-Run beleuchtet werden.

<details><summary>Warum zwei Flags? (mas.enabled vs. mas.migration.enabled)</summary>

- `mas.migration.enabled = true`
  - → erzeugt CronJobs & Tools für Pre-Check/Dry-Run
  - → Synapse läuft weiter, kein Routing wird geändert

- `mas.enabled = true`
  - → aktiviert MAS produktiv
  - → well-known wird angepasst
  - → Konfigurationen und Routing für MAS aktiviert und Synapse deaktiviert
  - mit `mas.migration.enabled = true` zusammen:
    - → Synapse wird automatisch skaliert (`replicas=0`)
    - → Cronjob für die aktive Migration wird erstellt

</details>

## 2.3 Installation von MAS

Nach der Anpassung der grundlegenden [Konfigurationsschalter](#mas-konfiguration-vorbereiten)
werden die Jobs und die Konfigurationen erstellt

```bash
helm upgrade --install <RELEASE> \
  oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
  -f values.yaml --namespace <NAMESPACE>
```

**Ergebnis:**

- MAS-Deployment wird erstellt
- CronJobs für Migration und/oder Backup werden je nach `values.yaml` konfiguriert
- Services und Secrets für MAS werden automatisch generiert

<details><summary>Grobskizze für Installation ohne dieses Helm Chart</summary>
Für Szenarien, in denen **kein Helm-Chart genutzt werden soll**, z. B. in
Testumgebungen oder individuellen Deployments:

1. **Eigenständige Bereitstellung der MAS-Komponenten:**
   - Deployment/StatefulSet für MAS
   - Service für interne/externe Erreichbarkeit
   - ConfigMaps für `mas-config.yaml` und ggf. OIDC-Provider-Konfiguration
   - Secrets für Datenbankzugang und JWT-Schlüssel

2. **Datenbankverbindung manuell konfigurieren:**
   - `POSTGRES_HOST`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` als
   Umgebungsvariablen oder in ConfigMap definieren

3. **Migration und Pre-Checks manuell ausführen:**
   - CronJobs für Pre-Check oder Dry-Run müssen **selbst erstellt und konfiguriert**
   werden
   - Volumes und ConfigMaps müssen manuell gemountet werden

4. **Keine automatische Integration mit BundesMessenger:**
   - Alle Migrationen, Jobs und Backups werden **nicht vom Helm-Chart erstellt**
   - Sämtliche Updates und Verwaltung erfolgen **manuell durch den Administrator**

> Vorteil der manuellen Installation: volle Kontrolle über Deployment und Jobs.
> Nachteil: keine automatischen Upgrades, keine integrierte Migration oder
> Backupverwaltung über Helm, keine Verwaltung über BundesMessenger Helm-Chart.
</details>

## 2.4 Konfigurationsmigration

### Upstream-Provider migrieren

MAS unterstützt nur OIDC-Provider. LDAP, SAML und Custom Password Provider
werden nicht mehr unterstützt und müssen über einen OpenID-Provider wie
[DEX](https://github.com/dexidp/dex) integriert werden.

Bisherige OIDC-Provider-Konfiguration in Synapse:

```yaml
# homeserver.yaml (Ausschnitt)
extraConfig:
  oidc_providers:
    - idp_id: "example"
      idp_name: "Example OIDC"
      issuer: "https://oidc-provider.example.com"
      client_id: "client-id"
      client_secret: "client-secret"
      ...
```

Diese Konfiguration wird in den neuen Bereich unter `mas` manuell
migriert.

:warning: Der bisherige Konfigurationabschnitt (`extraConfig`) bleibt dabei
als aktiver Teil des Deployments erhalten!
Dieser wird erst zur Aktivierung der Migration abgelöscht bzw. auskommentiert.

Migrierte OIDC-Provider-Konfiguration in MAS:

```yaml
# homeserver.yaml (Ausschnitt)
mas:
  extraConfig:
    upstream_oauth2:
      providers:
        - type: oidc
          id: "<ULID>"
          name: "Example OIDC"
          issuer: "https://oidc-provider.example.com"
          client_id: "client-id"
          client_secret: "client-secret"
          ...
```

:warning: Die URI des OIDC Providers muss auf die URI in `mas.uri` zeigen, mit
dem Suffix `/upstream/callback/<id>`.

:warning: Die `id` des Providers **muss** eine valide [ULID](https://github.com/ulid/spec)
sein. Zur Generierung dieser gibt es diverse Online Tools.

Wenn z.B. die MAS uri `mas.example.com` lautet, und `mas.extraConfig.upstream_oauth2.providers.0.id`
lautet `01KC493Q4PVHS01X487R9QXF09` so muss die `redirect_uri` im OIDC provider
`mas.example.com/upstream/callback/01KC493Q4PVHS01X487R9QXF09` lauten.

[Hier](https://element-hq.github.io/matrix-authentication-service/setup/sso.html#sample-configurations)
gibt es Beispiele für unterschiedliche OIDC-Provider.

Für weitere Nutzung von LDAP und SAML muss ein OpenID-Provider wie
[DEX](https://github.com/dexidp/dex) genutzt werden.

# 3. Migration Checks und Dry-Run

Bevor die eigentliche Migration durchgeführt wird, besteht die Möglichkeit,
sämtliche vorbereitenden Schritte – insbesondere Dry-Runs und Pre-Checks – flexibel
auf unterschiedliche Wege auszuführen.

1. Unsere bereitgestellten CronJobs können dabei auf Wunsch einmalig als reguläre
Kubernetes Jobs gestartet werden, um ein direktes Migrationsergebnis (Output/Logs)
zu erhalten, ohne den produktiven Bereich des BundesMessengers zu verändern.
Dieser Vorgang kann so oft wiederholt werden, wie gewünscht.

    **oder**

2. Alternativ können dieselben Prüfungen auch manuell als selbst definierte Jobs
ausgeführt werden, falls spezifische Anpassungen oder zusätzliche Argumente
erforderlich sind.
3. Schließlich ist es ebenso möglich, die Migrationstests komplett ohne
Kubernetes-Definitionen mittels der CLI-Beispiele aus der offiziellen Element-HQ
Dokumentation durchzuführen – ideal für lokale Vorabprüfungen oder vollständig
manuelle Migrationspipelines.

## 3.1 Migration Check (automatisch)

Sind alle Einstellungen vorgenommen worden, können mit einem Helm-Upgrade die
Jobs erstellt und für die Ausführung vorbereitet werden, falls nicht schon geschehen.

Der [Pre-Check](https://element-hq.github.io/matrix-authentication-service/setup/migration.html#run-the-migration-checker)-Job
kann wie ein normaler CronJob-Run manuell gestartet werden:

```bash
# Job aus CronJob-Vorlage erstellen und starten.
kubectl create job -n <NAMESPACE> --from=cronjob/<RELEASE>-precheck-mas-migration <JOBNAME>
# (optional) Logausgabe verfolgen
kubectl logs -n <NAMESPACE> -l job-name=<JOBNAME> -f --all-containers=true
```

Der Job wird ausgeführt und die Logs werden live gestreamt. Das Streaming kann
jederzeit mit `Ctrl + C` beendet werden.

Diese beiden Befehle können beliebig oft wiederholt werden. Erkennt der Pre-Check
Fehler in der Konfiguration, kann die Datei `values.yaml` angepasst und anschließend
mit dem gleichen Befehl erneut als Job aktualisiert werden:

```bash
# Deployment aktualisieren
helm upgrade --install <RELEASE-NAME> <REPOSITORY> -n <NAMESPACE> -f values.yaml
# Job aus CronJob-Vorlage erstellen und starten.
kubectl create job -n <NAMESPACE> --from=cronjob/<RELEASE>-precheck-mas-migration <NEUERJOBNAME>
# (optional) Logausgabe verfolgen
kubectl logs -n <NAMESPACE> -l job-name=<NEUERJOBNAME> -f --all-containers=true
```

> **Hinweis:** Ein Job kann nicht mehrmals existieren. Entweder er wird
> nach dem Durchlauf gelöscht oder ein neuer Name muss ausgewählt werden.

<details><summary>Lokale Synapse Passwörter</summary>

Folgende Meldung kann mit Pre-Check/Dry-Run Aufrufe auftreten:

```plain
===== Errors =====
These issues prevent migrating from Synapse to MAS right now:

• Password scheme version '1' in the MAS config must use the Bcrypt algorithm,
so that Synapse passwords can be imported and will be compatible.
```

Synapse verwendet bcrypt als Passwort-Hashing-Verfahren, während MAS
standardmäßig argon2id nutzt. Für migrierte Passwörter muss das Schema der
Version 1 auf bcrypt mit `unicode_normalization: true` eingestellt werden.
Es wird außerdem empfohlen, argon2id als Version 2 beizubehalten, sodass
Passwort-Hashes bei der nächsten Anmeldung automatisch auf das aktuelle
Verfahren aktualisiert werden.

Beispiel für eine Passwortkonfiguration:

```yaml
# values.yaml
mas:
[…] # vorhergehende Konfiguration von MAS
  extraConfig:
    passwords:
      enabled: true
      schemes:
      - version: 1
        algorithm: bcrypt
        unicode_normalization: true
        # Optional, must match the `password_config.pepper` in the Synapse config
        #secret: secretPepperValue
      - version: 2
        algorithm: argon2id
[…] # noch kommende Konfigurationen
```

Falls in der Synapse-Konfiguration ein „pepper“ für Passwörter definiert ist,
muss dieser in der entsprechenden Version-1-Konfiguration von MAS ebenfalls
gesetzt werden.

Der Migrations-Checker weist darauf hin, wenn diese Einstellungen nicht korrekt
vorgenommen wurden.

</details>

<details><summary>Migration Pre-Checker (manuell)</summary>
Alternativ kann der Migrations-Checker auch manuell ausgeführt werden, wie in den
offiziellen Element-HQ-Beispielen dokumentiert. Dabei wird ein temporärer
Kubernetes-Job gestartet, der die Kompatibilität der Konfiguration prüft:

```bash
kubectl run mas-migration-checker \
  --image=ghcr.io/element-hq/matrix-authentication-service:latest --restart=Never\
  -- syn2mas check --config mas-config.yaml --synapse-config homeserver.yaml
```

:warning: Hinweis: Bei dieser manuellen Variante müssen alle Abhängigkeiten und
Verknüpfungen selbst bereitgestellt werden. Das umfasst z. B. Secrets, ConfigMaps
oder Volumes, die für die Konfiguration und die Ausführung des `mas-cli`
erforderlich sind. Ohne diese kann der Checker nicht korrekt arbeiten.
</details>
<details><summary>Migration Pre-Checker als Job-Blueprint</summary>
Alternativ zu vorbereiteten CronJobs kann der Migrations-Checker auch als einmaliger
Job manuell ausgeführt werden. Dazu muss der Nutzer sicherstellen, dass alle
erforderlichen Ressourcen (ConfigMaps, Secrets, Volumes) bereitgestellt sind, da
diese vom Job benötigt werden.

Beispiel-Job-Manifest:

```bash
# mas-migration-checker-job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: mas-migration-checker
spec:
  template:
    spec:
      containers:
      - name: migration-checker
        image: ghcr.io/element-hq/matrix-authentication-service:latest
        command: ["mas-cli", "syn2mas", "check"]
        args: ["--config", "/config/mas-config.yaml", "--synapse-config", "/config/homeserver.yaml"]
        volumeMounts:
        - name: config
          mountPath: /config
      volumes:
      - name: config
        configMap:
          name: mas-migration-config
      restartPolicy: Never
```

Ausführung:

```bash
kubectl apply -f mas-migration-checker-job.yaml -n <NAMESPACE>
```

Nach dem Erstellen des Jobs kann der Log-Output live verfolgt werden:

```bash
kubectl logs -l job-name=mas-migration-checker -f --all-containers=true -n <NAMESPACE>
```

Das Streaming wird mit `Ctrl + C` beendet.

Der Job kann beliebig oft wiederholt werden. Bei Änderungen in der ConfigMap kann
diese mit demselben `kubectl apply`-Befehl aktualisiert werden.
</details>

## 3.2 Dry-Run-Test ausführen

Der [Dry-Run](https://element-hq.github.io/matrix-authentication-service/setup/migration.html#run-the-migration-in-test-mode-dry-run)-Test
simuliert den vollständigen Migrationsprozess, ohne Änderungen
an der bestehenden Synapse- oder MAS-Datenbank vorzunehmen.
Er dient als zweiter Schritt nach dem Pre-Check, um realistisch zu prüfen, ob alle
Daten, Tokens und Benutzer korrekt migriert werden _könnten_.

Der Dry-Run kann dann jederzeit manuell gestartet werden:

```bash
# Job aus CronJob-Vorlage erstellen und starten.
kubectl create job -n <NAMESPACE> --from=cronjob/<RELEASE-NAME>-dry-run-mas-migration <JOBNAME>
# (Optional) Live-Logs folgen
kubectl logs -n <NAMESPACE> -l job-name=<JOBNAME> -f --all-containers=true
```

Mit `Ctrl + C` wird das Log-Streaming beendet.
<details><summary>Dry-Run-Test (manuell, direkte Ausführung)</summary>

Der Dry-Run kann auch _komplett unabhängig_ von CronJobs ausgeführt werden,
indem der Nutzer das offizielle Image von `element-hq` direkt ausführt.

Dies ist hilfreich, wenn:

- eigene Testumgebungen genutzt werden
- Anpassungen vorgenommen werden sollen
- keine CronJobs erzeugt werden sollen

Ausführung:

```bash
kubectl run mas-migration-dry-run \
  --image=ghcr.io/element-hq/matrix-authentication-service:latest --restart=Never\
  -- syn2mas migrate --config mas-config.yaml --synapse-config homeserver.yaml --dry-run
```

> **Hinweis:**
> Bei dieser Variante müssen alle Dateien (`mas-config.yaml`, `homeserver.yaml`)
> selbst bereitgestellt und gemountet werden.
</details>
<details><summary>Dry-Run-Test (als eigenständiger Job)</summary>

Wenn ein dedizierter Job gewünscht wird, der mehrfach wiederverwendbar und
versionierbar ist, kann ein eigenes Job-Manifest genutzt werden:

_Beispiel-Blueprint: `mas-migration-dry-run-job.yaml`_

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: mas-migration-dry-run
spec:
  template:
    spec:
      containers:
      - name: migration-dry-run
        image: ghcr.io/element-hq/matrix-authentication-service:latest
        command: ["mas-cli", "syn2mas", "migrate"]
        args: ["--config", "mas-config.yaml", "--synapse-config", "homeserver.yaml", "--dry-run"]
        volumeMounts:
        - name: config
          mountPath: /config
      volumes:
      - name: config
        configMap:
          name: mas-migration-config
      restartPolicy: Never
```

Ausführung:

```bash
kubectl apply -f mas-migration-dry-run-job.yaml -n <NAMESPACE>
```

> **Hinweis:**
> Die ConfigMap `mas-migration-config` mit den beiden Datensets `mas-config.yaml`
> und `homeserver.yaml` muss vorab erstellt werden (z. B. durch das Helm-Chart
> oder manuell).
</details>

## 3.3 Fehlerbehebung

Die Pre-Check- und Dry-Run-Vorgänge können beliebig oft wiederholt werden.
Nach jedem Durchlauf sollte die Konfiguration angepasst werden, bis:

- keine strukturellen Fehler mehr auftreten
- keine fehlenden Parameter gemeldet werden
- alle Warnungen verstanden und akzeptiert wurden
- die Migration durchgehend im Dry-Run erfolgreich ist

:warning: Erst wenn beide Tests **fehlerfrei** laufen, kann die eigentliche
Migration durchgeführt werden.

# 4. Aktive Migration

Nachdem Pre-Check und Dry-Run erfolgreich abgeschlossen wurden, kann die eigentliche,
aktive Migration ausgeführt werden.
Dieser Schritt überträgt die realen Benutzer-, Token- und Sessions-Daten aus Synapse
in den Matrix Authentication Service (MAS).

Die Migration kann wahlweise **automatisiert** über das Helm-Chart oder **manuell**
durchgeführt werden.

## 4.1 Abschluss der Vorbereitungen

> :warning: Spätestens jetzt sollte eine Sicherung der values.yaml erstellt sein.
> Eine Sicherung der Datenbank und Media-Daten für ein eventuelles Rollback ist
> jetzt anzulegen! :warning:

Um die automatische Migration über das Helm-Chart auszuführen, müssen in der
`values.yaml` folgende Werte gesetzt werden

```yaml
mas:
  enabled: true    # Aktiviert MAS-Deployment (Pflicht für die aktive Migration)
  migration:
    enabled: true  # Aktiviert die automatisierten Migrations-Jobs
```

> :warning: **Wichtiger Hinweis**
> Sobald `mas.enabled=true` gesetzt wird und `mas.migration.enabled=true`noch
> gesetzt ist, erzeugt das Helm-Chart automatisch die
> benötigten Migrations-Jobs **und** skaliert die Synapse-Deployments kontrolliert
> auf `0`, um zu verhindern, dass während der Migration neue Logins oder Token
> generiert werden.
> Solange die Migration läuft, ist das Backend für die Clients nicht erreichbar
> und wird als `nicht verfügbar` angezeigt.

## 4.2 Automatische Migration (empfohlen)

> :warning: **Wichtiger Hinweis**
> Sollten TLS-Zertifikate für den MAS hinterlegt/aktiviert werden,
> ist jetzt der richtige Zeitpunkt diese auch in der `values.yaml`
> zu hinterlegen.

Helm-Upgrade ausführen:

```bash
helm upgrade bundesmessenger \
  oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
  --namespace <NAMESPACE> \
  -f values.yaml \
  -f maintenance-mode.yaml
```

Nach Anwendung wird u. a.:

- Wartungsmodus beibehalten
- Migrations-CronJob `*-mas-migration` erstellt
- MAS-Services vollständig bereitgestellt
- MAS wird nicht ausgeführt (`replicas=0`)

:warning: Sollte wider Erwarten ein Fehler auftreten, kann dieser
gelöst werden und der Migrations-Job erneut erstellt und ausgeführt
werden.

### Aktive Migration jetzt ausführen

```bash
# Job aus CronJob-Vorlage erstellen und starten.
kubectl create job -n <NAMESPACE> --from=cronjob/<RELEASE-NAME>-mas-migration <JOBNAME>
# (optional) Logausgabe verfolgen
kubectl logs -n <NAMESPACE> -l job-name=<JOBNAME> -f --all-containers=true
```

Der Job führt die **finale Migration** durch.

### Wartungsmodus beenden

Wenn der Job erfolgreich und ohne Fehler abgeschlossen wurde, muss anschließend
folgende Einstellung angepasst werden: (bei Fehlern siehe
[Kapitel 7](#7-disaster-recovery--best-practices))

```yaml
# values.yaml (Ausschnitt)
mas:
  migration:
    enabled: false     # Entfernt die Migrations-Jobs und Artefakte (ServiceAccount, Configmap)
```

Ausserdem muss nun der OIDC Provider aus der Synapsekonfiguration entfernt
werden (`extraConfig.oidc_providers`):

```yaml
# values.yaml (Ausschnitt)
extraConfig:
  oidc_providers: # Diesen Abschnitt loeschen
      ...
```

Dann wird mit einem Helm-Upgrade ohne `maintenance-mode.yaml` der Wartungsmodus
deaktiviert:

```bash
helm upgrade <RELEASE-NAME> \
  oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
  --namespace <NAMESPACE> \
  -f values.yaml \
  -f pusher-values
```

Dieser Schritt bewirkt:

- das Beenden des **Wartungsmodus** des Synapse-Deployments
- das **Entfernen** aller nicht mehr benötigten Migrations-Jobs
- Worker, Synapse und MAS werden gestartet

Damit befindet sich das System wieder im normalen Betriebsmodus.

## 4.3 Manuell (vollständig selbst durchgeführt)

<details><summary>Klick</summary>
Die manuelle Migration wird gewählt, wenn:

- Werte nicht über Helm gesteuert werden sollen
- alternative Pipelines genutzt werden
- eine manuell kontrollierte Ausführung bevorzugt wird
- eine manuell verwaltete Umgebung genutzt wird

In diesem Modus müssen alle Voraussetzungen (Skalierung, ConfigMaps, Files, Mounts)
selbst hergestellt werden.

1. [Wartungsmodus aktivieren](#12-wartungsmodus-aktivieren)

2. Manuelle Ausführung der Migration

    Die Migration kann direkt über das offizielle MAS-CLI-Tool gestartet werden:

    ```bash
    kubectl run mas-migration \
      --image=ghcr.io/element-hq/matrix-authentication-service:latest \
      --restart=Never \
      --overrides='
    {
      "apiVersion": "v1",
      "spec": {
        "containers": [
          {
            "name": "mas-migration",
            "image": "ghcr.io/element-hq/matrix-authentication-service:latest",
            "volumeMounts": [
              {
                "name": "mas-cfg",
                "mountPath": "/config/mas-config.yaml",
                "subPath": "mas-config.yaml"
              },
              {
                "name": "hs-cfg",
                "mountPath": "/config/homeserver.yaml",
                "subPath": "homeserver.yaml"
              }
            ]
          }
        ],
        "volumes": [
          {
            "name": "mas-cfg",
            "configMap": {
              "name": "mas-migration-config"
            }
          },
          {
            "name": "hs-cfg",
            "configMap": {
              "name": "synapse-backup-config"
            }
          }
        ]
      }
    }' \
      -- syn2mas migrate \
        --config /config/mas-config.yaml \
        --synapse-config /config/homeserver.yaml
    ```

    > Hinweis:
    > Dateien wie `mas-config.yaml` und `homeserver.yaml` müssen vorher als
    > ConfigMap bereitgestellt und gemountet werden.

3. Abschluss

    Nach erfolgreicher Migration:

      1. Wartungsmodus deaktivieren:

          Durch ein Helm-Upgrade ohne `maintenance-mode.yaml` um den Wartungsmodus
          zu deaktivieren:

          ```bash
          helm upgrade <RELEASE-NAME> \
            oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
            --namespace <NAMESPACE> \
            -f values.yaml \
            -f pusher-values
          ```

      2. MAS-Migration-Jobs entfernen oder über die Helm-Values deaktivieren
        (z. B. `mas.migration.enabled=false` setzen und `helm upgrade` ausführen)

      3. Finales Helm-Upgrade durchführen
        damit nur noch der produktive MAS-Betrieb aktiv ist und alle temporären
        Jobs entfernt werden.

</details>

# 5. Validierung

Nach Abschluss der Migration ist eine sorgfältige Überprüfung notwendig, um
sicherzustellen, dass sowohl MAS als auch Synapse ordnungsgemäß zusammenarbeiten
und alle Authentifizierungs- und Kommunikationswege korrekt funktionieren.

> :pushpin: Hinweis: Die Administration des MAS ist mit Synapse-Admin
> nicht möglich. Synapse-Admin kann durch das [BundesMessenger Admin-Portal](./admin_portal.md)
> ersetzt werden (`synapse_admin.enabled: false`, `adminPortal.enabled: true`.

## Funktionalität prüfen

Nach erfolgreicher Migration sollten folgende Tests durchgeführt werden:
<details><summary>Anmeldung mit bestehenden Nutzern</summary>
- Prüfung, ob sich ein bestehender Nutzer erfolgreich über MAS anmelden kann.
- Test auf verschiedene Login-Vorgänge:
  - Passwort-Login (falls aktiviert)
  - OIDC-Login
  - Token-basierte Login-Mechanismen (z. B. über spezielle Integrationen)
  - (optional) "Passwort-zurück-setzen"

:pushpin: Fehler in diesem Schritt deuten häufig auf Probleme in der
MAS-Konfiguration oder der OIDC-Verknüpfung hin.

</details>
<details><summary>Registrierung (falls erlaubt)</summary>
Falls die Instanz neue Registrierungen zulässt:

- Registrieren eines neuen Testkontos
- Prüfung, ob der OIDC-Provider die Nutzerattribute korrekt übergibt
- Verifizierung des Registrierungsvorgangs
  (E-Mail-Verifizierung / Approval-Flows, je nach Setup)

</details>
<details><summary>Testen der Kommunikation mit Upstream-Providern</summary>
MAS kommuniziert mit verschiedenen Upstream-Systemen. Prüfen Sie daher:

- Verbindung zu Ihrem OIDC-Provider (z. B. Bundes-Login, Keycloak, Authlib,
Azure AD)
- Erreichbarkeit der Endpunkte:
  - `/.well-known/openid-configuration`
  - Token-Endpunkt
  - UserInfo-Endpunkt
- Validierung der ausgetauschten Token und Claims

Fehlerhafte Claims oder Zertifikate sind häufige Ursachen für Probleme nach der
Migration.
</details>
<details><summary>Client-Kompatibilität sicherstellen</summary>
Starten/Nutzen von mehrere Matrix-Clients (WebClient/Android/iOS) und prüfen von:

- Login
- Logout
- Token-Refresh
- Geräteverwaltung / Key-Upload
- Media-Upload

</details>
<details><summary>API- und Hintergrundprozesse testen</summary>
- Prüfen, ob per `/_matrix/client/versions` der Synapse korrekt auf Anfragen antwortet
- Verifizieren nach Start der Synapse-Pods, von:
  - Hintergrundjobs (Push, Presence, Federation)
  - Ausgehenden Verbindungen
  - Federation-Handshake zu Peers (falls aktiv)

</details>

# 6. Rollback

## Entscheidung: Rollback vs. Kein Rollback (ASCII-Diagramm)

Dieses Diagramm hilft bei der schnellen Entscheidung, ob ein vollständiges Rollback
(inkl. Datenbank) erforderlich ist oder ob eine einfache Helm-Konfigurationskorrektur
ausreicht.

```bash
                +--------------------------------------+
                |  Tritt ein Fehler während der        |
                |  Migration / im Dry-Run auf?         |
                +--------------------------------------+
                              │
                              ▼
                   +---------------------+
                   |  Wurden Teile der   |
                   |  Migration bereits  |
                   |  angewendet?        |
                   +---------------------+
                         │              │
                       ja               nein
                         │              │
                         ▼              ▼
            +------------------+       +-------------------------+
            | Wurde MAS        |       | Helm-Values korrigieren |
            | gestartet und    |-nein->| oder nur ConfigMap      |
            | DB geschrieben?  |       |   | neu ausrollen       |
            +------------------+       +-------------------------+
                         │
                       ja
                         │
                         ▼
            +------------------+
            | DB-Rollback      |
            | + Helm-Rollback/ |
            |   Values-Rollback|
            +------------------+
                         │
                         ▼
            +-------------------------+
            | Synapse hochskalieren   |
            | und System prüfen       |
            +-------------------------+
```

Interpretation der Pfade:

- **„nein“** bedeutet: Migration hat noch _keine_ DB-Schemata oder
Authentifizierungsdaten verändert → kein DB-Rollback nötig
- **„ja“** bedeutet: der Migrationsprozess hat bereits Daten modifiziert → zwingend
DB-Restore erforderlich

Rollback ist nur korrekt möglich, wenn **DB, Media-Daten & values.yaml** gesichert
wurden.
<details><summary>Rollback-Diagramm anzeigen</summary>
```bash
+---------------------------+
| Start Rollback            |
+---------------------------+
            |
            v
+---------------------------+
| Maintenance aktivieren    |
+---------------------------+
            |
            v
+---------------------------+
| DB-Restore (Synapse)      |
+---------------------------+
            |
            v
+---------------------------+
| values.yaml rollback      |
+---------------------------+
            |
            v
+---------------------------+
| Media-Restore (Data)      | <-- optional
+---------------------------+
            |
            v
+---------------------------+
| Maintenance deaktivieren  |
+---------------------------+
            |
            v
+---------------------------+
| System OK? → Fertig       |
+---------------------------+
```

</details>

Tritt während der Migration ein Fehler auf oder liefern der Dry-Run bzw. die
aktive Migration unerwartete Ergebnisse, kann jederzeit auf den vorherigen Betriebszustand
zurückgegangen werden – vorausgesetzt, zu Beginn wurde wie empfohlen ein Backup
erstellt.
Die folgenden Schritte stellen sicher, dass sowohl die Konfiguration als auch die
Datenbank wieder in einen konsistenten Zustand versetzt werden.

Falls die Migration mit einem Fehler endet:

- Der Fehler kann behoben und der Vorgang durch erneutes Ausführen des Befehls
wiederholt werden, oder
- die Homeserver-Konfiguration wird zurückgesetzt (wodurch die MAS-Integration
wieder deaktiviert wird) und die Migration wird vorerst abgebrochen. In diesem
Fall sollte MAS nicht gestartet werden.

In einigen Fällen kann MAS während einer fehlgeschlagenen Migration bereits Daten
in die eigene Datenbank geschrieben haben und bei weiteren Ausführungen entsprechende
Fehlermeldungen erzeugen. In diesem Fall kann die MAS-Datenbank gefahrlos gelöscht
und neu erstellt werden, bevor der Vorgang erneut gestartet wird.

> Grundsätzlich gilt: Das Migrationstool nimmt keine Schreibvorgänge an der
> Synapse-Datenbank vor. Solange MAS nicht gestartet wurde, kann die Migration
> daher jederzeit zurückgesetzt werden, ohne die Synapse-Datenbank wiederherstellen
> zu müssen.

<details><summary>1.Wartungsmodus aktivieren</summary>

  siehe [Wartungsmodus aktivieren](#12-wartungsmodus-aktivieren)

</details>
<details>
<summary>2 .Wiederherstellen der vorherigen Konfiguration per Helm (inkl. Datenbank-Rollback)</summary>

Ein Helm-Rollback (`helm rollback`) allein reicht **nicht aus**, wenn die Migration
bereits Datenbankschemata oder Daten in der Synapse-Datenbank verändert hat.
Damit die vorherige Betriebsumgebung zuverlässig wiederhergestellt werden kann,
müssen sowohl:

1. **Konfiguration** (via Helm)
2. **Synapse-Datenbank** (via Backup/Restore)
3. **Media-Daten** (via Filesystem Backup)

auf den identischen Stand vor der Migration zurückgeführt werden.

Nur dann kann Synapse nach dem Rollback wieder fehlerfrei starten.
<details>
<summary>A) Wiederherstellung der vorherigen Konfiguration mit gesicherter `values.yaml`</summary>

Falls vor der Migration eine Sicherung der produktiven Werte erstellt wurde:

```bash
helm upgrade <RELEASE> <CHART-PATH> \
  -n <NAMESPACE> \
  -f values-backup.yaml
```

Dies stellt:

- ursprüngliche Synapse-Konfiguration wieder her
- deaktiviert MAS-Migration
- sorgt für korrekt generierte ConfigMaps/Secrets
- entfernt temporäre Migrations-Jobs
- skaliert Synapse wieder auf die vorherige Anzahl an Replikas

</details>
<details><summary>B) Helm-Rollback auf eine frühere Release-Revision</summary>

1. Revisionen anzeigen

    ```bash
    helm history <RELEASE> -n <NAMESPACE>
    ```

2. Rollback durchführen

    ```bash
    helm rollback <RELEASE> <REVISION> -n <NAMESPACE>
    ```

:warning: **Wichtig:**
Das Deployment wird zwar zurückgesetzt, **die Datenbank bleibt davon unberührt**.
Wurde die Migration bereits ausgeführt oder teilweise ausgeführt, ist ein
**DB-Rollback zwingend erforderlich**, bevor Synapse wieder gestartet wird.

Es muss sichergestellt werden, dass im Zuge eines Rollbacks Synapse
weiterhin heruntergefahren bleibt.

Siehe [Wartungsmodus aktivieren](#12-wartungsmodus-aktivieren).

</details>

<details><summary>C) Datenbank-Rollback <b>(Pflicht nach Beginn aktiver Migration)</b></summary>

Wenn bereits Schemaanpassungen oder Benutzer-/Tokenmigrationen erfolgt sind,
müssen die Änderungen rückgängig gemacht werden.
<details><summary>PostgreSQL-Datenbank wiederherstellen</summary>

Beispiel für Restore eines vollständigen Dumps:

```bash
kubectl exec -it <POSTGRES-POD> -n <NAMESPACE> -- \
  psql -U synapse -d synapse -f /backup/synapse-db-backup.sql
```

</details>
<details><summary>Alternative: PVC-/Snapshot-Wiederherstellung</summary>

Je nach Storage-Klasse oder Operator:

- VolumeSnapshot zurückspielen
- Entire PVC ersetzen
- Operator-spezifische Restore-Jobs nutzen (z. B. cloudnative-pg, CrunchyData etc.)

</details>
<details><summary>Hinweis zu MAS-Migrationsartefakten</summary>

Falls die Migration bereits Teile in ein neues MAS-Schema geschrieben hat:

- gelöschte/überschriebene Tabellen werden vom DB-Restore zurückgesetzt
- bereits erzeugte IDs im MAS-Kontext werden verworfen
- Authentifizierungsdaten stammen wieder vollständig aus der alten Synapse-DB

</details>
</details>

<details><summary>D) Synapse wieder hochfahren</summary>
Durch ein Helm-Upgrade ohne `maintenance-mode.yaml` den Wartungsmodus deaktivieren:

```bash
helm upgrade <RELEASE-NAME> \
  oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger \
  --namespace <NAMESPACE> \
  -f values.yaml \
  -f pusher-values
```

Synapse sollte jetzt wieder im **vor-migrativen Zustand** laufen.
</details>
</details>
</details>

# 7. Disaster Recovery & Best Practices

Disaster Recovery Best Practices (empfohlene Vorgehensweise)

Dieser Abschnitt beschreibt Empfehlungen für den Umgang mit unerwarteten Problemen
während einer Migration. Ziel ist es, die Migration reproduzierbar und sicher
durchzuführen, ohne dass produktive Daten gefährdet werden. Die Hinweise sind
**empfehlend**, keine verpflichtenden Vorschriften – sie sollen als Leitfaden bzw.
Hilfe dienen.

## 7.1 Vorbereitung

<details><summary>Vollständige Backups erstellen</summary>

1. **Datenbank sichern**
   Ein aktuelles Backup der Synapse-PostgreSQL-Datenbank ist essenziell, da ein
   Helm-Rollback allein die DB nicht wiederherstellt. Empfohlene Schritte:

   ```bash
   kubectl exec -it <POSTGRES-POD> -n <NAMESPACE> -- \
     pg_dump -U synapse -d synapse -F c -f /backup/synapse-db-backup.dump
   ```

   Alternativ kann ein Snapshot des PersistentVolumes erstellt werden, um alle
   Daten konsistent zu sichern.

2. **Helm-Werte sichern**

   ```bash
   helm get values <RELEASE> -n <NAMESPACE> > values-backup.yaml
   ```

3. **Synapse-Konfiguration sichern**

   ```bash
   kubectl get configmap synapse-config -n <NAMESPACE> -o yaml > synapse-config-backup.yaml
   ```

4. **MAS-Konfiguration sichern (falls relevant)**

   - ConfigMaps, Secrets, JWKS/Signing Keys (falls lokal verwaltet)

</details>

## 7.2 Während der Migration

- Migration nur starten, wenn die Backups verfügbar sind.
- Dry-Run oder Pre-Check-Jobs können helfen, mögliche Probleme frühzeitig zu erkennen.
- Logs sollten während der Migration kontinuierlich überwacht werden:

  ```bash
  kubectl logs -l job-name=<JOBNAME> -n <NAMESPACE> -f --all-containers
  ```

# 8. Anhänge & Zusatzinformationen

## 8.1 MAS als OIDC/Auth-Provider für Synapse

<details><summary>Architekturüberblick (mit MAS)</summary>

Dieses Diagramm zeigt die Architektur des MAS auf:

```bash
+----------------------------+
|        Matrix Client       |
+-------------+--------------+
              |
              | .well-known/matrix/client
              v
+-------------+--------------+
|  MAS (Issuer / OIDC Core)  |
| - User DB (PostgreSQL)     |
| - Token Service            |
| - Signing Keys             |
+-------------+--------------+
              |
              | JWT Tokens / OIDC Flows
              v
+-------------+--------------+
| Matrix Homeserver (Synapse)|
| - Validiert Tokens         |
| - Keine lokale User-DB     |
+----------------------------+
```

</details>
<details><summary> OIDC Discovery Flow </summary>

```bash
Client
  |
  | GET https://matrix.example.com/.well-known/matrix/client
  v
Findet ISSUER
  |
  | GET https://auth.example.com/.well-known/openid-configuration
  v
OIDC Endpunkte erhalten
  |
  |--> AuthZ / Token-Abläufe starten
```

</details>

# Bugs & Hilfe

Bitte eröffnet dazu Issues in den jeweiligen OpenCoDE Projekten. Alternativ
könnt ihr euch im [BuM Community Raum](https://matrix.to/#/#opencodebum:matrix.org)
auf Matrix austauschen oder uns kontaktieren.

[Email](mailto:bundesmessenger@bwi.de) geht auch :wink:
