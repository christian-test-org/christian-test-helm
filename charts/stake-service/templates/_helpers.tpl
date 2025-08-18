{{/*
Base labels - includes version which can change
*/}}
{{ define "christian-service.baseLabels" }}
app: {{ .Values.global.serviceName }}
team: {{ .Values.global.team }}
tags.datadoghq.com/env: {{ .Values.global.environment }}
tags.datadoghq.com/service: {{ .Values.global.serviceName }}
tags.datadoghq.com/version: {{ .Values.global.appVersion }}
{{ end }}

{{/*
Generate the full image name
*/}}
{{- define "christian-service.image" -}}
{{- $repo := .Values.deployment.ecrRepoName | required "global.ecrRepoName is required" -}}
{{- $tag := .Values.global.appVersion -}}
{{- printf "%s:%s" $repo $tag -}}
{{- end }}

{{- define "christian-service.labels" -}}
{{- $baseLabels := include "christian-service.baseLabels" . | fromYaml -}}
{{- if .Values.overrideLabels -}}
{{- toYaml .Values.overrideLabels -}}
{{- else if .Values.extraLabels -}}
{{- $mergedLabels := merge $baseLabels .Values.extraLabels -}}
{{- toYaml $mergedLabels -}}
{{- else -}}
{{- toYaml $baseLabels -}}
{{- end -}}
{{- end -}}

{{ define "christian-service.baseSelectors" }}
tags.datadoghq.com/env: {{ .Values.global.environment }}
tags.datadoghq.com/service: {{ .Values.global.serviceName }}
{{ end }}

{{- define "christian-service.selectors" -}}
{{- $baseSelectors := include "christian-service.baseSelectors" . | fromYaml -}}
{{- if .Values.overrideSelectors -}}
{{- toYaml .Values.overrideSelectors -}}
{{- else if .Values.extraSelectors -}}
{{- $mergedSelectors := merge $baseSelectors .Values.extraSelectors -}}
{{- toYaml $mergedSelectors -}}
{{- else -}}
{{- toYaml $baseSelectors -}}
{{- end -}}
{{- end -}}

{{- define "christian-service.deploymentAnnotations" -}}
{{- $annotations := .Values.deployment.annotations | default dict }}
{{- toYaml $annotations | nindent 0 }}
{{- end }}

{{/*
Use to set replica count for deployment if HPA is not enabled
*/}}
{{- define "christian-service.replicas" -}}
{{- if .Values.autoscaling.horizontal.enabled -}}
{{- /* Return null/empty when HPA is enabled */ -}}
{{- else -}}
{{- if hasKey .Values.deployment "replicas" -}}
{{- .Values.deployment.replicas -}}
{{- else -}}
{{- 1 -}}
{{- end -}}
{{- end -}}
{{- end }}


{{/*
Use global.namespace if provided, otherwise fallback to global.serviceName
*/}}
{{- define "christian-service.namespace" -}}
{{- .Values.global.namespace | default .Values.global.serviceName -}}
{{- end }}
