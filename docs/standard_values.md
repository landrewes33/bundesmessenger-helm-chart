# bundesmessenger

![Version: 0.9.1](https://img.shields.io/badge/Version-0.9.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.61.1](https://img.shields.io/badge/AppVersion-1.61.1-informational?style=flat-square)

BWI Matrix BundesMessenger

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Christian Steinke | <christian.steinke@bwi.de> |  |
| Alexander Olofsson | <ace@haxalot.com> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.enableRegistration | bool | true | Registrierungskonfiguration, beachten Sie, dass die Registrierung mit dem containerinternen Werkzeug register_new_matrix_user immer möglich ist. |
| config.extraListeners | list | `[]` | Extra listener  |
| config.logLevel | string | `"INFO"` | Das Loglevel  für Synapse und alle Module. |
| config.macaroonSecretKey | string | `""` | Hinweis: Es wird dringend empfohlen, diesen Wert auf einen secure value (secret) zu setzen. |
| config.publicBaseurl | string | `""` | Die öffentlich zugängliche URL für die Synapse-Instanz  lautet standardmäßig https://<publicServerName> Beispiel:  publicBaseurl: 'https://matrix.beispiel.org' |
| config.registrationSharedSecret | string | `""` | Hinweis: Dieser Wert wird standardmäßig auf eine zufällige Zeichenfolge gesetzt, wenn er nicht angegeben wird. |
| config.reportStats | bool | `true` | Sollen Nutzungsstatistiken gemeldet werden |
| config.trustedKeyServers | map | `[{"server_name":"matrix.org"}]` | Eine Gruppe von vertrauenswürdigen Servern, die zu kontaktieren sind, wenn ein anderer Server nicht auf eine Signierschlüssel-Anfrage antwortet. |
| config.turnUris | list | `[]` | URIs die zum Aufbau von 1:1 WebRTC Anrufe aufzubauen. Beispiel: turnUris: ["turn:turn.beispiel.org:3478?transport=udp"] |
| externalPostgresql.database | string | `"synapse_db"` |  |
| externalPostgresql.existingSecretPasswordKey | string | `"POSTGRES_PASSWORD"` |  |
| externalPostgresql.extraArgs | object | `{}` |  |
| externalPostgresql.password | string | `"synapse"` |  |
| externalPostgresql.port | int | `5432` |  |
| externalPostgresql.username | string | `"synapse"` |  |
| externalRedis.port | int | `6379` |  |
| extraConfig | object | wird nachfolgend aufgeschlüsselt | Best Practise BWI GmbH: Ref: https://github.com/matrix-org/synapse/blob/develop/docs/sample_config.yaml |
| extraConfig.allow_guest_access | bool | `false` | Gastzugang, abgeschaltet |
| extraConfig.allow_public_rooms_over_federation | bool | `false` | öffentliche Räume über Förderation erlauben, abgeschaltet  |
| extraConfig.allow_public_rooms_without_auth | bool | `false` | Öffentliche Räume ohne Login/Authentifizierung, abgeschaltet! |
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
| extraSecrets | object | `{}` | Geben Sie hier eine beliebige - geheime - Synapse-Konfiguration an; Diese Werte werden in Secrets anstelle von Configmaps gespeichert Ref: https://github.com/matrix-org/synapse/blob/develop/docs/sample_config.yaml |
| image.fullnameOverride | string | `""` | Überschreiben Sie den vollständigen Namen des installierten Charts. |
| image.nameOverride | string | `""` | Überschreibt einen Teil des installierten Namens, behält aber den Releasenamen bei. |
| image.pullPolicy | string | `"IfNotPresent"` | Pullpolicy für das konfigurierte Image imagePullPolicy „Always“, wenn tag ist „latest“ (imagepullpolicy-always.yaml) |
| image.pullSecrets | map | nicht gesetzt | Optional kann ein Array von imagePullSecrets angegeben werden.  Secrets müssen manuell im Namensraum angelegt werden. ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ Beispiel: pullSecrets:    - myRegistryKeySecretName |
| image.repository | string | `"matrixdotorg/synapse"` | Repository/Image Konfiguration, für Synapse und Workernodes. |
| image.tag | string | wird im Charts.yaml gesetzt | kann die gesetzte Defaultversion überschreiben, wenn gesetzt. |
| persistence.accessMode | string | `"ReadWriteOnce"` | Zugriffsmodus |
| persistence.enabled | bool | `true` | Aktivieren der Persistenz-Konfiguration für die Medien-Repository-Funktion. Diese PVC wird entweder in Synapse oder einem media_repo-Worker eingehängt. Hinweis: Wenn Sie in der Lage sein wollen, dies zu skalieren, müssen Sie den accessMode auf RWX/ReadWriteMany setzen. |
| persistence.existingClaim | string | `"matrix-synapse"` | Name des VolumeClaims |
| persistence.size | string | `"10Gi"` | Größe des zu nutzenden Volumes |
| persistence.storageClass | string | `"nfs-client"` | Name der entsprechenden Storage-Klasse |
| publicServerName | string | `""` | Der öffentliche Matrix-Servername, der für alle öffentlichen URLs  in der Konfiguration sowie für Client-API-Links im Ingress verwendet wird. @default  -- Nicht gesetzt |
| serverName | string | Nicht gesetzt, aber Voraussetzung! | Der Matrix-Domänenname, der für den Domänenteil in Ihren MXIDs verwendet wird. |
| service.port | int | `8008` | interner Port des Auszuliefernden Endpunktes für den Hauptdienst von Synapse |
| service.targetPort | int | `"http"` | externer Port des Auszuliefernden Endpunktes für den Hauptdienst von Synapse |
| service.type | string | `"ClusterIP"` | Typ des Auszuliefernden Endpunktes für den Hauptdienst von Synapse |
| signingkey.job.enabled | bool | `true` | es wird ein Job zu Beginn des Deployments gestartet, der einen Signierschlüssel erzeugt. Wenn abgeschaltet, muss ein vorhandener Schlüssel eingebunden werden, ansonsten ist eine Förderation als nicht vertrauenswürdig eingestuft |
| signingkey.job.generateImage.pullPolicy | string | `"IfNotPresent"` | PullPolicy für das Image vom Signing-Key-Job |
| signingkey.job.generateImage.repository | string | `"matrixdotorg/synapse"` | Repository/Image Konfiguration für Synapse-signing-key-job. Es wird dringend  empfohlen, dass die gleiche Konfiguration wie vom Synapse bzw. den Workernodes genutzt wird. |
| signingkey.job.publishImage | map | `{"pullPolicy":"IfNotPresent","repository":"bitnami/kubectl","tag":"1.21.13-debian-11-r4"}` | Repository/Image Konfiguration für den Upload des generierten Signing-Schlüssels.  aktuelle Version am 13.06.2022 vom kubectl im bitnami-Repo |
| signingkey.resources | object | `{}` |  |
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
| volumePermissions.enabled | bool | `true` | Aktivieren des Init-Containers zur Rechtekorrektur, um die Rechte auf dem Volume für Media anzupassen Notwendig für policy 'require-uid-greater-2000' |
| volumePermissions.gid | int | `2666` | Nutzer-ID  Notwendig für policy 'require-uid-greater-2000' |
| volumePermissions.image.pullPolicy | string | `"Always"` | da latest-Tag, PullPolicy immer für das zu nutzende Image zur Rechtebereinigung |
| volumePermissions.image.repository | string | `"alpine"` | das Repository für das zu nutzende Image zur Rechtebereinigung |
| volumePermissions.image.tag | string | `"latest"` | das Tag für das zu nutzende Image zur Rechtebereinigung Hinweis: alles außer latest ist hier sinnfrei |
| volumePermissions.resources | map | `{}` | Ressourcen des Init-Containers zur Rechtekorrektur Hier keine gesetzt, da kurzlebig und von Hause aus klein Beispiel: resources:   requests:     memory: 128Mi     cpu: 100m |
| volumePermissions.uid | int | `2666` | Nutzer-ID  Notwendig für policy 'require-uid-greater-2000' |
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
| workers.federation_sender.enabled | bool | `false` | Dieser Worker kümmert sich um den Versand des  Verbundverkehrs(Förderation Traffik) an andere Synapse-Server. |
| workers.frontend_proxy.csPaths[0] | path | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/keys/upload"` | Client-Side(cs) Pfade für die Ingress-Konfiguration des FrontendProxy-Workers Hinweis: (default Bundesmessenger) Wenn Sie extraConfig.use_presence=false setzen, sollten Sie den folgenden Pfad eintragen: - "/_matrix/client/(api/v1\|r0\|v3\|unstable)/presence/[^/]+/status" |
| workers.frontend_proxy.csPaths[1] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/presence/[^/]+/status"` |  |
| workers.frontend_proxy.enabled | bool | `false` | Aktivierung des FrontendProxy-Worker Dieser Worker kümmert sich um das Hochladen von Schlüsseln,  und kann auch die Anwesenheit ausblenden, wenn diese deaktiviert ist |
| workers.frontend_proxy.listeners | list | `["client"]` | Zusätzliche Listener für frontendproxy-Worker |
| workers.generic_worker.autoscaling.enabled | bool | `true` | schalte das HPA für die Pods ein |
| workers.generic_worker.autoscaling.maxReplicas | int | `10` | maximale Anzahl der Worker-Pods |
| workers.generic_worker.autoscaling.minReplicas | int | `2` | minimale Anzahl der Worker-Pods |
| workers.generic_worker.autoscaling.targetCPUUtilizationPercentage | int | `80` | Prozentsatz für CPU-Auslastung um Scaling zu triggern |
| workers.generic_worker.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Prozentsatz für RAM-Auslastung um Scaling zu triggern |
| workers.generic_worker.csPaths[0] | path | im Folgenden aufgeschlüsselt | Client-Side(cs) Pfad für die Ingress-Konfiguration des Workers auskommentiert: - "/_matrix/client/(v2_alpha|r0|v3)/sync" - "/_matrix/client/(api/v1\|r0\|v3)/initialSync" - "/_matrix/client/(api/v1\|r0\|v3)/rooms/[^/]+/initialSync" |
| workers.generic_worker.csPaths[10] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/keys/query"` |  |
| workers.generic_worker.csPaths[11] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/keys/changes"` |  |
| workers.generic_worker.csPaths[12] | string | `"/_matrix/client/versions"` |  |
| workers.generic_worker.csPaths[13] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/voip/turnServer"` |  |
| workers.generic_worker.csPaths[14] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/joined_groups"` |  |
| workers.generic_worker.csPaths[15] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/publicised_groups"` |  |
| workers.generic_worker.csPaths[16] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/login"` |  |
| workers.generic_worker.csPaths[17] | string | `"/_matrix/client/(r0\|v3\|unstable)/register"` |  |
| workers.generic_worker.csPaths[18] | string | `"/_matrix/client/(r0\|v3\|unstable)/auth/.*/fallback/web"` |  |
| workers.generic_worker.csPaths[19] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/rooms/.*/send"` |  |
| workers.generic_worker.csPaths[1] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/publicRooms"` |  |
| workers.generic_worker.csPaths[20] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/rooms/.*/(join\|invite\|leave\|ban\|unban\|kick)"` |  |
| workers.generic_worker.csPaths[21] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/join/"` |  |
| workers.generic_worker.csPaths[22] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/profile/"` |  |
| workers.generic_worker.csPaths[2] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/rooms/.*/joined_members"` |  |
| workers.generic_worker.csPaths[3] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/rooms/.*/context/.*"` |  |
| workers.generic_worker.csPaths[4] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/rooms/.*/members"` |  |
| workers.generic_worker.csPaths[5] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/rooms/.*/state"` |  |
| workers.generic_worker.csPaths[6] | string | `"/_matrix/client/unstable/org.matrix.msc2946/rooms/.*/spaces"` |  |
| workers.generic_worker.csPaths[7] | string | `"/_matrix/client/unstable/org.matrix.msc2946/rooms/.*/hierarchy"` |  |
| workers.generic_worker.csPaths[8] | string | `"/_matrix/client/unstable/im.nheko.summary/rooms/.*/summary"` |  |
| workers.generic_worker.csPaths[9] | string | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/account/3pid"` |  |
| workers.generic_worker.enabled | bool | `true` | Aktivieren von Workern |
| workers.generic_worker.enabled | bool | `false` | Aktiviere spez. Worker für Förderationsanfragen |
| workers.generic_worker.federation_reader | string | `nil` |  |
| workers.generic_worker.generic | bool | `true` | Aktivieren des generischen Workers (kann alle Aufgaben übernehmen) spezifische Aufgaben können spezifischen Workern übergeben werden z.B. Media Repo |
| workers.generic_worker.generic | bool | `true` | Wird aus dem generischen Worker abgeleitet |
| workers.generic_worker.listeners | list | `["federation"]` | Zusätzliche Listener für Förderationsworker |
| workers.generic_worker.listeners | list | `["client","federation"]` | entsprechende Endpunkte für den generischen Worker |
| workers.generic_worker.paths[0] | path | `"/_matrix/federation/v1/send/"` | Server-Side Pfade für die Ingress-Konfiguration des Förderations-Workers |
| workers.generic_worker.paths[0] | path | `"/_matrix/federation/v1/event/"` | Server-Side (externer Zugriff) Pfade für die Ingress-Konfiguration des Workers |
| workers.generic_worker.paths[10] | string | `"/_matrix/federation/v2/send_join/"` |  |
| workers.generic_worker.paths[11] | string | `"/_matrix/federation/v1/send_leave/"` |  |
| workers.generic_worker.paths[12] | string | `"/_matrix/federation/v2/send_leave/"` |  |
| workers.generic_worker.paths[13] | string | `"/_matrix/federation/v1/invite/"` |  |
| workers.generic_worker.paths[14] | string | `"/_matrix/federation/v2/invite/"` |  |
| workers.generic_worker.paths[15] | string | `"/_matrix/federation/v1/query_auth/"` |  |
| workers.generic_worker.paths[16] | string | `"/_matrix/federation/v1/event_auth/"` |  |
| workers.generic_worker.paths[17] | string | `"/_matrix/federation/v1/exchange_third_party_invite/"` |  |
| workers.generic_worker.paths[18] | string | `"/_matrix/federation/v1/user/devices/"` |  |
| workers.generic_worker.paths[19] | string | `"/_matrix/federation/v1/send/"` |  |
| workers.generic_worker.paths[1] | string | `"/_matrix/federation/v1/state/"` |  |
| workers.generic_worker.paths[20] | string | `"/_matrix/federation/v1/get_groups_publicised"` |  |
| workers.generic_worker.paths[21] | string | `"/_matrix/key/v2/query"` |  |
| workers.generic_worker.paths[2] | string | `"/_matrix/federation/v1/state_ids/"` |  |
| workers.generic_worker.paths[3] | string | `"/_matrix/federation/v1/backfill/"` |  |
| workers.generic_worker.paths[4] | string | `"/_matrix/federation/v1/get_missing_events/"` |  |
| workers.generic_worker.paths[5] | string | `"/_matrix/federation/v1/publicRooms"` |  |
| workers.generic_worker.paths[6] | string | `"/_matrix/federation/v1/query/"` |  |
| workers.generic_worker.paths[7] | string | `"/_matrix/federation/v1/make_join/"` |  |
| workers.generic_worker.paths[8] | string | `"/_matrix/federation/v1/make_leave/"` |  |
| workers.generic_worker.paths[9] | string | `"/_matrix/federation/v1/send_join/"` |  |
| workers.generic_worker.replicaCount | int | `2` | Anzahl der Worker-Pods |
| workers.generic_worker.securityContext | map | `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2003}` | Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers |
| workers.media_repository.csPaths[0] | path | `"/_matrix/media/"` | Client-Side(cs) Pfade für die Ingress-Konfiguration des Media-Workers |
| workers.media_repository.enabled | bool | `true` | Aktivieren des Media-Worker Dieser Worker kümmert sich um die Bereitstellung und Speicherung von Medien. Hinweis: Die Ausführung mehrerer Instanzen führt zu Konflikten mit Hintergrundaufgaben. |
| workers.media_repository.listeners | list | `["media"]` | Zusätzliche Listener für Media-Worker |
| workers.media_repository.paths[0] | path | `"/_matrix/media/"` | Server-Side(externe) Pfade für die Ingress-Konfiguration des Media-Workers |
| workers.media_repository.securityContext | map | `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2666}` | Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers Überschreibt die Konfiguration von Default und generischen Worker |
| workers.pusher.enabled | bool | `false` | Dieser Worker kümmert sich um die Übermittlung von Benachrichtigungen. Hinweis: Es kann jeweils nur eine Instanz dieses Workers ausgeführt werden WICHTIGER HINWEIS: Dafür gibt es den Sygnal-Service und Pod!!! |
| workers.synchrotron.csPaths[0] | path | `"/_matrix/client/(v2_alpha\|r0\|v3)/sync"` | Client-Side(cs) Pfade für die Ingress-Konfiguration des Synchworkers |
| workers.synchrotron.csPaths[1] | string | `"/_matrix/client/(api/v1\|v2_alpha\|r0\|v3)/events"` |  |
| workers.synchrotron.csPaths[2] | string | `"/_matrix/client/(api/v1\|r0\|v3)/initialSync"` |  |
| workers.synchrotron.csPaths[3] | string | `"/_matrix/client/(api/v1\|r0\|v3)/rooms/[^/]+/initialSync"` |  |
| workers.synchrotron.enabled | bool | `false` | Aktivierung des Synch-Workers |
| workers.synchrotron.generic | bool | `true` | Wird aus dem generischen Worker abgeleitet |
| workers.synchrotron.listeners | list | `["client"]` | Zusätzliche Listener für Synchworker |
| workers.user_dir.csPaths[0] | path | `"/_matrix/client/(api/v1\|r0\|v3\|unstable)/user_directory/search"` | Client-Side(cs) Pfade für die Ingress-Konfiguration des Nutzersuch-Workers |
| workers.user_dir.enabled | bool | `true` | Aktivieren des Nutzersuch-Workers Hinweis: Damit kann die Last vom generischen bzw. Haupt-Worker genommen werden |
| workers.user_dir.listeners | list | `["client"]` | Zusätzliche Listener für NutzerSuch-Worker |
