module "vpc" {
  source              = "../../modules/networking/vpc"
  availability_zones  = var.availability_zones
  env_name            = var.env_name
  cidr_blocks         = var.cidr_blocks
}