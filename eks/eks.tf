# EKS Cluster
resource "aws_eks_cluster" "lanchonete_api_cluster" {
  name     = var.cluster_name
  role_arn = var.node_role_arn

  vpc_config {
    subnet_ids = [
      data.aws_subnet.existing_subnet1.id,
      data.aws_subnet.existing_subnet2.id,
      data.aws_subnet.existing_subnet3.id,
      data.aws_subnet.existing_subnet4.id
    ]
    security_group_ids = [
      data.terraform_remote_state.other_repo.outputs.private_subnet_sg_id,
      data.terraform_remote_state.other_repo.outputs.public_subnet_sg_id,
      data.terraform_remote_state.other_repo.outputs.aws_security_group_rds
    ]
    endpoint_public_access = true
  }

  tags = {
    Name = "lanchonete_api_cluster"
  }

  depends_on = [aws_lb.alb]
}

data "aws_eks_cluster_auth" "lanchonete_api_cluster_auth" {
  name = aws_eks_cluster.lanchonete_api_cluster.name
}

# EKS Node Group
resource "aws_eks_node_group" "lanchonete_api_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "lanchonete_api_node_group"
  node_role_arn   = var.node_role_arn
  #  subnet_ids      = [aws_subnet.lanchonete_api_private_subnet_1.id, aws_subnet.lanchonete_api_private_subnet_2.id]
  subnet_ids      = [
    data.aws_subnet.existing_subnet1.id,
    data.aws_subnet.existing_subnet2.id,
    data.aws_subnet.existing_subnet3.id,
    data.aws_subnet.existing_subnet4.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  lifecycle {
    prevent_destroy = false
  }

  instance_types = [var.instance_type]
  disk_size      = 20

  # remote_access {
  #   ec2_ssh_key = var.ssh_key_name
  #   # source_security_group_ids = [aws_security_group.lanchonete_api_sg.id]
  # }

  ami_type = "AL2_x86_64"

  depends_on = [aws_eks_cluster.lanchonete_api_cluster]

  labels = {
    environment = var.environment
  }

  tags = {
    Name        = "lanchonete_api_node_group"
    Environment = var.environment
  }
}
