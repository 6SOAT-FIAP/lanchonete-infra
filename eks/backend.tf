terraform {
  backend "s3" {
    bucket = "lanchonete-bucket"
    key    = "api/terraform.tfstate"
    region = var.awsRegion
  }
}