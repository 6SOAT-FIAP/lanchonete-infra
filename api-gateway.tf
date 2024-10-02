# Declara o recurso aws_lb para o Load Balancer usando o nome
data "aws_lb" "lanchonete_lb" {
  tags = {
    "kubernetes.io/service-name" = "default/service-lanchonete-app"
  }

  depends_on = [kubernetes_service.lanchonete_app_service]
}

# Declara o recurso aws_lb_listener para obter o ARN do listener
data "aws_lb_listener" "lanchonete_lb_listener" {
  load_balancer_arn = data.aws_lb.lanchonete_lb.arn
  port              = 8080

  depends_on = [kubernetes_service.lanchonete_app_service]
}

# Cria a API Gateway do tipo HTTP API
resource "aws_apigatewayv2_api" "http_api" {
  name          = "lanchonete_http_api"
  protocol_type = "HTTP"
  description   = "lanchonete HTTP API"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

  lifecycle {
    prevent_destroy = false
  }
}

# Cria o autorizer Lambda para a HTTP API
#resource "aws_apigatewayv2_authorizer" "lambda_authorizer" {
#  api_id                            = aws_apigatewayv2_api.http_api.id
#  name                              = "lambda_authorizer"
#  authorizer_type                   = "REQUEST"
#  authorizer_uri                    = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.valida_cpf_usuario.arn}/invocations"
#  identity_sources                  = ["$request.header.auth"]
#  authorizer_payload_format_version = "2.0"
#  authorizer_result_ttl_in_seconds  = 0
#  enable_simple_responses           = true
#
#  lifecycle {
#    prevent_destroy = false
#  }
#}

# Define a rota do API Gateway para aceitar todas as requisições que começam com /pedidos e usar o autorizer Lambda
#resource "aws_apigatewayv2_route" "auth_route" {
#  api_id             = aws_apigatewayv2_api.http_api.id
#  route_key          = "ANY /api/v1/{proxy+}"
#  authorization_type = "CUSTOM"
#  authorizer_id      = aws_apigatewayv2_authorizer.lambda_authorizer.id
#  target             = "integrations/${aws_apigatewayv2_integration.auth_integration.id}"
#
#  lifecycle {
#    prevent_destroy = false
#  }
#
#  depends_on = [aws_apigatewayv2_integration.auth_integration]
#}

# Cria o VPC Link para a integração com o Load Balancer
resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name = "lanchonete_vpc_link"
  subnet_ids = [
    aws_subnet.lanchonete_private_subnet_1.id,
    aws_subnet.lanchonete_private_subnet_2.id
  ]
  security_group_ids = [
    aws_security_group.api_gw_sg.id,
    aws_security_group.eks_security_group.id,
  ]

  lifecycle {
    prevent_destroy = false
  }
}

# Define a integração do API Gateway para chamar a função Lambda
#resource "aws_apigatewayv2_integration" "lambda_integration" {
#  api_id                 = aws_apigatewayv2_api.http_api.id
#  integration_type       = "AWS_PROXY"
#  integration_uri        = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.valida_cpf_usuario.arn}/invocations"
#  payload_format_version = "2.0"
#
#  lifecycle {
#    prevent_destroy = false
#  }
#}

# Define a integração do API Gateway para chamar o Load Balancer
resource "aws_apigatewayv2_integration" "auth_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = data.aws_lb_listener.lanchonete_lb_listener.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id

  request_parameters = {
    "overwrite:header.auth" = "$context.authorizer.jwt"
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [kubernetes_service.lanchonete_app_service]
}

# Permissão para a API Gateway invocar a função Lambda
#resource "aws_lambda_permission" "apigw_lambda" {
#  statement_id  = "AllowAPIGatewayInvoke"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.valida_cpf_usuario.function_name
#  principal     = "apigateway.amazonaws.com"
#  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/authorizers/${aws_apigatewayv2_authorizer.lambda_authorizer.id}"
#}

# Cria o grupo de segurança para o API Gateway
resource "aws_security_group" "api_gw_sg" {
  name        = "api-gw-sg"
  description = "Allow API Gateway access"
  vpc_id      = aws_vpc.lanchonete_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}