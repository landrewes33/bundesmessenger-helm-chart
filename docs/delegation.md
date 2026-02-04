# Delegation

Die [Delegation](https://element-hq.github.io/synapse/latest/delegate.html#delegation-of-incoming-federation-traffic)
ist insbesondere im Kontext der Kommunikation in der Föderation wichtig.
Im Normalfall würde man erwarten, dass ein Benutzer `@benutzer:example.com`
auch auf dem Server `example.com` erreichbar ist. Das muss jedoch nicht
zwingend der Fall sein.

Mit Hilfe der Delegation kann man ermöglichen, dass ein Server im Internet
oder Intranet auf einem anderen DNS-Namen (Domain) erreichbar ist
(z.B. `matrix.example.com`) als ein Benutzername darstellt
(z.B. `@benutzer:example.com`).

Es gibt zwei Arten der Delegation:

1. [.well-known Seite](https://element-hq.github.io/synapse/latest/delegate.html#well-known-delegation)

    Die Domain, die einen Matrix-Server delegiert (`example.com`), muss unter
    der URL `https://example.com/.well-known/matrix/server` eine JSON-Datei
    mit dem folgenden Inhalt ausgeben und auf den Matrix-Server verweisen.
    Falls kein Port angegeben wird, wird der Standard-Port `8448` genutzt.

    ```json
    {
        "m.server": "matrix.example.com:443"
    }
    ```

1. [DNS SRV-Eintrag](https://element-hq.github.io/synapse/latest/delegate.html#srv-dns-record-delegation)

    Mit Hilfe eines SRV-Eintrages wird auf den Matrix-Server verwiesen.

    ```console
    _matrix._tcp.example.com 10 1 443 matrix.example.com
    ```

    <!-- markdownlint-disable MD036 -->
    | :warning: Die Delegation mit Hilfe eines DNS SRV Eintrages wird aus Gründen der Sicherheit nicht empfohlen, Stichwort DNSSEC |
    | --- |
    <!-- markdownlint-enable MD036 -->

## Referenzen

Für mehr Informationen nutzen Sie die öffentlich erreichbaren Dokumentationen:

- [Prozess zur Ermittlung des Kommunikationspartners / Discovery](https://spec.matrix.org/latest/server-server-api/#resolving-server-names)
- [Matrix Spezifikation](https://spec.matrix.org)
- [Synapse Delegation Dokumentation](https://element-hq.github.io/synapse/latest/delegate.html)
- [Synapse Federation Dokumentation](https://element-hq.github.io/synapse/latest/federate.html)
