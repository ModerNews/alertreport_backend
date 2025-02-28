{{- define "rocket-webhook.name" -}}
rocket-webhook
{{- end }}

{{- define "rocket-webhook.fullname" -}}
{{ .Release.Name }}-rocket-webhook
{{- end }}

