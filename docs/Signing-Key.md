# Generierung des Signaturschlüssels

Das Helm Chart generiert automatisch einen Signaturschlüssel (Signingkey).
Es kann bei Bedarf auch ein eigener Schlüssel manuell bereitgestellt werden.

## Verwendung eines vorhandenen Schlüssels

Setzen von `existingSecret` auf den Namen des vorhandenen Secrets und
`existingSecretKey` auf den Schlüsselnamen in [values.yaml](../values.yaml),
um den vorhandenen Schlüssel zu verwenden.

Um den Generierungsvorgang zu deaktivieren, muss `signingkey.job.enabled`
auf `false` in [values.yaml](../values.yaml) gesetzt werden.

## Schlüssel generieren

Mit Setzen von `signingkey.job.enabled` auf `true` in [values.yaml](../values.yaml),
wird der Job dazu aktiviert.

Dies erstellt das Secret und führt einen Job aus,
um den Schlüssel zu generieren.

Nachdem das Secret generiert wurde, sollte `signingkey.job.enabled` auf
`false` gesetzt werden.
Das generierte Secret bleibt bestehen und wird von Synapse verwendet.

Es ist nicht gefährlich, den Job aktiviert zu lassen, da er das vorhandene
Geheimnis nicht löscht. Allerdings werden Updatevorgänge verlangsamt,
da der beschriebene Vorgang bei jedem Upgrade ausgeführt wird.

## ArgoCD

Dieses Helm-Chart versucht zu erkennen, ob es unter ArgoCD ausgeführt wird,
und passt automatisch notwendige Teile des Signaturschlüssel-Jobs an,
wenn dies der Fall ist.

Nachdem der Signaturschlüssel-Job ausgeführt wurde, wechselt der
Anwendungsstatus nach einer Weile auf "Fehlt" (Missing). Um den Zustand "Gesund"
(Healthy) wiederherzustellen, kann in der [values.yaml](../values.yaml) der
Schalter `signingkey.job.enabled` auf `false`  gesetzt werden.
