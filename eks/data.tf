data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

//referencia o SG criado no repositorio de database
#data "terraform_remote_state" "other_repo" {
#  backend = "s3"
#  config  = {
#    bucket = "lanchonete-bucket"
#    key    = "lanchonete-bucket/database.tfstate"
#    region = "us-east-1"
#  }
#}

data "aws_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

data "aws_db_instance" "database" {
  db_instance_identifier = var.datatabase_lanchonete_api_name
}