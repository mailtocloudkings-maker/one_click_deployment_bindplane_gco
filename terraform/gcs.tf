resource "google_storage_bucket" "bindplane_bucket" {
  name          = "bindplane-bucket-${random_id.suffix.hex}"
  location      = var.gcp_region
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}

output "bindplane_bucket_name" {
  value = google_storage_bucket.bindplane_bucket.name
}
