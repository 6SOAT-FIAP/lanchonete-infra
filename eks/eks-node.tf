resource "aws_eks_node_group" "lanchonete-api" {
  cluster_name    = aws_eks_cluster.lanchonete-api.name
  node_role_arn   = var.node_role_arn
  node_group_name = var.cluster_name
  subnet_ids      = [for subnet in data.aws_subnet.subnet : subnet.id if subnet.availability_zone != "us-east-1e"]
  disk_size       = 50
  instance_types = [var.instance_type]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

}

resource "aws_eks_addon" "addon_vpn_cni" {
  cluster_name = aws_eks_cluster.lanchonete-api.name
  addon_name   = "vpc-cni"
}
