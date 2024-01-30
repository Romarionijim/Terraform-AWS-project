variable "cidr_blocks" {
  type = list(object({
    name       = string
    cidr_block = string
  }))
}

variable "env_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}
