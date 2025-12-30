data "aws_ssm_parameter" "sg_database_id" {
  name = "/${var.project_name}/${var.environment}/sg_database_id"
}

data "aws_ssm_parameter" "db_subnet_group_name" {
  name = "/${var.project_name}/${var.environment}/db_subnet_group_name"

}


