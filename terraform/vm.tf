resource "google_compute_instance" "bindplane_vm" {
  name         = "bindplane-vm-${random_id.suffix.hex}"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    # Update system
    apt update -y
    apt install -y curl ca-certificates

    # Install Docker
    curl -fsSL https://get.docker.com | sh

    # Install Docker Compose plugin
    apt install -y docker-compose-plugin

    # Create BindPlane directory
    mkdir -p /opt/bindplane
    cd /opt/bindplane

    # Write Docker Compose file
    cat << 'YAML' > docker-compose.yml
    ${file("${path.module}/../docker/docker-compose.yml")}
    YAML

    # Wait for Docker daemon
    until docker info >/dev/null 2>&1; do
      sleep 3
    done

    # Start BindPlane Server
    docker compose up -d
  EOF

  tags = ["bindplane"]

  depends_on = [
    google_compute_firewall.bindplane_fw
  ]
}
