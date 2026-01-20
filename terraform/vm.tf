resource "random_id" "suffix" {
  byte_length = 2
}

resource "google_compute_instance" "bindplane_vm" {
  name         = "bindplane-vm-${random_id.suffix.hex}"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
    }
  }

  network_interface {
    network = "default"
    access_config {} # Ephemeral public IP
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    apt update -y
    apt install -y curl ca-certificates

    # Install Docker & Compose
    curl -fsSL https://get.docker.com | sh
    apt install -y docker-compose-plugin

    mkdir -p /opt/bindplane
    cd /opt/bindplane

    # Get VM public IP dynamically from GCP metadata
    export BINDPLANE_PUBLIC_IP=$(curl -s -H "Metadata-Flavor: Google" \
    http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

    # Copy docker-compose.yml
    cat << 'EOFYAML' > docker-compose.yml
    ${file("${path.module}/../docker/docker-compose.yml")}
    EOFYAML

    # Start BindPlane Server
    docker compose up -d
  EOF

  depends_on = [
    google_compute_firewall.bindplane_fw
  ]
}
