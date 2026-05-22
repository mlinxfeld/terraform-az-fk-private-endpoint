# Azure Private Endpoint with Terraform / OpenTofu — Examples

This directory contains **hands-on Azure Private Endpoint examples** built around the
`terraform-az-fk-private-endpoint` module.

The examples are designed as **progressive building blocks** that introduce how
Azure **Private Endpoints** work for **Storage (Blob / Files)** and **ACR**
in private network‑first architectures.

These examples deliberately focus on **private connectivity patterns** and avoid
enterprise landing zones or platform abstractions.

They are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are used across:

- Azure Fundamentals with Terraform / OpenTofu  
- Azure Networking & Security design notes  
- Private PaaS connectivity patterns  
- AKS private image pull scenarios  
- Multicloud (Azure + OCI) architectural training  

---

## 🧭 Example Overview

| Example | Title | Key Topics |
|--------|-------|------------|
| 01 | **Private Blob with Private Endpoint** | Blob private endpoint + Private DNS module, locked down storage |
| 02 | **Private ACR with AKS and Private Endpoint** | AKS pulls images from ACR via private endpoint + Private DNS module |
| 03 | **Private Azure Files with Private Endpoint** | SMB access to Azure Files from private VMs via private endpoint + Private DNS module |

Each example introduces **one clear private connectivity concept** and can be applied
**independently** for learning, experimentation, or reuse.

---

## ⚙️ How to Use

Each example directory contains:

- Terraform / OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the architectural goal
- Architecture diagrams and Azure Portal verification screenshots
- A **fully runnable deployment** (no placeholders, no mock resources)

To run an example:

```bash
cd examples/01_private_blob_with_private_endpoint
tofu init
tofu plan
tofu apply
```

Examples may be deployed independently, but the **recommended learning path** is:

```
01 → 02 → 03
```

This mirrors real‑world Azure design:

- Start with private blob access and DNS  
- Extend to private ACR for AKS image pulls  
- Add private Azure Files access from VMs  

---

## 🧩 Design Principles

These examples follow strict design rules:

- One example = one architectural concept  
- Explicit modeling of:
- private endpoint placement in dedicated subnets  
  - private DNS zones and VNet links (via `terraform-az-fk-private-dns`)  
  - PaaS services accessed **only** via private endpoints  
- Clear separation of concerns:
  - networking (VNet, subnet)  
  - private connectivity (Private Endpoint module)  
  - data services (Storage / ACR)  
  - compute (VM / AKS), where applicable  
- No hidden magic or implicit routing  
- All traffic paths are visible in Terraform  

The examples intentionally avoid:

- Public endpoints for data paths  
- Platform landing zones  
- Over‑abstracted “platform” modules  
- Kubernetes abstractions beyond AKS basics  

The goal is **clarity and correctness**, not completeness.

---

## 🔗 Related Modules & Training

- [terraform-az-fk-private-endpoint](https://github.com/mlinxfeld/terraform-az-fk-private-endpoint) (this repository)  
- [terraform-az-fk-private-dns](https://github.com/mlinxfeld/terraform-az-fk-private-dns)  
- [terraform-az-fk-vnet](https://github.com/foggykitchen/terraform-az-fk-vnet)  
- [terraform-az-fk-storage](https://github.com/foggykitchen/terraform-az-fk-storage)  
- [terraform-az-fk-compute](https://github.com/foggykitchen/terraform-az-fk-compute)  
- [terraform-az-fk-aks](https://github.com/mlinxfeld/terraform-az-fk-aks)  
- [terraform-az-fk-nsg](https://github.com/mlinxfeld/terraform-az-fk-nsg)  

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See `LICENSE` for details.

---

© 2026 FoggyKitchen.com — Cloud. Code. Clarity.
