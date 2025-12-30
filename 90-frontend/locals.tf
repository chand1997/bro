locals {
  ami           = data.aws_ami.example.id
  resource_name = "${var.project_name}-${var.environment}-frontend"
  sg_frontend_id = data.aws_ssm_parameter.sg_frontend_id.value
  subnet_id     = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  subnet_ids    = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  listener_arn  = data.aws_ssm_parameter.frontend_listener_arn.value

}
