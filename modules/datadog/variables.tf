variable "create" {
  default = true
}

variable "name" {
  description = "The name of the Cluster"
}

variable "cluster_id" {
  description = "The id of the Cluster"
}

variable "datadog_enabled" {
  description = "Is datadog enabled ? "
  default     = false
}

variable "datadog_api_key" {
  description = "Datadog API Key"
  default     = false
}

variable "environment" {
  description = "Which environment are we in ? For datadog"
  type        = "string"
}
