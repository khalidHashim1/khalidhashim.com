Skip to content
khalidHashim1
khalidhashim.com
Repository navigation
Code
Issues
Pull requests
Actions
Projects
Security
Insights
Settings
Files
Go to file
t
.github
backend
frontend
terraform
backend.tf
main.tf
outputs.tf
providers.tf
variables.tf
versions.tf
README.md
khalidhashim.com/terraform
/
main.tf
in
main

Edit

Preview
Indent mode

Spaces
Indent size

2
Line wrap mode

No wrap
Editing main.tf file contents
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
 11
 12
 13
 14
 15
 16
 17
 18
 19
 20
 21
 22
 23
 24
 25
 26
 27
 28
 29
 30
 31
 32
 33
 34
 35
 36
 37
 38
 39
 40
 41
 42
 43
 44
 45
 46
 47
 48
 49
 50
 51
 52
 53
 54
 55
 56
 57
 58
 59
 60
 61
 62
 63
 64
 65
 66
 67
 68
 69
 70
 71
 72
 73
 74
 75
 76
 77
 78
 79
 80
 81
 82
 83
 84
 85
 86
 87
 88
 89
 90
 91
 92
 93
 94
 95
 96
 97
 98
 99
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
125
126
127
128
129
130
131
132
133
134
135
136
137
138
139
140
141
142
##############################
# AWS Provider with alias
##############################
provider "aws" {
  alias  = "website"
  region = "eu-north-1"  # Stockholm
}

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
    acm_certificate_arn = "arn:aws:acm:us-east-1:665832050840:certificate/0a85c5bc-3c94-41d4-add2-d8b58507511c"
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
Use Control + Shift + m to toggle the tab key moving focus. Alternatively, use esc then tab to move to the next interactive element on the page.
 
