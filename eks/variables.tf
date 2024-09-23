variable "node_role_arn" {
  description = "ARN of the IAM Role that will be associated with the Node Group"
  type        = string
  sensitive   = true
  default     = "arn:aws:iam::638385053556:role/LabRole"
}

variable "lab_role_name" {
  description = "Name of the IAM Role that will be associated with the Node Group"
  type        = string
  default     = "LabRole"
}

variable "environment" {
  description = "The environment of the application"
  type        = string
  # Environments are often things such as development, integration, or production.
  default     = "development"
}

variable "kubernetes_namespace" {
  description = "The Kubernetes namespace where the resources will be provisioned"
  type        = string
  default     = "lanchonete"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "lanchonete-eks"
}

variable "availability_zones" {
  description = "List of availability zones where the subnets will be created"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to associate with the EC2 instance"
  type        = string
  default     = "aws-ec2-access"
}

variable "ssh_key" {
  description = "The SSH key to use for connecting to the EC2 instance"
  type        = string
  default     = "~/.ssh/aws-ec2-access"
}

variable "image_version" {
  description = "The version of the image to deploy"
  type        = string
  default     = "latest"
}

variable "datatabase_lanchonete_api_name" {
  description = "Nome do database do projeto"
  default     = "rds-lanchonete-api"
  type        = string
}

variable "projectName" {
  description = "Nome do projeto."
  default     = "lanchonete-api"
  type        = string
}