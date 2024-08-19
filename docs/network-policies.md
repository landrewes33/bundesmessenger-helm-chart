# Network Policies

## Wozu dienen Network Policies?

[Network Policies in Kubernetes](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
sind eine Methode, um den Datenverkehr zwischen
Pods in einem Kubernetes-Cluster zu steuern. Sie ermöglichen es Ihnen, den
eingehenden und ausgehenden Datenverkehr auf der Ebene der Pods und Namespace
zu beschränken und zu filtern, um die Sicherheit und Zuverlässigkeit des
Netzwerks zu verbessern.

Genauer gesagt: Eine Network Policy ist eine Ressource in Kubernetes, die
definiert, wie der Datenverkehr zwischen verschiedenen Pods und Namespace
in einem Cluster fließen kann. Network Policies ermöglichen es Administratoren,
Regeln zu definieren, die den Datenverkehr anhand verschiedener Kriterien wie
IP-Adressen, Ports, Protokollen und Labels filtern.

Beispiele für mögliche Regeln in Network Policies sind:

- Erlauben des Datenverkehrs von einem bestimmten Pod zu einem anderen
- Blockieren des Datenverkehrs von einem Pod zu einem anderen
- Einschränken des ausgehenden Datenverkehrs eines Pods auf bestimmte Ziele
- Filtern des eingehenden Datenverkehrs eines Pods basierend auf dem Ursprung

Network Policies können verwendet werden, um das Netzwerk innerhalb des
Clusters sicherer und zuverlässiger zu machen, indem sie den Datenverkehr
beschränken und unerwünschte Zugriffe verhindern. Sie sind insbesondere für
Anwendungen relevant, die sensible Daten verarbeiten oder für die Sicherheit
und Compliance entscheidend sind.

Zusammenfassend sind Network Policies in Kubernetes eine Möglichkeit, den
Datenverkehr zwischen Pods und Namespace innerhalb des Clusters zu steuern.
Sie ermöglichen es, den Datenverkehr zu beschränken und zu filtern, um die
Sicherheit und Zuverlässigkeit des Netzwerks zu verbessern.

## Network Policies im BundesMessenger Helm Chart

Network Policies werden genutzt um die Kommunikation zwischen den
BundesMessenger Komponenten auf Port Ebene zu definieren und zu steuern.
~~Das Schaubild zeigt den **erlaubten** Datenverkehr wenn das Value
`networkpolicies.enabled: true` gesetzt wird.~~

Der komplette Datenverkehr aus dem Ingress Namespace wird anhand eines
Namespace Selectors (Namespace Auswahl / Einschränkung) erlaubt, hier empfiehlt
es sich einen für den Ingress Controller dedizierten Namespace zu nutzen.
(DVS Standard)
Sollte der Ingress Controller sich im Namespace `default` befindet, kann das
Feld `networkpolicies.ingressNamespace` leer gelassen werden.

> **Hinweis**
>
> - Sollten weitere Dienste im selben Namespace wie der BundesMessenger
Betrieben werden, benötigen diese Dienste ebenfalls Network Policies da die
Default Network Policy nur Datenverkehr zum Kubernetes API und DNS Server
erlaubt.
> - Das Aktivieren von Network Policies setzt den Einsatz eines Ingress
Controllers voraus, welcher auf Layer 7
([OSI-Schichtenmodell](https://de.wikipedia.org/wiki/OSI-Modell)) auflöst.
Ein Exponieren der Services via Layer 4 über den Servicetypen LoadBalancer ist
nicht unterstützt.

Eine Detailbeschreibung der einzelnen Network Policies ist hier zu finden:
[Network Policies Detailbeschreibungen](network_policies_detailbeschreibung.md)

## CertManager und Network Policies

:pushpin: Wenn die Network Polcies aktiviert sind `networkpolicies.enabled: true`,
ist eine Kommunikation vom Ingress zu den CertManager Pods im BundeMessenger Namespace
aktuell nicht möglich. Die default Deny All Policy verbietet dies.
Hierfür muss aktuell eine eigene Network Policy erstellt werden.

Details sind beim [CertManager beschrieben](https://cert-manager.io/docs/installation/best-practice/#network-requirements-and-network-policy).
