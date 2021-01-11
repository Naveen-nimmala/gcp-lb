
# ------------------------------------------------------------------------------
# IF SSL ENABLED, CREATE FORWARDING RULE AND PROXY
# ------------------------------------------------------------------------------

resource "google_compute_global_forwarding_rule" "https" {
  provider   = "google-beta"
  project    = var.project
  count      = var.enable_ssl ? 1 : 0
  name       = "${var.name}-https-rule"
  target     = google_compute_target_https_proxy.default.self_link
  ip_address = google_compute_global_address.default.address
  port_range = "443"
  depends_on = ["google_compute_global_address.default"]

  # labels = var.custom_labels
}

resource "google_compute_target_https_proxy" "default" {
  project    = var.project
  provider   = "google-beta"
  count      = var.enable_ssl ? 1 : 0
  name       = "${var.name}-https-proxy"
  url_map    = "${var.name}-url-map"
  depends_on = ["google_compute_url_map.urlmap"]

  ssl_certificates = ["${var.ssl_certificates}"]
}


