{{/* SPDX-FileCopyrightText: 2022–2025 BWI GmbH */}}
{{/* SPDX-License-Identifier: Apache-2.0 */}}
{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "matrix-synapse.name" -}}
{{- .Values.nameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "matrix-synapse.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := .Values.nameOverride | default .Chart.Name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Asserts all given keys are present in the dict.

Args:
  first item: (dict) The dict to check.
  rest: (str) Names of the keys that must be present.
*/}}
{{- define "matrix-synapse.assertKeys" -}}
{{- range rest . }}
  {{- if not (hasKey (first $) .) }}
    {{- fail (print "Missing key " . " in dict") }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Returns whether a new Secret must be created.

Panics if the looked-up secret and `legacyValue` both exist, but do not match.

Args:
  global: (dict) Global dict.
  secretName: (str) Name of the Secret to check.
  secretPath: (str) Path to the config option of the Secret name.
  keys: (list of dicts) List of Secret keys to check.
    secretKey: (str) Key into the given Secret.
    legacyValue: (str) The corresponding legacy plain-text secret.
    legacyPath: (str) The path to the legacy secret config option.
*/}}
{{- define "matrix-synapse.assertExistingSecret" -}}
{{- include "matrix-synapse.assertKeys" (list . 
  "global" "secretName" "secretPath" "keys"
)}}
{{- $existingSecret := lookup "v1" "Secret" .global.Release.Namespace .secretName }}
{{- range $item := .keys }}
  {{- include "matrix-synapse.assertKeys" (list $item
    "secretKey" "legacyValue" "legacyPath"
  )}}
  {{- $existingValue := dig "data" $item.secretKey "" $existingSecret | b64dec }}
  {{- if and $item.legacyValue $existingValue (ne $item.legacyValue $existingValue) }}
    {{- fail (print
      "Widersprechende Angaben: Das Geheimnis unter `" $item.legacyPath "` ist "
      "ein anderes als im Secret `" $.secretName "` (`" $.secretPath "`) unter "
      "dem Schlüssel `" $item.secretKey "` angegeben. Setzen Sie `"
      $item.legacyPath ": \"\"`, um das Geheimnis aus dem Secret zu verwenden. "
      "Um das Geheimnis im Secret zu ändern, nutzen Sie z.B. `kubectl "
      "--namespace=" $.global.Release.Namespace " edit secret " $.secretName
      "` und editieren Sie `data` bzw. `stringData`."
    )}}
  {{- end }}
{{- end }}
{{- if not $existingSecret }}
  {{- "true" }}
{{- end }}
{{- end -}}

{{/*
publicServerName.
*/}}
{{- define "matrix-synapse.publicServerName" -}}
{{- .Values.publicServerName | default .Values.serverName }}
{{- end -}}

{{/*
publicServerURL.
*/}}
{{- define "matrix-synapse.publicServerURL" -}}
{{- printf "https://%s" (include "matrix-synapse.publicServerName" .) }}
{{- end -}}

