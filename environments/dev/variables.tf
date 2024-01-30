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

variable "my_ip" {
  type = string
}

variable "ami_machine_image" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_key_location" {}

variable "instance_type" {}
