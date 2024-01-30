output "igw_id" {
  value = module.vpc.internet_gateway_id.id
}

output "nat_gw1_id" {
  value = module.vpc.nat_gateway_1_id.id
}
