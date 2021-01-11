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



variable "enable_http" {
  description = "Set to true to enable plain http. Note that disabling http does not force SSL and/or redirect HTTP traffic. See https://issuetracker.google.com/issues/35904733"
  default     = true
}

variable "bucketname" {
  description = "Set to true to enable plain http. Note that disabling http does not force SSL and/or redirect HTTP traffic. See https://issuetracker.google.com/issues/35904733"
  default     = "mybucket-f"
}

