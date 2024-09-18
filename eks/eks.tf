# EKS Cluster
resource "aws_eks_cluster" "lanchonete_api_cluster" {
  name     = var.cluster_name
  role_arn = var.node_role_arn

  vpc_config {
    subnet_ids = [
      aws_subnet.lanchonete_api_public_subnet_1.id,
      aws_subnet.lanchonete_api_public_subnet_2.id,
      aws_subnet.lanchonete_api_private_subnet_1.id,
      aws_subnet.lanchonete_api_private_subnet_2.id
    ]

    # security_group_ids = [aws_security_group.lanchonete_api_eks_sg.id]
  }

  tags = {
    Name = "lanchonete_api_cluster"
  }
}

data "aws_eks_cluster_auth" "lanchonete_api_cluster_auth" {
  name = aws_eks_cluster.lanchonete_api_cluster.name
}

# EKS Node Group
resource "aws_eks_node_group" "lanchonete_api_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "lanchonete_api_node_group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = [aws_subnet.lanchonete_api_private_subnet_1.id, aws_subnet.lanchonete_api_private_subnet_2.id]

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

  depends_on = [aws_eks_cluster.lanchonete_api_cluster, aws_cloudwatch_log_group.example]

  labels = {
    environment = var.environment
  }

  tags = {
    Name        = "lanchonete_api_node_group"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "example" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

  # ... potentially other configuration ...
}

# resource "aws_key_pair" "lanchonete_api_ssh_key" {
#   key_name   = var.ssh_key_name
#   public_key = file("${var.ssh_key}.pub")
# }