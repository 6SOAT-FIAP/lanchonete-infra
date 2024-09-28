variable "node_role_arn" {
  description = "ARN of the IAM Role that will be associated with the Node Group"
  type        = string
  sensitive   = true
  default     = "arn:aws:iam::638385053556:role/LabRole"
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
  default     = "default"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "lanchonete-api"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  #  default     = "t2.micro"
  default     = "t3.medium"
}

variable "datatabase_lanchonete_api_name" {
  description = "Nome do database do projeto"
  default     = "rds-lanchonete-api"
  type        = string
}

variable "principalArn" {
  default = "arn:aws:iam::257266759997:role/voclabs"
}

variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}

variable "awsRegion" {
  default = "us-east-1"
}