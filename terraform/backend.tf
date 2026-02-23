terraform {
  backend "s3" {
    bucket = "khalidhashim-terraform-state"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}
