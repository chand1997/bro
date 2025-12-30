locals {
  vpc_id            = data.aws_ssm_parameter.vpc_id.value
  public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  sg_web_alb_id     = data.aws_ssm_parameter.sg_web_alb_id.value
  cert_arn          = data.aws_ssm_parameter.cert_arn.value
}
