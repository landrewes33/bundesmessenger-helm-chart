# Huddle

> :pushpin: Hinweis: Huddles und BundesMessenger Call befinden sich in
der Beta bzw. Erprobungsphase.

Im BundesMessenger stehen allen Usern sogenannte Huddle für spontane Realtime
Besprechungen in kleinen Gruppen zur Verfügung.
[Zu den Details.](https://gitlab.opencode.de/bwi/bundesmessenger/info/-/blob/main/huddle.md)

Die Funktion der Huddle teilt sich auf technischer Ebene in drei Komponenten:

- Client - [BundesMessenger Call](https://gitlab.opencode.de/bwi/bundesmessenger/clients)
- JWT Token Server - [LiveKit JWT Service](https://github.com/element-hq/lk-jwt-service)
- Server - [LiveKit](https://livekit.io/)

Die Anteile des Clients und JWT Token Server sind Bestandteil diesen Helm Charts
und sind in der [`values.yaml`](../values.yaml) unter `call` konfigurierbar.

Der LiveKit JWT Service stellt sicher, dass nur authentifizierte Benutzer auf
die LiveKit SFU zugreifen. Er prüft die Berechtigung am Homeserver und
stellt den benötigten Token aus um auf die Ressource auf dem LiveKit Server
zugreifen zu können.

Der [LiveKit Server](https://github.com/livekit/livekit) ist die
Selective Forwarding Unit (SFU) und WebRTC-Server.

Er ist nicht Bestandteil diesen Helm Charts und muss separat
installiert werden. Entweder in einem (eigenen) Kubernetes Cluster oder
auf einer anderen Server.

## Funktionsweise

- Der Benutzer (Call-Client) holt sich vom Synapse-Homeserver ein Bearer Token
  - Dies ist notwendig, damit auch Gast-Funktionalitäten/Zugriff zur
  Verfügung gestellt werden kann.
  - API [`POST /_matrix/client/v3/user/{userId}/openid/request_token`](https://spec.matrix.org/v1.11/client-server-api/#post_matrixclientv3useruseridopenidrequest_token)
- Der Benutzer übergibt den Bearer Token an den LiveKit JWT Service
(`POST /sfu/get`)
- Der LiveKit JWT Service prüft den Bearer Token am Homeserver
des Benutzers. Das gilt auch für föderierte Benutzer.
  - Der abgefragte Endpunkt ist
  (`GET matrix://<serverName>/_matrix/federation/v1/openid/userinfo?access_token=<token>`)
  - Das Schema `matrix://` bedeutet, dass der Server via
  [Server Discovery](https://spec.matrix.org/v1.11/server-server-api/#server-discovery)
  ermittelt wird.
- Der LiveKit JWT Service generiert einen LiveKit JWT Token und übergibt
ihn zusammen mit der LiveKit Server URL an den Nutzer. Dafür wird keine Verbindung
(HTTP-Anfrage) zum LiveKit Server benötigt.
- Der Benutzer meldet sich mit dem JWT Token am LiveKit Server an und
stellt mit dem angefragten Huddle Meeting via WebSocket eine Verbindung her.
(`wss://<livekitServer>/rtc`)

## Aufbau

### BundesMessenger Call Client

Der folgende Parameter ist im Bereich `call` der Konfiguration anzugeben:

```yaml
uri: call.example.com
```

In Zukunft:
~~Die URL wird intern für die Bereitstellung des Clients genutzt. Der Benutzer
muss diese Adresse nicht manuell aufrufen.~~

:pushpin: Die weiteren Konfigurationen werden durch das Helm Chart automatisch
bereitgestellt.

Die Call Client [Konfiguration](https://github.com/element-hq/element-call?tab=readme-ov-file#backend)
wird um die LiveKit JWT Service URL in der `config.json` erweitert.

```json
"livekit": {
  "livekit_service_url": "https://call.example.com"
}
```

Der Call Client ruft die notwendigen Informationen während der Nutzung von der
API `POST https://call.example.com/sfu/get` ab.

### LiveKit JWT Service

Es sind folgende Parameter im Bereich `call` der Konfiguration anzugeben:

```yaml
livekit:
  url: "wss://livekit.example.com"
  key: "devkey"
  secret: "secret"
```

Key und Secret sind frei generierbar. Damit werden LiveKit Access Token berechnet.
Mit dem Key und Secret wird auch der LiveKit Server konfiguriert. Beides muss
überein stimmen.

Die LiveKit URL ist die Adresse unter der der LiveKit Server für den Client
erreichbar ist.

| :warning: Wichtig: Betten Sie NIEMALS Ihren API oder geheimen Schlüssel in eine Client-Anwendung ein. Wenn eine nicht vertrauenswürdige Person Zugang zu diesen Schlüsseln erhält, hat sie die volle Kontrolle über die Erstellung oder den Beitritt zu Räumen! In dem unglücklichen Fall, dass Ihre Schlüssel kompromittiert werden, erstellen Sie ein neues Schlüsselpaar. |
| --- |

:pushpin: Die weiteren Konfigurationen werden durch das Helm Chart automatisch
bereitgestellt.

Der LiveKit JWT Service ist ein eigenes Container Image bzw. Kubernetes Service
und wird via Umgebungsvariablen konfiguriert.

- `LIVEKIT_URL`
- `LIVEKIT_KEY_FROM_FILE`
- `LIVEKIT_SECRET_FROM_FILE`

Der LiveKit JWT Service stellt den API Endpunkt `POST /sfu/get` für die Clients
bereit. Über die API bekommt er einen OpenID-Token des Benutzers und den Synapse-Homeserver
mitgeteilt. Beides wird überprüft in dem er den Homeserver abfragt.

```text
GET matrix://<serverName>/_matrix/federation/v1/openid/userinfo?access_token=<token>
```

Das Schema `matrix://` bedeutet, dass der Server via
[Server Discovery](https://spec.matrix.org/v1.11/server-server-api/#server-discovery)
ermittelt wird.

Eine Konfiguration eines HTTP-Proxies ist durch die Umgebungsvariablen
`HTTP_PROXY` und `HTTPS_PROXY` möglich.

### LiveKit Server

Aufbau und Konfiguration vom LiveKit Server wird
[separat beschrieben](./livekit_server.md).

- offizielle [LiveKit Dokumentation](https://docs.livekit.io/realtime/self-hosting/local/)
