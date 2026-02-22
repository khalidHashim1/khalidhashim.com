resource "aws_acm_certificate" "cert" {
  domain_name       = "khalidhashim.com"
  validation_method = "DNS"

  subject_alternative_names = ["www.khalidhashim.com"]

  lifecycle {
    create_before_destroy = true
  }
}
