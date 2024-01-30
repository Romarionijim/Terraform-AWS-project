resource "aws_acm_certificate" "ssl_certificate" {
  domain_name       = var.main_domain_name
  validation_method = "DNS"
  tags = {
    Name = var.env_name
  }
  lifecycle {
    create_before_destroy = true
  }
}
