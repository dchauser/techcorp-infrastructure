variable "ip_space_name" {
  description = "Name of the IP Space in Infoblox"
  type        = string
}

variable "address_block" {
  description = "Address block configuration"
  type = object({
    address = string
    cidr    = number
    name    = string
    comment = string
  })
}

variable "subnets" {
  description = "Map of subnet configurations for IPAM registration"
  type = map(object({
    address = string
    cidr    = number
    name    = string
    comment = string
  }))
}
