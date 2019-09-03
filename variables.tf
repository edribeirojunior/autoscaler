# ----------------------------------------------------------------------------------------------------------------------
# Instance Template
# ----------------------------------------------------------------------------------------------------------------------
variable project {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}
variable instance_template_name_prefix {
  description = "Prefix of the instance template."
  default     = ""
}
variable machine_type {
  description = "Machine type for the VMs in the instance group."
  default     = "f1-micro"
}
variable region {
  description = "Region for cloud resources."
  default     = "southamerica-east1"
}

variable target_tags {
  description = "Tag added to instances for firewall and networking."
  type        = "list"
  default     = ["allow-service"]
}

variable instance_labels {
  description = "Labels added to instances."
  type        = "map"
  default     = {}
}
variable network {
  description = "Name of the network to deploy instances to."
  default     = "default"
}
variable subnetwork {
  description = "The subnetwork to deploy to"
  default     = "default"
}
variable subnetwork_project {
  description = "The project the subnetwork belongs to. If not set, var.project is used instead."
  default     = ""
}

variable access_config {
  description = "The access config block for the instances. Set to [] to remove external IP."
  type        = "list"

  default = [
    {},
  ]
}
variable network_ip {
  description = "Set the network IP of the instance in the template. Useful for instance groups of size 1."
  default     = ""
}
variable can_ip_forward {
  description = "Allow ip forwarding."
  default     = false
}

variable disk_auto_delete {
  description = "Whether or not the disk should be auto-deleted."
  default     = true
}
variable compute_image {
  description = "Image used for compute VMs."
  default     = "projects/debian-cloud/global/images/family/debian-9"
}
variable disk_type {
  description = "The GCE disk type. Can be either pd-ssd, local-ssd, or pd-standard."
  default     = "pd-ssd"
}

variable disk_size_gb {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  default     = 0
}

variable mode {
  description = "The mode in which to attach this disk, either READ_WRITE or READ_ONLY."
  default     = "READ_WRITE"
}

variable service_account_email {
  description = "The email of the service account for the instance template."
  default     = "default"
}

variable service_account_scopes {
  description = "List of scopes for the instance template service account"
  type        = "list"

  default = ["https://www.googleapis.com/auth/compute", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/devstorage.full_control"]
}

variable preemptible {
  description = "Use preemptible instances - lower price but short-lived instances. See https://cloud.google.com/compute/docs/instances/preemptible for more details"
  default     = "false"
}

variable automatic_restart {
  description = "Automatically restart the instance if terminated by GCP - Set to false if using preemptible instances"
  default     = "true"
}

# ----------------------------------------------------------------------------------------------------------------------
# Group Instance
# ----------------------------------------------------------------------------------------------------------------------

variable instance_group_name {
  description = "Name of the managed instance group."
}

variable wait_for_instances {
  description = "Wait for all instances to be created/updated before returning"
  default     = false
}
variable base_instance_name {
  description = "Name of the managed instance group."
}

variable update_strategy {
  description = "The strategy to apply when the instance template changes."
  default     = "NONE"
}

variable rolling_update_policy {
  description = "The rolling update policy when update_strategy is ROLLING_UPDATE"
  type        = "list"
  default     = []
}
variable distribution_policy_zones {
  description = "Default is all zones in given region."
  type        = "list"
  default     = []
}

variable target_pools {
  description = "The target load balancing pools to assign this group to."
  type        = "list"
  default     = []
}
variable size {
  description = "Target size of the managed instance group."
  default     = 1
}

variable service_port {
  description = "Port the service is listening on."
}

variable service_port_name {
  description = "Name of the port the service is listening on."
}

# ----------------------------------------------------------------------------------------------------------------------
# Autoscaler
# ----------------------------------------------------------------------------------------------------------------------
variable autoscaling {
  description = "Enable autoscaling."
  default     = true
}
variable autoscaler_name {
  description = "Name of the Autoscaler config."
}
variable max_replicas {
  description = "Autoscaling, max replicas."
  default     = 5
}

variable min_replicas {
  description = "Autoscaling, min replics."
  default     = 1
}

variable cooldown_period {
  description = "Autoscaling, cooldown period in seconds."
  default     = 60
}

variable autoscaling_cpu {
  description = "Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#cpu_utilization"
  default     = 0.8
}

variable autoscaling_metric {
  description = "Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#metric"
  type        = "list"
  default     = []
}
variable http_health_check {
  description = "Enable or disable the http health check for auto healing."
  default     = true
}
# ----------------------------------------------------------------------------------------------------------------------
# Health checks
# ----------------------------------------------------------------------------------------------------------------------
variable "health_check_name" {
  description = "Name of Health Check config."
}

variable hc_initial_delay {
  description = "Health check, intial delay in seconds."
  default     = 30
}

variable hc_interval {
  description = "Health check, check interval in seconds."
  default     = 30
}

variable hc_timeout {
  description = "Health check, timeout in seconds."
  default     = 10
}

variable hc_healthy_threshold {
  description = "Health check, healthy threshold."
  default     = 1
}

variable hc_unhealthy_threshold {
  description = "Health check, unhealthy threshold."
  default     = 10
}

variable hc_port {
  description = "Health check, health check port, if different from var.service_port, if not given, var.service_port is used."
  default     = ""
}

variable hc_path {
  description = "Health check, the http path to check."
  default     = "/"
}
