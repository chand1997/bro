data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}


data "aws_ssm_parameter" "sg_web_alb_id" {
  name = "/${var.project_name}/${var.environment}/sg_web_alb_id"
}

data "aws_ssm_parameter" "cert_arn" {
  name = "/${var.project_name}/${var.environment}/cert_arn"
}

