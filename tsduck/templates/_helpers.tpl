{{/*
Expand the name of the chart.
*/}}
{{- define "tsduck.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tsduck.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tsduck.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tsduck.labels" -}}
helm.sh/chart: {{ include "tsduck.chart" . }}
{{ include "tsduck.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tsduck.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tsduck.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tsduck.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tsduck.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Environment variables from secrets and config
*/}}
{{- define "helpers.list-env-variables"}}
{{- range $key, $val := .Values.env.secret }}
{{- if $val }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ include "tsduck.fullname" $ }}-secret
      key: {{ $key }}
{{- end}}
{{- end}}
{{- range $key, $val := .Values.env.normal }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end}}
{{- end }}
