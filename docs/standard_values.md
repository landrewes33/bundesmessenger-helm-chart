# bundesmessenger

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.78.0](https://img.shields.io/badge/AppVersion-1.78.0-informational?style=flat-square)

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
| https://charts.bitnami.com/bitnami | postgresql | ^12.1.6 |
| https://charts.bitnami.com/bitnami | redis | ^17.3.17 |

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
      <td id="image--nameOverride">
        <div style="max-width: 150px;"><a href="../values.yaml#L28">image.nameOverride</a></div>
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
      <td id="image--fullnameOverride">
        <div style="max-width: 150px;"><a href="../values.yaml#L31">image.fullnameOverride</a></div>
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
      <td>Eine URL unter der der Nutzer sich Datenschutzbestimmungen einsehen kann. Diese Datenschutzbestimmungen muss jeder Anbieter selbst dem Nutzer zur Verfügung stellen. Die Mobil-Apps nutzen dies, um die Datenschutzbestimmungen per Webaufruf dem Nutzer anzeigen zu lassen.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
Nicht gesetzt, aber Voraussetzung!
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="adminAPIServerName">
        <div style="max-width: 150px;"><a href="../values.yaml#L56">adminAPIServerName</a></div>
      </td>
      <td>string</td>
      <td>Der Servername für die Admin-API  "/_synapse/admin" und alle anderen APIs, die für alle administrativen Konfigurationen im Ingress verwendet werden. Wenn synapse_admin.enable ist und synapse_admin.uri unterschiedlich von adminAPIServerName, dann wird dort nur der Synapse_admin erreichbar sein. Schnittstellen zum konfigurieren, werden nur über adminAPIServerName zur Verfügung gestellt. @default  -- Nicht gesetzt, aber Voraussetzung!</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="monitoringService">
        <div style="max-width: 150px;"><a href="../values.yaml#L60">monitoringService</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des Monitoringservices für Synapse-Dienste in Prometheus</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="displayName">
        <div style="max-width: 150px;"><a href="../values.yaml#L64">displayName</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L82">signingkey.job.enabled</a></div>
      </td>
      <td>bool</td>
      <td>es wird ein Job zu Beginn des Deployments gestartet, der einen Signierschlüssel erzeugt. Wenn abgeschaltet, muss ein vorhandener Schlüssel eingebunden werden, ansonsten ist eine Förderation als nicht vertrauenswürdig eingestuft</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--job--generateImage--repository">
        <div style="max-width: 150px;"><a href="../values.yaml#L89">signingkey.job.generateImage.repository</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L93">signingkey.job.generateImage.pullSecrets</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L96">signingkey.job.generateImage.pullPolicy</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L99">signingkey.job.publishImage</a></div>
      </td>
      <td>map</td>
      <td>Repository/Image Konfiguration für den Upload des generierten Signing-Schlüssels. finaler Tag kann sich noch ändern</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/kubectl",
  "tag": "1.25.4-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="signingkey--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L111">signingkey.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L112">signingkey.resources.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L114">signingkey.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L115">signingkey.resources.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L123">ipv4Only</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L139">config.logLevel</a></div>
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
      <td id="config--logLevelSQL">
        <div style="max-width: 150px;"><a href="../values.yaml#L144">config.logLevelSQL</a></div>
      </td>
      <td>string</td>
      <td>Das Loglevel für `synapse.storage.SQL`. Achtung: Wenn dieser Wert auf `DEBUG` erhöht wird, werden alle SQL-Abfragen protokolliert. Diese enthalten sensible Informationen wie z.B. Zugriffstoken.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"INFO"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--reportStats">
        <div style="max-width: 150px;"><a href="../values.yaml#L147">config.reportStats</a></div>
      </td>
      <td>bool</td>
      <td>Nutzungsstatistiken (siehe extraConfig.reportStats)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="config--turnUris">
        <div style="max-width: 150px;"><a href="../values.yaml#L158">config.turnUris</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L165">config.enableRegistration</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L168">config.registrationSharedSecret</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L171">config.macaroonSecretKey</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L175">config.trustedKeyServers</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L181">config.extraListeners</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L189">extraConfig</a></div>
      </td>
      <td>object</td>
      <td>Best Practise BWI GmbH: Ref: https://github.com/matrix-org/synapse/blob/develop/docs/sample_config.yaml</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
wird nachfolgend aufgeschlüsselt
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--require_auth_for_profile_requests">
        <div style="max-width: 150px;"><a href="../values.yaml#L193">extraConfig.require_auth_for_profile_requests</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L195">extraConfig.limit_profile_requests_to_users_who_share_rooms</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L197">extraConfig.include_profile_data_on_invite</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L199">extraConfig.allow_public_rooms_without_auth</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L201">extraConfig.allow_public_rooms_over_federation</a></div>
      </td>
      <td>bool</td>
      <td>öffentliche Räume über Förderation erlauben, abgeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--block_non_admin_invites">
        <div style="max-width: 150px;"><a href="../values.yaml#L203">extraConfig.block_non_admin_invites</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L205">extraConfig.ip_range_whitelist</a></div>
      </td>
      <td>list</td>
      <td>IP-Whitelist für Förderation zwingend benötigt</td>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L208">extraConfig.presence.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Anwesenheitstatus anzeigen, abgeschaltet (Load)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--enable_search">
        <div style="max-width: 150px;"><a href="../values.yaml#L210">extraConfig.enable_search</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L213">extraConfig.user_directory.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L215">extraConfig.user_directory.search_all_users</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L217">extraConfig.require_membership_for_aliases</a></div>
      </td>
      <td>bool</td>
      <td>Alias nur für registrierte Nutzer (sowieso, nicht authentifizierte Nutzer sind abgeschaltet)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--user_ips_max_age">
        <div style="max-width: 150px;"><a href="../values.yaml#L219">extraConfig.user_ips_max_age</a></div>
      </td>
      <td>string</td>
      <td>Maximale Speicherzeit für IPs von Nutzern (Whitelist mapping)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"28d"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--retention--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L222">extraConfig.retention.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L224">extraConfig.url_preview_enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L227">extraConfig.oembed.disable_default_providers</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L229">extraConfig.enable_3pid_lookup</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L231">extraConfig.allow_guest_access</a></div>
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
      <td id="extraConfig--enable_metrics">
        <div style="max-width: 150px;"><a href="../values.yaml#L233">extraConfig.enable_metrics</a></div>
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
      <td id="extraConfig--report_stats">
        <div style="max-width: 150px;"><a href="../values.yaml#L235">extraConfig.report_stats</a></div>
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
      <td id="extraConfig--password_config">
        <div style="max-width: 150px;"><a href="../values.yaml#L238">extraConfig.password_config</a></div>
      </td>
      <td>object</td>
      <td>Passwortkonfiguration</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
folgende Aufschlüsselung
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L240">extraConfig.password_config.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Passwortkonfiguration selbst definieren, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--localdb_enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L242">extraConfig.password_config.localdb_enabled</a></div>
      </td>
      <td>bool</td>
      <td>lokale Nutzerdatenbank, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--password_config--policy--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L245">extraConfig.password_config.policy.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L247">extraConfig.password_config.policy.minimum_length</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L249">extraConfig.password_config.policy.require_digit</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L251">extraConfig.password_config.policy.require_symbol</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L253">extraConfig.password_config.policy.require_lowercase</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L255">extraConfig.password_config.policy.require_uppercase</a></div>
      </td>
      <td>bool</td>
      <td>Großbuchstaben muss genutz werden</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--ui_auth--session_timeout">
        <div style="max-width: 150px;"><a href="../values.yaml#L258">extraConfig.ui_auth.session_timeout</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L261">extraConfig.push.include_content</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L263">extraConfig.encryption_enabled_by_default_for_room_type</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L266">extraConfig.stats.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Schalte Nutzerstatistiken ein, eingeschaltet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--enable_room_list_search">
        <div style="max-width: 150px;"><a href="../values.yaml#L268">extraConfig.enable_room_list_search</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L274">extraConfig.opentracing.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L276">extraConfig.federation_domain_whitelist</a></div>
      </td>
      <td>list</td>
      <td>Whitelist (Domainbased) für Föderation</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="extraConfig--dynamic_thumbnails">
        <div style="max-width: 150px;"><a href="../values.yaml#L281">extraConfig.dynamic_thumbnails</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L289">extraSecrets</a></div>
      </td>
      <td>map</td>
      <td>Geben Sie hier eine beliebige - geheime - Synapse-Konfiguration an; Diese Werte werden in Secrets anstelle von Configmaps gespeichert Ref: https://github.com/matrix-org/synapse/blob/develop/docs/sample_config.yaml Beispiel:  password_config:    pepper: ""</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse">
        <div style="max-width: 150px;"><a href="../values.yaml#L293">synapse</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L300">synapse.strategy.type</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L307">synapse.annotations</a></div>
      </td>
      <td>map</td>
      <td>Annotations, die auf den Haupt-Synapse-Container anzuwenden sind. Beispiel: (Bundesmessenger lässt alle Services automatisch an Prometheus anbinden)  prometheus.io/scrape: "true"  prometheus.io/path: "/_synapse/metrics"  prometheus.io/port: "9090"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--labels">
        <div style="max-width: 150px;"><a href="../values.yaml#L310">synapse.labels</a></div>
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
      <td id="synapse--extraEnv">
        <div style="max-width: 150px;"><a href="../values.yaml#L318">synapse.extraEnv</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Umgebungsvariablen, die auf den Haupt-Synapse-pod anzuwenden sind Beispiel:  - name: LD_PRELOAD    value: /usr/lib/x86_64-linux-gnu/libjemalloc.so.2  - name: SYNAPSE_CACHE_FACTOR    value: "2"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--extraVolumes">
        <div style="max-width: 150px;"><a href="../values.yaml#L329">synapse.extraVolumes</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L335">synapse.extraVolumeMounts</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L341">synapse.extraCommands</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L347">synapse.podSecurityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L355">synapse.securityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L377">synapse.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L379">synapse.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den Haupt-Synapse-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"2500Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="synapse--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L382">synapse.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L384">synapse.resources.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L391">synapse.livenessProbe.httpGet.path</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L393">synapse.livenessProbe.httpGet.port</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L400">synapse.readinessProbe.httpGet.path</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L402">synapse.readinessProbe.httpGet.port</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L407">synapse.startupProbe.failureThreshold</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L411">synapse.startupProbe.httpGet.path</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L414">synapse.startupProbe.httpGet.port</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L418">synapse.nodeSelector</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L445">synapse.tolerations</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L448">synapse.affinity</a></div>
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
      <td id="workers--annotations">
        <div style="max-width: 150px;"><a href="../values.yaml#L464">workers.annotations</a></div>
      </td>
      <td>map</td>
      <td>Annotations, die auf die Synapse-Worker-Container anzuwenden sind. Standardkonfiguration, diese wird an alle Worker vererbt und kann auch für jeden Workertyp überschrieben werden. Beispiel: (Bundesmessenger lässt alle Services automatisch an Prometheus anbinden)  prometheus.io/scrape: "true"  prometheus.io/path: "/_synapse/metrics"  prometheus.io/port: "9090"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--replicaCount">
        <div style="max-width: 150px;"><a href="../values.yaml#L470">workers.default.replicaCount</a></div>
      </td>
      <td>int</td>
      <td>DEFAULT Die Anzahl der Worker-Replikate. Beachten Sie, dass einige Worker eine besondere Behandlung erfordern. Siehe dazu die Informations-URL https://github.com/matrix-org/synapse/blob/master/docs/workers.md</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
1
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--strategy--type">
        <div style="max-width: 150px;"><a href="../values.yaml#L478">workers.default.strategy.type</a></div>
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
      <td id="workers--default--annotations">
        <div style="max-width: 150px;"><a href="../values.yaml#L493">workers.default.annotations</a></div>
      </td>
      <td>map</td>
      <td>DEFAULT Annotations, die auf alle Synapse-Worker-Container anzuwenden sind. Beispiel: (Bundesmessenger lässt alle Services automatisch an Prometheus anbinden)  prometheus.io/scrape: "true"  prometheus.io/path: "/_synapse/metrics"  prometheus.io/port: "9090"</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--extraEnv">
        <div style="max-width: 150px;"><a href="../values.yaml#L501">workers.default.extraEnv</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L507">workers.default.volumes</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L511">workers.default.volumeMounts</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L518">workers.default.extraCommands</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L526">workers.default.podSecurityContext</a></div>
      </td>
      <td>map</td>
      <td>Informationen zum Sicherheitskontext, die den Workern mitgeteilt werden sollen. DEFAULT gilt für alle Synapse-Worker-Container. Beispiele:   fsGroup: 2003   runAsGroup: 2003   runAsUser: 2003</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L537">workers.default.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie DEFAULT gilt für alle Synapse-Worker-Container. Beispiele:   readOnlyRootFilesystem: true   runAsNonRoot: true   runAsUser: 2003   capabilities:     drop:       - ALL</td>
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
      <td id="workers--default--resources--limits--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L546">workers.default.resources.limits.cpu</a></div>
      </td>
      <td>string</td>
      <td>Rechenressourcengrenzen, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container. Empfohlen gesondert zu verwalten</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"500m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--resources--limits--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L550">workers.default.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container. Empfohlen gesondert zu verwalten</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"200Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L555">workers.default.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L559">workers.default.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf alle Synapse-Worker-Container anzuwenden sind. DEFAULT gilt für alle Synapse-Worker-Container. Empfohlen gesondert zu verwalten</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"128Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--default--livenessProbe--periodSeconds">
        <div style="max-width: 150px;"><a href="../values.yaml#L563">workers.default.livenessProbe.periodSeconds</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L567">workers.default.livenessProbe.httpGet.path</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L570">workers.default.livenessProbe.httpGet.port</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L574">workers.default.readinessProbe.periodSeconds</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L578">workers.default.readinessProbe.httpGet.path</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L581">workers.default.readinessProbe.httpGet.port</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L586">workers.default.startupProbe.failureThreshold</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L590">workers.default.startupProbe.httpGet.path</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L593">workers.default.startupProbe.httpGet.port</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L597">workers.default.nodeSelector</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L601">workers.default.tolerations</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L605">workers.default.affinity</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L614">workers.generic_worker.enabled</a></div>
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
      <td id="workers--generic_worker--generic">
        <div style="max-width: 150px;"><a href="../values.yaml#L618">workers.generic_worker.generic</a></div>
      </td>
      <td>bool</td>
      <td>Aktivieren des generischen Workers (kann alle Aufgaben übernehmen) spezifische Aufgaben können spezifischen Workern übergeben werden z.B. Media Repo</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L620">workers.generic_worker.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "readOnlyRootFilesystem": true,
  "runAsNonRoot": true,
  "runAsUser": 2003
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--generic_worker--listeners">
        <div style="max-width: 150px;"><a href="../values.yaml#L625">workers.generic_worker.listeners</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L628">workers.generic_worker.csPaths</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L705">workers.generic_worker.paths</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L733">workers.generic_worker.replicaCount</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L740">workers.generic_worker.autoscaling.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L742">workers.generic_worker.autoscaling.minReplicas</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L744">workers.generic_worker.autoscaling.maxReplicas</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L746">workers.generic_worker.autoscaling.targetCPUUtilizationPercentage</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L748">workers.generic_worker.autoscaling.targetMemoryUtilizationPercentage</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L759">workers.federation_reader.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Aktiviere spez. Worker für Förderationsanfragen Wenn dieser Worker genutzt wird, können die URLs aus dem generic_worker entfernt werden.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--federation_reader--generic">
        <div style="max-width: 150px;"><a href="../values.yaml#L761">workers.federation_reader.generic</a></div>
      </td>
      <td>bool</td>
      <td>Wird aus dem generischen Worker abgeleitet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--federation_reader--listeners">
        <div style="max-width: 150px;"><a href="../values.yaml#L763">workers.federation_reader.listeners</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Listener für Förderationsworker</td>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L766">workers.federation_reader.paths</a></div>
      </td>
      <td>path</td>
      <td>Server-Side Pfade für die Ingress-Konfiguration des Förderations-Workers</td>
      <td>
        <div style="max-width: 300px;"><pre lang="">
werden in der values.yaml gesetzt und können dort eingesehen werden
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--pusher--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L795">workers.pusher.enabled</a></div>
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
      <td id="workers--pusher--generic">
        <div style="max-width: 150px;"><a href="../values.yaml#L797">workers.pusher.generic</a></div>
      </td>
      <td>bool</td>
      <td>Wird aus dem generischen Worker abgeleitet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--appservice--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L802">workers.appservice.enabled</a></div>
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
      <td id="workers--appservice--generic">
        <div style="max-width: 150px;"><a href="../values.yaml#L804">workers.appservice.generic</a></div>
      </td>
      <td>bool</td>
      <td>Wird aus dem generischen Worker abgeleitet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--federation_sender--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L809">workers.federation_sender.enabled</a></div>
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
      <td id="workers--federation_sender--generic">
        <div style="max-width: 150px;"><a href="../values.yaml#L811">workers.federation_sender.generic</a></div>
      </td>
      <td>bool</td>
      <td>Wird aus dem generischen Worker abgeleitet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L817">workers.media_repository.enabled</a></div>
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
      <td id="workers--media_repository--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L820">workers.media_repository.securityContext</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für die Container-Sicherheitsrichtlinie des generischen Workers Überschreibt die Konfiguration von Default und generischen Worker</td>
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
      <td id="workers--media_repository--listeners">
        <div style="max-width: 150px;"><a href="../values.yaml#L825">workers.media_repository.listeners</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L828">workers.media_repository.csPaths</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L838">workers.media_repository.paths</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L843">workers.media_repository.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L845">workers.media_repository.resources.limits.memory</a></div>
      </td>
      <td>string</td>
      <td>RAM Ressourcengrenzen, die auf den media_repository-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"3500Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--resources--requests--cpu">
        <div style="max-width: 150px;"><a href="../values.yaml#L848">workers.media_repository.resources.requests.cpu</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an Rechenressourcen, die auf den media_repository-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"1000m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--media_repository--resources--requests--memory">
        <div style="max-width: 150px;"><a href="../values.yaml#L850">workers.media_repository.resources.requests.memory</a></div>
      </td>
      <td>string</td>
      <td>Anforderungen an RAM Ressourcen, die auf den media_repository-Container anzuwenden sind.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"2500Mi"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--user_dir--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L859">workers.user_dir.enabled</a></div>
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
      <td id="workers--user_dir--generic">
        <div style="max-width: 150px;"><a href="../values.yaml#L861">workers.user_dir.generic</a></div>
      </td>
      <td>bool</td>
      <td>Wird aus dem generischen Worker abgeleitet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="workers--user_dir--listeners">
        <div style="max-width: 150px;"><a href="../values.yaml#L863">workers.user_dir.listeners</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L866">workers.user_dir.csPaths</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L872">workers.background_worker.enabled</a></div>
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
      <td id="workers--background_worker--generic">
        <div style="max-width: 150px;"><a href="../values.yaml#L874">workers.background_worker.generic</a></div>
      </td>
      <td>bool</td>
      <td>Wird aus dem generischen Worker abgeleitet</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
true
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="persistence--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L881">persistence.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L884">persistence.existingClaim</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L886">persistence.storageClass</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L888">persistence.accessMode</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L890">persistence.size</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L896">volumePermissions.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L899">volumePermissions.uid</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L902">volumePermissions.gid</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L906">volumePermissions.image.repository</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L909">volumePermissions.image.tag</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L911">volumePermissions.image.pullPolicy</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L920">volumePermissions.resources</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L928">service.type</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L930">service.port</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L932">service.targetPort</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L941">sygnal.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L943">sygnal.image</a></div>
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
      <td id="sygnal--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L958">sygnal.podSecurityContext</a></div>
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
      <td id="sygnal--proxy">
        <div style="max-width: 150px;"><a href="../values.yaml#L960">sygnal.proxy</a></div>
      </td>
      <td>string</td>
      <td>Proxy, falls benötigt um die Push-Services zu erreichen. Auskommentieren oder leer für Deaktivierung</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--securityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L969">sygnal.securityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L977">sygnal.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L979">sygnal.resources.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L982">sygnal.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L984">sygnal.resources.requests.memory</a></div>
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
      <td id="sygnal--livenessProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L990">sygnal.livenessProbe.httpGet.path</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L992">sygnal.livenessProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Zu verwendende Konfiguration für den Port des Healthchecks</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"http"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--readinessProbe--httpGet--path">
        <div style="max-width: 150px;"><a href="../values.yaml#L998">sygnal.readinessProbe.httpGet.path</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1000">sygnal.readinessProbe.httpGet.port</a></div>
      </td>
      <td>string</td>
      <td>Konfiguration des Ports vom Bereitschaftscheck</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"http"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--nodeSelector">
        <div style="max-width: 150px;"><a href="../values.yaml#L1003">sygnal.nodeSelector</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1006">sygnal.tolerations</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1009">sygnal.affinity</a></div>
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
      <td id="sygnal--apns">
        <div style="max-width: 150px;"><a href="../values.yaml#L1017">sygnal.apns</a></div>
      </td>
      <td>object</td>
      <td>APN-Konfigurationsteil Beispiel: apns:    de.opencode.dvs.ios:      type: apns      keyfile: /de.opencode.dvs.ios.p8</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--ios_push--enabled">
        <div style="max-width: 150px;"><a href="../values.yaml#L1022">sygnal.ios_push.enabled</a></div>
      </td>
      <td>bool</td>
      <td>iOS-Push Schalter Wenn iOS Push mit genutzt wird, muss hier der Schalter dafür auf true gesetzt werden, sonst schlägt das Modul fehl</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--ios_push--ioskey_filename">
        <div style="max-width: 150px;"><a href="../values.yaml#L1029">sygnal.ios_push.ioskey_filename</a></div>
      </td>
      <td>map</td>
      <td>iOS-Key Konfiguration bei Nutzung von iOS-Pushservice, muss Key mit angebeben werden. Weitereres siehe README.md Beispiel:  ioskey_filename: de.opencode.dvs.ios.p8 <<-- muss zwingend mit dem Keyfile-Dateinamen aus dem APN-File übereinstimmen!  ioskey_keyvalue: 'HIER KÖNNTE IHR KEY IN STEHEN'</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
""
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="sygnal--ios_push--ioskey_keyvalue">
        <div style="max-width: 150px;"><a href="../values.yaml#L1030">sygnal.ios_push.ioskey_keyvalue</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1042">wellknown.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1047">wellknown.server</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1061">wellknown.client</a></div>
      </td>
      <td>object</td>
      <td>Daten, die auf .well-known/matrix/client bereitgestellt werden sollen Die Angabe des Objektes de.bwi{data_privacy_url: https://dsgvo.example.com} ist verpflichtend, wenn keine .Values.dataPrivacyUrl angegeben wurde und auf den WellKnown-Server verzichtet wird. Beispiel:  io.element.e2ee:    secure_backup_required: true    secure_backup_setup_methods: ["passphrase"]    outbound_keys_pre_sharing_mode: "on_room_opening"  m.homeserver:    base_url: https://matrix.example.com  de.bwi:    data_privacy_url: https://dsgvo.example.com</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--extraData">
        <div style="max-width: 150px;"><a href="../values.yaml#L1072">wellknown.extraData</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1076">wellknown.htdocsPath</a></div>
      </td>
      <td>path</td>
      <td>Ein benutzerdefinierter htdocs-Pfad, der nützlich ist, wenn ein anderes Image ausgeführt wird. @default /usr/share/nginx/html (nginx)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"/usr/share/nginx/html"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1082">wellknown.image</a></div>
      </td>
      <td>map</td>
      <td>Das Webserver Image optional: pullSecrets:   - myRegistryKeySecretName</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/nginx",
  "tag": "1.18.0-6ubuntu14.3-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="wellknown--podSecurityContext">
        <div style="max-width: 150px;"><a href="../values.yaml#L1090">wellknown.podSecurityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1099">wellknown.securityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1107">wellknown.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1109">wellknown.resources.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1112">wellknown.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1114">wellknown.resources.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1117">wellknown.nodeSelector</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1120">wellknown.tolerations</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1123">wellknown.affinity</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1137">postgresql.enabled</a></div>
      </td>
      <td>bool</td>
      <td>Diese Konfiguration ist für die Einrichtung des intern bereitgestellten Postgres-Servers gedacht, Wenn Sie stattdessen einen vorhandenen Server verwenden wollen, sollten Sie enabled auf false setzen und den externalPostgresql-Block konfigurieren. @default: false da externe DB vorausgesetzt wird</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
false
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--image">
        <div style="max-width: 150px;"><a href="../values.yaml#L1141">postgresql.image</a></div>
      </td>
      <td>map</td>
      <td>Das PostgreSQL Image @default: WIRD NICHT EMPFOHLEN!!</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "registry": "registry.opencode.de",
  "repository": "ig-bvc/demo-apps/postgresql/postgres",
  "tag": "14"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="postgresql--auth--database">
        <div style="max-width: 150px;"><a href="../values.yaml#L1149">postgresql.auth.database</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1152">postgresql.auth.username</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1155">postgresql.auth.password</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1159">postgresql.auth.existingSecret</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1163">postgresql.auth.secretKeys.userPasswordKey</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1166">postgresql.auth.secretKeys.adminPasswordKey</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1171">postgresql.primary.initdb.args</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1176">postgresql.primary.extendedConfiguration</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1180">postgresql.primary.persistence</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1187">postgresql.primary.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1189">postgresql.primary.resources.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1192">postgresql.primary.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1194">postgresql.primary.resources.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1198">postgresql.extraArgs</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Argumente für die Datenbankverbindung ref: https://github.com/matrix-org/synapse/blob/develop/docs/postgres.md#synapse-config</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="externalPostgresql">
        <div style="max-width: 150px;"><a href="../values.yaml#L1204">externalPostgresql</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1208">externalPostgresql.database</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1211">externalPostgresql.username</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1214">externalPostgresql.password</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1217">externalPostgresql.existingSecret</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1220">externalPostgresql.existingSecretPasswordKey</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1226">externalPostgresql.extraArgs</a></div>
      </td>
      <td>list</td>
      <td>Zusätzliche Argumente für die Datenbankverbindung ref: https://github.com/matrix-org/synapse/blob/develop/docs/postgres.md#synapse-config</td>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1238">redis.image.registry</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1239">redis.image.repository</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1240">redis.image.tag</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1245">redis.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1249">redis.auth</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1257">redis.sysctl</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1280">redis.architecture</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1282">redis.master.kind</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1287">redis.master.persistence.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1291">redis.master.service.ports.redis</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1296">redis.master.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1298">redis.master.resources.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1301">redis.master.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1303">redis.master.resources.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1312">externalRedis</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1331">ingress.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1335">ingress.traefikPaths</a></div>
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
      <td id="ingress--annotations--"nginx--ingress--kubernetes--io/use-regex"">
        <div style="max-width: 150px;"><a href="../values.yaml#L1341">ingress.annotations."nginx.ingress.kubernetes.io/use-regex"</a></div>
      </td>
      <td>bool</td>
      <td>Annotiation um Regex-Regeln nutzen zu können</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"true"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--annotations--"nginx--ingress--kubernetes--io/proxy-body-size"">
        <div style="max-width: 150px;"><a href="../values.yaml#L1343">ingress.annotations."nginx.ingress.kubernetes.io/proxy-body-size"</a></div>
      </td>
      <td>string</td>
      <td>Annotiation, um Body-size zu vergößern (Default Limit 1 oder 10MB)</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"50m"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--annotations--"nginx--ingress--kubernetes--io/enable-owasp-core-rules"">
        <div style="max-width: 150px;"><a href="../values.yaml#L1344">ingress.annotations."nginx.ingress.kubernetes.io/enable-owasp-core-rules"</a></div>
      </td>
      <td>string</td>
      <td></td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
"true"
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="ingress--csHosts">
        <div style="max-width: 150px;"><a href="../values.yaml#L1353">ingress.csHosts</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1360">ingress.hosts</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1367">ingress.wkHosts</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1384">ingress.paths</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1401">ingress.csPaths</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1404">ingress.includeUnderscoreSynapse</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1408">ingress.includeServerName</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1420">ingress.tls</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1425">ingress.className</a></div>
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



### Konfiguration für Content-Scanner

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
        <div style="max-width: 150px;"><a href="../values.yaml#L1433">contentscanner.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1435">contentscanner.image</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration des Image/Repository</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/content-scanner",
  "tag": "1.0.3-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="contentscanner--replicaCount">
        <div style="max-width: 150px;"><a href="../values.yaml#L1440">contentscanner.replicaCount</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1444">contentscanner.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1446">contentscanner.resources.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1449">contentscanner.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1451">contentscanner.resources.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1457">contentscanner.podSecurityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1466">contentscanner.securityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1476">schadcodescanner.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1478">schadcodescanner.imageclamav</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration des ClamAV-Image/Repository</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/clamav",
  "tag": "0.103.8_dfsg-0ubuntu0.22.04.1-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--imagecicap">
        <div style="max-width: 150px;"><a href="../values.yaml#L1483">schadcodescanner.imagecicap</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1490">schadcodescanner.persistence.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1493">schadcodescanner.persistence.existingClaim</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1495">schadcodescanner.persistence.storageClass</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1497">schadcodescanner.persistence.accessMode</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1499">schadcodescanner.persistence.size</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1509">schadcodescanner.extraEnv</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1514">schadcodescanner.service.port</a></div>
      </td>
      <td>int</td>
      <td>der Port des ClamAV Pods, wird im Service übertragen @default: 1344 der Port vom c-icap-Server</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
1344
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--freshclam--mirrors">
        <div style="max-width: 150px;"><a href="../values.yaml#L1522">schadcodescanner.freshclam.mirrors</a></div>
      </td>
      <td>list</td>
      <td>Eine Liste von clamav-Spiegeln, die vom freshclam-Dienst verwendet werden sollen. Erzeugt eine Liste von "PrivateMirror" in der freshclam.conf https://docs.clamav.net/appendix/CvdPrivateMirror.html#use-freshclam-to-serve-only-whole-database-files-from-a-private-mirror Der Standard-Updateserver ("DatabaseMirror") ist "database.clamav.net" und wird durch das Konfigurieren eines privaten Mirros automatisch überschrieben.</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
[]
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="schadcodescanner--replicaCount">
        <div style="max-width: 150px;"><a href="../values.yaml#L1527">schadcodescanner.replicaCount</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1534">schadcodescanner.autoscaling.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1536">schadcodescanner.autoscaling.minReplicas</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1538">schadcodescanner.autoscaling.maxReplicas</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1540">schadcodescanner.autoscaling.targetCPUUtilizationPercentage</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1542">schadcodescanner.autoscaling.targetMemoryUtilizationPercentage</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1546">schadcodescanner.limits.fileSize</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1548">schadcodescanner.limits.scanSize</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1550">schadcodescanner.limits.connectionQueueLength</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1552">schadcodescanner.limits.maxThreads</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1554">schadcodescanner.limits.sendBufTimeout</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1559">schadcodescanner.resourcesClamav.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1561">schadcodescanner.resourcesClamav.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1564">schadcodescanner.resourcesClamav.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1566">schadcodescanner.resourcesClamav.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1571">schadcodescanner.resourcesCicap.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1573">schadcodescanner.resourcesCicap.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1576">schadcodescanner.resourcesCicap.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1578">schadcodescanner.resourcesCicap.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1583">schadcodescanner.podSecurityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1591">schadcodescanner.clamavSecurityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1601">schadcodescanner.icapSecurityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1618">coturn.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1625">coturn.turnUris</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1629">coturn.existingcoturn.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1631">coturn.default_ns</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1633">coturn.image</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1638">coturn.securityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1651">synapse_admin.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1653">synapse_admin.uri</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1655">synapse_admin.image</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1664">synapse_admin.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1666">synapse_admin.resources.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1669">synapse_admin.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1671">synapse_admin.resources.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1677">synapse_admin.podSecurityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1685">synapse_admin.securityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1720">webclient.enabled</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1722">webclient.uri</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1724">webclient.image</a></div>
      </td>
      <td>map</td>
      <td>Konfiguration für das Image vom Element-Webclient</td>
      <td>
        <div style="max-width: 300px;"><pre lang="json">
{
  "pullPolicy": "IfNotPresent",
  "repository": "registry.opencode.de/bwi/bundesmessenger/backend/container-images/bundesmessenger-web",
  "tag": "2.4.0-jammy-production"
}
</pre>
</div>
      </td>
    </tr>
    <tr>
      <td id="webclient--annotations--"nginx--ingress--kubernetes--io/configuration-snippet"">
        <div style="max-width: 150px;"><a href="../values.yaml#L1729">webclient.annotations."nginx.ingress.kubernetes.io/configuration-snippet"</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1738">webclient.podSecurityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1747">webclient.securityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1755">webclient.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1757">webclient.resources.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1760">webclient.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1762">webclient.resources.requests.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1771">tests.image</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1777">tests.annotations</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1781">tests.podSecurityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1786">tests.securityContext</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1796">tests.resources.limits.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1798">tests.resources.limits.memory</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1801">tests.resources.requests.cpu</a></div>
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
        <div style="max-width: 150px;"><a href="../values.yaml#L1803">tests.resources.requests.memory</a></div>
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


----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)