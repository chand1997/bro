module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name                       = "${var.project_name}-${var.environment}-app-alb"
  vpc_id                     = local.vpc_id
  subnets                    = local.private_subnet_ids
  create_security_group      = false
  enable_deletion_protection = false
  internal                   = true
  security_groups            = [local.sg_app_alb_id]
  tags                       = merge({ Name = "${var.project_name}-${var.environment}-app-alb" }, var.common_tags)

}

resource "aws_lb_listener" "app_alb" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "app_alb" {
  zone_id = var.zone_id
  name    = "*.app-dev.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = false
  }
}
