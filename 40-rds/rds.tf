module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.project_name}-${var.environment}-db"

  engine            = "mysql"
  engine_version    = "8.0.40"
  instance_class    = "db.t4g.micro"
  allocated_storage = 5

  db_name  = "transactions"
  username = "root"
  port     = "3306"


  vpc_security_group_ids      = [local.sg_database_id]
  create_db_subnet_group      = false
  db_subnet_group_name        = local.db_subnet_group_name
  password                    = "ExpenseApp1"
  manage_master_user_password = false
  skip_final_snapshot         = true



  family = "mysql8.0"


  major_engine_version = "8.0"


  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

resource "aws_route53_record" "rds" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 30
  records = [module.db.db_instance_address]

}
