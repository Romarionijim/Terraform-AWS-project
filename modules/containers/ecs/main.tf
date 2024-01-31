locals {
  cidr_map = { for block in var.cidr_blocks : block.name => block.cidr_block }
}

resource "aws_ecs_cluster" "ecs_cluster_1" {
  name = var.ecs_cluster_1_name
}

resource "aws_ecs_task_definition" "express_app_container" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.dockerhub_image
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.ecs_cluster_1.id
  task_definition = aws_ecs_task_definition.express_app_container.arn
  launch_type     = ""
  load_balancer {
    target_group_arn = var.alb_root_target_group_arn
    container_name   = var.container_name
    container_port   = 3000
  }
  load_balancer {
    target_group_arn = var.alb_about_route_target_group_arn
    container_name   = var.container_name
    container_port   = 3000
  }
}

data "aws_iam_policy_document" "ecs_node_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_node_role" {
  name_prefix        = "demo-ecs-node-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_node_doc.json
}

resource "aws_iam_instance_profile" "ecs_node" {
  name_prefix = "demo-ecs-node-profile"
  role        = aws_iam_role.ecs_node_role.name
}

resource "aws_security_group" "ecs_sg" {
  vpc_id      = var.vpc_id
  description = "allow traffic from and to anywhere"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [local.cidr_map["all-traffic-cidr"]]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [local.cidr_map["all-traffic-cidr"]]
  }
  tags = {
    Name = "${var.env_name}-ecs-sg"
  }
}
