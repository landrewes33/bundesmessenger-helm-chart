# bundesmessenger

![Version: 1.3.1](https://img.shields.io/badge/Version-1.3.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.78.0](https://img.shields.io/badge/AppVersion-1.78.0-informational?style=flat-square)

BWI Matrix BundesMessenger

**Homepage:** <https://gitlab.opencode.de/bwi/bundesmessenger/backend/helm-chart/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| BWI GmbH | <bundesmessenger@bwi.de> | <https://messenger.bwi.de/> |
| Christian Steinke | <christian.steinke@bwi.de> |  |
| Dirk Klimpel | <dirk.klimpel@bwi.de> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | postgresql | ^12.8.0 |
| oci://registry-1.docker.io/bitnamicharts | redis | ^17.14.6 |

## Bundesmessenger Standard-Values


### Konfiguration für Synapse

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="image--repository">
        <div style="max-width: 150px;"><a href="../values.yaml#L8">image.repository</a></div>
      </td>
      <td>string</td>
      <td>Repository/Image Konfiguration, für Synapse und Workernodes. ursprünglich: "repository: matrixdotorg/synapse"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"registry.opencode.de/bwi/bundesmessenger/backend/container-images/synapse"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="image--pullSecrets">
        <div style="max-width: 150px;"><a href="../values.yaml#L21">image.pullSecrets</a></div>
      </td>
      <td>list</td>
      <td>Optional kann ein Array von imagePullSecrets angegeben werden. Secrets müssen manuell im Namensraum angelegt werden. ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ Beispiel: pullSecrets:   - name: myRegistryKeySecretName</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
nicht gesetzt
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="image--pullPolicy">
        <div style="max-width: 150px;"><a href="../values.yaml#L25">image.pullPolicy</a></div>
      </td>
      <td>string</td>
      <td>Pullpolicy für das konfigurierte Image imagePullPolicy „Always“, wenn tag ist „latest“ (imagepullpolicy-always.yaml)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"IfNotPresent"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="nameOverride">
        <div style="max-width: 150px;"><a href="../values.yaml#L28">nameOverride</a></div>
      </td>
      <td>string</td>
      <td>Überschreibt einen Teil des installierten Namens, behält aber den Releasenamen bei.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="fullnameOverride">
        <div style="max-width: 150px;"><a href="../values.yaml#L31">fullnameOverride</a></div>
      </td>
      <td>string</td>
      <td>Überschreiben Sie den vollständigen Namen des installierten Charts.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="serverName">
        <div style="max-width: 150px;"><a href="../values.yaml#L36">serverName</a></div>
      </td>
      <td>string</td>
      <td>Der Matrix-Domänenname, der für den Domänenteil in Ihren MXIDs verwendet wird.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
Nicht gesetzt, aber Voraussetzung!
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="publicServerName">
        <div style="max-width: 150px;"><a href="../values.yaml#L41">publicServerName</a></div>
      </td>
      <td>string</td>
      <td>Der öffentliche Matrix-Servername, der für alle öffentlichen URLs in der Konfiguration sowie für Client-API-Links im Ingress verwendet wird.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
Nicht gesetzt
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="dataPrivacyUrl">
        <div style="max-width: 150px;"><a href="../values.yaml#L48">dataPrivacyUrl</a></div>
      </td>
      <td>string</td>
      <td>Eine URL (ohne "https://") unter der der Nutzer sich Datenschutzbestimmungen einsehen kann. Diese Datenschutzbestimmungen muss jeder Anbieter selbst dem Nutzer zur Verfügung stellen. Die Mobil-Apps nutzen dies, um die Datenschutzbestimmungen per Webaufruf dem Nutzer anzeigen zu lassen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
Nicht gesetzt, aber Voraussetzung!
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="imprintUrl">
        <div style="max-width: 150px;"><a href="../values.yaml#L54">imprintUrl</a></div>
      </td>
      <td>string</td>
      <td>Eine URL (ohne "https://") unter der der Nutzer das Impressum einsehen kann. Dieses Impressum muss jeder Anbieter selbst dem Nutzer zur Verfügung stellen. Die Mobil-Apps nutzen dies, um das Impressum dem Nutzer anzeigen zu lassen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
Nicht gesetzt, aber Voraussetzung!
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="adminAPIServerName">
        <div style="max-width: 150px;"><a href="../values.yaml#L62">adminAPIServerName</a></div>
      </td>
      <td>string</td>
      <td>Der Servername für die Admin-API  "/_synapse/admin" und alle anderen APIs, die für alle administrativen Konfigurationen im Ingress verwendet werden. Wenn synapse_admin.enable ist und synapse_admin.uri unterschiedlich von adminAPIServerName, dann wird dort nur der Synapse_admin erreichbar sein. Schnittstellen zum konfigurieren, werden nur über adminAPIServerName zur Verfügung gestellt.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
Nicht gesetzt, aber Voraussetzung!
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="monitoring--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L71">monitoring.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des Monitorings für Synapse-Dienste in Prometheus</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="monitoring--labels">
        <div style="max-width: 150px;"><a href="../values.yaml#L75">monitoring.labels</a></div>
      </td>
      <td>map</td>
      <td>Labels, die Prometheus Operator als matchLabels benutzt (podMonitorSelector, ruleSelector) um den PodMonitor und die PrometheusRule zu aktivieren. `kubectl get Prometheus --all-namespaces -o jsonpath='{.items[*].spec.podMonitorSelector.matchLabels}'`</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="displayName">
        <div style="max-width: 150px;"><a href="../values.yaml#L79">displayName</a></div>
      </td>
      <td>string</td>
      <td>Anzeigename des Servers in Webclients</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
Messenger deiner Organisation
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--job--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L97">signingkey.job.enabled</a></div>
      </td>
      <td>bool</td>
      <td>es wird ein Job zu Beginn des Deployments gestartet, der einen Signierschlüssel erzeugt. Wenn abgeschaltet, muss ein vorhandener Schlüssel eingebunden werden, ansonsten ist eine Föderation als nicht vertrauenswürdig eingestuft</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--job--generateImage--repository">
        <div style="max-width: 150px;"><a href="../values.yaml#L104">signingkey.job.generateImage.repository</a></div>
      </td>
      <td>string</td>
      <td>Repository/Image Konfiguration für Synapse-signing-key-job. Es wird dringend empfohlen, dass die gleiche Konfiguration wie vom Synapse bzw. den Workernodes genutzt wird. ursprünglich: "repository: matrixdotorg/synapse" bei Nichtsetzen vom Tag, wird das Tag aus dem Chart.yaml übernommen (empfohlen)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"registry.opencode.de/bwi/bundesmessenger/backend/container-images/synapse"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--job--generateImage--pullSecrets">
        <div style="max-width: 150px;"><a href="../values.yaml#L108">signingkey.job.generateImage.pullSecrets</a></div>
      </td>
      <td>string</td>
      <td>Tag zum überschreiben, standardmäßig wird die Anwendungsversion (Chart.yaml) verwendet tag: ""</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
wird im Chart.yaml gesetzt
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--job--generateImage--pullPolicy">
        <div style="max-width: 150px;"><a href="../values.yaml#L111">signingkey.job.generateImage.pullPolicy</a></div>
      </td>
      <td>string</td>
      <td>PullPolicy für das Image vom Signing-Key-Job</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"IfNotPresent"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--job--publishImage">
        <div style="max-width: 150px;"><a href="../values.yaml#L114">signingkey.job.publishImage</a></div>
      </td>
      <td>map</td>
      <td>Repository/Image Konfiguration für den Upload des generierten Signing-Schlüssels. finaler Tag kann sich noch ändern</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/kubectl",
  "tag": "1.28.1-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L126">signingkey.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"100m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L127">signingkey.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"250Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L129">signingkey.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"100m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L130">signingkey.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"250Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ipv4Only">
        <div style="max-width: 150px;"><a href="../values.yaml#L138">ipv4Only</a></div>
      </td>
      <td>bool</td>
      <td>Schaltet alle internen IP-Adressevergaben auf IPv4-only Wenn `true` sind alle Listener und Anbindungspunkte `0.0.0.0`, wenn `false` sind einige Listener bzw. Anbindungspunkte `::` (IPv6) Derzeit wird nur reine IPv4 (https://github.com/matrix-org/synapse/issues/13107) oder Dual-Stack Umgebungen unterstützt, keine reine IPv6 Umgebung.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--logLevel">
        <div style="max-width: 150px;"><a href="../values.yaml#L154">config.logLevel</a></div>
      </td>
      <td>string</td>
      <td>Das Loglevel für Synapse und alle `loggers` Module. Mit Ausnahme von `synapse.storage.SQL`, welches aus Sicherheitsgründen zusätzlich geändert werden muss. Dokumentation: https://matrix-org.github.io/synapse/latest/structured_logging.html</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"INFO"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--useStructuredLogging">
        <div style="max-width: 150px;"><a href="../values.yaml#L159">config.useStructuredLogging</a></div>
      </td>
      <td>bool</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--extraLoggers">
        <div style="max-width: 150px;"><a href="../values.yaml#L165">config.extraLoggers</a></div>
      </td>
      <td>object</td>
      <td>Geben Sie hier zusätzliche Logger-Konfigurationen an. Achtung: Wenn `synapse.storage.SQL`auf `level: DEBUG` erhöht wird, werden alle SQL-Abfragen protokolliert. Diese enthalten sensible Informationen wie z.B. Zugriffstoken. Ref: https://matrix-org.github.io/synapse/latest/structured_logging.html</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "synapse.storage.SQL": {
    "level": "WARNING"
  }
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--reportStats">
        <div style="max-width: 150px;"><a href="../values.yaml#L170">config.reportStats</a></div>
      </td>
      <td>bool</td>
      <td>Erfassung Nutzungsstatistiken (Hostname, Synapse-Version und -Uptime, total_users usw.) an die Entwickler melden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--enable_metrics">
        <div style="max-width: 150px;"><a href="../values.yaml#L173">config.enable_metrics</a></div>
      </td>
      <td>bool</td>
      <td>Metriken erfassen, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--turnUris">
        <div style="max-width: 150px;"><a href="../values.yaml#L184">config.turnUris</a></div>
      </td>
      <td>list</td>
      <td>URIs die zum Aufbau von 1:1 WebRTC Anrufe aufzubauen. Beispiel: turnUris: ["turn:turn.example.com:3478?transport=udp"]</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--enableRegistration">
        <div style="max-width: 150px;"><a href="../values.yaml#L191">config.enableRegistration</a></div>
      </td>
      <td>bool</td>
      <td>Registrierungskonfiguration, beachten Sie, dass die Registrierung mit dem containerinternen Werkzeug register_new_matrix_user immer möglich ist. Synapse-Admin kann dafür genutzt werden.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--registrationSharedSecret">
        <div style="max-width: 150px;"><a href="../values.yaml#L194">config.registrationSharedSecret</a></div>
      </td>
      <td>string</td>
      <td>Hinweis: Dieser Wert wird standardmäßig auf eine zufällige Zeichenfolge gesetzt, wenn er nicht angegeben wird.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--macaroonSecretKey">
        <div style="max-width: 150px;"><a href="../values.yaml#L197">config.macaroonSecretKey</a></div>
      </td>
      <td>string</td>
      <td>Hinweis: Es wird dringend empfohlen, diesen Wert auf einen secure value (secret) zu setzen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--trustedKeyServers">
        <div style="max-width: 150px;"><a href="../values.yaml#L201">config.trustedKeyServers</a></div>
      </td>
      <td>map</td>
      <td>Eine Gruppe von vertrauenswürdigen Servern, die zu kontaktieren sind, wenn ein anderer Server nicht auf eine Signierschlüssel-Anfrage antwortet.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[
  {
    "server_name": "matrix.org"
  }
]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--extraListeners">
        <div style="max-width: 150px;"><a href="../values.yaml#L207">config.extraListeners</a></div>
      </td>
      <td>list</td>
      <td>Extra listener</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig">
        <div style="max-width: 150px;"><a href="../values.yaml#L215">extraConfig</a></div>
      </td>
      <td>object</td>
      <td>Beliebige weitere Synapse-Konfiguration Vorkonfiguriert nach Best Practise BWI GmbH: Ref: https://matrix-org.github.io/synapse/latest/usage/configuration/config_documentation.html</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "allow_guest_access": false,
  "allow_public_rooms_over_federation": false,
  "allow_public_rooms_without_auth": false,
  "block_non_admin_invites": false,
  "dynamic_thumbnails": true,
  "enable_3pid_lookup": false,
  "enable_room_list_search": true,
  "enable_search": true,
  "encryption_enabled_by_default_for_room_type": "all",
  "federation_domain_whitelist": [],
  "include_profile_data_on_invite": true,
  "ip_range_whitelist": [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ],
  "limit_profile_requests_to_users_who_share_rooms": false,
  "max_avatar_size": "5M",
  "max_upload_size": "50M",
  "media_retention": {
    "remote_media_lifetime": "90d"
  },
  "oembed": {
    "disable_default_providers": true
  },
  "opentracing": {
    "enabled": false
  },
  "password_config": {
    "enabled": true,
    "localdb_enabled": true,
    "policy": {
      "enabled": true,
      "minimum_length": 8,
      "require_digit": true,
      "require_lowercase": true,
      "require_symbol": true,
      "require_uppercase": true
    }
  },
  "presence": {
    "enabled": false
  },
  "push": {
    "include_content": false
  },
  "require_auth_for_profile_requests": true,
  "require_membership_for_aliases": true,
  "retention": {
    "enabled": false
  },
  "stats": {
    "enabled": true
  },
  "ui_auth": {
    "session_timeout": "15s"
  },
  "url_preview_enabled": false,
  "user_directory": {
    "enabled": true,
    "search_all_users": true
  },
  "user_ips_max_age": "28d"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--max_upload_size">
        <div style="max-width: 150px;"><a href="../values.yaml#L221">extraConfig.max_upload_size</a></div>
      </td>
      <td>string</td>
      <td>Maximale Dateigröße für Uploads von Medien. Zu beachten ist, dass dies auch vom Reverse Proxy erlaubt werden muss, siehe: "ingress.annotations: nginx.ingress.kubernetes.io/proxy-body-size"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"50M"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--max_avatar_size">
        <div style="max-width: 150px;"><a href="../values.yaml#L223">extraConfig.max_avatar_size</a></div>
      </td>
      <td>string</td>
      <td>Die maximale zulässige Dateigröße für ein Benutzer-Profilbild.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"5M"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--media_retention">
        <div style="max-width: 150px;"><a href="../values.yaml#L226">extraConfig.media_retention</a></div>
      </td>
      <td>object</td>
      <td>Angabe wann Medien von Repository gelöscht werden. Für die Zeitdauer gilt das Datum des letzten Zugriffs / Downloads.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "remote_media_lifetime": "90d"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--media_retention--remote_media_lifetime">
        <div style="max-width: 150px;"><a href="../values.yaml#L232">extraConfig.media_retention.remote_media_lifetime</a></div>
      </td>
      <td>string</td>
      <td>Zeitdauer wie lange Medien von fremden Servern im Cache vorgehalten werden. Bei Bedarf werden diese vom remote Server erneut heruntergeladen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"90d"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--require_auth_for_profile_requests">
        <div style="max-width: 150px;"><a href="../values.yaml#L234">extraConfig.require_auth_for_profile_requests</a></div>
      </td>
      <td>bool</td>
      <td>Authentifizierung notwendig für User-Suche</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--limit_profile_requests_to_users_who_share_rooms">
        <div style="max-width: 150px;"><a href="../values.yaml#L236">extraConfig.limit_profile_requests_to_users_who_share_rooms</a></div>
      </td>
      <td>bool</td>
      <td>Limitiere Requests für Nutzer mit shared rooms, abgeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--include_profile_data_on_invite">
        <div style="max-width: 150px;"><a href="../values.yaml#L238">extraConfig.include_profile_data_on_invite</a></div>
      </td>
      <td>bool</td>
      <td>Übersenden von Profildaten, wenn Chat gestartet wird</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--allow_public_rooms_without_auth">
        <div style="max-width: 150px;"><a href="../values.yaml#L240">extraConfig.allow_public_rooms_without_auth</a></div>
      </td>
      <td>bool</td>
      <td>Öffentliche Räume ohne Login/Authentifizierung, abgeschaltet!</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--allow_public_rooms_over_federation">
        <div style="max-width: 150px;"><a href="../values.yaml#L242">extraConfig.allow_public_rooms_over_federation</a></div>
      </td>
      <td>bool</td>
      <td>öffentliche Räume über Föderation erlauben, abgeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--block_non_admin_invites">
        <div style="max-width: 150px;"><a href="../values.yaml#L244">extraConfig.block_non_admin_invites</a></div>
      </td>
      <td>bool</td>
      <td>Einladung die von unpriviligierten Nutzern stammen blocken, abgeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--ip_range_whitelist">
        <div style="max-width: 150px;"><a href="../values.yaml#L246">extraConfig.ip_range_whitelist</a></div>
      </td>
      <td>list</td>
      <td>IP-Whitelist für Föderation und Push-Services zwingend benötigt</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[
  "10.0.0.0/8",
  "172.16.0.0/12",
  "192.168.0.0/16"
]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--presence--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L249">extraConfig.presence.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Anwesenheitsstatus anzeigen, abgeschaltet (Load)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--enable_search">
        <div style="max-width: 150px;"><a href="../values.yaml#L251">extraConfig.enable_search</a></div>
      </td>
      <td>bool</td>
      <td>Nutzersuche zulassen, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--user_directory--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L254">extraConfig.user_directory.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Nutzerverzeichnis erstellen, eingeschaltet (Voraussetzung für Nutzersuche)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--user_directory--search_all_users">
        <div style="max-width: 150px;"><a href="../values.yaml#L256">extraConfig.user_directory.search_all_users</a></div>
      </td>
      <td>bool</td>
      <td>Suche alle Nutzer, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--require_membership_for_aliases">
        <div style="max-width: 150px;"><a href="../values.yaml#L258">extraConfig.require_membership_for_aliases</a></div>
      </td>
      <td>bool</td>
      <td>Nur Raummitglieder können einen Alias für einen Raum konfigurieren.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--user_ips_max_age">
        <div style="max-width: 150px;"><a href="../values.yaml#L260">extraConfig.user_ips_max_age</a></div>
      </td>
      <td>string</td>
      <td>Maximale Speicherzeit für IPs von Nutzern</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"28d"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--forget_rooms_on_leave">
        <div style="max-width: 150px;"><a href="../values.yaml#L236">extraConfig.forget_rooms_on_leave</a></div>
      </td>
      <td>bool</td>
      <td>Benutzer vergessen Räume beim Verlassen automatisch. Nur wenn alle Nutzer einen Raum verlassen und vergessen haben, wird er automatisch vom Server gelöscht.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--retention--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L263">extraConfig.retention.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Nachrichtenaufbewahrungsrichtlinien einschalten (auf Raumebene)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--url_preview_enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L265">extraConfig.url_preview_enabled</a></div>
      </td>
      <td>bool</td>
      <td>URL-Vorschau, abgeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--oembed--disable_default_providers">
        <div style="max-width: 150px;"><a href="../values.yaml#L268">extraConfig.oembed.disable_default_providers</a></div>
      </td>
      <td>bool</td>
      <td>eingebettete URL-Darstellung von Drittanbietern</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--enable_3pid_lookup">
        <div style="max-width: 150px;"><a href="../values.yaml#L270">extraConfig.enable_3pid_lookup</a></div>
      </td>
      <td>bool</td>
      <td>thirdParty Identifier lookup (3pid), abgeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--allow_guest_access">
        <div style="max-width: 150px;"><a href="../values.yaml#L272">extraConfig.allow_guest_access</a></div>
      </td>
      <td>bool</td>
      <td>Gastzugang, abgeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config">
        <div style="max-width: 150px;"><a href="../values.yaml#L275">extraConfig.password_config</a></div>
      </td>
      <td>object</td>
      <td>Konfiguration für Login mit Passwort</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "enabled": true,
  "localdb_enabled": true,
  "policy": {
    "enabled": true,
    "minimum_length": 8,
    "require_digit": true,
    "require_lowercase": true,
    "require_symbol": true,
    "require_uppercase": true
  }
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L277">extraConfig.password_config.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Login mit Passwort erlauben, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--localdb_enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L279">extraConfig.password_config.localdb_enabled</a></div>
      </td>
      <td>bool</td>
      <td>lokale Nutzerdatenbank, eingeschaltet Wenn dies deaktiviert wird, müssen andere `password_providers` definiert werden.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--policy--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L282">extraConfig.password_config.policy.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Passwortpolicy nutzen, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--policy--minimum_length">
        <div style="max-width: 150px;"><a href="../values.yaml#L284">extraConfig.password_config.policy.minimum_length</a></div>
      </td>
      <td>int</td>
      <td>Passwortmindestlänge in Zeichen</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
8
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--policy--require_digit">
        <div style="max-width: 150px;"><a href="../values.yaml#L286">extraConfig.password_config.policy.require_digit</a></div>
      </td>
      <td>bool</td>
      <td>Zahl muss mit genutzt werden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--policy--require_symbol">
        <div style="max-width: 150px;"><a href="../values.yaml#L288">extraConfig.password_config.policy.require_symbol</a></div>
      </td>
      <td>bool</td>
      <td>Sonderzeichen muss genutzt werden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--policy--require_lowercase">
        <div style="max-width: 150px;"><a href="../values.yaml#L290">extraConfig.password_config.policy.require_lowercase</a></div>
      </td>
      <td>bool</td>
      <td>Kleinbuchstaben muss genutzt werden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--policy--require_uppercase">
        <div style="max-width: 150px;"><a href="../values.yaml#L292">extraConfig.password_config.policy.require_uppercase</a></div>
      </td>
      <td>bool</td>
      <td>Großbuchstaben muss genutzt werden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--ui_auth--session_timeout">
        <div style="max-width: 150px;"><a href="../values.yaml#L295">extraConfig.ui_auth.session_timeout</a></div>
      </td>
      <td>string</td>
      <td>User-Interactive Authentication API timeout</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"15s"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--push--include_content">
        <div style="max-width: 150px;"><a href="../values.yaml#L298">extraConfig.push.include_content</a></div>
      </td>
      <td>bool</td>
      <td>Push Modul verschickt Inhalt der Nachricht über Google-/Apple-Push-Services, abgeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--encryption_enabled_by_default_for_room_type">
        <div style="max-width: 150px;"><a href="../values.yaml#L300">extraConfig.encryption_enabled_by_default_for_room_type</a></div>
      </td>
      <td>string</td>
      <td>Verschlüsselung für neue Räume; default für alle Räume aktiviert</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"all"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--stats--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L306">extraConfig.stats.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Schalte Nutzer- und Raumstatistiken ein, eingeschaltet Beachten Sie, dass das Deaktivieren dazu führen kann, dass bestimmte Funktionen (z. B. das Raumverzeichnis) nicht korrekt funktionieren. Details: https://matrix-org.github.io/synapse/latest/room_and_user_statistics.html</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--enable_room_list_search">
        <div style="max-width: 150px;"><a href="../values.yaml#L308">extraConfig.enable_room_list_search</a></div>
      </td>
      <td>bool</td>
      <td>Raumsuche, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--opentracing--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L314">extraConfig.opentracing.enabled</a></div>
      </td>
      <td>bool</td>
      <td>OpenTracing ist ein Werkzeug, das einen Einblick in den kausalen Zusammenhang der Arbeit in und zwischen Servern gibt. Die einzelnen Server verfolgen Ereignisse und melden sie an einen zentralen Server - im Fall von Synapse: Jaeger.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--federation_domain_whitelist">
        <div style="max-width: 150px;"><a href="../values.yaml#L316">extraConfig.federation_domain_whitelist</a></div>
      </td>
      <td>list</td>
      <td>Whitelist (Matrix-Server-Namen) für Föderation</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--prevent_media_downloads_from">
        <div style="max-width: 150px;"><a href="../values.yaml#L293">extraConfig.prevent_media_downloads_from</a></div>
      </td>
      <td>list</td>
      <td>Eine Liste von Matrix-Servern, von denen die eigenen Benutzer keine Medien herunterladen dürfen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--dynamic_thumbnails">
        <div style="max-width: 150px;"><a href="../values.yaml#L321">extraConfig.dynamic_thumbnails</a></div>
      </td>
      <td>bool</td>
      <td>dynamisches Vorschaubild, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraSecrets">
        <div style="max-width: 150px;"><a href="../values.yaml#L329">extraSecrets</a></div>
      </td>
      <td>map</td>
      <td>Geben Sie hier eine beliebige - geheime - Synapse-Konfiguration an; Diese Werte werden in Secrets anstelle von Configmaps gespeichert Ref: https://matrix-org.github.io/synapse/latest/usage/configuration/config_documentation.html Beispiel:  password_config:    pepper: ""</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse">
        <div style="max-width: 150px;"><a href="../values.yaml#L333">synapse</a></div>
      </td>
      <td>object</td>
      <td>Konfiguration, die auf den Haupt-Synapse-Container anzuwenden ist.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
wird nachfolgend einzeln aufgeschlüsselt
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--strategy--type">
        <div style="max-width: 150px;"><a href="../values.yaml#L340">synapse.strategy.type</a></div>
      </td>
      <td>string</td>
      <td>Nur wirklich anwendbar, wenn das Deployment ein RWO PV angehängt hat (z.B. wenn Media Repository für den Haupt-Synapse-Container aktiviert ist) Da Replikate = 1 sind, kann eine Aktualisierung "hängen bleiben", da der vorherige Container mit dem PV verbunden bleibt und der "neu-aufgebaute" Container nie starten kann. Das Ändern der Strategie auf "Recreate" wird den einzelnen vorherigen Container beenden, so dass der neue, ankommende Container sich mit dem PV verbinden kann</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"RollingUpdate"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--annotations">
        <div style="max-width: 150px;"><a href="../values.yaml#L343">synapse.annotations</a></div>
      </td>
      <td>map</td>
      <td>Annotations, die auf den Haupt-Synapse-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--labels">
        <div style="max-width: 150px;"><a href="../values.yaml#L346">synapse.labels</a></div>
      </td>
      <td>map</td>
      <td>Labels, die auf den Haupt-Synapse-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--extraVolumes">
        <div style="max-width: 150px;"><a href="../values.yaml#L377">synapse.extraVolumes</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche in Synapse zu mountende Datenträger (Volumes) Beispiel:  - name: spamcheck    flexVolume:      driver: dvs/git-live      options:        repo: https://gitlab.opencode.de/bwi/bundesmessenger/synapse-module        interval: 1d      readOnly: true</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--extraVolumeMounts">
        <div style="max-width: 150px;"><a href="../values.yaml#L383">synapse.extraVolumeMounts</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche in Synapse zu mountende Datenträgerpfade (Volumes) Beispiel:  - name: spamcheck    mountPath: /usr/local/lib/python3.7/site-packages/company</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--extraCommands">
        <div style="max-width: 150px;"><a href="../values.yaml#L389">synapse.extraCommands</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Befehle, die beim Starten von Synapse ausgeführt werden Beispiele: - 'apt-get update -yqq && apt-get install patch -yqq' - 'patch -d/usr/local/lib/python3.7/site-packages/synapse -p2 < /synapse/patches/something.patch'</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L395">synapse.podSecurityContext</a></div>
      </td>
      <td>object</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie, Synapse wird immer als sein eigener Benutzer ausgeführt, auch wenn dies nicht eingestellt ist. Beachten Sie, dass eine Änderung dieser Einstellung auch die Verwendung der volumePermission Hilfsprogramm verwenden müssen, abhängig von Ihrem Speicher.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "fsGroup": 2666,
  "runAsGroup": 2666,
  "runAsNonRoot": true,
  "runAsUser": 2666
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L403">synapse.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie, siehe oben podSecurityContext für weitere relevante Informationen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsNonRoot": true,
  "runAsUser": 2666
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L425">synapse.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den Haupt-Synapse-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"1000m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L427">synapse.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den Haupt-Synapse-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"2000Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L430">synapse.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den Haupt-Synapse-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"500m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L432">synapse.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den Haupt-Synapse-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"1000Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--livenessProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L439">synapse.livenessProbe.httpGet.path</a></div>
      </td>
      <td>string</td>
      <td>Zu verwendende Konfiguration für den Pfad des Healthchecks</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"/health"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--livenessProbe--httpGet--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L441">synapse.livenessProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Zu verwendende Konfiguration für den Port des Healthchecks</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"metrics"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--readinessProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L448">synapse.readinessProbe.httpGet.path</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Pfads vom Bereitschaftscheck</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"/health"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--readinessProbe--httpGet--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L450">synapse.readinessProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Ports vom Bereitschaftscheck</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"metrics"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--startupProbe--failureThreshold">
        <div style="max-width: 150px;"><a href="../values.yaml#L455">synapse.startupProbe.failureThreshold</a></div>
      </td>
      <td>int</td>
      <td>Anzahl der Fehlversuche, damit Startzeit für Worker bei 60 Sekunden landet; Timeout default bei 10 Sekunden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
6
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--startupProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L459">synapse.startupProbe.httpGet.path</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Pfads vom Startup-Check DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"/health"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--startupProbe--httpGet--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L462">synapse.startupProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Ports vom Startup-Check DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"metrics"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--nodeSelector">
        <div style="max-width: 150px;"><a href="../values.yaml#L466">synapse.nodeSelector</a></div>
      </td>
      <td>object</td>
      <td>Node Selektoren, die für den Haupt-Synapse-Container festgelegt werden.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--tolerations">
        <div style="max-width: 150px;"><a href="../values.yaml#L493">synapse.tolerations</a></div>
      </td>
      <td>list</td>
      <td>Tolerations bzw. Taints die für den Haupt-Synapse-Container genutzt werden sollen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--affinity">
        <div style="max-width: 150px;"><a href="../values.yaml#L496">synapse.affinity</a></div>
      </td>
      <td>object</td>
      <td>Affinität zur Wahl von Nodes für die für den Haupt-Synapse-Container genutzt werden sollen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--replicaCount">
        <div style="max-width: 150px;"><a href="../values.yaml#L512">workers.default.replicaCount</a></div>
      </td>
      <td>int</td>
      <td>DEFAULT Die Anzahl der Worker-Replikate. Beachten Sie, dass einige Worker eine besondere Behandlung erfordern. Siehe dazu die Dokumentation: https://matrix-org.github.io/synapse/latest/workers.html</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
1
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--strategy--type">
        <div style="max-width: 150px;"><a href="../values.yaml#L520">workers.default.strategy.type</a></div>
      </td>
      <td>string</td>
      <td>DEFAULT gilt für alle Synapse-Worker-Container Nur wirklich anwendbar, wenn das Deployment ein RWO PV angehängt hat (z.B. Media Repository) Da Replikate = 1 sind, kann eine Aktualisierung "hängen bleiben", da der vorherige Container mit dem PV verbunden bleibt und der "neu-aufgebaute" Container nie starten kann. Das Ändern der Strategie auf "Recreate" wird den einzelnen vorherigen Container beenden, so dass der neue, ankommende Container sich mit dem PV verbinden kann</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"RollingUpdate"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--name">
        <div style="max-width: 150px;"><a href="../values.yaml#L525">workers.default.name</a></div>
      </td>
      <td>string</td>
      <td>Ein spezifischer Name für diesen Worker, kann nicht global gesetzt werden. Beachten Sie, dass dies nur gesetzt werden kann, wenn replicaCount 1 ist. (wird in den Worker überschrieben, ist hier nur aus historischen Gründen noch enthalten)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"nil"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--extraConfig">
        <div style="max-width: 150px;"><a href="../values.yaml#L528">workers.default.extraConfig</a></div>
      </td>
      <td>object</td>
      <td>Zusätzliche Konfiguration für die Worker.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--annotations">
        <div style="max-width: 150px;"><a href="../values.yaml#L531">workers.default.annotations</a></div>
      </td>
      <td>map</td>
      <td>DEFAULT Annotations, die auf alle Synapse-Worker-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--extraEnv">
        <div style="max-width: 150px;"><a href="../values.yaml#L539">workers.default.extraEnv</a></div>
      </td>
      <td>list</td>
      <td>DEFAULT Zusätzliche Umgebungsvariablen, die auf alle Synapse-Worker-Container anzuwenden sind Beispiel:  - name: LD_PRELOAD    value: /usr/lib/x86_64-linux-gnu/libjemalloc.so.2  - name: SYNAPSE_CACHE_FACTOR    value: "1.0"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--volumes">
        <div style="max-width: 150px;"><a href="../values.yaml#L545">workers.default.volumes</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Volumes, die dem Worker hinzugefügt werden sollen. DEFAULT gilt für alle Synapse-Worker-Container. Nützlich für das Medien-Repo oder zum Hinzufügen von Python-Modulen. Daher besser im entsprechenden Konfigurationsteil der spez. Worker</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--volumeMounts">
        <div style="max-width: 150px;"><a href="../values.yaml#L549">workers.default.volumeMounts</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche zu mountende Datenträgerpfade (siehe volumes) DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--extraCommands">
        <div style="max-width: 150px;"><a href="../values.yaml#L556">workers.default.extraCommands</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Befehle, die beim Starten von Synapse ausgeführt werden DEFAULT gilt für alle Synapse-Worker-Container. Beispiele: - 'apt-get update -yqq && apt-get install patch -yqq' - 'patch -d/usr/local/lib/python3.7/site-packages/synapse -p2 < /synapse/patches/something.patch'</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L564">workers.default.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die den Workern mitgeteilt werden sollen. DEFAULT gilt für alle Synapse-Worker-Container. Beispiele:   fsGroup: 2666   runAsGroup: 2666   runAsUser: 2666</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L575">workers.default.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie DEFAULT gilt für alle Synapse-Worker-Container. Beispiele:   readOnlyRootFilesystem: true   runAsNonRoot: true   runAsUser: 2666   capabilities:     drop:       - ALL</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsNonRoot": true,
  "runAsUser": 2666
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L585">workers.default.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container. Empfohlen gesondert zu verwalten</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"600m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L589">workers.default.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container. Empfohlen gesondert zu verwalten</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"768Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L594">workers.default.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container. Empfohlen gesondert zu verwalten</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"100m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L598">workers.default.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container. Empfohlen gesondert zu verwalten</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"150Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--livenessProbe--periodSeconds">
        <div style="max-width: 150px;"><a href="../values.yaml#L602">workers.default.livenessProbe.periodSeconds</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
10
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--livenessProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L606">workers.default.livenessProbe.httpGet.path</a></div>
      </td>
      <td>string</td>
      <td>Zu verwendende Konfiguration für den Pfad des Healthchecks DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"/health"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--livenessProbe--httpGet--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L609">workers.default.livenessProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Zu verwendende Konfiguration für den Port des Healthchecks DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"metrics"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--readinessProbe--periodSeconds">
        <div style="max-width: 150px;"><a href="../values.yaml#L613">workers.default.readinessProbe.periodSeconds</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
3
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--readinessProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L617">workers.default.readinessProbe.httpGet.path</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Pfads vom Bereitschaftscheck DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"/health"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--readinessProbe--httpGet--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L620">workers.default.readinessProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Ports vom Bereitschaftscheck DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"metrics"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--startupProbe--failureThreshold">
        <div style="max-width: 150px;"><a href="../values.yaml#L625">workers.default.startupProbe.failureThreshold</a></div>
      </td>
      <td>int</td>
      <td>Anzahl der Fehlversuche, damit Startzeit für Worker bei 60 Sekunden landet; Timeout default bei 10 Sekunden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
6
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--startupProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L629">workers.default.startupProbe.httpGet.path</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Pfads vom Startup-Check DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"/health"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--startupProbe--httpGet--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L632">workers.default.startupProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Ports vom Startup-Check DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"metrics"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--nodeSelector">
        <div style="max-width: 150px;"><a href="../values.yaml#L636">workers.default.nodeSelector</a></div>
      </td>
      <td>object</td>
      <td>Node Selektor Konfiguration, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--tolerations">
        <div style="max-width: 150px;"><a href="../values.yaml#L640">workers.default.tolerations</a></div>
      </td>
      <td>list</td>
      <td>Tolerations/Tains Konfiguration, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--affinity">
        <div style="max-width: 150px;"><a href="../values.yaml#L644">workers.default.affinity</a></div>
      </td>
      <td>object</td>
      <td>Affinitäts-Konfiguration, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L653">workers.generic_worker.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren von Workern</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--listeners">
        <div style="max-width: 150px;"><a href="../values.yaml#L655">workers.generic_worker.listeners</a></div>
      </td>
      <td>list</td>
      <td>entsprechende Endpunkte für den generischen Worker</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[
  "client",
  "federation"
]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--csPaths">
        <div style="max-width: 150px;"><a href="../values.yaml#L658">workers.generic_worker.csPaths</a></div>
      </td>
      <td>list</td>
      <td>Pfade für die Ingress-Konfiguration des Workers, mit 'publicServerName' Domain gesetzt</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
werden in der values.yaml gesetzt und können dort eingesehen werden
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--paths">
        <div style="max-width: 150px;"><a href="../values.yaml#L733">workers.generic_worker.paths</a></div>
      </td>
      <td>list</td>
      <td>Pfade für die Ingress-Konfiguration des Workers, mit 'serverName' Domain gesetzt</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
werden in der values.yaml gesetzt und können dort eingesehen werden
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--replicaCount">
        <div style="max-width: 150px;"><a href="../values.yaml#L762">workers.generic_worker.replicaCount</a></div>
      </td>
      <td>int</td>
      <td>Anzahl der Worker-Container Hinweis: Wenn autoscaling.enabled=true und replicaCount geringer als autoscaling.minReplicas oder wenn nicht gesetzt, dann wird autoscaling.minReplicas übernommen</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
2
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--autoscaling--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L769">workers.generic_worker.autoscaling.enabled</a></div>
      </td>
      <td>bool</td>
      <td>schalte das HPA für die Container ein Hinweis: Kann für alle spezifischen Worker benutzt werden Dazu muss entsprechende Konfiguration in die separaten Sektionen eingefügt werden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--autoscaling--minReplicas">
        <div style="max-width: 150px;"><a href="../values.yaml#L771">workers.generic_worker.autoscaling.minReplicas</a></div>
      </td>
      <td>int</td>
      <td>minimale Anzahl der Worker-Container</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
2
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--autoscaling--maxReplicas">
        <div style="max-width: 150px;"><a href="../values.yaml#L773">workers.generic_worker.autoscaling.maxReplicas</a></div>
      </td>
      <td>int</td>
      <td>maximale Anzahl der Worker-Container</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
10
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--autoscaling--targetCPUUtilizationPercentage">
        <div style="max-width: 150px;"><a href="../values.yaml#L775">workers.generic_worker.autoscaling.targetCPUUtilizationPercentage</a></div>
      </td>
      <td>int</td>
      <td>Prozentsatz für CPU-Auslastung um Scaling zu triggern</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
80
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--autoscaling--targetMemoryUtilizationPercentage">
        <div style="max-width: 150px;"><a href="../values.yaml#L777">workers.generic_worker.autoscaling.targetMemoryUtilizationPercentage</a></div>
      </td>
      <td>int</td>
      <td>Prozentsatz für RAM-Auslastung um Scaling zu triggern</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
80
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--federation_reader--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L788">workers.federation_reader.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktiviere spez. Worker für Föderationsanfragen Wenn dieser Worker genutzt wird, können die URLs aus dem generic_worker entfernt werden.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--federation_reader--listeners">
        <div style="max-width: 150px;"><a href="../values.yaml#L790">workers.federation_reader.listeners</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Listener für Föderationsworker</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[
  "federation"
]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--federation_reader--paths">
        <div style="max-width: 150px;"><a href="../values.yaml#L793">workers.federation_reader.paths</a></div>
      </td>
      <td>path</td>
      <td>Server-Side Pfade für die Ingress-Konfiguration des Föderations-Workers</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
werden in der values.yaml gesetzt und können dort eingesehen werden
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--pusher--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L823">workers.pusher.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Dieser Worker übernimmt die Übermittlung von Push-Benachrichtigungen. (pusher-worker -> Sygnal -> Push-Provider (Apple od. Google)) Hinweis: Es kann jeweils nur eine Instanz dieses Workers ausgeführt werden Ein lokaler Sygnal-Service und Container ist Bestandteil des Helm Charts.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--appservice--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L828">workers.appservice.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Dieser Worker sorgt für das Senden von Daten an registrierte Anwendungsdienste. Hinweis: Es kann nur eine Instanz dieses Workers ausgeführt werden.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--federation_sender--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L833">workers.federation_sender.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Dieser Worker sendet Verbundverkehrs (federation traffic) an andere Matrix-Server.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L839">workers.media_repository.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des Media-Worker Dieser Worker kümmert sich um die Bereitstellung und Speicherung von Medien. Hinweis: Die Ausführung mehrerer Instanzen führt zu Konflikten mit Hintergrundaufgaben.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--listeners">
        <div style="max-width: 150px;"><a href="../values.yaml#L841">workers.media_repository.listeners</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Listener für Media-Worker</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[
  "media"
]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--csPaths">
        <div style="max-width: 150px;"><a href="../values.yaml#L844">workers.media_repository.csPaths</a></div>
      </td>
      <td>list</td>
      <td>Pfade für die Ingress-Konfiguration des Media-Workers, mit 'publicServerName' Domain gesetzt</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
werden in der values.yaml gesetzt und können dort eingesehen werden
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--paths">
        <div style="max-width: 150px;"><a href="../values.yaml#L854">workers.media_repository.paths</a></div>
      </td>
      <td>list</td>
      <td>Pfade für die Ingress-Konfiguration des Media-Workers, mit 'serverName' Domain gesetzt</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
werden in der values.yaml gesetzt und können dort eingesehen werden
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L859">workers.media_repository.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den media_repository-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"2000m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L861">workers.media_repository.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den media_repository-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"2500Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L864">workers.media_repository.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den media_repository-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"500m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L866">workers.media_repository.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den media_repository-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"1500Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--extraConfig">
        <div style="max-width: 150px;"><a href="../values.yaml#L869">workers.media_repository.extraConfig</a></div>
      </td>
      <td>object</td>
      <td>Zusätzliche Konfiguration für die Worker</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "enable_media_repo": true
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--user_dir--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L878">workers.user_dir.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des Nutzersuch-Workers Hinweis: Damit kann Last vom generischen bzw. Haupt-Worker genommen werden Hinweis: Es kann nur eine Instanz dieses Workers ausgeführt werden.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--user_dir--listeners">
        <div style="max-width: 150px;"><a href="../values.yaml#L880">workers.user_dir.listeners</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Listener für NutzerSuch-Worker</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[
  "client"
]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--user_dir--csPaths">
        <div style="max-width: 150px;"><a href="../values.yaml#L883">workers.user_dir.csPaths</a></div>
      </td>
      <td>list</td>
      <td>Pfade für die Ingress-Konfiguration des Nutzersuch-Workers, mit 'publicServerName' Domain gesetzt</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
werden in der values.yaml gesetzt und können dort eingesehen werden
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--background_worker--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L889">workers.background_worker.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des Background-Workers Hinweis: Es kann nur eine Instanz dieses Workers ausgeführt werden.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="persistence--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L896">persistence.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren der Persistenz-Konfiguration für die Medien-Repository-Funktion. Diese PVC wird entweder in Synapse oder einem media_repo-Worker eingehängt. Hinweis: Wenn Sie in der Lage sein wollen, dies zu skalieren, müssen Sie den accessMode auf RWX/ReadWriteMany setzen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="persistence--existingClaim">
        <div style="max-width: 150px;"><a href="../values.yaml#L899">persistence.existingClaim</a></div>
      </td>
      <td>string</td>
      <td>Name des VolumeClaims</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
leerer Wert lässt dynamisches Provisionieren zu
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="persistence--storageClass">
        <div style="max-width: 150px;"><a href="../values.yaml#L901">persistence.storageClass</a></div>
      </td>
      <td>string</td>
      <td>Name der entsprechenden Storage-Klasse</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="persistence--accessMode">
        <div style="max-width: 150px;"><a href="../values.yaml#L903">persistence.accessMode</a></div>
      </td>
      <td>string</td>
      <td>Zugriffsmodus</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"ReadWriteOnce"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="persistence--size">
        <div style="max-width: 150px;"><a href="../values.yaml#L905">persistence.size</a></div>
      </td>
      <td>string</td>
      <td>Größe des zu nutzenden Volumes</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"10Gi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="volumePermissions--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L911">volumePermissions.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des Init-Containers zur Rechtekorrektur, um die Rechte auf dem Volume für Media anzupassen Notwendig für policy 'require-uid-greater-2000'</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="volumePermissions--uid">
        <div style="max-width: 150px;"><a href="../values.yaml#L914">volumePermissions.uid</a></div>
      </td>
      <td>int</td>
      <td>Nutzer-ID Notwendig für policy 'require-uid-greater-2000'</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
2666
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="volumePermissions--gid">
        <div style="max-width: 150px;"><a href="../values.yaml#L917">volumePermissions.gid</a></div>
      </td>
      <td>int</td>
      <td>Nutzer-ID Notwendig für policy 'require-uid-greater-2000'</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
2666
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="volumePermissions--image--repository">
        <div style="max-width: 150px;"><a href="../values.yaml#L921">volumePermissions.image.repository</a></div>
      </td>
      <td>string</td>
      <td>das Repository für das zu nutzende Image zur Rechtebereinigung</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"registry.opencode.de/bwi/bundesmessenger/backend/container-images/ubuntu"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="volumePermissions--image--tag">
        <div style="max-width: 150px;"><a href="../values.yaml#L924">volumePermissions.image.tag</a></div>
      </td>
      <td>string</td>
      <td>das Tag für das zu nutzende Image zur Rechtebereinigung Hinweis: noch kein finaler Tag, build version 10 als Alternative zu latest</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"latest-jammy-production"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="volumePermissions--image--pullPolicy">
        <div style="max-width: 150px;"><a href="../values.yaml#L926">volumePermissions.image.pullPolicy</a></div>
      </td>
      <td>string</td>
      <td>da latest-Tag, PullPolicy immer für das zu nutzende Image zur Rechtebereinigung</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"IfNotPresent"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="volumePermissions--resources">
        <div style="max-width: 150px;"><a href="../values.yaml#L935">volumePermissions.resources</a></div>
      </td>
      <td>map</td>
      <td>Ressourcen des Init-Containers zur Rechtekorrektur Hier keine gesetzt, da kurzlebig und von Hause aus klein Beispiel: resources:   requests:     memory: 128Mi     cpu: 100m</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="service--type">
        <div style="max-width: 150px;"><a href="../values.yaml#L943">service.type</a></div>
      </td>
      <td>string</td>
      <td>Typ des Auszuliefernden Endpunktes für den Hauptdienst von Synapse</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"ClusterIP"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="service--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L945">service.port</a></div>
      </td>
      <td>int</td>
      <td>interner Port des Auszuliefernden Endpunktes für den Hauptdienst von Synapse</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
8008
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="service--targetPort">
        <div style="max-width: 150px;"><a href="../values.yaml#L947">service.targetPort</a></div>
      </td>
      <td>int</td>
      <td>externer Port des Auszuliefernden Endpunktes für den Hauptdienst von Synapse</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"http"
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Sygnal

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="sygnal--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L957">sygnal.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des Sygnal-Container</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L959">sygnal.image</a></div>
      </td>
      <td>maps</td>
      <td>Image/Repo-Konfiguration von Sygnal</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/sygnal",
  "tag": "0.12.0-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--proxy">
        <div style="max-width: 150px;"><a href="../values.yaml#L968">sygnal.proxy</a></div>
      </td>
      <td>string</td>
      <td>Proxy, falls benötigt um die Push-Services zu erreichen. Auskommentieren oder leer lassen für die Benutzung ohne Proxy. Die Angabe des Zielports beim Proxy ist für die Generierung der Network Policies zwingend erforderlich</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L980">sygnal.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die dem Sygnal mitgeteilt werden sollen. Hinweis: hier muss der Sycall für unpriviligierter User auf priviligierter Port gesetzt sein weitere Beispiele:  runAsNonRoot: true  fsGroup: 27  runAsGroup: 2000  runAsUser: 2000  sysctls:    - name: net.ipv4.ip_unprivileged_port_start      value: "80"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L989">sygnal.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers weitere Beispiele:  capabilities:    drop:    - ALL  readOnlyRootFilesystem: true  runAsNonRoot: true  runAsUser: 2111</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L996">sygnal.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den Sygnal-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"150m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L998">sygnal.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den Sygnal-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"45Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1001">sygnal.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den Sygnal-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"150m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1003">sygnal.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den Sygnal-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"45Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--livenessProbe--periodSeconds">
        <div style="max-width: 150px;"><a href="../values.yaml#L1007">sygnal.livenessProbe.periodSeconds</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
10
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--livenessProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L1010">sygnal.livenessProbe.httpGet.path</a></div>
      </td>
      <td>string</td>
      <td>Zu verwendende Konfiguration für den Pfad des Healthchecks</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"/health"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--livenessProbe--httpGet--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L1012">sygnal.livenessProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Zu verwendende Konfiguration für den Port des Healthchecks</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"sygnal-port"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--readinessProbe--periodSeconds">
        <div style="max-width: 150px;"><a href="../values.yaml#L1016">sygnal.readinessProbe.periodSeconds</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
3
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--readinessProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L1019">sygnal.readinessProbe.httpGet.path</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Pfads vom Bereitschaftscheck</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"/health"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--readinessProbe--httpGet--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L1021">sygnal.readinessProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Ports vom Bereitschaftscheck</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"sygnal-port"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--nodeSelector">
        <div style="max-width: 150px;"><a href="../values.yaml#L1024">sygnal.nodeSelector</a></div>
      </td>
      <td>object</td>
      <td>Node Selektor Konfiguration für Sygnal-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--tolerations">
        <div style="max-width: 150px;"><a href="../values.yaml#L1027">sygnal.tolerations</a></div>
      </td>
      <td>list</td>
      <td>Tolerations/Tains Konfiguration für Sygnal-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--affinity">
        <div style="max-width: 150px;"><a href="../values.yaml#L1030">sygnal.affinity</a></div>
      </td>
      <td>object</td>
      <td>Affinitäts-Konfiguration für Sygnal-Container.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--apps">
        <div style="max-width: 150px;"><a href="../values.yaml#L1038">sygnal.apps</a></div>
      </td>
      <td>object</td>
      <td>Konfiguration für Push-Dienste (APNS und FCM) Beispiel: apps:    de.opencode.dvs.ios:      type: apns      keyfile: /de.opencode.dvs.ios.p8</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--ios_push--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1044">sygnal.ios_push.enabled</a></div>
      </td>
      <td>bool</td>
      <td>iOS-Push Schalter Wenn iOS Push mit genutzt wird, muss hier der Schalter dafür auf true gesetzt werden, sonst schlägt das Modul fehl. Hierdurch wird der unten angegebene ioskey geladen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--ios_push--ioskey_filename">
        <div style="max-width: 150px;"><a href="../values.yaml#L1051">sygnal.ios_push.ioskey_filename</a></div>
      </td>
      <td>map</td>
      <td>iOS-Key Konfiguration bei Nutzung von iOS-Pushservice, muss Key mit angeben werden. Weiteres siehe README.md Beispiel:  ioskey_filename: de.opencode.dvs.ios.p8 <<-- muss zwingend mit dem Keyfile-Dateinamen aus dem APN-File übereinstimmen!  ioskey_keyvalue: 'HIER KÖNNTE IHR KEY IN STEHEN'</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--ios_push--ioskey_keyvalue">
        <div style="max-width: 150px;"><a href="../values.yaml#L1052">sygnal.ios_push.ioskey_keyvalue</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Well-Known-Server

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="wellknown--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1064">wellknown.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivierung des Wellknown-Container</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--server">
        <div style="max-width: 150px;"><a href="../values.yaml#L1069">wellknown.server</a></div>
      </td>
      <td>object</td>
      <td>Die Host- und Port-Kombination, die auf .well-known/matrix/server zu bedienen ist. Beispiel:  m.server: matrix.example.com:443</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--client">
        <div style="max-width: 150px;"><a href="../values.yaml#L1086">wellknown.client</a></div>
      </td>
      <td>object</td>
      <td>Daten, die auf .well-known/matrix/client bereitgestellt werden sollen Die Angabe des Objektes "de.bwi": {"data_privacy_url": "https://example.com/privacy", "imprintUrl": "https://example.com/imprint"} ist verpflichtend, wenn keine .Values.dataPrivacyUrl und .Values.imprintUrl angegeben wurde und auf den WellKnown-Server verzichtet wird. Beispiel:  io.element.e2ee:    secure_backup_required: true    secure_backup_setup_methods: ["passphrase"]    outbound_keys_pre_sharing_mode: "on_room_opening"  m.homeserver:    base_url: https://matrix.example.com  de.bwi:    data_privacy_url: https://example.com/privacy    imprintUrl: https://example.com/imprint</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--extraData">
        <div style="max-width: 150px;"><a href="../values.yaml#L1097">wellknown.extraData</a></div>
      </td>
      <td>map</td>
      <td>Zusätzliche Daten, die unter .well-known/matrix/<data> bereitgestellt werden Dictionaries werden in JSON umgewandelt, einfache Strings werden direkt ausgeliefert MSC1929 Beispiel: support:   admins:     - matrix_id: '@admin:example.com'       email_address: 'admin@example.com'       role: 'admin'   support_page: 'https://example.com/support'</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--htdocsPath">
        <div style="max-width: 150px;"><a href="../values.yaml#L1101">wellknown.htdocsPath</a></div>
      </td>
      <td>path</td>
      <td>Ein benutzerdefinierter htdocs-Pfad, der nützlich ist, wenn ein anderes Image ausgeführt wird.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
/usr/share/nginx/html (nginx)
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1107">wellknown.image</a></div>
      </td>
      <td>map</td>
      <td>Das Webserver Image optional: pullSecrets:   - myRegistryKeySecretName</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/nginx",
  "tag": "1.18.0-6ubuntu14.4-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1115">wellknown.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die dem Container mitgeteilt werden sollen. weitere Möglichkeiten:  fsGroup: 1001</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "runAsGroup": 1001,
  "runAsUser": 1001
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1124">wellknown.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie weitere Möglichkeiten:  capabilities:    drop:    - ALL</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsNonRoot": true
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1132">wellknown.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den well-known server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"5m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1134">wellknown.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den well-known server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"15Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1137">wellknown.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den well-known server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"5m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1139">wellknown.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den well-known server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"15Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--nodeSelector">
        <div style="max-width: 150px;"><a href="../values.yaml#L1142">wellknown.nodeSelector</a></div>
      </td>
      <td>object</td>
      <td>Node Selektor Konfiguration für well-known server.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--tolerations">
        <div style="max-width: 150px;"><a href="../values.yaml#L1145">wellknown.tolerations</a></div>
      </td>
      <td>list</td>
      <td>Tolerations/Tains Konfiguration für well-known server.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--affinity">
        <div style="max-width: 150px;"><a href="../values.yaml#L1148">wellknown.affinity</a></div>
      </td>
      <td>object</td>
      <td>Affinitäts-Konfiguration für well-known server.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für ConfigurationHub-Server

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="confighub--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1160">confighub.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivierung des ConfigHub-Container</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--extraData">
        <div style="max-width: 150px;"><a href="../values.yaml#L1165">confighub.extraData</a></div>
      </td>
      <td>map</td>
      <td>Zusätzliche Daten, die unter /_matrix/cconfig/<data> bereitgestellt werden Dictionaries werden in JSON umgewandelt, einfache Strings werden direkt ausgeliefert Beispiel siehe wellknown-Konfiguration</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--htdocsPath">
        <div style="max-width: 150px;"><a href="../values.yaml#L1169">confighub.htdocsPath</a></div>
      </td>
      <td>path</td>
      <td>Ein benutzerdefinierter htdocs-Pfad, der nützlich ist, wenn ein anderes Image ausgeführt wird.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
/usr/share/nginx/html (nginx)
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1175">confighub.image</a></div>
      </td>
      <td>map</td>
      <td>Das Webserver Image optional: pullSecrets:   - myRegistryKeySecretName</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/nginx",
  "tag": "1.18.0-6ubuntu14.4-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1183">confighub.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die dem Container mitgeteilt werden sollen. weitere Möglichkeiten:  fsGroup: 1001</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "runAsGroup": 1001,
  "runAsUser": 1001
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1192">confighub.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie weitere Möglichkeiten:  capabilities:    drop:    - ALL</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsNonRoot": true
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1200">confighub.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den confighub anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"5m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1202">confighub.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den confighub anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"15Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1205">confighub.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den confighub anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"5m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1207">confighub.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den confighub anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"15Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--nodeSelector">
        <div style="max-width: 150px;"><a href="../values.yaml#L1210">confighub.nodeSelector</a></div>
      </td>
      <td>object</td>
      <td>Node Selektor Konfiguration für confighub.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--tolerations">
        <div style="max-width: 150px;"><a href="../values.yaml#L1213">confighub.tolerations</a></div>
      </td>
      <td>list</td>
      <td>Tolerations/Tains Konfiguration für confighub.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="confighub--affinity">
        <div style="max-width: 150px;"><a href="../values.yaml#L1216">confighub.affinity</a></div>
      </td>
      <td>object</td>
      <td>Affinitäts-Konfiguration für confighub.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Postgres Server

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="postgresql--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1231">postgresql.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Diese Konfiguration ist für die Einrichtung des intern bereitgestellten Postgres-Servers gedacht, Wenn Sie stattdessen einen vorhandenen Server verwenden wollen, sollten Sie enabled auf false setzen und den externalPostgresql-Block konfigurieren.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
false da externe DB vorausgesetzt wird
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1235">postgresql.image</a></div>
      </td>
      <td>map</td>
      <td>Das PostgreSQL Image</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
WIRD NICHT EMPFOHLEN!!
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--auth--database">
        <div style="max-width: 150px;"><a href="../values.yaml#L1243">postgresql.auth.database</a></div>
      </td>
      <td>string</td>
      <td>Name für PostgreSQL-DB</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"synapse_db"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--auth--username">
        <div style="max-width: 150px;"><a href="../values.yaml#L1246">postgresql.auth.username</a></div>
      </td>
      <td>string</td>
      <td>Name für PostgreSQL Nutzer</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"synapse"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--auth--password">
        <div style="max-width: 150px;"><a href="../values.yaml#L1249">postgresql.auth.password</a></div>
      </td>
      <td>string</td>
      <td>Passwort für PostgreSQL Nutzer</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"synapse"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--auth--existingSecret">
        <div style="max-width: 150px;"><a href="../values.yaml#L1253">postgresql.auth.existingSecret</a></div>
      </td>
      <td>string</td>
      <td>Bestehendes Secret das anstelle eines statischen Passwortes verwendet wird</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--auth--secretKeys--userPasswordKey">
        <div style="max-width: 150px;"><a href="../values.yaml#L1257">postgresql.auth.secretKeys.userPasswordKey</a></div>
      </td>
      <td>string</td>
      <td>Schlüssel, der das Datenbank-Passwort enthält. Wird nur berücksichtigt, wenn `existingSecret` gesetzt ist.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"password"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--auth--secretKeys--adminPasswordKey">
        <div style="max-width: 150px;"><a href="../values.yaml#L1260">postgresql.auth.secretKeys.adminPasswordKey</a></div>
      </td>
      <td>string</td>
      <td>Schlüssel, der das PostgreSQL enthält. Wird nur berücksichtigt, wenn `existingSecret` gesetzt ist.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"postgres-password"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--primary--initdb--args">
        <div style="max-width: 150px;"><a href="../values.yaml#L1265">postgresql.primary.initdb.args</a></div>
      </td>
      <td>string</td>
      <td>Extra Argumente zur Initialisierung der Datenbank</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"--lc-collate=C --lc-ctype=C --encoding=UTF8"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--primary--extendedConfiguration">
        <div style="max-width: 150px;"><a href="../values.yaml#L1270">postgresql.primary.extendedConfiguration</a></div>
      </td>
      <td>string</td>
      <td>Extra Konfiguration der Datenbank die Anzahl an max. Verbindungen ist oft eine Limitierung, da jeder Synapse- Prozess seine Verbindungen zur Datenbank hält</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"max_connections = 1024\n"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--primary--persistence">
        <div style="max-width: 150px;"><a href="../values.yaml#L1274">postgresql.primary.persistence</a></div>
      </td>
      <td>map</td>
      <td>Persistenzkonfiguration für Storage für PostgreSQL</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "size": "16Gi",
  "storageClass": ""
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--primary--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1281">postgresql.primary.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den PostgreSQL-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"500m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--primary--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1283">postgresql.primary.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den PostgreSQL-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"1024Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--primary--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1286">postgresql.primary.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den PostgreSQL-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"250m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--primary--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1288">postgresql.primary.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den PostgreSQL-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"256Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--extraArgs">
        <div style="max-width: 150px;"><a href="../values.yaml#L1292">postgresql.extraArgs</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Argumente für die Datenbankverbindung ref: https://matrix-org.github.io/synapse/latest/postgres.html#synapse-config</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="externalPostgresql">
        <div style="max-width: 150px;"><a href="../values.yaml#L1298">externalPostgresql</a></div>
      </td>
      <td>map</td>
      <td>Ein extern konfigurierter Postgres-Server, der für die Datenbank von Synapse verwendet wird. Die Datenbank muss vorhanden sein und sowohl COLLATE als auch CTYPE auf "C" eingestellt sein. Die "interne" Datenbank muss deaktiviert sein `postgresql.enabled: false`. Beispiel für K8s internen Postgres im Namespace "postgres":</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "database": "synapse_db",
  "existingSecret": "",
  "existingSecretPasswordKey": "password",
  "extraArgs": {},
  "host": "postgres-4-matrix-postgresql.postgres.svc.cluster.local",
  "password": "synapse",
  "port": 5432,
  "username": "synapse"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="externalPostgresql--database">
        <div style="max-width: 150px;"><a href="../values.yaml#L1302">externalPostgresql.database</a></div>
      </td>
      <td>string</td>
      <td>Name für PostgreSQL-DB auf die sich verbunden wird</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"synapse_db"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="externalPostgresql--username">
        <div style="max-width: 150px;"><a href="../values.yaml#L1305">externalPostgresql.username</a></div>
      </td>
      <td>string</td>
      <td>Name für PostgreSQL Nutzer</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"synapse"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="externalPostgresql--password">
        <div style="max-width: 150px;"><a href="../values.yaml#L1308">externalPostgresql.password</a></div>
      </td>
      <td>string</td>
      <td>Passwort für PostgreSQL Nutzer</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"synapse"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="externalPostgresql--existingSecret">
        <div style="max-width: 150px;"><a href="../values.yaml#L1311">externalPostgresql.existingSecret</a></div>
      </td>
      <td>string</td>
      <td>Der Name eines bestehenden Secrets mit Postgresql-Anmeldedaten</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="externalPostgresql--existingSecretPasswordKey">
        <div style="max-width: 150px;"><a href="../values.yaml#L1314">externalPostgresql.existingSecretPasswordKey</a></div>
      </td>
      <td>string</td>
      <td>Passwortschlüssel, der aus dem bestehenden Secret abgerufen wird</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"password"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="externalPostgresql--extraArgs">
        <div style="max-width: 150px;"><a href="../values.yaml#L1320">externalPostgresql.extraArgs</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Argumente für die Datenbankverbindung ref: https://matrix-org.github.io/synapse/latest/postgres.html#synapse-config</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Redis Server

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="redis--image--registry">
        <div style="max-width: 150px;"><a href="../values.yaml#L1332">redis.image.registry</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"registry.opencode.de"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--image--repository">
        <div style="max-width: 150px;"><a href="../values.yaml#L1333">redis.image.repository</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"bwi/bundesmessenger/backend/container-images/redis"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--image--tag">
        <div style="max-width: 150px;"><a href="../values.yaml#L1334">redis.image.tag</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"5_6.0.16-1ubuntu1-jammy-production"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1339">redis.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Diese Konfiguration ist für den internen Redis, der für die Verwendung mit Worker/Sharding eingesetzt wird. Für einen externen Redis-Server setzen Sie enabled auf false setzen und den externalRedis-Block konfigurieren.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--auth">
        <div style="max-width: 150px;"><a href="../values.yaml#L1343">redis.auth</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für Authentifikation gegen Redis Oder verwenden Sie ein bestehendes Geheimnis mit "redis-password"-Schlüssel anstelle eines statischen Passworts.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "enabled": true,
  "existingSecret": "",
  "existingSecretPasswordKey": "redis-password",
  "password": "synapse"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--sysctl">
        <div style="max-width: 150px;"><a href="../values.yaml#L1351">redis.sysctl</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration zur Härtung des Redis-Images (https://docs.bitnami.com/kubernetes/infrastructure/redis/administration/configure-kernel-settings/)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "command": [
    "/bin/sh",
    "-c",
    "echo never \u003e /host-sys/kernel/mm/transparent_hugepage/enabled"
  ],
  "enabled": true,
  "image": {
    "pullPolicy": "IfNotPresent",
    "registry": "registry.opencode.de",
    "repository": "bwi/bundesmessenger/backend/container-images/ubuntu",
    "tag": "latest-jammy-production"
  },
  "mountHostSys": true,
  "resources": {
    "limits": {
      "cpu": "200m",
      "memory": "256Mi"
    },
    "requests": {
      "cpu": "100m",
      "memory": "128Mi"
    }
  }
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--architecture">
        <div style="max-width: 150px;"><a href="../values.yaml#L1374">redis.architecture</a></div>
      </td>
      <td>string</td>
      <td>Form der Architektur des Deployments</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"standalone"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--master--kind">
        <div style="max-width: 150px;"><a href="../values.yaml#L1376">redis.master.kind</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"StatefulSet"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--master--persistence--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1381">redis.master.persistence.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Persistenzkonfiration des Redis Beachten Sie, dass Synapse redis nur als Synchronisierungsdienstprogramm verwendet, so dass keine Daten jemals persistiert werden müssen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--master--service--ports--redis">
        <div style="max-width: 150px;"><a href="../values.yaml#L1385">redis.master.service.ports.redis</a></div>
      </td>
      <td>int</td>
      <td>Serviceport</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
6379
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--master--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1390">redis.master.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den Redis-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"500m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--master--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1392">redis.master.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den Redis-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"512Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--master--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1395">redis.master.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den Redis-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"300m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="redis--master--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1397">redis.master.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den Redis-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"256Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="externalRedis">
        <div style="max-width: 150px;"><a href="../values.yaml#L1406">externalRedis</a></div>
      </td>
      <td>map</td>
      <td>Ein extern konfigurierter Redis-Server, der für Worker/Sharding verwendet wird Wird erst ausgewertet, wenn `redis.enabled=false` ist. Alternativ zum statischen Passwort: Der Name eines bestehenden Secret mit Redis-Anmeldeinformationen existingSecret: redis-secrets Passwortschlüssel, der aus dem bestehenden Secret abgerufen wird existingSecretPasswordKey: redis-password</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "existingSecret": "",
  "existingSecretPasswordKey": "redis-password",
  "host": "redis",
  "password": "synapse",
  "port": 6379
}
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Ingress

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="ingress--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1425">ingress.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktiviert Ingress-Konfiguration</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--traefikPaths">
        <div style="max-width: 150px;"><a href="../values.yaml#L1429">ingress.traefikPaths</a></div>
      </td>
      <td>bool</td>
      <td>Generierung von Traefik-kompatiblen Regex-Pfaden anstelle von Nginx-kompatiblen Pfaden. UNGETESTET!</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--annotations">
        <div style="max-width: 150px;"><a href="../values.yaml#L1432">ingress.annotations</a></div>
      </td>
      <td>map</td>
      <td>Annotations zur Konfiguration des Ingress.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "nginx.ingress.kubernetes.io/cors-allow-credentials": "true",
  "nginx.ingress.kubernetes.io/cors-allow-methods": "PUT, GET, POST, OPTIONS, DELETE",
  "nginx.ingress.kubernetes.io/cors-allow-origin": "*",
  "nginx.ingress.kubernetes.io/enable-cors": "true",
  "nginx.ingress.kubernetes.io/enable-owasp-core-rules": "true",
  "nginx.ingress.kubernetes.io/proxy-body-size": "50m",
  "nginx.ingress.kubernetes.io/use-regex": "true"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--csHosts">
        <div style="max-width: 150px;"><a href="../values.yaml#L1453">ingress.csHosts</a></div>
      </td>
      <td>list</td>
      <td>Hosts, die der Ingress-Konfiguration für die Verarbeitung von Client-to-Server-API-Anfragepfade hinzugefügt werden sollen. Hinweis: config.serverName wird einbezogen, wenn includeServerName gesetzt ist. (default) Beispiel:  - matrix.example.com</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--hosts">
        <div style="max-width: 150px;"><a href="../values.yaml#L1460">ingress.hosts</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Hosts, die der Ingress-Konfiguration für die Bearbeitung von Server-zu-Server-API-Anfragen hinzugefügt werden sollen. Hinweis: config.serverName wird einbezogen, wenn includeServerName gesetzt ist. (default) Beispiel:  - example.com</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--wkHosts">
        <div style="max-width: 150px;"><a href="../values.yaml#L1467">ingress.wkHosts</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Hosts, die der Ingress-Konfiguration für die Bearbeitung von wellknown-Anfragen hinzugefügt werden sollen. Hinweis: config.serverName wird einbezogen, wenn includeServerName gesetzt ist. (default) Beispiel:  - example.com</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--paths">
        <div style="max-width: 150px;"><a href="../values.yaml#L1484">ingress.paths</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Pfade, die zu den Server-zu-Server-Eingangsblöcken hinzugefügt werden sollen Werden vor dem `/_matrix` Catch-all-Pfad eingefügt. Beispiele:  # K8s 1.19+  - path: /_matrix/media    pathType: Prefix    backend:      service:        name: matrix-media-repo        port: 8000  # K8s <1.19  - path: /_matrix/media    backend:      serviceName: matrix-media-repo      servicePort: 8000</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--csPaths">
        <div style="max-width: 150px;"><a href="../values.yaml#L1501">ingress.csPaths</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Pfade, die zu den Client-zu-Server Blöcken hinzugefügt werden sollen Werden vor dem `/_matrix` und `/_synapse` Catch-all-Pfade eingefügt. Beispiele:  # K8s 1.19+  - path: /_matrix/media    pathType: Prefix    backend:      service:        name: matrix-media-repo        port: 8000  # K8s <1.19  - path: /_matrix/media    backend:      serviceName: matrix-media-repo      servicePort: 8000</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--includeUnderscoreSynapse">
        <div style="max-width: 150px;"><a href="../values.yaml#L1504">ingress.includeUnderscoreSynapse</a></div>
      </td>
      <td>bool</td>
      <td>Soll der `/_synapse`-Pfad im Ingress enthalten sein, werden die Client-APIs unter diesem Pfad bereitgestellt.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--includeServerName">
        <div style="max-width: 150px;"><a href="../values.yaml#L1508">ingress.includeServerName</a></div>
      </td>
      <td>bool</td>
      <td>Sollte `config.serverName` in die Liste der Eingangspfade aufgenommen werden, kann auf `false` gesetzt werden, wenn die Hauptdomäne auf irgendeine externe Weise verwaltet wird</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--tls">
        <div style="max-width: 150px;"><a href="../values.yaml#L1520">ingress.tls</a></div>
      </td>
      <td>list</td>
      <td>TLS-Konfiguration für Ingress Konfiguration Enthält für alle benötigten Domains die notwendigen Secrets bzw. TLS-Zertifikate Beispiel:  - secretName: chart-example-tls    hosts:      - example.com      - matrix.example.com  - secretName: admin-example-tls    hosts:      - admin.example.com</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--className">
        <div style="max-width: 150px;"><a href="../values.yaml#L1525">ingress.className</a></div>
      </td>
      <td>string</td>
      <td>Legen Sie den Namen der IngressClass-Cluster-Ressource fest (optional) https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/#IngressSpec HINWEIS: Wir setzen dem Nginx voraus, da wir auch die entsprechenden Annotiations setzen</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"nginx"
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Matrix-Content-Scanner

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="contentscanner--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1535">contentscanner.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des Matrix-Content-Scanner Mittelsmann zwischen AV und Matrix-Synapse</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="contentscanner--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1537">contentscanner.image</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration des Image/Repository</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/matrix-content-scanner",
  "tag": "1.0.3-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="contentscanner--replicaCount">
        <div style="max-width: 150px;"><a href="../values.yaml#L1542">contentscanner.replicaCount</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
