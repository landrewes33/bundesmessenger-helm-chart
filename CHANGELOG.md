# Changelog

Die Angaben zu den Merge Requests verweisen auf die des internen Gitlabs.
Da im OpenCoDE ein Mirror eines internen BWI Repos liegt und beim Mirroring die
Git History neu geschrieben wird, sind die Merge Requests aktuell nicht verlinkt.

<!-- markdownlint-disable MD024 MD012 -->

<!-- towncrier release notes start -->
## BundesMessenger Helm Chart 1.8.0 (2024-06-18)

### ⚠️ Versionshinweise

- Die Sygnal (Push-Server) Konfiguration wurde vereinfacht. Das betrifft
  Betreiber, die Push für iOS benutzen.
  Der Schalter `sygnal.ios_push.enabled` entfällt und wird automatisch
  berechnet wenn `ioskey_filename` konfiguriert ist.
  Zusätzlich wurde die Ebene `ios_push` entfernt. Beispiel: Aus
  `sygnal.ios_push.ioskey_filename` wird `sygnal.ioskey_filename`.
  Nutzer die bereits eine `pusher-values.yaml` erhalten haben, müssen diese mit
  einer neuen Version austauschen. (!369)
- Wenn das Passwort ein `/` enthält, wird es von `sed` als Regex-Trennzeichen
  interpretiert und verursacht Probleme.
  Wenn das Passwort ein `&` enthält, ersetzt `sed` es durch die
  Eingabezeichenfolge.
  Etwas wie `passw&ord` wird zu `passw@@POSTGRES_PASSWORD@@ord`. (!374)

### ✨ Features

- Hinzufügen einer föderationsspezifischen Konfigurationsektion inklusive
  Zertifikate für private Föderation. (!345)
- Entfernen User-Settings und setzen von `fsGroup` in der
  Schadcodescanner-Konfiguration. Contributed by Dimitri Schwarz
  (dimitri.schwarz@muenchen.de). (!360)
- Nutzung von fsGroup zum setzen der Permissions auf Dateien-Ebene. (!361)
- Support für FCM Google Push API im Synapse als Ersatz für GCM hinzugefügt.
  (!369)
- Escape von Sonderzeichen in Postgres- und Redis-Passwörtern um
  Missinterpretation von `sed` zu verhindern. (!374)

### 🐛 Bugfixes

- Behebt eine falsche `permalink_prefix` Konfiguration des Webclients. (!371)
- Fix für Helper-Funktion von `matrix-synapse.imagePullSecrets`. Contributed by
  Thomas Brodersen. (!372, !402)

### 📚 Dokumentation

