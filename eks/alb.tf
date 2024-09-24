resource "aws_lb" "alb" {
  name               = "ALB-${var.projectName}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.other_repo.outputs.public_subnet_sg_id]
  subnets            = [data.aws_subnet.existing_subnet1.id, data.aws_subnet.existing_subnet2.id]
  idle_timeout       = 60

}

resource "aws_lb" "nlb" {
  name               = "NLB-${var.projectName}"
  internal           = false
  load_balancer_type = "network"
  subnets            = [data.aws_subnet.existing_subnet1.id, data.aws_subnet.existing_subnet2.id]
}

resource "aws_lb_listener" "alb-listener-default" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "8022"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_lanchonete_api.arn
  }
}

resource "aws_lb_listener_rule" "lanchonete_api" {
  listener_arn = aws_lb_listener.alb-listener-default.arn
  priority     = 20
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_lanchonete_api.arn
  }
  condition {
    path_pattern {
      values = ["/api*"]
    }
  }
}
