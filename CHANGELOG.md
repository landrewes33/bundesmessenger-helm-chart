# Changelog

Die Angaben zu den Merge Requests verweisen auf die des internen Gitlabs.
Da im OpenCoDE ein Mirror eines internen BWI Repos liegt und beim Mirroring die
Git History neu geschrieben wird, sind die Merge Requests aktuell nicht verlinkt.

<!-- markdownlint-disable MD024 MD012 -->

<!-- towncrier release notes start -->
## BundesMessenger Helm Chart 1.3.0 (2023-08-28)

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
  50M`](https://matrix-org.github.io/synapse/latest/usage/configuration/config_documentation.html#max_upload_size)
  und [`max_avatar_size:
  5M`](https://matrix-org.github.io/synapse/latest/usage/configuration/config_documentation.html#max_avatar_size)).
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
  Worker](https://matrix-org.github.io/synapse/latest/workers.html#synapseappgeneric_worker).
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
- Volume für fehlendes TMP-Verzeichnis hinzugefügt. (!146)
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
  gesetzt. (!24)
- Korrektur von konfigurierten Resourcen-Limits. (!35)
- Fehlerbehebung im Image des Schadcodescanners (ClamAV).

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