1
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="contentscanner--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1546">contentscanner.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den Matrix-Content-Scanner-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"500m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="contentscanner--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1548">contentscanner.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den Matrix-Content-Scanner-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"1Gi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="contentscanner--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1551">contentscanner.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den Matrix-Content-Scanner-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"300m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="contentscanner--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1553">contentscanner.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den Matrix-Content-Scanner-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"500Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="contentscanner--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1559">contentscanner.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die dem Container mitgeteilt werden sollen. weitere Möglichkeiten:  fsGroup: 1001</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "runAsGroup": 1334,
  "runAsUser": 1334
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="contentscanner--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1568">contentscanner.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie weitere Möglichkeiten:  capabilities:    drop:    - ALL</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsNonRoot": true
}
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für ClamAV

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="schadcodescanner--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1579">schadcodescanner.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des ClamAV-Container</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--imageclamav">
        <div style="max-width: 150px;"><a href="../values.yaml#L1581">schadcodescanner.imageclamav</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration des ClamAV-Image/Repository</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/clamav",
  "tag": "0.103.9_dfsg-0ubuntu0.22.04.1-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--imagecicap">
        <div style="max-width: 150px;"><a href="../values.yaml#L1586">schadcodescanner.imagecicap</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration des C-ICAP-Server-Image/Repository</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/icap",
  "tag": "1_0.5.6-2build1-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--persistence--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1593">schadcodescanner.persistence.enabled</a></div>
      </td>
      <td>bool</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--persistence--existingClaim">
        <div style="max-width: 150px;"><a href="../values.yaml#L1596">schadcodescanner.persistence.existingClaim</a></div>
      </td>
      <td>string</td>
      <td>Name des VolumeClaims</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
