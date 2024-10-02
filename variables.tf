# Application configuration
variable "environment" {
  description = "The environment of the application"
  type        = string
  default     = "development"
}

variable "image_name" {
  description = "The name of the image to deploy"
  type        = string
  default     = "lanchonete-api"
}

variable "image_username" {
  description = "The username of the image to deploy"
  type        = string
  default     = "luhanlacerda"
}

variable "image_version" {
  description = "The version of the image to deploy"
  type        = string
  default     = "latest"
}

variable "app_port" {
  description = "The port where the application will be listening"
  type        = string
  default     = "8080"
}

variable "enable_flyway" {
  description = "Enable Flyway to run the migrations"
  type        = bool
  default     = false
}

# AWS provider configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "sa-east-1"
}

variable "node_role_arn" {
  description = "ARN of the IAM Role that will be associated with the Node Group"
  type        = string
  default     = "arn:aws:iam::578360598759:role/role-adm"
}

# VPC configuration
variable "vpc_name" {
  description = "VPC Name - VPC Created in the infrastructure repo"
  type        = string
  default     = "lanchonete_vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_public_1_cidr_block" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_public_2_cidr_block" {
  description = "CIDR block for the secondary public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_private_1_cidr_block" {
  description = "CIDR block for the first subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_private_2_cidr_block" {
  description = "CIDR block for the first subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "subnet_availability_zone_az_1" {
  description = "Availability zone for the subnets"
  type        = string
  default     = "sa-east-1a"
}

variable "subnet_availability_zone_az_2" {
  description = "Availability zone 2 for the subnets"
  type        = string
  default     = "sa-east-1b"
}

# Kubernetes configuration
variable "kubernetes_namespace" {
  description = "The Kubernetes namespace where the resources will be provisioned"
  type        = string
  default     = "default"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "eks-lanchonete-api"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

# Lambda configuration
variable "lambda_sg_name" {
  description = "Security Group Name for the Lambda"
  type        = string
  default     = "lambda_sg"
}

variable "bucket_lanchonete_lambdas" {
  description = "The name of the bucket where the lambdas will be stored"
  type        = string
  default     = "bucket-lanchonete-lambdas"
}

# Database configuration
variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "root"
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  default     = "root@2024"
}

variable "db_name" {
  description = "Name for the database"
  type        = string
  default     = "lanchonete_db"
}

variable "db_host" {
  description = "Host for the database"
  type        = string
  default     = ""
}