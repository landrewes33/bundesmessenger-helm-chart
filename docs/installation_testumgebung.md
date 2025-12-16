# BundesMessenger Testumgebung

Diese Dokumentation soll dazu dienen schnell eine beispielhafte Testumgebung
aufzubauen.

> :warning: Dies ist keine Anleitung zum Aufbau einer produktiven Umgebung.
Es werden keine Sicherheitsmechanismen oder Härtungen wie Netzsegmentierung,
DMZ oder ähnliches berücksichtigt.

Einige Teile werden an dieser Stelle nicht beschrieben, u.a.:

- Bereitstellung eines Kubernetes-Clusters
- Konfiguration der DNS-Namen

:pushpin: [Beschreibung der Bereitstellung eines Kubernetes Clusters
mit Hilfe von Terraform am Beispiel der IONOS Cloud.](./installation_k8s_ionos.md)

## Inhaltsverzeichnis

- [Installation](#installation)
  - [Ingress Controller](#ingress-controller)
  - [Cert Manager](#cert-manager)
  - [BundesMessenger](#bundesmessenger)
- [Monitoring](#monitoring)

## Installation

### Ingress Controller

```shell
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

Falls die notwendige IP-Adresse nicht als External IP zugewiesen wird,
kann dies manuell erfolgen:

```shell
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.loadBalancerIP=1.2.3.4
```

`1.2.3.4` muss durch die entsprechende IP-Adresse ersetzt werden.

### Cert Manager

Der [Cert Manager](https://github.com/cert-manager/cert-manager/)
stellt [Let's Encrypt](https://letsencrypt.org/de/) oder Self-Signed Zertifikate
für die Webseiten aus.

```shell
helm upgrade --install cert-manager cert-manager \
  --namespace cert-manager --create-namespace \
  --repo https://charts.jetstack.io \
  --set installCRDs=true
```

Konfiguration des Cert Manager.

- `letsencrypt-staging` für Tests und Let's Encrypt Test-Zertifikate
- `letsencrypt-prod` für gültige Let's Encrypt Test-Zertifikate

```yaml
# certmanager-ClusterIssuer.yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: ssl@example.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource used to store the account's private key.
      name: letsencrypt-staging-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx

---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: ssl@example.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource used to store the account's private key.
      name: letsencrypt-prod-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx

```

Einspielen der Konfiguration mit:

```shell
kubectl apply -f certmanager-ClusterIssuer.yaml
```

Das Überprüfen der `ClusterIssuer` ist mit `kubectl get clusterissuer` möglich.

#### Localhost Selfsigned Cert Manager Setup

Ausführliche Schritt-für-Schritt-Anleitung der Einrichtung eines BundesMessenger
Selfsigned Cert Manager Setup auf Localhost findet sich [hier](simple-selfsigned-setup.md).

### BundesMessenger

Erstellen der notwendigen Beispiel-Konfigurationen:

```yaml
# bum-configuration.yaml
---
serverName: demo.example.com

# zum Absichern der Administration gegen externen Zugriff
# kann dies eine lokale Adresse sein
adminAPIServerName: admin-api.localhost
# adminAPIServerName: admin-api.demo.example.com
dataPrivacyUrl: example.com/datenschutz.html
imprintUrl: example.com/impressum.html

synapse_admin:
  enabled: true
  uri: admin-gui.demo.example.com
webclient:
  enabled: true
  uri: web.demo.example.com

schadcodescanner:
  enabled: true

contentscanner:
  enabled: true

postgresql:
  enabled: true
  image:
    tag: "18"

mas:
  enabled: true
  uri: auth.example.com

maspostgresql:
  enabled: true
```

```yaml
# bum-tls.yaml
---
ingress:
  tls:
    - hosts:
        # all hostnames to create a certificate
        - demo.example.com
        - web.demo.example.com
        - admin-api.demo.example.com
        - admin-gui.demo.example.com
      secretName: ingress-bum-tls-certificate
  annotations:
    # default annotations from helm chart
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 50m
    nginx.ingress.kubernetes.io/enable-owasp-core-rules: "true"
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "*"
    nginx.ingress.kubernetes.io/cors-allow-methods: "PUT, GET, POST, OPTIONS, DELETE"
    nginx.ingress.kubernetes.io/cors-allow-credentials: "true"

    # additional annotation to enable cert manager
    # cert-manager.io/cluster-issuer: letsencrypt-prod
    cert-manager.io/cluster-issuer: letsencrypt-staging
```

Installation des BundesMessenger auf dem Kubernetes Cluster:

- Chart Museum Repository

  ```shell
  helm upgrade --install demo1 bundesmessenger \
    --namespace bum --create-namespace \
    -f bum-configuration.yaml -f bum-tls.yaml \
    --repo https://gitlab.opencode.de/api/v4/projects/560/packages/helm/stable
  ```

- OCI-Registry

  ```shell
  helm upgrade --install --namespace bum --create-namespace \
    -f bum-configuration.yaml -f bum-tls.yaml \
    demo1 oci://registry.opencode.de/bwi/bundesmessenger/backend/helm-chart/bundesmessenger
  ```

## Monitoring

Die Echtzeitüberwachung ist kein Bestandteil der BundesMessenger-Testumgebung,
kann jedoch leicht integriert werden. Informationen zur Einrichtung sind unter
[Monitoring mit Grafana](./Monitoring-mit-Grafana.md) zu finden.