leer, damit dynamische Volumes genutzt werden können (dennoch persistent)
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--persistence--storageClass">
        <div style="max-width: 150px;"><a href="../values.yaml#L1598">schadcodescanner.persistence.storageClass</a></div>
      </td>
      <td>string</td>
      <td>Name der entsprechenden Storage-Klasse, - (damit wird default genutzt, ansonsten storageClass direkt benennen)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--persistence--accessMode">
        <div style="max-width: 150px;"><a href="../values.yaml#L1600">schadcodescanner.persistence.accessMode</a></div>
      </td>
      <td>string</td>
      <td>Zugriffsmodus, ReadWriteOnce (wird für jedes HPA-skalierte neu angelegt)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"ReadWriteOnce"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--persistence--size">
        <div style="max-width: 150px;"><a href="../values.yaml#L1602">schadcodescanner.persistence.size</a></div>
      </td>
      <td>string</td>
      <td>Größe des zu nutzenden Volumes</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"10Gi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--extraEnv">
        <div style="max-width: 150px;"><a href="../values.yaml#L1612">schadcodescanner.extraEnv</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Umgebungsvariablen, die auf den Pod anzuwenden sind Beispiel:   - name: NO_PROXY     value: "127.0.0.1,localhost,*.mylocaldomain.local,10.0.0.0/8"   - name: HTTPS_PROXY     value: "https://proxyuser@proxyserver:proxyport"   - name: HTTP_PROXY     value: "http://proxyuser@proxyserver:proxyport"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--service--port">
        <div style="max-width: 150px;"><a href="../values.yaml#L1616">schadcodescanner.service.port</a></div>
      </td>
      <td>int</td>
      <td>der Port des ClamAV Pods (c-icap-Server), wird im Service übertragen</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
