variable "cluster_name" {
  type        = string
  description = "Name of the Talos cluster"
}

variable "environment" {
  type        = string
  description = "Environment name"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "The environment must be one of: development, staging, production."
  }
}

variable "talos_version" {
  type        = string
  description = "Talos version string (e.g., v1.13.9)"

  validation {
    condition     = can(regex("^v\\d+\\.\\d+\\.\\d+$", var.talos_version))
    error_message = "The talos_version must follow the format 'vX.Y.Z' (e.g., v1.13.9)."
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes cluster version (e.g., 1.36.2)"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+$", var.kubernetes_version))
    error_message = "The kubernetes_version must follow the format 'X.Y.Z' without a leading 'v' (e.g., 1.36.2)."
  }
}

variable "controllers" {
  type = map(object({
    instance_type = string
  }))
}

variable "workers" {
  type = map(object({
    instance_type = string
  }))
}

variable "external_source_cidrs" {
  type = list(object({
    name = string
    cidr = string
  }))
  description = "List of CIDR blocks for external sources that can access the cluster"
}
