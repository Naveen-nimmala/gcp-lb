
resource "google_compute_backend_service" "default" {
  name = "new-backend-service"
  # health_checks = [google_compute_http_health_check.default.id]
}