1344
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--freshclam--mirrors">
        <div style="max-width: 150px;"><a href="../values.yaml#L1626">schadcodescanner.freshclam.mirrors</a></div>
      </td>
      <td>list</td>
      <td>Eine Liste von clamav-Spiegeln, die vom freshclam-Dienst verwendet werden sollen. Erzeugt eine Liste von "PrivateMirror" in der freshclam.conf https://docs.clamav.net/appendix/CvdPrivateMirror.html#use-freshclam-to-serve-only-whole-database-files-from-a-private-mirror Der Standard-Updateserver ("DatabaseMirror") ist "database.clamav.net" und wird durch das Konfigurieren eines privaten Mirrors automatisch überschrieben. Die Angabe des Zielports beim Mirror ist für die Generierung der Network Policies zwingend erforderlich</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--replicaCount">
        <div style="max-width: 150px;"><a href="../values.yaml#L1631">schadcodescanner.replicaCount</a></div>
      </td>
      <td>int</td>
      <td>Anzahl der ClamAV-Pods Hinweis: Wenn autoscaling.enabled=true und replicaCount geringer als autoscaling.minReplicas oder wenn nicht gesetzt, dann wird autoscaling.minReplicas übernommen</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
1
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--autoscaling--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1638">schadcodescanner.autoscaling.enabled</a></div>
      </td>
      <td>bool</td>
      <td>schalte das HPA für die Container ein Hinweis: Kann für alle spezifischen Worker benutzt werden Dazu muss entsprechende Konfiguration in die separaten Sektionen eingefügt werden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--autoscaling--minReplicas">
        <div style="max-width: 150px;"><a href="../values.yaml#L1640">schadcodescanner.autoscaling.minReplicas</a></div>
      </td>
      <td>int</td>
      <td>minimale Anzahl der Worker-Container</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
