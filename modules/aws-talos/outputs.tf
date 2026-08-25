############################################
# Outputs
############################################

output "controller_public_ips" {
  description = "Public IP addresses of the controller nodes"
  value       = { for k, instance in aws_instance.controllers : k => instance.public_ip }
}

output "worker_public_ips" {
  description = "Public IP addresses of the worker nodes"
  value       = { for k, instance in aws_instance.workers : k => instance.public_ip }
}