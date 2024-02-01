output "alb_dns_name" {
  value = aws_alb.app_load_balancer.dns_name
}

output "root_tg_arn" {
  value = aws_lb_target_group.alb_root_target_group.arn
}

output "about_route_tg_arn" {
  value = aws_lb_target_group.alb_about_target_group.arn
}