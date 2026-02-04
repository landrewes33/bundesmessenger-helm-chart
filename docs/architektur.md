# Architektur des BundesMessenger Helm Charts

## Ziel dieses Dokuments

Dieses Dokument beschreibt die **Architektur des BundesMessenger Backends**,  
wie sie durch das bereitgestellte **Helm Chart** in einem Kubernetes-Cluster
ausgerollt wird.

Der Fokus liegt auf:

- Komponentenübersicht
- Zusammenspiel der Services
- Netz-, Storage- und Betriebsaspekten
- Abgrenzung zu externen Systemen

Dieses Dokument dient als **Architektur- und Orientierungsdokument** und
ergänzt:

- [README.md](../README.md)
- [Betriebs- und Detaildokumentation](../README.md#betrieb) unter `docs/`

## Überblick

Das BundesMessenger Backend basiert auf dem **Matrix-Ökosystem** und wird als
**containerisierte, skalierbare Plattform** in Kubernetes betrieben.

Zentrale Eigenschaften:

- [Kubernetes](https://kubernetes.io/)-native Architektur
- [Helm](https://helm.sh/)-basiertes Deployment
- Trennung von Kern- und Zusatzdiensten
- Skalierbarkeit über Worker-Konzepte
- Integration externer Infrastruktur (z.B. PostgreSQL)

## Logische Architektur

Auf hoher Ebene besteht die Architektur aus folgenden Schichten:

1. [Client-Ebene](#client-ebene)
2. [Ingress- und Routing-Ebene](#ingress--und-routing-ebene)
3. [Authentifizierungs- und Identitäts-Ebene](#authentifizierungs--und-identitäts-ebene)
4. [Applikations-Ebene](#applikations-ebene-synapse-core)
5. [Worker- und Nebenservices](#worker-architektur)
6. [Persistenz- und externe Dienste](#persistenz-und-externe-systeme)
7. [Monitoring und Administration](#monitoring-und-observability)

## Komponentenübersicht

### Client-Ebene

Clients greifen ausschließlich über HTTPS auf das Backend zu.

Typische Clients:

- BundesMessenger WebClient
- Mobile Matrix-Clients
- Föderierte externe Matrix-Server

### Ingress- und Routing-Ebene

#### Ingress Controller

- Terminiert TLS (extern oder vorgeschaltet)
- Routing anhand von Hostnamen und Pfaden
- Weiterleitung an interne Services

Typische Endpunkte:

- `/_matrix` – Client- und Föderations-API
- `/.well-known/matrix/server` – Delegation
- [WebClient](#bundesmessenger-webclient)
- [Admin-Oberflächen](#web--und-admin-oberflächen)

## Authentifizierungs- und Identitäts-Ebene

### Matrix Authentication Service (MAS)

Der [Matrix Authentication Service (MAS)](https://github.com/element-hq/matrix-authentication-service)
ist ein eigenständiger Dienst zur
modernen Authentifizierung und Autorisierung im Matrix-Ökosystem.

Er ersetzt bzw. erweitert klassische Synapse-interne Authentifizierungsmechanismen
und dient als **zentrale Identitäts- und Login-Komponente**.

#### Aufgaben

- Benutzeranmeldung (Login)
- Token-Ausstellung (Access Tokens)
- Unterstützung moderner Authentifizierungsflüsse
- Integration externer Identity Provider
- Vorbereitung auf zukünftige Matrix-Auth-Standards

#### Architekturrolle

- Betrieb als **separater Kubernetes Service**
- Anbindung über Ingress
- Enge Kopplung an Synapse über definierte APIs
- Eigene Konfiguration und Secrets

MAS agiert logisch **zwischen Client und Synapse**:

- Clients authentifizieren sich gegenüber MAS
- Synapse validiert Tokens, die durch MAS ausgestellt wurden

#### Typische Integrationen

- OpenID Connect (OIDC)
- Externe Behörden- oder Organisations-IdPs
- Single Sign-On (SSO)

#### Sicherheitsaspekte

- TLS zwingend erforderlich
- Klare Trennung von öffentlichem Login-Endpunkt und internen APIs
- Token-Lebenszeiten und Scopes zentral steuerbar

### Applikations-Ebene (Synapse Core)

#### Synapse Homeserver

- Zentrale [Matrix-Server-Implementierung](https://github.com/element-hq/synapse)
- Zuständig für:
  - Benutzerverwaltung
  - Raum- und Nachrichtenlogik
  - Föderation
- Authentifizierung erfolgt über:
  - Matrix Authentication Service

Deployment-Typ:

- Kubernetes Deployment (Master / Frontend)

### Worker-Architektur

Zur Skalierung nutzt das Helm Chart mehrere **Synapse Worker**:

Typische Worker-Typen:

- Generic Worker
- Media Worker
- Federation Worker
- Client Reader / Writer

Merkmale:

- Betrieb als **StatefulSets**
- Horizontale Skalierung möglich
- Entkopplung von Lastspitzen
- Gemeinsamer Zugriff auf Datenbank und Medien

### Nebenservices

#### Redis

- In-Memory Datenspeicher
- Caching
- Queue-Mechanismen
- Entlastung der Datenbank

#### Sygnal (Push Service)

- Zuständig für Push-Benachrichtigungen
- Anbindung an:
  - Apple Push Notification Service
  - Google Firebase Cloud Messaging

#### Matrix Content Scanner

- Analyse hochgeladener Medien
- Übergabe an Virenscanner
- Sicherheitsrelevante Inhaltsprüfung

#### ClamAV

- Virenscan für Medieninhalte
- Integration über Content Scanner
- Separat skalierbar

### Web- und Admin-Oberflächen

#### BundesMessenger WebClient

- Browserbasierter Matrix-Client
- Bereitstellung über Ingress
- Gehärtete Variante für den Einsatz im Behördenumfeld

#### Synapse Admin

- Administrationsoberfläche für Synapse
- Benutzer- und Raumverwaltung
- Empfohlen:
  - Interne Domain
  - Kein öffentlicher Zugriff

#### Admin-Portal

- Erweiterte Administrationsfunktionen
- Trennung von operativer und administrativer Nutzung

## Persistenz und externe Systeme

### PostgreSQL (extern)

- Zentrale Persistenz für Synapse **und MAS**
- Enthält:
  - Benutzer
  - Räume
  - Events
  - State
  - Authentifizierungs- und Token-Daten
- **Nicht Bestandteil des Helm Charts**

Wichtige Eigenschaften:

- Muss hochverfügbar betrieben werden
- Collation und CType auf `C`
- Regelmäßige Backups erforderlich

### Storage (Kubernetes)

- PersistentVolumeClaims für:
  - Medien
  - Worker-spezifische Daten
- Unterstützung für:
  - CSI-Storage
  - NFS
  - Block-Storage

## Monitoring und Observability

### Prometheus

- Service-Monitoring via ServiceMonitor
- Metriken für:
  - Synapse
  - Worker
  - Matrix Authentication Service

### Grafana

- Visualisierung von:
  - Authentifizierungsflüssen
  - Token-Ausstellung
  - Login-Fehlern
  - Synapse- und Worker-Last

## Netzwerk- und Sicherheitsaspekte

- Interne Kommunikation über Cluster-Netzwerk
- Externe Kommunikation ausschließlich über Ingress
- TLS zwingend erforderlich
- Trennung öffentlicher und interner Domains empfohlen
- Föderation optional deaktivierbar
- Zentrale Authentifizierung über MAS reduziert Angriffsfläche

## Föderation und Delegation

- Föderation erfolgt Server-zu-Server
- Delegation über:
  - `.well-known/matrix/server` (empfohlen)
- Entkopplung von:
  - Benutzer-Domain
  - Server-Adresse

Details:

- [Delegation] (/docs/delegation.md)
- [Matrix Spezifikation]

## Abgrenzung (nicht Bestandteil)

Folgende Komponenten sind **nicht Teil** des Helm Charts:

- DMZ-Infrastruktur
- Loadbalancer außerhalb des Clusters
- PAP-Infrastruktur
- Externe Identity Provider selbst
- Datenbankbetrieb

## Architekturprinzipien

- Kubernetes-First
- Infrastructure as Code
- Trennung von Authentifizierung und Fachlogik
- Skalierung über Worker
- Security by Design
- Reproduzierbarkeit
- Zukunftssichere Matrix-Authentifizierung

## Weiterführende Dokumentation

- [Authentifizierung und SSO](./matrix-authentication-service.md)
- [Föderation](./federation.md)
- [Monitoring](./monitoring-mit-grafana.md)
- [Delegation](./delegation.md)
