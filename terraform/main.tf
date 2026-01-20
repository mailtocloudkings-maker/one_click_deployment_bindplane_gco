provider "google" {
  project = var.project_id
  region  = var.region
}

resource "random_id" "suffix" {
  byte_length = 3
}

# Firewall
resource "google_compute_firewall" "bindplane_fw" {
  name    = "bindplane-fw-${random_id.suffix.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "3001", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# VM
resource "google_compute_instance" "vm" {
  name         = "bindplane-vm-${random_id.suffix.hex}"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

# GCS Bucket
resource "google_storage_bucket" "logs" {
  name     = "bindplane-logs-${random_id.suffix.hex}"
  location = var.region
}
