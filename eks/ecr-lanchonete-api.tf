#resource "aws_ecr_repository" "repository_lanchonete_api" {
#  name                 = "lanchonete-api"
#  image_tag_mutability = "MUTABLE"
#
#  image_scanning_configuration {
#    scan_on_push = false
#  }
#
#  force_delete = true
#  depends_on   = [null_resource.push_image_lanchonete_api_to_ecr]
#}
#
#
#resource "aws_ecr_lifecycle_policy" "repository-payment-lifecycle" {
#  repository = aws_ecr_repository.repository_lanchonete_api.name
#
#  policy = <<EOF
# {
#     "rules": [
#         {
#             "rulePriority": 1,
#             "description": "Expire images count more than 2",
#             "selection": {
#                 "tagStatus": "any",
#                 "countType": "imageCountMoreThan",
#                 "countNumber": 2
#             },
#             "action": {
#                 "type": "expire"
#             }
#         }
#     ]
# }
# EOF
#}
#
## Definição de um recurso de execução local para fazer o push da imagem "lanchonete-api"
#resource "null_resource" "push_image_lanchonete_api_to_ecr" {
#  provisioner "local-exec" {
#    #command = "aws ecr get-login-password | docker login --username AWS --password-stdin 638385053556.dkr.ecr.us-east-1.amazonaws.com && docker build -t 638385053556.dkr.ecr.us-east-1.amazonaws.com/lanchonete-api:latest ../../ && docker push 638385053556.dkr.ecr.us-east-1.amazonaws.com/lanchonete-api:latest"
#
#    command     = <<-EOT
#      aws ecr get-login-password | docker login --username AWS --password-stdin 638385053556.dkr.ecr.us-east-1.amazonaws.com
#      mkdir -p ./temp_repo_lanchonete_api  # Cria diretório temporário exclusivo para a api da lanchonete
#      cd ./temp_repo_lanchonete_api
#      git clone https://github.com/6SOAT-FIAP/lanchonete-api ./lanchonete-api-repo
#      cd ./lanchonete-api-repo || exit 1
#      docker build -t 638385053556.dkr.ecr.us-east-1.amazonaws.com/lanchonete-api:latest .
#      docker push 638385053556.dkr.ecr.us-east-1.amazonaws.com/lanchonete-api:latest
#      rm -rf ./temp_repo_lanchonete_api
#    EOT
#    working_dir = path.module
#  }
#  depends_on = [aws_ecr_repository.repository_lanchonete_api]
#}