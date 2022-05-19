### TURN-Server
****Erfahrungsbericht: Wenn der CoTurn im K8s betrieben werden soll, muss sichergestellt werden, dass die Dienste des CoTurn über Nodeports erreichbar sind! (NginX Reverse-Proxy auf Nodes und Ports vorweg geschaltet als Beispiel)****
```console
#ginx-stream config für CoTurn
stream {
        upstream coturn-udp {
        server NODE1:3478;
        server NODE2:3478;
        server NODE3:3478;
        server NODE4:3478;
        }
        server {
        listen 3478 udp;
        proxy_pass coturn-udp;
        proxy_responses 0;
        }
        upstream coturn-tcp {
        server NODE1:3478;
        server NODE2:3478;
        server NODE3:3478;
        server NODE4:3478;
        }
        server {
        listen 3478;
        proxy_pass coturn-tcp;
        proxy_responses 0;
        }

```

Für Installationen, in denen Sie Videokonferenzfunktionen verwenden möchten, muss ein TURN-Server installiert und verfügbar sein, damit die Apps und der Web-Client ihn verwenden kann.
Dieser wird per Default im gleichen Namespace wie der Service installiert und per Ingress auch konfiguriert. 
Weitere Details zur Konfiguration und Anweisungen dazu finden Sie hier: https://github.com/matrix-org/synapse/blob/master/docs/turn-howto.md 
 
Der CoTurn-Server wird neben einem eigenen Ingress-Controller installiert. Dieser wird explizit für die UDP-LoadBalancer ausgerollt, die standardmäßig nicht möglich sind. Der Controller wird im Namespace ausgerollt und vorerst nur mit dem Port 3478 verknüpft.
CoTurn wird als Daemonset seitens K8s etabliert und mit einer Turn-URi versehen.
Der Service des Standard-IngressController muss angepasst werden, sollte die Turn-URi mit TCP als Protokoll genutzt werden:
```yaml
  ports:
  - appProtocol: coturn-tcp
    name: coturn-tcp
    nodePort: 30478
    port: 3478
    protocol: TCP
    targetPort: coturn-tcp
```
Weiterhin muss sichergestellt werden, dass der Standard-Ingress-Controller im NameSpace `default` läuft oder entsprechend in den values geändert wird, bzw. überschrieben wird:
```console
--set coturn.ingress_ns_standard=MEINNAMESPACE
``` 
```console
######################################################################################
##          Setting up CoTurn
######################################################################################

coturn:
  enabled: true
  image:
    repository: coturn/coturn
    tag: latest
    pullPolicy: Always
  ingress_ns_standard: default
```
