| Rule/Policy | Hinweis/Einschränkung |
| ------ | ------ |
| deny-privilege-escalation | keine Einschränkung |
| disallow-add-capabilities | keine Einschränkung |
| disallow-default-serviceaccount | **FIXED** es musste ein default-serviceaccount erstellt und angewandt werden, auf allen Services |
| disallow-host-namespaces | keine Einschränkung |
| disallow-host-path | keine Einschränkung |
| disallow-host-ports | keine Einschränkung |
| disallow-latest-tag | **FIXED** Job signing-key-job, dort war für beide kurzlebigen Images der Default auf latest. Muss zukünftig beachtet werden |
| disallow-privileged-containers | keine Einschränkung |
| disallow-selinux-options | keine Einschränkung |
| imagepullpolicy-always | **FIXED** Job signing-key-job |
| require-default-proc-mount | keine Einschränkung |
| require-gid-greater-2000 | keine Einschränkung |
| require-health-and-liveness-check | Es müssen noch Checks geschrieben werden für 3 Deploymentteile, Job signing-key-job ist kurzlebig und bekommt auch keine Checks |
| require-limits-and-requests | Job signing-key-job ist kurzlebig und bekommt auch keine expliziten limits |
| require_ro_rootfs | **FIXED:** Sygnal kann dies nicht umsetzen in der aktuellen Version (Nodejs) <br /> **FIXED:** synapse-admin + web-element: (separates Helm-Chart aktuell noch)  <br /> nginx: [emerg] 1#1: mkdir() "/var/cache/nginx/client_temp" failed (30: Read-only file system) <br /> nginx: [emerg] mkdir() "/var/cache/nginx/client_temp" failed (30: Read-only file system) |
| require-run-as-non-root | **FIXED:** Anpassung securityContext und podSecurityContext <br /> **FIXED: SYGNAL** listen auf Port 80 als Nodejs :( Kernel 4.4 oder älter zwingend notwendig auf WorkerNodes! |
| require-uid-greater-2000 |  **siehe require-run-as-non-root** |
| require-unique-uid-per-workload | **TODO:** ClamAV <br /> **FIXED:** runAsUser entsprechend jedem Deployment unique gestalten, das gilt somit auch für Erweiterungen und Jobs (signing-key-job) |
| restrict-apparmor | keine Einschränkung |
| restrict-external-ips | keine Einschränkung |
| restrict-image-registries | noch deaktiviert, da aktuell noch keine CI/CD -->> keine Registry |
| restrict-sysctls | keine Einschränkung, wir nutzen nur safe sysctl-calls |
