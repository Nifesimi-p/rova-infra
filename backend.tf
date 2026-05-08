terraform {
  backend "s3" {
    key     = "rova/terraform.tfstate"
    encrypt = true
  }
}