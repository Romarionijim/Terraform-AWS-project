module "vpc" {
  source             = "../../modules/networking/vpc"
  availability_zones = var.availability_zones
  env_name           = var.env_name
  cidr_blocks        = var.cidr_blocks
}

module "ec2" {
  source              = "../../modules/compute/ec2"
  cidr_blocks         = var.cidr_blocks
  my_ip               = var.my_ip
  ami_machine_image   = var.ami_machine_image
  env_name            = var.env_name
  public_subnet_id    = module.vpc.public_subnet_id
  availability_zones  = var.availability_zones
  key_name            = var.key_name
  public_key_location = var.public_key_location
  vpc_id              = module.vpc.vpc_id
  instance_type = var.instance_type
}
