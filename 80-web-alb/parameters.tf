

resource "aws_ssm_parameter" "frontend_listener_arn" {
  name  = "/${var.project_name}/${var.environment}/frontend_listener_arn"
  type  = "String"
  value = aws_lb_listener.web_alb.arn
}
