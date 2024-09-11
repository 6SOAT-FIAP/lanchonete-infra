#variable "projectName" {
#  default = "lanchonete-api"
#}
#
#variable "clusterName" {
#  default = "lanchonete-api"
#}
#
#variable "regionDefault" {
#  default = "us-east-1"
#}
#
#variable "vpcCIDR" {
#  default = "172.31.0.0/20"
#}
#
#variable "project_name_dynamo" {
#  description = "Nome do projeto. Por exemplo, 'bluesburguer'."
#  default     = "TBD"
#  type        = string
#}
#
#variable "project_name_lanchonete-api" {
#  description = "Nome do projeto. Por exemplo, 'lanchonete-api'."
#  default     = "lanchonete-api"
#  type        = string
#}
#
#variable "tags" {
#  type    = map(string)
#  default = {
#    App      = "lanchonete-api",
#    Ambiente = "Desenvolvimento"
#  }
#}
#
variable "aws_region" {
  default = "us-east-1"
}
#
#variable "aws_access_key" {
#  default = "sua_access_key"
#}
#
#variable "aws_secret_key" {
#  default = "sua_secret_key"
#}
#
#variable "domain_name" {
#  description = "Inserir aws secret key"
#  type        = string
#  default     = "lanchonete-api.terraform.com"
#}
#
#variable "github_repo_url" {
#  default = "https://github.com/6SOAT-FIAP/lanchonete-api"
#}

variable "registry_server" {
  type    = string
  default = "https://hub.docker.com/"
}

variable "registry_username" {
  type    = string
  default = "luhanlacerda"
}

variable "registry_password" {
  type      = string
  sensitive = true
}

locals {
  tags = {
    created_by = "terraform"
  }

#  aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}