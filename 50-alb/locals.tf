locals {
  vpc_id             = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  sg_app_alb_id      = data.aws_ssm_parameter.sg_app_alb_id.value
}
