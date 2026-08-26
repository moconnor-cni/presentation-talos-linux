############################################
# VPC network
############################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.0"
  name    = "${var.cluster_name}-${var.environment}-network"
  cidr    = "10.0.0.0/16"

  # 3 AZs for true control plane high-availability 
  #azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  #public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  azs             = ["eu-west-1a"]
  public_subnets  = ["10.0.1.0/24"]

  # Add these lines to give your private instances internet egress route tables
  #enable_nat_gateway = true
  #single_nat_gateway = true # Keeps costs down for small/demo environments

  tags = {
    Project     = var.cluster_name
    Environment = var.environment
  }

  vpc_tags = {
    Project     = var.cluster_name
    Environment = var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  default_security_group_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  igw_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  nat_gateway_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

######################################################
# Security groups for Talos controllers and workers
######################################################

# Common Security Group (All Nodes)
resource "aws_security_group" "talos_nodes" {
  name        = "talos-nodes-sg"
  description = "Shared security group for all Talos nodes"
  vpc_id      = module.vpc.vpc_id

  # Internal Node-to-Node communication
  ingress {
    description = "Allow all traffic between cluster nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Talos API Access (Port 50000)
  ingress {
    description = "Talos API endpoint"
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = [for entry in var.external_source_cidrs : entry.cidr]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==========================================
# Controller Security Group
# ==========================================
resource "aws_security_group" "talos_controllers" {
  name        = "talos-controllers-sg"
  description = "Security group specific to Talos controller nodes"
  vpc_id      = module.vpc.vpc_id

  # Kubernetes API Access (Port 6443)
  ingress {
    description = "Kubernetes API server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [for entry in var.external_source_cidrs : entry.cidr]
  }
}