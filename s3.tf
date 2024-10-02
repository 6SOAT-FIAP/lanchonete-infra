terraform {
  backend "s3" {
    bucket = "lanchonete-bucket"
    key    = "api/terraform.tfstate"
    region = "sa-east-1"
  }
}

#resource "aws_s3_bucket" "lambdas" {
#  bucket = var.bucket_lanchonete_lambdas
#}

#resource "aws_s3_object" "valida_cpf_usuario" {
#  bucket = aws_s3_bucket.lambdas.bucket
#  key    = "valida_cpf_usuario.zip"
#  source = "${path.module}/valida_cpf_usuario.zip"
#}