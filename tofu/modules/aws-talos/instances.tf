############################################
# Create VMs
############################################

resource "aws_instance" "controllers" {
  for_each      = var.controllers
  ami           = data.aws_ami.talos.id
  instance_type = each.value.instance_type

  subnet_id              = module.vpc.public_subnets[index(keys(var.controllers), each.key) % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [aws_security_group.talos_nodes.id, aws_security_group.talos_controllers.id]
  associate_public_ip_address = true

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
  associate_public_ip_address = true

  tags = {
    Name = each.key
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}