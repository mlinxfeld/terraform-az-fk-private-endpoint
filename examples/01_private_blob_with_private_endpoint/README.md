# Example 01: Blob Private Endpoint (Private Access + DNS)

## 🚀 Learn the full Azure architecture

This example shows only one piece of the puzzle:  
**private access to Azure Blob Storage using a Private Endpoint.**

In real-world architectures, this pattern is combined with:

- compute layer (VMs, AKS, scaling)
- network design (VNets, subnets, routing)
- access patterns between services
- reusable Terraform/OpenTofu modules

👉 See the full step-by-step architecture: [https://foggykitchen.com/courses/azure-fundamentals-terraform-course/](https://foggykitchen.com/courses/azure-fundamentals-terraform-course/)

This course shows how this pattern fits into a complete, production-ready Azure environment.

--- 

In this storage example, we move from **restricted public access**
to **private connectivity** by introducing a **Private Endpoint for Azure Blob Storage**
using **Terraform / OpenTofu**.

This example focuses on **private network access and DNS resolution**
while still defining **data intent** through Blob Containers.

No compute resources are attached.

---

## 🧭 Architecture Overview

This deployment creates a single **Azure Storage Account**
exposed through a **Private Endpoint** for the Blob service,
with private name resolution handled by **Azure Private DNS**.

Blob Containers are created to represent **intended data usage**
(e.g. artifacts and logs), even though no consumers are attached yet.

<img src="01_private_blob_with_private_endpoint-architecture.png" width="900"/>

This example creates:
- One **Azure Storage Account (StorageV2)** via `terraform-az-fk-storage`
- Two **private Blob Containers** (e.g. `artifacts`, `logs`) via `terraform-az-fk-storage`
- One **Private Endpoint** for the **Blob** subresource via `terraform-az-fk-private-endpoint`
- One **Private DNS Zone** (`privatelink.blob.core.windows.net`)
- A **VNet link** for private DNS resolution
- A **Virtual Network** and **private subnet** via `terraform-az-fk-vnet`
- HTTPS-only access
- Minimum TLS version enforced
- Network Rules with `default_action = Deny`
- No compute resources

This is a **private storage baseline**, not a complete production deployment.

---

## 🎯 Why this example exists

The next logical step for secure storage is to **introduce private connectivity**
and remove the public storage surface from the data path.

Private Endpoints provide:
- private IP-based access to PaaS services,
- traffic that never leaves the Azure backbone,
- native integration with Virtual Networks and DNS.

This example focuses on:
- Understanding how Blob Storage behaves when exposed privately
- Seeing the role of Private DNS Zones in name resolution
- Defining storage **before** workloads exist

Blob Containers are created to define **data intent**, not consumption.

Integration with compute services (VMs, AKS, CI/CD pipelines)
is intentionally out of scope for this example.

---

## 🔐 About Network Rules in this example

Network Rules are enabled to:
- keep the storage account locked down (`default_action = Deny`),
- allow Terraform provisioning from a trusted source,
- preserve a deterministic deployment experience without compute resources.

In fully private environments, data-plane provisioning
would typically run from within the Virtual Network
(e.g. via a private runner).

Important:
- set `my_public_ip` in `terraform.tfvars` before running `tofu apply`
- if `my_public_ip` is empty or stale, `tofu destroy` can fail with 403
  because Terraform cannot read/delete blob containers through the data plane

---

## 🚀 Deployment Steps

From the `examples/01_private_blob_with_private_endpoint` directory:

```bash
tofu init
tofu plan
tofu apply
```

---

## 🖼️ Azure Portal View

<img src="01_private_blob_with_private_endpoint-portal-overview.png" width="900"/>

*Figure 1. Private Endpoint DNS configuration: private IP address, FQDN,
and Private DNS zone association.*

---

## 🧹 Cleanup

```bash
tofu destroy
```

---

## 🛠️ Troubleshooting

- **403 on `tofu destroy` (storage containers):**  
  Make sure `my_public_ip` in `terraform.tfvars` is your **current** public IP.
  If the IP changed, storage network rules will block Terraform from reading/deleting containers.

- **Slow deletion of Private DNS VNet link:**  
  `azurerm_private_dns_zone_virtual_network_link` can take several minutes to delete.
  This is normal in Azure; if it hangs for >10 minutes, retry `tofu destroy`.

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
