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

  required_version = ">= 1.2.0"
}

# We don't define the provider's credentials here because we are using the AWS CLI to authenticate.
# https://registry.terraform.io/providers/hashicorp/aws/5.65.0/docs?utm_content=documentLink&utm_medium=Visual+Studio+Code&utm_source=terraform-ls#environment-variables
provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "cluster" {
  name = "eks-lanchonete-api"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "eks-lanchonete-api"
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

provider "kubernetes" {
  #  host                   = aws_eks_cluster.lanchonete_cluster.endpoint
  #  cluster_ca_certificate = base64decode(aws_eks_cluster.lanchonete_cluster.certificate_authority[0].data)
  #  token                  = data.aws_eks_cluster_auth.lanchonete_cluster_auth.token
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# provider "kubernetes" {
#   host                   = aws_eks_cluster.application_cluster.endpoint
#   cluster_ca_certificate = base64decode(one(aws_eks_cluster.application_cluster.certificate_authority[*].data))

#   # Prevent error │ Error: secrets "secret-application" is forbidden: User "system:anonymous" cannot get resource "secrets" in API group "" in the namespace "default"
#   # https://github.com/hashicorp/terraform-provider-aws/issues/18852#issuecomment-979480690
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.application_cluster.name]
#     command     = "aws"
#   }
# }