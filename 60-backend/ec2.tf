resource "aws_instance" "backend" {
  ami                    = local.ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.sg_backend_id]
  subnet_id              = local.subnet_id

  tags = {
    Name = local.resource_name
  }
}


resource "null_resource" "backend" {

  triggers = {
    aws_instance_id = aws_instance.backend.id
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.backend.public_ip
  }

  provisioner "file" {
    source      = "backend.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo sh /tmp/backend.sh ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "backend" {
  instance_id = aws_instance.backend.id
  state       = "stopped"
  depends_on  = [null_resource.backend]
}

resource "aws_ami_from_instance" "backend" {
  name               = local.resource_name
  source_instance_id = aws_instance.backend.id
  depends_on         = [aws_ec2_instance_state.backend]
}

resource "null_resource" "terminate_instance" {
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.backend.id}"
  }
  depends_on = [aws_ami_from_instance.backend]
}


resource "aws_lb_target_group" "backend" {
  name                 = local.resource_name
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = local.vpc_id
  deregistration_delay = 300


  health_check {
    healthy_threshold   = 2
    interval            = 10
    unhealthy_threshold = 2
    matcher             = "200-299"
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 5
  }
}

resource "aws_launch_template" "backend" {
  image_id                             = aws_ami_from_instance.backend.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3.micro"
  name                                 = local.resource_name
  update_default_version               = true
  vpc_security_group_ids               = [local.sg_backend_id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = local.resource_name
    }
  }
}


resource "aws_autoscaling_policy" "backend" {
  autoscaling_group_name = aws_autoscaling_group.backend.name
  name                   = local.resource_name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_autoscaling_group" "backend" {
  name                      = local.resource_name
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 180
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = local.subnet_ids
  launch_template {
    id      = aws_launch_template.backend.id
    version = aws_launch_template.backend.latest_version
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
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    host_header {
      values = ["backend.app-${var.environment}.${var.domain_name}"]
    }
  }
}



