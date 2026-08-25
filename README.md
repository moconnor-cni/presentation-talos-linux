# presentation-talos-linux

This is a presentation page covering [Talos Linux](https://www.siderolabs.com/talos-linux)

## Software

```bash
brew bundle install
```

## Quick Start

Create a powerpoint presentation

```bash
make
```

## Run Demo

Optionally create an S3 bucket to act as a state store for OpenTofu

```bash
export AWS_PROFILE=cis-development-admin
export AWS_REGION=eu-west-1
export BUCKET_NAME="aws-talos-demo-207987"

# Create bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region $AWS_REGION --create-bucket-configuration LocationConstraint=$AWS_REGION

# Enable versioning
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Lock down access
aws s3api put-public-access-block --bucket $BUCKET_NAME --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

Run [OpenTofu](https://opentofu.org/)

```bash
tofu -chdir=environments/aws-demo init
tofu -chdir=environments/aws-demo plan -out myplan.tfplan
tofu -chdir=environments/aws-demo apply myplan.tfplan
```

## Cleanup

```bash
tofu -chdir=environments/aws-demo plan -destroy -out destroy.tfplan
tofu -chdir=environments/aws-demo apply destroy.tfplan
```