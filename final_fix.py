#!/usr/bin/env python3
import re

with open('values.yaml', 'r', encoding='utf-8') as f:
    content = f.read()

# Comprehensive final replacements for all remaining German text
replacements = [
    ('# The "internal" database must disabled be: `postgresql.enabled: false`.', '# The "internal" database must be disabled: `postgresql.enabled: false`.'),
    ('enabled: false  # Auf true setzen, to migration auszuführen', 'enabled: false  # Set to true to run migration'),
    ('# Start of the MAS! Ändern of the key leads to data loss.', '# start of MAS! Changing the key leads to data loss.'),
    ('# (list) Diese URLs ersetzen or überlagern the URLs from Synapse.', '# (list) These URLs replace or overlay the URLs from Synapse.'),
    ('# /!\\ Ändern Sie dies nur, if Sie wissen, was Sie tun.', '# /!\\ Only change this if you know what you are doing.'),
    ('# (list) Additional in the MAS to mountende Datenträger (Volumes)', '# (list) Additional volumes to be mounted in MAS'),
    ('# (list) Additional in the MAS to mountende Datenträgerpfade (Volumes)', '# (list) Additional volume mounts to be mounted in MAS'),
    ('# Beachten Sie, sincess a Änderung dieser Einstellung auch the Verwendung the volumePermission', '# Note that changing this setting may also require using the volumePermission'),
    ('# (list|null) Liste the zulässigen MIME-Typen.', '# (list|null) List of allowed MIME types.'),
    ('# Nicht erkannte Binärsinceteien are as "application/octet-stream" betrachtet.', '# Unrecognized binary files are considered as "application/octet-stream".'),
    ('# Nicht erkannte Textsinceteien are as "text/plain" betrachtet.', '# Unrecognized text files are considered as "text/plain".'),
    ('# Nicht erkannte Binärsinceteien are as `application/octet-stream` betrachtet.', '# Unrecognized binary files are considered as `application/octet-stream`.'),
    ('# (string) The maximum zwischenspeicherbare Dateigröße.', '# (string) The maximum cacheable file size.'),
    ('# If a Datei größer as diese Größe ist, is a Kopie sincevon', '# If a file is larger than this size, a copy of it'),
    ('# (list) Additional in the Matrix-Content-Scanner to mountende Datenträger (Volumes)', '# (list) Additional volumes to be mounted in the Matrix Content Scanner'),
    ('# (list) Additional in the Matrix-Content-Scanner to mountende Datenträgerpfade (Volumes)', '# (list) Additional volume mounts to be mounted in the Matrix Content Scanner'),
    ('# If ka Schadcode gefunthe wurde, must the Script the Exit-Code 0 zurück geben.', '# If no malicious code was found, the script must return exit code 0.'),
    ('# (integer) the Port of the ClamAV Pods (c-icap-Server), is im Service übertragen', '# (integer) The port of the ClamAV pod (c-icap-server), is transferred in the service'),
    ('# durch the configuring of a privaten Mirrors automatisch überschrieben.', '# automatically overridden by configuring a private mirror.'),
    ('# (map) Additional in the Synapse Admin einzuhängende Datenträger (Volumes).', '# (map) Additional volumes to be mounted in Synapse Admin.'),
    ('# (map) Additional in the Synapse Admin einzuhängende Datenträgerpfade (Volume-Mounts).', '# (map) Additional volume mounts to be mounted in Synapse Admin.'),
    ('# (bool) Enable the TLS Zertifikatsüberprüfung', '# (bool) Enable TLS certificate verification'),
    ('# Mögliche Werte are "OFF" and "INFO".', '# Possible values are "OFF" and "INFO".'),
    ('## JWT Service benötigt.', '## JWT service is required.'),
    ('# Key and secret must with the specification im LiveKit Server übera stimmen.', '# Key and secret must match the specification in the LiveKit server.'),
    ('# (map) referencee on Livekit-Schlüssel and -Geheimnis.', '# (map) References to Livekit key and secret.'),
    ('# (string) reference im `existingsecret` on the Livekit-Schlüssel.', '# (string) Reference in `existingSecret` to the Livekit key.'),
    ('## Configurationen, the übergreifend are and not nur a einzelne Komponenten betreffen.', '## Configurations that are cross-cutting and do not only affect a single component.'),
    ('## greifen komponentenübergreifend, z.B. alle Clients (auch the mobilen Apps)', '## affect cross-component, e.g. all clients (also the mobile apps)'),
    ('# (bool) Um the Vorankündigung for Einführung the Föderation anzeigen to can.', '# (bool) To be able to display the announcement for the introduction of federation.'),
    ('# Note: The Einführungsdialog is nur einmalig angezeigt.', '# Note: The introduction dialog is only displayed once.'),
    ('# Ermöglicht the Benutzer in the BuM Legacy-Apps in verschiedenen Stufen auf', '# Allows the user in the BuM Legacy apps in different stages to'),
    ('#  3: Zwangsdialog, Anmeldung to the BuM Legacy App not mehr möglich', '#  3: Forced dialog, login to BuM Legacy app no longer possible'),
    ('# (bool) Fügt Volume and suspended Cronjob hinto to Benutzer to exportieren.', '# (bool) Adds volume and suspended cronjob to export users.'),
    ('# Führt for Configuration the /.well-known/client and /_matrix/cconfig/style.json', '# Leads to configuration of /.well-known/client and /_matrix/cconfig/style.json'),
    ('# Diese URL is via /.well-known/matrix/client to the Clients übergeben to the Informationen', '# This URL is passed to the clients via /.well-known/matrix/client to obtain the information'),
    ('# Configuration from `map_style_config` übergeben.', '# configuration from `map_style_config`.'),
    ('# Anführungszeichen (") are automatisch of Helm escaped (to \\").', '# Quotation marks (") are automatically escaped by Helm (to \\").'),
    ('# Weiterhin besteht the Möglichkeit, the user to Upsincete of the Clients to motivieren or to zwingen.', '# Furthermore, there is the possibility to motivate or force users to update the client.'),
    ('#                   Feld `description` is zusätzlich sincerunder with 1 Zeile Abstand angezeigt,', '#                   Field `description` is additionally displayed below with 1 line spacing,'),
    ('#   description:  optionaler Text zusätzlich to Stansincerd-Wartungstext', '#   description:  optional text in addition to the standard maintenance text'),
    ('#   For the Versionsangabe are vollständige Versionsnummern (Major.Minor.Patch) anzugeben.', '#   For the version specification, complete version numbers (Major.Minor.Patch) must be specified.'),
    ('# upsincete_before: the letzte Version, the gedulded wird, ältere must upsinceten', '# update_before: the last version that is tolerated, older ones must update'),
    ('# warn_before: the letzte Version without Upsincete-Note, ältere should upsinceten', '# warn_before: the last version without update note, older ones should update'),
    ('# Beim Einsatz a PostgreSQL-Instanz außerhalb of the Kubernetes Clusters', '# When using a PostgreSQL instance outside the Kubernetes cluster'),
]

for old, new in replacements:
    content = content.replace(old, new)

with open('values.yaml', 'w', encoding='utf-8') as f:
    f.write(content)

print("All translations complete!")
