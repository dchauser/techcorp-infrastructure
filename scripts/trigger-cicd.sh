#!/bin/bash
# ============================================
# TechCorp CI/CD Pipeline Launcher
# ============================================
# This script automates the entire CI/CD setup:
# 1. Forks the repo to your GitHub account
# 2. Enables GitHub Actions on the fork
# 3. Configures all 5 secrets automatically
# 4. Triggers the Full-Stack Deploy pipeline
# ============================================

set -e

echo "============================================"
echo "  TechCorp CI/CD Pipeline Launcher"
echo "============================================"
echo ""

# Check gh is authenticated
if ! gh auth status &>/dev/null; then
    echo "ERROR: Not logged in to GitHub CLI."
    echo "Run: gh auth login"
    exit 1
fi

GH_USER=$(gh api user -q .login)
echo "Logged in as: $GH_USER"
echo ""

# Step 1: Fork
echo "=== Step 1: Forking repository ==="
REPO="$GH_USER/techcorp-infrastructure"

if gh repo view "$REPO" &>/dev/null; then
    echo "Fork already exists: https://github.com/$REPO"
else
    echo "Creating fork..."
    gh repo fork iracic82/techcorp-infrastructure --clone=false
    echo "Fork created: https://github.com/$REPO"
fi

# Wait for GitHub to fully initialize the fork
echo "Waiting for fork to initialize..."
for i in $(seq 1 12); do
    if gh api "repos/$REPO" &>/dev/null; then
        echo "  Fork ready!"
        break
    fi
    echo "  Waiting... ($i/12)"
    sleep 5
done

# Step 2: Enable GitHub Actions (disabled by default on forks)
echo ""
echo "=== Step 2: Enabling GitHub Actions ==="
if gh api -X PUT "repos/$REPO/actions/permissions" \
    -f enabled=true -f allowed_actions=all &>/dev/null; then
    echo "  Actions enabled ✓"
else
    echo "  WARNING: Could not enable Actions via API."
    echo "  Go to https://github.com/$REPO/actions and enable them manually."
fi

# Step 3: Set secrets
echo ""
echo "=== Step 3: Configuring secrets ==="

BUCKET_NAME=$(grep bucket /root/lab/techcorp-infrastructure/terraform/environments/dev/backend.tf | awk -F'"' '{print $2}')
if [ -z "$BUCKET_NAME" ]; then
    echo "ERROR: Could not extract S3 bucket name from backend.tf"
    exit 1
fi

echo "Setting AWS_ACCESS_KEY_ID..."
gh secret set AWS_ACCESS_KEY_ID -b "$AWS_ACCESS_KEY_ID" -R "$REPO"
echo "  AWS_ACCESS_KEY_ID       ✓"

echo "Setting AWS_SECRET_ACCESS_KEY..."
gh secret set AWS_SECRET_ACCESS_KEY -b "$AWS_SECRET_ACCESS_KEY" -R "$REPO"
echo "  AWS_SECRET_ACCESS_KEY   ✓"

echo "Setting BLOXONE_API_KEY..."
gh secret set BLOXONE_API_KEY -b "$BLOXONE_API_KEY" -R "$REPO"
echo "  BLOXONE_API_KEY         ✓"

echo "Setting BLOXONE_CSP_URL..."
gh secret set BLOXONE_CSP_URL -b "https://csp.infoblox.com" -R "$REPO"
echo "  BLOXONE_CSP_URL         ✓"

echo "Setting S3_BUCKET_NAME..."
gh secret set S3_BUCKET_NAME -b "$BUCKET_NAME" -R "$REPO"
echo "  S3_BUCKET_NAME          ✓"

echo ""
echo "All 5 secrets configured!"

# Step 4: Trigger workflow
echo ""
echo "=== Step 4: Triggering Full-Stack Pipeline ==="

# Wait a moment for Actions to be fully enabled before triggering
sleep 3

if gh workflow run full-stack-deploy.yml -R "$REPO" -f environment=dev; then
    echo ""
    echo "============================================"
    echo "  Pipeline triggered!"
    echo "============================================"
else
    echo ""
    echo "ERROR: Could not trigger the workflow."
    echo "Try manually: Go to https://github.com/$REPO/actions"
    echo "  → Select 'TechCorp Full-Stack Application Deployment'"
    echo "  → Click 'Run workflow' → Select 'dev' → Click 'Run workflow'"
    exit 1
fi

echo ""
echo "Watch it live:"
echo "  https://github.com/$REPO/actions"
echo ""
echo "The pipeline will:"
echo "  Stage 1: Terraform  → AWS + IPAM + DNS"
echo "  Stage 2: Ansible    → DNS records + IP allocation (parallel)"
echo "  Stage 3: Validate   → End-to-end verification"
echo "  Stage 4: Summary    → Deployment report"
echo ""
echo "Open the GitHub Repository tab to watch!"
echo "============================================"
