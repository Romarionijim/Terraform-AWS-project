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

variable "my_ip" {}
variable "ami_machine_image" {}
variable "key_name" {}
variable "public_key_location" {}
variable "instance_type" {}
variable "install_web_server_shell_script_loaction" {}
variable "target_type" {}
variable "ip_address_type" {}
variable "protocol" {}
variable "main_domain_name" {}
variable "sub_domain_name" {}
variable "launch_type" {}
variable "container_name" {}
variable "dockerhub_image" {}
variable "ecs_cluster_1_name" {}
variable "task_name" {}
variable "ecs_service_name" {}
variable "bucket_name" {}
variable "dynamodb_table" {}
variable "bucket_key_path" {}
variable "region" {}