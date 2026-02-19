variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.20.0.0/16"
}

variable "ddi_api_key" {
  description = "BloxOne DDI API key (set via TF_VAR_ddi_api_key environment variable)"
  type        = string
  sensitive   = true
}
