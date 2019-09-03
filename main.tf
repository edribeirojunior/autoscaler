terraform {
  required_version = "~> 0.12.0"
}

# ----------------------------------------------------------------------------------------------------------------------
# Locals
# ----------------------------------------------------------------------------------------------------------------------
data "google_compute_zones" "available" {
  project = "${var.project}"
  region  = "${var.region}"
}

locals {
  distribution_zones = {
    default = "${data.google_compute_zones.available.names}"
    user    = "${var.distribution_policy_zones}"
  }

  dependency_id = "${element(concat(null_resource.region_dummy_dependency.*.id, list("disabled")), 0)}"
}


# ----------------------------------------------------------------------------------------------------------------------
# Instance Template
# ----------------------------------------------------------------------------------------------------------------------

resource "google_compute_instance_template" "main" {
  provider    = "google-beta"
  project     = "${var.project}"
  name_prefix = "${var.instance_template_name_prefix}"

  machine_type = "${var.machine_type}"

  region = "${var.region}"

  tags = "${concat(list("allow-ssh"), var.target_tags)}"

  labels = "${var.instance_labels}"

  network_interface {
    network    = "${var.subnetwork == "" ? var.network : ""}"
    subnetwork = "${var.subnetwork}"
    #    access_config      = "${var.access_config}"
    #address            = "${var.network_ip}"
    subnetwork_project = "${var.subnetwork_project == "" ? var.project : var.subnetwork_project}"
  }

  can_ip_forward = "${var.can_ip_forward}"

  disk {
    auto_delete  = "${var.disk_auto_delete}"
    boot         = true
    source_image = "${var.compute_image}"
    type         = "PERSISTENT"
    disk_type    = "${var.disk_type}"
    disk_size_gb = "${var.disk_size_gb}"
    mode         = "${var.mode}"
  }

  service_account {
    email  = "${var.service_account_email}"
    scopes = "${var.service_account_scopes}"
  }


  scheduling {
    preemptible       = "${var.preemptible}"
    automatic_restart = "${var.automatic_restart}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Instance Group
# ----------------------------------------------------------------------------------------------------------------------

resource "google_compute_region_instance_group_manager" "main" {
  provider           = "google-beta"
  project            = "${var.project}"
  name               = "${var.instance_group_name}"
  description        = "compute VM Instance Group"
  wait_for_instances = "${var.wait_for_instances}"

  base_instance_name = "${var.base_instance_name}"

  version {
    name              = "instance_template"
    instance_template = "${google_compute_instance_template.main.self_link}"
  }

  region = "${var.region}"

  #  update_strategy       = "${var.update_strategy}"
  #  rolling_update_policy = "${var.rolling_update_policy}"

  distribution_policy_zones = "${local.distribution_zones["${length(var.distribution_policy_zones) == 0 ? "default" : "user"}"]}"

  target_pools = "${var.target_pools}"

  target_size = "${var.autoscaling ? var.min_replicas : var.size}"

  named_port {
    name = "${var.service_port_name}"
    port = "${var.service_port}"
  }

  auto_healing_policies {
    health_check      = "${var.http_health_check ? element(concat(google_compute_health_check.mig-health-check.*.self_link, list("")), 0) : ""}"
    initial_delay_sec = "${var.hc_initial_delay}"
  }

}
# ----------------------------------------------------------------------------------------------------------------------
# Autoscaler
# ----------------------------------------------------------------------------------------------------------------------
resource "google_compute_region_autoscaler" "main" {
  provider = "google-beta"
  count    = "${var.autoscaling ? 1 : 0}"
  name     = "${var.autoscaler_name}"
  region   = "${var.region}"
  project  = "${var.project}"
  target   = "${google_compute_region_instance_group_manager.main.self_link}"

  autoscaling_policy {
    max_replicas    = "${var.max_replicas}"
    min_replicas    = "${var.min_replicas}"
    cooldown_period = "${var.cooldown_period}"
    cpu_utilization {
      target = "${var.autoscaling_cpu}"
    }
  }

}

# ----------------------------------------------------------------------------------------------------------------------
# Health Check
# ----------------------------------------------------------------------------------------------------------------------
resource "google_compute_health_check" "mig-health-check" {
  provider = "google-beta"
  count    = "${var.http_health_check ? 1 : 0}"
  name     = "${var.health_check_name}"
  project  = "${var.project}"

  check_interval_sec  = "${var.hc_interval}"
  timeout_sec         = "${var.hc_timeout}"
  healthy_threshold   = "${var.hc_healthy_threshold}"
  unhealthy_threshold = "${var.hc_unhealthy_threshold}"

  http_health_check {
    port         = "${var.hc_port == "" ? var.service_port : var.hc_port}"
    request_path = "${var.hc_path}"
  }
}
resource "null_resource" "region_dummy_dependency" {
  depends_on = ["google_compute_region_instance_group_manager.main"]

  triggers = {
    instance_template = "${element(google_compute_instance_template.main.*.self_link, 0)}"
  }
}
