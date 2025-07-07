# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
resource "google_compute_global_forwarding_rule" "entry_point" {
  name                  = "tsa-gateway"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.tsa-http-proxy.id

  depends_on = [
    google_compute_subnetwork.bam6-private,
  ]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy
resource "google_compute_target_http_proxy" "tsa-http-proxy" {
  name    = "tsa-http-proxy"
  url_map = google_compute_url_map.tsa_url_map.id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
resource "google_compute_url_map" "tsa_url_map" {
  name            = "tsa-url-map"
  default_service = google_compute_backend_service.backend_service.id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
resource "google_compute_backend_service" "backend_service" {
  name                            = "tsa-backend-service"
  load_balancing_scheme           = "EXTERNAL"
  port_name                       = "http"
  protocol                        = "HTTP"
  timeout_sec                     = 10
  connection_draining_timeout_sec = 0

  backend {
    group           = google_compute_region_instance_group_manager.brazil.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
    max_utilization = 0.8
  }

  health_checks = [google_compute_health_check.tsa-health-check.self_link]
}
