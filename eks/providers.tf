terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
  }

  backend "s3" {
    bucket = "lanchonete-bucket"
    key    = "lanchonete-bucket/eks.tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.2.0"
}

# We don't define the provider's credentials here because we are using the AWS CLI to authenticate.
# https://registry.terraform.io/providers/hashicorp/aws/5.65.0/docs?utm_content=documentLink&utm_medium=Visual+Studio+Code&utm_source=terraform-ls#environment-variables
provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.lanchonete-api.id
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.lanchonete-api.id
}

provider "kubernetes" {
  #  cluster_ca_certificate = base64decode(aws_eks_cluster.lanchonete-api.certificate_authority[0].data)
  #  host                   = data.aws_eks_cluster.cluster.endpoint
  #  token                  = data.aws_eks_cluster_auth.cluster.token
  host                   = aws_eks_cluster.lanchonete-api.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.lanchonete-api.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.lanchonete-api_auth.token

  # For standard kubeconfig-based authentication:
  # config_path = "~/.kube/config"
}