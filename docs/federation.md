# Hinweise zur Föderation

Bei der Föderation werden mehrere Server-Instanzen zur Kommunikation
untereinander verbunden. Diese Seite gibt hilfreiche Hinweise zur Einrichtung
der Föderation zwischen Instanzen des BundesMessengers. Die Dokumentation wird
fortlaufend ergänzt; Hinweise oder Ergänzungen nehmen wir gerne auf.

## Konfiguration

### Servernamen

In der Konfiguration bestimmt `federation_domain_whitelist`, mit welchen Servern
föderiert werden darf. Die Angabe des Servernamen bezieht sich auf
den konfigurierten Wert `server_name` für Synapse bzw. `serverName` im Helm Chart.
Der Anteil entspricht der Zeichenkette nach dem `:`  der Matrix-ID eines Benutzers.

Falls ein [`trusted_key_servers`](https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#trusted_key_servers)
(Helm Chart: `config.trustedKeyServers`) konfiguriert wird, muss dieser
auch in die `federation_domain_whitelist` mit aufgenommen werden. Diese Abfragen
gelten als ausgehende Föderationsabfragen.

### Worker `federation_sender`

Der Name `federation_sender` ist derzeit irreführend. Zwar verarbeitet der
Worker die zu sendenden Events, er ist jedoch nicht ausschließlich für die
ausgehende Kommunikation zuständig. Die ausgehende Kommunikation
zu föderierten Systemen erfolgt auch von weiteren Synapse Prozessen.
In Zukunft ist geplant, dass der `federation_sender` auch
die sendende Rolle übernimmt
([`outbound_federation_restricted_to`](https://element-hq.github.io/synapse/v1.109/usage/configuration/config_documentation.html#outbound_federation_restricted_to)).

### Netzwerkverbindungen

In einer Föderation kommunizieren verschiedene Komponenten mit anderen Servern.
Daher sind bei Bedarf verschiedene Proxies zu konfigurieren:

| Komponente | Konfiguration | Bemerkung |
| -------- | -------- | -------- |
| Sygnal | `sygnal.proxy` | Push für Android/iOS |
| Synapse Main-Prozess | `extraEnv` | |
| Synapse Worker | `workers.extraEnv` | |
| Synapse Media Repository | `workers.extraEnv` | Alternativ: `workers.media_repository.extraEnv` |

Eine Aufstellung, welche Verbindungen Synapse zu einen Proxy sendet, ist in der
[Hersteller-Dokumentation](https://element-hq.github.io/synapse/latest/setup/forward_proxy.html#connection-types)
zu finden.

Die Synapse-Komponenten kommunizieren untereinander. Daher ist jeweils auch die
`no_proxy` Variable zu setzen.

- Verbindung zu Sygnal: `push-local`
- Kommunikation zu Authentifizierungsprovidern

Neben der "normalen" Kommunikation zwischen den Matrix-Servern, werden noch:

- Wellknown- und
- Key-Server-Abfragen (`config.trustedKeyServers`)

durchgeführt.

## Weiterführende Themen

- [Aufbau von Benutzernamen](../README.md#benutzernamen)
- [Delegation](../README.md#delegation)
