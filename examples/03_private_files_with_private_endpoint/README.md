# Example 03: Private Azure Files with Private Endpoint

## 🚀 Learn the full Azure architecture

This example is part of a larger, production-ready setup using reusable Terraform/OpenTofu modules.

👉 See the full step-by-step architecture: [https://foggykitchen.com/courses/azure-fundamentals-terraform-course/](https://foggykitchen.com/courses/azure-fundamentals-terraform-course/)

Includes:
- compute layer (VMs, scaling)
- network design (VNet, subnets, routing)
- private connectivity patterns
- real-world architecture walkthroughs

This example deploys **two private VMs** that mount **Azure Files (SMB)**
through a **Private Endpoint**. The storage account is kept private, and
name resolution is handled by **Private DNS**.

This is the first example in the private‑endpoint series that **demonstrates
real workload access** (VMs mounting a file share), not just infrastructure wiring.

---

## 🧭 Architecture Overview

This deployment creates:
- A **Virtual Network** with two subnets via `terraform-az-fk-vnet`
  - `fk-subnet-private-vm` for VMs
  - `fk-subnet-private-endpoints` for Private Endpoints
- Two **Linux VMs** via `terraform-az-fk-compute`
- A **Storage Account (StorageV2)** with **Azure Files** via `terraform-az-fk-storage`
- A **Private Endpoint** for the `file` subresource via `terraform-az-fk-private-endpoint`
- A **Private DNS Zone** (`privatelink.file.core.windows.net`) and VNet link

The VMs mount the file share using **SMB over the private endpoint**.

<img src="03_private_files_with_private_endpoint_architecture.png" width="900"/>

*Figure 1. Azure Files accessed from private VMs via a Private Endpoint and Private DNS.*

---

## 🔐 Private DNS Flow (Azure Files)

Private DNS ensures the storage FQDN resolves to the **private IP** of the endpoint:

```
<storage-account>.file.core.windows.net
  → privatelink.file.core.windows.net
  → private endpoint IP in fk-subnet-private-endpoints
```

---

## 🚀 Deployment Steps

From the `examples/03_private_files_with_private_endpoint` directory:

```bash
tofu init
tofu plan
tofu apply
```

---

## ✅ Verification (SMB over Private Endpoint)

This example uses cloud‑init on each VM to mount the file share to:

```
/mnt/azurefiles
```

You can verify from any VM (Run Command or SSH):

```bash
ls -la /mnt/azurefiles/
```

Expected:
- You see files created by multiple VMs (shared SMB mount).

---

## 🖼️ Azure Portal View

<img src="03_private_files_with_private_endpoint_portal_dns.png" width="900"/>

*Figure 2. Private DNS configuration for Azure Files (privatelink.file.core.windows.net).*

<img src="03_private_files_with_private_endpoint_portal_vm_mount.png" width="900"/>

*Figure 3. SMB mount validation on VM (files visible from multiple VMs).*

---

## 📤 Outputs

```bash
tofu output
```

- `private_endpoint_private_ip` — private IP assigned to the Files private endpoint
- `vm_private_ips` — list of VM private IPs

---

## ⚠️ Network Rules Note

This example enables Storage **network rules** with `default_action = Deny`.
Make sure `my_public_ip` in `terraform.tfvars` is your **current** public IP.
Otherwise, Terraform may fail to read/destroy the file share (403).

---

## 🧹 Cleanup

```bash
tofu destroy
```

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
