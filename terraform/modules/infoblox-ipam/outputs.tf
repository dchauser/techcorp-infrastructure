output "ip_space_id" {
  description = "ID of the created IP Space"
  value       = bloxone_ipam_ip_space.main.id
}

output "address_block_id" {
  description = "ID of the created Address Block"
  value       = bloxone_ipam_address_block.main.id
}

output "subnet_ids" {
  description = "Map of subnet name to IPAM subnet ID"
  value       = { for k, v in bloxone_ipam_subnet.subnets : k => v.id }
}
