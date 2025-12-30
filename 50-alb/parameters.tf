

resource "aws_ssm_parameter" "listener_arn" {
  name  = "/${var.project_name}/${var.environment}/listener_arn"
  type  = "String"
  value = aws_lb_listener.app_alb.arn
}
