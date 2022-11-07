<div align="center">
  <img src="https://gitlab.opencode.de/bwi/bundesmessenger/info/-/raw/main/images/logo.png" alt="BundesMessenger Logo" width="256" height="256">
</div>

<div align="center">
  <h2 align="center">BundesMessenger</h2>
</div>
<div align="center">
  Der souveräne Messenger für Deutschland 
</div>

# BundesMessenger Backend

Das BundesMessenger Backend ist Bestandteil einer Sammlung von Repositories zum BundesMessenger.
Allgemeine Informationen zum Projekt befinden sich im übergeordneten
[**BundesMessenger Repository**](https://gitlab.opencode.de/bwi/bundesmessenger/info).

Dieses Repository stellt ein [Helm Chart](https://helm.sh/) zur automatisierten Bereitstellung
eines Backends bzw. Infrastruktur für die Nutzung mit dem BundesMessenger Client zur Verfügung.
Hauptbestanteil ist der [Synapse](https://github.com/matrix-org/synapse) Server, Dieser ist eine
Matrix homeserver Implementierung in Python auf Basis des [Matrix Protokolls](https://matrix.org).

Das Matrix Protokoll wird in der [Matrix Specification](https://spec.matrix.org/) beschrieben und dokumentiert.

Weitere Komponenten, die durch das Helm Chart bereitgestellt werden:

- [Synapse-Admin](https://github.com/Awesome-Technologies/synapse-admin) zur Administration
- [Sygnal](https://github.com/matrix-org/sygnal) Push-Server für Google und Apple
- BundesMessenger WebClient
- [Redis](https://redis.io/) In-Memory Datenbank
- [Ingress Konfiguration](https://github.com/kubernetes/ingress-nginx)  auf Basis von Nginx
- [Matrix-Content-Scanner](https://github.com/matrix-org/matrix-content-scanner)
- [ClamAV](https://www.clamav.net/)

:pushpin: Nicht Bestandteil sind eine DMZ, PAP-Infrastruktur oder ähnliches.

## Inhaltsverzeichnis

- [Herkunft und Anpassungen der Helm Charts](#herkunft-und-anpassungen-der-helm-charts)
- [Hinweise zu Matrix](#hinweise-zu-matrix)
  - [Benutzernamen](#benutzernamen)
  - [Delegation](#delegation)
- [Installation](#installation)
  - [Infrastruktur](#infrastruktur)
  - [Voraussetzungen](#voraussetzungen)
  - [Option 1: Domain entspricht den Benutzernamen (ohne Delegation)](#option-1-domain-entspricht-den-benutzernamen-ohne-delegation)
  - [Option 2: Domain entspricht nicht den Benutzernamen (mit Delegation)](#option-2-domain-entspricht-nicht-den-benutzernamen-mit-delegation)
  - [Erster Benutzer](#erster-benutzer)
  - [Upgrading](#upgrading)
- [Weiterführende Dokumentation](#weiterführende-dokumentation)
- [Kontakt und Austausch](#kontakt-und-austausch)

# Herkunft und Anpassungen der Helm Charts

Das Helm-Chart für den BundesMessenger wurde aus dem Helm Chart von [Alexander Olofsson](https://gitlab.com/ananace/charts/-/tree/master/charts/matrix-synapse) entwickelt.
Die größten Änderungen zu dem zugrundeliegenden Chart sind:

- Anpassungen im Umfeld des Storage / Speichers
- Änderung des Sets für die Worker auf `StatefulSets`
- Hinzufügen und Konfiguration für Horizontal Pod Autoscaling (HPA) für die Generic-Worker und den ClamAV
- Änderung der Namensgebung/Transport der Pod-Names in die Dienste, für ein eindeutiges Logging und Auswertung der internen Kommunikation
- festes `PersistentVolumeClaim` für Media-Worker
- Einfügen/Anpassen von Ingress-Routen
- Hinzufügen eines [Virenscanner (ClamAV)](https://www.clamav.net/) zusammen mit dem
  [Matrix-Content-Scanner](https://github.com/matrix-org/matrix-content-scanner)
- Hinzufügen des [Synapse Admin](https://github.com/Awesome-Technologies/synapse-admin)
  von [Awesome-Technologies](https://awesome-technologies.de/) zur Administration der
  Instanz (empfohlen auf nur intern erreichbarer Domain)
- Hinzufügen und Konfiguration des Sygnal-Push-Dienstes
- Konfiguration des kompletten Dienstes für das Service-Monitoring per Prometheus
  (wird automatisch an Clustereigenen Prometheus promoted)
- **Out of scope!** mögliche Integration eines [CoTurn-Servers](https://github.com/coturn/coturn)
  zur Nutzung der VoIP-Dienste
  - *Optional: Installation und Konfiguration eines dedizierten NginX Controllers für UDP Traffic*
  - :pushpin: **Empfehlung: Installation eines CoTurn außerhalb des Kubernetes und Konfiguration zur Erreichbarkeit dort vornehmen**
- Konfiguration der Dienste nach Best Practice
- Anpassung an Dual-Stack bzw. reine IPv4-Umgebungen
- Integration eines eigenen gehärteten WebClients

# Hinweise zu Matrix

Der BundesMessenger nutzt das [Open Source Protokoll Matrix](https://matrix.org/).
Das Protokoll basiert auf JSON over Rest und ist in der
[Matrix Spezifikation](https://spec.matrix.org/latest/) definiert und dokumentiert.
Der Hersteller stellt [Einführungen und Tutorials](https://matrix.org/docs/guides/introduction)
bereit.

## Benutzernamen

Benutzernamen heißen in Matrix "**M**atri**x** **ID**" bzw. **MXID**. Diese sind ähnlich aufgebaut wie E-Mail-Adressen.
Sie besitzen einen Anteil des lokalen Benutzernamens (`localpart`) und eine Domain bzw. Servernamen (`example.com`),
die relevant ist für die Kommunikation zwischen den Matrix-Instanzen (Föderation).

Somit ergibt sich die Matrix ID: `@localpart:example.com`. `@` und `:` sind fest definierte Identifier und Trennzeichen.
Je nach Implementierung des Clients reicht für den Benutzer der `localpart` um sich am eigenen Server,
dem sog. "homeserver" anzumelden.

- [Spezifikation](https://spec.matrix.org/latest/appendices/#identifier-grammar)
  - [definierte Identifier](https://spec.matrix.org/latest/appendices/#common-identifier-format)
  - [Benutzername](https://spec.matrix.org/latest/appendices/#user-identifiers)
  - [Domain bzw. Servername](https://spec.matrix.org/latest/appendices/#server-name)

| :warning: Wichtig: Mit der Inbetriebnahme des Synapse Servers wird die Domain `example.com`, welche der Server verwaltet, festgelegt. Damit auch der Namensraum der Benutzer. Ein nachträgliches Ändern oder eine Migration sind nicht möglich. Hierfür müssen der Server bzw. die Datenbank neu installiert werden. Ein Server kann auch nur eine Domain (hier: `example.com`) verwalten. |
| --- |

## Delegation

Die [Delegation](https://matrix-org.github.io/synapse/latest/delegate.html#delegation-of-incoming-federation-traffic)
ist insbesondere im Kontext der Kommunikation in der Föderation wichtig.
Im Normalfall würde man erwarten, dass ein Benutzer `@benutzer:example.com` auch auf dem
Server `example.com` erreichbar ist. Das muss jedoch nicht zwingend der Fall sein.

Mit Hilfe der Delegation kann man ermöglichen, dass ein Server im Internet oder Intranet auf
einem anderen DNS-Namen (Domain) erreichbar ist (z.B. `matrix.example.com`)
als ein Benutzername darstellt (z.B. `@benutzer:example.com`).

Es gibt zwei Arten der Delegation:

1. [.well-known Seite](https://matrix-org.github.io/synapse/latest/delegate.html#well-known-delegation)

    Die Domain, die einen Matrix-Server delegiert (`example.com`), muss unter der URL
    `https://example.com/.well-known/matrix/server` eine JSON-Datei
    mit dem folgenden Inhalt ausgeben und auf den Matrix-Server verweisen.
    Falls kein Port angegeben wird, wird der Standard-Port `8448` genutzt.

    ```json
    {
        "m.server": "matrix.example.com:443"
    }
    ```

1. [DNS SRV-Eintrag](https://matrix-org.github.io/synapse/latest/delegate.html#srv-dns-record-delegation)

    Mit Hilfe eines SRV-Eintrages wird auf den Matrix-Server verwiesen.

    ```console
    _matrix._tcp.example.com 10 1 443 matrix.example.com
    ```

    | :warning: Die Delegation mit Hilfe eines DNS SRV Eintrages wird aus Gründen der Sicherheit nicht empfohlen, Stichwort DNSSEC |
    | --- |

Für mehr Informationen nutzen Sie die öffentlich erreichbaren Dokumentationen:

- [Prozess zur Ermittlung des Kommunikationspartners / Discovery](https://spec.matrix.org/latest/server-server-api/#resolving-server-names)
- [Delegation](https://matrix-org.github.io/synapse/latest/delegate.html)
- [Federation](https://matrix-org.github.io/synapse/latest/federate.html)

# Installation

| :warning: Das Helm Chart sollte derzeit nicht in einer produktiven Umgebung genutzt werden. Es dient dem Einsatz im PoC der DVS, für Teststellungen und hat BETA-Status. |
| --- |

:pushpin:  Alle möglichen Konfigurationswerte bzw. Parameter für das Helm Chart werden
in der [`values.yaml`](./values.yaml) dokumentiert und vorgehalten. Die ausführliche
Dokumentation hierfür erfolgt zu einem späteren Zeitpunkt.

:pushpin: Getestet wird das Helm Chart auf einer Kubernetes-Infrastruktur mit einem
[4-Node-Cluster](./docs/requirements_poc.md#maschinengröße) auf Basis von vanilla Kubernetes.

## Infrastruktur

Das Helm Chart rollt die im Bild blau dargestellten Komponenten aus.

![Infrastruktur](./docs/images/Infrastruktur_Scope.jpg "Übersicht über die Infrastruktur")

## Voraussetzungen

- Bereitstellen der Basis-Images in eigener Registry, wenn die Images nicht direkt aus dem
Internet bezogen werden dürfen.
- Anpassung der [`values.yaml`](./values.yaml) zur Nutzung der richtigen Images und Registry
  - :pushpin: Informationen zur Bereitstellung der [Container-Basisimages](./docs/requirements_poc.md#container-basisimages)
  und [BundesMessenger Container Registry](https://gitlab.opencode.de/bwi/bundesmessenger/backend/container-images/)
- Bereitstellen des Helm Charts im eigenen Repository (`helm repo add`). In den Beispielen
`bundesmessenger`. Alternativ die Installation des Helm Charts aus dem Dateisystem (z.B. `./bundesmessenger/`).
- ([Sub-)Domains mit dazugehörigen TLS-Zertifikaten](./docs/requirements_poc.md#hostnamendns)
  ([Sicherheitshinweis](https://github.com/matrix-org/synapse/blob/develop/README.rst#security-note))
  - Eine (Sub-)Domain für den Applikationsserver z.B.: `matrix.example.com`
  (Parameter `serverName` bzw. `publicServerName`)
  - Eine (Sub-)Domain für den WebClient z.B. `app.example.com`, besser `app.example.net`
  - Eine (Sub-)Domain für die Administrationsoberfläche um den Zugriff zu separieren
  bzw. die Admin-Schnittstelle vor öffentlichen Zugriff zu schützen (Parameter `synapse_admin.uri`)
- [Kubernetes](https://kubernetes.io/) 1.19+
- [Helm](https://helm.sh/) 3.0+
- Ingress Controller (NginX) im Cluster installiert
  - *Optional: Nicht Policy-Konform: Bei Nutzung von CoTurn des Helm Charts, muss der
  IngressController den Port 3478 TCP zugefügt werden (Patch) oder durch vorgeschalteten
  Reverse-Proxy an die Nodeports direkt durchgeleitet werden. Weiterhin müsste bei der
  Nutzung von CoTurn innerhalb von K8s ein weiterer NginX-Controller installiert werden,
  welcher sich um den UDP-Traffic kümmert **(nicht empfohlen)***
- vorgelagerte Loadbalancer und vorkonfigurierte Firewalls, um den Service in vollem Umfang zu nutzen
  - *Optional: bei Nutzung von CoTurn wird ein NginX-Reverse-Proxy empfohlen, der die TCP/UDP-Streams weiterleitet. Das ist nicht policykonform, da Host-Ports angesprochen werden müssen.*
- *Optional: Storage muss `PersistentVolumeClaims` zulassen und konfiguriert haben (von Vorteil für die Datenbank und Media)*
- Zugriff auf vorhandenen [PostgreSQL](https://www.postgresql.org/) Server (konform zur DVS)
  - Datenbank `synapse_db` mit einem Benutzer `synapse`.
  - Server muss aus dem k8s-Namespace erreichbar sein
  - :pushpin: **Hinweis:** Collation und cType müssen auf `C` gesetzt sein. Siehe
  [Postgresql-Datenbank](./docs/requirements_poc.md#postgresql-datenbank)
- *Optional: ein `existingClaim` (persistent volume claim) mit dem Namen `matrix-synapse` (empfohlen 10 GB) für den Media-Worker als Speicher.*

:pushpin: **Hinweis:** Sollte die `storageClass` `nfs-client` nicht existent sein, muss diese erstellt oder mit dem folgenden Parameter gesetzt werden:

```console
helm install bundesmessenger bundesmessenger/bundesmessenger --set persistence.storageClass=STORAGECLASS
```
:pushpin: **Hinweis:** Alternativ können auch dynamisch erstellte PersistentVolumeClaim (PVC) genutzt werden, wenn eine entsprechende [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/) mit CSI-Volume-Plug-ins [(**C**ontainer **S**torage **I**nterface](https://kubernetes.io/docs/concepts/storage/volumes/#csi)) konfiguriert wurde.

| :warning: Zum aktuellen Zeitpunkt stellt das Helm Chart die Infrastruktur auf Basis eines `http`-Listeners bereit.<br />Vor der Infrastruktur muss ein Loadbalancer oder Reverse-Proxy für die Bereitstellung der `https`-Verbindung sorgen und ein Offloading durchführen. |
| --- |

| :pushpin: Matrix benötigt valide TLS-Zertifikate um voll funktionsfähig zu sein. <br /> :warning: Diese müssen von einer öffentlichen CA abgeleitet sein, wenn die mobilen Clients genutzt werden. :warning: |
| --- |


## Option 1: Domain entspricht den Benutzernamen (ohne Delegation)

Für eine möglichst einfache Matrix-Installation, können Sie Ihre Synapse-Installation
auf der gewünschten Domain für Ihre MXIDs ausführen. Eine [Delegation](#delegation) ist nicht notwendig.

**Die Server-Adresse `example.com` entspricht den Benutzernamen `@localpart:example.com`.**

```console
helm install bundesmessenger bundesmessenger/bundesmessenger \
  --set serverName=example.com \
  --set wellknown.enabled=true
```

Es wird bereitgestellt:

- Synapse für Client- und Föderations-Verbindungen auf `example.com/_matrix`
- lighttp Server für well-known-Anfragen auf `example.com/.well-known/matrix/server`

Es ist auch möglich, Synapse auf einer Subdomain (`matrix.example.com`) laufen zu lassen,
wobei diese dann Teil Ihrer MXIDs wird: (`@localpart:matrix.example.com` in folgenden Beispiel)

```console
helm install bundesmessenger bundesmessenger/bundesmessenger \
  --set serverName=matrix.example.com \
  --set wellknown.enabled=true
```

## Option 2: Domain entspricht nicht den Benutzernamen (mit Delegation)

Für den Fall, Sie besitzen die Domain `example.com` und Sie wollen Benutzernamen in der
Form `@localpart:example.com`, aber dennoch den Server unter der Domain
`matrix.example.com` laufen lassen, kann dies durch [Delegation](#delegation)
erreicht werden. Hierfür gibt es zwei Möglichkeiten: DNS (:warning: nicht empfohlen) oder well-known.

**Die Server-Adresse `matrix.example.com` ist unabhängig von den Benutzernamen `@localpart:example.com`.**

- Für die **well-known-Variante** erfolgt die Installation wie folgt:

  ```console
  helm install bundesmessenger bundesmessenger/bundesmessenger \
    --set serverName=example.com \
    --set publicServerName=matrix.example.com \
    --set wellknown.enabled=true
  ```

  Es wird bereitgestellt:

  - Synapse für Client- und Föderations-Verbindungen auf `matrix.example.com/_matrix`
  - lighttp Server für well-known-Anfragen auf `example.com/.well-known/matrix/server`

  :pushpin: Sie benötigen zusätzlich zum Zertifikat für `matrix.example.com` ein weiteres für `example.com`.

  :pushpin: Falls die Domain `example.com` nicht in diesem K8s Cluster gehostet wird, kann der well-known Eintrag auch manuell auf dem Server `example.com` erstellt und gehostet werden.

  Die Funktionsweise der [Delegation mit well-known](#delegation) wird weiter oben beschrieben.

- Für die **DNS-Variante** installieren Sie den Messenger-Service wie folgt:

  ```console
  helm install bundesmessenger bundesmessenger/bundesmessenger \
    --set serverName=example.com \
    --set publicServerName=matrix.example.com
  ```

  Es wird bereitgestellt:

  - Synapse für Client- und Föderations-Verbindungen auf `matrix.example.com/_matrix`

   Zusätzlich wird für die Föderation der DNS SRV-Record benötigt, siehe dem [Kapitel zur Delegation](#delegation).

| :pushpin: Weitere Setups, Erweiterungen und Services wie Loadbalancer und TLS-Listener werden noch folgen. |
| --- |

## Erster Benutzer

Nach der Installation sind in der Umgebung keine Benutzer vorhanden.

* [Dokumentation um den ersten Benutzer anzulegen](./docs/nutzerverwaltung.md)

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

## Weiterführende Dokumentation

Eine Anweisung für die Installation einer PoC-Umgebung finden Sie hier, so wie auch Hinweise zu den einzelnen zusätzlichen Diensten:

- [PoC Requirements](./docs/requirements_poc.md)
- [Benutzerverwaltung](./docs/nutzerverwaltung.md)
- [BundesMessenger WebClient](./docs/webclient.md)
- [Synapse Admin](./docs/synapse_admin.md)
- [TURN (Audio / Video)](./docs/turn.md)
- [Sygnal (Push-Service)](./docs/sygnal_push.md)

# Kontakt und Austausch

Für Fragen zur Anwendung des Helm-Charts, Konfiguration, Deployment und BundesMessenger
haben wir einen [Matrix Raum](https://matrix.to/#/#opencodebum:matrix.org) erstellt.

<div align="center">
  <img src="https://gitlab.opencode.de/bwi/bundesmessenger/info/-/raw/main/images/qr_matrix_room.png" alt="QR Code Matrix">
</div>

Kein Matrix Client zur Hand, dann auch gerne über unser [Email Postfach](mailto:bundesmessenger@bwi.de).

Wir freuen uns auf den Austausch.
