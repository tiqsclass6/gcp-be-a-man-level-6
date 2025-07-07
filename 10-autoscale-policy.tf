# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_autoscaler

resource "google_compute_region_autoscaler" "brazil" {
  name   = "brazil-autoscaler"
  region = "southamerica-east1"
  target = google_compute_region_instance_group_manager.brazil.id

  autoscaling_policy {
    max_replicas    = 6
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}
