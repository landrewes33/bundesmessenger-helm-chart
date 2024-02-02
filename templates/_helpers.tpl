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
{{- if or .Values.image.pullSecrets .Values.wellknown.image.pullSecrets .Values.volumePermissions.pullSecrets }}
imagePullSecrets:
{{- with .Values.image.pullSecrets }}
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{- with .Values.wellknown.image.pullSecrets }}
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{- with .Values.volumePermissions.image.pullSecrets }}
  {{- . | toYaml | nindent 2 }}
{{- end }}
{{- end -}}
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
{{ required "A valid externalPostgresql.host is required" .Values.externalPostgresql.host }}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret
*/}}
{{- define "matrix-synapse.postgresql.secret" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "matrix-synapse.postgresql.fullname" . -}}
{{- else -}}
{{- template "matrix-synapse.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres port
*/}}
{{- define "matrix-synapse.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
{{- if .Values.postgresql.service -}}
{{- .Values.postgresql.service.port | default 5432 }}
{{- else -}}
5432
{{- end -}}
{{- else -}}
{{- required "A valid externalPostgresql.port is required" .Values.externalPostgresql.port -}}
{{- end -}}
{{- end -}}

{{/*
Set postgresql username
*/}}
{{- define "matrix-synapse.postgresql.username" -}}
{{- if .Values.postgresql.enabled -}}
{{-  if .Values.postgresql.postgresqlUsername -}}
{{-    fail "You need to switch to the new postgresql.auth values." -}}
{{-  end -}}
{{- .Values.postgresql.auth.username | default "postgres" }}
{{- else -}}
{{ required "A valid externalPostgresql.username is required" .Values.externalPostgresql.username }}
{{- end -}}
{{- end -}}

{{/*
Set postgresql password
*/}}
{{- define "matrix-synapse.postgresql.password" -}}
{{- if .Values.postgresql.enabled -}}
{{-  if .Values.postgresql.postgresqlPassword -}}
{{-    fail "You need to switch to the new postgresql.auth values." -}}
{{-  end -}}
{{- .Values.postgresql.auth.password | default "synapse" }}
{{- else if not (and .Values.externalPostgresql.existingSecret .Values.externalPostgresql.existingSecretPasswordKey) -}}
{{ required "A valid externalPostgresql.password is required" .Values.externalPostgresql.password }}
{{- end -}}
{{- end -}}

{{/*
Set postgresql database
*/}}
{{- define "matrix-synapse.postgresql.database" -}}
{{- if .Values.postgresql.enabled -}}
{{-  if .Values.postgresql.postgresqlDatabase -}}
{{-    fail "You need to switch to the new postgresql.auth values." -}}
{{-  end -}}
{{- .Values.postgresql.auth.database | default "synapse" }}
{{- else -}}
{{ required "A valid externalPostgresql.database is required" .Values.externalPostgresql.database }}
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
{{ required "A valid externalRedis.host is required" .Values.externalRedis.host }}
{{- end -}}
{{- end -}}

{{/*
Set redis secret
*/}}
{{- define "matrix-synapse.redis.secret" -}}
{{- if .Values.redis.enabled -}}
{{- template "matrix-synapse.redis.fullname" . -}}
{{- else -}}
{{- template "matrix-synapse.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set redis port
*/}}
{{- define "matrix-synapse.redis.port" -}}
{{- if .Values.redis.enabled -}}
{{- .Values.redis.master.service.ports.redis | default 6379 }}
{{- else -}}
{{ required "A valid externalRedis.port is required" .Values.externalRedis.port }}
{{- end -}}
{{- end -}}

{{/*
Set redis password
*/}}
{{- define "matrix-synapse.redis.password" -}}
{{- if .Values.redis.password -}}
{{ .Values.redis.password }}
{{- else if .Values.redis.auth.password -}}
{{ .Values.redis.auth.password }}
{{- else if .Values.externalRedis.password -}}
{{ .Values.externalRedis.password }}
{{- end -}}
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
  {{- if .Values.mas.enabled -}}
{{- .Values.mas.uri | default ( .Values.publicServerName | default .Values.serverName ) -}}
  {{- end -}}
{{- end -}}
