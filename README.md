<div align="center">
  <img src="https://gitlab.opencode.de/bwi/bundesmessenger/info/-/raw/main/images/logo.png" alt="BundesMessenger Logo" width="256" height="256">
</div>

<div align="center">
  <h2 align="center">BundesMessenger</h2>
</div>
<div align="center">
  Der souveräne Messenger für Deutschland 
</div>


# BundesMessenger Backend auf Basis von Matrix Synapse

1. [Übersicht](#übersicht-zum-bundesmessenger)
    - [Kontakt und Austausch](#kontakt-und-austausch)
    - [Voraussetzungen](#voraussetzungen)
    - [Infrastruktur](#infrastruktur)
1. [Messenger-PoC](#messenger-poc)
    - [Installationshinweis](#installationshinweis)
    - [Installation](#installation)
      - [Auf der Hauptdomain / mit Subdomain MXIDs](#auf-der-hauptdomain---mit-subdomain-mxids)
      - [Auf separater Subdomain](#auf-separater-subdomain)
    - [Upgrading](#upgrading)
1. [Erweitertes Inhaltsverzeichnis](#erweitertes-inhaltsverzeichnis)

## Übersicht zum [BundesMessenger](https://gitlab.opencode.de/bwi/bundesmessenger/info)

| :warning: Das Helm Chart sollte noch nicht in einer produktiven Umgebung genutzt werden. Es dient dem Einsatz im PoC der DVS und für Teststellungen. |
| --- |

[Synapse](https://github.com/matrix-org/synapse) ist eine Matrix homeserver Implementierung auf Basis des [Matrix Protokoll](https://matrix.org).
Das Matrix Protokoll wird in der [Matrix Specification](https://spec.matrix.org/) beschrieben und dokumentiert.

Das Helm-Chart für den BundesMessenger wurde aus dem Helm Chart von [Alexander Olofsson](https://gitlab.com/ananace/charts/-/tree/master/charts/matrix-synapse) entwickelt.
Die größten Änderungen zu dem zugrundeliegenden Chart sind:
- Anpassungen im Umfeld des Storage / Speichers
- Änderung des Sets für die Worker auf `StatefulSets`
- Hinzufügen und Konfiguration für Horizontal Pod Autoscaling (HPA) für die Generic-Worker
- Änderung der Namensgebung/Transport der Pod-Names in die Dienste, für ein eindeutiges Logging und Auswertung der internen Kommunikation
- festes `PersistentVolumeClaim` für Media-Worker
- Einfügen/Anpassen von Ingress-Routen 
- Hinzufügen eines Virenscanners (ClamAV) **(ToDo: Einbringung des Contentscanners zum aktivieren des Virenscanners)**
- Hinzufügen des [Synapse Admin](https://github.com/Awesome-Technologies/synapse-admin) von [Awesome-Technologies](https://awesome-technologies.de/) zur Administration der Instanz (aktuell auf nur intern erreichbarer Domain)
- Hinzufügen und Konfiguration des Sygnal-Push-Dienstes
- Konfiguration des kompletten Dienstes für das Service-Monitoring per Prometheus (wird automatisch an Clustereigenen Prometheus promoted)
- Integration eines [CoTurn-Servers](https://github.com/coturn/coturn) zur Nutzung der VoIP-Dienste 
    - *Optional: Installation und Konfiguration eines dedizierten NginX Controllers für UDP Traffic*
    - :pushpin: **Empfehlung: Installation eines CoTurn außerhalb des Kubernetes und Konfiguration zur Erreichbarkeit dort vornehmen**
- Konfiguration der Dienste nach Best Practice

### Kontakt und Austausch

Für Fragen zur Anwendung des Helm-Charts, Konfiguration, Deployment und BundesMessenger
haben wir einen [Matrix Raum](https://matrix.to/#/#opencodebum:matrix.org) erstellt.

<div align="center">
  <img src="https://gitlab.opencode.de/bwi/bundesmessenger/info/-/raw/main/images/qr_matrix_room.png" alt="QR Code Matrix">
</div>

Kein Matrix Client zur Hand, dann auch gerne über unser [Email Postfach](mailto:bundesmessenger@bwi.de).

Wir freuen uns auf den Austausch.

### Voraussetzungen

- [Kubernetes](https://kubernetes.io/) 1.19+
- [Helm](https://helm.sh/) 3.0+
- Unix mit Kernel 4.11 oder neuer auf Worker-Nodes (für syscall Anweisung `net.ipv4.ip_unprivileged_port_start`)
- Ingress Controller (NginX) im Cluster installiert
    - *Optional: Nicht Policy-Konform: Bei Nutzung von CoTurn des Helm Charts, muss der IngressController den Port 3478 TCP zugefügt werden (Patch) oder durch vorgeschalteten ReverseProxy an die Nodeports direkt durchgeleitet werden. Weiterhin müsste bei Kubernetesinternem CoTurn ein weiterer NginX-Controller deployed werden, welcher sich um den UDP-Traffic kümmert **(nicht empfohlen)***
- vorgelagerte Loadbalancer und vorkonfigurierte Firewalls, um den Service in vollem Umfang zu nutzen
    - *Optional: bei Nutzung von CoTurn wird ein NginX-ReverseProxy empfohlen, der die TCP/UDP-Streams weiterleitet (nicht Policykonform, da Host-Ports angesprochen werden müssen.*
- *Optional: Storage muss `PersistentVolumeClaims` zulassen und konfiguriert haben (von Vorteil für DB und Media)*
- Zugriff auf vorhandenen [PostgreSQL](https://www.postgresql.org/) Server (konform zur DVS)
    - Datenbank `synapse_db` mit einem Benutzer `synapse`.
    - Server muss erreichbar sein aus dem Namespace *Empfehlung: PostgreSQL Server liegt auch im Kubernetes*.
    - :pushpin: **Hinweis:** Collation und cType müssen auf `C` gesetzt sein. Siehe [Postgresql-Datenbank](#postgresql-datenbank)
- *Optional: ein `existingClaim` (persistent volume claim) mit dem Namen `matrix-synapse` (empfohlen 10 GB) für den Media-Worker als Speicher.*

:pushpin: **Hinweis:** Sollte die `storageClass` `nfs-client` nicht existent sein, muss diese erstellt oder mit dem folgenden Parameter gesetzt werden:
```console
helm install bundesmessenger bundesmessenger/bundesmessenger --set persistence.storageClass=STORAGECLASS
```

| :warning: Anmerkung: Matrix benötigt valide TLS-Zertifikate um voll funktionsfähig zu sein.|
| --- |

### Infrastruktur

Das Helm Chart rollt die im Bild blau dargestellten Komponenten aus.

Nicht Bestandteil sind eine DMZ, PAP-Infrastruktur oder ähnliches.

![Infrastruktur](./docs/images/Infrastruktur_Scope.jpg "Übersicht über die Infrastruktur")

## Messenger-PoC
So installieren Sie eine PoC-Umgebung.

Unser Helm Chart kann die Installation von Matrix/Synapse Proof of Concept (PoC) Umgebungen übernehmen. Unsere Kubernetes-Infrastruktur ist ein 4-Node-Cluster mit vanilla Kubernetes. Auf dem Cluster wird der Messenger-PoC bereitgestellt, der einen voll funktionsfähigen Synapse-Server mit Element Web Client bereitstellt.

Messenger-PoCs auf Basis dieser Helm Charts sind nicht dazu bestimmt in einem produktiven Umfeld betrieben zu werden. Sie sollten eine andere Installation für Ihre Produktionsumgebung planen. Einstellungen, die Sie mit dem Installationsprogramm verwenden, können für eine Installation in einer Produktivumgebung übernommen werden. Daten innerhalb des Messengers (Benutzer, Räume, Chatinhalte, etc.) werden nicht zwischen den Umgebungen (PoC/Test/Integration/Produktion) überführt.

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

# Erweitertes Inhaltsverzeichnis

Eine Anweisung für die Installation einer PoC-Umgebung finden Sie hier, so wie auch Hinweise zu den einzelnen zusätzlichen Diensten:

- [PoC Requirements](./docs/requirements_poc.md)
- [TURN (Audio / Video)](./docs/turn.md)
- [Sygnal (Push-Service)](./docs/sygnal_push.md)

# ToDo
- Neustrukturierung der Dokumente
- Klären DVS DMZ, etc. Port 80 und TLS/443 in Helm Chart
- Infrastruktur-Bild
- Ingress
