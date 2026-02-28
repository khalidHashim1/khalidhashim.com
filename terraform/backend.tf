terraform {
  backend "s3" {
    bucket = "khalidhashim-terraform-state"
    key    = "khalidhashim.com/terraform.tfstate" # temporary, overridden by backend-config
    region = "us-east-1"
    #dynamodb_table = "terraform-locks"
    encrypt = true
  }
}
