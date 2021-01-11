provider "google" {
  credentials = file("../../key.json")
  project     = "new-k8s-253203"
  region      = "us-central1"
  zone        = "us-central1-a"
}


module "lb" {
  source       = "GoogleCloudPlatform/lb/google"
  version      = "2.2.0"
  region       = "us-central1"
  name         = "load-balancer"
  service_port = 80
  target_tags  = ["my-target-pool"]
  # network      = google_compute_network.vpc_network.name
}
