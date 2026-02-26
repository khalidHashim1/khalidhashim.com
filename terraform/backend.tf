terraform {
  backend "s3" {
    bucket         = "khalidhashim-terraform-state"
    key = "khalidhashim.com/${terraform.workspace}/terraform.tfstate"
    region         = "us-east-1"   # change if different
    #dynamodb_table = "terraform-locks" # only if you created this
    encrypt        = true
  }
}
