# Upgrade-Strategie – Überblick

Dieser Abschnitt beschreibt die unterstützten Upgrade-Pfade bei
einem Upgrade von `v1.x` auf `v2.x` und erforderlichen
Schritte beim Wechsel zwischen unterschiedlichen Konfigurations- und Funktionsständen.
Er dient als kurze Erläuterung für die [`CHANGELOG.md`](./CHANGELOG.md) und verweist
auf die jeweils detaillierte Dokumentation.

---

## Upgrade bei interner Datenbank-Subchart-Nutzung

Wird das interne (Bitnami) PostgreSQL-Subchart verwendet, muss dieses zuerst migriert
werden, bevor weitere Upgrade-Schritte durchgeführt werden können.

- Erforderliche Maßnahme: Migration auf internen Datenbank-Subchart von CloudPirates
- Dokumentation: [`PostgreSQL-Upgrade-Advanced.md`](./docs/postgresql-upgrade-advanced.md)

## Upgrade auf MAS-basierte Benutzerverwaltung und Authentifizierung

Der Wechsel auf den Matrix-Authentication-Service (MAS) erfordert einen
dedizierten Migrationsschritt. Die Migration und Verwendung von MAS ist aktuell
noch nicht erforderlich. Der MAS ist jedoch für die Benutzung der neuen
BuMX Apps erforderlich.

- Erforderliche Maßnahme: Durchführung der MAS-Migration
- Dokumentation: [`matrix-authentication-service-migration.md`](./docs/matrix-authentication-service-migration.md)
- Umfang:
  - Migration von Benutzer- und Authentifizierungsdaten
  - Abgleich der Konfiguration zwischen Synapse und MAS
  - Validierung der Migrationsvoraussetzungen

## Upgrade von Synapse mit aktiviertem MAS

Für Umgebungen, in denen MAS bereits im Einsatz ist, ist kein separates
Migrationsverfahren erforderlich.
Dennoch müssen bestimmte Konfigurationsschalter überprüft und angepasst
werden.

Folgende Werte
verschieben sich von `mas` zu `mas.extraConfig`: `clients`, `passwords`,
`email`, `upstream_oauth2_provider`, `account`, `policy`.

Für diesen Upgrade-Pfad ist keine eigene Migrationsanleitung erforderlich,
es sind ausschließlich Konfigurationsanpassungen vorzunehmen.

## MAS standardmäßig aktiviert ab Helm Chart Version `v2.1.0`

Ab der nächsten Version (`v2.1.0`) ist MAS standardmäßig aktiviert.

- Bestehende Installationen ohne MAS müssen diesen entweder explizit deaktivieren
  `mas.enabled: false` oder vorab die MAS-Migration durchführen
- Neuinstallationen nutzen automatisch die MAS-basierte Authentifizierung
- Legacy-Authentifizierungsmechanismen gelten als veraltet

---

Für detaillierte Schritt-für-Schritt-Anleitungen wird auf die jeweils verlinkten
Dokumente verwiesen. Diese Dokumentation dient als übergeordnete Upgrade-Übersicht
und Änderungshinweis.