1
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--autoscaling--maxReplicas">
        <div style="max-width: 150px;"><a href="../values.yaml#L1642">schadcodescanner.autoscaling.maxReplicas</a></div>
      </td>
      <td>int</td>
      <td>maximale Anzahl der Worker-Container</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
4
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--autoscaling--targetCPUUtilizationPercentage">
        <div style="max-width: 150px;"><a href="../values.yaml#L1644">schadcodescanner.autoscaling.targetCPUUtilizationPercentage</a></div>
      </td>
      <td>int</td>
      <td>Prozentsatz für CPU-Auslastung um Scaling zu triggern</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
90
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--autoscaling--targetMemoryUtilizationPercentage">
        <div style="max-width: 150px;"><a href="../values.yaml#L1646">schadcodescanner.autoscaling.targetMemoryUtilizationPercentage</a></div>
      </td>
      <td>int</td>
      <td>Prozentsatz für RAM-Auslastung um Scaling zu triggern</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
80
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--limits--fileSize">
        <div style="max-width: 150px;"><a href="../values.yaml#L1650">schadcodescanner.limits.fileSize</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
50
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--limits--scanSize">
        <div style="max-width: 150px;"><a href="../values.yaml#L1652">schadcodescanner.limits.scanSize</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
100
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--limits--connectionQueueLength">
        <div style="max-width: 150px;"><a href="../values.yaml#L1654">schadcodescanner.limits.connectionQueueLength</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
