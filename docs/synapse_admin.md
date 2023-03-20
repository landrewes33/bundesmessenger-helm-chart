# Installation

Zur Administration mit Hilfe einer Weboberfläche kann
[Synapse-Admin](https://github.com/Awesome-Technologies/synapse-admin)
bereitgestellt werden.

In dem folgenden Beispiel wir zusätzlich zur Synapse Installation Synapse Admin

- aktiviert (`synapse_admin.enabled=true`) und
- eine URL festgelegt (`synapse_admin.uri`).

Die Administrations-Oberfläche ist im Anschluss auf `admin.example.com` erreichbar.
Die Administrations-Oberfläche greift auf die administrativen APIs von Synapse zu.
Der Servername unter dem die API erreichbar wird mit Hilfe von `adminAPIServerName`
konfiguriert. Beides kann auch auf dem selben Servernamen laufen.
Die Admin API `admin.example.com` sollte nicht via Internet erreichbar sein.

```console
helm install bundesmessenger bundesmessenger/bundesmessenger \
  --set serverName=example.com \
  --set adminAPIServerName=admin.example.com \
  --set synapse_admin.enabled=true \
  --set synapse_admin.uri=admin.example.com
```
