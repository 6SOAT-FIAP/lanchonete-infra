# EKS Cluster
resource "aws_eks_cluster" "lanchonete-api" {
  name     = "module-eks-${var.cluster_name}"
  role_arn = var.node_role_arn

  vpc_config {
    #    subnet_ids              = aws_subnet.public_lanchonete-api_subnet.*.id
    subnet_ids = [
      aws_subnet.lanchonete-api_public_subnet_1.id,
      aws_subnet.lanchonete-api_public_subnet_2.id,
      aws_subnet.lanchonete-api_private_subnet_1.id,
      aws_subnet.lanchonete-api_private_subnet_2.id
    ]
    endpoint_public_access  = true
    endpoint_private_access = false
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = [
      aws_security_group.node_group_one.id
    ]
  }
  lifecycle {
    prevent_destroy = false
  }

  enabled_cluster_log_types = ["api","scheduler"]

  access_config {
    authentication_mode = var.accessConfig
  }

}

data "aws_eks_cluster_auth" "lanchonete-api_auth" {
  name = aws_eks_cluster.lanchonete-api.name
}

resource "aws_eks_node_group" "lanchonete-api" {
  cluster_name    = aws_eks_cluster.lanchonete-api.name
  node_role_arn   = var.node_role_arn
  node_group_name = var.cluster_name
  subnet_ids      = [aws_subnet.lanchonete-api_private_subnet_1.id, aws_subnet.lanchonete-api_private_subnet_2.id]
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 1
    max_size     = 3
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
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
#  disk_size      = 20

  # remote_access {
  #   ec2_ssh_key = var.ssh_key_name
  #   # source_security_group_ids = [aws_security_group.basic_app_sg.id]
  # }

#  ami_type = "AL2_x86_64"
}