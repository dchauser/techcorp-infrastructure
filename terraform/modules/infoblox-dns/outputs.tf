output "zone_id" {
  description = "ID of the created DNS zone"
  value       = bloxone_dns_auth_zone.main.id
}

output "view_id" {
  description = "ID of the created DNS view"
  value       = bloxone_dns_view.main.id
}

output "record_ids" {
  description = "Map of record name to record ID"
  value       = { for k, v in bloxone_dns_a_record.initial : k => v.id }
}