{{/*
config.publicBaseURL.
*/}}
{{- define "matrix-synapse.publicBaseURL" -}}
{{- .Values.config.publicBaseurl | default ( printf "https://%s" (include "matrix-synapse.publicServerName" .)) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "matrix-synapse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "matrix-synapse.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{/* Default name is ".Release.Name" and not "default" due to DVC requirements. */}}
    {{ default .Release.Name .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default replication name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "matrix-synapse.replicationname" -}}
{{- printf "%s-%s" .Release.Name "replication" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default worker name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "matrix-synapse.workername" -}}
{{- printf "%s-%s" .global.Release.Name .worker | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default external component name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "matrix-synapse.externalname" -}}
{{- printf "%s-%s" .global.Release.Name .external | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "matrix-synapse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the correct image tag name
*/}}
{{- define "matrix-synapse.imageTag" -}}
{{- .Values.image.tag | default (printf "%s-jammy-production" .Chart.AppVersion) -}}
{{- end -}}

{{/*
Create the name of the service account to use in signingkey job (pre-install)
*/}}
{{- define "matrix-synapse.signingkeyServiceAccountName" -}}
{{- if .Values.signingkey.serviceAccount.create -}}
    {{ default (include "matrix-synapse.externalname" (dict "global" . "external" "signingkey-job")) .Values.signingkey.serviceAccount.name }}
{{- else -}}
    {{/* Default name is ".Release.Name"-"signingkey-job" */}}
    {{ default (include "matrix-synapse.externalname" (dict "global" . "external" "signingkey-job")) .Values.signingkey.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use in demomode job (if enabled)
*/}}
{{- define "matrix-synapse.demomodeServiceAccountName" -}}
{{- if .Values.demomode.serviceAccount.create -}}
    {{ default (include "matrix-synapse.externalname" (dict "global" . "external" "demomode")) .Values.demomode.serviceAccount.name }}
{{- else -}}
    {{/* Default name is ".Release.Name"-"demomode" */}}
    {{ default (include "matrix-synapse.externalname" (dict "global" . "external" "demomode")) .Values.demomode.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use in dsgvo-exporter job (if enabled)
*/}}
{{- define "matrix-synapse.dsgvoExportServiceAccountName" -}}
{{- if .Values.additionalConfig.dsgvoExport.serviceAccount.create -}}
    {{ default (include "matrix-synapse.externalname" (dict "global" . "external" "dsgvo-exporter")) .Values.additionalConfig.dsgvoExport.serviceAccount.name }}
{{- else -}}
    {{/* Default name is ".Release.Name"-"dsgvo-exporter" */}}
    {{ default (include "matrix-synapse.externalname" (dict "global" . "external" "dsgvo-exporter")) .Values.additionalConfig.dsgvoExport.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "matrix-synapse.labels" -}}
helm.sh/chart: {{ include "matrix-synapse.chart" . }}
{{ include "matrix-synapse.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "matrix-synapse.selectorLabels" -}}
app.kubernetes.io/name: {{ include "matrix-synapse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Monitoring labels
*/}}
{{- define "matrix-synapse.monitoringLabels" -}}
{{- if .Values.monitoring.enabled -}}
matrix-synapse: monitoring
{{- end -}}
{{- end -}}


{{/*
Pull secrets
*/}}
{{- define "matrix-synapse.imagePullSecrets" -}}
{{- with concat
    .Values.image.pullSecrets
    .Values.volumePermissions.image.pullSecrets
    .Values.wellknown.image.pullSecrets
-}}
imagePullSecrets:
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "matrix-synapse.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Set postgres host
*/}}
{{- define "matrix-synapse.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
  {{- template "matrix-synapse.postgresql.fullname" . -}}
{{- else -}}
  {{- required "A valid externalPostgresql.host is required" .Values.externalPostgresql.host }}
{{- end -}}
{{- end -}}

{{/*
Set postgres port
*/}}
{{- define "matrix-synapse.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
  {{- required
    "A valid PostgreSQL port at postgresql.primary.service.ports.postgresql is required"
    .Values.postgresql.primary.service.ports.postgresql
  -}}
{{- else -}}
  {{- required "A valid externalPostgresql.port is required" .Values.externalPostgresql.port -}}
{{- end -}}
{{- end -}}

{{/*
Set postgresql username
*/}}
{{- define "matrix-synapse.postgresql.username" -}}
{{- if .Values.postgresql.enabled -}}
  {{- .Values.postgresql.auth.username | default "postgres" }}
{{- else -}}
  {{- required "A valid externalPostgresql.username is required" .Values.externalPostgresql.username }}
{{- end -}}
{{- end -}}

{{/*
PostgreSQL password.

Empty if an existingSecret is used.
*/}}
{{- define "matrix-synapse.postgresql.password" -}}
{{- if and .Values.postgresql.enabled (not .Values.postgresql.auth.existingSecret) }}
  {{- required "PostgreSQL requires a Secret or password" .Values.postgresql.auth.password }}
{{- else if and (not .Values.postgresql.enabled) (not .Values.externalPostgresql.existingSecret) }}
  {{- required
    "External PostgreSQL requires a Secret or password"
    .Values.externalPostgresql.password
  }}
{{- end }}
{{- end -}}

{{/*
Name of the Secret containing the PostgreSQL password.

Empty if no existingSecret is used.
*/}}
{{- define "matrix-synapse.postgresql.secret-name" -}}
{{- if .Values.postgresql.enabled -}}
  {{ .Values.postgresql.auth.existingSecret | default "" }}
{{- else -}}
  {{ .Values.externalPostgresql.existingSecret | default "" }}
{{- end -}}
{{- end -}}

{{/*
Key to the password contained in the PostgreSQL Secret.

Empty if no existingSecret is used.
*/}}
{{- define "matrix-synapse.postgresql.secret-key" -}}
{{- if and .Values.postgresql.enabled .Values.postgresql.auth.existingSecret -}}
  {{- required
    "To use a Secret for PostgreSQL, postgresql.auth.secretKeys.userPasswordKey is required"
    .Values.postgresql.auth.secretKeys.userPasswordKey
  }}
{{- else if and (not .Values.postgresql.enabled) .Values.externalPostgresql.existingSecret -}}
  {{- required
    "To use a Secret for PostgreSQL, externalPostgresql.existingSecretPasswordKey is required"
    .Values.externalPostgresql.existingSecretPasswordKey
  }}
{{- end -}}
{{- end -}}

{{/*
Set postgresql database
*/}}
{{- define "matrix-synapse.postgresql.database" -}}
{{- if .Values.postgresql.enabled -}}
  {{- .Values.postgresql.auth.database | default "synapse" }}
{{- else -}}
  {{- required "A valid externalPostgresql.database is required" .Values.externalPostgresql.database }}
{{- end -}}
{{- end -}}

{{/*
Set postgresql sslmode
*/}}
{{- define "matrix-synapse.postgresql.sslmode" -}}
{{- if .Values.postgresql.enabled -}}
  {{- .Values.postgresql.sslmode | default "prefer" }}
{{- else -}}
  {{- .Values.externalPostgresql.sslmode | default "prefer" }}
{{- end -}}
{{- end -}}


{{/*
Set postgresql extra args
Refer to https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-PARAMKEYWORDS
for a list of options that can be passed.
*/}}
{{- define "matrix-synapse.postgresql.extraArgs" -}}
{{- if .Values.postgresql.enabled -}}
  {{- with .Values.postgresql.extraArgs }}
    {{- . | toYaml }}
  {{- end }}
{{- else -}}
  {{- with .Values.externalPostgresql.extraArgs }}
    {{- . | toYaml }}
  {{- end }}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "matrix-synapse.redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Set redis host
*/}}
{{- define "matrix-synapse.redis.host" -}}
{{- if .Values.redis.enabled -}}
  {{- printf "%s-%s" (include "matrix-synapse.redis.fullname" .) "master" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- required "A valid externalRedis.host is required" .Values.externalRedis.host }}
{{- end -}}
{{- end -}}

{{/*
Set redis port
*/}}
{{- define "matrix-synapse.redis.port" -}}
{{- if .Values.redis.enabled -}}
  {{- .Values.redis.master.service.ports.redis | default 6379 }}
{{- else -}}
  {{- required "A valid externalRedis.port is required" .Values.externalRedis.port }}
{{- end -}}
{{- end -}}

{{/*
Name of the Secret containing the Redis password.

Empty if no existingSecret is used.
*/}}
{{- define "matrix-synapse.redis.secret-name" -}}
{{- if .Values.redis.enabled }}
  {{- .Values.redis.auth.existingSecret | default "" -}}
{{- else -}}
  {{- .Values.externalRedis.existingSecret | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Key to the password contained in the Redis Secret.

Empty if no existingSecret is used.
*/}}
{{- define "matrix-synapse.redis.secret-key" -}}
{{- if and .Values.redis.enabled .Values.redis.auth.existingSecret }}
  {{- required
    "To use a Secret for Redis, redis.auth.existingSecretPasswordKey is required"
    .Values.redis.auth.existingSecretPasswordKey
  -}}
{{- else if and (not .Values.redis.enabled) .Values.externalRedis.existingSecret -}}
  {{- required
    "To use a Secret for Redis, externalRedis.existingSecretPasswordKey is required"
    .Values.externalRedis.existingSecretPasswordKey
  -}}
{{- end -}}
{{- end -}}

{{/*
Redis password.

Empty if an existingSecret is used.
*/}}
{{- define "matrix-synapse.redis.password" -}}
{{- if and .Values.redis.enabled (not .Values.redis.auth.existingSecret) }}
  {{- required "Redis requires a Secret or password" .Values.redis.auth.password }}
{{- else if and (not .Values.redis.enabled) (not .Values.externalRedis.existingSecret) }}
  {{- required
    "External Redis requires a Secret or password"
    .Values.externalRedis.password
  }}
{{- end }}
{{- end -}}

{{/*
Set synapse_admin uri
*/}}
{{- define "synapse-admin.host" -}}
  {{- if .Values.synapse_admin.enabled -}}
    {{- if .Values.synapse_admin.uri -}}
{{- .Values.synapse_admin.uri -}}
    {{- else }}
{{- required "A valid URI for the synapse Admin webGUI (synapse_admin.uri) is required." .Values.synapse_admin.uri -}}
    {{- end -}}
  {{- end -}}
{{- end -}}


{{/*
Check networkpolicy requirements TBD CHECK POSTGRES
*/}}
{{- if .Values.networkpolicies.enabled }}
  {{- if not .Values.postgresql.enabled -}}
    {{- required "A host from the external Postgres instance (externalPostgresql.host) is required." .Values.externalPostgresql.host -}}
  {{- end }}
  {{- if not .Values.redis.enabled -}}
    {{- required "A host from the external redis instance (externalRedis.host) is required." .Values.externalRedis.host -}}
  {{- end }}
{{- end }}

{{/*
Set MAS postgresql username
*/}}
{{- define "matrix-synapse.maspostgresql.username" -}}
  {{- if .Values.mas.enabled -}}
{{- .Values.mas.postgresql.username | default "mas-synapse" }}
  {{- end -}}
{{- end -}}

{{/*
Set MAS postgresql password
*/}}
{{- define "matrix-synapse.maspostgresql.password" -}}
  {{- if .Values.mas.enabled -}}
{{- .Values.mas.postgresql.password | default "mas-synapse" }}
  {{- end -}}
{{- end -}}

{{/*
Set MAS postgresql database
*/}}
{{- define "matrix-synapse.maspostgresql.database" -}}
  {{- if .Values.mas.enabled -}}
{{- .Values.mas.postgresql.database | default "mas-synapse" }}
  {{- end -}}
{{- end -}}

{{/*
Set MAS postgres host
*/}}
{{- define "matrix-synapse.maspostgresql.host" -}}
  {{- if .Values.mas.enabled -}}
{{- .Values.mas.postgresql.host | default ( include "matrix-synapse.postgresql.host" . ) -}}
  {{- end -}}
{{- end -}}

{{/*
MAS PostgreSQL port.

Defaults to `matrix-synapse.postgresql.port`.
*/}}
{{- define "matrix-synapse.maspostgresql.port" -}}
{{- if .Values.mas.enabled -}}
  {{- .Values.mas.postgresql.port | default (include "matrix-synapse.postgresql.port" .) -}}
{{- end -}}
{{- end -}}

{{/*
Set MAS postgresql sslmode
*/}}
{{- define "matrix-synapse.maspostgresql.sslmode" -}}
  {{- if .Values.mas.enabled -}}
{{- .Values.mas.postgresql.sslmode | default "prefer" }}
  {{- end -}}
{{- end -}}


{{/*
Set MAS postgresql extra args
Refer to https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-PARAMKEYWORDS
for a list of options that can be passed.
*/}}
{{- define "matrix-synapse.maspostgresql.extraArgs" -}}
  {{- if .Values.mas.enabled -}}
    {{- with .Values.mas.postgresql.extraArgs }}
{{- . | toYaml }}
    {{- end }}
  {{- end -}}
{{- end -}}

{{/*
Set MAS default uri
*/}}
{{- define "matrix-synapse.masUri" -}}
{{- if .Values.mas.enabled }}
  {{- .Values.mas.uri | default (include "matrix-synapse.publicServerName" .) }}
{{- end }}
{{- end -}}
