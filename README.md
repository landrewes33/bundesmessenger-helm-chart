<!-- markdownlint-disable -->
<div align="center">
  <img
    src="https://gitlab.opencode.de/bwi/bundesmessenger/info/-/raw/main/images/logo.png"
    alt="BundesMessenger Logo"
    width="256"
    height="256"
  />
  <h2>BundesMessenger Backend</h2>
  <p>Der souveräne Messenger für Deutschland</p>
</div>
<!-- markdownlint-enable -->

---

# BundesMessenger Backend Helm-Chart

Der BundesMessenger ist die sichere Kommunikationslösung für die öffentliche
Verwaltung. Allgemeine Informationen zum Gesamtprojekt befinden sich im
übergeordneten [BundesMessenger
Repository](https://gitlab.opencode.de/bwi/bundesmessenger/info).

Dieses Repository enthält das Helm-Chart zur automatisierten Bereitstellung des
BundesMessenger Backends.

## Enthaltene Komponenten

Das Helm-Chart stellt unter anderem folgende Komponenten bereit:

- [Synapse (Matrix Homeserver)](https://github.com/element-hq/synapse)
- [Matrix-Authentication-Service (Nutzermanagement und Authentifizierungsservice)](https://github.com/element-hq/matrix-authentication-service)
- WellKnown-Service (Delegation über HTTPS, ohne DNS-Änderungen vorzunehmen)
- [Admin-Portal (Administrationsoberfläche)](https://gitlab.opencode.de/bwi/bundesmessenger/admin-portal)
- [Sygnal](https://github.com/element-hq/sygnal) Push-Server für Google und Apple
- [BundesMessenger WebClient](https://gitlab.opencode.de/bwi/bundesmessenger/clients/bundesmessenger-web)
- Call Infrastruktur
- [Redis](https://redis.io/) In-Memory Datenbank
- [Matrix-Content-Scanner](https://github.com/vector-im/matrix-content-scanner-python)
- [ClamAV (optional)](https://www.clamav.net/)
- Kubernetes Ingress-Ressourcen

> :warning: Nicht Bestandteil sind DMZ-, PAP- oder vergleichbare Infrastrukturen.

## Architektur

Das Helm Chart stellt eine vollständige Matrix-Backend-Architektur bereit.

Ausführliche Informationen zur Architektur, Herkunft des Helm Charts und
den vorgenommenen Anpassungen sind in der folgenden Dokumentation beschrieben:

- [Architektur und Helm-Chart-Anpassungen](docs/architektur.md)

## Voraussetzungen

Die vollständigen technischen und infrastrukturellen Voraussetzungen sind
in der PoC Dokumentation beschrieben:

- [PoC Requirements](docs/requirements-poc.md)

Kurzfassung:

- Kubernetes 1.32+
- Helm 3.19+
- PostgreSQL 18+ (optional mit Chart)
- Ingress Controller / Gateway-API
- TLS Zertifikate

## Installation

Die Installation erfolgt mittels Helm.

Einstieg:

```console
helm repo add bundesmessenger https://gitlab.opencode.de/api/v4/projects/560/packages/helm/stable
helm install bundesmessenger bundesmessenger/bundesmessenger
```

Alle Installationsvarianten und Domain Setups:

- [Installationsanleitung](docs/installation.md)
- [Testumgebung](docs/installation-testumgebung.md)
- [Localhost Selfsigned Certmanager Setup](docs/simple-selfsigned-setup.md)
- [ArgoCD Hinweise](docs/argocd.md)

## Matrix Grundlagen

Grundlagen zu Matrix, MXIDs und Delegation:

- [Matrix Grundlagen](docs/matrix-basics.md)
- [Delegation](docs/delegation.md)

## Betrieb

- [DSGVO-Exporter](docs/dsgvo-exporter.md)
- [Upgrade Anleitungen](./UPGRADE.md)
- [Monitoring mit Grafana](docs/monitoring-mit-grafana.md)
- [Webclient](docs/webclient.md)
- [WellKnown](docs/wellknown.md)

## Weiterführende Dokumentation

Eine vollständige Übersicht aller Detaildokumente:

- [Dokumentationsübersicht](docs/README.md)

## Kontakt und Austausch

Für Fragen zur Anwendung des Helm-Charts, Konfiguration, Deployment und BundesMessenger
haben wir einen [Matrix Raum](https://matrix.to/#/#opencodebum:matrix.org) erstellt.

<!-- markdownlint-disable -->
<div align="center">
  <img src="https://gitlab.opencode.de/bwi/bundesmessenger/info/-/raw/main/images/qr_matrix_room.png" alt="QR Code Matrix">
</div>
<!-- markdownlint-enable -->

Kein Matrix Client zur Hand, dann auch gerne über unser [Email Postfach](mailto:bundesmessenger@bwi.de).

Wir freuen uns auf den Austausch.
