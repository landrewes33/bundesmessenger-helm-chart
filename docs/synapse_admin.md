# Installation

Zur Administration mit Hilfe einer Weboberfläche kann
[Synapse-Admin](https://github.com/Awesome-Technologies/synapse-admin) bereitgestellt werden.

In dem folgenden Beispiel wir zusätzlich zur Synapse Installation Synapse Admin
- aktiviert (`synapse_admin.enabled=true`) und
- eine URL festgelegt (`synapse_admin.adminUri`).

Die Administrations-Oberfläche ist im Anschluss auf `admin.example.com` erreichbar.

```console
helm install bundesmessenger bundesmessenger/bundesmessenger \
  --set serverName=example.com \
  --set synapse_admin.enabled=true \
  --set synapse_admin.adminUri=admin.example.com
```
