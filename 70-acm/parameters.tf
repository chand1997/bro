resource "aws_ssm_parameter" "cert_arn" {
  name  = "/${var.project_name}/${var.environment}/cer_arn"
  type  = "String"
  value = aws_acm_certificate.backend.arn
}
