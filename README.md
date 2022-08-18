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
1. [PoC](#poc)
    - [Hostnamen/DNS](#hostnamen-dns)
    - [Maschinengröße](#maschinengröße)
    - [Container-Basisimages](#container-basisimages)
    - [Betriebssystem K8s](#betriebssystem-k8s)
    - [Benutzer](#benutzer)
    - [Netzwerkbesonderheiten](#netzwerkbesonderheiten)
    - [Postgresql-Datenbank](#postgresql-datenbank)
    - [SSL-Zertifikate](#ssl-zertifikate)
    - [Zusätzliche Konfigurationselemente](#zusätzliche-konfigurationselemente)
      - [Backup:](#backup-)
      - [BestPractise](#bestpractise)
      - [Kyverno](#kyverno)
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

Um mit einer PoC-Installation zu beginnen, müssen mehrere Dinge berücksichtigt werden, die in diesem Leitfaden behandelt werden:

- [Hostnamen/DNS](#hostnamendns)
- [Maschinengröße](#maschinengröße)
- [Container-Basisimages](#container-basisimages)
- [Betriebssystem K8s](#betriebssystem-k8s)
- [Benutzer](#benutzer)
- [Netzwerkbesonderheiten](#netzwerkbesonderheiten)
- [Postgresql-Datenbank](#postgresql-datenbank)
- *Optional: [TURN-Server](/docs/turn.md)*
- [SSL-Zertifikate](#ssl-zertifikate)
- [Zusätzliche Konfigurationselemente](#zusätzliche-konfigurationselemente)

Sobald diese Bereiche abgedeckt sind, können Sie eine PoC-Umgebung installieren!

### Hostnamen/DNS
Sie benötigen Hostnamen für die folgenden Infrastrukturkomponenten:

- Element Web Client (erforderlich)
- Synapse (erforderlich)
- Synapse-Admin (empfohlen für eine Erreichbarkeit nur von intern, `.local`-Domain, ansonsten muss eine zusätzliche Sicherheitsbarriere hier berücksichtigt werden :smiley:)
- Monitoring (empfohlen) - ToDo: Beschreiben
- CoTurn-Server (optional)
 
Diese Hostnamen müssen in die entsprechenden IP-Adressen aufgelöst werden. Wenn Sie über einen geeigneten DNS-Server mit Einträgen (auch mit SRV-Einträgen für Matrix, siehe [separater Subdomain](docs/installation.md#auf-separater-subdomain)) für diese Hostnamen verfügen, können Sie loslegen.

### Maschinengröße
Für die Durchführung eines Proof of Concept mit unserem Installationschart unterstützen wir nur die x86_64-Architektur und empfehlen die folgenden Mindestanforderungen an Ressourcen in einem Kubernetes-Cluster:

- Ohne Föderation
  - zwei Worker-Nodes mit je 2 vCPUs/CPUs und 8 GB RAM
  - eine Master-Node mit 2 vCPUs und 4GB RAM
- Mit Föderation
  - mind. drei Worker-Nodes mit je 4 vCPUs/CPUs und 16 GB RAM
  - mind. eine Master-Node mit 2 vCPUs und 4GB RAM

:pushpin: **Hinweis:** Es wird empfohlen auf mehr als eine Master-Node zu setzen. Weiterhin ist eine zusätzliche Node, welche persistenten Speicher präsentiert, von Vorteil. Diese Funktionalität sollte vom Plattformbetreiber zur Verfügung gestellt werden und ist kein Bestandteil dieser Helm Charts.

### Container-Basisimages
In Zukunft soll auf die Nutzung von Container aus [Docker Hub](https://hub.docker.com/) verzichtet werden.
Hierzu werden wir eigene CI-Pipelines aufbauen um eigene Applikations- bzw. Basis-Images im OpenCoDE zur Verfügung zu stellen.

Veröffentlichen von eigenen Basis-Images stellt eine Verbreitung einer Linux-Distribution dar.
Daher werden wir zur Herstellung unserer Appikations-Images auf spezielle Basis-Images aufbauen.
Folgende Optionen werden geprüft:
- DVS Basis-Image
- [OSADL Basis-Image](https://www.osadl.org/OSADL-Docker-Base-Image.osadl-docker-base-image.0.html)

### Betriebssystem K8s
ToDo: *Empfehlung: Als Betriebssystem für die k8s-Worker wird Debian empfohlen, da dort `iptables-legacy-mode` ohne große Umstände mit der aktuellen Version von kubelet und containerd.io lauffähig ist.*

### Benutzer
Es wird empfohlen im Rahmen das PoC auf alle sicherheitsrelevanten Umgebungs- und Rahmenbedingungen zu achten. Dazu zählen nicht privilegierte Benutzer auf den Maschinen um dort eventuelle Arbeiten umzusetzen. Damit ist eine lauffähige und stabile Infrastruktur gewährleistet.

### Netzwerkbesonderheiten
Der Messengerservice muss Inhalte binden und bereitstellen über:

- Port 80 TCP
- Port 443 TCP

Entsprechende Ports müssen auch entweder lokal auf der PoC-Umgebung freigegeben werden oder in der vorgeschalteten Sicherheitsinfrastruktur.

Für zusätzliche Dienste wie CoTurn, müssen die entsprechenden Ports in der Sicherheitsinfrastruktur freigegeben werden:

- Port 3478 UDP/TCP
- Port 5349 TCP (bei TLS)

### Postgresql-Datenbank
Die Installation erfordert, dass Sie eine postgresql-Datenbank mit einem `locale` von `C` und `encoding` `UTF8` eingerichtet haben. 
Siehe [Synapse Dokumentation](https://matrix-org.github.io/synapse/latest/postgres.html#set-up-database) für weitere Details.

Wenn Sie diese bereitgestellt haben, notieren Sie sich bitte den Datenbanknamen, den Benutzer und das Passwort, da Sie diese benötigen, um mit der Installation zu beginnen. (per Parameter zu übergeben oder in der `value.yaml` anzupassen)

Wenn Sie noch keine Datenbank haben, richtet das PoC-Installationsprogramm PostgreSQL in Ihrem Namen ein. Dies ist standardmäßig hinterlegt. Dafür benötigt das Chart jedoch ein festes `VolumeClaim` der `StorageClass` `nfs-client`. Dies kann geändert werden (siehe oben).

*Optional: Es kann das Helm-Chart mit dazu verwendet werden im gleichen Namespace einen PostgreSQL-Server mit entsprechender Konfiguration bereitzustellen. Das ist für den PoC auch funktional, sollte aber in eine stabile DVS-konforme Version überführt werden. Dazu kann auch das Subchart für den PostgreSQL-Server entsprechend angepasst werden, dass ein eigener Namespace für einen "externen" Datenbankserver verwendet wird. Dabei ist zu beachten, dass diese Bereitstellung losgelöst vom BundesMessenger umgesetzt wird, da sonst die kyverno-Regeln hier einen Verstoß melden würden.*

### SSL-Zertifikate
Es wird empfohlen, wie auch in der folgenden Installationsanweisung, valide TLS-Zertifikate für alle genutzten Domains auf dem der Synapse-Host und die verknüpften Services (siehe: [Hostnamen/DNS](#hostnamen-dns)) erreichbar sind, zur Verfügung zu stellen.

Die Bereitstellung der TLS-Zertifikate ist nicht Bestandteil dieser Helm Charts.

### Zusätzliche Konfigurationselemente

Die Anbindung an eine IAM-Sicherheitsinfrastruktur ist noch ein offener Punkt, der während des PoCs zur Klärung bereit ist.
Einhergehend auch die Thematik Single Sign-on (SSO) per SAML, OIDC oder anderen Mechaniken.

#### Backup:
Für den Messenger ist die Datenbank der Hauptfokus, zusammen mit dem `signing-key` von Matrix. Dahingehend muss die Datenbank persistiert und regelmäßig gesichert werden. Der Schlüssel liegt als Secret im laufenden Deployment und sollte gesichert werden. Für ein aktives Redeployment, bzw. Migration in eine andere Umgebung (z.B. Produktionsumgebung), wird dieser Schlüssel benötigt und kann bei der initialen Ausführung des Helm-Charts mit angegeben werden: 
```yaml
extraConfig:
#  old_signing_keys:
#    "ed25519:id": { key: "base64string", expired_ts: 123456789123 }
```

#### BestPractise 

    Netzwerk Policies 
    Noch im ToDo
    Wahl der Domain und Delegation

#### [Kyverno](https://kyverno.io/)
Siehe Dokumentation der einzelnen Rulesets im Dokument [DVS Policies retentions](./DVS-Policies-restrictions.md)

# Erweitertes Inhaltsverzeichnis

Eine Installationsanweisung finden Sie hier, so wie auch Hinweise zu den einzelnen zusätzlichen Diensten:

- [Installation](./docs/installation.md)
- [TURN (Audio / Video)](./docs/turn.md)
- [Sygnal (Push-Service)](./docs/sygnal_push.md)

# ToDo
- Neustrukturierung der Dokumente
- Klären DVS DMZ, etc. Port 80 und TLS/443 in Helm Chart
- Infrastruktur-Bild
- Ingress
