locals {
  ami           = data.aws_ami.example.id
  resource_name = "${var.project_name}-${var.environment}-backend"
  sg_backend_id = data.aws_ssm_parameter.sg_backend_id.value
  subnet_id     = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  subnet_ids    = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  listener_arn  = data.aws_ssm_parameter.listener_arn.value
  vpc_id        = data.aws_ssm_parameter.vpc_id.value

}
