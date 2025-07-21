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
Operators](https://external-secrets.io).

Für eine Einführung zum Einsatz von Secrets im BundesMessenger siehe
[Secrets.md](./Secrets.md).

## Erzwingen der Anpassungen für ArgoCD

Dieses Helm-Chart erkennt über das Vorhandensein der [API-Version]
`argoproj.io/v1alpha1`, wenn es unter ArgoCD ausgeführt wird. Um den Betrieb für
ArgoCD zu erzwingen, kann in der Konfiguration explizit `argoCD: true` gesetzt
werden; dies sollte normalerweise aber nicht erforderlich sein.

[API-Version]:
    <https://helm.sh/docs/chart_template_guide/builtin_objects/#:~:text=Capabilities.APIVersions.Has>