100
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--limits--maxThreads">
        <div style="max-width: 150px;"><a href="../values.yaml#L1656">schadcodescanner.limits.maxThreads</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
4
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--limits--sendBufTimeout">
        <div style="max-width: 150px;"><a href="../values.yaml#L1658">schadcodescanner.limits.sendBufTimeout</a></div>
      </td>
      <td>int</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
500
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--resourcesClamav--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1663">schadcodescanner.resourcesClamav.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den ClamAV-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"1500m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--resourcesClamav--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1665">schadcodescanner.resourcesClamav.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den ClamAV-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"4Gi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--resourcesClamav--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1668">schadcodescanner.resourcesClamav.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den ClamAV-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"300m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--resourcesClamav--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1670">schadcodescanner.resourcesClamav.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den ClamAV-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"2Gi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--resourcesCicap--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1675">schadcodescanner.resourcesCicap.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den C-Icap-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"500m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--resourcesCicap--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1677">schadcodescanner.resourcesCicap.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den C-Icap-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"100Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--resourcesCicap--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1680">schadcodescanner.resourcesCicap.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den C-Icap-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"300m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--resourcesCicap--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1682">schadcodescanner.resourcesCicap.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den C-Icap-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"50Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1687">schadcodescanner.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die dem Container mitgeteilt werden sollen. weitere Möglichkeiten:  fsGroup: 1001</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "runAsNonRoot": true
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--clamavSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1695">schadcodescanner.clamavSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die ClamAv-Container-Sicherheitsrichtlinie weitere Möglichkeiten:  capabilities:    drop:    - ALL</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsGroup": 1111,
  "runAsUser": 1111
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--icapSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1705">schadcodescanner.icapSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die C-ICAP-Container-Sicherheitsrichtlinie weitere Möglichkeiten:  capabilities:    drop:    - ALL</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsGroup": 1112,
  "runAsUser": 1112
}
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für CoTurn

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="coturn--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1723">coturn.enabled</a></div>
      </td>
      <td>bool</td>
      <td>CoTurn als Deployment aktivieren Hinweis: Nicht empfohlen!</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="coturn--turnUris">
        <div style="max-width: 150px;"><a href="../values.yaml#L1730">coturn.turnUris</a></div>
      </td>
      <td>map</td>
      <td>TurnUris zusammenbauen lassen, aktuell deaktiviert, Als Liste unter `config.turnUris` konfigurieren Beispiel:  udp: 3478  tcp: 3478  realm: "turn.example.com"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="coturn--existingcoturn--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1734">coturn.existingcoturn.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Schalter um bereits existenten CoTurn im K8s-Cluster zu nutzen</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="coturn--default_ns">
        <div style="max-width: 150px;"><a href="../values.yaml#L1736">coturn.default_ns</a></div>
      </td>
      <td>string</td>
      <td>Namespace für den CoTurn-Dienst</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"default"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="coturn--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1738">coturn.image</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für das Image vom CoTurn</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "HIER BITTE EIN REPOSITORY FÜR COTURN EINTRAGEN - NICHT EMPFOHLEN!",
  "tag": "Hier das Tag für das Image des Coturn eintragen - NICHT EMPFOHLEN!"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="coturn--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1743">coturn.securityContext</a></div>
      </td>
      <td>map</td>
      <td>SecurityContext für den Container</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "allowPrivilegeEscalation": false,
  "readOnlyRootFilesystem": true,
  "runAsGroup": 2011,
  "runAsUser": 2011
}
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Synapse Admin

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="synapse_admin--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1756">synapse_admin.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des Synapse-Admin-Moduls</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse_admin--uri">
        <div style="max-width: 150px;"><a href="../values.yaml#L1758">synapse_admin.uri</a></div>
      </td>
      <td>string</td>
      <td>URI für die Admin GUI, zwingend notwendig</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse_admin--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1760">synapse_admin.image</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration des Image vom Modul</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/synapse-admin",
  "tag": "0.8.7-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse_admin--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1769">synapse_admin.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den Synapse-Admin Server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"5m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse_admin--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1771">synapse_admin.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den Synapse-Admin Server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"15Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse_admin--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1774">synapse_admin.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den Synapse-Admin Server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"5m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse_admin--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1776">synapse_admin.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den Synapse-Admin Server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"15Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse_admin--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1782">synapse_admin.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die dem Sygnal mitgeteilt werden sollen. Hinweis: hier muss der Sycall für unpriviligierter User auf priviligierter Port gesetzt sein weitere Beispiele:  runAsNonRoot: true</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "runAsGroup": 1001,
  "runAsUser": 1001
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse_admin--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1790">synapse_admin.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie des Containers weitere Beispiele:   runAsNonRoot: true   readOnlyRootFilesystem: true   runAsUser: 2010</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsNonRoot": true
}
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Element-WebClient

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="webclient--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1825">webclient.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Element-Webclient im Deployment aktivieren</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--uri">
        <div style="max-width: 150px;"><a href="../values.yaml#L1827">webclient.uri</a></div>
      </td>
      <td>string</td>
      <td>URL für den Webclient, zwingend notwendig</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1829">webclient.image</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für das Image vom Element-Webclient</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/bundesmessenger-web",
  "tag": "2.8.0-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--annotations--"nginx--ingress--kubernetes--io/configuration-snippet"">
        <div style="max-width: 150px;"><a href="../values.yaml#L1834">webclient.annotations."nginx.ingress.kubernetes.io/configuration-snippet"</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"add_header X-Frame-Options SAMEORIGIN;\nadd_header X-Content-Type-Options nosniff;\nadd_header X-XSS-Protection \"1; mode=block\";\nadd_header Content-Security-Policy \"frame-ancestors 'none'\";\n"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1843">webclient.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die der Container übernehmen soll. weitere Möglichkeiten:  fsGroup: 1001</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "runAsGroup": 1001,
  "runAsUser": 1001
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1852">webclient.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie weitere Möglichkeiten:  capabilities:    drop:    - ALL</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsNonRoot": true
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1860">webclient.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf den webclient-server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"100m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1862">webclient.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den webclient-server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"90Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1865">webclient.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den webclient-server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"50m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1867">webclient.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den webclient-server anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"45Mi"
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### zusätzliche Konfigurationen für den BundesMessenger

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="additionalConfig--locationSharing--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1887">additionalConfig.locationSharing.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktivierung und Konfiguration von Standort teilen (location sharing) in den Clients Führt zur Konfiguration der /.well-known/client und /_matrix/cconfig/style.json Wenn wellknown.enable oder confighub.enable deaktiviert sind, ist die notwendige Konfiguration selbst vorzunehmen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="additionalConfig--maintenance">
        <div style="max-width: 150px;"><a href="../values.yaml#L1931">additionalConfig.maintenance</a></div>
      </td>
      <td>map</td>
      <td>Die Nutzer werden mit diesen Informationen auf die bevorstehende geplante Downtime, bzw. auf die aktive Downtime, hingewiesen. Weiterhin besteht die Möglichkeit, die Nutzer zum Update des Clients zu motivieren bzw. zu zwingen. Die Konfiguration wird vom confighub ausgeliefert, daher ist es notwendig, dass `confighub.enable: true` gesetzt ist.  downtime[]   warning_start_time: Startzeit der Warnmeldung (ISO 8601)                       Beispiele: 2023-08-06T14:00:00Z (UTC)                                  2009-01-01T12:00:00+01:00 (MEZ)                                  2009-06-30T18:30:00+02:00 (MESZ - Sommerzeit)   start_time:         Startzeit der Downtime (ISO 8601)   end_time:           Ende der Downtime (ISO 8601)   type:     MAINTENANCE:  Default Text in Anwendung für Wartungsfenster.                   Feld `description` wird zusätzlich darunter mit 1 Zeile Abstand angezeigt,                   wenn vorhanden     ADHOC_MESSAGE: Nur der Text aus dem Feld `description` wird angezeigt.   description:  optionaler Text zusätzlich zum Standard-Wartungstext   blocking:     Bei true werden Login und Requests vom Client blockiert (auch im eingeloggten Zustand)                 Requests auf die Maintenance-Schnittstelle werden nicht blockiert.  versions: ios oder android (web unterstützt die Funktion aktuell nicht)   Für die Versionsangabe sind vollständige Versionsnummern (Major.Minor.Patch) anzugeben. update_before: die letzte Version, die gedulded wird, ältere müssen updaten warn_before: die letzte Version ohne Update-Hinweis, ältere sollten updaten  maintenance:   downtime:     - warning_start_time: "2022-12-14T11:00:00Z"       start_time: "2022-12-23T11:00:00Z"       end_time: "2022-12-24T20:00:00Z"       type: "MAINTENANCE"       description: "Weihnachtswartung 2022"       blocking: true   versions:     ios:       update_before: "1.17.0"       warn_before: "1.19.0"     android:       update_before: "1.17.0"       warn_before: "1.19.0"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration der Network Policies

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="networkpolicies--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1939">networkpolicies.enabled</a></div>
      </td>
      <td>bool</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="networkpolicies--ingressNamespace">
        <div style="max-width: 150px;"><a href="../values.yaml#L1943">networkpolicies.ingressNamespace</a></div>
      </td>
      <td>string</td>
      <td>Hierbei handelt es sich um den Namespace indem ein Ingress Controller gehostet wird. Aktuell wird nur eine Architektur mit einem L7 Ingress Controller unterstützt. Absolut notwendig für die Network-Policies</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"default"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="networkpolicies--postgres--externalPostgresIP">
        <div style="max-width: 150px;"><a href="../values.yaml#L1949">networkpolicies.postgres.externalPostgresIP</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="networkpolicies--postgres--labelselector">
        <div style="max-width: 150px;"><a href="../values.yaml#L1953">networkpolicies.postgres.labelselector</a></div>
      </td>
      <td>string</td>
      <td>Der labelselector wird dafür genutzt eine Postgres Instanz innerhalb des Clusters zu adressieren. Sollte das Label bei einer eigens betriebenen Instanz abweichen, kann dies hier angepasst werden.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"app.kubernetes.io/name: postgresql"
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Helm-Tests

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="tests--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1962">tests.image</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für das Image der Tests</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/wget",
  "tag": "1.21.2-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="tests--annotations">
        <div style="max-width: 150px;"><a href="../values.yaml#L1968">tests.annotations</a></div>
      </td>
      <td>map</td>
      <td>Annotations, die zusätzlich auf die Tests anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="tests--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1972">tests.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die der Container übernehmen soll.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "runAsGroup": 1001,
  "runAsUser": 1001
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="tests--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1977">tests.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsGroup": 1001,
  "runAsNonRoot": true,
  "runAsUser": 1001
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="tests--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1987">tests.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die für Tests anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"100m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="tests--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1989">tests.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die für Tests anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"32Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="tests--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L1992">tests.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die für Tests anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"50m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="tests--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L1994">tests.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die für Tests anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"16Mi"
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>



