# ------------------------------------------------------------------------------
# IF PLAIN HTTP ENABLED, CREATE FORWARDING RULE AND PROXY
# ------------------------------------------------------------------------------

resource "google_compute_target_http_proxy" "http" {
  # count    = var.enable_http ? 1 : 0
  provider   = "google-beta"
  project    = var.project
  name       = "${var.name}-http-proxy"
  url_map    = "${var.name}-url-map"
  depends_on = ["google_compute_url_map.urlmap"]

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
