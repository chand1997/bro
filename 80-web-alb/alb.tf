module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name                       = "${var.project_name}-${var.environment}-web-alb"
  vpc_id                     = local.vpc_id
  subnets                    = local.public_subnet_ids
  create_security_group      = false
  enable_deletion_protection = false
  internal                   = false
  security_groups            = [local.sg_web_alb_id]
  tags                       = merge({ Name = "${var.project_name}-${var.environment}-web-alb" }, var.common_tags)

}

resource "aws_lb_listener" "web_alb" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = local.cert_arn
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "web_alb" {
  zone_id = var.zone_id
  name    = "${var.project_name}-dev.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = false
  }
}
