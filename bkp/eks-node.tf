resource "aws_eks_node_group" "lanchonete-node" {
  cluster_name    = aws_eks_cluster.lanchonete-api.name
  node_group_name = "${var.cluster_name}-NG"
  node_role_arn   = var.node_role_arn
  subnet_ids      = [for subnet in data.aws_subnet.subnet : subnet.id if subnet.availability_zone != "sa-east-1e"]
  disk_size       = 50
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

}