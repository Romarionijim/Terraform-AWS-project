locals {
  cidr_map = { for block in var.cidr_blocks : block.name => block.cidr_block }
}

resource "aws_instance" "web_server" {
  ami                         = var.ami_machine_image
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web_server_firewall.id]
  availability_zone           = var.availability_zones[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.web_server_ssh_key_pair.key_name
  subnet_id                   = var.public_subnet_id
  user_data                   = file("install_web_server.sh")
  user_data_replace_on_change = true
  tags = {
    Name = "${var.env_name}-web-server"
  }
}

resource "aws_key_pair" "web_server_ssh_key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_location)
}

resource "aws_security_group" "web_server_firewall" {
  vpc_id      = var.vpc_id
  description = "webserver/ec2 firewall"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.cidr_map["all-traffic-cidr"]]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [local.cidr_map["all-traffic-cidr"]]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.cidr_map["all-traffic-cidr"]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [local.cidr_map["all-traffic-cidr"]]
  }

  tags = {
    Name = "${var.env_name}-sg"
  }
}

