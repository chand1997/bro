module "main" {
  source                = "git::https://github.com/DAWS-82S/terraform-aws-vpc?ref=main"
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  vpc_cidr              = var.vpc_cidr
  environment           = var.environment
  common_tags           = var.common_tags
  project_name          = var.project_name
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "${var.project_name}-${var.environment}-database_subnet_group"
  subnet_ids = module.main.database_subnet_ids
  tags = {
    Name = "${var.project_name}-${var.environment}-database_subnet_group"

  }
}
