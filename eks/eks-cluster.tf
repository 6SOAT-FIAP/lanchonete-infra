# EKS Cluster
resource "aws_eks_cluster" "lanchonete-api" {
  name     = "module-eks-${var.cluster_name}2"
  role_arn = var.node_role_arn

  vpc_config {
    subnet_ids              = [for subnet in data.aws_subnet.subnet : subnet.id if subnet.availability_zone != "us-east-1e"]
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = [aws_security_group.sg.id]
  }

  access_config {
    authentication_mode = var.accessConfig
  }

  lifecycle {
    prevent_destroy = false
  }

  enabled_cluster_log_types = ["api", "scheduler"]

}

data "aws_eks_cluster_auth" "lanchonete-api_auth" {
  name = aws_eks_cluster.lanchonete-api.name
}