# Changelog

Die Angaben zu den Merge Requests verweisen auf die des internen Gitlabs.
Da im OpenCoDE ein Mirror eines internen BWI Repos liegt und beim Mirroring die
Git History neu geschrieben wird, sind die Merge Requests aktuell nicht verlinkt.

<!-- markdownlint-disable MD024 MD012 -->

<!-- towncrier release notes start -->
## BundesMessenger Helm Chart 1.1.0 (2022-12-22)

### ✨ Features

- Ergänzung des `podSecurityContext` und `securityContext` für den
  Wellknow-Service, Webclient und Synapse-Admin. (!13)
- Changelog zum Repository hinzugefügt. (!19)

### 🐛 Bugfixes

- Aktualisierung der genutzten Anwendungs-Images. (!9, !14)
- Kleine Korrektur des Scannerscripts vom Contentscanner, Entfernung der
  Umleitung auf `/dev/stdout`. (!18)

### 📝 Weitere Änderungen

- CI-Pipleine zum Testen des Helm Charts gegen die [DVS Kyverno
  Policies](https://gitlab.opencode.de/ig-bvc/ig-bvc-poc-2/ig-bvc-poc-ii-ap-4.1-ff-policy-entwicklung/rl-kyverno).
  (!15)


## BundesMessenger Helm Chart 1.0.1 (2022-12-16)

### ✨ Features

- Ergänzung des `podSecurityContext` und `securityContext` für den
  Wellknow-Service, Webclient und Synapse-Admin. (!13)
- Changelog zum Repository hinzugefügt. (!19)

### 🐛 Bugfixes

- Aktualisierung der genutzten Anwendungs-Images. (!9, !14)
- Kleine Korrektur des Scannerscripts vom Contentscanner, Entfernung der
  Umleitung auf `/dev/stdout`. (!18)

### 📝 Weitere Änderungen

- CI-Pipleine zum Testen des Helm Charts gegen die [DVS Kyverno
  Policies](https://gitlab.opencode.de/ig-bvc/ig-bvc-poc-2/ig-bvc-poc-ii-ap-4.1-ff-policy-entwicklung/rl-kyverno).
  (!15)


## BundesMessenger Helm Chart 1.0.0 (2022-12-15)

### ✨ Features

- Initiale Version und Veröffentlichung des BundesMessenger Helm Charts.
