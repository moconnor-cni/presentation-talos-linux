###########################################
# Select region
###########################################
data "aws_region" "current" {}

###########################################
# Select ami the image
#
# aws ec2 describe-images --region eu-west-1 --filters "Name=name,Values=talos-v1.13.2-eu-west-1-amd64" --owner=540036508848 --query 'Images[0].ImageId'
############################################

data "aws_ami" "talos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["talos-${var.talos_version}-${data.aws_region.current.region}-amd64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["540036508848"] # Siderolabs
}