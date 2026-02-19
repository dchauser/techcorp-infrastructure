variable "dns_view_name" {
  description = "Name of the DNS view"
  type        = string
}

variable "zone_fqdn" {
  description = "Fully qualified domain name for the DNS zone"
  type        = string
}

variable "initial_records" {
  description = "Map of initial DNS A records to create"
  type = map(object({
    type    = string
    address = string
    comment = string
  }))
  default = {}
}
