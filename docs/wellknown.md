# Well-known

## Was ist Well-known?

"well-known" und SRV-Record sind zwei unterschiedliche Methoden,
um Informationen über Dienste oder
Ressourcen im Netzwerk zu speichern und abzurufen.

Das Prinzip von "well-known" basiert darauf,
dass bestimmte Dienste auf einer bestimmten Portnummer
auf einem Host bereitgestellt werden.
Diese Portnummern sind standardisiert und allgemein bekannt,
daher ist es möglich, Dienste über die Angabe des Hostnamens
und der Portnummer zu erreichen.
Ein Beispiel dafür ist der HTTP-Dienst, der standardmäßig auf Port 80 läuft.
Wenn also eine Anwendung auf dem Host "example.com" auf den
HTTP-Dienst zugreifen möchte, kann sie einfach "example.com:80" angeben.

Um jedoch Dienste oder Ressourcen zur Verfügung zu stellen,
die nicht allgemein bekannt sind,
müssen die Informationen dazu zugänglich bzw. zur Verfügung gestellt werden.

## Trennung Well-known zu normalen Anfragen

Well-Known Aufrufe werden oft von anderen Diensten getrennt und separat
beantwortet aus Gründen der **Sicherheit**, **Performance** und
**Standardisierung**:

1. **Sicherheit:** Well-Known Endpunkte, wie z.B. `/.well-known/acme-challenge`
für SSL/TLS-Zertifikatvalidierung, enthalten sensible Informationen. Indem sie
separat behandelt werden, können spezielle Sicherheitsmaßnahmen ergriffen
werden, um sicherzustellen, dass diese Informationen nur für autorisierte
Anfragen zugänglich sind. Diese Trennung minimiert das Risiko von Datenlecks.

2. **Performance:** Well-Known Endpunkte dienen oft für spezifische Aufgaben
wie Zertifikatsvalidierung. Indem sie getrennt von anderen Diensten beantwortet
werden, können spezielle Caching-Strategien implementiert werden, um
sicherzustellen, dass diese Anfragen schnell beantwortet werden können.
Dies verbessert die Gesamtperformance der Architektur.

3. **Standardisierung:** Well-Known Endpunkte folgen bestimmten Standards und
Konventionen, die von verschiedenen Organisationen wie IETF
(Internet Engineering Task Force) und IANA
(Internet Assigned Numbers Authority) festgelegt wurden. Durch die Trennung
und separate Beantwortung dieser Anfragen wird sichergestellt, dass diese
Standards eingehalten werden.
Dies ist wichtig für die Interoperabilität und das korrekte
Funktionieren von Diensten im Internet.

4. **Entkopplung von Diensten:** Die Trennung von Well-Known Aufrufen von
anderen Diensten ermöglicht es, diese Dienste unabhängig voneinander zu
entwickeln, zu warten und zu skalieren. Dies fördert die Modularität und
Flexibilität der Gesamtsystemarchitektur.

Insgesamt ermöglicht die Trennung und separate Beantwortung von Well-Known
Aufrufen eine präzise Kontrolle über den Zugriff auf sensible Informationen,
optimiert die Performance und erleichtert die Einhaltung von Standards.
