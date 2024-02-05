module "vpc" {
  source             = "../../modules/networking/vpc"
  availability_zones = var.availability_zones
  env_name           = var.env_name
  cidr_blocks        = var.cidr_blocks
}

module "ec2" {
  source                                   = "../../modules/compute/ec2"
  cidr_blocks                              = var.cidr_blocks
  my_ip                                    = var.my_ip
  ami_machine_image                        = var.ami_machine_image
  env_name                                 = var.env_name
  public_subnet_id                         = module.vpc.public_subnet_id
  availability_zones                       = var.availability_zones
  key_name                                 = var.key_name
  public_key_location                      = var.public_key_location
  vpc_id                                   = module.vpc.vpc_id
  instance_type                            = var.instance_type
  install_web_server_shell_script_loaction = var.install_web_server_shell_script_loaction
}

module "alb" {
  source          = "../../modules/load_balancers/alb"
  target_type     = var.target_type
  subnet_id       = module.vpc.public_subnet_id
  vpc_id          = module.vpc.vpc_id
  env_name        = var.env_name
  ip_address_type = var.ip_address_type
  protocol        = var.protocol
  cidr_blocks     = var.cidr_blocks
  subnet_2_id     = module.vpc.public_subnet_2
  domain          = var.main_domain_name
}

module "route53_and_ssl_cert" {
  source           = "../../modules/dns/route53"
  main_domain_name = var.main_domain_name
  subdomain_name   = var.sub_domain_name
  env_name         = var.env_name
  lb_dns_name      = module.alb.alb_dns_name
}

module "ecs" {
  source                           = "../../modules/containers/ecs"
  vpc_id                           = module.vpc.vpc_id
  launch_type                      = var.launch_type
  container_name                   = var.container_name
  dockerhub_image                  = var.dockerhub_image
  ecs_cluster_1_name               = var.ecs_cluster_1_name
  cidr_blocks                      = var.cidr_blocks
  alb_root_target_group_arn        = module.alb.root_tg_arn
  alb_about_route_target_group_arn = module.alb.about_route_tg_arn
  edit_route_traget_group_arn      = module.alb.edit_route_traget_group_arn
  task_name                        = var.task_name
  env_name                         = var.env_name
  ecs_service_name                 = var.ecs_service_name
  web_server_instance              = module.ec2
  public_subnet_ip                 = module.vpc.public_subnet_id
}

module "s3_bucket" {
  source      = "../../modules/storage/s3_bucket"
  bucket_name = var.bucket_name
  env_name    = var.env_name
}

module "dynamodb_table" {
  source        = "../../modules/database/non_rds/dynamodb"
  dynamodb_name = var.dynamodb_table
}
