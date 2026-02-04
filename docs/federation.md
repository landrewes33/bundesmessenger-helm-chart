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

### Selbstsignierte Zertifikate und private Certificate Authorities (CA)

Innerhalb privater Föderationen kann es vorkommen, den Netzwerkverkehr über
selbstsignierte Zertifikate oder Zertifikate aus privaten selbsterstellten
Root-CAs abzusichern.

Dafür bietet das Helm Chart die Möglichkeit, die Zertifikate im PEM Format
der Gegenseite einzubinden. Dieses Verfahren nimmt dem Synapse allerdings die
vom Betriebssystem bereitgestellten Zertifikate (siehe [Synapse Dokumentation](https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#federation_custom_ca_list)).

Dieses Verfahren übergibt dem Synapse die zu vertrauenden Zertifikate und deren
eventuell verwendeten privaten Root-CAs für den verschlüsselten Verbindungsaufbau
innerhalb einer privaten Föderation. Ein Hinzufügen in den
vorhandenen Zertifikatsspeicher des Betriebssystems des Hosts, auf dem
der entsprechende Container laufen soll, stellt eine höhere Komplexität dar.

Die Variable `extraConfig.federation_custom_ca_list` wird als Liste
geführt und die Einträge bauen sich nach der folgenden Struktur auf:

```yaml
extraConfig:
  federation_custom_ca_list:
    - /Secret/Zertifikatsdatei
```

Der führende `/` und die Angabe einer Zertifikatsdatei ist optional,
das Secret muss an dieser Stelle aber korrekt übergeben werden.

Es kann somit in einem Secret mehrere Zertifikatsdateien an den Synapse
gegeben werden.

Die Aktualisierung und Überwachung der Aktualität der Zertifikate im PEM Format
obliegen dem verantwortlichen Administrator.

## Weiterführende Themen

- [Aufbau von Benutzernamen](matrix-basics.md#benutzernamen)
- [Delegation](delegation.md)
