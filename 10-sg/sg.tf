module "sg_frontend" {
  source         = "git::https://github.com/DAWS-82S/terraform-aws-securitygroup?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "frontend"
  sg_description = "frontend"
  vpc_id         = local.vpc_id
  common_tags    = var.common_tags
}

module "sg_backend" {
  source         = "git::https://github.com/DAWS-82S/terraform-aws-securitygroup?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "backend"
  sg_description = "backend"
  vpc_id         = local.vpc_id
  common_tags    = var.common_tags
}

module "sg_database" {
  source         = "git::https://github.com/DAWS-82S/terraform-aws-securitygroup?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "database"
  sg_description = "database"
  vpc_id         = local.vpc_id
  common_tags    = var.common_tags
}

module "sg_web_alb" {
  source         = "git::https://github.com/DAWS-82S/terraform-aws-securitygroup?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "web_alb"
  sg_description = "web_alb"
  vpc_id         = local.vpc_id
  common_tags    = var.common_tags
}

module "sg_app_alb" {
  source         = "git::https://github.com/DAWS-82S/terraform-aws-securitygroup?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "app_alb"
  sg_description = "app_alb"
  vpc_id         = local.vpc_id
  common_tags    = var.common_tags
}

module "sg_vpn" {
  source         = "git::https://github.com/DAWS-82S/terraform-aws-securitygroup?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "vpn"
  sg_description = "vpn"
  vpc_id         = local.vpc_id
  common_tags    = var.common_tags
}

module "sg_bastion" {
  source         = "git::https://github.com/DAWS-82S/terraform-aws-securitygroup?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "bastion"
  sg_description = "bastion"
  vpc_id         = local.vpc_id
  common_tags    = var.common_tags
}

resource "aws_security_group_rule" "internet_to_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.sg_bastion.sg_id
}

resource "aws_security_group_rule" "bastion_to_app_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.sg_app_alb.sg_id
  source_security_group_id = module.sg_bastion.sg_id
}

resource "aws_security_group_rule" "bastion_to_backend" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.sg_backend.sg_id
  source_security_group_id = module.sg_bastion.sg_id
}

resource "aws_security_group_rule" "bastion_to_database" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.sg_database.sg_id
  source_security_group_id = module.sg_bastion.sg_id
}

resource "aws_security_group_rule" "vpn_to_app_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.sg_app_alb.sg_id
  source_security_group_id = module.sg_vpn.sg_id
}

resource "aws_security_group_rule" "vpn_to_backend" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.sg_backend.sg_id
  source_security_group_id = module.sg_vpn.sg_id
}

resource "aws_security_group_rule" "vpn_to_database" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.sg_database.sg_id
  source_security_group_id = module.sg_vpn.sg_id
}

resource "aws_security_group_rule" "backend_to_database" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.sg_database.sg_id
  source_security_group_id = module.sg_backend.sg_id
}


resource "aws_security_group_rule" "vpn_to_backend_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.sg_backend.sg_id
  source_security_group_id = module.sg_vpn.sg_id
}

resource "aws_security_group_rule" "bastion_to_backend_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.sg_backend.sg_id
  source_security_group_id = module.sg_bastion.sg_id
}


resource "aws_security_group_rule" "internet_to_web_alb" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.sg_web_alb.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "frontend_to_app_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.sg_app_alb.sg_id
  source_security_group_id = module.sg_frontend.sg_id
}

resource "aws_security_group_rule" "app_alb_to_backend" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.sg_backend.sg_id
  source_security_group_id = module.sg_app_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_to_frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.sg_frontend.sg_id
  source_security_group_id = module.sg_web_alb.sg_id
}

resource "aws_security_group_rule" "internet_to_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.sg_vpn.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "internet_to_vpn_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.sg_vpn.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "internet_to_vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  security_group_id = module.sg_vpn.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "internet_to_vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  security_group_id = module.sg_vpn.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}



resource "aws_security_group_rule" "internet_to_frontend" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.sg_frontend.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "internet_to_database" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = module.sg_database.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}



