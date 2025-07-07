# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones

data "google_compute_zones" "brazil-available" {
  status = "UP"
  region = "southamerica-east1"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager
resource "google_compute_region_instance_group_manager" "brazil" {
  name               = "brazil-mig"
  region             = "southamerica-east1"
  base_instance_name = "brazil"
  target_size        = 3

  version {
    instance_template = google_compute_instance_template.brazil-instance-template.id
  }

  distribution_policy_zones = [
    "southamerica-east1-a",
    "southamerica-east1-b",
    "southamerica-east1-c"
  ]

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.health-hc.id
    initial_delay_sec = 60
  }
}
