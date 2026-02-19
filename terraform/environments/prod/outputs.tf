# ============================================
# AWS Outputs
# ============================================
output "vpc_id" {
  description = "AWS VPC ID"
  value       = module.aws_networking.vpc_id
}

output "vpc_cidr" {
  description = "AWS VPC CIDR block"
  value       = module.aws_networking.vpc_cidr
}

output "subnet_ids" {
  description = "Map of subnet names to AWS subnet IDs"
  value       = module.aws_networking.subnet_ids
}

# ============================================
# Infoblox IPAM Outputs
# ============================================
output "ip_space_id" {
  description = "Infoblox IP Space ID"
  value       = module.infoblox_ipam.ip_space_id
}

output "address_block_id" {
  description = "Infoblox Address Block ID"
  value       = module.infoblox_ipam.address_block_id
}

output "ipam_subnet_ids" {
  description = "Map of subnet names to IPAM subnet IDs"
  value       = module.infoblox_ipam.subnet_ids
}

# ============================================
# Infoblox DNS Outputs
# ============================================
output "zone_id" {
  description = "Infoblox DNS Zone ID"
  value       = module.infoblox_dns.zone_id
}

output "dns_view_id" {
  description = "Infoblox DNS View ID"
  value       = module.infoblox_dns.view_id
}
