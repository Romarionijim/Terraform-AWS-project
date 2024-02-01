output "internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway
}

output "nat_gateway_1_id" {
  value = aws_nat_gateway.nat_gateway_subnet_1
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet_1.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_2" {
  value = aws_subnet.public_subnet_2.id
}
