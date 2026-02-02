# Network Policies Detailbeschreibungen

Nachfolgenden werden die Funktionen der einzelnen Network Policies erläutert.
Diese Network Policies werden nur angewendet, wenn die Variable
`networkpolicies.enabled` auf `true` gesetzt ist.

## allow-kubeapi-network-policy.yaml

### kubeapi Egress

Die Network Policy ermöglicht den ausgehenden Datenverkehr von Pods, die das
Label `to-apiserver: allowed` gesetzt haben, zu den `TCP`-Ports `443` und `6443`.
Da es sich bei dem Kube-API Server um kein Kubernetes Objekt handelt, welches
direkt als Ziel dieser Egress Policy definiert werden kann, sondern um einen
Systemprozess, laufend auf der bzw. den dazugehörigen Control-Planes,
wird der Traffic auf den Ports `443` und `6443` gestattet.

## allow-kubedns-network-policy.yaml

### kubedns Egress

Die Policy ermöglicht den ausgehenden Datenverkehr von allen Pods im Release
Namespace zu den Pods, die im Namespace `kube-system` sind und das Label
`k8s-app: kube-dns` haben. Diese Policy erlaubt den ausgehenden Datenverkehr
zum DNS-Server im Kubernetes-Cluster.

## confighub-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn zusätzlich Variable
`confighub.enabled` auf `true` gesetzt ist.

### Confighub Ingress

Sie ermöglicht den eingehenden Datenverkehr zum Confighub Pod
auf dem `TCP`-Port `8080` vom Ingress-Controller.

## contentscanner-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn zusätzlich die Variable
`contentscanner.enabled` auf `true` gesetzt ist.

### contentscanner Egress

Die Policy ermöglicht den ausgehenden Datenverkehr von Pods des contentscanner
zu bestimmten Ziel-Pods.
Wenn das Media Repository ausgerollt ist, wird der ausgehende Datenverkehr zum
Media Repository Pod mit dem auf dem `TCP`-Port `8083` zugelassen. Andernfalls wird
der ausgehende Datenverkehr zum Synapse main auf dem Service
`TCP`-Port `8008` erlaubt.
Unabhängig davon wird der ausgehende Datenverkehr zum Schadcodescanner auf dem
`TCP`-Port `1344` zugelassen.

## matrix-network-policy.yaml

### Synapse Ingress

Sie ermöglicht den eingehenden Datenverkehr auf den Synapse Pod von
folgenden Quellen:

- Genereller Datenverkehr auf dem `TCP`-Port `8008`
  für den Ingress-Controller.

- Pods aller Worker auf dem `TCP`-Port `9093`.

- Genereller Datenverkehr auf dem `TCP`-Port `9090`.
  Dieser wird zum bereitstellen der Monitoring Metriken genutzt.

### Synapse Egress

Der ausgehende Datenverkehr ist abhängig von der Konfiguration des Helm Charts.
Wenn die Variable `postgresql.enabled` auf `true` gesetzt ist,
wird der ausgehende Datenverkehr zu dem ausgerollten
Postgres Pod auf dem `TCP`-Port `5432` erlaubt.
Sollte eine externe Postgres DB genutzt werden, kann über die Variable
`externalPostgres.host` die dazugehörige IP Adresse angegeben werden,
um Datenverkehr auf dem `TCP`-Port `5432` zu erlauben.
Genauso wird der ausgehende Datenverkehr zu den redis Pods auf dem
`TCP`-Port `6379` erlaubt, wenn die Variable
`redis.enabled` auf `true` gesetzt ist.

Bei einer externen redis Instanz, kann die Variable
`externalRedis.host` gesetzt werden,
um Datenverkehr auf dem `TCP`-Port `6379` zu erlauben.

## postgresql-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn zusätzlich die Variable
`postgresql.enabled` auf `true` gesetzt ist.

### PostgreSQL Ingress

Der eingehende Datenverkehr ist von folgenden Quellpods
auf dem `TCP`-Port `5432` erlaubt:

- Pods des Synapse.
- Pods aller Worker.

