data "aws_route53_zone" "hosted_zone" {
  name         = var.main_domain_name
  private_zone = false
}

resource "aws_route53_record" "route53_record" {
  zone_id         = data.aws_route53_zone.hosted_zone.id
  name            = var.sub_domain_name
  type            = "A"
  allow_overwrite = true
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
  depends_on = [var.alb]
}
