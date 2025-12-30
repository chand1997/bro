locals {
  sg_database_id       = data.aws_ssm_parameter.sg_database_id.value
  db_subnet_group_name = data.aws_ssm_parameter.db_subnet_group_name.value
}
