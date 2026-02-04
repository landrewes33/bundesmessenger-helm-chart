# LiveKit Server

LiveKit kann in einem Kubernetes Cluster betrieben werden.

- LiveKit nutzt hierfür `NodePorts`.
- Jeder Node sollte nur ein LiveKit Pod bereit stellen.
- Jede Node benötigt eine vom Client erreichbare IP-Adresse.
  - Keine NAT-Adresse des Kubernetes Clusters.
- Zusätzlich zu den LiveKit Pods kann das Cluster weitere
Applikationen bereit stellen.

:pushpin: Die Bereitstellung ist nicht Bestandteil des BundesMessenger Helm Charts.
Die Anleitung dient als Beispiel und zusätzliche Unterstützung.
Je nach Umgebung kann die Bereitstellung auch auf anderem Wege erfolgen.

- [offizielle Dokumentation zur Bereitstellung in einem Kubernetes Cluster](https://docs.livekit.io/realtime/self-hosting/kubernetes/)

## Vorbereitung

- [Installation Nginx Ingress Controller](./installation-testumgebung.md#ingress-controller)
- [Installation Cert Manager](./installation-testumgebung.md#cert-manager)

## Installation

Konfiguration eines minimalen LiveKit Setups:

```yaml
# livekit_values.yaml

replicaCount: 1

# Refer to https://docs.livekit.io/deploy/kubernetes/ for instructions

livekit:
  rtc:
    use_external_ip: true
  # redis:
  #   address: <redis-host>:6379
  keys:
    devkey: "secret"
  turn:
    enabled: false

  # By default, the LiveKit SFU auto-creates rooms for all users.
  # To ensure proper access control disable automatic room creation.
  room:
    auto_create: false

loadBalancer:
  type: do
  # TLS certificate generated automatically with certmanager / letsencrypt
  # secretName is still required. certmanager will place the provisioned
  # certificate in that secret
  clusterIssuer: letsencrypt-prod
  tls:
    - hosts:
        - livekit.example.com
      secretName: livekit-cert-tls
autoscaling:
  enabled: false

resources: {}
```

Folgende Werte sind anzupassen:

- `livekit.keys`
- `loadBalancer.clusterIssuer`
- `loadBalancer.tls.hosts[]`

Der Loadbalancer `loadBalancer.type: do` erzeugt einen Ingress.
Der Cert Manager stellt für diesen das TLS-Zertifikat aus.
Der Ingress nimmt die Anfragen per `HTTPS/TCP443` entgegen und routet
sie weiter an den LiveKit Server `TCP7880`.

Auf dem im Ingress definierten Host (hier `livekit.example.com`)
muss ein DNS Eintrag auf die IP-Adresse des Nginx Ingress zeigen.

Start der Installation:

```sh
helm repo add livekit https://helm.livekit.io
helm repo update

helm upgrade --install livekit livekit/livekit-server \
  --namespace livekit --create-namespace \
  --values livekit_values.yaml
```

## Tests

LiveKit besitzt ein [Command Line Tool](https://docs.livekit.io/realtime/cli-setup/)
mit dem Last auf dem Server bzw. in den Huddles (Räume) erzeugt
werden kann.

:warning: Das Ausrufezeichen (`!`) in der Raum ID muss auf der Kommandozeile
mit einem Backslash `\` escaped werden.

Beispiele

Ein weiterer Teilnehmer im Huddle (`join-room`):

```sh
./livekit-cli join-room --url wss://livekit.example.com \
  --api-key devkey --api-secret secret \
  --room <roomID>:<matrixServerName> \
  --identity bot-user --publish-demo
```

Weitere 20 Teilnehmer in einem Raum (`load-test`):

```sh
./livekit-cli load-test --url wss://livekit.example.com \
  --api-key devkey --api-secret secret \
  --room <roomID>:<matrixServerName> \
  --video-publishers 20
```

## Anmerkungen

- Der LiveKit Server stellt auf Port `7880` eine unverschlüsselte
WebSocket Verbindung bereit `ws://`
- Der Nginx Ingress stellt die Verbindung auf Port `443` bereit.
- Die Clients Verbinden sich mit dem Ingress per WebSocket `wss://`
- Der Nginx Ingress terminiert die TLS-Verbindung und führt die initiale
Lastverteilung auf die LiveKit Pods bereit.
- Aktuell erfolgte die Bereitstellung auf einem Single-Node Cluster
- Redis wurde bisher nicht bereit gestellt
