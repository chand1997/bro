locals {
  ami              = data.aws_ami.example.id
  sg_id            = data.aws_ssm_parameter.sg_bastion_id.value
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
}
