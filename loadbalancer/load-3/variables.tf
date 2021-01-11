variable "project" {
  description = "The project ID to create the resources in."
  default     = "new-k8s-253203"
}

variable "name" {
  description = "Name for the load balancer forwarding rule and prefix for supporting resources."
  default     = "naveen"
}

variable "url_map" {
  description = "A reference (self_link) to the url_map resource to use."
  default     = "naveen-url"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------
# variable "enable_ssl" {
#   description = "Set to true to enable ssl. If set to 'true', you will also have to provide 'var.ssl_certificates'."
#   default     = false
# }

# variable "ssl_certificates" {
#   description = "List of SSL cert self links. Required if 'enable_ssl' is 'true'."
#   type        = list(string)
#   default     = []
# }

variable "enable_http" {
  description = "Set to true to enable plain http. Note that disabling http does not force SSL and/or redirect HTTP traffic. See https://issuetracker.google.com/issues/35904733"
  default     = true
}

# variable "create_dns_entries" {
#   description = "If set to true, create a DNS A Record in Cloud DNS for each domain specified in 'custom_domain_names'."
#   default     = false
# }

# variable "custom_domain_names" {
#   description = "List of custom domain names."
#   type        = list(string)
#   default     = []
# }

# variable "dns_managed_zone_name" {
#   description = "The name of the Cloud DNS Managed Zone in which to create the DNS A Records specified in 'var.custom_domain_names'. Only used if 'var.create_dns_entries' is true."
#   default     = "replace-me"
# }

# variable "dns_record_ttl" {
#   description = "The time-to-live for the site A records (seconds)"
#   default     = 300
# }

variable "custom_labels" {
  description = "A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  type        = map(string)
  default     = {}
}
