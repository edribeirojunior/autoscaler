# Módulo Terraform - Google - Autoscaler

Módulo do Terraform para provisionamento do Autoscale.

## Uso

```hcl
module "autoscaler" {
  source = "git::ssh://git@gitlab.com/mandic-labs/terraform/modules/google/autoscaler.git?ref=v0.0.1"

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
```

## Recursos provisionados

- Instance template
- Instance group
- Autoscaler
- HealthCheck

## Exemplos

<!-- TODO: alterar título e link abaixo conforme diretório de exemplo criado. -->
- [Exemplo simples](examples/simple-example/)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autoscaler\_name | Name of the Autoscaler config. | string | n/a | yes |
| base\_instance\_name | Name of the managed instance group. | string | n/a | yes |
| health\_check\_name | Name of Health Check config. | string | n/a | yes |
| instance\_group\_name | Name of the managed instance group. | string | n/a | yes |
| service\_port | Port the service is listening on. | string | n/a | yes |
| service\_port\_name | Name of the port the service is listening on. | string | n/a | yes |
| access\_config | The access config block for the instances. Set to [] to remove external IP. | list | `[ {} ]` | no |
| automatic\_restart | Automatically restart the instance if terminated by GCP - Set to false if using preemptible instances | string | `"true"` | no |
| autoscaling | Enable autoscaling. | string | `"true"` | no |
| autoscaling\_cpu | Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#cpu_utilization | string | `"0.8"` | no |
| autoscaling\_metric | Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#metric | list | `[]` | no |
| can\_ip\_forward | Allow ip forwarding. | string | `"false"` | no |
| compute\_image | Image used for compute VMs. | string | `"projects/debian-cloud/global/images/family/debian-9"` | no |
| cooldown\_period | Autoscaling, cooldown period in seconds. | string | `"60"` | no |
| disk\_auto\_delete | Whether or not the disk should be auto-deleted. | string | `"true"` | no |
| disk\_size\_gb | The size of the image in gigabytes. If not specified, it will inherit the size of its base image. | string | `"0"` | no |
| disk\_type | The GCE disk type. Can be either pd-ssd, local-ssd, or pd-standard. | string | `"pd-ssd"` | no |
| distribution\_policy\_zones | Default is all zones in given region. | list | `[]` | no |
| hc\_healthy\_threshold | Health check, healthy threshold. | string | `"1"` | no |
| hc\_initial\_delay | Health check, intial delay in seconds. | string | `"30"` | no |
| hc\_interval | Health check, check interval in seconds. | string | `"30"` | no |
| hc\_path | Health check, the http path to check. | string | `"/"` | no |
| hc\_port | Health check, health check port, if different from var.service_port, if not given, var.service_port is used. | string | `""` | no |
| hc\_timeout | Health check, timeout in seconds. | string | `"10"` | no |
| hc\_unhealthy\_threshold | Health check, unhealthy threshold. | string | `"10"` | no |
| http\_health\_check | Enable or disable the http health check for auto healing. | string | `"true"` | no |
| instance\_labels | Labels added to instances. | map | `{}` | no |
| instance\_template\_name\_prefix | Prefix of the instance template. | string | `""` | no |
| machine\_type | Machine type for the VMs in the instance group. | string | `"f1-micro"` | no |
| max\_replicas | Autoscaling, max replicas. | string | `"5"` | no |
| min\_replicas | Autoscaling, min replics. | string | `"1"` | no |
| mode | The mode in which to attach this disk, either READ_WRITE or READ_ONLY. | string | `"READ_WRITE"` | no |
| network | Name of the network to deploy instances to. | string | `"default"` | no |
| network\_ip | Set the network IP of the instance in the template. Useful for instance groups of size 1. | string | `""` | no |
| preemptible | Use preemptible instances - lower price but short-lived instances. See https://cloud.google.com/compute/docs/instances/preemptible for more details | string | `"false"` | no |
| project | The project to deploy to, if not set the default provider project is used. | string | `""` | no |
| region | Region for cloud resources. | string | `"southamerica-east1"` | no |
| rolling\_update\_policy | The rolling update policy when update_strategy is ROLLING_UPDATE | list | `[]` | no |
| service\_account\_email | The email of the service account for the instance template. | string | `"default"` | no |
| service\_account\_scopes | List of scopes for the instance template service account | list | `[ "https://www.googleapis.com/auth/compute", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/devstorage.full_control" ]` | no |
| size | Target size of the managed instance group. | string | `"1"` | no |
| subnetwork | The subnetwork to deploy to | string | `"default"` | no |
| subnetwork\_project | The project the subnetwork belongs to. If not set, var.project is used instead. | string | `""` | no |
| target\_pools | The target load balancing pools to assign this group to. | list | `[]` | no |
| target\_tags | Tag added to instances for firewall and networking. | list | `[ "allow-service" ]` | no |
| update\_strategy | The strategy to apply when the instance template changes. | string | `"NONE"` | no |
| wait\_for\_instances | Wait for all instances to be created/updated before returning | string | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| health\_check | The healthcheck for the managed instance group |
| instance\_template | Link to the instance_template for the group |
| network\_ip | Pass through of input `network_ip`. |
| region\_depends\_id | Id of the dummy dependency created used for intra-module dependency creation with regional groups. |
| region\_instance\_group | Link to the `instance_group` property of the region instance group manager resource. |
| service\_port | Pass through of input `service_port`. |
| service\_port\_name | Pass through of input `service_port_name`. |
| target\_tags | Pass through of input `target_tags`. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Licença

Copyright © 2019 Mandic Cloud Solutions. Todos os direitos reservados.
