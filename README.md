# TechCorp Infrastructure

Production-ready infrastructure automation using **Terraform**, **Ansible**, and **Infoblox Universal DDI**.

This repository demonstrates enterprise CI/CD pipelines that provision AWS infrastructure AND integrate with Infoblox Universal DDI for IP management and DNS — the way real DevOps teams do it.

## Scenario: TechCorp Digital Transformation

TechCorp is a manufacturing company undergoing digital transformation:

1. **Greenfield:** Deploying a new cloud-native inventory management application on AWS
2. **Hybrid Cloud:** Migrating legacy on-prem DNS/IPAM to Universal DDI

Your job: Build a production-ready CI/CD pipeline that provisions AWS infrastructure AND integrates with Infoblox Universal DDI for IP management and DNS.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    ORCHESTRATION LAYER                       │
│              (GitHub Actions / CI/CD Pipeline)               │
└─────────────────────────────────────────────────────────────┘
         │                                    │
         ▼                                    ▼
┌─────────────────────┐          ┌─────────────────────┐
│     TERRAFORM       │          │      ANSIBLE        │
│   (Day-0 / Day-1)   │          │      (Day-2)        │
│                     │          │                     │
│ • IP Spaces         │          │ • Bulk DNS records  │
│ • Address Blocks    │          │ • IPAM allocations  │
│ • DNS Views/Zones   │          │ • Legacy migration  │
│ • AWS VPC/Subnets   │          │ • Remediation       │
└─────────────────────┘          └─────────────────────┘
         │                                    │
         └────────────────┬───────────────────┘
                          ▼
              ┌─────────────────────┐
              │  INFOBLOX UNIVERSAL │
              │        DDI          │
              │   (API-First)       │
              └─────────────────────┘
```

## Quick Start

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) >= 2.14
- AWS CLI configured with credentials
- Infoblox Universal DDI API key

> See [docs/INSTALL-MAC.md](docs/INSTALL-MAC.md) or [docs/INSTALL-WINDOWS.md](docs/INSTALL-WINDOWS.md) for detailed installation instructions.

### 1. Clone the Repository

```bash
git clone <repo-url>
cd techcorp-infrastructure
```

### 2. Set Environment Variables

```bash
# AWS Credentials
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Infoblox Universal DDI
export BLOXONE_API_KEY="your-api-key"
export BLOXONE_CSP_URL="https://csp.infoblox.com"
```

### 3. Deploy with Terraform

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### 4. Run Ansible Day-2 Operations

```bash
# Install the Infoblox Ansible collection
ansible-galaxy collection install infoblox.universal_ddi

# Create application DNS records
ansible-playbook ansible/playbooks/dns-records.yml \
  -e "zone_id=<your-zone-id>"

# Allocate IPs for new instances
ansible-playbook ansible/playbooks/ipam-allocate.yml \
  -e "app_subnet_id=<your-subnet-id>" \
  -e "ip_space_id=<your-ip-space-id>"
```

## Repository Structure

```
techcorp-infrastructure/
├── .github/workflows/
│   ├── terraform-plan.yml          # PR triggers plan
│   ├── terraform-apply.yml         # Merge triggers apply
│   └── full-stack-deploy.yml       # AWS + DDI orchestrated
├── terraform/
│   ├── environments/
│   │   ├── dev/                    # Dev environment config
│   │   └── prod/                   # Prod environment config
│   └── modules/
│       ├── aws-networking/         # VPC, Subnets, IGW, RT
│       ├── infoblox-ipam/          # IP Spaces, Address Blocks, Subnets
│       └── infoblox-dns/           # Views, Zones, Records
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/hosts.yml
│   ├── group_vars/all.yml
│   └── playbooks/
│       ├── dns-records.yml         # Day-2 DNS operations
│       ├── ipam-allocate.yml       # Next-available IP allocation
│       ├── migrate-legacy.yml      # Legacy record migration
│       ├── cleanup-orphans.yml     # Remove unmanaged records
│       └── validate-deployment.yml # End-to-end validation
└── docs/
    ├── INSTALL-MAC.md
    ├── INSTALL-WINDOWS.md
    └── TROUBLESHOOTING.md
```

## When to Use What

| Tool | Role | Use For |
|------|------|---------|
| **Terraform** | Day-0/Day-1 Builder | Infrastructure provisioning, state-tracked resources |
| **Ansible** | Day-2 Operations | Bulk changes, migrations, remediation (stateless) |
| **CI/CD Pipeline** | Orchestrator | Coordinating Terraform + Ansible + validation |
| **Cloud Discovery** | Observer | Discovering what actually exists (read-only) |

## CI/CD Pipeline

The `full-stack-deploy.yml` workflow orchestrates the entire deployment:

1. **Terraform** provisions AWS infrastructure + registers in Infoblox IPAM + creates DNS zones
2. **Ansible DNS** creates application DNS records (runs in parallel with IPAM)
3. **Ansible IPAM** allocates IPs for new instances (runs in parallel with DNS)
4. **Validation** verifies the entire stack end-to-end
5. **Summary** posts deployment results

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `BLOXONE_API_KEY` | Infoblox Universal DDI API key |
| `BLOXONE_CSP_URL` | Infoblox CSP portal URL |

## Troubleshooting

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for common issues and solutions.

## License

Internal use only — Infoblox Sales Engineering.
