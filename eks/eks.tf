# EKS Cluster
resource "aws_eks_cluster" "lanchonete-api" {
  name     = "module-eks-${var.cluster_name}"
  role_arn = var.node_role_arn

  vpc_config {
    subnet_ids              = aws_subnet.public_lanchonete-api_subnet.*.id
    endpoint_public_access  = true
    endpoint_private_access = false
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = [
      aws_security_group.node_group_one.id
    ]
  }

  depends_on = [aws_lb.alb]
}

data "aws_eks_cluster_auth" "lanchonete-api_auth" {
  name = aws_eks_cluster.lanchonete-api.name
}

resource "aws_eks_node_group" "lanchonete-api" {
  cluster_name    = aws_eks_cluster.lanchonete-api.name
  node_role_arn   = var.node_role_arn
  node_group_name = var.cluster_name
  subnet_ids      = aws_subnet.public_lanchonete-api_subnet.*.id
  instance_types  = ["t2.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

}

resource "aws_security_group" "node_group_one" {
  name_prefix = "node_group_one"
  vpc_id      = aws_vpc.lanchonete-api_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
