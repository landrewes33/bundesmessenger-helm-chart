# Installation

Der BundesMessenger WebClient auf Basis von [Element Web](https://github.com/vector-im/element-web)
kann zusätzlich bereitgestellt werden.

In dem folgenden Beispiel wird zusätzlich zur Synapse Installation der WebClient

- aktiviert (`webclient.enabled=true`) und
- eine URL festgelegt (`webclient.uri`).

Der WebClient ist im Anschluss auf `app.example.com` erreichbar.

```console
helm install bundesmessenger bundesmessenger/bundesmessenger \
  --set serverName=example.com \
  --set webclient.enabled=true \
  --set webclient.uri=app.example.com
```
