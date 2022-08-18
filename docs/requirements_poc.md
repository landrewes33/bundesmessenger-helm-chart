
Um mit einer PoC-Installation zu beginnen, müssen mehrere Dinge berücksichtigt werden, die in diesem Leitfaden behandelt werden:

1. [PoC](#poc)
    - [Hostnamen/DNS](#hostnamendns)
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
