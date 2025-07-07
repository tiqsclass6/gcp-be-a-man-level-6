# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

resource "google_compute_network" "bam6-vpc" {
  name                    = "bam6-vpc"
  auto_create_subnetworks = false
}
