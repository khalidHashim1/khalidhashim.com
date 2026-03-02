
##############################
# S3 Bucket (Private)
##############################
resource "aws_s3_bucket" "portfolio" {
  provider = aws.website
  bucket = "khalidhashim.com"

  tags = {
    Name        = "Portfolio Website"
    Environment = "prod"
  }
}

##############################
# Block Public Access
##############################
resource "aws_s3_bucket_public_access_block" "portfolio" {
  provider = aws.website
  bucket = aws_s3_bucket.portfolio.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##############################
# CloudFront Origin Access Control (OAC)
##############################
resource "aws_cloudfront_origin_access_control" "oac" {
  provider                         = aws.website
  name                              = "portfolio-oac"
  description                       = "OAC for khalidhashim.com"
  signing_behavior                   = "always"
  signing_protocol                   = "sigv4"
  origin_access_control_origin_type  = "s3"
}

##############################
# CloudFront Distribution
##############################
resource "aws_cloudfront_distribution" "portfolio" {
  provider         = aws.website
  enabled          = true
  is_ipv6_enabled  = true
  comment          = "Portfolio CloudFront Distribution"
  price_class      = "PriceClass_All"
  wait_for_deployment = true
  default_root_object = "index.html"

  aliases = [
    "khalidhashim.com",
    "www.khalidhashim.com",
  ]

  origin {
    origin_id   = "S3-khalidhashim"
    domain_name = aws_s3_bucket.portfolio.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    target_origin_id       = "S3-khalidhashim"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    default_ttl            = 0
    min_ttl                = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.main.arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  tags = {
    Name           = "khalidhashimCloudFront"
    awsApplication = "Portfolio Website"
  }
}

##############################
# S3 Bucket Policy (Allow Only CloudFront)
##############################
resource "aws_s3_bucket_policy" "portfolio_policy" {
  provider = aws.website
  bucket   = aws_s3_bucket.portfolio.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.portfolio.id}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.portfolio.arn
          }
        }
      }
    ]
  })
}

##############################
# Route53 A Record (Alias to CloudFront)
##############################
resource "aws_route53_record" "root" {
  provider = aws.website
  zone_id = "Z04058082YY1290VSKWE8"
  name    = "khalidhashim.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = "Z2FDTNDATAQYW2" # CloudFront hosted zone
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.khalidhashim.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

##############################
# ACM Certificate (us-east-1)
##############################
resource "aws_acm_certificate" "main" {
  provider          = aws.us
  domain_name       = "khalidhashim.com"
  validation_method = "DNS"

  subject_alternative_names = [
    "www.khalidhashim.com",
    "*.khalidhashim.com"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "khalidhashim-main-cert"
  }
}

##############################
# Get Route53 Zone
##############################
data "aws_route53_zone" "main" {
  name         = "khalidhashim.com"
  private_zone = false
}

##############################
# DNS Validation Records
##############################
resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true

  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}

##############################
# Certificate Validation
##############################
resource "aws_acm_certificate_validation" "main" {
  provider                = aws.us
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}