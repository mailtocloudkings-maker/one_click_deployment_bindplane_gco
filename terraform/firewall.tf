resource "random_id" "suffix" {
  byte_length = 3
}

resource "google_compute_firewall" "bindplane_fw" {
  name    = "bindplane-fw-${random_id.suffix.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "3001", "5432", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bindplane"]
}
