- [Erstellen von Benutzern](#erstellen-von-benutzern)
  * [Identifizieren des anzusprechenden Containers](#identifizieren-des-anzusprechenden-containers)
  * [Anlegen eines Nutzers mit Administratorrechten](#anlegen-eines-nutzers-mit-administratorrechten)
  * [Anlegen eines Nutzers ohne Administratorrechten](#anlegen-eines-nutzers-ohne-administratorrechten)

# Erstellen von Benutzern

Nach der Installation sind in der Umgebung keine Benutzer vorhanden. Mindestens
der erste Benutzer muss per Kommandozeile angelegt werden. Weitere Benutzer lassen
sich im Anschluss auch per
[Admin API](https://matrix-org.github.io/synapse/latest/admin_api/user_admin_api.html#create-or-modify-account)
(z.B. mit `curl`) oder der Administrationsoberfläche
[Synapse-Admin](https://github.com/Awesome-Technologies/synapse-admin) anlegen.

Am Ende der Installation werden die notwendigen Kommandozeilen ausgegeben.
In der Ausgabe sind die Umgebungsvariablen (Deployment und Namespace)
mit den richtigen Werten aus der Installation gesetzt.

Folgende Schritte sind erforderlich:

1. [Identifizieren des anzusprechenden Containers (Synapse-Hauptprozess)](#identifizieren-des-anzusprechenden-containers)
1. Anlegen des Benutzers auf der Kommandozeile innerhalb des Pods
    * [Benutzer **mit** Administratorrechten](#anlegen-eines-nutzers-mit-administratorrechten)
    * [Benutzer **ohne** Administratorrechten](#anlegen-eines-nutzers-ohne-administratorrechten)

## Identifizieren des anzusprechenden Containers

In dem Beispiel wird das Deployment mit den Namen `testmatrix` in dem Namespace `bundesmessenger` verwaltet.

```console
export POD_NAME=$(kubectl get pods --namespace bundesmessenger -l "app.kubernetes.io/name=bundesmessenger,app.kubernetes.io/instance=testmatrix,app.kubernetes.io/component=synapse" -o jsonpath="{.items[0].metadata.name}")
```

## Anlegen eines Nutzers **mit** Administratorrechten

- NUTZER ist der Nutzername (der `localpart` der Matrix ID: `@localpart:example.com`).
- PASSWORT muss in `''` Single-Quotes gesetzt werden, sollte es Sonderzeichen enthalten.

```console
kubectl exec --namespace bundesmessenger $POD_NAME -- register_new_matrix_user -c /synapse/config/homeserver.yaml -c /synapse/config/conf.d/secrets.yaml -u NUTZER -p 'PASSWORT' --admin http://localhost:8008
```

## Anlegen eines Nutzers **ohne** Administratorrechten

- NUTZER ist der Nutzername (der `localpart` der Matrix ID: `@localpart:example.com`).
- PASSWORT muss in `''` Single-Quotes gesetzt werden, sollte es Sonderzeichen enthalten.

```console
kubectl exec --namespace bundesmessenger $POD_NAME -- register_new_matrix_user -c /synapse/config/homeserver.yaml -c /synapse/config/conf.d/secrets.yaml -u NUTZER -p 'PASSWORT' --no-admin http://localhost:8008
```
