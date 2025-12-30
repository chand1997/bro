resource "aws_instance" "frontend" {
  ami                    = local.ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.sg_frontend_id]
  subnet_id              = local.subnet_id


  tags = {
    Name = local.resource_name
  }
}


resource "null_resource" "frontend" {

  triggers = {
    aws_instance_id = aws_instance.frontend.id
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.frontend.public_ip
  }

  provisioner "file" {
    source      = "frontend.sh"
    destination = "/tmp/frontend.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/frontend.sh",
      "sudo sh /tmp/frontend.sh ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "frontend" {
  instance_id = aws_instance.frontend.id
  state       = "stopped"
  depends_on  = [null_resource.frontend]
}

resource "aws_ami_from_instance" "frontend" {
  name               = local.resource_name
  source_instance_id = aws_instance.frontend.id
  depends_on         = [aws_ec2_instance_state.frontend]
}

resource "null_resource" "terminate_instance" {
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.frontend.id}"
  }
  depends_on = [aws_ami_from_instance.frontend]
}


resource "aws_lb_target_group" "frontend" {
  name                 = local.resource_name
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = local.vpc_id
  deregistration_delay = 300


  health_check {
    healthy_threshold   = 2
    interval            = 10
    unhealthy_threshold = 2
    matcher             = "200-299"
    path                = "/health"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
  }
}

resource "aws_launch_template" "frontend" {
  image_id                             = aws_ami_from_instance.frontend.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3.micro"
  name                                 = local.resource_name
  update_default_version               = true
  vpc_security_group_ids               = [local.sg_frontend_id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = local.resource_name
    }
  }
}


resource "aws_autoscaling_policy" "frontend" {
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  name                   = local.resource_name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_autoscaling_group" "frontend" {
  name                      = local.resource_name
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 180
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = local.subnet_ids
  launch_template {
    id      = aws_launch_template.frontend.id
    version = aws_launch_template.frontend.latest_version
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
  tag {
    key                 = "Name"
    value               = local.resource_name
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }

}

resource "aws_lb_listener_rule" "static" {
  listener_arn = local.listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["expense-${var.environment}.${var.domain_name}"]
    }
  }
}