### Konfiguration für Demo-Modes

<table>
  <thead>
    <th>Schlüssel</th>
    <th>Typ</th>
    <th>Beschreibung</th>
    <th>Default</th>
  </thead>
  <tbody>
    <tr>
      <td id="demomode--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L2004">demomode.enabled</a></div>
      </td>
      <td>boolean</td>
      <td>Aktivieren des Demoworkflows für Kubernetes ab v1.21.0 Achtung: Der Demomodus setzt per CronJob die Datenbank regelmäßig zurück.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="demomode--mode">
        <div style="max-width: 150px;"><a href="../values.yaml#L2012">demomode.mode</a></div>
      </td>
      <td>string</td>
      <td>Auswahl des Demomodus Folgende Möglichkeiten:   "complete": Es wird die gesamte Datenbank gelöscht und neu erstellt.   "defined": Es wird ein Datenbank-Dump zurück gespielt.              Dieser muss als DB-Dump bereit gestellt werden. (TBD)   "federation": Wie "defined", jedoch mit der Option als Förderationspartner zu fungieren. (TBD)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"complete"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="demomode--interval">
        <div style="max-width: 150px;"><a href="../values.yaml#L2033">demomode.interval</a></div>
      </td>
      <td>string</td>
      <td>Angabe der Laufzeit des Demomodus Nutzung der Crontab-Zeitnotation Die Crontab-Zeitnotation besteht aus fünf oder sechs Stichpunkten, die die Zeitintervalle angeben: Minute (0-59): Die Minute, zu der die Aufgabe ausgeführt werden soll. Stunde (0-23): Die Stunde, zu der die Aufgabe ausgeführt werden soll. Tag des Monats (1-31): Der Tag des Monats, an dem die Aufgabe ausgeführt werden soll. Monat (1-12): Der Monat, in dem die Aufgabe ausgeführt werden soll. Tag der Woche (0-6): Der Tag der Woche, an dem die Aufgabe ausgeführt werden soll (0 steht für Sonntag). (optional) Jahr (z. B. 2023): Das Jahr, in dem die Aufgabe ausgeführt werden soll. Die Stichpunkte können folgende Werte enthalten: Eine konkrete Zahl (z. B. 5): Die Aufgabe wird zu diesem spezifischen Wert ausgeführt. Eine Liste von Zahlen (z. B. 1,3,5): Die Aufgabe wird zu jedem der angegebenen Werte ausgeführt. Ein Bereich von Zahlen (z. B. 1-5): Die Aufgabe wird zu allen Werten im angegebenen Bereich ausgeführt. Eine Schrittgröße (z. B. */10): Die Aufgabe wird in Intervallen entsprechend der angegebenen Schrittgröße ausgeführt. Zusätzlich können spezielle Zeichen verwendet werden: Asterisk (*): Steht für "jeder Wert" und wird verwendet, um anzuzeigen, dass die Aufgabe zu jeder möglichen Zeit ausgeführt werden soll. Komma (,): Trennt mehrere Werte oder Wertebereiche voneinander. Schrägstrich (/): Wird verwendet, um eine Schrittgröße anzugeben. @default 0 0 * * 0, Dies bedeutet, dass die Aufgabe um 0:00 Uhr (Mitternacht) an jedem Sonntag (Tag der Woche = 0) ausgeführt wird</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"0 0 * * 0"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="demomode--existingClaim">
        <div style="max-width: 150px;"><a href="../values.yaml#L2036">demomode.existingClaim</a></div>
      </td>
      <td>string</td>
      <td>existingClaim für PostgreSQL-Dump</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"sqldump"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="demomode--sqldump">
        <div style="max-width: 150px;"><a href="../values.yaml#L2039">demomode.sqldump</a></div>
      </td>
      <td>string</td>
      <td>Postgresql-Dump, welcher auf dem PVC vom PostgreSQL-Server liegt</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"dump.sql"
</pre>
</div>
      </td>
    </tr>
  </tbody>
</table>


----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)