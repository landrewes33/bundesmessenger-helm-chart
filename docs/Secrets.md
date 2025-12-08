# Secrets

Der BundesMessenger erfordert den Einsatz von [Kubernetes Secrets], um auf eine
sichere Art seine benötigten Passwörter, Schlüssel und andere *Geheimnisse* zu
erhalten. Ein Kubernetes *Secret* ist eine Kubernetes Ressource, welche eine
beliebige[*] Anzahl von benannten Geheimnissen als Schlüssel-Werte-Paare
enthalten kann:

<!-- markdownlint-disable -->
<figure>

 ```yaml
apiVersion: v1
kind: Secret
metadata:
  name: login-secret
stringData:
  user-password: P455W02D!
  admin-password: 1014DM!N!$$$
 ```

 <figcaption>
 Manifest eines Kubernetes Secrets, in dem zwei Passwörter unter den
 Schlüsseln <code>user-password</code> und <code>admin-password</code>
 hinterlegt sind.
 </figcaption>
</figure>
<!-- markdownlint-enable -->

[*]: <https://kubernetes.io/docs/concepts/configuration/secret/#restriction-data-size>

## Erstellen von Secrets

Ein Secret mit der selben Struktur, wie oben beschrieben, kann mittels `kubectl
create` im Cluster erzeugt werden und steht dann den dort laufenden Anwendungen
zur Verfügung:

```sh
# Erstellen des Secrets `login-secret` mit zwei Geheimnissen.
kubectl --namespace=bum create secret generic "login-secret" \
  --from-literal="user-password=$(pwgen 42 1)" \
  --from-literal="admin-password=$(pwgen 42 1)"

# Ausgeben des Geheimnisses `user-password` im Secret `login-secret`.
kubectl --namespace=bum get secret "login-secret" \
  -o jsonpath='{.data.user-password}' \
  | base64 --decode; echo

# Ausgeben des Geheimnisses `admin-password` im Secret `login-secret`.
kubectl --namespace=bum get secret "login-secret" \
  -o jsonpath='{.data.admin-password}' \
  | base64 --decode; echo
```

[Kubernetes Secrets]:
 <https://kubernetes.io/docs/concepts/configuration/secret/>

## Verwalten von Secrets

Zu guter Sicherheitspraxis gehört die organisierte Verwaltung der eingesetzten
Geheimnisse. Der Einsatz eines *Vault* hat sich dabei als Best-Practice der
Industrie herausgestellt. Vault-Produkte sind beispielsweise [HashiCorp Vault
(proprietär)][HashiCorp Vault], [OpenBao] und [Infisical].

Während viele verschiedene Vault-Lösungen existieren, können die meisten über
den [External Secrets Operator][ESO Providers] an Kubernetes angebunden werden.
Der ESO sorgt dafür, dass Secrets in Kubernetes mit den Geheimnissen aus der
Vault erstellt und fortlaufend aktualisiert werden.

Eine Hilfe bei der Einrichtung kann die ESO Seite [Getting startet][ESO Getting
startet] bieten.

[HashiCorp Vault]: <https://hashicorp.com/vault>
[OpenBao]: <https://openbao.org/>
[Infisical]: <https://infisical.com/>
[ESO Providers]: <https://external-secrets.io/latest/provider/infisical/>
[ESO Getting startet]:
 <https://external-secrets.io/latest/introduction/getting-started/>

## Referenzierung von Secrets

In der BundesMessenger Konfiguration wird meist ein einzelnes Geheimnis
innerhalb eines Secrets referenziert. Dafür muss einerseits der Name des
Secrets, andererseits der Schlüssel des jeweiligen Eintrags angegeben werden.
Beispielsweise kann das Passwort für den Redis-Server mit Verweis auf ein Secret
angegeben werden:

<!-- markdownlint-disable -->
<figure>
  ```yaml
  externalRedis:
    existingSecret: redis
    existingSecretPasswordKey: password
  ```

  <figcaption>
    BundesMessenger Konfiguration des externen Redis-Servers, die angibt, das
    Redis-Passwort im Secret <code>redis</code> unter dem Schlüssel
    <code>password</code> nachzuschlagen.
  </figcaption>
</figure>
<!-- markdownlint-enable -->

## Übersicht BundesMessenger Secrets

Der BundesMessenger benötigt und verwaltet einige Secrets. Die folgende Tabelle
gibt eine Übersicht.

| Komponente | Name des Secrets | Schlüssel | Automatisch erstellt |
| --- | --- | --- | --- |
| Hauptkomponente | `"RELEASE-NAME-bundesmessenger"` | `"config.yaml"`, `"experimental-features.yaml"` | ✓ Ja |
| Hauptkomponente | `config.*.existingSecret` | `"registration-shared-secret"`, `"macaroon-secret-key"`, `"form-secret"`, `"worker-replication-secret"` | – Falls nicht vorhanden |
| Signing-Key-Job | `signingkey.existingSecret` | `"signing.key"` | ✗ Nein |
| Signing-Key-Job | `"RELEASE-NAME-bundesmessenger-signingkey"` | `"signing.key"` | ✓ Falls `signingkey.job.enabled` |
| PostgreSQL intern | `postgresql.auth.existingSecret` | `postgresql.auth.secretKeys.adminPasswordKey` | – Falls nicht vorhanden |
| PostgreSQL intern | `postgresql.customUser.existingSecret` | `postgresql.customUser.secretKeys.username`, `postgresql.customUser.secretKeys.database`, `postgresql.customUser.secretKeys.password` | – Falls nicht vorhanden |
| PostgreSQL extern | `externalPostgresql.existingSecret` | `externalPostgresql.existingSecretPasswordKey` | ✗ Nein |
| Redis intern | `redis.auth.existingSecret` | `redis.auth.existingSecretPasswordKey` | – Falls nicht vorhanden |
| Redis extern | `externalRedis.existingSecret` | `externalRedis.existingSecretPasswordKey` | ✗ Nein |
| MAS | `"RELEASE-NAME-bundesmessenger-matrix-authentication-service"` | `"mas-secret.yaml"` | ✓ Falls `mas.enabled` |
| MAS PostgreSQL intern | `maspostgresql.auth.existingSecret` | `maspostgresql.auth.secretKeys.adminPasswordKey` | – Falls nicht vorhanden |
| MAS PostgreSQL intern | `maspostgresql.customUser.existingSecret` | `maspostgresql.customUser.secretKeys.username`, `maspostgresql.customUser.secretKeys.database`, `maspostgresql.customUser.secretKeys.password` | – Falls nicht vorhanden |
| MAS PostgreSQL extern | `externalmasPostgresql.existingSecret` | `externalmasPostgresql.existingSecretPasswordKey` | ✗ Nein |
| Call | `call.existingSecret` | `call.secretKeys.livekitKey`, `call.secretKeys.livekitSecret` | ✓ Falls `call.enabled` |
| Sygnal | `"matrix-sygnal"` | `"sygnal.yaml"` | ✓ Falls `sygnal.enabled` |
| Sygnal | `sygnal.existingSecret` | `sygnal.ioskey_filename`, `sygnal.fcmkey_filename` | ✓ Falls `sygnal.enabled` und `sygnal.{ioskey,fcmkey}_filename` gesetzt |

### Legende

Das Präfix `RELEASE-NAME-bundesmessenger` ist hier ein Platzhalter für die
eigentlichen Release- und Chart-Namen. Werte in Anführungszeichen sind
buchstäblich zu verstehen; Werte ohne Anführungszeichen sind
Konfigurationsoptionen.
