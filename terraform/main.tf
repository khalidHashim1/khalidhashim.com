# main.tf

provider "aws" {
  alias  = "website"
  region = "eu-north-1"  # Your website bucket region (Stockholm)
}

# Website bucket (already created manually)
resource "aws_s3_bucket" "portfolio" {
  provider = aws.website
  bucket   = "khalidhashim.com"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Portfolio Website"
    Environment = "prod"
  }
}

# Public access block for website bucket
resource "aws_s3_bucket_public_access_block" "portfolio" {
  provider = aws.website
  bucket   = aws_s3_bucket.portfolio.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
