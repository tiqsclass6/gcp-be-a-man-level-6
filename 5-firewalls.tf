# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall

# Allow RDP
resource "google_compute_firewall" "bam6-rdp-allow" {
  name    = "bam6-allow-rdp"
  network = google_compute_network.bam6-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rdp-public"]
}

# Allow Internal Traffic
resource "google_compute_firewall" "bam6-allow-internal" {
  name    = "bam6-allow-internal"
  network = google_compute_network.bam6-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_tags = ["bam6-access"]
  target_tags = ["bam6-internal", "grafana"]
}

# Allow Health Check
resource "google_compute_firewall" "allow_health_check" {
  name    = "allow-health-check"
  network = google_compute_network.bam6-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["bam6-internal"]
}

# Allow Grafana HTTP
resource "google_compute_firewall" "allow_grafana_http" {
  name        = "allow-grafana-http"
  description = "Grafana Dashboard"
  network     = google_compute_network.bam6-vpc.name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["grafana"]
}
