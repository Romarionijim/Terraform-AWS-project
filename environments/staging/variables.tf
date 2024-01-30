variable "env_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "cidr_blocks" {
  type = list(object({
    name       = string
    cidr_block = string
  }))
}

variable "internet_gateway_id" {
  type = string
}

# variable "nat_gateway_id" {
#   type = string
# }
