# Anforderungen

Um mit einer PoC-Installation zu beginnen, müssen mehrere Dinge berücksichtigt
werden, die in diesem Leitfaden behandelt werden:

- [Ausbaustufen des Deployments](#ausbaustufen-des-deployments-vom-bundesmessenger)
- [Requirements für die Konfiguration](#requirements-für-die-konfiguration)
- [Hostnamen/DNS](#hostnamendns)
- [Maschinengröße](#maschinengröße)
- [Container-Basisimages](#container-basisimages)
- [Betriebssystem K8s](#betriebssystem-k8s)
- [Benutzer](#benutzer)
- [Netzwerkbesonderheiten](#netzwerkbesonderheiten)
- [Postgresql-Datenbank](#postgresql-datenbank)
- [SSL-Zertifikate](#ssl-zertifikate)
- [Zusätzliche Konfigurationselemente](#zusätzliche-konfigurationselemente)
  - [Backup](#backup)
  - [BestPractise](#bestpractise)
  - [Kyverno](#kyverno)

Sobald diese Bereiche abgedeckt sind, können Sie eine PoC-Umgebung installieren!

## Ausbaustufen des Deployments vom BundesMessenger

| Größe | Module | Typ |
| ------ | ------ | ------ |
| Default | Synapse-Main, generische Worker Nodes (2), Media Repository (1), Redis Server, Ingress-Ressourcen | Default minimum |
| Minimum PoC | Synapse-Main, Redis Server, Ingress-Ressourcen | Minimum für PoC / Demo |
| Full PoC | Synapse-Main, generische Worker Nodes (2), Media Repository (1), Redis Server, Ingress-Ressourcen, Webclient, Contentscanner, ClamAV, Wellknown-Server, Synapse-Admin, Anbindung an Monitoring | vollwertiges PoC Deployment |
| Full-Stack Deployment | Synapse-Main, generische Worker Nodes (2), Media Repository (1), Redis Server, Ingress-Ressourcen, Webclient, Contentscanner, ClamAV, Wellknown-Server, Synapse-Admin, PostgreSQL, spezifische Worker für Userdirectory (Nutzerverzeichnis) usw., Anbindung an Monitoring | Deployment aller möglichen und benötigten Module aus dem HelmChart. |

## Maschinengröße

Für die Durchführung eines Proof of Concept mit unserem Installationschart
unterstützen wir nur die x86_64-Architektur (Virtualisiert oder BareMetall)
und empfehlen die folgenden Mindestanforderungen an Ressourcen in einem
Kubernetes-Cluster.

### Für die Ausbaustufe Minimum PoC oder Default

| Ausführung | Anzahl Worker Nodes | Ressourcen Worker-Nodes | Anzahl Control-Planes (Master-Nodes) | Ressourcen Control-Plane |
| ------ | ------ | ------ | ------ | ------ |
| Ohne Föderation | 2 | je 2 vCPUs/CPUs und 8 GB RAM | 1 | 2 vCPUs und 4GB RAM |
| Mit Föderation (experimentell) | 3 | je 4 vCPUs/CPUs und 16 GB RAM | 3 | 2 vCPUs und 4GB RAM |

### Für die Ausbaustufe Full PoC bzw. Full-Stack Deployment

| Ausführung | Anzahl Worker Nodes | Ressourcen Worker-Nodes | Anzahl Control-Planes (Master-Nodes) | Ressourcen Control-Plane |
| ------ | ------ | ------ | ------ | ------ |
| Ohne Föderation | 4 | je 4 vCPUs/CPUs und 8 GB RAM | 1 | 4 vCPUs und 4GB RAM |
| Mit Föderation (experimentell) | 5 | je 4 vCPUs/CPUs und 16 GB RAM | 3 | 2 vCPUs und 4GB RAM |

:pushpin: **Hinweis:** Es wird empfohlen auf mehr als eine Master-Node zu
setzen. Weiterhin ist eine zusätzliche Node (VM oder BareMetall), welche
persistenten Speicher präsentiert, von Vorteil. Diese Funktionalität sollte
vom Plattformbetreiber zur Verfügung gestellt werden und ist **kein**
Bestandteil des Helm Charts.

## Requirements für die Konfiguration

Die folgenden Punkte sind abhängig zu der Bedingung zu Konfigurieren,
damit ein Deployment möglich und erfolgreich ist.

Eine Musterkonfiguration ist in der [Installationsanleitung](./installation_testumgebung.md#bundesmessenger)
enthalten.

| Konfigurationsparameter | Bedingung | Bemerkung |
| ------ | ------ | ------ |
| `dataPrivacyUrl` | `wellknown.enabled: true` | DSGVO verpflichtende URL für die per Internet abrufbare Datenschutzbestimmungen. |
| `imprintUrl` | `wellknown.enabled: true` | URL für das per Internet abrufbare Impressum des Betreibers. |
| `serverName` bzw. `publicServerName` | Eine ist verpflichtend | Öffentlich (oder teilöffentlich bzw. Nutzerkreis bekannter) präsentierter Endpunkt bzw. MXID der Nutzer. |
| `adminAPIServerName` | verpflichtend | Zur Trennung des Admin-API Interfaces des Synapse vom öffentlichen präsentierten Kontaktpunkt. |
| `sygnal.apns` | `sygnal.enabled: true` | Werden von der BWI GmbH für die mobilen Clients zur Verfügung gestellt und beim Deployment zusätzlich eingebunden. |
| `externalPostgresql.host` | `postgresql.enabled: false` | Wenn kein PostgreSQL-Server (für Synapse) im Zuge des Deployments erstellt werden soll, muss zwingend eine URL zum erreichen eines externen PostgreSQL-Servers konfiguriert werden. (inklusive Zugangsdaten!) |
| `externalmasPostgresql.host` | `maspostgresql.enabled: false` | Wenn kein PostgreSQL-Server (für MAS) im Zuge des Deployments erstellt werden soll, muss zwingend eine URL zum Erreichen eines externen PostgreSQL-Servers konfiguriert werden. (inklusive Zugangsdaten!) |
| `externalRedis.host` | `redis.enabled: false` | Wenn kein eigener Redis-Server installiert werden soll, muss zwingend die URL eines externen Redis-Server konfiguriert werden. (inklusive Zugangsdaten!) |
| Alle Ingress-Routen und Network policies | `ingress.enabled.false` | Alle Routen und Network-Policies müssen manuell konfiguriert werden, wenn kein DVS-Standard Ingress-Controller nicht vorhanden ist und in der Konfiguration deaktiviert wurde. |
| `schadcodescanner.freshclam.mirrors` | eigener lokaler privater Mirror, da Zugriff auf Internet nicht möglich | Hier kann und muss eine Liste von privaten Mirrors für den eingesetzten ClamAV Updater freshclam hinterlegt werden, wenn ein Zugriff auf den offiziellen Server unter database.clamav.net nicht möglich ist. |
| `synapse_admin.uri` | `synapse_admin.enabled: true` | Wenn der Synapse-Admin (kein MAS Support) genutzt werden soll, kann eine sich von `adminAPIServerName` unterscheidende URL konfiguriert werden (empfohlen). |
| `adminPortal.uri` | `adminPortal.enabled: true` | Wenn das BundesMessenger Admin-Portal (mit MAS Support) genutzt werden soll, kann eine sich von `adminAPIServerName` unterscheidende URL konfiguriert werden (empfohlen). |
| `webclient.uri` | `webclient.enabled: true` | Wenn der Webclient genutzt werden will, muss eine entsprechende URL für die WebGUI konfiguriert werden. |
| `call.standalone.uri` | `call.standalone.enabled: true` | Wenn der [standalone Call Client](./huddle-meetings.md#standalone-bundesmessenger-call-client) genutzt werden will, muss eine entsprechende URL für die WebGUI konfiguriert werden. |
| `displayName` | `webclient.enabled: true` | Der Anzeigename des Messengers im Webclient. Default: `Messenger deiner Organisation`. |

## Hostnamen/DNS

Sie benötigen Hostnamen inkl. DNS-Auflösung für die folgenden Infrastrukturkomponenten:

| Komponente | Status | Parameter | Bemerkung |
| ------ | ------ | ------ | ------ |
| Synapse | erforderlich | `serverName` bzw. `publicServerName` | |
| Synapse | erforderlich | `adminAPIServerName` | Für die Trennung der Admin-API von Synapse und dem öffentlich zugänglichen Endpunkt des Synapse. |
| [WebClient](webclient.md) | optional, aber empfohlen | `webclient.uri` | Kann aktiviert werden mit `webclient.enabled=true`. <br /> Der inkludierte gehärtete WebClient des BundesMessenger wird hauptsächlich für den "internen" Gebrauch ausgelegt und per Browser aufgerufen. <br /> Für die externe Nutzung von Clients über mobile Endgeräte stehen die Apps des BundesMessengers zur Verfügung. |
| Call Standalone | optional bei Nutzung von Call | `call.standalone.uri` | Kann aktiviert werden mit `call.standalone.enabled=true`. <br /> Der [standalone Call Client](./huddle-meetings.md#standalone-bundesmessenger-call-client) des BundesMessenger kann ohne den WebClient genutzt über diese URL aufgerufen werden. |
| [Synapse-Admin](synapse-admin.md) | optional, aber empfohlen | `synapse_admin.uri` | Empfohlen für eine Erreichbarkeit nur von intern, `.local`-Domain, ansonsten muss eine zusätzliche Sicherheitsbarriere hier berücksichtigt werden :smiley:<br />Kann aktiviert werden mit `synapse_admin.enabled=true`. |
| Monitoring | empfohlen | tbd | ToDo |

## Container-Basisimages

Es werden eigene CI-Pipelines aufgebaut um eigene Applikations- bzw.
Basis-Images im OpenCoDE zur Verfügung zu stellen.

- [BundesMessenger Container Registry](https://gitlab.opencode.de/bwi/bundesmessenger/backend/container-images/)

Das Veröffentlichen eigener Basis-Images stellt eine Verbreitung von
Linux-Distribution dar. Daher werden wir zur Herstellung unserer
Applikations-Images auf spezielle Basis-Images aufbauen.

Folgende Optionen werden in Betracht gezogen:

- eigene Base Images auf Basis von Ubuntu Jammy
- [OSADL Basis-Image](https://www.osadl.org/OSADL-Docker-Base-Image.osadl-docker-base-image.0.html)
- DVS Basis-Image (noch nicht verfügbar)

## Betriebssystem K8s

ToDo: *Empfehlung: Als Betriebssystem für die k8s-Worker wird Debian empfohlen,
da dort `iptables-legacy-mode` ohne große Umstände mit der aktuellen Version
von kubelet und containerd.io lauffähig ist.*

## Benutzer

Es wird empfohlen im Rahmen das PoC auf alle sicherheitsrelevanten Umgebungs-
und Rahmenbedingungen zu achten. Dazu zählen nicht privilegierte Benutzer auf
den Maschinen um dort eventuelle Arbeiten umzusetzen. Damit ist eine lauffähige
und stabile Infrastruktur gewährleistet.

## Netzwerkbesonderheiten

Das Helm Chart unterstützt IPv4-Only Netzwerke über die Konfiguration des
Schalter `ipv4Only=true`.

Der Messengerservice muss Inhalte binden und bereitstellen über:

- Port 80 TCP (bei SSL Offload vor dem Kubernetes)
- Port 443 TCP

Entsprechende Ports müssen auch entweder lokal auf der PoC-Umgebung freigegeben
werden oder in der vorgeschalteten Sicherheitsinfrastruktur.

Für zusätzliche Dienste wie CoTurn, müssen die entsprechenden Ports in der
Sicherheitsinfrastruktur freigegeben werden:

- Port 3478 UDP/TCP
- Port 5349 TCP (bei TLS)

## PostgreSQL-Datenbank

Die Installation erfordert, dass Sie eine PostgreSQL-Datenbank mit einem
`locale` von `C` und `encoding` `UTF8` eingerichtet haben.
Siehe [Synapse Dokumentation](https://element-hq.github.io/synapse/latest/postgres.html#set-up-database)
für weitere Details.

Zusätzlich benötigen Sie auch eine Datenbank für den MAS.
Siehe [MAS Dokumentation](https://element-hq.github.io/matrix-authentication-service/setup/database.html)

Wenn Sie diese bereitgestellt haben, notieren Sie sich bitte den
Datenbanknamen, den Benutzer und das Passwort, da Sie diese benötigen, um mit
der Installation zu beginnen. (per Parameter zu übergeben, in der
`values.yaml` anzupassen bzw. als k8s-Secret konfigurieren.)

Wenn Sie noch keine Datenbank haben, richten Sie sich eine Datenbank nach den
Vorgaben im Kubernetes ein. Die Nutzung eines SubChart für die Einrichtung des
PostgreSQL wäre über das Chart möglich. Es ist aber davon abzuraten und ein
selbstständige Installation über HelmChart oder manuelle Installation
umzusetzen.

*Optional: Es kann das Helm-Chart mit dazu verwendet werden im gleichen
Namespace einen PostgreSQL-Server mit entsprechender Konfiguration
bereitzustellen. Das ist für den PoC auch funktional, sollte aber in eine
stabile DVS-konforme Version überführt werden. Dazu kann auch das Subchart für
den PostgreSQL-Server entsprechend angepasst werden, dass ein eigener Namespace
für einen "externen" Datenbankserver verwendet wird. Dabei ist zu beachten,
dass diese Bereitstellung losgelöst vom BundesMessenger umgesetzt wird, da
sonst die kyverno-Regeln hier einen Verstoß melden würden.*

## SSL-Zertifikate

Es wird empfohlen, wie auch in der folgenden Installationsanweisung, valide
TLS-Zertifikate für alle genutzten Domains auf dem der Synapse-Host und die
verknüpften Services (siehe: [Hostnamen/DNS](#hostnamendns)) erreichbar sind,
zur Verfügung zu stellen.

:warning: Weiterhin wird empfohlen, diese Zertifikate gegen eine öffentliche
und offizielle CAs signieren zu lassen, damit die mobilen Clients des
BundesMessenger diese auch abrufen können. Selbstsignierte Zertifikate werden
nicht in den Client importiert und nicht vertraut, eine Kommunikation ist
damit nicht möglich!

Die Bereitstellung (Ausstellung bzw. Generierung) der TLS-Zertifikate ist nicht
Bestandteil dieses Helm Charts. Vorhandene Zertifikate können den Ingress-Ressourcen
mit Hilfe von Secrets über den Parameter `ingress.tls` übergeben werden.

Beispiel:

```yaml
ingress:
  tls:
    # Enthält für alle benötigten Domains die notwendigen Secrets bzw. TLS-Zertifikate
    - secretName: chart-example-tls
      hosts:
        - example.com
        - matrix.example.com
    - secretName: admin-example-tls
      hosts:
        - admin.example.com
```

Alternativ kann vor der Infrastruktur ein Loadbalancer oder Reverse-Proxy für
die Bereitstellung der `https`-Verbindung sorgen und ein Offloading durchführen.

## Zusätzliche Konfigurationselemente

Die Anbindung an eine IAM-Sicherheitsinfrastruktur ist noch ein offener Punkt,
der während des PoCs zur Klärung bereit ist.
Einhergehend auch die Thematik Single Sign-on (SSO) per SAML, OIDC oder anderen
Mechaniken.

### Backup

Für den Messenger ist die Datenbank der Hauptfokus, zusammen mit dem
`signing-key` von Matrix. Dahingehend muss die Datenbank persistiert und
regelmäßig gesichert werden. Der Schlüssel liegt als Secret im laufenden
Deployment und sollte gesichert werden. Für ein aktives Redeployment, bzw.
Migration in eine andere Umgebung (z.B. Produktionsumgebung), wird dieser
Schlüssel benötigt und kann bei der initialen Ausführung des Helm-Charts
mit angegeben werden:

```yaml
extraConfig:
#  old_signing_keys:
#    "ed25519:id": { key: "base64string", expired_ts: 123456789123 }
```

### BestPractise

- Netzwerk Policies
- Noch im ToDo
- Wahl der Domain und Delegation

### [Kyverno](https://kyverno.io/)

Siehe Dokumentation der einzelnen Rulesets im Dokument [DVS Policies retentions](./dvs-policies-restrictions.md)
