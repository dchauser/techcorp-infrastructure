# Installation Guide — Windows

This guide walks you through installing Terraform and Ansible on Windows for the TechCorp Infrastructure lab.

## Prerequisites

- Windows 10/11 (64-bit)
- Administrator access
- Internet connection

## Option A: Using WSL2 (Recommended)

Windows Subsystem for Linux gives you a native Linux environment — the best experience for Terraform and Ansible.

### Step 1: Install WSL2

Open PowerShell as Administrator:
```powershell
wsl --install
```

Restart your computer when prompted. Ubuntu will be installed by default.

### Step 2: Set Up Ubuntu

After restart, open "Ubuntu" from the Start menu. Create a username and password when prompted.

### Step 3: Install Tools in WSL2

```bash
# Update packages
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install -y software-properties-common curl unzip git python3 python3-pip

# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

# Install Ansible
sudo apt install -y ansible

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Install Infoblox Ansible collection
ansible-galaxy collection install infoblox.universal_ddi
```

### Step 4: Verify

```bash
terraform version
ansible --version
aws --version
git --version
```

### Step 5: Configure Environment Variables

Add to `~/.bashrc`:
```bash
# AWS Credentials
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Infoblox Universal DDI
export BLOXONE_API_KEY="your-api-key"
export BLOXONE_CSP_URL="https://csp.infoblox.com"
```

Reload:
```bash
source ~/.bashrc
```

---

## Option B: Native Windows (Without WSL)

> **Note:** Ansible does not natively support Windows as a control node. If you choose this path, you'll use Terraform natively and Ansible via a Docker container or Python virtual environment.

### Step 1: Install Chocolatey Package Manager

Open PowerShell as Administrator:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Step 2: Install Terraform

```powershell
choco install terraform -y
```

Verify:
```powershell
terraform version
```

### Step 3: Install Git

```powershell
choco install git -y
```

### Step 4: Install AWS CLI

```powershell
choco install awscli -y
```

### Step 5: Install Python and Ansible

```powershell
choco install python3 -y

# After installation, open a new PowerShell window
pip install ansible
ansible-galaxy collection install infoblox.universal_ddi
```

### Step 6: Set Environment Variables

Open System Properties > Environment Variables, or use PowerShell:

```powershell
[System.Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID", "your-access-key", "User")
[System.Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", "your-secret-key", "User")
[System.Environment]::SetEnvironmentVariable("AWS_DEFAULT_REGION", "us-east-1", "User")
[System.Environment]::SetEnvironmentVariable("BLOXONE_API_KEY", "your-api-key", "User")
[System.Environment]::SetEnvironmentVariable("BLOXONE_CSP_URL", "https://csp.infoblox.com", "User")
```

> **Security Note:** Never commit credentials to Git. Use environment variables.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| WSL2 install fails | Enable "Virtual Machine Platform" in Windows Features |
| `terraform` not recognized | Close and reopen terminal, or add to PATH manually |
| Ansible import errors on Windows | Use WSL2 instead (Option A) — Ansible works best on Linux |
| Python PATH issues | Reinstall Python with "Add to PATH" checked |
| Git SSL errors behind proxy | `git config --global http.sslVerify false` (temporary) |

## Optional: VS Code with WSL2

```powershell
choco install vscode -y
```

Then install the "WSL" extension in VS Code to edit files directly in your WSL2 environment.
