# Redis Sysctl-Tuning

Das Aktivieren von Transparent Huge Pages (THP) im Linux-Kernel kann unter
Umständen Datenbankanwendungen wie Redis negativ beeinflussen. Auf manchen Nodes
kann es daher zu der folgenden Fehlermeldung von Redis kommen:

> WARNING you have Transparent Huge Pages (THP) support enabled in your kernel.
> This will create latency and memory usage issues with Redis. To fix this issue
> run the command 'echo madvise > /sys/kernel/mm/transparent_hugepage/enabled'
> as root, and add it to your /etc/rc.local in order to retain the setting after
> a reboot. Redis must be restarted after THP is disabled (set to 'madvise' or
> 'never').

Dieser Empfehlung kann direkt nachgekommen werden. Alternativ existiert auch ein
Umweg über das Bitnami Redis-Chart.

## Empfohlene Lösung

Der Empfehlung in der Warnung sollte nachgekommen werden. Dafür muss bei jedem
betroffenen Kubernetes-Node auf Host-Ebene diese Anpassung der THP-Einstellung
vorgenommen werden:

```sh
echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
```

Mit der `madvise`-Option hat eine Applikation die Möglichkeit, per
Opt-in-Verfahren THPs zu nutzen, wenn diese benötigt werden. Redis ist es dann
möglich, darauf zu verzichten.

## Alternativer Weg

> ⚠ **Achtung** – Es wird empfohlen, diese Einstellungen nicht vorzunehmen.
> Sysctl-Einstellungen dieser Art sind per Standard in der DVC nicht gewünscht.
> Es können somit Regelwerke greifen, die ein Deployment verhindern.

In manchen Umgebungen ist ein direkter Host-Zugriff allerdings nicht möglich.
Daher existiert von Seiten des Bitnami Redis-Charts ein alternativer Weg, die
THP-Einstellungen für den aktuellen Host des Redis-Containers aus Kubernetes
heraus *dauerhaft* anzupassen. Für das BundesMessenger-interne Redis muss in der
Konfiguration unter dem `redis`-Schlüssel folgende Einstellungen hinzugefügt
werden:

```yaml
  # https://github.com/bitnami/charts/tree/main/bitnami/redis/#host-kernel-settings
  sysctl:
    enabled: true
    image:
      registry: registry.opencode.de
      repository: bwi/bundesmessenger/backend/container-images/ubuntu
      tag: latest-jammy-production
      pullPolicy: IfNotPresent
      # pullSecrets: ["myRegistryKeySecretName"]
    mountHostSys: true
    resources:
      limits:
        cpu: 400m
        memory: 512Mi
      requests:
        cpu: 100m
        memory: 128Mi
    command:
      - /bin/sh
      - -c
      - |-
        echo madvise > /host-sys/kernel/mm/transparent_hugepage/enabled
```
