# Upgrade-Strategie – Überblick

Dieser Abschnitt beschreibt die unterstützten Upgrade-Pfade und erforderlichen
Schritte beim Wechsel zwischen unterschiedlichen Konfigurations- und Funktionsständen.
Er dient als kurze Erläuterung für die `CHANGELOG.md` und verweist auf die
jeweils detaillierte Dokumentation.

---

## 1. Upgrade von interner DB-Subchart-Nutzung

Wird derzeit das interne PostgreSQL-Subchart verwendet, muss dieses zuerst migriert
werden, bevor weitere Upgrade-Schritte durchgeführt werden können.

- Erforderliche Maßnahme: Migration auf internen DB-Subchart von CloudPirates
- Dokumentation: `PostgreSQL-Upgrade-Advanced.md`

---

## 2. Upgrade auf MAS-basierte Authentifizierung

Der Wechsel auf den Matrix-Authentication-Service (MAS) erfordert einen
dedizierten Migrationsschritt.

- Erforderliche Maßnahme: Durchführung der MAS-Migration  
- Dokumentation: `matrix-authentication-service-migration.md`  
- Umfang:
  - Migration von Benutzer- und Authentifizierungsdaten  
  - Abgleich der Konfiguration zwischen Synapse und MAS  
  - Validierung der Migrationsvoraussetzungen

---

## 3. Upgrade von Synapse mit aktiviertem MAS

Für Umgebungen, in denen MAS bereits im Einsatz ist, ist kein separates
Migrationsverfahren erforderlich.
Dennoch müssen bestimmte Konfigurationsschalter überprüft und angepasst
werden.

Folgende Werte
verschieben sich von `mas` zu `mas.extraConfig`: `clients`, `passwords`,
`email`, `upstream_oauth2_provider`, `account`, `policy`.

Für diesen Upgrade-Pfad ist keine eigene Migrationsanleitung erforderlich,
es sind ausschließlich Konfigurationsanpassungen vorzunehmen.

---

## 4. MAS standardmäßig aktiviert ab nächster Version

Ab der nächsten Version ist MAS standardmäßig aktiviert.

- Bestehende Installationen ohne MAS müssen entweder explizit widersprechen oder
vorab die MAS-Migration durchführen  
- Neuinstallationen nutzen automatisch die MAS-basierte Authentifizierung  
- Legacy-Authentifizierungsmechanismen gelten als veraltet

---

Für detaillierte Schritt-für-Schritt-Anleitungen wird auf die jeweils verlinkten
Dokumente verwiesen. Diese Dokumentation dient als übergeordnete Upgrade-Übersicht
und Änderungshinweis.
