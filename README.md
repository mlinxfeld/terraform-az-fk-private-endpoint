# terraform-az-fk-private-endpoint

This repository contains a reusable **Terraform / OpenTofu module** and progressive examples for deploying **Azure Private Endpoints** with optional **Private DNS Zone** integration (via `terraform-az-fk-private-dns`).

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses/azure-fundamentals-terraform-course/)** and is designed as a dedicated **private connectivity layer** for Azure PaaS services.

---

## 🎯 Purpose

The goal of this repository is to provide a **clear, educational, and composable reference implementation**
for **Azure Private Endpoints** using Infrastructure as Code.

It focuses on:

- Private Endpoints as **first-class private connectivity primitives**
- Explicit modeling of:
  - private endpoint NIC placement
- private service connection configuration
- optional Private DNS zone integration (via `terraform-az-fk-private-dns`)
- Clear separation between:
  - **PaaS service resources** (Storage, ACR, Key Vault, etc.)
  - **Private connectivity** (Private Endpoint module)
- Terraform/OpenTofu patterns that reflect **Azure’s real private connectivity model**

This is **not** a landing zone, platform framework, or full network security stack.  
It is a **learning-first building block** designed to integrate cleanly with other FoggyKitchen modules.

---

## ✨ What the module does

Depending on configuration and example used, the module can:

- Create an **Azure Private Endpoint**
- Create a **Private Service Connection**
- Optionally attach a **Private DNS Zone Group**
- Support static or dynamic private IP assignment

The module intentionally does **not** create or manage:

- Virtual Networks or subnets (handled by `terraform-az-fk-vnet`)
- Storage Accounts / ACR / Key Vault / other PaaS services
- Private DNS zones (handled by `terraform-az-fk-private-dns`)
- Network Security Groups or firewall policies

Each of those concerns belongs in its own dedicated module.

---

## 📂 Repository Structure

```bash
terraform-az-fk-private-endpoint/
├── examples/
│   ├── 01_private_blob_with_private_endpoint/
│   ├── 02_private_acr_with_aks_and_private_endpoint/
│   ├── 03_private_files_with_private_endpoint/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

---

## 🚀 Example Usage

### Create a Private Endpoint with Private DNS integration

```hcl
module "private_endpoint" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-private-endpoint.git?ref=v1.0.0"

  name                = "fk-pe-blob"
  location            = "westeurope"
  resource_group_name = "fk-rg"
  subnet_id           = module.vnet.subnet_ids["fk-subnet-private-endpoints"]

  private_connection_resource_id = module.storage.storage_account_id
  subresource_names              = ["blob"]

  private_dns_zone_group_name = "default"
  private_dns_zone_ids        = [module.private_dns.private_dns_zone_ids["privatelink.blob.core.windows.net"]]

  tags = {
    project = "foggykitchen"
    env     = "dev"
  }
}
```

---

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `private_endpoint_id` | ID of the Private Endpoint |
| `private_endpoint_name` | Name of the Private Endpoint |
| `network_interface_ids` | NIC IDs created for the Private Endpoint |
| `private_service_connection_name` | Name of the Private Service Connection |
| `private_dns_zone_group_name` | Name of the Private DNS Zone Group (if configured) |
| `custom_dns_configs` | DNS configs returned by Azure for the endpoint |
| `private_ip_addresses` | Private IPs assigned to the endpoint |

---

## 🧠 Design Philosophy

- Private connectivity must be **explicit**
- DNS should be modeled **as part of the connectivity story**
- One module = one responsibility
- PaaS access should flow through **private endpoints**, not public endpoints
- Avoid “magic” defaults — model the traffic the way Azure actually routes it

This repository intentionally avoids abstractions that hide Private Endpoint mechanics behind “magic” defaults.

---

## 🧩 Related Modules & Training

- [terraform-az-fk-private-dns](https://github.com/foggykitchen/terraform-az-fk-private-dns)  
- [terraform-az-fk-vnet](https://github.com/foggykitchen/terraform-az-fk-vnet)  
- [terraform-az-fk-storage](https://github.com/foggykitchen/terraform-az-fk-storage)  
- [terraform-az-fk-compute](https://github.com/mlinxfeld/terraform-az-fk-compute)  
- [terraform-az-fk-aks](https://github.com/mlinxfeld/terraform-az-fk-aks)  
- [terraform-az-fk-nsg](https://github.com/mlinxfeld/terraform-az-fk-nsg)  

Used across:

- **Azure Fundamentals with Terraform / OpenTofu**
- Private PaaS connectivity baselines
- AKS private image pull patterns
- Storage private access patterns

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](LICENSE) for details.

---

© 2026 FoggyKitchen.com — Cloud. Code. Clarity.
