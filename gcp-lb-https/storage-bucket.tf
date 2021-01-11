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
