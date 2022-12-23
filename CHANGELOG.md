<!-- markdownlint-disable MD024 -->
# Changelog

## v1.1.0 (2022-12-22)

### Features

- der Webclient kann mit Version v2.1.0-b3 und später ohne direkte
`config.json` arbeiten (veränderbare Daten werden per initContainer übertragen)
- Hinzufügen von `extraEnv` für ClamAV, damit z.B. Proxy-Settings auch
auf den ClamAV-Pod gesetzt werden können
- Neue Tags und Versionen für die Container, siehe
[Dokumentation der Container](https://gitlab.opencode.de/bwi/bundesmessenger/backend/container-images/-/blob/master/README.md#versionierung-der-images)
- gesetzte Image-Tags sind Rollingtags per Default

### Fixed

- Fehlerbehebung im Image des Schadcodescanners (ClamAV)
- Service-Port vom Schadcodescanner auf Port `1344` für C-ICAP als default gesetzt
- Aktualisierung der Helm Dependencies
  - PostgreSQL `10.9.4` zu `12.1.6`
    - Bei Nutzung der integrierten Datenbank verändern sich die Verbindungs-
    Parameter zu `postgresql.auth`
  - Redis `16.1.0` zu `17.3.17`

## v1.0.1 (2022-12-16)

### Features

- Changelog hinzugefügt

### Fixed

- Aktualisierung der genutzten Images
- Ergänzung des `podSecurityContext` und `securityContext` für den
Wellknow-Service, Webclient und Synapse-Admin
- kleine Korrektur des Scannerscripts vom Contentscanner, entfernen von der
Umleitung auf `/dev/stdout`

## v1.0.0 (2022-12-15)

### Features

- Initiale Version und Veröffentlichung
