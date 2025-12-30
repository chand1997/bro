resource "aws_ssm_parameter" "sg_frontend_id" {
  name  = "/${var.project_name}/${var.environment}/sg_frontend_id"
  type  = "String"
  value = module.sg_frontend.sg_id
}

resource "aws_ssm_parameter" "sg_backend_id" {
  name  = "/${var.project_name}/${var.environment}/sg_backend_id"
  type  = "String"
  value = module.sg_backend.sg_id
}

resource "aws_ssm_parameter" "sg_database_id" {
  name  = "/${var.project_name}/${var.environment}/sg_database_id"
  type  = "String"
  value = module.sg_database.sg_id
}

resource "aws_ssm_parameter" "sg_web_alb_id" {
  name  = "/${var.project_name}/${var.environment}/sg_web_alb_id"
  type  = "String"
  value = module.sg_web_alb.sg_id
}

resource "aws_ssm_parameter" "sg_app_alb_id" {
  name  = "/${var.project_name}/${var.environment}/sg_app_alb_id"
  type  = "String"
  value = module.sg_app_alb.sg_id
}

resource "aws_ssm_parameter" "sg_bastion_id" {
  name  = "/${var.project_name}/${var.environment}/sg_bastion_id"
  type  = "String"
  value = module.sg_bastion.sg_id
}

resource "aws_ssm_parameter" "sg_vpn_id" {
  name  = "/${var.project_name}/${var.environment}/sg_vpn_id"
  type  = "String"
  value = module.sg_vpn.sg_id
}




