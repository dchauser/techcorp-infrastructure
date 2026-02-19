terraform {
  required_providers {
    bloxone = {
      source = "infobloxopen/bloxone"
    }
  }
}

resource "bloxone_dns_view" "main" {
  name = var.dns_view_name
}

resource "bloxone_dns_auth_zone" "main" {
  fqdn         = var.zone_fqdn
  primary_type = "cloud"
  view         = bloxone_dns_view.main.id
}

resource "bloxone_dns_a_record" "initial" {
  for_each = var.initial_records

  zone         = bloxone_dns_auth_zone.main.id
  name_in_zone = each.key
  rdata        = { address = each.value.address }
  comment      = each.value.comment
}
