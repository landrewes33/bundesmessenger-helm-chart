# bundesmessenger

![Version: 0.9.1](https://img.shields.io/badge/Version-0.9.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.61.1](https://img.shields.io/badge/AppVersion-1.61.1-informational?style=flat-square)

BWI Matrix BundesMessenger

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Christian Steinke | <christian.steinke@bwi.de> |  |
| Alexander Olofsson | <ace@haxalot.com> |  |

## Bundesmessenger Standard-Values

### Synapse
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|
| config.enableRegistration | bool | true | Registrierungskonfiguration, beachten Sie, dass die Registrierung mit dem containerinternen Werkzeug register_new_matrix_user immer möglich ist. |
| config.extraListeners | list | `[]` | Extra listener  |
| config.logLevel | string | `"INFO"` | Das Loglevel  für Synapse und alle Module. |
| config.macaroonSecretKey | string | `""` | Hinweis: Es wird dringend empfohlen, diesen Wert auf einen secure value (secret) zu setzen. |
| config.publicBaseurl | string | `""` | Die öffentlich zugängliche URL für die Synapse-Instanz  lautet standardmäßig  `https://<publicServerName>` Beispiel:  publicBaseurl: 'https://matrix.beispiel.org' |
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
| signingkey.job.publishImage | map | <details><summary>Klicken zum einsehen</summary> `{"pullPolicy":"IfNotPresent","repository":"bitnami/kubectl","tag":"1.21.13-debian-11-r4"}` </details> | Repository/Image Konfiguration für den Upload des generierten Signing-Schlüssels.  aktuelle Version am 13.06.2022 vom kubectl im bitnami-Repo |
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
| synapse.securityContext | map | <details><summary>Klicken zum einsehen</summary> `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2666}`</details>  | Konfiguration für die Container-Sicherheitsrichtlinie, siehe oben podSecurityContext für weitere relevante Informationen. |
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
| workers.frontend_proxy.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfade für die Ingress-Konfiguration des FrontendProxy-Workers Hinweis: (default Bundesmessenger) Wenn Sie extraConfig.use_presence=false setzen, sollten Sie den folgenden Pfad eintragen: - "/_matrix/client/(api/v1|r0|v3|unstable)/presence/[^/]+/status" |
| workers.frontend_proxy.enabled | bool | `false` | Aktivierung des FrontendProxy-Worker Dieser Worker kümmert sich um das Hochladen von Schlüsseln,  und kann auch die Anwesenheit ausblenden, wenn diese deaktiviert ist |
| workers.frontend_proxy.listeners | list | `["client"]` | Zusätzliche Listener für frontendproxy-Worker |
| workers.generic_worker.autoscaling.enabled | bool | `true` | schalte das HPA für die Pods ein |
| workers.generic_worker.autoscaling.maxReplicas | int | `10` | maximale Anzahl der Worker-Pods |
| workers.generic_worker.autoscaling.minReplicas | int | `2` | minimale Anzahl der Worker-Pods |
| workers.generic_worker.autoscaling.targetCPUUtilizationPercentage | int | `80` | Prozentsatz für CPU-Auslastung um Scaling zu triggern |
| workers.generic_worker.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Prozentsatz für RAM-Auslastung um Scaling zu triggern |
| workers.generic_worker.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfad für die Ingress-Konfiguration des Workers auskommentiert: - "/_matrix/client/(v2_alpha|r0|v3)/sync" - "/_matrix/client/(api/v1|r0|v3)/initialSync" - "/_matrix/client/(api/v1|r0|v3)/rooms/[^/]+/initialSync" |
| workers.generic_worker.enabled | bool | `true` | Aktivieren von Workern |
| workers.generic_worker.enabled | bool | `false` | Aktiviere spez. Worker für Förderationsanfragen |
| workers.generic_worker.federation_reader | string | `nil` |  |
| workers.generic_worker.generic | bool | `true` | Aktivieren des generischen Workers (kann alle Aufgaben übernehmen) spezifische Aufgaben können spezifischen Workern übergeben werden z.B. Media Repo |
| workers.generic_worker.generic | bool | `true` | Wird aus dem generischen Worker abgeleitet |
| workers.generic_worker.listeners | list | `["federation"]` | Zusätzliche Listener für Förderationsworker |
| workers.generic_worker.listeners | list | `["client","federation"]` | entsprechende Endpunkte für den generischen Worker |
| workers.generic_worker.paths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Server-Side (externer Zugriff) Pfade für die Ingress-Konfiguration des Workers |
| workers.generic_worker.replicaCount | int | `2` | Anzahl der Worker-Pods |
| workers.generic_worker.securityContext | map | <details><summary>Klicken zum einsehen</summary> `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2003}`</details>  | Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers |
| workers.media_repository.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfade für die Ingress-Konfiguration des Media-Workers |
| workers.media_repository.enabled | bool | `true` | Aktivieren des Media-Worker Dieser Worker kümmert sich um die Bereitstellung und Speicherung von Medien. Hinweis: Die Ausführung mehrerer Instanzen führt zu Konflikten mit Hintergrundaufgaben. |
| workers.media_repository.listeners | list | `["media"]` | Zusätzliche Listener für Media-Worker |
| workers.media_repository.paths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Server-Side(externe) Pfade für die Ingress-Konfiguration des Media-Workers |
| workers.media_repository.securityContext | map | <details><summary>Klicken zum einsehen</summary> `{"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":2666}`</details>  | Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers Überschreibt die Konfiguration von Default und generischen Worker |
| workers.pusher.enabled | bool | `false` | Dieser Worker kümmert sich um die Übermittlung von Benachrichtigungen. Hinweis: Es kann jeweils nur eine Instanz dieses Workers ausgeführt werden WICHTIGER HINWEIS: Dafür gibt es den Sygnal-Service und Pod!!! |
| workers.synchrotron.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfade für die Ingress-Konfiguration des Synchworkers |
| workers.synchrotron.enabled | bool | `false` | Aktivierung des Synch-Workers |
| workers.synchrotron.generic | bool | `true` | Wird aus dem generischen Worker abgeleitet |
| workers.synchrotron.listeners | list | `["client"]` | Zusätzliche Listener für Synchworker |
| workers.user_dir.csPaths | path | werden in der value.yaml gesetzt und können dort eingesehen werden  | Client-Side(cs) Pfade für die Ingress-Konfiguration des Nutzersuch-Workers |
| workers.user_dir.enabled | bool | `true` | Aktivieren des Nutzersuch-Workers Hinweis: Damit kann die Last vom generischen bzw. Haupt-Worker genommen werden |
| workers.user_dir.listeners | list | `["client"]` | Zusätzliche Listener für NutzerSuch-Worker |

### Sygnal
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|
| sygnal.affinity | object | `{}` |  |
| sygnal.apns | object | `{}` |  |
| sygnal.enabled | bool | `true` |  |
| sygnal.image.pullPolicy | string | `"IfNotPresent"` |  |
| sygnal.image.repository | string | `"matrixdotorg/sygnal"` |  |
| sygnal.image.tag | string | `"v0.11.0"` |  |
| sygnal.ios_push_enabled | bool | `false` |  |
| sygnal.ioskey | object | `{}` |  |
| sygnal.nodeSelector | object | `{}` |  |
| sygnal.podSecurityContext.sysctls[0].name | string | `"net.ipv4.ip_unprivileged_port_start"` |  |
| sygnal.podSecurityContext.sysctls[0].value | string | `"80"` |  |
| sygnal.resources.limits.cpu | string | `"150m"` |  |
| sygnal.resources.limits.memory | string | `"45Mi"` |  |
| sygnal.resources.requests.cpu | string | `"150m"` |  |
| sygnal.resources.requests.memory | string | `"45Mi"` |  |
| sygnal.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| sygnal.securityContext.runAsNonRoot | bool | `true` |  |
| sygnal.securityContext.runAsUser | int | `2111` |  |
| sygnal.tolerations | list | `[]` |  |

### Schadcodescanner
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|
| schadcodescanner.enabled | bool | `false` |  |
| schadcodescanner.image.pullPolicy | string | `"IfNotPresent"` |  |
| schadcodescanner.image.repository | string | `"clamav/clamav"` |  |
| schadcodescanner.image.tag | string | `"stable"` |  |
| schadcodescanner.resources.limits.cpu | string | `"400m"` |  |
| schadcodescanner.resources.limits.memory | string | `"3Gi"` |  |
| schadcodescanner.resources.requests.cpu | string | `"150m"` |  |
| schadcodescanner.resources.requests.memory | string | `"400Mi"` |  |
| schadcodescanner.securityContext.runAsGroup | int | `1000` |  |
| schadcodescanner.securityContext.runAsNonRoot | bool | `true` |  |

### CoTurn
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|
| coturn.default_ns | string | `"default"` |  |
| coturn.enabled | bool | `false` |  |
| coturn.existingcoturn.enabled | bool | `true` |  |
| coturn.image.pullPolicy | string | `"IfNotPresent"` |  |
| coturn.image.repository | string | `"coturn/coturn"` |  |
| coturn.image.tag | string | `"docker/4.5.2-r12"` |  |
| coturn.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| coturn.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| coturn.securityContext.runAsGroup | int | `2011` |  |
| coturn.securityContext.runAsUser | int | `2011` |  |
| coturn.turnUris.realm | string | `"turn.beispiel.org"` |  |
| coturn.turnUris.tcp | int | `3478` |  |
| coturn.turnUris.udp | int | `3478` |  |

### WellKnown
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|
| wellknown.affinity | object | `{}` |  |
| wellknown.client."io.element.e2ee".outbound_keys_pre_sharing_mode | string | `"on_room_opening"` |  |
| wellknown.client."io.element.e2ee".secure_backup_required | bool | `true` |  |
| wellknown.client."io.element.e2ee".secure_backup_setup_methods[0] | string | `"passphrase"` |  |
| wellknown.client."m.homeserver".base_url | string | `"https://matrix.beispiel.org"` |  |
| wellknown.enabled | bool | `false` |  |
| wellknown.htdocsPath | string | `"/var/www/localhost/htdocs"` |  |
| wellknown.image.pullPolicy | string | `"IfNotPresent"` |  |
| wellknown.image.repository | string | `"sebp/lighttpd"` |  |
| wellknown.image.tag | string | `"1.4.61-r1"` |  |
| wellknown.nodeSelector | object | `{}` |  |
| wellknown.podSecurityContext.runAsNonRoot | bool | `true` |  |
| wellknown.resources.limits.cpu | string | `"5m"` |  |
| wellknown.resources.limits.memory | string | `"15Mi"` |  |
| wellknown.resources.requests.cpu | string | `"5m"` |  |
| wellknown.resources.requests.memory | string | `"15Mi"` |  |
| wellknown.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| wellknown.securityContext.runAsNonRoot | bool | `true` |  |
| wellknown.securityContext.runAsUser | int | `2022` |  |
| wellknown.server."m.server" | string | `"matrix.beispiel.org:443"` |  |
| wellknown.tolerations | list | `[]` |  |
| wellknown.useIpv6 | bool | `false` | 
### Element
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|

### Redis
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|
| externalRedis.port | int | `6379` |  |
| redis.architecture | string | `"standalone"` |  |
| redis.auth.enabled | bool | `true` |  |
| redis.auth.password | string | `"synapse"` |  |
| redis.enabled | bool | `true` |  |
| redis.master.persistence.enabled | bool | `false` |  |
| redis.master.service.port | int | `6379` |  |
| redis.master.statefulset.updateStrategy | string | `"RollingUpdate"` |  |

### PostgreSQL
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|
| externalPostgresql.database | string | `"synapse_db"` |  |
| externalPostgresql.existingSecret | string | `"postgres-secrets"` |  |
| externalPostgresql.existingSecretPasswordKey | string | `"POSTGRES_PASSWORD"` |  |
| externalPostgresql.extraArgs | object | `{}` |  |
| externalPostgresql.host | string | `"postgres-4-matrix-postgresql.postgres.svc.cluster.local"` |  |
| externalPostgresql.password | string | `"synapse"` |  |
| externalPostgresql.port | int | `5432` |  |
| externalPostgresql.username | string | `"synapse"` |  |
| postgresql.enabled | bool | `false` |  |
### Synapse-Admin
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|
| synapse_admin.adminUri | string | `nil` |  |
| synapse_admin.enabled | bool | `true` |  |
| synapse_admin.image.pullPolicy | string | `"IfNotPresent"` |  |
| synapse_admin.image.repository | string | `"awesometechnologies/synapse-admin"` |  |
| synapse_admin.image.tag | string | `"0.8.5"` |  |
| synapse_admin.livenessProbe.httpGet.path | string | `"/"` |  |
| synapse_admin.livenessProbe.httpGet.port | int | `80` |  |
| synapse_admin.podSecurityContext.sysctls[0].name | string | `"net.ipv4.ip_unprivileged_port_start"` |  |
| synapse_admin.podSecurityContext.sysctls[0].value | string | `"80"` |  |
| synapse_admin.readinessProbe.httpGet.path | string | `"/"` |  |
| synapse_admin.readinessProbe.httpGet.port | int | `80` |  |
| synapse_admin.resources.limits.cpu | string | `"5m"` |  |
| synapse_admin.resources.limits.memory | string | `"15Mi"` |  |
| synapse_admin.resources.requests.cpu | string | `"5m"` |  |
| synapse_admin.resources.requests.memory | string | `"15Mi"` |  |

### Nginx-Ingress
| Schlüssel | Typ | Default | Beschreibung |
|-----------|-----|---------|--------------|
| ingress.annotations."nginx.ingress.kubernetes.io/proxy-body-size" | string | `"50m"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/use-regex" | string | `"true"` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.csHosts | list | `[]` |  |
| ingress.csPaths | list | `[]` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts | list | `[]` |  |
| ingress.includeServerName | bool | `true` |  |
| ingress.includeUnderscoreSynapse | bool | `true` |  |
| ingress.paths | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| ingress.traefikPaths | bool | `false` |  |
| ingress.wkHosts | list | `[]` |  |
