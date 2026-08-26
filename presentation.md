---
marp: true
theme: gaia
header: ![](assets/centripetal_logo.png)
---

# Talos Linux

The easy and secure way to run Kubernetes

Mark O’Connor
Principal DevOps Engineer
Centripetal

---
## What is Talos?

* A Linux based OS that has been stripped down to the bare minimum components. Just enough OS to run Kubernetes.
* Very popular for bare metal scenarios (running on servers in a data center)
* Easy to operate, but requires a new way of thinking about Linux admin

---
## What Sidero says

[www.siderolabs.com](https://www.siderolabs.com/talos-linux)

* No SSH, No Shell, No package manager
* Immutable read-only file systen
* Reduced attack surface < 50 binaries

---

## How to create a Kubernetes cluster

Create 3 VMs on AWS

```bash
tofu plan -out myplan.tfplan
tofu apply myplan.tfplan
```

Generate some configuration files

```bash
$ talosctl gen config $CLUSTER_NAME https://$CONTROL_PLANE_IP:6443
generating PKI and tokens
Created controlplane.yaml
Created worker.yaml
Created talosconfig
```

---
Apply configuration files to Kubernetes nodes

```bash
talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file controlplane.yaml
talosctl apply-config --insecure --nodes $WORKER_IP_1 --file worker.yaml
talosctl apply-config --insecure --nodes $WORKER_IP_2 --file worker.yaml
```

Bootstap the etcd

```bash
talosctl --talosconfig=./talosconfig bootstrap
```

---

Retrieve a kubeconfig file

```bash
talosctl --talosconfig=./talosconfig kubeconfig .
```

Run a Kubernetes command to check the cluster nodes

```bash
kubectl --kubeconfig=kubeconfig get nodes
```