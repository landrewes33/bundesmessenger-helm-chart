Am Ende der Installation wird dem Deployment entsprechend gesetzte Umgebungsvariablen (Deploymentname, Namespace) die folgenden Anweisungen ausgegeben.

Identifizieren des anzusprechenden Containers (Deployment trägt hier den Namen "testmatrix")
    export POD_NAME=$(kubectl get pods --namespace bundesmessenger -l "app.kubernetes.io/name=bundesmessenger,app.kubernetes.io/instance=testmatrix,app.kubernetes.io/component=synapse" -o jsonpath="{.items[0].metadata.name}"

Anlegen eines Nutzers **mit** Administratorrechten:

    kubectl exec --namespace bundesmessenger $POD_NAME -- register_new_matrix_user -c /synapse/config/homeserver.yaml -c /synapse/config/conf.d/secrets.yaml -u NUTZER -p PASSWORT --admin http://localhost:8008

Anlegen eines Nutzers **ohne** Administratorrechten:
    kubectl exec --namespace bundesmessenger $POD_NAME -- register_new_matrix_user -c /synapse/config/homeserver.yaml -c /synapse/config/conf.d/secrets.yaml -u NUTZER -p PASSWORT --no-admin http://localhost:8008
