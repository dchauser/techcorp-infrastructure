#!/bin/bash
# ============================================
# TechCorp CI/CD Pipeline Launcher
# ============================================
# This script automates the entire CI/CD setup:
# 1. Forks the repo to your GitHub account
# 2. Configures all 5 secrets automatically
# 3. Triggers the Full-Stack Deploy pipeline
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
gh repo fork iracic82/techcorp-infrastructure --clone=false 2>/dev/null || echo "Fork already exists"
REPO="$GH_USER/techcorp-infrastructure"
echo "Fork: https://github.com/$REPO"
sleep 5

# Step 2: Set secrets
echo ""
echo "=== Step 2: Configuring secrets ==="

BUCKET_NAME=$(grep bucket /root/lab/techcorp-infrastructure/terraform/environments/dev/backend.tf | awk -F'"' '{print $2}')

gh secret set AWS_ACCESS_KEY_ID -b "$AWS_ACCESS_KEY_ID" -R "$REPO"
echo "  AWS_ACCESS_KEY_ID       ✓"

gh secret set AWS_SECRET_ACCESS_KEY -b "$AWS_SECRET_ACCESS_KEY" -R "$REPO"
echo "  AWS_SECRET_ACCESS_KEY   ✓"

gh secret set BLOXONE_API_KEY -b "$BLOXONE_API_KEY" -R "$REPO"
echo "  BLOXONE_API_KEY         ✓"

gh secret set BLOXONE_CSP_URL -b "https://csp.infoblox.com" -R "$REPO"
echo "  BLOXONE_CSP_URL         ✓"

gh secret set S3_BUCKET_NAME -b "$BUCKET_NAME" -R "$REPO"
echo "  S3_BUCKET_NAME          ✓"

echo ""
echo "All 5 secrets configured!"

# Step 3: Trigger workflow
echo ""
echo "=== Step 3: Triggering Full-Stack Pipeline ==="
gh workflow run full-stack-deploy.yml -R "$REPO" -f environment=dev
echo ""
echo "============================================"
echo "  Pipeline triggered!"
echo "============================================"
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
