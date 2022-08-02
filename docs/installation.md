## Installationshinweis

Um eine Förderationsversion vom Matrix zu Nutzen, benötigen Sie eine öffentlich zugängliche Subdomain, auf der Kubernetes ein Ingress laufen hat.
Sie benötigen weiterhin auch einen Vermittler, entweder in Form des Well-Known `/.well-known/matrix/server` Server oder einem SRV-Eintrag im DNS.

Wenn Sie einen well-known Eintrag verwenden, benötigen Sie ein gültiges Zertifikat für die Subdomain, auf der Sie Synapse bereitstellen möchten.
Wenn Sie einen SRV-Eintrag verwenden, benötigen Sie zusätzlich ein gültiges Zertifikat für die Hauptdomäne, die Sie für Ihre MXIDs (**M**atri**x** Nutzer **ID**s) verwenden.

## Installation

Für mehr Informationen nutzen Sie die öffentlich erreichbaren Dokumentationen: [Synapse Dokumentation](https://matrix-org.github.io/synapse/latest/federate.html)

### Auf der Hauptdomain / mit Subdomain MXIDs

Für eine möglichst einfache Matrix-Installation, können Sie Ihre Synapse-Installation auf der gewünschten HauptDomain für Ihre MXIDs ausführen.
Sollten Sie, zum Beispiel, die Domaine 'beispiel.org' besitzen und Sie möchten den Bundesmessenger darauf laufen lassen, reicht der folgende Aufruf des Charts:
```console
helm install bundesmessenger nextmessage/bundesmessenger --set serverName=beispiel.org --set wellknown.enabled=true
```

Dadurch würde Synapse mit Client-Server und Förderation eingerichtet werden, welche beide über `beispiel.org/_matrix` verfügbar sind, sowie ein lighttp Server, der auf die Förderationsanfragen auf `beispiel.org/.well-known/matrix/server` antwortet.

Es ist auch möglich, Synapse auf einer Subdomain laufen zu lassen, wobei diese dann Teil Ihrer MXIDs wird: (`@nutzer:matrix.beispiel.org` in folgenden Beispiel)
```console
helm install matrix-synapse bundesmessenger/bundesmessenger --set serverName=matrix.beispiel.org --set wellknown.enabled=true
```

### Auf separater Subdomain

Für den Fall, Sie besitzen die Domain `beispiel.org` und Sie wollen die MXIDs in der Form `@nutzer:beispiel.org`, aber dennoch den Synapsedienst unter der Domain `matrix.beispiel.org` laufen lassen, bleiben Ihnen 2 Möglichkeiten: DNS oder well-known.

Für die DNS-Variante, installieren Sie den Messengerservice wie folgt:
```console
helm install matrix-synapse bundesmessenger/bundesmessenger --set serverName=beispiel.org --set publicServerName=matrix.beispiel.org
```

Das fügt Endpunkte für die Federation `beispiel.org` hinzu, sowie auch Client Endpunkte auf `matrix.beispiel.org`.
Ohne ein entsprechend valides Zertifikat beide Domainen wird Synapse nicht funktionieren.
Weiterhin wird für die Federation auch ein SRV-Record im DNS benötigt (Beispiel):
```console
_matrix._tcp.beispiel.org 10 1 443 matrix.beispiel.org
```

Als Alternative mit dem well-known Variation, ist die Installation wie folgt:
```console
helm install matrix-synapse bundesmessenger/bundesmessenger --set serverName=example.com --set publicServerName=matrix.example.com --set wellknown.enabled=true
```

In der well-known Federations-Variante muss der Client-Server/Public Host sich um alle Kommunikation von Client und Federation kümmern. Auf der Hauptdomain muss nur `etwas` mit einer JSON Antwort auf die URL `beispiel.org/.well-known/matrix/server` antworten. Die Antwort beinhaltet den wellknown Server. Zusätzlich muss für Synapse nur das Zertifikat für `matrix.beispiel.org` valide sein.

&nbsp;

Weitere Setups, Erweiterungen und Service wie Loadbalancer und TLS-Listener werden noch folgen.

## Upgrading
Beispiel:
```console
# Lösche altes StatefulSet, aber lasse die entsprechend aus dem resultierende Pods bestehen:
kubectl delete statefulset --cascade=orphan matrix-synapse-bundesmessenger

# Upgrade das Chart und erstelle ein neues StatefulSet für das Deployment
helm upgrade matrix-synapse matrix-synapse-bundesmessenger

# Lösche alten Pods, damit die neu (konfigurierten) Pods übernehmen können
kubectl delete pod matrix-synapse-bundesmessenger   
```
