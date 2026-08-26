# ==================
# Root module inputs
# ==================

#
# These are the CIDR blocks controlling access to the cluster. 
# It is used to configure the security group rules for the control plane nodes, allowing access to the Kubernetes and Talos API endpoints
# You can find your public IP address by running `dig +short myip.opendns.com @resolver1.opendns.com`
#
locals {
  external_source_cidrs = [
    {
      name = "Galway office"
      cidr = "193.200.155.153/32"
    },
    {
      name = "Home office - Mark OConnor"
      cidr = "176.61.39.56/32"
    }
  ]
}

# ============================================
# This module creates the Talos cluster in AWS
# ============================================
module aws-demo {
  source = "../../modules/aws-talos"

  cluster_name       = "aws-talos-demo"
  environment        = "development"
  kubernetes_version = "1.36.2"
  talos_version      = "v1.13.9"

  controllers = {
    "aws-demo-controller-1" = { instance_type = "t3.micro" },
  }

  workers = {
    "aws-demo-worker-1" = { instance_type = "t3.small" },
    "aws-demo-worker-2" = { instance_type = "t3.small" }
  }

  # The CIDR blocks for external sources that can access the cluster, used to configure security group rules for the control plane nodes
  external_source_cidrs = local.external_source_cidrs
}

# ===================
# Root module outputs
# ===================

output "controller_public_ips" {
  description = "Public IP addresses of the controller nodes"
  value       = module.aws-demo.controller_public_ips
}

output "worker_public_ips" {
  description = "Public IP addresses of the worker nodes"
  value       = module.aws-demo.worker_public_ips
}