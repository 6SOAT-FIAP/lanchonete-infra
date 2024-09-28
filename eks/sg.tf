resource "aws_security_group" "sg" {
  name        = "SG-${var.cluster_name}"
  description = "Security group to instance access"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite acesso SSH de qualquer IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Permite todo o tráfego de saída
    cidr_blocks = ["0.0.0.0/0"]
  }
}