## redis-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn zusätzlich die Variable
`redis.enabled` auf `true` gesetzt ist.

### Redis Ingress

Der eingehende Datenverkehr ist von folgenden Quellpods
auf dem `TCP`-Port `6379` erlaubt:

- Pods des Synapse.
- Pods aller Worker.

## schadcodescanner-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn zusdätzlich die Variable
`schadcodescanner.enabled` auf `true` gesetzt ist.

### Schadcodescanner Ingress

Sie ermöglicht den eingehenden Datenverkehr der Komponenten des
`matrix-content-scanners` auf dem `TCP`-Port `1344` auf Pods des Schadcodescanners.

### Schadcodescanner Egress

Sie erlaubt den ausgehenden Datenverkehr der Komponenten des Schadcodescanners
auf dem `TCP`-Port `443` oder dem Port des privaten Mirrors.
Diese Verbindung wird vorrausgesetzt um die Malware-Datenbank von einem
Mirror zu synchronisieren.

## synapse-admin-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn zusätzlich Variable
`synapse_admin.enabled` auf `true` gesetzt ist.

### Synapse-Admin Ingress

Sie ermöglicht den eingehenden Datenverkehr zum Synapse-Admin Pod
auf dem `TCP`-Port `8080` vom Ingress-Controller.

## sygnal-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn zusätzlich Variable
`sygnal.enabled` auf `true` gesetzt ist.

### Sygnal Ingress

Sie ermöglicht den eingehenden Datenverkehr zu matrix-sygnal Pods
auf dem `TCP`-Port `5000`.

### Sygnal Egress

Sie ermöglicht den ausgehenden Datenverkehr des Sygnal-Pods zu den Ports:

- `TCP`-Port `443`
- `TCP`-Port `2197`

Diese Ports werden benötigt um die Apple und Google Pushservices zu erreichen.
Der Datenverkehr verlässt hierbei den Cluster.

## webclient-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn zusätzlich Variable
`webclient.enabled` auf `true` gesetzt ist.

### Webclient Ingress

Sie ermöglicht den eingehenden Datenverkehr zum Webclient Pod
auf dem `TCP`-Port `8080` vom Ingress-Controller.

## well-known-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn zusätzlich Variable
`wellknown.enabled` auf `true` gesetzt ist.

### WellKnown Ingress

Sie ermöglicht den eingehenden Datenverkehr zum WellKnown Pod
auf dem `TCP`-Port `8080` vom Ingress-Controller.

## worker-network-policy.yaml

Diese Network Policy wird nur angewendet, wenn Worker konfiguriert sind.

Wenn diese Bedingungen erfüllt ist, wird für jede Komponente, die in der
`.Values.workers`-Konfiguration aufgeführt ist und für die `enabled` auf `true`
gesetzt ist, eine eigene Network Policy erstellt.

### Synapse-Worker Ingress

Die Policy Erlaubt den eingehenden Datenverkehr für die Komponente
von den angegebenen Quell-Pods.

Für den Namesapce des Ingress und den eigenen Namespace ist der Zugriff
auf den `TCP`-Port `8083` erlaubt.

Für alle ist der Zugriff auf den `TCP`-Port `9090` erlaubt.
Der Zugriff auf Port `9090` zum Sammeln von Metriken benötigt
und für die Health-Checks.

### Synapse-Worker Egress

Die Policy erlaubt ausgehenden Datenverkehr für die Komponente zu den
angegebenen Ziel-Pods und -Ports. Diese können auf den Port `9093` des
synapse Pods zugreifen. Wenn PostgreSQL aktiviert ist, kann auf den
Port `5432` des PostgreSQL-Pods zugegriffen werden.
Andernfalls wird der Zugriff auf die PostgreSQL-Datenbank
auf eine festgelegte IP-Adresse beschränkt.
Wenn Redis aktiviert ist, kann auf den Port `6379` des
Redis-Pods zugegriffen werden.
Andernfalls wird der Zugriff auf eine festgelegte IP-Adresse beschränkt.
