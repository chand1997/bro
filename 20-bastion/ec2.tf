resource "aws_instance" "bastion" {
  ami                    = local.ami
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.sg_id]
  subnet_id              = local.public_subnet_id
}

resource "null_resource" "bastion" {
  triggers = {
    aws_instance_id = aws_instance.bastion.id
  }
  connection {
    host     = aws_instance.bastion.public_ip
    user     = "ec2-user"
    password = "DevOps321"
    type     = "ssh"
  }
  provisioner "file" {
    source      = "bastion.sh"
    destination = "/tmp/bastion.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bastion.sh",
      "sudo sh /tmp/bastion.sh"
    ]
  }
}
