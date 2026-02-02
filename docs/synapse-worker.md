# Unterschiedliche Worker-Typen des Synapse

Für kleine Instanzen wird empfohlen, Synapse im standardmäßigen Monolithmodus auszuführen.
Für größere Instanzen, bei denen die Leistung eine Rolle spielt, kann es hilfreich
sein, die Funktionalität auf mehrere separate Python-Prozesse aufzuteilen.
Diese Prozesse werden „Worker“ genannt und können teilweise horizontal
unabhängig skaliert werden.

Alle Prozesse teilen sich weiterhin dieselbe Datenbankinstanz.

Bei der Verwendung von Workern hat jeder Worker-Prozess seine eigene Konfigurationsdatei,
die spezifische Einstellungen für diesen Worker enthält,
wie z. B. den von ihm bereitgestellten HTTP-Listener (falls vorhanden),
die Protokollierungskonfiguration und Monitoringkonfiguration usw.

Die Worker-Pods sind so konfiguriert, dass sie sowohl aus einer gemeinsamen Konfigurationsdatei
als auch aus den workerspezifischen Konfigurationsdateien lesen.

Diese Konfigurationen werden im Zuge des Deplyoments erzeugt, auf den Pod(s) eingehangen
und mit dem Python-Prozess ausgeführt.

## Workertypen

Es gibt eine Anzahl an vordefinierten Workertypen:

- [generic worker](https://element-hq.github.io/synapse/latest/workers.html#available-worker-applications)
- [background worker](https://element-hq.github.io/synapse/latest/workers.html?highlight=worker#background-tasks)
- [user dir](https://element-hq.github.io/synapse/latest/workers.html?highlight=worker#updating-the-user-directory)
- [notify service](https://element-hq.github.io/synapse/latest/workers.html?highlight=worker#notifying-application-services)
- [push notification](https://element-hq.github.io/synapse/latest/workers.html?highlight=worker#push-notifications)
- [pusher](https://element-hq.github.io/synapse/latest/workers.html?highlight=worker#synapseapppusher)
- [appservice](https://element-hq.github.io/synapse/latest/workers.html?highlight=worker#synapseappappservice)
- [federation sender](https://element-hq.github.io/synapse/latest/workers.html?highlight=worker#restrict-outbound-federation-traffic-to-a-specific-set-of-workers)
  & [Dokumentation Teil 2](https://element-hq.github.io/synapse/latest/workers.html?highlight=worker#synapseappfederation_sender)
- [media repository](https://element-hq.github.io/synapse/latest/workers.html?highlight=worker#synapseappmedia_repository)

Früher besaßen einige Worker separate Anwendungstypen. Sie entsprechen jetzt
aber alle `synapse.app.generic_worker`:

- `synapse.app.appservice`
- `synapse.app.client_reader`
- `synapse.app.event_creator`
- `synapse.app.federation_reader`
- `synapse.app.federation_sender`
- `synapse.app.frontend_proxy`
- `synapse.app.media_repository`
- `synapse.app.pusher`
- `synapse.app.synchrotron`
- `synapse.app.user_dir`

## Worker des BundesMessengers

Im Rahmen des Deployments sind die folgenden Worker-Typen bei uns vordefiniert:

- `default` (kein eigener Worker, stellt die Standardwerte für die übrigen Worker)
- `generic_worker` (das Arbeitstier der Synapse-Worker)
- `federation_reader`
- `pusher`
- `appservice`
- `federation_sender`
- `media_repository`
- `user_dir`
- `background_worker`

## Selbsterstellter Worker

Falls ein Worker für spezifische Aufgaben selbst erstellt werden soll,
(folgend Customworker genannt) müssen folgende Punkte in der
Konfiguration berücksichtigt werden.

### YAML-Anchor

Wir empfehlen im Rahmen der Angaben des Workers zuvor ein Defaultworker für
Standardwerte anzulegen oder diese Standardwerte dem Customworker mit zu übergeben.

Die Angaben entsprechen unseren Defaultangaben ohne die Dokumentation
innerhalb der values.yaml:

```yaml:
workers:
  default: &workerDefault
    enabled: false
    replicaCount: 1
    strategy:
      type: RollingUpdate
    extraConfig: {}
    annotations: {}
    extraEnv: []
    volumes: []
    volumeMounts: []
    extraCommands: []
    podSecurityContext:
      runAsNonRoot: true
      seccompProfile:
        type: RuntimeDefault
      fsGroup: 2666
      runAsGroup: 2666
      runAsUser: 2666
    securityContext:
      capabilities:
        drop:
          - ALL
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      runAsUser: 2666
    resources:
      limits:
        cpu: 600m
        memory: 768Mi
      requests:
        cpu: 100m
        memory: 150Mi
    livenessProbe:
      periodSeconds: 10
      httpGet:
        path: /health
        port: health
    readinessProbe:
      periodSeconds: 3
      httpGet:
        path: /health
        port: health
    startupProbe:
      failureThreshold: 6
      httpGet:
        path: /health
        port: health
    nodeSelector: {}
    tolerations: []
    affinity: {}
    listeners: []
    csPaths: []
    paths: []
    autoscaling:
      enabled: false      
      minReplicas: 2
      maxReplicas: 10
      targetCPUUtilizationPercentage: 80
      targetMemoryUtilizationPercentage: 80
```

Wir haben in unserem Beispiel die `YAML-Anchor` Version genutzt,
um zu demonstrieren wie wir auch in unserem `values.yaml` Werte referenzieren.

Dann kann direkt auch der Customworker definiert werden:

```yaml:
  customWorker:
    <<: *workerDefault
    enabled: true
```

### Direkte Konfiguration

Alternativ können die Standardwerte auch direkt mit angegeben werden.
Dies wirkt im ersten Moment etwas viel für einen Worker.
Da dieser nicht standardisiert ist, benötigt er alle minimalen
Angaben um der Definition als Worker zu bestehen.

```yaml:
  customWorker:
    enabled: true
    replicaCount: 1
    strategy:
      type: RollingUpdate
    extraConfig: {}
    annotations: {}
    extraEnv: []
    volumes: []
    volumeMounts: []
    extraCommands: []
    podSecurityContext:
      runAsNonRoot: true
      seccompProfile:
        type: RuntimeDefault
      fsGroup: 2666
      runAsGroup: 2666
      runAsUser: 2666
    securityContext:
      capabilities:
        drop:
          - ALL
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      runAsUser: 2666
    resources:
      limits:
        cpu: 600m
        memory: 768Mi
      requests:
        cpu: 100m
        memory: 150Mi
    livenessProbe:
      periodSeconds: 10
      httpGet:
        path: /health
        port: health
    readinessProbe:
      periodSeconds: 3
      httpGet:
        path: /health
        port: health
    startupProbe:
      failureThreshold: 6
      httpGet:
        path: /health
        port: health
    nodeSelector: {}
    tolerations: []
    affinity: {}
    listeners: []
    csPaths: []
    paths: []
    autoscaling:
      enabled: false      
      minReplicas: 2
      maxReplicas: 10
      targetCPUUtilizationPercentage: 80
      targetMemoryUtilizationPercentage: 80
```
