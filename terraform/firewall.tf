resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_firewall" "bindplane_fw" {
  name    = "bindplane-fw-${random_id.suffix.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports = [
      "22",    # SSH
      "80",    # HTTP
      "443",   # HTTPS
      "3001",  # BindPlane UI / API
      "5432"   # PostgreSQL
    ]
  }

  source_ranges = ["0.0.0.0/0"]

  depends_on = [google_project_service.compute]
}
