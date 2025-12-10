# BundesMessenger Admin-Portal

Zur Administration mit Hilfe einer Weboberfläche kann das
[BundesMessenger Admin-Portal](https://gitlab.opencode.de/bwi/bundesmessenger/admin-portal)
mit dem Helm Chart installiert werden.

| :pushpin: BundesMessenger Admin-Portal wird in Zukunft [Synapse-Admin](./synapse_admin.md) ablösen. |
| --- |

| :pushpin: BundesMessenger Admin-Portal erfordert den [MAS](./matrix-authentication-service.md) und die Migration der Benutzerverwaltung von Synapse zum MAS. |
| --- |

In dem folgenden Beispiel wird zusätzlich zur Synapse-Installation BundesMessenger

- das BundesMessenger Admin-Portal aktiviert (`adminPortal.enabled=true`),
- seinem API-Server eine URL zugewiesen (`adminAPIServerName`) und
- seiner Weboberfläche eine URL zugewiesen (`adminPortal.uri`).

```console
helm install bundesmessenger bundesmessenger/bundesmessenger \
  --set serverName=example.com \
  --set adminAPIServerName=admin.example.com \
  --set adminPortal.enabled=true \
  --set adminPortal.uri=bum-adminportal.example.com
```

Die Administrationsoberfläche ist im Anschluss unter der für `adminPortal.uri`
angegebenen URL erreichbar (hier: `bum-adminportal.example.com`).

Zur Vereinfachung **können** beide URLs (`adminAPIServerName` und `adminPortal.uri`)
gleich sein.

:pushpin: Das BundesMessenger Admin-Portal und Synapse-Admin können nicht auf der
gleichen URL installiert werden. Es gilt: `adminPortal.uri` darf nicht gleich
`synapse_admin.uri` sein.

:warning: Die Admin API `adminAPIServerName` (hier: `admin.example.com`) sollte
nicht via Internet erreichbar sein. Dies lässt sich u.a. durch Annotations
am Ingress (`ingress.annotationsAdminAPI`) realisieren – für Nginx mit
[`nginx.ingress.kubernetes.io/whitelist-source-range`](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md#whitelist-source-range).

Der Pod des synapse-ui-Core vom Admin-Portal muss weiterhin
den Ingress von der Admin API erreichen können. Er greift intern via dem Ingress
darauf zu.
