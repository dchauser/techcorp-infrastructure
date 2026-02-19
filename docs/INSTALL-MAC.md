# Installation Guide — macOS

This guide walks you through installing Terraform and Ansible on macOS for the TechCorp Infrastructure lab.

## Prerequisites

- macOS 12 (Monterey) or later
- Administrator access
- Internet connection

## Step 1: Install Homebrew (if not already installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Verify:
```bash
brew --version
```

## Step 2: Install Terraform

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Verify:
```bash
terraform version
# Expected: Terraform v1.5.0 or later
```

## Step 3: Install Ansible

```bash
brew install ansible
```

Verify:
```bash
ansible --version
# Expected: ansible [core 2.14+]
```

## Step 4: Install AWS CLI

```bash
brew install awscli
```

Verify:
```bash
aws --version
```

## Step 5: Install the Infoblox Ansible Collection

```bash
ansible-galaxy collection install infoblox.universal_ddi
```

## Step 6: Install Git (if not already installed)

macOS includes Git by default. Verify:
```bash
git --version
```

If not installed, Xcode Command Line Tools will prompt you to install it. Alternatively:
```bash
brew install git
```

## Step 7: Configure Environment Variables

Add these to your `~/.zshrc` (or `~/.bash_profile` if using bash):

```bash
# AWS Credentials
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Infoblox Universal DDI
export BLOXONE_API_KEY="your-api-key"
export BLOXONE_CSP_URL="https://csp.infoblox.com"
```

Then reload:
```bash
source ~/.zshrc
```

> **Security Note:** Never commit credentials to Git. Use environment variables or a secrets manager.

## Step 8: Verify Everything Works

```bash
# Clone the repo
git clone <repo-url>
cd techcorp-infrastructure

# Test Terraform
cd terraform/environments/dev
terraform init
terraform validate

# Test Ansible
cd ../../../
ansible --version
ansible-galaxy collection list | grep infoblox
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `brew: command not found` | Reinstall Homebrew (Step 1) |
| `terraform: command not found` | Run `brew link hashicorp/tap/terraform` |
| `ansible: command not found` | Run `brew link ansible` or check PATH |
| Python version conflicts | Use `brew install python@3.11` and update PATH |
| Permission denied on `/usr/local` | Run `sudo chown -R $(whoami) /usr/local` |

## Optional: VS Code Extensions

If using Visual Studio Code:

```bash
brew install --cask visual-studio-code

# Install useful extensions
code --install-extension hashicorp.terraform
code --install-extension redhat.ansible
code --install-extension ms-python.python
```
