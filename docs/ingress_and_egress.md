# Ingress und Egress

## Ingress-Regeln

Ingress-Regeln in Kubernetes sind eine Methode, um den eingehenden Datenverkehr
in Ihre Anwendungen zu steuern.
Sie ermöglichen es Ihnen, den Datenverkehr basierend auf verschiedenen Kriterien
wie Hostnamen, Pfaden und Protokollen zu routen und filtern.

Um es genauer zu erklären: In Kubernetes ist ein Ingress-Objekt eine Art Ressource,
die definiert, wie der eingehende Netzwerkverkehr auf eine Gruppe von Diensten
in einem Kubernetes-Cluster verteilt wird.
Ingress-Regeln werden in der Regel verwendet,
um mehrere Anwendungen auf derselben IP-Adresse und Port-Nummer zu hosten,
indem sie den Datenverkehr basierend auf verschiedenen Parametern an
verschiedene interne Dienste im Cluster weiterleiten.

Ingress-Regeln werden normalerweise mit einem Ingress-Controller kombiniert,
der für die eigentliche Ausführung der Regeln verantwortlich ist.
Ein Ingress-Controller ist eine Komponente, die die Ingress-Objekte überwacht und
den Netzwerkverkehr entsprechend den definierten Regeln weiterleitet.

Zusammenfassend sind Ingress-Regeln eine Möglichkeit, den eingehenden Datenverkehr
in einem Kubernetes-Cluster zu steuern, indem sie den Datenverkehr basierend auf
verschiedenen Parametern an interne Dienste im Cluster weiterleiten.

## Egress-Regeln

Egress-Regeln dagegen sind eine Möglichkeit,
den ausgehenden Datenverkehr aus einem Kubernetes-Cluster zu steuern.
Sie ermöglichen es Ihnen, den ausgehenden Datenverkehr basierend auf
verschiedenen Kriterien wie Ziel-IP-Adressen,
Protokollen und Ports zu filtern und zu beschränken,
ähnlich den Ingress-Regeln.

Genauer gesagt: Egress-Regeln sind eine Netzwerkrichtlinie, die definiert,
wie der Datenverkehr aus einem Kubernetes-Pod zu
externen Netzwerkressourcen weitergeleitet wird.
Wenn ein Pod in Kubernetes eine Verbindung zu einem externen Netzwerk herstellt,
wird der ausgehende Datenverkehr normalerweise durch einen Netzwerk-Proxy geleitet,
der vom Cluster bereitgestellt wird.
Mit Egress-Regeln können Sie die Richtlinien des Proxys so anpassen,
dass der Datenverkehr bestimmte Ziele erreicht
und bestimmte Beschränkungen unterliegt.

Egress-Regeln können beispielsweise verwendet werden,
um den Zugriff auf bestimmte externe Ressourcen wie Datenbanken oder APIs
zu beschränken oder um den ausgehenden Datenverkehr zu überwachen und zu protokollieren.

Zusammenfassend sind Egress-Regeln eine Möglichkeit,
den ausgehenden Datenverkehr aus einem Kubernetes-Cluster zu steuern,
indem sie den Datenverkehr basierend auf verschiedenen Parametern filtern und beschränken.
Sie bieten eine zusätzliche Sicherheitsebene und ermöglichen eine präzisere Kontrolle
über den Datenverkehr innerhalb des Clusters.

## Split von Ingress Regeln in v1.2.0

In Kubernetes wird empfohlen,
Ingress-Regeln nicht in einer einzigen Ingress-Ressource zu bündeln.
Stattdessen sollten Ingress-Regeln für jede Anwendung oder jeden Service in einer
separaten Ingress-Ressource definiert werden.

Dies hat mehrere Gründe:

1. Trennung von Zuständigkeiten:
Durch die Aufteilung von Ingress-Regeln auf mehrere Ingress-Ressourcen
kann man die Zuständigkeiten für verschiedene Anwendungen
und Services voneinander trennen.
Dies erleichtert die Wartung und Verwaltung von Ingress-Regeln,
da man nicht durch eine lange Liste von Regeln navigieren muss,
um eine bestimmte Anwendung oder einen bestimmten Service zu finden.

2. Skalierbarkeit:
In einem großen Kubernetes-Cluster kann eine einzige Ingress-Ressource
mit vielen Ingress-Regeln zu einer hohen Last auf dem Ingress-Controller führen.
Durch die Aufteilung der Ingress-Regeln auf mehrere Ingress-Ressourcen
kann man die Last auf mehrere Ingress-Controller verteilen
und so die Skalierbarkeit verbessern.

3. Flexibilität:
Durch die Aufteilung von Ingress-Regeln auf separate Ingress-Ressourcen
kann man die Regeln für jede Anwendung oder jeden Service individuell anpassen.
Dadurch kann man beispielsweise unterschiedliche TLS-Zertifikate für
verschiedene Anwendungen oder Services verwenden oder spezielle Konfigurationen
für bestimmte Anwendungen oder Services vornehmen.

Insgesamt kann die Aufteilung von Ingress-Regeln auf separate
Ingress-Ressourcen die Verwaltung von Ingress-Regeln vereinfachen,
die Skalierbarkeit verbessern und die Flexibilität erhöhen.

Es ist damit durchaus möglich,
das weitere Unterteilungen in eigene Ingress-Ressourcen zukünftig umgesetzt werden.
