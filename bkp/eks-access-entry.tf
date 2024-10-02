resource "aws_eks_access_entry" "eks-access-entry" {
  cluster_name      = aws_eks_cluster.lanchonete-api.name
  principal_arn     = var.principalArn
  kubernetes_groups = [var.cluster_name]
  type              = "STANDARD"
}