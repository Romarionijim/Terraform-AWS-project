locals {
  cidr_map = { for block in var.cidr_blocks : block.name => block.cidr_block }
}

resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_map["vpc"]
  tags = {
    Name = "${var.env_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  cidr_block        = local.cidr_map["public-subnet-1"]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "${var.env_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  cidr_block        = local.cidr_map["public-subnet-2"]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "${var.env_name}-public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  cidr_block        = local.cidr_map["private-subnet-1"]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "${var.env_name}-private-subnet-1"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env_name}-public-rtb"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env_name}-igw"
  }
}

resource "aws_route" "public_rtb_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = local.cidr_map["all-traffic-cidr"]
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "rtb_association_1" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env_name}-private-rtb"
  }
}

resource "aws_nat_gateway" "nat_gateway_subnet_1" {
  subnet_id     = aws_subnet.private_subnet_1.id
  allocation_id = aws_eip.elastic_ip_1.id
  depends_on    = [aws_eip.elastic_ip_1]
  tags = {
    Name = "${var.env_name}-nat-gateway"
  }
}

//associate the nat gateway with both of the private subnets
resource "aws_route" "nat_gateway_association_1" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = local.cidr_map["all-traffic-cidr"]
  nat_gateway_id         = aws_nat_gateway.nat_gateway_subnet_1.id
}

resource "aws_route_table_association" "private_rtb_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

resource "aws_eip" "elastic_ip_1" {
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.env_name}-elastic-ip"
  }
}
