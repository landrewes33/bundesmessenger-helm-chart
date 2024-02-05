# Readme `changelog.d`

Dieses Verzeichnis enthält "Newsfragmente", das sind kurze Dateien, die einen
kleinen `Markdown` Text enthalten, der dem nächsten [`CHANGELOG`](../CHANGELOG.md)
hinzugefügt wird.

Alle Änderungen, auch kleinere, benötigen einen entsprechenden Newsfragment-
Eintrag. Diese werden von [Towncrier](https://github.com/twisted/towncrier)
verwaltet.

Das `CHANGELOG` wird von Benutzern gelesen werden, daher sollte diese
Beschreibung an die Benutzer gerichtet sein, anstatt interne Änderungen
zu beschreiben, die nur für die Entwickler relevant sind.
Achten Sie darauf, ganze Sätze in der Vergangenheit oder Gegenwart zu verwenden.

Um einen Changelog-Eintrag zu erstellen, legen Sie eine neue Datei im Verzeichnis
`changelog.d` mit dem Namen im Format `MR-Nummer.Typ` an.
Der Typ kann einer der folgenden sein:

- `notes` (Für explizite Hinweise zur Version (Release Notes).
Diese sollte immer nur zusätzlich zu einem normalen Changelog-Eintrag erstellt werden)
- `feature`
- `bugfix`
- `doc` (für Aktualisierungen von Dokumentation)
- `removal` (auch für Abkündigungen)
- `wip` (in Arbeit (work in progress))
- `misc` (für interne Änderungen)

Zusätzlich können Einträge ohne Zuordnung zu einem Merge-Request erstellt werden.
Hierfür muss die Datei mit `+` beginnen, z.B.: `+something-unique.misc`.

Diese Datei wird bei der nächsten Veröffentlichung Teil unseres Changelogs,
daher sollte der Inhalt der Datei eine kurze Beschreibung der Änderung
im gleichen Stil wie der Rest des Changelogs sein. Die Datei kann
Markdown-Formatierungen enthalten und muss aus Gründen der Konsistenz
mit einem Punkt (.) oder einem Ausrufezeichen (!) enden.

Wenn mehrere Merge-Requests an einem Bugfix/Feature/etc. beteiligt sind,
sollte der Inhalt jeder changelog.d-Datei der gleiche sein.
Towncrier wird die übereinstimmenden Dateien in einem einzigen
Changelog-Eintrag zusammenführen.

Um das Changelog in der Vorschau anzuzeigen, verwende:

```console
towncrier build --draft --version 1.2.3
```
