# EKS Cluster
resource "aws_eks_cluster" "lanchonete-api" {
  name     = "eks-${var.cluster_name}"
  role_arn = var.node_role_arn

  vpc_config {
    subnet_ids         = [for subnet in data.aws_subnet.subnet : subnet.id if subnet.availability_zone != "sa-east-1e"]
    security_group_ids = [aws_security_group.sg.id]
  }

  access_config {
    authentication_mode = var.accessConfig
  }
}

data "aws_eks_cluster_auth" "lanchonete-api_auth" {
  name = aws_eks_cluster.lanchonete-api.name
}