- Hinzufügen einer [Dokumentation für selbsterstellte
  Zertifikate](https://gitlab.opencode.de/bwi/bundesmessenger/backend/helm-chart/-/blob/main/docs/simple-selfsigned-setup.md).
  (!351)
- Hinzufügen von Beschreibungen der Abschnitte in standard_values.md. (!385)
- Hinzufügen von Hinweis und aktuelle Empfehlung für Inaktivität für den
  Matrix-Authentication-Service (MAS). (!387)

### 📝 Weitere Änderungen

- Reduzierung des standardmäßigen Loggings von Synapse. (!333)
- Behebt einen Fehler in Kommentaren, der zu Leerzeilen im Template führt.
  (!401)
- `alpine/helm` in der CI-Pipeline auf Version `3.15.2` aktualisiert.
- `alpine` in der CI-Pipeline auf Version `3.20` aktualisiert.
- `docker.io/aquasec/trivy` in der CI-Pipeline auf Version `0.52.2`
  aktualisiert.
- `kindest/node` in der CI-Pipeline auf aktuelles Patch-Level aktualisiert.
- `kubernetes-sigs/kind` in der CI-Pipeline auf Version `v0.23.0` aktualisiert.
- `kubernetes-sigs/kustomize` in der CI-Pipeline auf Version `5.4.2`
  aktualisiert.
- `kyverno/kyverno` in der CI-Pipeline auf Version `v1.12.3` aktualisiert.
- `registry.gitlab.com/gitlab-org/release-cli` in der CI-Pipeline auf Version
  `v0.18.0` aktualisiert.
- `sonarsource/sonar-scanner-cli` in der CI-Pipeline auf Version `10.0`
  aktualisiert.

## BundesMessenger Helm Chart 1.7.1 (2024-04-25)

### ⚠️ Versionshinweise

- Dieses Release ist ein Security Release für Synapse. Synapse wird auf Version
  [`v1.105.1`](https://github.com/element-hq/synapse/releases/tag/v1.105.1)
  aktualisiert.
  Es wird empfohlen ein Upgrade von einer Synapse Version größer oder gleich
  `v1.100.0` durchzuführen. D.h. dass vorher ein Upgrade auf die Helm Chart
  Version `1.7.0` empfohlen wird.

  Betroffen sind Benutzer, die öffentlicher Föderation aktiviert haben.
  Links zu den CVE-Beschreibungen:
  [GHSA-3h7q-rfh9-xm4v](https://github.com/element-hq/synapse/security/advisories/GHSA-3h7q-rfh9-xm4v)
  /
  [CVE-2024-31208](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2024-31208)
  (!synapse)

### ✨ Features

- Image `bwi/bundesmessenger/backend/container-images/synapse` auf Version
  `1.105.1` aktualisiert.

## BundesMessenger Helm Chart 1.7.0 (2024-04-22)

### ✨ Features

- Hinzufügen eines DNS-Label-Schalters für Network-Policies. (!332)
- Ermöglicht das Aktivieren und Deaktivieren der Komponenten für den DSGVO
  Exporter (`additionalConfig.dsgvoExport.enabled`). Aktuell ist im Standard
  der Exporter deaktiviert. Das aus früheren Deployments verbleibende PVC im
  Status "pending" kann manuell gelöscht werden. (!344)
- Angelehnt an [!251 in v1.6.0](#bundesmessenger-helm-chart-160-2024-02-05)
  werden weitere ServiceAccounts konfigurierbar gemacht. (!346)
- Hinzufügen der Option `networkpolicies.egressIpBlock` um mit IP-Ranges DNS
  und Kube-APIs zu arbeiten, statt mit Pod-Labels im Egress. (!356)
- Image `bwi/bundesmessenger/backend/container-images/synapse` auf Version
  `1.103.0` aktualisiert.
- Image `ghcr.io/matrix-org/matrix-authentication-service` auf Version `0.8`
  aktualisiert.
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/bundesmessenger-web`
  auf Version `2.16.0` aktualisiert.
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/kubectl`
  auf Version `1.29.3` aktualisiert.
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/sygnal`
  auf Version `0.14.1` aktualisiert.
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/synapse-admin`
  auf Version `0.9.1` aktualisiert.

### 📚 Dokumentation

- Aktualisierung der Links auf das umgezogene [Synapse
  Projekt](https://github.com/element-hq/synapse) auf Github. (!275)

### 📝 Weitere Änderungen

- Das Monitoring bzw. die PodMonitore überarbeitet und Monitoring für
  Matrix-Authentication-Service hinzugefügt. (!310)
- Anpassung der Einbindung der Konfigurationsdateien für die Refaktorisierung
  des Matrix-Content-Scanner-Containers. (!318)
- Umstellung auf das neue Projekt [Richtlinien-Umsetzung
  Kyverno](https://gitlab.opencode.de/ig-bvc/policy-entwicklung/richtlinien-umsetzung-kyverno)
  der [IG BvC](https://wikijs.opencode.de/de/Organisationen/IG_BvC). (!326)
- Management der Updates von `kindest/node` mit Renovate. (!336)
- Verschieben des DSGVO-Jobs in einen eigenen Unterordner für bessere
  Übersicht. (!353)
- `alpine/helm` in der CI-Pipeline auf Version `3.14.4` aktualisiert.
- `docker.io/aquasec/trivy` in der CI-Pipeline auf Version `0.50.1`
  aktualisiert.
- `docker` in der CI-Pipeline auf Version `26` aktualisiert.
- `jnorwood/helm-docs` in der CI-Pipeline auf Version `v1.13.1` aktualisiert.
- `kubernetes-sigs/kind` in der CI-Pipeline auf Version `v0.22.0` aktualisiert.
- `kubernetes-sigs/kustomize` in der CI-Pipeline auf Version `5.4.1`
  aktualisiert.
- `registry.gitlab.com/gitlab-org/release-cli` in der CI-Pipeline auf Version
  `v0.17.0` aktualisiert.

## BundesMessenger Helm Chart 1.6.1 (2024-02-13)

### 🐛 Bugfixes

- Korrektur des CSP Header `from-ancestor` von `none` zu `self`. (!312)

## BundesMessenger Helm Chart 1.6.0 (2024-02-05)

### ⚠️ Versionshinweise

- Es verändert sich die Logik für den Namen des automatisch erzeugten Service
  Accounts.
  Ein Upgrade des Helm Charts ist problemlos möglich. Es wird automatisch der
  ServiceAccount
  mit den neuen Namen angelegt. Wenn Helm den alten Service Account nicht
  automatisch entfernt hat,
  kann bei Bedarf der alte, nicht benötigte ServiceAccount mit dem Namen `{{
  .Release.Name }}`, manuell gelöscht werden.
- Zur Erstellung der Signierungsschlüssel für Matrix wurde der Job umgestellt,
  sodass er Helm Hooks nutzt. Alle bestehenden Installationen sollten den Job
  ab sofort deaktivieren: `signingkey.job.enabled: false`.

### ✨ Features

- Hinzufügen von Demo-Modus `demomode.mode: defined`, der aus zwei Cronjobs
  (speichern und zurücksetzen der Daten) besteht.
  Es gibt verschiedene Demo-Workflow-Ausprägungen (complete, defined,
  federation).
  Der Demomodus ist nicht kompatibel mit dem Matrix-Authentication-Service.
  (!111)
- Umsetzung des Signingkey Jobs via Annotation-Hooks. (!231)
- Erstellen eines ServiceAccounts, samt gewünschter Annotations, oder Nutzung
  eines vorhandenen ServiceAccounts. (!251)
- IP-Filter für Admin-API per Ingress-Ressource. Synapse-Admin bekommt eigene
  Ingress-Ressource. (!269)
- Hinzufügen eines DSGVO-konformen Export von Nutzerdaten auf notwendigem
  eigenen PVC. (!271, !304)
- Ermöglichen der Konfiguration (`postgresql.containerPorts.postgresql`) des
  Container Port im PostgreSQL-Bitnami-Chart. (!273)
- Ermöglicht den `securityContext` im signingKey-Job zu konfigurieren.
  Contributed by Dimitri Schwarz (dimitri.schwarz@muenchen.de). (!284)
- Hinzufügen von Option `argoCD` und der Detektion ob das HelmChart im Rahmen
  von ArgoCD ausgeführt wird.
  Behebung von Fehlern die in diesem Zusammenhang auftreten. (!289)
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/bundesmessenger-web`
  auf Version `2.13.0` aktualisiert.
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/kubectl`
  auf Version `1.29.0` aktualisiert.
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/matrix-content-scanner`
  auf Version `1.0.5` aktualisiert.
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/sygnal`
  auf Version `0.13.0` aktualisiert.

### 🐛 Bugfixes

- Warnung vom Nginx-Ingress (`warnings.go:70] path /.well-known/matrix cannot
  be used with pathType Prefix`) behoben. (!252)
- Korrektur der Ressourcen Limits für Sygnal. (!287)

### 🚧 In Entwicklung

- Hinzufügen und Konfiguration OAuth 2.0 und OpenID Provider Server
  "Matrix-Authentication-Service".
  Aktuell wird an dem Modul noch entwickelt und zukünftige strukturelle
  Änderungen sind nicht ausgeschlossen. (!240)

### 📚 Dokumentation

- Korrektur von internem Link zum Network-Policies-Image in Changelog. (!274)
- Korrektur der podSecurityContext Beschreibung in der values.yaml. (!286)
- Nutzung und Einbindung von Synapse Modulen dokumentiert. (!305)
- Korrektur Link zur Redis Chart Dokumentation. (!306)
- Überarbeitung der Synapse-Admin Dokumentation. (!307)

### 📝 Weitere Änderungen

- Vereinfachung der Renovate Konfiguration. (!238)
- Automatisches Upgrade der Renovate Konfiguration. (!243)
- In der CI-Pipeline erlauben, dass das PostgreSQL Image nicht von OpenCoDE
  geladen wird. (!266)
- Harmonisierung der Annotation `checksum/config` gemäß der [Helm
  Dokumentation](https://helm.sh/docs/howto/charts_tips_and_tricks/#automatically-roll-deployments).
  (!279)
- Die Möglichkeit der Erstellung von Release Notes mit Hilfe von towncrier
  hinzugefügt. (!280)
- Skript zum Berechnen der angefragten und maximalen Ressourcen (`resources`)
  hinzugefügt. (!294)
- Im Schadcodescanner Deployment den Code-Style angepasst. (!295)
- Ordnung der Helm Templates in einer Ordnerstruktur. (!297)
- Erhöhen der Ressourcen-Grenzen einiger Services und Subcharts. (!298)
- Nutzung von `git push -u` zur Verknüpfung der Branches im Release Script.
  (!301)
- Verschieben der CORS-Header vom NginX zur Wiederverwendung in eine
  Konfigurationsdatei. (!303)
- `docker.io/aquasec/trivy` in der CI-Pipeline auf Version `0.49.0`
  aktualisiert.
- `git-mirror` in der CI-Pipeline auf Version `v1.5.6` aktualisiert.
- `jnorwood/helm-docs` in der CI-Pipeline auf Version `v1.12.0` aktualisiert.
- `kyverno/kyverno` in der CI-Pipeline auf Version `v1.11.4` aktualisiert.

## BundesMessenger Helm Chart 1.5.0 (2023-12-18)

### ✨ Features

- Hinzufügen von Network-Policy-Einträgen für Proxy-Environments via Env-Vars.
  (!224)
- Ermöglicht die eigene Konfiguration
  (`additionalConfig.locationSharing.map_style_url` und
  `additionalConfig.locationSharing.map_style_config`)
  des durch den Client verwendeten Karten-Servers. (!244)
- Verlagern der Snippet-Configuration des Webclient in nginx-Configuration vom
  Container. (!255)
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/kubectl`
  auf Version `1.28.3` aktualisiert.

### 🐛 Bugfixes

- Korrektur der TLS-Einbindung in der Webclient-Ingress-Ressource. (!253)

### 📚 Dokumentation

- Hinzufügen der [Darstellung](docs/images/Bum_Network_Policies.jpg) der
  Network-Policy-Struktur. (!256, !263)
- Aktualisierung der Dokumentation auf eine "stable" Version. (!264)
- Beispiele zur Installation mit Nutzung von einer OCI-Registry hinzugefügt.
  (!265)

### 📝 Weitere Änderungen

- Erklärung für Well-known und Ergänzungen zur Ingress Dokumentation
  hinzugefügt. (!109)
- Die `.well-known` URL zum Ingress für den Synapse Server hinzugefügt für eine
  bessere Client Konfiguration. (!178)
- Fixierung der genutzten `towncrier` Version in der CI-Pipeline. (!237)
- `alpine/helm` in der CI-Pipeline auf Version `3.13.3` aktualisiert.
- `alpine` in der CI-Pipeline auf Version `3.19` aktualisiert.
- `docker.io/aquasec/trivy` in der CI-Pipeline auf Version `0.48.0`
  aktualisiert.
- `kubernetes-sigs/kustomize` in der CI-Pipeline auf Version `5.3.0`
  aktualisiert.
- `kyverno/kyverno` in der CI-Pipeline auf Version `v1.11.1` aktualisiert.
- `towncrier` in der CI-Pipeline auf Version `23.11.0` aktualisiert.

### 🦖 Abkündigungen und Bereinigungen

- Alte CI-Pipeline zum Aktualisieren der Helm Dependencies entfernt. (!211)

## BundesMessenger Helm Chart 1.4.0 (2023-10-26)

### ✨ Features

- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/bundesmessenger-web`
  auf Version `2.10.0` aktualisiert.
  (!de-bwi-bundesmessenger-backend-container-images-bundesmessenger-web)
- Image
  `registry.opencode.de/bwi/bundesmessenger/backend/container-images/kubectl`
  auf Version `1.28.2` aktualisiert.
  (!de-bwi-bundesmessenger-backend-container-images-kubectl)
- Konfiguration
  [`forget_rooms_on_leave`](https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#forget_rooms_on_leave)
  für [Synapse
  1.84.0](https://github.com/matrix-org/synapse/releases/tag/v1.84.0)
  und
  [`forgotten_room_retention_period`](https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#forgotten_room_retention_period)
  für [Synapse
  1.93.0](https://github.com/matrix-org/synapse/releases/tag/v1.93.0)
  hinzugefügt. (!136)
- Konfiguration
  [`prevent_media_downloads_from`](https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#prevent_media_downloads_from)
  für [Synapse
  1.84.0](https://github.com/matrix-org/synapse/releases/tag/v1.84.0)
  hinzugefügt. (!137)
- Hinzufügen von weiteren Endpunkten im Ingress zu den Workern. (!210)
- SecurityContext des VolumePermissions-Init-Container
  (`volumePermissions.securityContext`) lässt sicher in der `values.yaml`
  konfigurieren. Contributed by Klaus Mueller (@klmlklml:matrix.org). (!213)
- Sygnal-Checks auf `tcpSocket` umgestellt, für besseres Loghandling. (!219)
- Image `bwi/bundesmessenger/backend/container-images/synapse` auf Version
  `1.94.0` aktualisiert.

### 📚 Dokumentation

- Aktualisierung der Anforderungen an Helm und Kubernetes in der README.md.
  (!229)

### 📝 Weitere Änderungen

- `registry.gitlab.com/gitlab-org/release-cli` in der CI-Pipeline auf Version
  `v0.16.0` aktualisiert. (!com-gitlab-org-release-cli)
- `docker.io/aquasec/trivy` in der CI-Pipeline auf Version `0.46.0`
  aktualisiert. (!io-aquasec-trivy)
- `git-mirror` in der CI-Pipeline auf Version `v1.5.5` aktualisiert.
  (!tech-bwmessenger-git-mirror)
- Aktualisierung der [Synapse
  Einstellung](https://github.com/matrix-org/synapse/blob/develop/docs/upgrade.md#upgrading-to-v1830)
  zur Replikation (`worker_replication_*` => `instance_map`). (!132)
- Management der CI-Pipeline und Helm Abhängigkeiten mit
  [Renovate](https://github.com/renovatebot/renovate). (!194)
- Umbenennung von `schadcodescanner.imageclamav` nach
  `schadcodescanner.clamavImage`
  und `schadcodescanner.imagecicap` nach `schadcodescanner.icapImage` (in der
  `values.yaml`)
  um die Kompatibilität zu
  [Renovate](https://docs.renovatebot.com/modules/manager/helm-values/#additional-information)
  herzustellen. (!207)
- Management der vom Chart genutzten Applikationen (wie Synapse) mit
  [Renovate](https://github.com/renovatebot/renovate). (!208)
- Aktualisierung des Release Prozesses in Folge der Einführung von Renovate.
  (!209)
- Ergänzung von fehlender Changelog Kategorie `removal`. (!212)
- Contribution früherer MR hinzugefügt. (!214)
- Eine manuelle CI-Pipeline zur Prüfung von Images mit
  [trivy](https://github.com/aquasecurity/trivy) hinzugefügt. (!227)
- `alpine/helm` in der CI-Pipeline auf Version `3.13.1` aktualisiert.
- `alpine` in der CI-Pipeline auf Version `3.18` aktualisiert.
- `jnorwood/helm-docs` in der CI-Pipeline auf Version `v1.11.3` aktualisiert.
- `kubernetes-sigs/kustomize` in der CI-Pipeline auf Version `5.2.1`
  aktualisiert.
- `kyverno/kyverno` in der CI-Pipeline auf Version `v1.10.3` aktualisiert.
- `python` in der CI-Pipeline auf Version `3.12` aktualisiert.

### 🦖 Abkündigungen und Bereinigungen

- Entfernen von CoTurn aus dem Helm-Chart und Dokumentationen. (!232)


## BundesMessenger Helm Chart 1.3.1 (2023-09-25)

### ✨ Features

- Kubectl auf Version `1.28.1` aktualisiert.

### 🐛 Bugfixes

- PostgreSQL Image (`postgresql.image`) auf `docker.io/bitnami/postgresql:14`
  aktualisiert.
  Das alte Image `registry.opencode.de/ig-bvc/demo-apps/postgresql/postgres:14`
  ist nicht mit den aktuellen [Bitnami
  Charts](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
  kompatibel. (!internalpostgres)
- Korrektur der Env-Var `SYGNAL_CONF` auf absoluten Pfad vom Sygnal-Container.
  Contributed by Jakob-Tobias Winter (@wintix:matrix.org).
  (!190)
- Hinzufügen der konfigurierbaren `image.pullPolicy` in alle Container des
  Schadcodescanners.
  Contributed by Jakob-Tobias Winter (@wintix:matrix.org). (!191)


## BundesMessenger Helm Chart 1.3.0 (2023-08-29)

### Versionshinweise

1. Es wurde eine Korrektur von `selector`-Labels durchgeführt.
Das führt dazu, dass ein Upgrade mit `helm upgrade` nicht möglich ist.
Es muss ein `helm uninstall` und `helm install` erfolgen.
:warning: **Um eine bestehende Installation weiter nutzen zu können bzw.
keine Daten zu verlieren, wird dringend empfohlen vorher das Update auf
Version 1.2.3 durchzuführen. Dort wurden die Labels zur Persistenz von
Media-Repository und ClamAV-PVCs neu gesetzt.**

2. Das Feature der Implementierung der Network Policies ist im Standard
deaktiviert und muss manuell aktiviert werden
(`networkpolicies.enabled: true`).
Sie befinden sich weiterhin in Arbeit und Review.

### ✨ Features

- Überarbeitung des Monitorings im Zusammenhang mit dem Prometheus Operator.
  Die Konfiguration `monitoringService` wird durch `monitoring.enabled`
  ersetzt. (!124)
- Hinzufügen von CORS Headern als default in die Ingress-Konfiguration. (!135)
- Definition von Standardwerten für den Upload von Medien in Synapse
  ([`max_upload_size:
  50M`](https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#max_upload_size)
  und [`max_avatar_size:
  5M`](https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#max_avatar_size)).
  (!140)
- Erweiterung der `ScanFileTypes` des C-ICAP-Services für PDF und weiteren
  Media-Support. (!141)
- Grundkonfiguration vom Matrix-Content-Scanner zur Nutzung von `shred -u`
  anstatt `srm` auf Grund von Performanceproblemen geändert. (!143)
- TMP-Volumes werden als RAM-Disk konfiguriert. Zugewinn von Geschwindigkeit
  und Korrektur der bereitgestellten Volume-Größen. (!144)
- Möglichkeit zur Aktivierung von Location Sharing in den Clients.
  Hierfür wird ein neuer Nginx-Container (`confighub`) und dessen Konfiguration
  hinzugefügt.
  Der neue Container übernimmt auch das Hosting der Wartungsschnittstelle
  (`cmaintenance`). (!151)
- Anpassung des Scanner-Scripts zur Beschleunigung des Scannens und Speichern
  der Ergebnisse im Cache bei Virusfund. (!154)
- Hinzufügen eines Demo-Workflow, der aus einem Cronjob zum zurücksetzen der
  Datenbank und dem Schalter `demomode.enabled: true` besteht.
  Erster Demomode ist ein kompletter Reset (`complete`). Der Demo-Workflow ist
  nur Verfügbar für Kubernetes >= v1.21.0. (!156)
- Hinzufügen der Pflichtangabe `imprintUrl` zum Angeben eines Impressums.
  (!164)
- Die Möglichkeit der Konfiguration von automatischen Löschen von Medien
  Dateien (`extraConfig.media_retention`) hinzugefügt. (!166)
- Mit `config.extraLoggers` kann das Logging von Synapse granularer
  konfiguriert werden. Dies ersetzt den Wert `config.logLevelSQL`. (!168)
- Hinzufügen des Bereichs `additionalConfig` für zusätzliche Konfigurationen
  für den BundesMessenger (z.B. locationSharing). (!171)
- Aktualisierung der Bitnami Sub-Charts auf redis `17.14.6` und postgres
  `12.8.0`.
  Gleichzeitig Umstellung auf die [Bitnami
  OCI-Registry](https://blog.bitnami.com/2023/04/httpsblog.bitnami.com202304bitnami-helm-charts-now-oci.html).
  (!175)
- Support für `structured logging` hinzugefügt. (!182)
- Erstellen und anwenden von Network Policies zum sichern des Deployments.
  (!184)
- ClamAV auf Version `0.103.9` aktualisiert.
- Kubectl auf Version `1.28.0` aktualisiert.
- Nginx auf Version `1.18.0` aktualisiert.
- Webclient auf Version `2.8.0` aktualisiert.

### 🐛 Bugfixes

- Korrektur von `selector` Labels. Das führt dazu, dass ein **Upgrade mit `helm
  upgrade` nicht möglich** ist. Es muss ein `helm uninstall` und `helm install`
  erfolgen. (!125)
- Anpassungen und Korrekturen zur Nutzung von Readiness/Liveness-Checks. (!157,
  !159)
- Behebt einen Fehler wodurch die Einstellungen für `wellknown`.`nodeSelector`,
  `affinity` und `tolerations` nicht funktionierten. (!161)
- Hinzufügen von `securityContext` zum `update-config` initContainer der
  Worker-Pods. (!162)
- Erhöhen der Temp-Verzeichnisgrößen von Media-Repository und Synapse-Main,
  abhängig von `extraConfig.max_upload_size`. (!163)
- `secure_backup_required` wird als Boolean in der `/.well-known/matrix/client`
  ausgegeben. (!165)
- Korrektur falscher Einrückungen von `nameOverride` und `fullnameOverride` in
  der `values.yaml`. (!169)
- Behebt ein Verbindungsproblem vom Matrix-Content-Scanner zu Synapse, wenn
  kein Media Repository genutzt wird. (!183)

### 📚 Dokumentation

- Anleitung zur Installation einer einfachen Testumgebung hinzugefügt. (!160)
- Beispielkonfiguration für die Nutzung eines ausgehenden Proxy-Servers für
  Synapse in der `values.yaml` hinterlegt. (!172)

### 📝 Weitere Änderungen

- Konfiguration `generic` für Worker entfernt. Alle Worker sind [Synapse
  Generic
  Worker](https://element-hq.github.io/synapse/latest/workers.html#synapseappgeneric_worker).
  (!121)
- Hinzufügen von SonarQube zur CI-Pipeline. (!138)
- Release Script zur Verbesserung des Release-Prozesses hinzugefügt. (!147,
  !186, !187, !188)
- Nutzung von `printf` anstatt `echo -e` in Scripts. (!148)
- Anpassung des Ablaufs der CI-Pipeline. (!149)
- Script zum automatischen Aktualisieren der verwendeten Images im Helm Chart
  hinzugefügt. (!150)
- Aktualisierung von `node` auf `lts-alpine` in CI-Pipeline. (!153)
- Anpassen der Ressourcen Limits für `synapse` und `synapse.workers`. (!170,
  !180)
- Aufnahme von Kubernetes `v1.27` in die Tests in der CI.
  Kubernetes `v1.19` und `v1.21` entfallen dafür.
  Die kleinste getestete Kubernetes Version ist `v1.23.17`
  (auf Basis von
  [kind](https://github.com/kubernetes-sigs/kind/releases/tag/v0.20.0)
  `v0.20.0`). (!176)
- Formatierung der JSON-Ausgabe von `/.well-known/matrix/server` mit
  `toPrettyJson`. (!179)
- Nicht benötigten Code bzw. Helper entfernt. (!185)


## BundesMessenger Helm Chart 1.2.3 (2023-06-26)

### 🐛 Bugfixes

- Aktualisierung auf aktuelles Image für den Matrix-Content-Scanner
  [`matrix-content-scanner`](https://gitlab.opencode.de/bwi/bundesmessenger/backend/container-images/container_registry/423).
  (!matrix-content-scanner)
- Hinzufügen von `runAsUser` zu `workers.default.securityContext` damit alle
  Synapse-Worker starten. Vorher kam es zum Fehler: `Error: container has
  runAsNonRoot and image will run as root (pod: "bum-appservice-0_bum",
  container: appservice)`. (!120)
- Bedingung (`helm.sh/resource-policy: keep`) für Persistenzeinstellung in
  Schadcodescanner-PVC hinzugefügt. (!133)
- Neustarten des Sygnal und Webclients, wenn die Konfiguration verändert wurde.
  (!134)
- Behebt ein zu kleines 5 MB Limit in der Virenscanner Konfiguration
  (`virus_scan.MaxObjectSize`) und übernimmt die Konfiguration aus der
  `values.yaml`. (!139)
- Das Media Repository bzw. dazugehörige `PersistentVolumeClaim` wird bei
  aktivierter `persistence` nicht mehr durch Helm gelöscht. (!145)
- Volume für fehlendes TMP-Verzeichnis hinzugefügt.
  Contributed by Jakob-Tobias Winter (@wintix:matrix.org). (!146)
- Workaround zu 'warning: command substitution: ignored null byte in input'
  durch c-icap HTML Nachricht. (!152)

### 📝 Weitere Änderungen

- Aktualisierung der genutzten Tools in der CI-Pipeline. (!126)
- Lokales Helm Repo aus der CI-Pipeline entfernt. (!155)


## BundesMessenger Helm Chart 1.2.2 (2023-04-25)

### ✨ Features

- Das Helm Chart wird zusätzlich zum [Helm
  Repository](https://gitlab.opencode.de/bwi/bundesmessenger/backend/helm-chart/-/packages)
  auch in der [OCI
  Registry](https://gitlab.opencode.de/bwi/bundesmessenger/backend/helm-chart/container_registry)
  veröffentlicht. (!127)

### 🐛 Bugfixes

- Entfernt den Endpunkt `/refresh` von der Ingress-Zuordnung zu Workern auf
  Grund eines offenen Bugs in Synapse. (!123)
- Hinzufügen des Contentscanner Schalter in der Webclient-Konfiguration als
  Standardverhalten auf eingeschaltet. (!128)
- Behebt einen Fehler mit dem der Konfiguration des temporären Verzeichnis des
  c-icap Scanners und ClamAV. (!130)
- `extraConfig.presence.enabled` wird jetzt auch an den Webclient übergeben.
  (!131)

### 📝 Weitere Änderungen

- CI Pipeline erzeugt ein nightly build. (!118, !119)


## BundesMessenger Helm Chart 1.2.1 (2023-04-05)

### 🐛 Bugfixes

- Die Release-Beschreibung wird nun automatisch von der Pipeline gesetzt.
  (!113)
- Entfernen der doppelten Konfiguration `extraConfig.report_stats`. Dies wird
  durch `config.reportStats` bereits abgedeckt.
  Migration des Schalters `extraConfig.enable_metrics` zu
  `config.enable_metrics` und setzen des Wertes in der configuration.yaml.
  (!115)
- Webclient verbindet sich wieder via `https` mit dem Backend. (!117)

### 📚 Dokumentation

- Kleine Verbesserungen an Formulierungen in der Dokumentation und
  Aktualisierung von Links zur Upstream Dokumentation. (!114)
- Fehlerkorrektur des `CHANGELOG` für Version v1.1.0. (!116)


## BundesMessenger Helm Chart 1.2.0 (2023-03-30)

### ✨ Features

- Aktualisierung auf Synapse v1.78.0 und besseres Handling von `replicaCount`
  für Worker. (!34, !110)
- Weitere Helm Tests hinzugefügt. (!44)
- Möglichkeit das Logging für das Synapse Modul `synapse.storage.SQL` separat
  zu konfigurieren. (!46)
- Hinzufügen und aktives konfigurieren des `worker_replication_secret` um die
  interne Replikation zu authentifizieren. (!51)
- Trennung der Ingresskonfiguration von Matrix-Service und Admin-API bzw.
  Synapse-Admin auf `ingress-admin.yaml`. Einführung einer neuen Variable
  `adminAPIServerName` als Servername für die Admin-API (verpflichtend
  anzugeben). (!60)
- Erlaubt eine Liste von Update-Server für ClamAV anzugeben
  (`schadcodescanner.freshclam.mirrors: []`). Diese ersetzen den
  Standard-Server unter database.clamav.net. (!99)
- Aktualisierung des Inhaltes von `/.well-known/matrix/client` und Hinzufügen
  der Pflichtangabe von `dataPrivacyUrl`. (!104)

### 🐛 Bugfixes

- Standardbenutzer aus der Nginx-Konfiguration entfernt. Diese ist im Container
  fest verankert. (!43)
- Readiness-Checks der auf Nginx-basierenden Dienste aus dem Access-Log
  genommen (`/status`-logging). (!47, !49)
- Einheitliche Benamung der einzelnen Module/Container innerhalb des
  Deployments hergestellt. (!48)
- Liveness-Checks der auf Nginx-basierenden Dienste
  (Synapse-Admin/WellKnown/WebClient) auf `TCPSocket` umgestellt. (!50)
- Säuberung der Sygnal-Config: Entfernen von nicht DVS konformen
  `net.ipv4.ip_unprivileged_port_start`. (!57)
- Aktualisierung wie die Webclient-Konfiguration mit dem Container Image
  hergestellt wird. (!65)
- Aktualisierung von Datentypen in der `values.yaml`. (!86)
- Entfernen des doppelten Labels `synapse-matrix: http` im Synapse Deployment.
  (!87)
- Aktualisierung der Resourcen-Limits für den Synapse Worker. (!94)
- Behebt einen Fehler durch den bei delegierten Server-Namen der Medien Upload
  nicht funktioniert. (!95)
- Umstellung des Tags für das Synapse-Image ohne vorangestelltem `v`. (!97)
- Korrektur und hinzufügen der Resource-Limits nach DVS Vorgaben auch bei Redis
  und PostgreSQL! (!98)
- Korrektur falscher Variablenname `sygnal.apns` zu `sygnal.apps`. (!108)

### 🚧 In Entwicklung

- Dokumentation der Abhängigkeiten und genutzten Images je Version des Helm
  Charts. (!106)
- Dokumentation für die Aufteilung des Ingress-Regelwerkes. (!112)

### 📚 Dokumentation

- Klarere Erklärung was `paths` und `csPaths` bedeuten. (!55)
- Korrektur der Hinweise nach dem Deployment `templates/NOTES.txt`. (!62)

### 📝 Weitere Änderungen

- Parameter aus der CI Pipeline in Konfigurationsdateien verschoben. (!37)
- Alte `index.yaml` aus dem Repository entfernt. (!38)
- CI Pipeline für ein `helm dependency update` hinzugefügt. (!40)
- Alte `insecure-skip-tls-verify` Parameter aus der CI Pipeline entfernt. (!41)
- Aktualisierung der Charts Metadaten. (!42)
- Alte Kommentare aus der Sygnal-Logging-Konfiguration entfernt. (!45)
- Interne Dokumentation wie ein Release zu erstellen ist. (!53)
- Aktualisierung der Stage-Namen der CI Pipeline. (!54)
- Übernahme der aktuellen Logging Einstellungen vom Synapse Upstream. (!56)
- Umsetzung von DVS Regeln in den Helm Tests und Konfiguration via
  `values.yaml`. (!58, !91, !93)
- Nutzung von Proxy Cache für KinD in der CI Pipeline. (!61)
- Verwaltung und Automatisierung des `CHANGELOGS` mit
  [`towncrier`](https://github.com/twisted/towncrier). (!63, !64)
- Umsetzung von DVS Vorgaben für den ClamAV-Schadcodescanner. (!66)
- Konfiguration zur Härtung des Redis-Images gemäß
  [Bitnami-Empfehlungen](https://github.com/bitnami/charts/tree/main/bitnami/redis/#host-kernel-settings).
  (!67)
- Auslagern des Skriptes zum Erstellen der `docs/standard_values.md` in eine
  separate Datei. (!68)
- CI fügt der Beschreibung des Gitlab Releases automatisch die relevanten
  Changelog-Einträge hinzu. (!69)
- Deaktivierung von nicht relevanten DVS Kyverno Regeln mit Hife von
  `kustomize` und Integration des Reports in [Gitlab
  SAST](https://docs.gitlab.com/ee/user/application_security/sast/). (!70, !77,
  !78, !80)
- Job zum Testen der Verfügbarkeit von Container Images im Repository zur CI
  Pipeline hinzugefügt. (!72, !88)
- Dokumentation der Sygnal-Konfiguration für definierte Nutzerhäuser. (!73)
- Beispieladresse des TURN-Servers (`turnUris`) aus der Standard-Konfiguration
  (`values.yaml`) entfernt. (!74)
- Konfiguration von `readOnlyRootFilesystem` und `serviceAccount` bei weiteren
  Images nach Vorgabe der DVS. (!75)
- Konfiguration von `livenessProbe` und `readinessProbe` bei weiteren
  Containern nach Vorgabe der DVS. (!79, !81)
- Aktualisierung des Repository Logos. (!82)
- Konfiguration der Resourcen-Limits für den Webclient. (!83)
- Signingkey Job mit Readonly-Rootfs versehen. (!84)
- Einen Linkcheker zum Überprüfen der Dokumentation zur CI hinzugefügt. (!89)
- Aufnahme von Kubernetes `v1.26.0` in die Tests in der CI. (!90)
- Alte Hilfsfunktion `matrix-synapse.sygnal.imageTag` entfernt. (!92)
- Aktualisierung der Image-Namen und Version Tags aus der Container Registry.
  (!100)
- Einen Linter für alle yaml-Dateien inkl. Helm Templates zur CI-Pipeline
  hinzugefügt. (!102, !105)
- Hinzufügen von fehlenden `namespace` Konfigurationen zu den Metadaten. (!103)
- Aktualisierung der Dokumentation zum PoC Requirement. (!107)


## BundesMessenger Helm Chart 1.1.0 (2022-12-23)

### ✨ Features

- Neue Tags und Versionen für die Container, siehe [Dokumentation der
  Container](https://gitlab.opencode.de/bwi/bundesmessenger/backend/container-images/-/blob/master/README.md#versionierung-der-images).
  (!containertags)
- Aktualisierung der Helm Dependencies: PostgreSQL von `10.9.4` zu `12.1.6`,
  Redis von `16.1.0` zu `17.3.17`.
  Bei Nutzung der integrierten Datenbank verändern sich die
  Verbindungsparameter zu `postgresql.auth`. (!22)
- Der Webclient kann mit Version `v2.1.0-b3` und später ohne direkte
  `config.json` arbeiten (veränderbare Daten werden per `initContainers`
  übertragen). (!25)
- Hinzufügen von `extraEnv` für ClamAV, damit z.B. Proxy-Settings auch auf den
  ClamAV-Pod gesetzt werden können. (!26)
- Genutzte Image-Tags sind Rolling-Tags in der Container-Registry.

### 🐛 Bugfixes

- Aktualisierung der genutzten Anwendungs-Images. (!21, !32)
- Service-Port vom Schadcodescanner auf Port `1344` für C-ICAP als Standard
  gesetzt. Contributed by Hajk Nagdaljan (@hajk:matrix.org). (!24)
- Korrektur von konfigurierten Resourcen-Limits. (!35)
- Fehlerbehebung im Image des Schadcodescanners
  Contributed by Hajk Nagdaljan (@hajk:matrix.org). (ClamAV).

### 📚 Dokumentation

- Dokumentation in der `README.md` wie das OpenCoDE Helm Repository eingebunden
  wird. (!23)
- Aktualisierung der Dokumentation zur Nutzung der OpenCoDE Registry. (!30)

### 📝 Weitere Änderungen

- Genau Definition der genutzten Image-Versionen in der CI-Pipeline. (!27, !28)


## BundesMessenger Helm Chart 1.0.1 (2022-12-16)

### ✨ Features

- Ergänzung des `podSecurityContext` und `securityContext` für den
  Wellknow-Service, Webclient und Synapse-Admin. (!13)
- Changelog zum Repository hinzugefügt. (!19)

### 🐛 Bugfixes

- Aktualisierung der genutzten Anwendungs-Images. (!9, !14)
- Kleine Korrektur des Scannerscripts vom Contentscanner, Entfernung der
  Umleitung auf `/dev/stdout`. (!18)

### 📝 Weitere Änderungen

- CI-Pipleine zum Testen des Helm Charts gegen die [DVS Kyverno
  Policies](https://gitlab.opencode.de/ig-bvc/ig-bvc-poc-2/ig-bvc-poc-ii-ap-4.1-ff-policy-entwicklung/rl-kyverno).
  (!15)


## BundesMessenger Helm Chart 1.0.0 (2022-12-15)

### ✨ Features

- Initiale Version und Veröffentlichung des BundesMessenger Helm Charts.
