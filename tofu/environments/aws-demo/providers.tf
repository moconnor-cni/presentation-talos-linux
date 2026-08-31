terraform {

  required_version = "~> 1.12.5"

  backend "s3" {
    bucket       = "aws-talos-demo-283394"
    key          = "opentofu/terraform.tfstate"
    region       = "eu-west-1" 

    # This profile should be configured in your AWS CLI config file
    profile = "myspotontheweb"

    # Enable native S3 locking
    use_lockfile = true

    # Enable Server-Side Encryption
    encrypt = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.61.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  profile = "myspotontheweb"
}