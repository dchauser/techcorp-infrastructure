output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "subnet_ids" {
  description = "Map of subnet name to subnet ID"
  value       = { for k, v in aws_subnet.subnets : k => v.id }
}

output "subnet_cidrs" {
  description = "Map of subnet name to CIDR block"
  value       = { for k, v in aws_subnet.subnets : k => v.cidr_block }
}

output "nat_gateway_ip" {
  description = "Public IP of the NAT gateway (placeholder for DNS records)"
  value       = aws_internet_gateway.main.id
}
