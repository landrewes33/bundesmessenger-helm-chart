# Matrix-Authentication-Service

| :warning:  Aktuell sind die Clients noch nicht mit dem Matrix-Authentication-Service (MAS) vollständig kompatibel. Nutzung wird unsererseits nicht empfohlen. Sollte sich der Zustand ändern, werden wir dies mitteilen. Hingegen voll von Synapse unterstützt ist die reine [Anmeldung mit SSO](#anmeldung-via-single-sign-on-sso). |
| --- |

| :warning: Wichtig: Der Matrix-Authentication-Service (MAS) ist "work in progress" und hat den Status experimentell. Die Migration von einer bestehenden Synapse Installation zum MAS ist noch nicht Bestandteil. Daher kann der MAS derzeit nur für neue Installationen genutzt werden. Eine Migration wird in Zukunft jedoch erforderlich sein. |
| --- |

Um den Matrix-Authentication-Service (MAS) zu verwenden,
müssen Sie zunächst die Installation planen.
Dieser Teil der Dokumentation erklärt die Installation des Dienstes,
wichtige Teile der Konfigurationsdatei und wie der Dienst ausgeführt wird.

Vor der Installation ist es wichtig zu verstehen, dass ein OIDC
(OpenID Connect)-nativer Matrix-Server verschiedene Komponenten hat,
die miteinander interagieren.
Der Matrix-Authentication-Service soll den Homeserver ergänzen
und den internen Authentifizierungsmechanismus ersetzen.

Die Umstellung auf einen OIDC-nativen Homeserver verändert das
Authentifizierungsmodell radikal:
Der Homeserver ist nicht mehr für die Verwaltung von Benutzerkonten
und Sitzungen verantwortlich.
Der Matrix-Authentication-Service wird zur Quelle der Wahrheit für
Benutzerkonten und Zugriffstoken, während der Homeserver nur die
Gültigkeit der über den Service erhaltenen Tokens überprüft.

Zum Zeitpunkt der Dokumentation ist vorgesehen, dass der MAS auf einer
eigenständigen Domain (z. B. auth.example.com) und der Homeserver auf einer
anderen (z. B. matrix.example.com) betrieben wird.
Diese Domain wird im Benutzerfluss für die Authentifizierung sichtbar sein.

Wenn ein Client einen Authentifizierungsfluss initiiert, wird er den MAS über
den `.well-known/matrix/client`-Endpunkt identifizieren.
Diese Datei wird auf einen "Issuer" verweisen, der der kanonischen Name der
Matrix-Authentication-Service-Instanz ist.
Aus diesem Issuer heraus wird er den Rest der Endpunkte durch Aufrufen des
`[issuer]/.well-known/openid-configuration`-Endpunkts identifizieren.
Standardmäßig stimmt der Issuer mit der Root-Domain überein, auf dem
der Service bereitgestellt ist (z. B. `https://auth.example.com/`),
kann jedoch anders konfiguriert werden.

## Vorbereitung

Um diesen Service jetzt schon nutzen zu können, müssen die folgenden Punkte erfüllt
werden und umgesetzt sein:

1. Eigene Subdomain unter dem der MAS deployed wird
2. Entscheidung welcher Dienst die Auslieferung der entsprechenden
Wellknown-Datei übernimmt.
Es wird empfohlen, dies vom MAS übernehmen zu lassen
3. Bereitstellen einer PostgreSQL-Datenbank für den MAS
4. Konfiguration des Homeservers zur Nutzung des MAS
    1. Deaktivierung von `config.enableRegistration` (übernimmt Helm Chart)
    1. Deaktivierung von `extraConfig.password_config.enabled` (übernimmt Helm Chart)
    1. Konfigurieren von `experimental_features.msc3861` mit
        `enabled:true`, `issuer`, `client_id`, `client_auth_method`,
        `clients_secret`, `admin_token`, `account_management_url`
        (übernimmt Helm Chart)
    1. Konfiguration eines optionalen OIDC-Providers (OpenID-Connect-Provider)
5. Migration der bestehenden Konfiguration auf neue Authentifizierungsmethode

## Installation

Durch die Konfiguration des Services, kann die Installation über das
Helm-Chart vorgenommen werden.

Es ist empfohlen für jegliche Kommunikation zum MAS ein SSL-Zertifikat
zu hinterlegen.

## Anmeldung via Single Sign On (SSO)

Der MAS hat das ambitionierte Ziel, die Nutzerverwaltung vollständig von Matrix
loszulösen und sie stattdessen über OIDC bereitzustellen [[MSC 3861]].
Demgegenüber steht die Nutzung von OIDC zur bloßen Nutzerauthorisierung (SSO).
Diese ist bereits jetzt vollständig von Synapse und den Clients unterstützt.

Im BundesMessenger kann SSO aktiviert werden, indem seine Helm-Konfiguration
unter [`extraConfig`][bum-extra-config] um den Synapse-Schlüssel
[`oidc_providers`][synapse-config-oidc-providers] ergänzt wird. Informationen zu
den benötigten Werten und umfangreiche Beispiele finden sich in der
[Synapse-Dokumentation zu OIDC][synapse-oidc].

[MSC 3861]: <https://github.com/matrix-org/matrix-spec-proposals/pull/3861>
[bum-extra-config]:
    <https://gitlab.opencode.de/bwi/bundesmessenger/backend/helm-chart/-/blob/main/values.yaml#L290>
[synapse-oidc]: <https://element-hq.github.io/synapse/latest/openid.html>
[synapse-config-oidc-providers]:
    <https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#oidc_providers>

## Weiterführende Links

- [Dokumentation des Herstellers](https://matrix-org.github.io/matrix-authentication-service/)
- [Github Repository mit schematischer Darstellung](https://github.com/matrix-org/matrix-authentication-service/tree/main?tab=readme-ov-file#oauth20--openid-connect-provider-for-matrix-homeservers)
