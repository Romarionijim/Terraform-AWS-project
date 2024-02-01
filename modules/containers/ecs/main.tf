locals {
  cidr_map = { for block in var.cidr_blocks : block.name => block.cidr_block }
}

resource "aws_ecs_cluster" "ecs_cluster_1" {
  name = var.ecs_cluster_1_name
  tags = {
    Name = "${var.env_name}-ecs-cluster-1"
  }
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
  launch_type     = "EC2"
  desired_count   = 1
  network_configuration {
    subnets          = [var.public_subnet_ip]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
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

  depends_on = [var.web_server_instance]
  tags = {
    Name = "${var.env_name}-ecs-service"
  }
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

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
