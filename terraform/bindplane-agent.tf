resource "google_compute_instance" "bindplane_agent" {
  name         = "bindplane-agent-${random_id.suffix.hex}"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    apt update -y
    apt install -y curl sudo

    # Wait until BindPlane Server VM is ready
    BINDPLANE_SERVER_IP="${google_compute_instance.bindplane_vm.network_interface[0].access_config[0].nat_ip}"
    until nc -zv $BINDPLANE_SERVER_IP 3001 >/dev/null 2>&1; do
      echo "Waiting for BindPlane server at $BINDPLANE_SERVER_IP:3001..."
      sleep 5
    done

    # Install BindPlane agent
    sudo sh -c "$(curl -fsSL 'https://bdot.bindplane.com/v1.90.0/install_unix.sh')" \
      -e "ws://${BINDPLANE_SERVER_IP}:3001/v1/opamp" \
      -s "01KF69KEJVDVG2RCTDKPTTDX1J" \
      -v "1.90.0" \
      -k "configuration=logs,install_id=e1794847-3e65-4b8b-8a31-eabe29a9ffd2"

    echo "BindPlane agent installed and configured successfully!"
  EOF

  depends_on = [
    google_compute_instance.bindplane_vm
  ]
}
