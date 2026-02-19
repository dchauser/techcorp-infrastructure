# Troubleshooting Guide

Common issues and solutions for the TechCorp Infrastructure lab.

## Terraform Issues

### "Error: No valid credential sources found"

**Problem:** AWS credentials not configured.

**Solution:**
```bash
# Set environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"

# Or configure AWS CLI
aws configure
```

### "Error: Failed to get existing workspaces"

**Problem:** S3 backend bucket doesn't exist or you don't have access.

**Solution:**
```bash
# For the lab, you may need to use local backend temporarily
# Comment out the backend block in backend.tf and run:
terraform init
```

### "Error: error configuring BloxOne provider"

**Problem:** Infoblox API credentials not set.

**Solution:**
```bash
export BLOXONE_API_KEY="your-api-key"
export BLOXONE_CSP_URL="https://csp.infoblox.com"
```

### "Error: Resource already exists"

**Problem:** Resource was created outside of Terraform (manual UI creation).

**Solution:**
```bash
# Import the existing resource into Terraform state
terraform import <resource_type>.<name> <resource_id>

# Or remove the manually-created resource from the UI and re-run
terraform apply
```

### "Error: state lock"

**Problem:** Another Terraform process has the state locked, or a previous run crashed.

**Solution:**
```bash
# Force unlock (use with caution — make sure no one else is running)
terraform force-unlock <lock-id>
```

### Terraform plan shows unexpected drift

**Problem:** Someone modified resources manually via the UI.

**Solution:**
```bash
# Review the drift
terraform plan

# Accept and fix the drift
terraform apply
```

## Ansible Issues

### "ERROR! couldn't resolve module/action 'infoblox.universal_ddi.dns_record'"

**Problem:** Infoblox Ansible collection not installed.

**Solution:**
```bash
ansible-galaxy collection install infoblox.universal_ddi
```

### "Failed to connect to CSP" or "401 Unauthorized"

**Problem:** API credentials are wrong or expired.

**Solution:**
```bash
# Verify your credentials
echo $BLOXONE_API_KEY
echo $BLOXONE_CSP_URL

# Test with curl
curl -s -H "Authorization: Token $BLOXONE_API_KEY" \
  "$BLOXONE_CSP_URL/api/ddi/v1/ipam/ip_space"
```

### "The task includes an option with an undefined variable"

**Problem:** Required variables not passed to the playbook.

**Solution:**
```bash
# Pass required variables with -e
ansible-playbook ansible/playbooks/dns-records.yml \
  -e "zone_id=your-zone-id"
```

### Playbook hangs or times out

**Problem:** Network connectivity to the Infoblox CSP API.

**Solution:**
```bash
# Test connectivity
curl -v "$BLOXONE_CSP_URL/api/ddi/v1/dns/auth_zone"

# Check if behind a proxy
echo $http_proxy
echo $https_proxy
```

## Git Issues

### "Permission denied (publickey)"

**Problem:** SSH key not configured for GitHub.

**Solution:**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your-email@example.com"

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key and add to GitHub Settings > SSH Keys
cat ~/.ssh/id_ed25519.pub
```

### "fatal: repository not found"

**Problem:** Wrong repo URL or no access.

**Solution:**
```bash
# Use HTTPS instead of SSH
git clone https://github.com/<org>/techcorp-infrastructure.git
```

## CI/CD Pipeline Issues

### GitHub Actions workflow not triggering

**Problem:** Workflow file not in the default branch or path filters don't match.

**Solution:**
- Ensure workflow files are in `.github/workflows/` on the `main` branch
- Check that your changes match the `paths` filter in the workflow
- Use `workflow_dispatch` to trigger manually

### "Error: Secrets not available"

**Problem:** GitHub Secrets not configured for the repository.

**Solution:**
1. Go to Repository Settings > Secrets and variables > Actions
2. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `BLOXONE_API_KEY`
   - `BLOXONE_CSP_URL`

### Pipeline succeeds but resources not created

**Problem:** The `if` condition prevents apply on PRs (by design).

**Solution:**
- Terraform Apply only runs on merge to `main`, not on PRs
- PRs only trigger `terraform plan` for review
- Merge the PR to trigger the full apply

## Environment-Specific Issues

### Instruqt Sandbox

| Issue | Solution |
|-------|----------|
| Terminal unresponsive | Refresh the browser tab |
| VS Code not loading | Wait 30 seconds, then refresh |
| Environment variables reset | Re-run the setup script or source the env file |
| Terraform state corrupted | Delete `.terraform/` directory and re-run `terraform init` |

### Local Development

| Issue | Solution |
|-------|----------|
| Multiple Terraform versions | Use `tfenv` to manage versions |
| Python version conflicts | Use `pyenv` or virtual environments |
| Ansible version mismatch | Use `pipx install ansible` for isolation |

## Getting Help

1. Check this troubleshooting guide
2. Review the error message carefully — it usually tells you what's wrong
3. Ask the instructor or TA
4. Check the [Infoblox Universal DDI documentation](https://docs.infoblox.com/)
5. Check the [Terraform BloxOne Provider documentation](https://registry.terraform.io/providers/infobloxopen/bloxone/latest/docs)
