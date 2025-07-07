# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance

# Grafana Linux VM
resource "google_compute_instance" "grafana_vm" {
  name         = "grafana-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["grafana", "http-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.bam6-vpc.id
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apt-transport-https software-properties-common wget
    wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
    echo "deb https://packages.grafana.com/oss/deb stable main" | tee /etc/apt/sources.list.d/grafana.list
    apt-get update
    apt-get install grafana -y
    systemctl enable grafana-server
    systemctl start grafana-server
  EOT
}
