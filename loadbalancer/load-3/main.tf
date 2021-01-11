# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A HTTP LOAD BALANCER
# This module deploys a HTTP(S) Cloud Load Balancer
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CREATE A PUBLIC IP ADDRESS
# ------------------------------------------------------------------------------

resource "google_compute_global_address" "default" {
  provider     = "google-beta"
  project      = var.project
  name         = "${var.name}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

# ------------------------------------------------------------------------------
# IF PLAIN HTTP ENABLED, CREATE FORWARDING RULE AND PROXY
# ------------------------------------------------------------------------------

resource "google_compute_target_http_proxy" "http" {
  # count    = var.enable_http ? 1 : 0
  provider = "google-beta"
  project  = var.project
  name     = "${var.name}-http-proxy"
  url_map  = "${var.name}-url-map"
}

resource "google_compute_global_forwarding_rule" "http" {
  count    = var.enable_http ? 1 : 0
  provider = "google-beta"
  project  = var.project
  name     = "${var.name}-http-rule"
  # target     = google_compute_target_http_proxy.http.self_link
  target     = google_compute_target_http_proxy.http.self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"

  depends_on = ["google_compute_global_address.default"]

  # labels = var.custom_labels
}

# ------------------------------------------------------------------------------
# IF SSL ENABLED, CREATE FORWARDING RULE AND PROXY
# ------------------------------------------------------------------------------

# resource "google_compute_global_forwarding_rule" "https" {
#   provider   = "google-beta"
#   project    = var.project
#   count      = var.enable_ssl ? 1 : 0
#   name       = "${var.name}-https-rule"
#   target     = google_compute_target_https_proxy.default.self_link
#   ip_address = google_compute_global_address.default.address
#   port_range = "443"
#   depends_on = ["google_compute_global_address.default"]

#   labels = var.custom_labels
# }

# resource "google_compute_target_https_proxy" "default" {
#   project  = var.project
#   provider = "google-beta"
#   count    = var.enable_ssl ? 1 : 0
#   name     = "${var.name}-https-proxy"
#   url_map  = "${var.name}-url-map"

#   # ssl_certificates = ["${var.ssl_certificates}"]
# }

# ------------------------------------------------------------------------------
# IF DNS ENTRY REQUESTED, CREATE A RECORD POINTING TO THE PUBLIC IP OF THE CLB
# ------------------------------------------------------------------------------

# resource "google_dns_record_set" "dns" {
#   provider = "google-beta"
#   project  = "${var.project}"
#   count    = "${var.create_dns_entries ? length(var.custom_domain_names) : 0}"

#   name = "${element(var.custom_domain_names, count.index)}."
#   type = "A"
#   ttl  = "${var.dns_record_ttl}"

#   managed_zone = "${var.dns_managed_zone_name}"

#   rrdatas = ["${google_compute_global_address.default.address}"]
# }

# ------------------------------------------------------------------------------
# CREATE THE URL MAP TO MAP PATHS TO BACKENDS
# ------------------------------------------------------------------------------

resource "google_compute_url_map" "urlmap" {
  project = var.project

  name        = "${var.name}-url-map"
  description = "URL map for ${var.name}"

  default_service = google_compute_backend_bucket.static.self_link

  # host_rule {
  #   hosts        = ["*"]
  #   path_matcher = "all"
  # }

  # path_matcher {
  #   name            = "all"
  #   default_service = google_compute_backend_bucket.static.self_link

  #   path_rule {
  #     paths   = ["/api", "/api/*"]
  #     service = google_compute_backend_service.api.self_link
  #   }
  # }
}

# ------------------------------------------------------------------------------
# CREATE THE BACKEND SERVICE CONFIGURATION FOR THE INSTANCE GROUP
# ------------------------------------------------------------------------------

# resource "google_compute_backend_service" "api" {
#   project = var.project

#   name        = "${var.name}-api"
#   description = "API Backend for ${var.name}"
#   port_name   = "http"
#   protocol    = "HTTP"
#   timeout_sec = 10
#   enable_cdn  = false

#   backend {
#     group = google_compute_instance_group.api.self_link
#   }

#   health_checks = [google_compute_health_check.default.self_link]

#   depends_on = [google_compute_instance_group.api]
# }

resource "google_compute_backend_service" "default" {
  name          = "backend-service"
  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

# ------------------------------------------------------------------------------
# CREATE THE STORAGE BUCKET FOR THE STATIC CONTENT
# ------------------------------------------------------------------------------

resource "google_storage_bucket" "static" {
  project = var.project

  name          = "${var.name}-bucket"
  location      = "US"
  storage_class = "MULTI_REGIONAL"

  # website {
  #   main_page_suffix = "index.html"
  #   not_found_page   = "404.html"
  # }

  # For the example, we want to clean up all resources. In production, you should set this to false to prevent
  # accidental loss of data
  force_destroy = false

  #  labels = var.custom_labels
}


# ------------------------------------------------------------------------------
# CREATE THE BACKEND FOR THE STORAGE BUCKET
# ------------------------------------------------------------------------------

resource "google_compute_backend_bucket" "static" {
  project = var.project

  name        = "${var.name}-backend-bucket"
  bucket_name = google_storage_bucket.static.name
}
