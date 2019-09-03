provider "google" {}

# ----------------------------------------------------------------------------------------------------------------------
# Autoscaler
# ----------------------------------------------------------------------------------------------------------------------

module "autoscaler" {
  source = "../../"
  
  project                       = "terraform-test-249120"
  instance_template_name_prefix = "test-template"

  machine_type  = "f1-micro"
  compute_image = "projects/debian-cloud/global/images/family/debian-9"
  disk_size_gb  = 30
  region        = "southamerica-east1"
  network       = "projects/terraform-test-249120/global/networks/default"
  subnetwork    = "subnet-biondo-test"

  instance_group_name = "test-instance-group"
  base_instance_name  = "biondo-vms"
  size                = 2
  service_port        = 3000
  service_port_name   = "app-port"

  autoscaler_name   = "test-autoscaler"
  health_check_name = "app-healthcheck"

  autoscaling_cpu = 0.8
  
  instance_labels = {
    environment = "dev"
    terraform   = "true"
    projeto     = "simple-example-project"
  }
}