terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    bloxone = {
      source  = "infobloxopen/bloxone"
      version = "~> 1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "TechCorp-Inventory"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

provider "bloxone" {
  # API key from environment variable: BLOXONE_API_KEY
  # CSP URL from environment variable: BLOXONE_CSP_URL
}
