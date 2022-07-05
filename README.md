Inhaltsverzeichnis
==================

- [Installation](./installation.md)
- [TURN (Audio / Video)](./turn.md)
- [Sygnal (Push-Service)](./Sygnal_push.md)

BWI Bundesmessenger auf Basis von Matrix Synapse
================================================

1. Übersicht
2. PoC
3. Installationsbeispiele 

Übersicht zum [BundesMessenger](https://gitlab.opencode.de/bwi/bundesmessenger/info)

**Das Helm Chart ist noch nicht Produktionsbereit. Nur für PoC oder Teststellung zu verwenden.** 

[Synapse](https://github.com/matrix-org/synapse) ist die aktuelle Implementation des [Matrix Protokoll](https://matrix.org).
Das Helm-Chart für den Bundesmessenger wurde aus dem Helm Chart von [Alexander Olofsson](https://gitlab.com/ananace/charts/-/tree/master/charts/matrix-synapse) entwickelt.
Die größten Änderungen zu dem zugrunde liegenden Chart sind:
- Anpassungen im Storageumfeld
- Änderung des Sets für die Worker auf Statefulsets
- Hinzufügen und Konfiguration für Horizontal Pod Autoscaling (HPA) für die Generic-Worker
- Änderung der Benamung/Transport der Pod-Names in die Dienste, für eineindeutiges Logging und Auswertung der internen Kommunikation
- festes PersistentVolumeClaim für Media-Worker
- Einfügen/Anpassen von Ingress-Routen 
- Hinzufügen eines Virenscanners (ClamAV) **(TODO: Einbringung des Contentscanners zum aktivieren des Virenscanners)**
- Hinzufügen des Synapse Admin von [Awesome-Technologies](https://github.com/Awesome-Technologies/synapse-admin) zur Administration der Instanz (aktuell auf nur intern erreichbarer Domain)
- Hinzufügen und Konfiguration des Sygnal-Push-Dienstes
- Konfiguration des kompletten Dienstes für das ServiceMonitoring per Prometheus (wird automatisch an Clustereigenen Prometheus promoted)
- Integration eines CoTurn-Servers zur Nutzung der VoIP-Dienste 
    - *Optional: Installation und Konfiguration eines dedizierten NginX Controllers für UDP Traffic*
    - **Empfehlung: Installation eines CoTurn außerhalb des Kubernetes und Konfiguration zur Erreichbarkeit dort vornehmen**

Für Fragen zur Anwendung des Helm-Charts, Konfiguration und Deployment steht Ihnen Christian.Steinke@bwi.de gerne zur Verfügung.

## Voraussetzungen

- Kubernetes 1.19+
- Helm 3.0+
- Unix mit Kernel 4.11 oder neuer auf Worker-Nodes (für syscall Anweisung net.ipv4.ip_unprivileged_port_start)
- Ingress Controller (NginX) im Cluster installiert
    - *Optional: Nicht Policiy-Konform: Bei Nutzung von CoTurn des Helm Charts, muss der IngressController den Port 3478 TCP zugefügt werden(Patch) oder durch vorgeschalteten ReverseProxy an die Nodeports direkt durchgeleitet werden*
- vorgelagerte Loadbalancer und vorkonfigurierte Firewalls, um den Service in vollem Umfang zu nutzen
    - *Optional: bei Nutzung von CoTurn wird ein NginX-ReverseProxy empfohlen, der die TCP/UDP-Streams weiterleitet*
- *Optional: Storage muss PersistentVolumeClaims zulassen und konfiguriert haben (von Vorteil für DB und Media)*
- Zugriff auf vorhandenen PostgreSQL Server (DVS Konformität)
    - Datenbank **synapse_db** (**Hinweis: Collation und cType müssen auf "C" gesetzt sein**)  und User **synapse**.
    - Server muss erreichbar sein aus dem Namespace *Empfehlung: PostgreSQL Server liegt auch im Kubernetes*.
- *Optional: ein "existingClaim" (persistent volume claim) mit dem Namen "matrix-synapse" (empfohlen 10GB) für den Media-Worker als Speicher.*

 *Hinweis: Sollte die storageClass nfs-client nicht existent sein, muss diese erstellt oder mit dem folgenden Parameter gesetzt werden:*
```console
    helm install bundesmessenger bundesmessenger/bundesmessenger --set persistence.storageClass=STORAGECLASS
```
**Anmerkung** Matrix benötigt valide Zertifikate um voll funktionsfähig zu sein.

## PoC

So installieren Sie eine PoC-Umgebung

Unser Helm Chart kann die Installation von Matrix/Synapse Proof of Concept (PoC) Umgebungen übernehmen. Unsere Standard-PoC-Umgebung ist ein 4-Node-Cluster mit vanilla Kubernetes, auf dem wir unsere Testumgebung bereitstellen, was zu einem voll funktionsfähigen Synapse-Server mit Element Web führt, der zur Durchführung eines PoC verwendet werden kann. Lokale Produktionsbereitstellungen verwenden dasselbe Installationsprogramm und denselben Operator, sind jedoch für die Bereitstellung in einer vollständigen Kubernetes-Umgebung vorgesehen und müssen erst noch getestet werden und das PoC erfolgreich verlassen.

PoC-Anlagen sind nicht dazu bestimmt, zu Produktionszwecken betrieben zu werden. Sie sollten eine andere Installation für Ihre Produktionsumgebung planen. Die Einstellungen, die Sie mit dem Installationsprogramm verwenden, können für Ihre Produktionsinstallation übernommen, Ihre Räume und Bereiche jedoch nicht.

Um mit einer PoC-Installation zu beginnen, müssen mehrere Dinge berücksichtigt werden, die in diesem Leitfaden behandelt werden:

Hostnamen/DNS
Maschinengröße
Betriebssystem
Benutzer
Netzwerkbesonderheiten
Postgresql-Datenbank
*Optional: TURN-Server*
SSL-Zertifikate
Zusätzliche Konfigurationselemente
Sobald diese Bereiche abgedeckt sind, können Sie eine PoC-Umgebung installieren!

### Hostnamen/DNS
Sie benötigen Hostnamen für die folgenden Infrastrukturkomponenten:

- Elementserver (erforderlich)
- Synapse-Server (erforderlich)
- CoTurn-Server (optional)
- Synapse-Admin-Server (empfohlen für nur intern erreichbar, .local-Domain, ansonsten muss eine zusätzliche Sicherheitsbarriere hier berücksichtigt werden :) )
- Monitoring (empfohlen)
 
Diese Hostnamen müssen in die entsprechenden IP-Adressen aufgelöst werden. Wenn Sie über einen geeigneten DNS-Server mit Einträgen (auch mit SRV-Einträgen für Matrix) für diese Hostnamen verfügen, können Sie loslegen.

### Maschinengröße
Für die Durchführung eines Proof of Concept mit unserem Installationschart unterstützen wir nur die x86_64-Architektur und empfehlen die folgenden Mindestanforderungen für ein eigenständig aufgebautes PoC-Umfeld:

- Keine Förderation: 4 vCPUs/CPUs und 16 GB RAM auf 2 Worker-Nodes und eine Master-Node mit 2vCPUs und 4GB RAM
- Föderation: 8 vCPUs/CPUs und 32 GB RAM auf 3+ Worker-Nodes und mindestens eine Master-Node mit 2vCPUs und 4GB RAM

*Es wird empfohlen auf mehr als eine Master-Node zu setzen. Weiterhin ist eine zusätzliche Node, welche persistenten Speicher präsentiert von Vorteil. **Diese Funktionalität muss später vom Plattformbetreiber zur Verfügung gestellt werden und sollte somit aus dem PoC-Fokus frühzeitig gelöst sein.***

### Betriebssystem
Im Rahmen der DVS und der Entwicklung des Bundesmessenger ist die Nutzung von OSADL-Images die wahrscheinlichste Variante.
Aus der Sicht der Sicherheit ist zu Alpine oder Debian bzw. Ubuntu-Server (LTS) zu raten. Es gibt aber keine Einschränkungen zu RedHead oder SLES, jedoch müssen Abhängigkeiten zu nötigen Paketen selbst vorgenommen werden.

*Empfehlung: Als OS für die PoC-Umgebung wird Debian empfohlen. Da dort iptables-legacy-mode ohne große Umstände mit der aktuellen Version von kubelet und containerd.io lauffähig ist.*

### Netzwerk
Der Messengerservice muss Inhalte binden und bereitstellen über:

- Port 80 TCP
- Port 443 TCP

Entsprechende Ports müssen auch entweder lokal auf der PoC-Umgebung freigegeben werden oder in der vorgeschalteten Sicherheitsinfrastruktur.

Für zusätzliche Dienste wie CoTurn, müssen die entsprechenden Ports in der Sicherheitsinfrastruktur freigegeben werden:

- Port 3478 UDP/TCP
- Port 5349 TCP (bei TLS)

### Postgresql-Datenbank
Die Installation erfordert, dass Sie eine postgresql-Datenbank mit einem LOCALE von C und UTF8-Codierung eingerichtet haben. 
Siehe https://github.com/matrix-org/synapse/blob/develop/docs/postgres.md#set-up-database für weitere Details.

Wenn Sie diese bereits haben, notieren Sie sich bitte den Datenbanknamen, den Benutzer und das Passwort, da Sie diese benötigen, um mit der Installation zu beginnen. (per Parameter zu übergeben oder in der value.yaml anzupassen)

Wenn Sie noch keine Datenbank haben, richtet das PoC-Installationsprogramm PostgreSQL in Ihrem Namen ein. Dies ist per Default so hinterlegt. Dafür benötigt das Chart jedoch ein festes VolumeClaim der StorageClass "nfs-client". Dies kann geändert werden (siehe oben)

### SSL-Zertifikate
Es ist von Vorteil, wie auch in der folgenden Installationsanweisung, valide Zertifikate für die Hauptdomain und wenn notwendig auch die entsprechende Subdomain auf dem der Synapse-Host erreichbar ist. 

*Es ist auch möglich Lets-Encrypt-Zertifikate zu nutzen, allerdings führt dies zu Fehlverhalten bei Nutzung von Goggle-Chrome als Browser.*

### Zusätzliche Konfigurationselemente

Die Anbindung an eine IAM-Sicherheitsinfrastruktur ist noch ein offener Punkt, der während des PoCs zur Klärung bereit ist.
Einhergehend auch die Thematik SSO per SAML oder anderen Mechaniken.

#### Backup:
Für den Messenger ist die Datenbank der Hauptfokus, zusammen mit dem ```signing-key``` von Matrix. Dahingehend muss die Datenbank persistiert und regelmäßig gebackupt werden. Der Schlüssel liegt als Secret im laufenden Deployment und sollte gesichert werden. Für ein aktives Redeployment, bzw. Migration in eine andere Umgebung (PRD), wird dieser Schlüssel benötigt und kann bei der initialen Ausführung des Helm-Charts mit angegeben werden: 
```
extraConfig:
#  old_signing_keys:
#    "ed25519:id": { key: "base64string", expired_ts: 123456789123 }
```

#### BestPractise 

    Netzwerk Policies 
    Noch im TODO


#### Kyverno
Siehe Dokumentation der einzelnen Rulesets im Dokument [DVS Policies retentions](./DVS-Policies-restrictions.md)


## Installationshinweis

Um eine Förderationsversion vom Matrix zu Nutzen, benötigen Sie eine öffentlich zugängliche Subdomain, auf der Kubernetes ein Ingress laufen hat.
Sie benötigen weiterhin auch einen Vermittler, entweder in Form des Well-Known `.well-known/matrix/server` Server oder einem SRV-Eintrag im DNS.

Wenn Sie einen well-known Eintrag verwenden, benötigen Sie ein gültiges Zertifikat für die Subdomain, auf der Sie Synapse bereitstellen möchten.
Wenn Sie einen SRV-Eintrag verwenden, benötigen Sie zusätzlich ein gültiges Zertifikat für die Hauptdomäne, die Sie für Ihre MXIDs (**M**atri**x** Nutzer **ID**s) verwenden.

## Installation

Für mehr Informationen nutzen Sie die öffentlich erreichbaren Dokumentationen: [Synapse Dokumentation](https://github.com/matrix-org/synapse/blob/master/docs/federate.md)

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
