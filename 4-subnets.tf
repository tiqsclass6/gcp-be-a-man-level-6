# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

# Public Subnet
resource "google_compute_subnetwork" "bam6-public" {
  name          = "bam6-public"
  ip_cidr_range = "10.235.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.bam6-vpc.id
}

# Private Subnet
resource "google_compute_subnetwork" "bam6-private" {
  name                     = "bam6-private"
  ip_cidr_range            = "10.236.0.0/24"
  region                   = "southamerica-east1"
  network                  = google_compute_network.bam6-vpc.id
  private_ip_google_access = true
}
