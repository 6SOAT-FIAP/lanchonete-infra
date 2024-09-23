data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

data "aws_vpc" "existing_vpcs" {
  tags = {
    Name = "vpc-lanchonete-api"
  }
}

//referencia o SG criado no repositorio de database
data "terraform_remote_state" "other_repo" {
  backend = "s3"
  config  = {
    bucket = "lanchonete-bucket"
    key    = "lanchonete-bucket/database.tfstate"
    region = "us-east-1"
  }
}

data "aws_subnet" "existing_subnet1" {
  tags = {
    Name = "subnet-public-lanchonete-api-1"
  }
}

data "aws_subnet" "existing_subnet2" {
  tags = {
    Name = "subnet-public-lanchonete-api-2"
  }
}

data "aws_subnet" "existing_subnet3" {
  tags = {
    Name = "subnet-private-lanchonete-api-1"
  }
}

data "aws_subnet" "existing_subnet4" {
  tags = {
    Name = "subnet-private-lanchonete-api-2"
  }
}

data "aws_db_instance" "database" {
  db_instance_identifier = var.datatabase_lanchonete_api_name
}

data "aws_subnet" "cluster-vpc-subnet-private-1" {
  tags = {
    Name = "subnet-private-lanchonete-api-1"
  }
}

data "aws_subnet" "cluster-vpc-subnet-private-2" {
  tags = {
    Name = "subnet-private-lanchonete-api-2"
  }
}

data "aws_security_group" "public_subnet_sg" {
  name = "balancers-security-group"
}