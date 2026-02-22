provider "aws" {
  region = "eu-north-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}
