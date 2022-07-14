
# bundesmessenger

![Version: 2.3.5](https://img.shields.io/badge/Version-2.3.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.59.1](https://img.shields.io/badge/AppVersion-1.59.1-informational?style=flat-square)

BWI Matrix BundesMessenger

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Christian Steinke | <christian.steinke@bwi.de> |  |
| Alexander Olofsson | <ace@haxalot.com> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | ^10.9.4 |
| https://charts.bitnami.com/bitnami | redis | ^16.1.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.enableRegistration | bool | false | Registrierungskonfiguration, beachten Sie, dass die Registrierung mit dem containerinternen Werkzeug register_new_matrix_user immer möglich ist. |
| config.extraListeners | list | `[]` | Extra listener  |
| config.logLevel | string | `"INFO"` | Das Loglevel  für Synapse und alle Module. |
| config.macaroonSecretKey | string | `""` | Hinweis: Es wird dringend empfohlen, diesen Wert auf einen secure value (secret) zu setzen. |
| config.publicBaseurl | string | `""` | Die öffentlich zugängliche URL für die Synapse-Instanz  lautet standardmäßig `https://<publicServerName>` Beispiel:  publicBaseurl: 'https://matrix.beispiel.org' |
| config.registrationSharedSecret | string | `""` | Hinweis: Dieser Wert wird standardmäßig auf eine zufällige Zeichenfolge gesetzt, wenn er nicht angegeben wird. |
| config.reportStats | bool | `false` | Sollen Nutzungsstatistiken gemeldet werden |
| config.trustedKeyServers | map | `[{"server_name":"matrix.org"}]` | Eine Gruppe von vertrauenswürdigen Servern, die zu kontaktieren sind, wenn ein anderer Server nicht auf eine Signierschlüssel-Anfrage antwortet. |
| config.turnSecret | string | `""` | geheime Schlüssel für TURN-Server |
| config.turnUris | list | `["turn:turn.lab-mobility.de:3478?transport=udp"]` | URIs die zum Aufbau von 1:1 WebRTC Anrufe aufzubauen. Beispiel: turnUris: ["turn:turn.beispiel.org:3478?transport=udp"] |
| coturn.default_ns | string | `"default"` | Namespace für den CoTurn-Dienst |
| coturn.enabled | bool | `false` | CoTurn als Deployment aktivieren Hinweis: Nicht empfohlen! |
| coturn.existingcoturn.enabled | bool | `false` | Schalter um bereits existenten CoTurn im K8s-Cluster zu nutzen |
| coturn.image | map | `{"pullPolicy":"IfNotPresent","repository":"coturn/coturn","tag":"docker/4.5.2-r12"}` | Konfiguration für das Image vom CoTurn |
| coturn.securityContext | map | `{"allowPrivilegeEscalation":false,"readOnlyRootFilesystem":true,"runAsGroup":2011,"runAsUser":2011}` | SecurityContext für das Pod |
| coturn.turnUris | map | `{"realm":"turn.beispiel.org","tcp":3478,"udp":3478}` | TurnUris zusammenbauen lassen, aktuell deaktiviert, Als Liste unter `config.turnUris` konfigurieren  |
| externalPostgresql | map | `{"database":"synapse_db","existingSecret":"postgres-secrets","existingSecretPasswordKey":"POSTGRES_PASSWORD","extraArgs":{},"host":"postgres-4-matrix-postgresql.postgres.svc.cluster.local","password":"synapse","port":5432,"username":"synapse"}` | Ein extern konfigurierter Postgres-Server, der für die Datenbank von Synapse verwendet wird,  muss die Datenbank sowohl COLLATE als auch CTYPE auf "C" eingestellt haben. Beispiel für K8s internen Postgres im Namespace "postgres": |
| externalPostgresql.database | string | `"synapse_db"` | Name der Datenbank auf die sich verbunden wird |
| externalPostgresql.existingSecret | string | `"postgres-secrets"` | Der Name eines bestehenden Secrets mit Postgresql-Anmeldedaten |
| externalPostgresql.existingSecretPasswordKey | string | `"POSTGRES_PASSWORD"` | Passwortschlüssel, der aus dem bestehenden Secret abgerufen wird |
| externalPostgresql.extraArgs | list | `{}` | Zusätzliche Argumente für die Datenbankverbindung ref: https://github.com/matrix-org/synapse/blob/develop/docs/postgres.md#synapse-config |
| externalRedis | map | `{"host":"redis","password":"synapse","port":6379}` | Ein extern konfigurierter Redis-Server, der für Worker/Sharding verwendet wird Wird erst ausgewertet, wenn `redis.enabled=false` ist. Alternativ zum statischen Passwort: Der Name eines bestehenden Secret mit Redis-Anmeldeinformationen existingSecret: redis-secrets Passwortschlüssel, der aus dem bestehenden Secret abgerufen wirdq existingSecretPasswordKey: redis-password |
| extraConfig | object | wird nachfolgend aufgeschlüsselt | Best Practise BWI GmbH: Ref: https://github.com/matrix-org/synapse/blob/develop/docs/sample_config.yaml |
| extraConfig.allow_guest_access | bool | `false` | Gastzugang, abgeschaltet |
| extraConfig.allow_public_rooms_over_federation | bool | `false` | öffentliche Räume über Förderation erlauben, abgeschaltet  |
| extraConfig.allow_public_rooms_without_auth | bool | `false` | Öffentliche Räume ohne Login/Authentifizierung, abgeschaltet! |
| extraConfig.block_non_admin_invites | bool | `false` | Einladung die von unpriviligierten Nutzern stammen blocken, abgeschaltet |
| extraConfig.dynamic_thumbnails | bool | `true` | dynamisches Vorschaubild, eingeschaltet |
| extraConfig.enable_3pid_lookup | bool | `false` | thirdParty Identifier lookup (3pid), abgeschaltet |
| extraConfig.enable_metrics | bool | `true` | Nutzungsstatistiken, eingeschaltet |
| extraConfig.enable_room_list_search | bool | `true` | Raumsuche, eingeschaltet |
| extraConfig.enable_search | bool | `true` | Nutzersuche zulassen, eingeschaltet |
| extraConfig.encryption_enabled_by_default_for_room_type | string | `"all"` | Verschlüsselung der Räume (default Einstellung, eingeschaltet |
| extraConfig.include_profile_data_on_invite | bool | `true` | Übersenden von Profildaten, wenn Chat gestartet wird |
| extraConfig.ip_range_whitelist | list | `[]` | IP-Whitelist für Förderation zwingend benötigt |
| extraConfig.limit_profile_requests_to_users_who_share_rooms | bool | `false` | Limitiere Requests für Nutzer mit shared rooms, abgeschaltet |
| extraConfig.oembed.disable_default_providers | bool | `true` | eingebettete URL-Darstellung von Drittanbietern |
| extraConfig.opentracing.enabled | bool | `false` | OpenTracing ist ein Werkzeug, das einen Einblick  in den kausalen Zusammenhang der Arbeit in und zwischen Servern gibt.  Die einzelnen Server verfolgen Ereignisse und melden  sie an einen zentralen Server - im Fall von Synapse: Jaeger. |
| extraConfig.password_config | object | folgende Aufschlüsselung | Passwortkonfiguration |
| extraConfig.password_config.enabled | bool | `true` | Passwortkonfiguration selbst definieren, eingeschaltet |
| extraConfig.password_config.localdb_enabled | bool | `true` | lokale Nutzerdatenbank, eingeschaltet |
| extraConfig.password_config.policy.enabled | bool | `true` | Passwortpolicy nutzen, eingeschaltet |
| extraConfig.password_config.policy.minimum_length | int | `8` | Passwortmindestlänge in Zeichen |
| extraConfig.password_config.policy.require_digit | bool | `true` | Zahl muss mit genutzt werden |
| extraConfig.password_config.policy.require_lowercase | bool | `true` | Kleinbuchstaben muss genutzt werden |
| extraConfig.password_config.policy.require_symbol | bool | `true` | Sonderzeichen muss genutzt werden |
| extraConfig.password_config.policy.require_uppercase | bool | `true` | Großbuchstaben muss genutz werden |
| extraConfig.presence.enabled | bool | `false` | Anwesenheitstatus anzeigen, abgeschaltet (Load) |
| extraConfig.push.include_content | bool | `false` | Push Modul verschickt Inhalt der Nachricht über Google-/Apple-Push-Services, abgeschaltet |
| extraConfig.report_stats | bool | `false` | Übermitteln von Nutzungsstatistiken (werden abgeholt nicht übermittelt) |
| extraConfig.require_auth_for_profile_requests | bool | `true` | Authentifizierung notwendig für User-Suche |
| extraConfig.require_membership_for_aliases | bool | `true` | Alias nur für registrierte Nutzer (sowieso, nicht authentifizierte Nutzer sind abgeschaltet) |
| extraConfig.retention.enabled | bool | `false` | Nachrichtenaufbewahrungsrichtlinien einschalten (auf Raumebene) |
| extraConfig.stats.enabled | bool | `true` | Schalte Nutzerstatistiken ein, eingeschaltet |
| extraConfig.ui_auth.session_timeout | string | `"15s"` | User-Interactive Authentication API timeout  |
| extraConfig.url_preview_enabled | bool | `false` | URL-Vorschau, abgeschaltet |
| extraConfig.user_directory.enabled | bool | `true` | Nutzerverzeichnis erstellen, eingeschaltet (Vraussetzung für Nutzersuche) |
| extraConfig.user_directory.search_all_users | bool | `true` | Suche alle Nutzer, eingeschaltet |
| extraConfig.user_ips_max_age | string | `"28d"` | Maximale Speicherzeit für IPs von Nutzern (Whitelist mapping) |
| extraSecrets | map | `{}` | Geben Sie hier eine beliebige - geheime - Synapse-Konfiguration an; Diese Werte werden in Secrets anstelle von Configmaps gespeichert Ref: https://github.com/matrix-org/synapse/blob/develop/docs/sample_config.yaml Beispiel:  password_config:    pepper: '' |
| image.fullnameOverride | string | `""` | Überschreiben Sie den vollständigen Namen des installierten Charts. |
| image.nameOverride | string | `""` | Überschreibt einen Teil des installierten Namens, behält aber den Releasenamen bei. |
| image.pullPolicy | string | `"IfNotPresent"` | Pullpolicy für das konfigurierte Image imagePullPolicy „Always“, wenn tag ist „latest“ (imagepullpolicy-always.yaml) |
| image.repository | string | `"matrixdotorg/synapse"` | Repository/Image Konfiguration, für Synapse und Workernodes. |
| ingress.annotations."nginx.ingress.kubernetes.io/proxy-body-size" | string | `"50m"` | Annotiation, um Body-size zu vergößern (Default Limit 1 oder 10MB) |
| ingress.annotations."nginx.ingress.kubernetes.io/use-regex" | bool | `"true"` | Annotiation um Regex-Regeln nutzen zu können |
| ingress.className | string | `"nginx"` | Legen Sie den Namen der IngressClass-Cluster-Ressource fest (optional) https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/#IngressSpec |
| ingress.csHosts | list | `[]` | Hosts, die der Ingress-Konfiguration für die Verarbeitung von  Client-to-Server-API-Anfragepfade hinzugefügt werden sollen. Hinweis: config.serverName wird einbezogen, wenn includeServerName gesetzt ist. (default) Beispiel:  - matrix.beispiel.org |
| ingress.csPaths | path | `[]` | Zusätzliche Pfade, die zu den Client-zu-Server Blöcken hinzugefügt werden sollen Werden vor dem `/_matrix` und `/_synapse` Catch-all-Pfade eingefügt. Beispiele:  # K8s 1.19+  - path: /_matrix/media    pathType: Prefix    backend:      service:        name: matrix-media-repo        port: 8000  # K8s <1.19  - path: /_matrix/media    backend:      serviceName: matrix-media-repo      servicePort: 8000 |
| ingress.enabled | bool | `true` | Aktiviert Ingress-Konfiguration |
| ingress.hosts | list | `[]` | Zusätzliche Hosts, die der Ingress-Konfiguration für die Bearbeitung von Server-zu-Server-API-Anfragen hinzugefügt werden sollen. Hinweis: config.serverName wird einbezogen, wenn includeServerName gesetzt ist. (default) Beispiel:  - beispiel.org |
| ingress.includeServerName | bool | `true` | Sollte `config.serverName` in die Liste der Eingangspfade aufgenommen werden,  kann auf `false` gesetzt werden, wenn die Hauptdomäne auf irgendeine externe Weise verwaltet wird  |
| ingress.includeUnderscoreSynapse | bool | `true` | Sollte der `/_synapse`-Pfad im Ingress enthalten sein, werden die Admin-APIs unter diesem Pfad bereitgestellt. |
| ingress.paths | path | `[]` | Zusätzliche Pfade, die zu den Server-zu-Server-Eingangsblöcken hinzugefügt werden sollen Werden vor dem `/_matrix` Catch-all-Pfad eingefügt. Beispiele:  # K8s 1.19+  - path: /_matrix/media    pathType: Prefix    backend:      service:        name: matrix-media-repo        port: 8000  # K8s <1.19  - path: /_matrix/media    backend:      serviceName: matrix-media-repo      servicePort: 8000 |
| ingress.tls | map | `[]` | TLS-Konfiguration für Ingress Konfiguration Beispiel:  - secretName: chart-example-tls    hosts:      - beispiel.org      - matrix.beispiel.org |
| ingress.traefikPaths | bool | `false` | Generierung von Traefik-kompatiblen Regex-Pfaden anstelle von Nginx-kompatiblen Pfaden.  UNGETESTET! |
| ingress.wkHosts | list | `[]` | Zusätzliche Hosts, die der Ingress-Konfiguration für die Bearbeitung von wellknown-Anfragen hinzugefügt werden sollen. Hinweis: config.serverName wird einbezogen, wenn includeServerName gesetzt ist. (default) Beispiel:  - beispiel.org |
| persistence.accessMode | string | `"ReadWriteOnce"` | Zugriffsmodus |
| persistence.enabled | bool | `true` | Aktivieren der Persistenz-Konfiguration für die Medien-Repository-Funktion. Diese PVC wird entweder in Synapse oder einem media_repo-Worker eingehängt. Hinweis: Wenn Sie in der Lage sein wollen, dies zu skalieren, müssen Sie den accessMode auf RWX/ReadWriteMany setzen. |
| persistence.existingClaim | string | `"matrix-synapse"` | Name des VolumeClaims |
| persistence.size | string | `"10Gi"` | Größe des zu nutzenden Volumes |
| persistence.storageClass | string | `"nfs-client"` | Name der entsprechenden Storage-Klasse |
| postgresql.enabled | bool | `false` | Diese Konfiguration ist für die Einrichtung des intern bereitgestellten Postgres-Servers gedacht, Wenn Sie stattdessen einen vorhandenen Server verwenden wollen, sollten Sie enabled auf false setzen und den externalPostgresql-Block konfigurieren. |
| postgresql.extraArgs | list | `{}` | Zusätzliche Argumente für die Datenbankverbindung ref: https://github.com/matrix-org/synapse/blob/develop/docs/postgres.md#synapse-config |
| postgresql.persistence | map | `{"size":"16Gi","storageClass":"nfs-client"}` | Persistenzkonfiguration für Storage für PostgreSQL |
| postgresql.postgresqlDatabase | string | `"synapse_db"` | Name für PostgreSQL-DB |
| postgresql.postgresqlInitdbArgs | string | `"--lc-collate=C --lc-ctype=C"` | Extra Argumente zur Initialisierung der Datenbank  |
| postgresql.postgresqlPassword | string | `"synapse"` | Passwort für PostgreSQL Nutzer TODO: Muss in ein Vault! Oder verwenden Sie ein bestehendes Secret mit dem Schlüssel "postgresql-password" anstelle eines statischen Passworts  existingSecret: postgres-secrets  existingSecretPasswordKey: POSTGRES_PASSWORD |
| postgresql.postgresqlUsername | string | `"synapse"` | Name für PostgreSQL Nutzer |
| publicServerName | string | `""` | Der öffentliche Matrix-Servername, der für alle öffentlichen URLs  in der Konfiguration sowie für Client-API-Links im Ingress verwendet wird. @default  -- Nicht gesetzt |
| redis.architecture | string | `"standalone"` | Form der Architektur des Deployments |
| redis.auth | map | `{"enabled":true,"password":"synapse"}` | Konfiguration für Authentifikation gegen Redis Oder verwenden Sie ein bestehendes Geheimnis mit "redis-password"-Schlüssel anstelle eines statischen Passworts. Der Platzhalter wird später hart ignoriert, muss aber gesetzt und nicht leer sein dafür.  Nur für mehr als 1 Instanz je K8s interessant existingSecret: synapse-redis <- Was hab ich damit gemeint und was geändert |
| redis.enabled | bool | `true` | Diese Konfiguration ist für den internen Redis, der für die Verwendung mit Worker/Sharding eingesetzt wird. Für einen externen Redis-Server setzen Sie enabled auf false setzen und den externalRedis-Block konfigurieren. |
| redis.master.persistence.enabled | bool | `false` | Persistenzkonfiration des Redis Beachten Sie, dass Synapse redis nur als Synchronisierungsdienstprogramm verwendet, so dass keine Daten jemals persistiert werden müssen. |
| redis.master.service.port | int | `6379` | Serviceport |
| redis.master.statefulset.updateStrategy | string | `"RollingUpdate"` | Wie soll bei Update mit dem Pod verfahren werden https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies |
| schadcodescanner.enabled | bool | `false` | Aktivieren das ClamAV-Pods und Schadcodescanner |
| schadcodescanner.image | map | `{"pullPolicy":"IfNotPresent","repository":"clamav/clamav","tag":"stable"}` | Konfiguration des Image/Repository |
| schadcodescanner.resources.limits.cpu | string | `"400m"` | Rechenressourcengrenzen, die auf den ClamAV-Pod anzuwenden sind.  |
| schadcodescanner.resources.limits.memory | object | `"3Gi"` | RAM Ressourcengrenzen, die auf den ClamAV-Pod anzuwenden sind. |
| schadcodescanner.resources.requests.cpu | string | `"150m"` | Anforderungen an Rechenressourcen, die auf den ClamAV-Pod anzuwenden sind.  |
| schadcodescanner.resources.requests.memory | string | `"400Mi"` | Anforderungen an RAM Ressourcen, die auf den ClamAV-Pod anzuwenden sind.  |
| serverName | string | Nicht gesetzt, aber Voraussetzung! | Der Matrix-Domänenname, der für den Domänenteil in Ihren MXIDs verwendet wird. |
| service.port | int | `8008` | interner Port des Auszuliefernden Endpunktes für den Hauptdienst von Synapse |
| service.targetPort | int | `"http"` | externer Port des Auszuliefernden Endpunktes für den Hauptdienst von Synapse |
| service.type | string | `"ClusterIP"` | Typ des Auszuliefernden Endpunktes für den Hauptdienst von Synapse |
| signingkey.job.enabled | bool | `true` | es wird ein Job zu Beginn des Deployments gestartet, der einen Signierschlüssel erzeugt. Wenn abgeschaltet, muss ein vorhandener Schlüssel eingebunden werden, ansonsten ist eine Förderation als nicht vertrauenswürdig eingestuft |
| signingkey.job.generateImage.pullPolicy | string | `"IfNotPresent"` | PullPolicy für das Image vom Signing-Key-Job |
| signingkey.job.generateImage.repository | string | `"matrixdotorg/synapse"` | Repository/Image Konfiguration für Synapse-signing-key-job. Es wird dringend  empfohlen, dass die gleiche Konfiguration wie vom Synapse bzw. den Workernodes genutzt wird. |
| signingkey.job.publishImage | map | `{"pullPolicy":"IfNotPresent","repository":"bitnami/kubectl","tag":"1.21.13-debian-11-r4"}` | Repository/Image Konfiguration für den Upload des generierten Signing-Schlüssels.  aktuelle Version am 13.06.2022 vom kubectl im bitnami-Repo |
| signingkey.resources | object | `{}` |  |
| sygnal.affinity | list | `{}` | Affinitäts-Konfiguration für Sygnal-Pod. |
| sygnal.apns | map | `{"de.bundesmessenger.android":{"api_key":"AAAAhQYs0IM:APA91bEW1Xh-Hj3DejTt0M-6Aj3H3Lx0Ooa5saZGg59IdlRc5Fc-WCJWWX3g_3Y0xEfqDtcEp_BiL1v8i88Si-PUf0RUCDQXRZnh6eG09nDisWpIH8e0GlqcETengqBHpzpVDYkWbKB1","type":"gcm"},"de.bundesmessenger.ios.dev":{"key_id":"6F5K9Q96VZ","keyfile":"/etc/matrix/sygnal/de.bwi.bwmessenger.ios.dev.p8","platform":"sandbox","team_id":"Q283Q29YC2","topic":"de.bwi.bundesmessenger","type":"apns"}}` | APN-Konfigurationsteil Beispiel: apns:    de.opencode.dvs.ios:      type: apns      keyfile: /etc/matrix/sygnal/ |
| sygnal.enabled | bool | `true` | Aktivieren des Sygnal-Pod |
| sygnal.image | map | `{"pullPolicy":"IfNotPresent","repository":"matrixdotorg/sygnal","tag":"v0.11.0"}` | Image/Repo-Konfiguration von Sygnal |
| sygnal.ios_push.enabled | bool | `true` | IOS-Push Schalter Wenn iOS Push mit genutzt wird, muss hier der Schalter dafür auf true gesetzt werden, sonst schlägt das Modul fehl |
| sygnal.ios_push.ioskey_filename | map | `"de.bwi.bwmessenger.ios.dev.p8"` | iOS-Key Konfiguration bei Nutzung von iOS-Pushservice, muss Key mit angebeben werden. Weitereres siehe README.md Beispiel:     ioskey_filename: de.opencode.dvs.ios.p8 <<-- muss zwingend mit dem Keyfile-Dateinamen aus dem APN-File übereinstimmen!    ioskey_keyvalue: 'HIER KÖNNTE IHR KEY IN STEHEN' |
| sygnal.ios_push.ioskey_keyvalue | string | `"LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JR1RBZ0VBTUJNR0J5cUdTTTQ5QWdFR0NDcUdTTTQ5QXdFSEJIa3dkd0lCQVFRZ0lHUUFwU0hWcEpOVm9neTkKQXdIZWVpNC9pVXZ0QlR2TDU3N2R2OC9PTGN5Z0NnWUlLb1pJemowREFRZWhSQU5DQUFSTkJTMG5ra0RwR04zNQpIcjYrb3FyNDEwZTd6MG1Vc1ZOQUdmQjVmL0QwbVJna3RCV1dhN3lZM3c3ZlFHZVUybHl4aEtOSVhsQ2h6MElECnJ0blZLY2NI"` |  |
| sygnal.nodeSelector | list | `{}` | Node Selektor Konfiguration für Sygnal-Pod. |
| sygnal.podSecurityContext | map | `{"sysctls":[{"name":"net.ipv4.ip_unprivileged_port_start","value":"80"}]}` | Informationen zum Sicherheitskontext, die dem Sygnal mitgeteilt werden sollen. Hinweis: hier muss der Sycall für unpriviligierter User auf priviligierter Port gesetzt sein weitere Beispiele:  runAsNonRoot: true  fsGroup: 27  runAsGroup: 2000  runAsUser: 2000 |
| sygnal.resources.limits.cpu | string | `"150m"` | Rechenressourcengrenzen, die auf den Sygnal-Pod anzuwenden sind.  |
| sygnal.resources.limits.memory | object | `"45Mi"` | RAM Ressourcengrenzen, die auf den Sygnal-Pod anzuwenden sind. |
| sygnal.resources.requests.cpu | string | `"150m"` | Anforderungen an Rechenressourcen, die auf den Sygnal-Pod anzuwenden sind.  |
| sygnal.resources.requests.memory | string | `"45Mi"` | Anforderungen an RAM Ressourcen, die auf den Sygnal-Pod anzuwenden sind.  |
| sygnal.securityContext | map | `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2111}` | Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers weitere Beispiele:  capabilities:    drop:    - ALL |
| sygnal.tolerations | list | `[]` | Tolerations/Tains Konfiguration für Sygnal-Pod. |
| synapse | object | wird nachfolgend einzeln aufgeschlüsselt | Konfiguration, die auf den Haupt-Synapse-Pod anzuwenden ist. |
| synapse.affinity | object | `{}` | Affinität zur Wahl von Nodes für die für den Haupt-Synapse-Pod genutzt werden sollen. |
| synapse.annotations | map | `{}` | Annotations, die auf den Haupt-Synapse-Pod anzuwenden sind. Beispiel: (Bundesmessenger lässt alle Services automatisch an Prometheus anbinden)  prometheus.io/scrape: "true"  prometheus.io/path: "/_synapse/metrics"  prometheus.io/port: "9090" |
| synapse.extraCommands | list | `[]` | Zusätzliche Befehle, die beim Starten von Synapse ausgeführt werden Beispiele: - 'apt-get update -yqq && apt-get install patch -yqq' - 'patch -d/usr/local/lib/python3.7/site-packages/synapse -p2 < /synapse/patches/something.patch' |
| synapse.extraEnv | map | `[]` | Zusätzliche Umgebungsvariablen, die auf den Haupt-Synapse-pod anzuwenden sind Beispiel:  - name: LD_PRELOAD    value: /usr/lib/x86_64-linux-gnu/libjemalloc.so.2  - name: SYNAPSE_CACHE_FACTOR    value: "2" |
| synapse.extraVolumeMounts | object | `[]` | Zusätzliche in Synapse zu mountende Datenträgerpfade (Volumes) Beispiel:  - name: spamcheck    mountPath: /usr/local/lib/python3.7/site-packages/company |
| synapse.extraVolumes | object | `[]` | Zusätzliche in Synapse zu mountende Datenträger (Volumes) Beispiel:  - name: spamcheck    flexVolume:      driver: dvs/git-live      options:        repo: https://gitlab.opencode.de/bwi/bundesmessenger/synapse-module        interval: 1d      readOnly: true |
| synapse.labels | map | `{}` | Labels, die auf den Haupt-Synapse-Pod anzuwenden sind. |
| synapse.livenessProbe.httpGet.path | string | `"/health"` | Zu verwendende Konfiguration für den Pfad des Healthchecks  |
| synapse.livenessProbe.httpGet.port | string | `"http"` | Zu verwendende Konfiguration für den Port des Healthchecks  |
| synapse.nodeSelector | list | `{}` | Node Selektoren, die für den Haupt-Synapse-Pod festgelegt werden. |
| synapse.podSecurityContext | object | `{"runAsNonRoot":true}` | Konfiguration für die Pod-Sicherheitsrichtlinie, Synapse wird immer als sein eigener Benutzer ausgeführt, auch wenn dies nicht eingestellt ist.  Beachten Sie, dass eine Änderung dieser Einstellung auch die Verwendung der volumePermission Hilfsprogramm verwenden müssen, abhängig von Ihrem Speicher. |
| synapse.readinessProbe.httpGet.path | string | `"/health"` | Konfiguration des Pfads vom Bereitschaftscheck |
| synapse.readinessProbe.httpGet.port | string | `"http"` | Konfiguration des Ports vom Bereitschaftscheck |
| synapse.resources.limits.cpu | string | `"1000m"` | Rechenressourcengrenzen, die auf den Haupt-Synapse-Pod anzuwenden sind.  |
| synapse.resources.limits.memory | object | `"2500Mi"` | RAM Ressourcengrenzen, die auf den Haupt-Synapse-Pod anzuwenden sind. |
| synapse.resources.requests.cpu | string | `"1000m"` | Anforderungen an Rechenressourcen, die auf den Haupt-Synapse-Pod anzuwenden sind.  |
| synapse.resources.requests.memory | string | `"2500Mi"` | Anforderungen an RAM Ressourcen, die auf den Haupt-Synapse-Pod anzuwenden sind.  |
| synapse.securityContext | map | `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2666}` | Konfiguration für die Container-Sicherheitsrichtlinie, siehe oben podSecurityContext für weitere relevante Informationen. |
| synapse.strategy.type | string | `"RollingUpdate"` | Nur wirklich anwendbar, wenn das Deployment ein RWO PV angehängt hat (z.B. wenn Media Repository für den Haupt-Synapse-Pod aktiviert ist) Da Replikate = 1 sind, kann eine Aktualisierung "hängen bleiben", da der vorherige Pod mit dem PV verbunden bleibt und der "neu-aufgebaute" Pod nie starten kann. Das Ändern der Strategie auf "Recreate" wird den einzelnen vorherigen Pod beenden, so dass der neue, ankommende Pod sich mit dem PV verbinden kann |
| synapse.tolerations | list | `[]` | Tolerations bzw. Taints die für den Haupt-Synapse-Pod genutzt werden sollen. |
| synapse_admin.adminUri | string | `"msgk8sadmin.itlab.net"` | URI für die Admin GUI, zwingend notwendig |
| synapse_admin.enabled | bool | `true` | Aktivieren des Synapse-Admin-Moduls |
| synapse_admin.image | map | `{"pullPolicy":"IfNotPresent","repository":"awesometechnologies/synapse-admin","tag":"0.8.5"}` | Konfiguration des Image vom Modul |
| synapse_admin.livenessProbe.httpGet.path | string | `"/"` | Zu verwendende Konfiguration für den Pfad des Healthchecks  |
| synapse_admin.livenessProbe.httpGet.port | string | `"http"` | Zu verwendende Konfiguration für den Port des Healthchecks  |
| synapse_admin.podSecurityContext.sysctls | map | `[{"name":"net.ipv4.ip_unprivileged_port_start","value":"80"}]` | Informationen zum Sicherheitskontext, die dem Sygnal mitgeteilt werden sollen. Hinweis: hier muss der Sycall für unpriviligierter User auf priviligierter Port gesetzt sein weitere Beispiele:    runAsNonRoot: true |
| synapse_admin.readinessProbe.httpGet.path | string | `"/"` | Konfiguration des Pfads vom Bereitschaftscheck |
| synapse_admin.readinessProbe.httpGet.port | string | `"http"` | Konfiguration des Ports vom Bereitschaftscheck |
| synapse_admin.resources.limits.cpu | string | `"5m"` | Rechenressourcengrenzen, die auf den Synapse-Admin Server anzuwenden sind.  |
| synapse_admin.resources.limits.memory | object | `"15Mi"` | RAM Ressourcengrenzen, die auf den Synapse-Admin Server anzuwenden sind. |
| synapse_admin.resources.requests.cpu | string | `"5m"` | Anforderungen an Rechenressourcen, die auf den Synapse-Admin Server anzuwenden sind.  |
| synapse_admin.resources.requests.memory | string | `"15Mi"` | Anforderungen an RAM Ressourcen, die auf den Synapse-Admin Server anzuwenden sind.  |
| synapse_admin.securityContext | map | `{}` | Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers weitere Beispiele:    runAsNonRoot: true    readOnlyRootFilesystem: true    runAsUser: 2010 |
| volumePermissions.enabled | bool | `true` | Aktivieren des Init-Containers zur Rechtekorrektur, um die Rechte auf dem Volume für Media anzupassen Notwendig für policy 'require-uid-greater-2000' |
| volumePermissions.gid | int | `2666` | Nutzer-ID  Notwendig für policy 'require-uid-greater-2000' |
| volumePermissions.image.pullPolicy | string | `"Always"` | da latest-Tag, PullPolicy immer für das zu nutzende Image zur Rechtebereinigung |
| volumePermissions.image.repository | string | `"alpine"` | das Repository für das zu nutzende Image zur Rechtebereinigung |
| volumePermissions.image.tag | string | `"latest"` | das Tag für das zu nutzende Image zur Rechtebereinigung Hinweis: alles außer latest ist hier sinnfrei |
| volumePermissions.resources | map | `{}` | Ressourcen des Init-Containers zur Rechtekorrektur Hier keine gesetzt, da kurzlebig und von Hause aus klein Beispiel: resources:   requests:     memory: 128Mi     cpu: 100m |
| volumePermissions.uid | int | `2666` | Nutzer-ID  Notwendig für policy 'require-uid-greater-2000' |
| wellknown.affinity | list | `{}` | Affinitäts-Konfiguration für well-known server. |
| wellknown.client | map | `{"io.element.e2ee":{"outbound_keys_pre_sharing_mode":"on_room_opening","secure_backup_required":true,"secure_backup_setup_methods":["passphrase"]},"m.homeserver":{"base_url":"https://msgk8s.lab-mobility.de"}}` | Daten, die auf .well-known/matrix/client bereitgestellt werden sollen |
| wellknown.enabled | bool | `true` | Aktivierung des Wellknown-Pods |
| wellknown.htdocsPath | path | `"/var/www/localhost/htdocs"` | Ein benutzerdefinierter htdocs-Pfad, der nützlich ist, wenn ein anderes Image ausgeführt wird. |
| wellknown.image | map | `{"pullPolicy":"IfNotPresent","repository":"sebp/lighttpd","tag":"1.4.61-r1"}` | Das lighttpd image optional: pullSecrets:   - myRegistryKeySecretName |
| wellknown.nodeSelector | list | `{}` | Node Selektor Konfiguration für well-known server. |
| wellknown.podSecurityContext | map | `{"runAsNonRoot":true}` | Informationen zum Sicherheitskontext, die dem Arbeiter mitgeteilt werden sollen. weitere Möglichkeiten:  fsGroup: 2001  runAsGroup: 2001  runAsUser: 2001 |
| wellknown.resources.limits.cpu | string | `"5m"` | Rechenressourcengrenzen, die auf den well-known server anzuwenden sind.  |
| wellknown.resources.limits.memory | object | `"15Mi"` | RAM Ressourcengrenzen, die auf den well-known server anzuwenden sind. |
| wellknown.resources.requests.cpu | string | `"5m"` | Anforderungen an Rechenressourcen, die auf den well-known server anzuwenden sind.  |
| wellknown.resources.requests.memory | string | `"15Mi"` | Anforderungen an RAM Ressourcen, die auf den well-known server anzuwenden sind.  |
| wellknown.securityContext | map | `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2022}` | Konfiguration für die Container-Sicherheitsrichtlinie weitere Möglichkeiten:  capabilities:    drop:    - ALL |
| wellknown.server."m.server" | map | `"msgk8s.lab-mobility.de:443"` | Die Host- und Port-Kombination, die auf .well-known/matrix/server zu bedienen ist. |
| wellknown.tolerations | list | `[]` | Tolerations/Tains Konfiguration für well-known server. |
| wellknown.useIpv6 | bool | `false` | Lighttpd bindet standardmäßig nicht an IPv6, obwohl dies in IPv6-only-Clustern erforderlich ist. |
| workers.annotations | map | `{}` | Annotations, die auf die Synapse-Worker-Pods anzuwenden sind. Standardkonfiguration, diese wird an alle Worker vererbt und kann auch für jeden Workertyp überschrieben werden. Beispiel: (Bundesmessenger lässt alle Services automatisch an Prometheus anbinden)  prometheus.io/scrape: "true"  prometheus.io/path: "/_synapse/metrics"  prometheus.io/port: "9090" |
| workers.appservice.enabled | bool | `false` | Dieser Worker sorgt für das Senden von Daten an registrierte Anwendungsdienste. Hinweis: Es kann jeweils nur eine Instanz dieses Workers ausgeführt werden. |
| workers.default.affinity | list | `{}` | Affinitäts-Konfiguration, die auf alle Synapse-Worker-Pod anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Pods.  |
| workers.default.annotations | map | `{}` | DEFAULT Annotations, die auf alle Synapse-Worker-Pods anzuwenden sind. Beispiel: (Bundesmessenger lässt alle Services automatisch an Prometheus anbinden)  prometheus.io/scrape: "true"  prometheus.io/path: "/_synapse/metrics"  prometheus.io/port: "9090" |
| workers.default.extraCommands | list | `[]` | Zusätzliche Befehle, die beim Starten von Synapse ausgeführt werden DEFAULT gilt für alle Synapse-Worker-Pods. Beispiele: - 'apt-get update -yqq && apt-get install patch -yqq' - 'patch -d/usr/local/lib/python3.7/site-packages/synapse -p2 < /synapse/patches/something.patch' |
| workers.default.extraEnv | object | `[]` | DEFAULT Zusätzliche Umgebungsvariablen, die auf alle Synapse-Worker-Pods anzuwenden sind Beispiel:  - name: LD_PRELOAD    value: /usr/lib/x86_64-linux-gnu/libjemalloc.so.2  - name: SYNAPSE_CACHE_FACTOR    value: "1.0" |
| workers.default.livenessProbe.httpGet.path | string | `"/health"` | Zu verwendende Konfiguration für den Pfad des Healthchecks  DEFAULT gilt für alle Synapse-Worker-Pods.  |
| workers.default.livenessProbe.httpGet.port | string | `"listener"` | Zu verwendende Konfiguration für den Port des Healthchecks  DEFAULT gilt für alle Synapse-Worker-Pods.  |
| workers.default.nodeSelector | list | `{}` | Node Selektor Konfiguration, die auf alle Synapse-Worker-Pod anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Pods.  |
| workers.default.podSecurityContext | map | `{}` | Informationen zum Sicherheitskontext, die dem Arbeiter mitgeteilt werden sollen. DEFAULT gilt für alle Synapse-Worker-Pods. Beispiele:   fsGroup: 2003   runAsGroup: 2003   runAsUser: 2003 |
| workers.default.readinessProbe.httpGet.path | string | `"/health"` | Konfiguration des Pfads vom Bereitschaftscheck DEFAULT gilt für alle Synapse-Worker-Pods.  |
| workers.default.readinessProbe.httpGet.port | string | `"listener"` | Konfiguration des Ports vom Bereitschaftscheck DEFAULT gilt für alle Synapse-Worker-Pods.  |
| workers.default.replicaCount | int | `1` | DEFAULT Die Anzahl der Worker-Replikate.  Beachten Sie, dass einige Worker eine besondere Behandlung erfordern.  Siehe dazu die Informations-URL https://github.com/matrix-org/synapse/blob/master/docs/workers.md |
| workers.default.resources.limits.cpu | string | `"100m"` | Rechenressourcengrenzen, die auf alle Synapse-Worker-Pod anzuwenden sind.  DEFAULT gilt für alle Synapse-Worker-Pods.  Epmfohlen gesondert zu verwalten |
| workers.default.resources.limits.memory | object | `"128Mi"` | RAM Ressourcengrenzen, die auf alle Synapse-Worker-Pod anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Pods.  Epmfohlen gesondert zu verwalten |
| workers.default.resources.requests.cpu | string | `"100m"` | Anforderungen an Rechenressourcen, die auf alle Synapse-Worker-Pod anzuwenden sind.  DEFAULT gilt für alle Synapse-Worker-Pods.  Epmfohlen gesondert zu verwalten |
| workers.default.resources.requests.memory | string | `"128Mi"` | Anforderungen an RAM Ressourcen, die auf alle Synapse-Worker-Pod anzuwenden sind.  DEFAULT gilt für alle Synapse-Worker-Pods.  Epmfohlen gesondert zu verwalten |
| workers.default.securityContext | map | `{}` | Konfiguration für die Container-Sicherheitsrichtlinie DEFAULT gilt für alle Synapse-Worker-Pods. Beispiele:   readOnlyRootFilesystem: true   runAsNonRoot: true   runAsUser: 2003   capabilities:     drop:       - ALL |
| workers.default.strategy.type | string | `"RollingUpdate"` | DEFAULT gilt für alle Synapse-Worker-Pods Nur wirklich anwendbar, wenn das Deployment ein RWO PV angehängt hat (z.B. Media Repository) Da Replikate = 1 sind, kann eine Aktualisierung "hängen bleiben", da der vorherige Pod mit dem PV verbunden bleibt und der "neu-aufgebaute" Pod nie starten kann. Das Ändern der Strategie auf "Recreate" wird den einzelnen vorherigen Pod beenden, so dass der neue, ankommende Pod sich mit dem PV verbinden kann |
| workers.default.tolerations | list | `[]` | Tolerations/Tains Konfiguration, die auf alle Synapse-Worker-Pod anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Pods.  |
| workers.default.volumeMounts | map | `[]` | Zusätzliche zu mountende Datenträgerpfade (siehe volumes) DEFAULT gilt für alle Synapse-Worker-Pods. |
| workers.default.volumes | map | `[]` | Zusätzliche Volumes, die dem Worker hinzugefügt werden sollen. DEFAULT gilt für alle Synapse-Worker-Pods. Nützlich für das Medien-Repo oder zum Hinzufügen von Python-Modulen. Daher besser im entsprechenden Konfigurationsteil der spez. Worker |
| workers.federation_reader.enabled | bool | `false` | Aktiviere spez. Worker für Förderationsanfragen |
| workers.federation_reader.generic | bool | `true` | Wird aus dem generischen Worker abgeleitet |
| workers.federation_reader.listeners | list | `["federation"]` | Zusätzliche Listener für Förderationsworker |
| workers.federation_reader.paths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Server-Side Pfade für die Ingress-Konfiguration des Förderations-Workers |
| workers.federation_sender.enabled | bool | `false` | Dieser Worker kümmert sich um den Versand des  Verbundverkehrs(Förderation Traffik) an andere Synapse-Server. |
| workers.frontend_proxy.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfade für die Ingress-Konfiguration des FrontendProxy-Workers Hinweis: (default Bundesmessenger) Wenn Sie extraConfig.use_presence=false setzen, sollten Sie den folgenden Pfad eintragen: - "/_matrix/client/(api/v1|r0|v3|unstable)/presence/[^/]+/status" |
| workers.frontend_proxy.enabled | bool | `false` | Aktivierung des FrontendProxy-Worker Dieser Worker kümmert sich um das Hochladen von Schlüsseln,  und kann auch die Anwesenheit ausblenden, wenn diese deaktiviert ist |
| workers.frontend_proxy.listeners | list | `["client"]` | Zusätzliche Listener für frontendproxy-Worker |
| workers.generic_worker.autoscaling | int | `{"enabled":true,"maxReplicas":10,"minReplicas":2,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80}` | Anzahl der Worker-Pods Hinweis: Wenn autoscaling.enabled=true und replicaCount geringer als autoscaling.minReplicas  oder wenn nicht gesetzt, dann wird autoscaling.minReplicas übernommen replicaCount: 2 # Konfiguration für das auto-scaling der Applikation. |
| workers.generic_worker.autoscaling.enabled | bool | `true` | schalte das HPA für die Pods ein |
| workers.generic_worker.autoscaling.maxReplicas | int | `10` | maximale Anzahl der Worker-Pods |
| workers.generic_worker.autoscaling.minReplicas | int | `2` | minimale Anzahl der Worker-Pods |
| workers.generic_worker.autoscaling.targetCPUUtilizationPercentage | int | `80` | Prozentsatz für CPU-Auslastung um Scaling zu triggern |
| workers.generic_worker.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Prozentsatz für RAM-Auslastung um Scaling zu triggern |
| workers.generic_worker.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfad für die Ingress-Konfiguration des Workers auskommentiert: - "/_matrix/client/(v2_alpha|r0|v3)/sync" - "/_matrix/client/(api/v1|r0|v3)/initialSync" - "/_matrix/client/(api/v1|r0|v3)/rooms/[^/]+/initialSync" |
| workers.generic_worker.enabled | bool | `true` | Aktivieren von Workern |
| workers.generic_worker.generic | bool | `true` | Aktivieren des generischen Workers (kann alle Aufgaben übernehmen) spezifische Aufgaben können spezifischen Workern übergeben werden z.B. Media Repo |
| workers.generic_worker.listeners | list | `["client","federation"]` | entsprechende Endpunkte für den generischen Worker |
| workers.generic_worker.paths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Server-Side (externer Zugriff) Pfade für die Ingress-Konfiguration des Workers |
| workers.generic_worker.securityContext | map | `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2003}` | Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers |
| workers.media_repository.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfade für die Ingress-Konfiguration des Media-Workers |
| workers.media_repository.enabled | bool | `true` | Aktivieren des Media-Worker Dieser Worker kümmert sich um die Bereitstellung und Speicherung von Medien. Hinweis: Die Ausführung mehrerer Instanzen führt zu Konflikten mit Hintergrundaufgaben. |
| workers.media_repository.listeners | list | `["media"]` | Zusätzliche Listener für Media-Worker |
| workers.media_repository.paths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Server-Side(externe) Pfade für die Ingress-Konfiguration des Media-Workers |
| workers.media_repository.securityContext | map | `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2666}` | Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers Überschreibt die Konfiguration von Default und generischen Worker |
| workers.pusher.enabled | bool | `false` | Dieser Worker kümmert sich um die Übermittlung von Benachrichtigungen. Hinweis: Es kann jeweils nur eine Instanz dieses Workers ausgeführt werden WICHTIGER HINWEIS: Dafür gibt es den Sygnal-Service und Pod!!! |
| workers.synchrotron.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfade für die Ingress-Konfiguration des Synchworkers |
| workers.synchrotron.enabled | bool | `false` | Aktivierung des Synch-Workers |
| workers.synchrotron.generic | bool | `true` | Wird aus dem generischen Worker abgeleitet |
| workers.synchrotron.listeners | list | `["client"]` | Zusätzliche Listener für Synchworker |
| workers.user_dir.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfade für die Ingress-Konfiguration des Nutzersuch-Workers |
| workers.user_dir.enabled | bool | `true` | Aktivieren des Nutzersuch-Workers Hinweis: Damit kann die Last vom generischen bzw. Haupt-Worker genommen werden |
| workers.user_dir.listeners | list | `["client"]` | Zusätzliche Listener für NutzerSuch-Worker |
