locals {
  cidr_map = { for block in var.cidr_blocks : block.name => block.cidr_block }
}

resource "aws_alb" "app_load_balancer" {
  load_balancer_type = "application"
  name               = "${var.env_name}-load-balancer"
  internal           = false
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.alb_sg]
  subnet_mapping {
    subnet_id = var.subnet_id
  }
  tags = {
    Name = "${var.env_name}-alb"
  }
}

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_alb.app_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_secure_https_listener" {
  load_balancer_arn = aws_alb.app_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.cert_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_root_target_group.arn
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_about_target_group.arn
  }
}

resource "aws_lb_target_group" "alb_root_target_group" {
  target_type      = var.target_type
  name             = "${var.env_name}-root-target-group-"
  protocol         = var.protocol
  port             = 3000
  ip_address_type  = var.ip_address_type
  vpc_id           = var.vpc_id
  protocol_version = "HTTP1"
  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
  tags = {
    Name = "${var.env_name}-root-target-group"
  }
}

resource "aws_lb_target_group" "alb_about_target_group" {
  target_type      = var.target_type
  name             = "${var.env_name}-about-target-group"
  protocol         = var.protocol
  port             = 3000
  ip_address_type  = var.ip_address_type
  vpc_id           = var.vpc_id
  protocol_version = "HTTP1"
  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/about"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
  tags = {
    Name = "${var.env_name}-about-route-target-group"
  }
}

resource "aws_security_group" "alb_sg" {
  description = "alb security group"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
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
}
