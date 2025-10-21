# ArgoCD

Der BundesMessenger kann unter ArgoCD betrieben werden. Um die Kompatibilität
von Helm zu ArgoCD zu verbessern, wird das Chart an einigen Stellen leicht
angepasst. Die größte Anpassung für ArgoCD ist dabei das Abstellen der
automatischen Generierung von Secrets.

## Keine automatisch generierten Secrets

> ⚠️ **Warnung** – Unter ArgoCD müssen alle für den BundesMessenger benötigten
> Secrets selbst angelegt werden.

Damit der BundesMessenger erfolgreich installiert werden kann, müssen alle
verwendeten Secrets extern angelegt werden. Die anzulegenden Secrets und
Secret-Schlüssel kann man über die Suche nach *existingSecret* in der
[values.yaml](../values.yaml) finden. Das Skript
[initialize-secrets.sh](../scripts/initialize-secrets.sh) bietet eine einfache
Möglichkeit, alle benötigten Secrets anzulegen. Es dokumentiert außerdem die
Struktur der Secrets und gibt Aufschluss über die zu verwendenden Schlüssel und
Werte.

Die für den BundesMessenger empfohlene Art Secrets anzulegen ist über das
Anbinden eine Vault-Lösung, beispielsweise mithilfe des [External Secrets
Operators](https://external-secrets.io). Als Startpunkt dafür können die
folgenden [`ExternalSecret`]-Manifeste dienen.

Diese Manifeste sind am Beispiel von [OpenBao](https://openbao.org/) erstellt worden.

```yaml
# external-secrets.yaml
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: synapse
spec:
  secretStoreRef:
    kind: SecretStore
    name: bum-secret-store
  data:
    - secretKey: registration-shared-secret
      remoteRef:
        key: secret/synapse
        property: registration-shared-secret
    - secretKey: macaroon-secret-key
      remoteRef:
        key: secret/synapse
        property: macaroon-secret-key
    - secretKey: form-secret
      remoteRef:
        key: secret/synapse
        property: form-secret
    - secretKey: worker-replication-secret
      remoteRef:
        key: secret/synapse
        property: worker-replication-secret
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: postgresql
spec:
  secretStoreRef:
    kind: SecretStore
    name: bum-secret-store
  data:
    - secretKey: password
      remoteRef:
        key: secret/postgresql
        property: password
    - secretKey: postgres-password
      remoteRef:
        key: secret/postgresql
        property: postgres-password
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: redis
spec:
  secretStoreRef:
    kind: SecretStore
    name: bum-secret-store
  data:
    - secretKey: redis-password
      remoteRef:
        key: secret/redis
        property: redis-password
```

Für eine Einführung zum Einsatz von Secrets im BundesMessenger siehe
[Secrets.md](./Secrets.md).

[`ExternalSecret`]: <https://external-secrets.io/latest/api/externalsecret/>

## Erzwingen der Anpassungen für ArgoCD

Dieses Helm-Chart erkennt über das Vorhandensein der [API-Version]
`argoproj.io/v1alpha1`, wenn es unter ArgoCD ausgeführt wird. Um den Betrieb für
ArgoCD zu erzwingen, kann in der Konfiguration explizit `argoCD: true` gesetzt
werden; dies sollte normalerweise aber nicht erforderlich sein.

[API-Version]:
    <https://helm.sh/docs/chart_template_guide/builtin_objects/#:~:text=Capabilities.APIVersions.Has>
