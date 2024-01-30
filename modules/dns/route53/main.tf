resource "aws_route53_zone" "domain_hosted_zone" {
  name = var.main_domain_name
  tags = {
    Name = "${var.env_name}-hosted-zone"
  }
}

resource "aws_route53_record" "main_domain_record" {
  zone_id = aws_route53_zone.domain_hosted_zone.zone_id
  name    = var.main_domain_name
  type    = "A"
  ttl     = "300"
  records = [var.lb_dns_name]
}

resource "aws_route53_record" "subdomain_record" {
  zone_id = aws_route53_zone.domain_hosted_zone.zone_id
  name    = var.subdomain_name
  type    = "A"
  ttl     = "300"
  records = [var.lb_dns_name]
}
