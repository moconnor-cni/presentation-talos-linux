############################################
# Create VMs
############################################

resource "aws_instance" "controllers" {
  for_each      = var.controllers
  ami           = data.aws_ami.talos.id
  instance_type = each.value.instance_type

  subnet_id              = module.vpc.public_subnets[index(keys(var.controllers), each.key) % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [aws_security_group.talos_nodes.id, aws_security_group.talos_controllers.id]
  #iam_instance_profile   = aws_iam_instance_profile.controller_profile.name
  associate_public_ip_address = true

  # Pass the generated controlplane configuration as compressed user-data (Talos Linux has a custom cloud-init that can read this format)
  #user_data_base64 = base64gzip(data.talos_machine_configuration.controlplane.machine_configuration)

  tags = {
    Name = each.key
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_instance" "workers" {
  for_each      = var.workers
  ami           = data.aws_ami.talos.id
  instance_type = each.value.instance_type

  subnet_id              = module.vpc.public_subnets[index(keys(var.workers), each.key) % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [aws_security_group.talos_nodes.id]
  #iam_instance_profile   = aws_iam_instance_profile.worker_profile.name
  associate_public_ip_address = true

  # Pass the generated worker configuration as user-data
  #user_data = data.talos_machine_configuration.worker.machine_configuration

  tags = {
    Name = each.key
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}