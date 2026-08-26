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

### Create VMs

Optionally create an S3 bucket to act as a state store for OpenTofu

```bash
export AWS_PROFILE=myspotontheweb
export AWS_REGION=eu-west-1
export BUCKET_NAME="aws-talos-demo-849203"

# Create bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region $AWS_REGION --create-bucket-configuration LocationConstraint=$AWS_REGION

# Enable versioning
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Lock down access
aws s3api put-public-access-block --bucket $BUCKET_NAME --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

Run [OpenTofu](https://opentofu.org/)

```bash
tofu -chdir=tofu/environments/aws-demo init
tofu -chdir=tofu/environments/aws-demo plan -out myplan.tfplan
tofu -chdir=tofu/environments/aws-demo apply myplan.tfplan
```

### Configure Kubernetes cluster

```bash
export CLUSTER_NAME=aws-talos-demo
export CONTROL_PLANE_IP=$(tofu -chdir=tofu/environments/aws-demo output -json controller_public_ips | jq '."aws-demo-controller-1"' -r)
export WORKER_IP_1=$(tofu -chdir=tofu/environments/aws-demo output -json worker_public_ips | jq '."aws-demo-worker-1"' -r)
export WORKER_IP_2=$(tofu -chdir=tofu/environments/aws-demo output -json worker_public_ips | jq '."aws-demo-worker-2"' -r)

#
# Generate cluster configuration
#
talosctl gen config $CLUSTER_NAME https://$CONTROL_PLANE_IP:6443

#
# Apply configuration files
#
talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file controlplane.yaml
talosctl apply-config --insecure --nodes $WORKER_IP_1 --file worker.yaml
talosctl apply-config --insecure --nodes $WORKER_IP_2 --file worker.yaml

#
# Bootstrap cluster
#
talosctl --talosconfig=./talosconfig config endpoints $CONTROL_PLANE_IP
talosctl --talosconfig=./talosconfig config node $CONTROL_PLANE_IP

talosctl bootstrap --talosconfig=./talosconfig

#
# Cluser health
#
talosctl --talosconfig=./talosconfig health

#
# Get Kubeconfig file
#
talosctl kubeconfig --talosconfig=./talosconfig .
```

## Cleanup

```bash
tofu -chdir=tofu/environments/aws-demo plan -destroy -out destroy.tfplan
tofu -chdir=tofu/environments/aws-demo apply destroy.tfplan
```