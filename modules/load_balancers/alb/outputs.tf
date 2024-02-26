output "alb_dns_name" {
  value = aws_alb.app_load_balancer.dns_name
}

output "alb_zone_id" {
  value = aws_alb.app_load_balancer.zone_id
}

output "alb" {
  value = aws_alb.app_load_balancer
}

output "root_tg_arn" {
  value = aws_lb_target_group.alb_root_target_group.arn
}