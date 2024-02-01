variable "ami_machine_image" {
  type = string
}

variable "my_ip" {
  type = string
}

variable "cidr_blocks" {
  type = list(object({
    name       = string
    cidr_block = string
  }))
}

variable "availability_zones" {
  type = list(string)
}

variable "public_key_location" {
  type = string
}

variable "key_name" {
  type = string
}

variable "env_name" {
  type = string
}

variable "public_subnet_id" {
  type = any
}

variable "vpc_id" {
  type = any
}

variable "instance_type" {
  type = string
}

variable "install_web_server_shell_script_loaction" {}