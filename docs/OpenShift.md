# OpenShift

Der BundesMessenger kann auf der OpenShift-Plattform betrieben werden.
Die Anforderungen von OpenShift unterscheiden sich jedoch stark genug von
anderen Kubernetes-Plattformen, dass Konfigurationsänderungen nötig sind.

Insbesondere der [Umgang mit Linux UIDs/GIDs][OpenShift-UID-GID] in
`podSecurityContext`- und `securityContext`-Definitionen ist ausreichend
unterschiedlich.

Neben den hier beschriebenen Anpassungen kann außerdem das von der Community
gepflegte [Bundesmessenger-Openshift]-Repository auf OpenCoDE als Referenz
verwendet werden.

[OpenShift-UID-GID]:
    <https://www.redhat.com/en/blog/a-guide-to-openshift-and-uids>
[Bundesmessenger-Openshift]:
  <https://gitlab.opencode.de/landeshauptstadt-muenchen/bundesmessenger-openshift>

## Anpassen des Security-Context

OpenShift vergibt standardmäßig dynamische UIDs und GIDs innerhalb gewisser
Bereiche, die mit `SecurityContextConstraints` sichergestellt werden. Um statt
der festen UIDs/GIDs in der BundesMessenger-Konfiguration die von OpenShift
festgelegten Werte zu verwenden, können die entsprechenden Schalter im
Helm-Chart auf `null` gesetzt werden. Helm sorgt dann dafür, dass diese nicht in
die generierten Kubernetes-Manifeste übernommen werden.

### Beispielkonfiguration

```yaml
# openshift.yaml
---
confighub:
  podSecurityContext:
    runAsGroup: null
    runAsUser: null

contentscanner:
  podSecurityContext:
    runAsGroup: null
    runAsUser: null
    fsGroup: null

mas:
  podSecurityContext:
    fsGroup: null
    runAsGroup: null
    runAsUser: null
  securityContext:
    runAsUser: null

redis:
  master:
    podSecurityContext:
     enabled: false
    containerSecurityContext:
     enabled: false

schadcodescanner:
  clamavSecurityContext:
    runAsUser: null
    runAsGroup: null
  icapSecurityContext:
    runAsUser: null
    runAsGroup: null
  podSecurityContext:
    fsGroup: null

signingkey:
  podSecurityContext:
    runAsGroup: null
    fsGroup: null
  securityContext:
    runAsUser: null

synapse_admin:
  podSecurityContext:
    runAsGroup: null
    runAsUser: null

synapse:
  podSecurityContext:
    fsGroup: null
    runAsGroup: null
    runAsUser: null
  securityContext:
    runAsUser: null

webclient:
  podSecurityContext:
    runAsGroup: null
    runAsUser: null

wellknown:
  podSecurityContext:
    runAsGroup: null
    runAsUser: null

workers:
  default:
    securityContext:
      runAsUser: null
    podSecurityContext:
      fsGroup: null
      runAsGroup: null
      runAsUser: null
  generic_worker:
    securityContext:
      runAsUser: null
    podSecurityContext:
      fsGroup: null
      runAsGroup: null
      runAsUser: null
  media_repository:
    securityContext:
      runAsUser: null
    podSecurityContext:
      fsGroup: null
      runAsGroup: null
      runAsUser: null
```
