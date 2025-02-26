# Synapse-Admin

| :pushpin: Synapse-Admin wird in Zukunft durch das [BundesMessenger Admin-Portal](./admin_portal.md) abgelöst werden. |
| --- |

Zur Administration mit Hilfe einer Weboberfläche kann
[Synapse-Admin](https://github.com/Awesome-Technologies/synapse-admin)
mit dem Helm Chart installiert werden.

In dem folgenden Beispiel wird zusätzlich zur Synapse-Installation Synapse-Admin

- aktiviert (`synapse_admin.enabled=true`) und
- eine URL festgelegt (`synapse_admin.uri`).

```console
helm install bundesmessenger bundesmessenger/bundesmessenger \
  --set serverName=example.com \
  --set adminAPIServerName=admin.example.com \
  --set synapse_admin.enabled=true \
  --set synapse_admin.uri=adminportal.example.com
```

Die Administrationsoberfläche ist im Anschluss unter der für `synapse_admin.uri`
angegebenen URL erreichbar (hier: `adminportal.example.com`).

Die beim Login auf der Administrationsoberfläche wird neben dem
Benutzernamen und Passwort eines Synapse Administrators auch die
URL mit den administrativen API Endpunkten angegeben. Diese
wird mit `adminAPIServerName` (hier: `admin.example.com`) konfiguriert.

Zur Vereinfachung **können** beide URLs (`adminAPIServerName` und `synapse_admin.uri`)
gleich sein.

:warning: Die Admin API `adminAPIServerName` (hier: `admin.example.com`) sollte
nicht via Internet erreichbar sein. Dies lässt sich u.a. durch Annotations
am Ingress (`ingress.annotationsAdminAPI`) realisieren - für Nginx mit
[`nginx.ingress.kubernetes.io/whitelist-source-range`](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md#whitelist-source-range).
