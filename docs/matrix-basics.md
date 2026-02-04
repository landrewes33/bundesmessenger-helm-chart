# Matrix Grundlagen

## Matrix Protokoll

Matrix ist ein offenes Kommunikationsprotokoll auf Basis von JSON over REST.

Spezifikation:  

<https://spec.matrix.org>

## Benutzernamen

Benutzernamen heißen in Matrix "**M**atri**x** **ID**" bzw. **MXID**. Diese
sind ähnlich aufgebaut wie E-Mail-Adressen. Sie besitzen einen Anteil des
lokalen Benutzernamens (`localpart`) und eine Domain bzw. Servernamen
(`example.com`), die relevant ist für die Kommunikation zwischen den
Matrix-Instanzen (Föderation).

Somit ergibt sich die Matrix ID: `@localpart:example.com`. `@` und `:` sind
fest definierte Identifier und Trennzeichen. Je nach Implementierung des
Clients reicht für den Benutzer der `localpart` um sich am eigenen Server,
dem sog. "homeserver" anzumelden.

- [Einführungen und Tutorials](https://matrix.org/docs/chat_basics/matrix-for-im/)
- [Spezifikation](https://spec.matrix.org/latest/appendices/#identifier-grammar)
  - [definierte Identifier](https://spec.matrix.org/latest/appendices/#common-identifier-format)
  - [Benutzername](https://spec.matrix.org/latest/appendices/#user-identifiers)
  - [Domain bzw. Servername](https://spec.matrix.org/latest/appendices/#server-name)

## Wichtiger Hinweis

| :warning: Wichtig: Mit der Inbetriebnahme des Synapse Servers wird die Domain `example.com`, welche der Server verwaltet, festgelegt. Damit auch der Namensraum der Benutzer. Ein nachträgliches Ändern oder eine Migration sind nicht möglich. Hierfür müssen der Server bzw. die Datenbank neu installiert werden. Ein Server kann auch nur eine Domain (hier: `example.com`) verwalten. |
| --- |
