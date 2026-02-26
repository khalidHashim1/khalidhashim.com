terraform {
  backend "s3" {
    bucket         = "khalidhashim-terraform-state"
    key            = "khalidhashim.com/${terraform.workspace}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
