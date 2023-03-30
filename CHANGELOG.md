# Changelog

Die Angaben zu den Merge Requests verweisen auf die des internen Gitlabs.
Da im OpenCoDE ein Mirror eines internen BWI Repos liegt und beim Mirroring die
Git History neu geschrieben wird, sind die Merge Requests aktuell nicht verlinkt.

<!-- markdownlint-disable MD024 MD012 -->

<!-- towncrier release notes start -->
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
  [Bitnami-Empfehlungen](https://docs.bitnami.com/kubernetes/infrastructure/redis/administration/configure-kernel-settings/).
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


## BundesMessenger Helm Chart 1.1.0 (2022-12-22)

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
