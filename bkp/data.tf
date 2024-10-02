data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

data "aws_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"
}

data "aws_subnets" "subnets"{
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

# Não funciona pq n temos permissão no aws academy
#data "aws_iam_role" "labRole"{
#  name = "LabRole"
#}