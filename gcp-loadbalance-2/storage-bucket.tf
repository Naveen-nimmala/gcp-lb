

# ------------------------------------------------------------------------------
# CREATE THE BACKEND FOR THE STORAGE BUCKET
# ------------------------------------------------------------------------------

resource "google_compute_backend_bucket" "static" {
  project = var.project

  name        = "${var.name}-backend-bucket"
  bucket_name = var.bucketname
}
