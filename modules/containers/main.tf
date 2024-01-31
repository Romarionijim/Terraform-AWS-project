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
  launch_type = "FAR"
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
